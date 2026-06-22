---
description: Run the entire task lifecycle autonomously (mature → implement → review → test → approve). Resumable via checkpoints.
argument-hint: "<#issue | FT-XXX>"
---

# Run Task (autonomous)

Thin dispatcher. Becomes the **orchestrator** agent and runs one task from current status all the way to `done`, chaining the phase sub-commands without stopping for input.

## Pre-flight guard

```bash
REF="$ARGUMENTS"
```
- Resolve the task backend (GitHub Issues vs filesystem Kanban — see `/feature`).
- Task exists and is open.
- Not already `done` → if `done`, report and exit 0.
- Check for a resume checkpoint at `.claude/.checkpoints/<ref>.json`.

## Dispatch order

1. `/mature-task <ref>`   → ready
2. `/execute-task <ref>`  → ready-for-review
3. `/review-task <ref>`   → ready-for-testing
4. `/test-task <ref>`     → pr-open
5. `/approve-task <ref>`  → done

Skip any phase whose status precondition is already satisfied (resume).

## Resume support

If a checkpoint exists: read last completed phase, resume from the next one, and aggregate cost.

## Loop guard

If the same phase fails 3+ times → STOP and invoke the **Loop Recovery Protocol** (`.claude/WORKFLOW.md`). Do not keep retrying.

## Success criteria

- [ ] Status is `done`.
- [ ] PR merged (Issues mode) or file in `product/done/` (Kanban mode).
- [ ] Checkpoint cleaned up.
- [ ] Total cost reported.

## Rejection handling

Any phase that rejects sends the task back per its own rules and pauses the chain with a clear next-action recommendation.
