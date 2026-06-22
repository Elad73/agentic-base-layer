---
name: pre-ship
description: Mandatory pre-commit quality gates — type-check, lint, test, build — run in order and halting on the first failure. Use this BEFORE committing any change that touches application code, so failures are caught while context is still fresh instead of by CI. Surfaces the failing tool's verbatim error and refuses to proceed until gates pass.
allowed-tools: Bash Read
---

# pre-ship — gatekeeper for code changes

Run this before committing application code. It runs the project's quality gates in sequence and **halts on the first required-gate failure**, so you fix problems before they reach CI or production.

**Usage:** `/pre-ship` (optionally `/pre-ship --quick` to skip the slow test gate during iteration)

## When to invoke

- **Always** before `git commit` if any staged file is application code (source, routes/handlers, schema/migrations, tests).
- **Optional** before `git push` to confirm nothing rotted since the last commit.
- **Required** after fixing a bug: add a regression test for it, and that test must pass here.

## Gates

Run in order. Replace each command with the project's real tooling. A `required` gate failure HALTS; a `soft` gate failure logs a warning and continues.

| # | Gate | Required | Command (genericize) |
|---|------|----------|----------------------|
| G0 | diff inventory | yes | `git diff --cached --name-only` — list changed files, classify app code vs docs |
| G1 | type-check | yes | «PLACEHOLDER: e.g. `tsc --noEmit`, `mypy .`, `go vet ./...`» |
| G2 | lint | soft | «PLACEHOLDER: e.g. `eslint .`, `ruff check`, `golangci-lint run`» |
| G3 | unit tests | yes | «PLACEHOLDER: e.g. `npm test`, `pytest -q`, `go test ./...`» (skipped with `--quick`) |
| G4 | build | yes | «PLACEHOLDER: e.g. `npm run build`, `cargo build --release`» |
| G5 | regression cases | yes | «PLACEHOLDER: project regression suite, if any» |

If a docs-only change is detected at G0 (no app code staged), you may skip G1–G5 and report that gates were not needed.

## Halt rules

- **Required gate fails → STOP.** Do not commit. Surface the failure.
- **Soft gate fails → warn and continue.**
- Bypassing gates (`--no-verify` or skipping this skill) is forbidden unless the user explicitly says to skip pre-ship. It is a deliberate decision, never a default.

## When a gate fails

1. Read the error **verbatim** — pre-ship surfaces the tool's real stderr, not a paraphrase.
2. Fix the **root cause**; do not edit the gate to make it pass.
3. Re-run pre-ship.
4. If a regression case fails, confirm whether the code regressed or the test drifted, and fix the correct one.

## Reporting

On success:
```
pre-ship: N/N gates passed in <ms>ms
  G1 type-check ✓
  G2 lint       ✓
  G3 tests      ✓
  G4 build      ✓
```

On failure:
```
pre-ship: HALTED at <gate name>
  <verbatim error>

Fix the failure above before committing.
```
