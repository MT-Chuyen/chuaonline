#!/usr/bin/env bash
# Two-agent fantasy pipeline for Lên Chùa Cầu An
# Usage:
#   ./agents/run-pipeline.sh              # help
#   ./agents/run-pipeline.sh new "title"  # create empty task stub
#   ./agents/run-pipeline.sh latest       # print latest task path
#   ./agents/run-pipeline.sh prompts      # copy-paste prompts
#   ./agents/run-pipeline.sh sync         # refresh status.json for dashboard
#   ./agents/run-pipeline.sh log agent1 "Wrote task" working
#   ./agents/run-pipeline.sh serve        # open live dashboard (port 8765)
#   ./agents/run-pipeline.sh loop-status  # show continuous loop state
#   ./agents/run-pipeline.sh loop-start [max]  # arm Agent1↔Agent2 loop
#   ./agents/run-pipeline.sh loop-stop    # stop the loop
#   ./agents/run-pipeline.sh continue     # print who should run next + prompt
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TASK_DIR="$ROOT/agents/tasks"
AGENTS="$ROOT/agents"
LOOP_STATE="$AGENTS/loop-state.json"
mkdir -p "$TASK_DIR"

cmd="${1:-help}"

sync_status() {
  python3 "$AGENTS/sync_status.py"
}

loop_read() {
  python3 - "$LOOP_STATE" <<'PY'
import json, sys
from pathlib import Path
p = Path(sys.argv[1])
if not p.exists():
    print("missing")
    raise SystemExit(1)
print(json.dumps(json.loads(p.read_text()), ensure_ascii=False))
PY
}

case "$cmd" in
  new)
    title="${2:-fantasy-task}"
    slug="$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '-' | sed 's/-$//')"
    stamp="$(date +%Y%m%d-%H%M)"
    file="$TASK_DIR/TASK-${stamp}-${slug}.md"
    cat > "$file" <<EOF
# $title

## Wish being fulfilled
(TODO Agent 1)

## Player fantasy loop (addictive)
1. Discover → 2. Interact → 3. Reward → 4. Escalate → 5. Show off

## Must implement (in index.html)
- [ ] ...

## Acceptance criteria
- ...

## Out of scope
- ...
EOF
    python3 "$AGENTS/sync_status.py" log agent1 "Created task: $title" working >/dev/null
    echo "Created: $file"
    echo "Next: open Cursor Agent chat as Agent1 with @agents/AGENT1_DIRECTOR.md and fill this task."
    echo "Dashboard: ./agents/run-pipeline.sh serve"
    ;;
  latest)
    latest="$(ls -1t "$TASK_DIR"/TASK-*.md 2>/dev/null | head -1 || true)"
    if [[ -z "${latest:-}" ]]; then
      echo "No tasks yet. Run: ./agents/run-pipeline.sh new \"my wish\""
      exit 1
    fi
    echo "$latest"
    ;;
  sync)
    sync_status
    ;;
  log)
    # ./agents/run-pipeline.sh log agent1 "message" [status]
    agent="${2:-system}"
    message="${3:-}"
    status="${4:-}"
    if [[ -z "$message" ]]; then
      echo "Usage: ./agents/run-pipeline.sh log agent1|agent2 \"message\" [working|done|ready|waiting]"
      exit 1
    fi
    python3 "$AGENTS/sync_status.py" log "$agent" "$message" "$status"
    ;;
  serve)
    sync_status >/dev/null
    port="${2:-8765}"
    echo "Opening dashboard on http://127.0.0.1:${port}/dashboard.html"
    # try to open browser if available
    if command -v xdg-open >/dev/null 2>&1; then
      (sleep 0.4; xdg-open "http://127.0.0.1:${port}/dashboard.html" >/dev/null 2>&1) &
    fi
    exec python3 "$AGENTS/serve_dashboard.py" --port "$port"
    ;;
  loop-status)
    if [[ ! -f "$LOOP_STATE" ]]; then
      echo "No loop-state.json — run: ./agents/run-pipeline.sh loop-start"
      exit 1
    fi
    python3 - "$LOOP_STATE" <<'PY'
