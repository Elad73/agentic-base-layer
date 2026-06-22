---
description: Final gatekeeper for an open PR — security scan, workflow verification, squash-merge, close task, transition to done.
argument-hint: "<#issue | FT-XXX>"
---

# Approve Task

Thin dispatcher. Becomes the **release-gatekeeper** agent.

## Pre-flight guard

```bash
REF="$ARGUMENTS"
```
- Resolve the task backend (Issues vs Kanban).
- Status is `pr-open`.
- A PR (or, in Kanban mode, a merge candidate branch) exists.

## Security scan (MANDATORY gate)

```bash
gh pr diff <PR> | grep -iE "(api[_-]?key|password|secret|token|credential)" && { echo "BLOCKED"; exit 2; }
gh pr diff <PR> --name-only | grep -E "\.(env|sql|backup|pem|key)$" && { echo "BLOCKED"; exit 2; }
gh pr diff <PR> | grep -iE "(eval\(|exec\(|innerHTML)" && echo "REVIEW: dynamic exec / injection sink"
```
Only exit code **2** blocks. A real finding → REJECT, do not merge.

## Assume role: release-gatekeeper

1. Security scan (above).
2. Verify the task actually flowed through mature → build → review → test.
3. Confirm every acceptance criterion is checked.
4. Decide stretch goals: defer (file a follow-up) or complete now.
5. **APPROVED** → squash-merge, delete branch, close task, capture lessons learned, transition to `done`.
6. **REJECTED** → back to `in-progress` with findings.

## Success criteria (merged)

- [ ] Security scan passed.
- [ ] All acceptance criteria checked.
- [ ] PR squash-merged, branch deleted, task closed.
- [ ] Lessons learned captured (feeds the skills loop).
- [ ] Status is `done`.

## Rejection criteria

- [ ] Finding documented; PR has requested changes.
- [ ] Status is `in-progress`.
