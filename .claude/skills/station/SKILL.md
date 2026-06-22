---
name: station
description: End-of-session composition that chains retrospect → document → cleanup → wrap-up into one closeout pipeline. Use this to fully close a working session — capture learnings, sync docs, prune artifacts, then commit and open a PR — without forgetting a step. Side-effecting; honors each sub-skill's confirmation and approval gates. Run explicitly.
disable-model-invocation: true
---

# station — Combined End-of-Session Workflow

Run the full closeout pipeline in order. Each phase reuses the corresponding standalone skill and respects its gates.

**Usage:** `/station`

---

## Overview

| # | Phase | Reuses | Gate |
|---|-------|--------|------|
| 1 | Retrospect | `retrospect` | none (write to registry) |
| 2 | Document | `document` | secret scan before write |
| 3 | Cleanup | `cleanup` | user confirmation |
| 4 | Wrap-up | `wrap-up` | branch guard + approval |

If any phase halts (secret found, on main branch, user declines), stop the pipeline there and report — do not silently skip ahead.

---

## Pre-Flight: Security Scan

```bash
grep -rn -iE "(sk_|pk_|api[_-]?key|secret|password|token|[a-z]+://[^ ]*:[^ ]*@)" \
  README.md CLAUDE.md docs/ .claude/ \
  --include="*.md" 2>/dev/null
```
If secrets found: **STOP**, alert the user, remove before continuing.

---

## Phase 1: Retrospect

Mine the session, classify insights (K-PAT / K-PIT / K-ARC / K-PRF / K-SEC), append entries to `.claude/knowledge/REGISTRY.md` using the Context → Learning → Application → Metric schema. (See the `retrospect` skill.)

## Phase 2: Document

Scan the code, secret-scan the docs, then apply targeted edits to STATUS.md / CLAUDE.md / README so they match reality. (See the `document` skill.)

## Phase 3: Cleanup

Audit git branches, stale session files, and temp caches. Present the report table and wait for confirmation before deleting anything. Never touch main/current branch, env, secrets, or databases. (See the `cleanup` skill.)

## Phase 4: Wrap-up

Update STATUS, confirm you are on a feature branch, security-grep the diff, make a conventional commit (no AI-tool mentions), get approval, then push and open a PR. (See the `wrap-up` skill.)

---

## Output

```
SESSION STATION COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RETROSPECT  knowledge entries: N
DOCUMENT    files updated: [list]    alignment: [clean | N issues]
CLEANUP     branches pruned: N       artifacts cleared: [size]
WRAP-UP     commit: [hash]           PR: [url]

Session closed.
```

## Safety Rules

1. Secret scan before any doc write.
2. Cleanup requires explicit confirmation.
3. Wrap-up requires a feature branch and explicit approval before push.
4. Code is truth; docs describe what IS.
5. Never commit secrets; never push to main.
6. Halt the chain on the first gate that fails — report, don't skip.
