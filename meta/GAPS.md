# Agentic Base Layer — Gaps Found & Filled

What was broken, missing, or inconsistent across the six source projects, and how Agentic Base Layer resolves each. Grouped by severity. Sections A–C are the source-project audit (valid history); §E tracks items resolved in the v0.2.0 restructure; §D lists what's genuinely still open.

## A. Defects fixed during extraction (were real bugs)

| # | Gap | Where it lived | Fix in Agentic Base Layer |
|---|---|---|---|
| 1 | **Hardcoded absolute memory path** `~/.claude/projects/…/memory/` | the finance project `advise`, `retrospect`, `station` | Repointed to project-relative `.claude/knowledge/REGISTRY.md`; removed the path-dependent "update memory" step. Now portable. |
| 2 | **Skill with no `SKILL.md`** (not invokable) | the finance project `parallel-orchestration` | Checkpoint schema folded into `orchestrator` agent + `run-task` command. |
| 3 | **Skill / template missing YAML frontmatter** | `github-orchestration` SKILL.md; `SKILL-TEMPLATE.md` | Added required `name` + trigger-rich `description` (+ `allowed-tools`). |
| 4 | **Copy-paste bug**: a design-reviewer "master of visual design" block grafted onto the code reviewer | the music project `code-reviewer-pro` | Removed; `code-reviewer` keeps a security smell-test and *delegates* design to `design-reviewer`. |
| 5 | **Stale model names** (`claude-3-7-sonnet`, "caching coming soon") | `anthropic-claude-api` skill | Flagged DROP-until-refreshed; all kit files use only `claude-opus-4-8` / `claude-sonnet-4-6` / `claude-haiku-4-5`. |
| 6 | **Phase-count doc drift** ("5-phase" vs "6-phase"; Security as Phase 4 vs 5) | the orchestrator repo | Reconciled to one canonical 6-stage lifecycle in `WORKFLOW.md`. |
| 7 | **Session-file naming drift** (`context_session` vs `content_session`; `sessions/` vs `tasks/`) | the music project | Standardized to `.claude/sessions/CURRENT-SESSION.md`. |
| 8 | **Token-cost formula hardcoded** ($0.000008/Sonnet) — silently drifts with pricing | the base-team repo, the finance project | Dropped from base; cost tracking is optional/externalized. |
| 9 | **GH project-board scripts shipped with `"TODO"` IDs** — nothing runs until 6 files are hand-edited | the base-team repo, the finance project | Base is backend-agnostic; GH scripts are an opt-in pack, clearly marked as needing per-project setup. |
| 10 | **Cross-project token bleed** — the briefing project design tokens leaked into the music project skills | shared design skills | Domain skills demoted to optional packs; tokens marked «PLACEHOLDER». |

## B. Capability gaps (missing across *all* projects)

