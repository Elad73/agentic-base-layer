---
description: Full-cycle feature development orchestrator. Creates/locates a task, then sequences agents through plan → implement → review → test → approve. Backend-agnostic.
argument-hint: "<feature description> [#issue | FT-XXX]"
---

# Feature Development Orchestrator

Thin dispatcher. Becomes the **orchestrator** agent and drives one feature through the full lifecycle defined in `.claude/WORKFLOW.md`.

## Input

- Feature description and/or an existing task ref: `$ARGUMENTS`
- A ref looks like `#123` / `123` (GitHub Issues mode) or `FT-XXX` (filesystem Kanban mode).

## Task Backend (pluggable — detect, do not assume)

| Mode | Source of truth | Detect by |
|------|-----------------|-----------|
| **GitHub Issues** | `gh issue` + status labels | repo has issues + `gh auth status` ok |
| **Filesystem Kanban** | `.claude/product/{todo,in-progress,done}/` with `FT-XXX`/`BUG-XXX` files | that directory tree exists |

Pick the mode the project actually uses. All phase commands below honor the same mode.

## Phase 0: Task Setup

- **If a ref is provided:** load it and confirm it is open/not done.
  - GitHub: `gh issue view <N> --json number,title,state,labels`
  - Kanban: locate `FT-XXX.md` under `product/{todo,in-progress}/`
- **If only a description is provided:** create a new task seeded from `.claude/templates/FEATURE-TEMPLATE.md` at status `backlog`.
  - GitHub: `gh issue create --title "feat: …" --body "<template>" --label "status:backlog"`
  - Kanban: write `product/todo/FT-XXX.md` from the template.

## Phases 1–5: Sequenced dispatch

Run these THIN sub-commands in order; each advances status and hands off via the 4-field handoff in `.claude/CONTEXT-PASSING.md`.

| Phase | Command | Role | Status flow |
|-------|---------|------|-------------|
| 1 | `/mature-task <ref>` | product-manager | backlog → maturing → ready |
| 2 | `/execute-task <ref>` | developer | ready → in-progress → ready-for-review |
| 3 | `/review-task <ref>` | code-reviewer (+ domain sub-reviewers) | ready-for-review → in-review → ready-for-testing |
| 4 | `/test-task <ref>` | test-engineer | ready-for-testing → testing → pr-open |
| 5 | `/approve-task <ref>` | release-gatekeeper | pr-open → done |

Each phase auto-triggers the next on success.

## Success criteria

- [ ] Task reaches `done` with PR merged (or, in pure-Kanban mode, file in `product/done/`).
- [ ] Every phase recorded its handoff and status transition.

## Rejection / failure handling

| Failure | Action |
|---------|--------|
| Maturation incomplete | stay `maturing`, report blockers |
| Build fails verification | stay `in-progress`, report errors |
| Review rejects | back to `in-progress` for fixes |
| Tests red | back to `in-progress` |
| Same failure 3+ times | invoke **Loop Recovery Protocol** (see WORKFLOW.md) |