import json, sys
d = json.load(open(sys.argv[1]))
print(f"active={d.get('active')}  iteration={d.get('iteration')}/{d.get('maxIterations')}  next={d.get('next')}  last={d.get('lastAgent')}")
print(f"task={d.get('lastTask')}")
print(f"goal={d.get('goal')}")
PY
    ;;
  loop-start)
    max="${2:-4}"
    latest="$(ls -1t "$TASK_DIR"/TASK-*.md 2>/dev/null | head -1 || true)"
    python3 - "$LOOP_STATE" "$max" "${latest:-}" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
path, max_i, latest = Path(sys.argv[1]), int(sys.argv[2]), sys.argv[3]
root = path.parent.parent
rel = str(Path(latest).relative_to(root)) if latest else None
data = {
  "active": True,
  "iteration": 1,
  "maxIterations": max_i,
  "next": "agent1",
  "lastAgent": "agent2",
  "lastTask": rel,
  "goal": "Continuous wish-fulfillment loop: Agent1 review/improve → Agent2 build → repeat",
  "updatedAt": datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds"),
}
path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")
print(json.dumps({"ok": True, **{k: data[k] for k in ("active","iteration","maxIterations","next")}}))
PY
    python3 "$AGENTS/sync_status.py" log system "Loop armed — next: agent1" working >/dev/null
    echo "Loop armed. Orchestrator should start Agent1, then keep alternating."
    echo "See: ./agents/run-pipeline.sh continue"
    ;;
  loop-stop)
    python3 - "$LOOP_STATE" <<'PY'
import json, sys
from datetime import datetime, timezone
from pathlib import Path
path = Path(sys.argv[1])
d = json.loads(path.read_text()) if path.exists() else {}
d["active"] = False
d["next"] = "stop"
d["updatedAt"] = datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
print("Loop stopped.")
PY
    python3 "$AGENTS/sync_status.py" log system "Loop stopped" idle >/dev/null
    ;;
  continue)
    # Prints who runs next + a ready-to-paste / ready-to-spawn prompt body
    python3 - "$LOOP_STATE" "$ROOT" "$TASK_DIR" <<'PY'
import json, sys
from pathlib import Path
state_path, root, task_dir = map(Path, sys.argv[1:4])
if not state_path.exists():
    print("NO_LOOP")
    raise SystemExit(1)
d = json.loads(state_path.read_text())
if not d.get("active") or d.get("next") == "stop":
    print("STOPPED")
    print(json.dumps(d, ensure_ascii=False))
    raise SystemExit(0)
it, mx = int(d.get("iteration", 1)), int(d.get("maxIterations", 4))
if it > mx:
    print("MAX_REACHED")
    raise SystemExit(0)
tasks = sorted(task_dir.glob("TASK-*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
latest = str(tasks[0].relative_to(root)) if tasks else d.get("lastTask")
nxt = d.get("next")
print(f"NEXT={nxt}")
print(f"ITERATION={it}/{mx}")
print(f"TASK={latest}")
print("---PROMPT---")
if nxt == "agent1":
    print(f"""You are Agent 1 (Director). Follow {root}/agents/FOCUS.md, {root}/agents/AGENT1_DIRECTOR.md, {root}/agents/LOOP.md
Repo: {root}
Latest task/build: @{latest} and @index.html
Loop state: @agents/loop-state.json (iteration {it}/{mx})

1) Review Agent 2's work for GLOBAL fun / addiction (temple-wide systems).
2) Apply quick polish yourself in index.html if small.
3) Write a NEW follow-up task for the NEXT global innovation (progression, world mood, explore, social, fortune, NPCs). Do NOT expand BTS/princess.
4) Update loop-state.json: next=agent2, lastAgent=agent1, lastTask=<new task path>, focus=global, updatedAt=now.
   If good enough to stop: active=false, next=stop.
5) Log: ./agents/run-pipeline.sh log agent1 "..." working|done""")
elif nxt == "agent2":
    print(f"""You are Agent 2 (Builder). Follow {root}/agents/AGENT2_BUILDER.md and {root}/agents/LOOP.md
Implement @{latest} in @index.html.
Mark checkboxes, append Done report, log dashboard.
Update loop-state.json: next=agent1, lastAgent=agent2, lastTask={latest}, iteration={it}+1 (increment), updatedAt=now.
Log: ./agents/run-pipeline.sh log agent2 "..." working|done""")
else:
    print(f"Unknown next={nxt}")
PY
    ;;
  prompts)
    echo "===== AGENT 1 (paste into a Cursor Agent chat) ====="
    cat <<'EOF'
You are Agent 1. Follow @agents/AGENT1_DIRECTOR.md
Game: Lên Chùa Cầu An, main file @index.html
Follow @agents/FOCUS.md and @agents/AGENT1_DIRECTOR.md
1) Invent GLOBAL temple features (progression, world mood, explore, social, fortune) — NOT BTS/princess.
2) Assign work by writing a new task in agents/tasks/.
3) Log: ./agents/run-pipeline.sh log agent1 "your note" working|done
Do NOT expand BTS unless the user asks.
EOF
    echo
    echo "===== AGENT 2 (paste into a SECOND Cursor Agent chat) ====="
    LATEST="$(ls -1t "$TASK_DIR"/TASK-*.md 2>/dev/null | head -1)"
    cat <<EOF
