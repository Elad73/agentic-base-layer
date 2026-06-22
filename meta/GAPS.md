# Agentic Base Layer — Gaps Found & Filled

What was broken, missing, or inconsistent across your six projects, and how Agentic Base Layer resolves each. Grouped by severity.

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
| **No authoring standard for new assets** | Each project reinvented agent/skill shape | `templates/` + the two meta-skills (`authoring-skills`, `authoring-subagents`). |
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

## D. Open items for you (not auto-fixable)

1. ~~Pick the name~~ ✅ **Decided: `Agentic Base Layer`** (see README §1).
2. **Choose the task backend** per project (filesystem Kanban vs GitHub Issues).
3. **Refresh or retire** the `anthropic-claude-api` skill before reusing it.
4. **Decide on stack packs** — which domain skills to bundle for your project's stack.
5. **Seed `knowledge/REGISTRY.md`** with your project's real lessons to make the loop live.
