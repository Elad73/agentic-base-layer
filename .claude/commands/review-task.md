---
description: Code-review an implemented task. Spawns domain sub-reviewers in parallel based on what changed. Approves to ready-for-testing or rejects to in-progress.
argument-hint: "<#issue | FT-XXX>"
---

# Review Task

Thin dispatcher. Becomes the **code-reviewer** agent.

## Pre-flight guard

```bash
REF="$ARGUMENTS"
```
- Resolve the task backend (Issues vs Kanban).
- Status is `ready-for-review` or `in-review`.
- A feature branch for `<ref>` exists.

## Sub-reviewer detection (spawn in parallel)

Inspect the diff and dispatch the matching specialist roles:

```bash
CHANGED=$(git diff main...HEAD --name-only)
# DB/schema/migrations          -> database-reviewer
# auth / middleware / api / input handling -> security-reviewer
# UI components / styles / pages -> design-reviewer
```

Map (genericize the globs to «PROJECT-STACK»):

| Changed paths | Sub-reviewer role |
|---------------|-------------------|
| schema / migrations / models | database-reviewer |
| auth / middleware / api / sanitize | security-reviewer |
| components / *.tsx / pages / styles | design-reviewer |

## Assume role: code-reviewer

1. Read the task to understand intent.
2. Review **all** commits on the branch, not just the latest.
3. Spawn the detected sub-reviewers in parallel; collect their findings.
4. Check: correctness, requirements coverage, code quality, performance, security.
5. **APPROVE** → `ready-for-testing`, or **REJECT** → `in-progress`.

## Success criteria (approved)

- [ ] No critical issues from any sub-reviewer.
- [ ] All acceptance criteria verified in code.
- [ ] Status is `ready-for-testing`.

## Rejection criteria

- [ ] Findings documented with `file:line` references.
- [ ] Status is `in-progress` (handed back to developer).
