---
description: Full bug-fix workflow — reproduce, root-cause, minimal fix, regression test, security gate, PR. Backend-agnostic.
argument-hint: "<bug description> | #issue | BUG-XXX"
---

# Bug Fix Workflow

Thin dispatcher. Becomes the **developer** agent (escalating to **code-reviewer** / **security-reviewer** when changes warrant) to fix one bug end-to-end.

## Input

- `$ARGUMENTS` is either a tracker ref (`#123` / `BUG-XXX`) or a free-text bug description.
- If it matches `^#?[0-9]+$` or `^BUG-[0-9]+$` → treat as an existing ticket.
- Otherwise → a new bug to file first (seed from `.claude/templates/BUG-TEMPLATE.md`).

## Task Backend (pluggable)

Detect GitHub Issues vs filesystem Kanban exactly as in `/feature`. Create/locate the bug ticket in whichever the project uses.

## Phase 1 — Validate & reproduce

- Load (or create) the ticket; confirm it is a bug.
- Reproduce via a failing test or documented manual repro. No repro → no fix; report and stop.

## Phase 2 — Root cause

- Trace the code path; identify exact affected files (`file:line`).
- Classify the bug (logic, data/DB, UI, security, integration, …).
- Record the root cause on the ticket.

## Phase 3 — Minimal fix

```bash
git checkout main && git pull
git checkout -b "fix/<ref>-<slug>"
```

Apply the smallest correct fix that follows «PROJECT-CODING-STANDARDS». Do not gold-plate.

## Phase 4 — Regression test

- Add a test that fails before the fix and passes after.
- Confirm no existing tests break.

## Phase 5 — Verify

```bash
«PROJECT-VERIFY-CMD»   # e.g. npm run type-check && npm run lint && npm test
```

## Phase 6 — Review (only if non-trivial)

For medium+ changes, dispatch `/review-task <ref>`.

## Phase 7 — Security gate (MANDATORY)

```bash
git diff --cached | grep -iE "(api[_-]?key|password|secret|token)" && { echo "BLOCKED: potential secret"; exit 2; }
git diff --cached --name-only | grep -E "\.(env|sql|backup|pem|key)$" && { echo "BLOCKED: sensitive file"; exit 2; }
```
Only hook exit code **2** blocks the action. A finding here means STOP, not continue.

## Phase 8 — PR

```bash
git push -u origin "fix/<ref>-<slug>"
gh pr create --title "fix: <title> (<ref>)" --body "Closes <ref>"
```
Commit/PR text must never mention "claude" or "anthropic".

## Success criteria

- [ ] Bug reproduced, root cause documented.
- [ ] Minimal fix + regression test, full verify green.
- [ ] Security gate passed.
- [ ] PR open and linked to the ticket.
