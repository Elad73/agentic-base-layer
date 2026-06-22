---
description: Show all open tasks grouped by status, surface anomalies, and suggest the next actionable command per group. Backend-agnostic.
---

# Sync Issues

Thin dispatcher. Becomes the **orchestrator** agent and produces a compact, action-oriented status board. (Lighter than `/task-status`.)

## Gather

**GitHub Issues mode**
```bash
gh auth status
gh issue list --state open --json number,title,labels,assignees --limit 100
```

**Filesystem Kanban mode**
```bash
ls .claude/product/{todo,in-progress,done}/ 2>/dev/null
```

## Group by status

```
TASK STATUS BOARD
─────────────────────────────
BACKLOG        → /mature-task <ref>
READY          → /execute-task <ref>
IN-PROGRESS    → continue /execute-task <ref>
READY-FOR-REVIEW   → /review-task <ref>
READY-FOR-TESTING  → /test-task <ref>
PR-OPEN        → /approve-task <ref>
BLOCKED        → investigate blocker
```

## Next-action mapping

| Status | Suggested command |
|--------|-------------------|
| backlog | `/mature-task <ref>` |
| ready | `/execute-task <ref>` |
| ready-for-review | `/review-task <ref>` |
| ready-for-testing | `/test-task <ref>` |
| pr-open | `/approve-task <ref>` |

## Anomalies to report

- Tasks with no status / multiple statuses.
- Blocked tasks and what blocks them.

## Success criteria

- [ ] All open tasks grouped by status.
- [ ] One suggested command per actionable group.
- [ ] Anomalies surfaced.
