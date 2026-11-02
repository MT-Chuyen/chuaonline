# Continuous Agent1 ↔ Agent2 loop

While `agents/loop-state.json` has `"active": true` and `iteration <= maxIterations`:

1. **Agent1 (Director)** — follow `agents/FOCUS.md` + `AGENT1_DIRECTOR.md`. Review latest build; assign the next **GLOBAL** innovation task (not BTS). Set `loop-state.json` → `"next": "agent2"`. If quality is good enough, set `"active": false` and `"next": "stop"`.
2. **Agent2 (Builder)** — implement the newest task file named in `loop-state.json` `lastTask`. Checkbox + Done report + dashboard log. Set `"next": "agent1"`, increment `iteration`.
3. **Orchestrator** — when one finishes, start the other via `./agents/run-pipeline.sh continue`.

**Focus:** global temple / world / explore / social systems. Do not expand BTS/princess unless user overrides FOCUS.md.

Stop conditions: `active: false`, or `iteration > maxIterations`, or Agent1 writes `STOP_LOOP`.
