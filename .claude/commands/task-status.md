---
description: Detailed dashboard of all tasks with priorities, sizes, ages, anomalies, and recently closed work. Backend-agnostic.
---

# Task Status

Thin dispatcher. Becomes the **orchestrator** agent and renders a full task dashboard from whichever backend the project uses.

## Gather

**GitHub Issues mode**
```bash
gh issue list --state open   --json number,title,labels,assignees,createdAt,updatedAt --limit 100
gh issue list --state closed --json number,title,labels,closedAt --limit 20
```

**Filesystem Kanban mode**
```bash
ls .claude/product/todo/ .claude/product/in-progress/ .claude/product/done/ 2>/dev/null
# read FT-XXX/BUG-XXX front-matter for Status / Priority / Created
```

## Group & display

Group by status across the full lifecycle (see `.claude/WORKFLOW.md`), then by priority and size.

| Symbol | Meaning |
|--------|---------|
| [P0]–[P3] | priority p0 (critical) → p3 (low) |
| [XS]–[XL] | size xs → xl |

## Anomaly detection

1. Tasks with no status.
2. Tasks with multiple/conflicting statuses.
3. Stale tasks (same status > 7 days).
4. Circular blocks.
5. Orphaned branches (branch with no matching open task).

## Success criteria

- [ ] Every open task shown under its status with priority/size/age.
- [ ] Recently closed work listed.
- [ ] Anomalies flagged with a suggested fix.
