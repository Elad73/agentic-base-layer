---
description: End-of-task wrap-up — sanity-check changes, security gate, safe commit, push, open PR, sync the tracker. Backend-agnostic.
argument-hint: "[#issue | FT-XXX]"
---

# Wrap Up

Thin dispatcher. Becomes the **orchestrator** agent to close out the current piece of work safely.

## Phase 1 — Context

```bash
git status
git branch --show-current   # expect feature/<ref>-… or fix/<ref>-…
```
Derive the task ref from `$ARGUMENTS` or the branch name.

## Phase 2 — Security gate (MANDATORY)

```bash
git add -A
git diff --cached --name-only | grep -E "\.env|backup|\.sql|credential|secret|\.pem|\.key$" && { echo "BLOCKED: sensitive file staged"; exit 2; }
git diff --cached | grep -iE "(api[_-]?key|password|secret|token)" && { echo "BLOCKED: potential secret"; exit 2; }
```
Only exit code **2** blocks. A finding → unstage and stop.

## Phase 3 — Commit

```bash
git commit -m "<type>: <description> (<ref>)"
```
Types: `feat|fix|docs|refactor|test|chore`. Commit text must never mention "claude" or "anthropic".

## Phase 4 — Update tracker

- GitHub Issues: `gh issue comment <ref> --body "<work summary + files changed>"`.
- Kanban: update the `FT-XXX`/`BUG-XXX` file (check boxes, Updates Log, Lessons Learned table).

## Phase 5 — Push & PR (never push to main)

```bash
git push -u origin <branch>
gh pr create --title "<type>: <description>" --body "Closes <ref>"
```

## Safety rules

1. Never commit secrets or sensitive files.
2. Never push directly to `main`; always go through a PR.
3. Always record the work on the tracker.

## Success criteria

- [ ] Security gate passed.
- [ ] Clean commit on a feature/fix branch.
- [ ] Tracker updated.
- [ ] PR open and linked.
