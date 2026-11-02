#!/usr/bin/env python3
"""Scan agents/tasks + activity log → agents/status.json for the dashboard."""
from __future__ import annotations

import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent
TASK_DIR = ROOT / "tasks"
STATUS_PATH = ROOT / "status.json"
ACTIVITY_PATH = ROOT / "activity.jsonl"
REPO = ROOT.parent


def now_iso() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")


def parse_task(path: Path) -> dict:
    text = path.read_text(encoding="utf-8", errors="replace")
    title_m = re.search(r"^#\s+(.+)$", text, re.M)
    wish_m = re.search(
        r"##\s+Wish being fulfilled\s*\n+(.+?)(?=\n##|\Z)", text, re.S | re.I
    )
    checks = re.findall(r"- \[([ xX])\]\s+(.+)", text)
    items = [
        {"done": mark.lower() == "x", "text": body.strip()} for mark, body in checks
    ]
    done_n = sum(1 for i in items if i["done"])
    has_done_report = bool(re.search(r"^##\s+Done report\b", text, re.M | re.I))
    done_body = ""
    if has_done_report:
        dm = re.search(r"##\s+Done report\s*\n+(.*)\Z", text, re.S | re.I)
        done_body = (dm.group(1).strip() if dm else "")[:2000]

    if has_done_report and items and done_n == len(items):
        phase = "review"
    elif has_done_report:
        phase = "review"
    elif done_n > 0:
        phase = "building"
    elif wish_m and "TODO Agent 1" not in (wish_m.group(1) if wish_m else ""):
        phase = "assigned"
    else:
        phase = "planning"

    return {
        "file": str(path.relative_to(REPO)),
        "name": path.name,
        "title": (title_m.group(1).strip() if title_m else path.stem),
        "wish": (wish_m.group(1).strip() if wish_m else ""),
        "phase": phase,
        "checklist": items,
        "done": done_n,
        "total": len(items),
        "progress": round(100 * done_n / len(items), 1) if items else 0.0,
        "hasDoneReport": has_done_report,
        "doneReport": done_body,
        "mtime": datetime.fromtimestamp(path.stat().st_mtime).astimezone().isoformat(
            timespec="seconds"
        ),
    }


def git_hint() -> dict:
    out = {"indexDirty": False, "indexMtime": None, "diffStat": ""}
    index = REPO / "index.html"
    if index.exists():
        out["indexMtime"] = datetime.fromtimestamp(index.stat().st_mtime).astimezone().isoformat(
            timespec="seconds"
        )
    try:
        st = subprocess.run(
            ["git", "status", "--porcelain", "--", "index.html"],
            cwd=REPO,
            capture_output=True,
            text=True,
            timeout=5,
        )
        out["indexDirty"] = bool(st.stdout.strip())
        diff = subprocess.run(
            ["git", "diff", "--stat", "--", "index.html"],
            cwd=REPO,
            capture_output=True,
            text=True,
            timeout=5,
        )
        out["diffStat"] = diff.stdout.strip()
    except Exception:
        pass
    return out


def load_activity(limit: int = 80) -> list:
    if not ACTIVITY_PATH.exists():
        return []
    lines = ACTIVITY_PATH.read_text(encoding="utf-8", errors="replace").splitlines()
    events = []
    for line in lines[-limit:]:
        line = line.strip()
        if not line:
            continue
        try:
            events.append(json.loads(line))
        except json.JSONDecodeError:
            continue
    return list(reversed(events))


def infer_agents(task: dict | None, activity: list) -> dict:
    phase = task["phase"] if task else "idle"
    a1 = {
        "id": "agent1",
        "name": "Agent 1 — Director",
        "role": "Assign · Review · Improve",
        "status": "idle",
        "detail": "Waiting for a wish / task",
    }
    a2 = {
        "id": "agent2",
        "name": "Agent 2 — Builder",
        "role": "Implement task in index.html",
        "status": "idle",
        "detail": "No assignment yet",
    }

    if phase == "planning":
        a1.update(status="working", detail="Identifying wishes & writing the task brief")
        a2.update(status="waiting", detail="Waiting for Agent 1 assignment")
    elif phase == "assigned":
        a1.update(status="done", detail="Task assigned — waiting for build")
        a2.update(status="ready", detail="Ready to implement the task")
    elif phase == "building":
        a1.update(status="watching", detail="Watching checklist progress")
        a2.update(
            status="working",
            detail=f"Building… {task['done']}/{task['total']} checklist items",
        )
    elif phase == "review":
        a1.update(status="working", detail="Reviewing Done report & improving fun")
        a2.update(status="done", detail="Build pass finished — awaiting review")

    # Latest activity overrides soft status labels
    for ev in activity[:5]:
        who = (ev.get("agent") or "").lower()
        msg = ev.get("message") or ""
        st = ev.get("status")
        if who in ("agent1", "a1", "1") and st:
            a1["status"] = st
            if msg:
                a1["detail"] = msg
            break
    for ev in activity[:5]:
        who = (ev.get("agent") or "").lower()
        msg = ev.get("message") or ""
        st = ev.get("status")
        if who in ("agent2", "a2", "2") and st:
            a2["status"] = st
            if msg:
                a2["detail"] = msg
            break

    return {"agent1": a1, "agent2": a2, "pipelinePhase": phase if task else "idle"}


def build() -> dict:
    TASK_DIR.mkdir(parents=True, exist_ok=True)
    tasks = sorted(TASK_DIR.glob("TASK-*.md"), key=lambda p: p.stat().st_mtime, reverse=True)
    parsed = [parse_task(p) for p in tasks]
    current = parsed[0] if parsed else None
    activity = load_activity()
    agents = infer_agents(current, activity)
    return {
        "updatedAt": now_iso(),
        "pipeline": agents,
        "currentTask": current,
        "tasks": parsed,
        "git": git_hint(),
        "activity": activity,
    }


def write_status(data: dict | None = None) -> dict:
    data = data or build()
    STATUS_PATH.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return data


def append_activity(agent: str, message: str, status: str | None = None) -> dict:
    event = {
        "ts": now_iso(),
        "agent": agent,
        "message": message,
        "status": status,
    }
    with ACTIVITY_PATH.open("a", encoding="utf-8") as f:
        f.write(json.dumps(event, ensure_ascii=False) + "\n")
    return write_status()


if __name__ == "__main__":
    import sys

    if len(sys.argv) >= 2 and sys.argv[1] == "log":
        # sync_status.py log agent1 "message" [status]
        agent = sys.argv[2] if len(sys.argv) > 2 else "system"
        message = sys.argv[3] if len(sys.argv) > 3 else ""
        status = sys.argv[4] if len(sys.argv) > 4 else None
        data = append_activity(agent, message, status)
    else:
        data = write_status()
    print(json.dumps({"ok": True, "updatedAt": data["updatedAt"], "phase": data["pipeline"]["pipelinePhase"]}))
