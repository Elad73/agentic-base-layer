---
description: Run the test suite against a reviewed branch and open a PR. Green → pr-open; red → back to in-progress.
argument-hint: "<#issue | FT-XXX>"
---

# Test Task

Thin dispatcher. Becomes the **test-engineer** agent.

## Pre-flight guard

```bash
REF="$ARGUMENTS"
```
- Resolve the task backend (Issues vs Kanban).
- Status is `ready-for-testing` or `testing`.

## Assume role: test-engineer

1. Check out the feature branch.
2. Run unit/integration tests with coverage.
3. Run lint and type-check.
4. Exercise edge cases and error paths for the changed surface.
5. Confirm no regressions in related features.
6. ALL PASS → open PR, transition `testing` → `pr-open`.
7. ANY FAIL → transition back to `in-progress` with failure details.

## Coverage policy («PROJECT-COVERAGE»)

| Area | Threshold |
|------|-----------|
| Overall | «e.g. 80%» |
| Critical paths (auth, money, parsing) | 100% happy + error |

## PR body

```
## Summary
Implements <ref>

## Test results
| Suite | Status | Coverage |
|-------|--------|----------|
| Unit  | Passed | <cov>%   |
| Lint  | Passed | —        |
| Types | Passed | —        |

Closes <ref>
```
No "claude"/"anthropic" anywhere in PR text.

## Success criteria

- [ ] All tests pass; coverage meets threshold.
- [ ] PR created and linked.
- [ ] Status is `pr-open`.

## Rejection criteria

- [ ] Failing tests listed with names/messages.
- [ ] Status is `in-progress`.
