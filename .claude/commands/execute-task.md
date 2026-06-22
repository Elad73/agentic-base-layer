---
description: Implement a ready task — feature branch, all acceptance criteria, tests, project verification. Transitions to ready-for-review. Resumable.
argument-hint: "<#issue | FT-XXX>"
---

# Execute Task

Thin dispatcher. Becomes the **developer** agent.

## Pre-flight guard

```bash
REF="$ARGUMENTS"
```
- Resolve the task backend (Issues vs Kanban).
- Task exists and is open.
- Status is `ready` or `in-progress` (resume allowed).
- Task has acceptance criteria (else send back to `/mature-task`).
- Not `blocked` → if blocked, `exit 1`.

## Assume role: developer

1. Read the task + any linked prompt/spec.
2. Create branch `feature/<ref>-<slug>` (resume an existing one if present).
3. Implement **all** acceptance criteria — nothing more, nothing less.
4. Write tests alongside the code.
5. Run «PROJECT-VERIFY-CMD» (type-check + lint + tests) until green.
6. Push the branch.
7. Transition: `ready` → `in-progress` → `ready-for-review`.

## Loop guard

Same failure 3+ times → **Loop Recovery Protocol** (`.claude/WORKFLOW.md`).

## Success criteria

- [ ] Every acceptance criterion satisfied and checked off.
- [ ] Project verification green.
- [ ] Branch pushed.
- [ ] Status is `ready-for-review`.

## Rejection criteria

- [ ] Cannot satisfy a criterion → stay `in-progress`, document the blocker.