You are Agent 2. Follow @agents/AGENT2_BUILDER.md
Implement the task file: @${LATEST#$ROOT/}
Work in @index.html.
Log progress for the dashboard:
  ./agents/run-pipeline.sh log agent2 "Starting build" working
  After each checklist item: mark - [x] in the task file, then
  ./agents/run-pipeline.sh log agent2 "Finished: <item>" working
When finished, append a Done report to the task file and:
  ./agents/run-pipeline.sh log agent2 "Build complete — ready for review" done
EOF
    echo
    echo "===== AGENT 1 REVIEW (after Agent 2 finishes) ====="
    cat <<'EOF'
You are Agent 1 again. Follow @agents/AGENT1_DIRECTOR.md
Review Agent 2's changes in @index.html against the task file.
Log: ./agents/run-pipeline.sh log agent1 "Reviewing build" working
Improve fun / addiction / wish-fulfillment. Fix weak spots. Keep mobile + FPS working.
When happy: ./agents/run-pipeline.sh log agent1 "Review approved" done
EOF
    ;;
  help|*)
    cat <<'EOF'
Lên Chùa Cầu An — 2-agent pipeline + live dashboard

DASHBOARD (see both agents' progress)
  ./agents/run-pipeline.sh serve
  → http://127.0.0.1:8765/dashboard.html
  Auto-reads task checkboxes, Done report, git dirty state, activity log.

EASIEST (Cursor UI)
  1. Chat A = Agent1  → paste prompts from:  ./agents/run-pipeline.sh prompts
  2. Chat B = Agent2  → paste Agent2 prompt
  3. Keep dashboard open in browser while they work
  4. Chat A again for REVIEW

PROGRESS SIGNALS THE UI READS
  • Checkbox - [x] in agents/tasks/TASK-*.md
  • ## Done report section
  • ./agents/run-pipeline.sh log agent1|agent2 "message" [status]
  • Uncommitted changes to index.html

CONTINUOUS LOOP (Agent1 ↔ Agent2)
  ./agents/run-pipeline.sh loop-start 4     # arm loop (max 4 rounds)
  ./agents/run-pipeline.sh continue         # who runs next + prompt
  ./agents/run-pipeline.sh loop-status
  ./agents/run-pipeline.sh loop-stop
  Orchestrator (Cursor parent chat) must spawn the NEXT agent each time one finishes.

COMMANDS
  ./agents/run-pipeline.sh serve            # live UI
  ./agents/run-pipeline.sh sync             # refresh status.json
  ./agents/run-pipeline.sh log agent2 "…"   # append activity
  ./agents/run-pipeline.sh prompts
  ./agents/run-pipeline.sh latest
  ./agents/run-pipeline.sh new "my wish"
EOF
    ;;
esac
