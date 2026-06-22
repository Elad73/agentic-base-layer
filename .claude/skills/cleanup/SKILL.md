---
name: cleanup
description: Safe artifact pruning. Audits stale project artifacts — merged git branches, old session/context files, temp dirs and caches, debug screenshots — then cleans only what the user confirms. Use this when the working tree feels cluttered, before archiving a project, or after a long session. Never deletes the main/current branch, env files, secrets, or databases. Side-effecting; run explicitly.
disable-model-invocation: true
argument-hint: "[category: git | sessions | temp | all]"
---

# cleanup — Project Artifact Audit

Audit and optionally remove stale artifacts. Audit-first, confirm-then-execute.

**Usage:** `/cleanup [category]` where category is `git | sessions | temp | all` (default: `all`)

---

## Phase 1: Safety Pre-Check

```bash
git status --porcelain
git branch --show-current
```

If uncommitted changes exist, warn:
> You have uncommitted changes. Cleanup will NOT touch your current branch or working files, but consider committing or stashing first.

Record the current branch name now — it is on the never-delete list.

## Phase 2: Audit (collect, do not delete)

### git
```bash
# Local branches already merged into the default branch (exclude default + current)
git branch --merged "$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@origin/@@' || echo main)" \
  | grep -vE "main|master" | grep -v "^\*"

# Remote refs that no longer exist upstream
git remote prune origin --dry-run

# Age of each local branch (for the report)
git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(committerdate:relative)'
```

### sessions
```bash
# Stale session/context handoff files, older than 14 days («adjust path to project convention»)
find .claude/tasks/ -name "context_session_*.md" -mtime +14 2>/dev/null
```

### temp
```bash
# Build/test/tool caches and debug artifacts — sizes only
du -sh .playwright-mcp/ test-results/ playwright-report/ node_modules/.cache/ 2>/dev/null
# «PLACEHOLDER: add framework build cache dir, e.g. .next/ dist/ build/»
ls -la *.png *.log *.tmp 2>/dev/null
```

## Phase 3: Report Table

| Category | Item | Age / Size | Action | Safe |
|----------|------|------------|--------|------|
| git | [branch] | merged | delete | yes |
| git | [remote ref] | gone | prune | yes |
| sessions | [file] | N days | delete | yes |
| temp | .playwright-mcp/ | [size] | clear | yes |
| temp | *.png (debug) | [count] | delete | yes |

Mark anything ambiguous as `Safe: manual` and leave it for the user to decide.

## Phase 4: Confirm

```
Options:
1. Clean all items marked Safe
2. Clean a specific category
3. Select individual items
4. Cancel
```
Wait for an explicit choice. Do nothing destructive before it.

## Phase 5: Execute (only after confirmation)

```bash
# git
git remote prune origin
git branch --merged "$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@origin/@@' || echo main)" \
  | grep -vE "main|master" | grep -v "^\*" | xargs -r git branch -d

# temp
rm -rf .playwright-mcp/* 2>/dev/null
rm -f ./*.png 2>/dev/null
```
Use `git branch -d` (safe; refuses unmerged), never `-D`, unless the user explicitly names a branch to force-delete.

## HARD RULES — never violate

1. **Never** delete the default branch (main/master) or the current branch.
2. **Never** delete `.env*`, `*.pem`, `*.key`, `credentials*`, or any database/backup file.
3. **Never** delete without an audit and an explicit confirmation first.
4. **Never** use `rm -rf` on paths outside the project working directory.
5. Prefer `-d` over `-D`; prefer dry-run flags during the audit phase.
