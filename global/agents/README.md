# Agent roster

Subagents are flat `.md` files; each runs in its own context window with a custom
prompt and scoped tools. An agent costs nothing until it's invoked, so the bar isn't
"applies to every project" — it's "a clean, reusable role that behaves the same way
wherever it's relevant." Four tiers:

## Universal (fire on almost any project)
- **code-reviewer** *(sonnet)* — correctness/quality/security review of a diff; delegates to specialists.
- **security-reviewer** — OWASP/secrets/auth review; read-only brief + history-scrub recovery.
- **debugger** — systematic root-cause investigation; proves the cause before a minimal fix.
- *(planner: use Claude Code's built-in `Plan` agent.)*
- **test-engineer** — coverage, gaps, opens the PR on green.

## SDLC spine (drive the structured `/feature` → `/run-task` lifecycle)
- **orchestrator** — conducts all phases with checkpoints/retries.
- **product-manager** — matures backlog items into ready tasks (AC, sizing).
- **developer** — implements a ready task on a branch, with tests.
- **release-gatekeeper** — final security scan + merge/close.

## On-demand domain (spawned by `/review` only when relevant changes are detected)
- **database-reviewer** — schema/query/migration review (read-only).
- **design-reviewer** — UI/UX/a11y review (read-only).

## Conventions
- **Read-only reviewers** (`code-`, `security-`, `database-`, `design-reviewer`) never modify code or change task status; they return IDed findings (`CR-001`, …) with severity + `file:line` + fix.
- **Least privilege:** reviewers get `Read, Grep, Glob` (+ web/Bash only where investigation needs it); implementers get `Edit, Write, Bash`.
- To author a new agent: use the **`/create-subagent`** command (the `create-subagents` skill).
