---
description: Quick context sync at session start — status, branch, in-progress work, and one proposed next step. Backend-agnostic.
---

# Wake Up

Thin dispatcher. Becomes the **orchestrator** agent for a fast situational read. Run the gathering steps in parallel.

## Gather (parallel)

```bash
# Git
git log --oneline -5 --format="%h %s (%ar)"
git branch --show-current && git status --short

# Task backend — GitHub Issues mode
gh issue list --label "status:in-progress" --json number,title --limit 3 2>/dev/null
gh issue list --label "status:ready"       --json number,title --limit 3 2>/dev/null
gh issue list --label "status:blocked"     --json number,title --limit 3 2>/dev/null
gh pr list --state open --json number,title,headRefName --limit 3 2>/dev/null

# Task backend — filesystem Kanban mode
ls .claude/product/in-progress/ 2>/dev/null
ls .claude/product/todo/ 2>/dev/null
```

Use whichever backend the project has. Also read «PROJECT-STATUS-FILE» (e.g. `docs/STATUS.md`) if present.

## Output

A compact summary: project name, branch, clean/dirty, in-progress tasks, ready tasks, blocked tasks, open PRs.

## Next-step logic (propose exactly one)

- Uncommitted changes → suggest commit or stash.
- In-progress task → suggest continuing it (`/execute-task <ref>`).
- Ready task → suggest `/execute-task <ref>`.
- Open PR → suggest `/approve-task <ref>`.
- Blocked task → investigate the blocker.
- All clear → suggest `/sync-issues` or creating a new task.

## Success criteria

- [ ] Current state summarized from the real backend.
- [ ] One concrete next command proposed.
