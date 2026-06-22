---
name: wake-up
description: Session-start context sync. Reads project STATUS, git state, and runs a quick health check, then emits a short (<15 line) announcement of where things stand and the single best next step. Use this at the beginning of a working session to re-establish context fast. Does NOT re-read CLAUDE.md (already in the system prompt). Read-only and fast.
---

# wake-up — Session Context Establishment

Re-establish context at the start of a session. Be fast and concise.

**Usage:** `/wake-up`

---

## Step 1: Read Core State

Read in parallel; focus on key sections only, not whole files.

1. **STATUS.md** (`docs/STATUS.md` or `docs/status/STATUS.md`) — extract:
   - "Recently Completed" (latest entry)
   - "Current Sprint Goals" / current phase
   - Any blockers or decisions pending

2. **Git state**
```bash
git status --porcelain
git log --oneline -5
git branch --show-current
```

## Step 2: Quick Health Check

```bash
# Is a dev server already up? («PLACEHOLDER: replace 3000 with project port»)
lsof -i :3000 2>/dev/null | head -2

# Count stale merged branches (suggests /cleanup)
git branch --merged main 2>/dev/null | grep -vE "main|master" | grep -v "^\*" | wc -l
```

## Step 3: Announce (keep under 15 lines)

```
SESSION WAKE-UP

Branch:  [current branch]   ([clean | N uncommitted])
Updated: [STATUS.md last-updated]
Phase:   [current phase]
Recent:  [last 1-2 completed items]
Server:  [running on :PORT | not detected]

NEXT STEP: [the single most logical next action from STATUS.md]
```

If there are uncommitted changes, call them out. If stale branches exist, suggest `/cleanup`.

## Important Notes

- **Do NOT re-read CLAUDE.md** — that context is already in the system prompt.
- Do not read a long STATUS.md in full; pull only the key sections.
- Read-only: make no edits, no commits.
- Propose exactly ONE next step, not a menu.
