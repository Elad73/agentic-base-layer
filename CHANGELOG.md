# Changelog

All notable changes to the Agentic Base Layer.

## [0.2.0] — 2026-06-22 — Hybrid restructure (global + per-project)

### Changed — repository shape
- Split into two payloads: **`global/`** (reusable engine installed into your config home — agents, skills, commands, conventions) and **`project-seed/`** (per-project starter — CLAUDE.md seed, knowledge scaffold, rules, docs). Framework docs live in `meta/`.
- Added **`install.sh`** — symlink (or `--copy`) `global/*` into `$CLAUDE_CONFIG_DIR`/`~/.claude` so the toolkit is live in every project. `bin/new-project.sh` still seeds a standalone project.

### Added — content reconciled from the real global toolkit (sanitized)
- **Authoring/meta skills** (full router skills, replacing the thin stand-ins): `create-agent-skills`, `create-subagents`, `create-slash-commands`, `create-hooks`, `create-meta-prompts`, `create-plans`, `debug-like-expert`.
- **`debugger`** agent (the universal tier the roster was missing).
- **Command wrappers** for every skill-only verb (`advise`, `document`, `retrospect`, `cleanup`, `station`, `pre-ship`) and the authoring/planning skills — fixes verbs advertised with `/` that previously did nothing.
- **`consider/`** — 12 mental-model commands (5-whys, inversion, eisenhower-matrix, first-principles, …).
- Utilities: `create-prompt`, `run-prompt`, `whats-next`, `heal-skill`, `run-plan`, `add-to-todos`, `check-todos`.
- **`block-secrets.sh`** hook (previously referenced but missing).

### Fixed
- Collapsed **command↔skill duplication** (`wake-up`, `wrap-up`) to skill-logic + thin command — one source of truth.
- 4-field handoff contract was self-contradictory (`REGISTRY` said *Goal/Inputs/Constraints/Return*; canonical doc says *Task/Files/Context/Constraints*) — reconciled to the canonical version.
- `pre-ship` skill frontmatter `allowed-tools: Bash Read` → `Bash, Read` (was one bogus token).
- Live `settings.json` SessionStart printed the literal `«PROJECT-STATUS-FILE»` placeholder → resolves to `docs/STATUS.md`.
- `K-ARC-001` knowledge entry had Application before Learning → reordered to the schema.

### Excluded (kept private — personal/aesthetic)
- `cost-track`, `log-to-vault`, `workstation`, `dispatch-design`, `taxonomy-design`, `ui-designer`, `taxonomy-curator`, the `expertise/` domain packs, and personal `settings.json` hooks.

## [0.1.0] — 2026-06-22 — Initial public release
- First template-repo cut: 9 SDLC agents, 10 skills, 12 lifecycle commands, knowledge registry, workflow + handoff conventions, CLAUDE.md seed, framework study + presentation.
