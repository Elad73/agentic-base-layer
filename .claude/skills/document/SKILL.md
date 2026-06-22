---
name: document
description: Code-is-truth documentation sync. Detects drift between the codebase and project docs (STATUS.md, CLAUDE.md, README), then applies targeted edits so docs describe what the code actually is. Use this after shipping features, before a release, or when docs feel stale. Secret-scans every doc before writing. Makes small surgical edits, never wholesale rewrites.
---

# document — Documentation Sync

Scan the code, detect drift from the docs, and patch the docs to match reality.

**Usage:** `/document`

---

## Phase 1: Scan the Code (source of truth)

Genericize these probes to the project's actual layout. The goal is a current inventory of routes, modules, data models, and surfaces.

```bash
# Recent activity
git log --oneline -10

# Source size / shape («adjust glob to project language»)
find src -type f | wc -l

# Public entry points / routes («PLACEHOLDER: e.g. ls api/  or  routes manifest»)
ls api/ 2>/dev/null

# Modules of interest («PLACEHOLDER: commands/ services/ handlers/ ...»)
ls src/services/ src/commands/ 2>/dev/null

# Data models («PLACEHOLDER: ORM schema, e.g. grep '^model ' prisma/schema.prisma»)
# Skills / commands available
ls .claude/skills/ .claude/commands/ 2>/dev/null
```

## Phase 2: Secret Scan (before any write)

```bash
grep -rn -iE "(sk_|pk_|api[_-]?key|secret|password|token|[a-z]+://[^ ]*:[^ ]*@)" \
  README.md CLAUDE.md docs/ .claude/ \
  --include="*.md" 2>/dev/null
```
If anything real is matched: **STOP**, alert the user, and remove the secret before writing anything. Do not commit.

## Phase 3: Apply Targeted Edits

Update only the parts that drifted.

### STATUS.md (path `docs/STATUS.md` or `docs/status/STATUS.md`)
- Last-updated date
- Completed work / recent PRs
- Current phase and next steps
- Known blockers

### CLAUDE.md
- Directory structure (only if it changed)
- New commands / skills / scripts
- Architecture patterns and workflows

### README.md (if present)
- Feature list, tech stack, setup steps

## Phase 4: Alignment Check

Verify the docs now match the code on countable facts:

| Check | Doc | Code source | Verify |
|-------|-----|-------------|--------|
| Data model count | CLAUDE.md | «schema file» | equal |
| Command/route list | CLAUDE.md | «routes / commands dir» | equal |
| Surface count | STATUS.md | «UI manifest» | equal |
| Skill list | CLAUDE.md | `.claude/skills/` | equal |

## Rules

1. **Code is truth** — docs describe what IS, not what should be.
2. **Targeted edits** — patch lines; never rewrite whole files.
3. **Single source** — each fact lives in one place; others reference it.
4. **Secret scan before every write** — no exceptions.
5. **No emojis** unless the file already uses them.
