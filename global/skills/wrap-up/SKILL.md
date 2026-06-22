---
name: wrap-up
description: Session-end safe closeout. Updates STATUS, verifies you are on a feature branch (never main), security-greps the diff for secrets, makes a conventional commit (no AI-tool mentions), then asks for approval before pushing and opening a PR. Use this to properly close a development session. Side-effecting and gated on explicit user approval; run explicitly.
disable-model-invocation: true
---

# wrap-up — Session Completion Workflow

Close a session cleanly: status → branch check → security grep → commit → approval → push + PR.

**Usage:** `/wrap-up`

---

## Step 1: Update STATUS

Update STATUS.md (`docs/STATUS.md` or `docs/status/STATUS.md`):
- Mark completed tasks
- Refresh current goals / phase
- Add to "Recently Completed"
- Bump the last-updated date

## Step 2: Git State + Branch Guard

```bash
git status
git branch --show-current
git diff --stat
```

**Branch guard:** if the current branch is `main` or `master`, **STOP**. Do not commit. Create a feature branch first:
```bash
git checkout -b feature/«descriptive-name»
```

## Step 3: SECURITY GREP (mandatory)

Scan what is about to be committed for secrets:
```bash
git diff --cached --name-only | xargs grep -lE "(API[_-]?KEY|SECRET|PASSWORD|TOKEN|BEGIN [A-Z ]*PRIVATE KEY|[a-z]+://[^ ]*:[^ ]*@)" 2>/dev/null
# Also scan unstaged tracked changes
git diff --name-only | xargs grep -lE "(API[_-]?KEY|SECRET|PASSWORD|TOKEN)" 2>/dev/null
```

Never commit these:
- `.env*`, `*.pem`, `*.key`, `credentials*.json`
- database dumps / backups
- any file containing a real key or token

Confirm `.gitignore` covers `.env`, `.env.local`, `*.pem`, `*.key`, `backups/`. If a secret is staged, **STOP** and remediate before continuing.

## Step 4: Conventional Commit

```bash
git add «specific files»   # prefer explicit paths over -A
git commit -m "type: concise summary

- detail
- detail"
```

Commit message rules:
- Conventional prefix: `feat: | fix: | docs: | refactor: | test: | chore:`
- Summary ≤ 72 chars
- **NO mention of "claude", "anthropic", or any AI tool** anywhere in the message

## Step 5: Approval Gate

Present and WAIT for explicit approval:
```
WRAP-UP SUMMARY
Branch: [name]   Commit: [hash] [summary]

Changes:
| File | What changed |
|------|--------------|
| ...  | ...          |

Ready to push branch and open a PR. Approve? (yes/no)
```
Do not push without a clear "yes".

## Step 6: Push + Open PR

```bash
git push -u origin "$(git branch --show-current)"
gh pr create --title "type: description" --body "## Summary
- ...

## Test Plan
- [ ] ..."
```

PR body must not mention AI tools.

## Safety Checklist

- [ ] On a feature branch (not main/master)
- [ ] Security grep clean — no secrets staged
- [ ] `.gitignore` covers env/keys
- [ ] Conventional commit, no AI-tool mentions
- [ ] User approved before push/PR