| Gap | Why it matters | Agentic Base Layer's fill |
|---|---|---|
| **No enforcement layer** — rules lived only as prose; the music project measured ~10% compliance with "MUST consult" | Prose can't enforce; only hooks/gates can | Ship `settings.json` hooks + `pre-ship` gates as the deterministic layer; doc the "exit code 2 blocks" rule. |
| **No context-budget discipline** documented | Long sessions hit context rot; CLAUDE.md bloat reduces adherence | `meta/REFERENCE.md` + the presentation teach progressive disclosure, the 200-line CLAUDE.md target, `/clear` & `/compact`, subagent isolation. |
| **No authoring standard for new assets** ✅ | Each project reinvented agent/skill shape | ✅ **RESOLVED (v0.2.0):** full `create-*` router skills (`create-agent-skills`, `create-subagents`, `create-slash-commands`, `create-hooks`, `create-meta-prompts`, `create-plans`, `debug-like-expert`) — each with bundled references/templates/workflows — replaced the thin meta-skills. Plus FEATURE/BUG templates in the seed. |
| **Knowledge registries shipped empty** (base-team's was "No entries yet") | Value only accrues from real use | Schema + 3 self-documenting example entries; adoption guide says "seed it from your audit findings day one". |
| **No "right altitude" guidance** for prompts | Agents were either too brittle (hardcoded) or too vague | Meta-skills + presentation encode the Goldilocks principle. |
| **No modern features adopted** — none used path-scoped `rules/`, `disable-model-invocation`, `context: fork`, tool-search | Newer Claude Code features cut context cost materially | Kit demonstrates `rules/`, `disable-model-invocation`, and the reference doc covers fork/tool-search/programmatic-tool-calling. |

## C. Things your projects did *better* than the docs (kept & promoted)

Not everything was a gap — these home-grown patterns are genuinely strong and are now canonical in Agentic Base Layer:

- **The typed knowledge registry** (`K-PAT/PIT/ARC/PRF/SEC`, `Context→Learning→Application→Metric`) — more actionable than generic "memory".
- **The 4-field handoff** (`Task/Files/Context/Constraints`) — independently reinvented in 3 repos; a real convergent pattern.
- **The Loop Recovery Protocol** (same error 3×: STOP→DOCUMENT→ANALYZE→SIMPLIFY→ALTERNATE→ESCALATE) — pure, portable, prevents thrash.
- **Read-only reviewer + fixed BRIEF** with IDed findings — clean separation that the official subagent guidance only implies.
- **`station` composition** — chaining session-hygiene skills into one verb.
- **Backup-before-migration + add-then-delete test safety** — operational wisdom worth keeping.

## D. Open items (not auto-fixable)

1. ~~Pick the name~~ ✅ **Decided: `Agentic Base Layer`** (see README §1).
2. ~~No global-install path~~ ✅ **RESOLVED (v0.2.0):** see §E.
3. ~~No authoring standard~~ ✅ **RESOLVED (v0.2.0):** see §B / §E.
4. **Choose the task backend** per project (filesystem Kanban vs GitHub Issues).
5. **Refresh or retire** the `anthropic-claude-api` skill before reusing it.
6. **Decide on stack packs** — which domain skills to bundle for your project's stack.
7. **Seed `knowledge/REGISTRY.md`** with your project's real lessons to make the loop live.
8. **Plugin / marketplace distribution** — the kit currently ships as a GitHub *template* repo + global install; a Claude Code plugin/marketplace package remains a future option, not yet built.
9. **Two over-long skills** — a couple of the lifecycle/router skills run past the ~500-line body target; worth a split/trim pass.

## E. Resolved in the v0.2.0 restructure

The hybrid (global + per-project) restructure closed several gaps that were open at v0.1.0:

| Item | Was | ✅ Resolution in v0.2.0 |
|---|---|---|
| **No global-install path** | Kit was a single `.claude/` at the repo root; nothing made it live across projects | `install.sh` symlinks (or `--copy`) `global/*` into `~/.claude` (honoring `$CLAUDE_CONFIG_DIR`) so the engine is live in every project and updatable via `git pull`. `bin/new-project.sh` seeds a standalone project from `project-seed/`. |
| **No authoring standard** | Thin `authoring-skills` / `authoring-subagents` stand-ins only | Full `create-*` router skills with bundled references/templates/workflows (see §B). |
| **Verbs advertised with `/` but skill-only did nothing** | `advise`, `document`, `retrospect`, `cleanup`, `station`, `pre-ship` (+ authoring/planning verbs) had no command, so `/advise` etc. were dead | Thin command wrappers added for every skill-only verb — the skill holds the logic, the command is a one-source-of-truth wrapper. |
| **`block-secrets.sh` referenced but missing** | Hooks doc/settings referenced a secret-blocking hook that wasn't shipped | `block-secrets.sh` now ships in `project-seed/.claude/hooks/`. |
| **4-field handoff contradiction** | `REGISTRY` said *Goal/Inputs/Constraints/Return*; canonical doc said *Task/Files/Context/Constraints* | Reconciled to the canonical `Task/Files/Context/Constraints` everywhere. |
| **`pre-ship` skill frontmatter** | `allowed-tools: Bash Read` (one bogus token) | Fixed to `Bash, Read`. |
| **`settings.json` placeholder leaked** | Live SessionStart printed the literal `«PROJECT-STATUS-FILE»` | Resolves to `docs/STATUS.md`. |
| **`K-ARC-001` entry out of schema order** | Application appeared before Learning | Reordered to the `Context→Learning→Application→Metric` schema. |
