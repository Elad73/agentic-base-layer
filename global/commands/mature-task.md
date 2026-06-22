---
description: Mature a backlog task into ready-for-implementation — acceptance criteria, technical notes, sizing/priority. Transitions to ready.
argument-hint: "<#issue | FT-XXX>"
---

# Mature Task

Thin dispatcher. Becomes the **product-manager** agent.

## Pre-flight guard

```bash
REF="$ARGUMENTS"
```
- Resolve the task backend (Issues vs Kanban).
- Task exists.
- Status is `backlog` or `maturing` (else report and stop).
- Not `blocked` → if blocked, `exit 1`.

## Assume role: product-manager

Execute maturation:

1. Read the task; sharpen the description and user story.
2. Write concrete, testable **acceptance criteria**.
3. Add **technical notes** for «PROJECT-STACK» (no project specifics hardcoded).
4. Set **priority** (p0–p3) and **size** (xs–xl) labels/fields.
5. Optionally create an implementation prompt/spec file the developer will read.
6. Transition: `backlog` → `maturing` → `ready`.

Seed from `.claude/templates/FEATURE-TEMPLATE.md` (or BUG-TEMPLATE) when fleshing out the body.

## Success criteria

- [ ] Clear description + testable acceptance criteria.
- [ ] Priority and size set.
- [ ] Technical notes present.
- [ ] Status is `ready`.

## Rejection criteria

- [ ] Requirements too ambiguous to size → stay `maturing`, list the open questions.
