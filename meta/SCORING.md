# Agentic Base Layer — Asset Scoring

Every reusable asset found across your six projects, scored on two axes and given a verdict.

- **Reuse (1–10):** how cross-project / drop-in-portable it is (10 = generic, 1 = one-project-only).
- **Quality (1–10):** how well-engineered the asset is on its own terms.
- **Verdict:** `ADOPT` (in Agentic Base Layer as-is/genericized) · `ADAPT` (good idea, needs rework) · `DROP` (project-specific or superseded) · `FIX` (adopted but had a defect, now fixed).

Scoring criteria for **agents**: single-responsibility, least-privilege tools, trigger-rich description, structured output, correct read-only/writer split. For **skills**: focused scope, trigger-rich description, progressive disclosure, body <500 lines, no hardcoded paths. For **CLAUDE.md**: concise (<200–300 lines ideal), concrete/testable rules, only non-inferable info, correct use of emphasis.

---

## 1. Agents

| Agent (source) | Reuse | Quality | Verdict | Notes |
|---|:-:|:-:|---|---|
| **orchestrator** (maestro-mehta) | 8 | 8 | ADOPT | Checkpoint/retry/escalation machinery is gold; de-personalized + stack-decoupled. |
| **code-reviewer** (code-reviewer-pro) | 8 | 9 | FIX | Best-engineered reviewer (sub-reviewer spawn, evidence gate). Source had a copy-pasted *design-reviewer* block grafted on — removed. |
| **security-reviewer** | 8 | 8 | ADOPT | OWASP checklist + concrete secret greps + `git filter-branch`/`filter-repo` credential-leak recovery folded in from orchestrator/core. |
| **database-reviewer** | 7 | 8 | ADOPT | Most reuse-ready as-is (Decimal-not-Float, N+1, safe migrations). Light stack coupling stripped. |
| **design-reviewer** | 7 | 7 | ADAPT | Generic WCAG/spacing/type knowledge kept; baked-in fonts/keyframes dropped → point at the project's design skill. |
| **product-manager** (master-steve / steve-jobs) | 6 | 8 | ADAPT | Richest requirements-maturation logic; HALT-gate on intent conflict is excellent. De-personalized. |
| **developer** (ninja-developer) | 6 | 7 | ADAPT | "Implement one AC at a time, verify-before-done" loop kept; hardcoded stack removed. |
| **test-engineer** (test-automation-expert) | 6 | 8 | ADOPT | Tiered coverage thresholds + PR-on-green. Coverage numbers genericized. |
| **release-gatekeeper** (master-yoda) | 6 | 8 | ADAPT | Secret scan + completeness gate + squash-merge/close. De-personalized. |
| nextjs-expert (the briefing project) | 7 | 7 | DROP→skill | Good, but framework-specific → belongs as a *skill* (`nextjs-15-patterns`), not a base agent. |
| ui-ux-reviewer (live, Playwright MCP) | 5 | 6 | DROP | Overlaps design-reviewer but *executes* screenshots; keep as an optional project add-on. |
| marketing-strategist (the music project) | 2 | 7 | DROP | Cleanly structured but fully product-locked. |
| audio-pipeline-reviewer (the briefing project) | 2 | 6 | DROP | Vendor/domain-specific (TTS). |

**Reusable techniques lifted regardless of source:** consultant-vs-owner role split with tool-permission enforcement; read-only specialist returns a fixed-template BRIEF; sub-reviewer auto-detection by `git diff … | grep`; script-enforced AC-evidence gate with exit codes; rubric-scored review with numeric merge thresholds.

---

## 2. Skills

### Lifecycle / session skills (the portable core)
| Skill | Reuse | Quality | Verdict | Notes |
|---|:-:|:-:|---|---|
| **cleanup** | 9 | 9 | ADOPT | Safe artifact pruning; hard never-delete rules. Merged the finance project + the music project versions; default-branch via `origin/HEAD`. |
| **retrospect** | 8 | 8 | FIX | Writes typed K-entries. Removed hardcoded absolute memory path → project-relative `knowledge/REGISTRY.md`. |
| **wrap-up** | 8 | 8 | ADOPT | Branch guard → secret grep → no-AI-mention commit → approval → PR. |
| **wake-up** | 7 | 8 | ADOPT | Start-of-session sync; smartly avoids re-reading CLAUDE.md (already in system prompt). |
| **station** | 7 | 8 | FIX | Composes retrospect→document→cleanup→wrap-up. `disable-model-invocation: true`. |
| **advise** | 7 | 7 | FIX | Pre-task knowledge retrieval. Same hardcoded-path fix as retrospect. |
| **document** | 7 | 7 | ADOPT | Code-is-truth doc sync + secret-scan before write. Detection commands genericized. |
| **pre-ship** | 6 | 9 | ADAPT | Mandatory pre-commit gates, halt-on-first-fail. Gate commands → «PLACEHOLDER» table per project. |
| parallel-orchestration (checkpoint) | 8 | 7 | FIX | Great checkpoint schema but **had no SKILL.md** (not invokable) → folded into `orchestrator` + `run-task`. |
| github-orchestration | 7 | 7 | ADAPT | Issues-as-SOT framework w/ progressive disclosure; **was missing frontmatter** → fixed. Roster parameterized. |

### Meta-skills (teach the craft — highest pure-knowledge value)
| Skill | Reuse | Quality | Verdict | Notes |
|---|:-:|:-:|---|---|
| **authoring-skills** (agent-skills-guide) | 9 | 9 | ADOPT | Progressive disclosure, trigger-rich descriptions, char limits, 4 craft principles. Corrected against current spec. |
| **authoring-subagents** (subagents-guide) | 8 | 9 | ADOPT | Flat-file rule, frontmatter, isolated context, delegate-at-10-files. Corrected against current spec. |

### Domain/reference skills (keep per-stack, not "base")
| Skill | Reuse | Quality | Verdict | Notes |
|---|:-:|:-:|---|---|
| saas-business-model | 10 | 8 | KEEP (lib) | Pure domain knowledge, zero coupling. |
| graphic-design-principles | 10 | 8 | KEEP (lib) | Timeless; swap tokens. |
| prisma-optimization / nextjs-15-patterns / vercel-deployment | 9 | 8 | KEEP (lib) | Stack libraries — ship in a per-stack "pack", not base. |
| playwright-testing / conversion-optimization / seo-* / ui-card-design / pricing-page-design / homepage-design | 7–9 | 7–8 | KEEP (lib) | Strong references; tokens are placeholders. |
| anthropic-claude-api | 6 | 4 | FIX/DROP | **STALE** (`claude-3-7-sonnet`, "caching coming soon"). Refresh before any reuse. |
| frontend-aesthetics | 4 | 6 | DROP | Hardcoded the briefing project dark tokens leaked into other projects. |
| the finance app-design-system | 1 | 9 | DROP | Exceptional *mechanism* (progressive disclosure, live `file:line` examples, SCORECARD loop) but 100% project brand. Copy the **mechanism**, not the content. |

> The 15+ domain skills are excellent but belong in optional **stack packs** (`packs/nextjs`, `packs/design`), not the universal base. Agentic Base Layer ships the lifecycle + meta skills; you add a pack per project.

---

## 3. Commands

| Command | Reuse | Quality | Verdict | Notes |
|---|:-:|:-:|---|---|
| **wake-up** | 8 | 8 | ADOPT | Parallel context sync → proposes next step. |
| **wrap-up** | 8 | 8 | ADOPT | Safe commit + PR + tracker sync. |
| **bug-fix** | 7 | 8 | ADOPT | 8-phase reproduce→root-cause→regression-test→gate→PR; structure is generic. |
| **task-status / sync-issues** | 7 | 7 | ADOPT | Dashboards + anomaly detection (no-status, multi-status, stale, orphaned branches). |
| **feature** | 6 | 7 | ADAPT | Phase-0 create → sequences phases; error-handling matrix. |
| **run-task** | 6 | 7 | ADAPT | Autonomous full-lifecycle via orchestrator + checkpoint resume + loop guard. |
| **review-task** | 6 | 8 | ADOPT | Sub-reviewer detection by `git diff … | grep` → parallel spawn. |
| **mature/execute/test/approve-task** | 5 | 7 | ADOPT | Thin per-phase dispatchers; the `pre-flight guard → assume role → success criteria` skeleton is the reusable gold. |

---

## 4. CLAUDE.md sections (what belongs, what to cut)

Scored as *should this be in a base CLAUDE.md template?* Anthropic guidance: keep it **concise** (official target <200 lines), concrete/testable rules, only non-inferable info, emphasis (`IMPORTANT`/`YOU MUST`) reserved for the few critical rules. Bloat causes Claude to *ignore* instructions.

| Section pattern (seen in your projects) | Keep in base? | Notes |
|---|---|---|
| Reconnection protocol (read order on session start) | ✅ ADOPT | Your global CLAUDE.md already nails this. |
| Architecture invariants ("non-negotiable" rules) | ✅ ADOPT (template) | A pure-invariants CLAUDE.md is the model: declarative, load-bearing, testable. |
| Tech & environment table | ✅ per-project | Non-inferable (ports, DB quirks) — exactly what CLAUDE.md is for. |
| DB safety / backup-before-migration | ✅ ADOPT | Already in your global; keep. |
| Workflow pointer (feature-branch + PR, no direct main) | ✅ ADOPT | Point to `.claude/WORKFLOW.md` instead of inlining. |
| Commit hygiene (no "claude"/"anthropic" in messages) | ✅ ADOPT | One line. |
| Massive inline "algorithm source-of-truth" prose | ⚠️ MOVE | the finance project's 440-line product spec → belongs in `docs/`, not CLAUDE.md (context bloat). |
| Long troubleshooting / recent-features logs | ❌ CUT | Frequently-changing → `docs/STATUS.md`, not CLAUDE.md. |
| File-by-file code tours | ❌ CUT | Claude can read the code. |
| Persona flourishes ("WHAT IS YOUR NEXT WISH, CAPTAIN") | ❌ CUT | Cute; costs tokens; hurts portability. |

**Verdict:** your *best* CLAUDE.md is ~120 lines of pure invariants — keep that shape. Your *heaviest* (the finance project, 609 lines) proves the anti-pattern: move source-of-truth algorithms to `docs/`.

---

## 5. `.claude/` folder components

| Component | Reuse | Quality | Verdict | Notes |
|---|:-:|:-:|---|---|
| **knowledge/REGISTRY.md + advise/retrospect loop** | 10 | 9 | ADOPT ★ | **The single best asset across all projects.** Content-agnostic, append-only, compounding. the briefing project's populated version is the canonical schema. |
| **CONTEXT-PASSING.md (4-field handoff)** | 10 | 9 | ADOPT ★ | Converged independently in all 3 orchestration repos — strongest signal of a real pattern. |
| **templates/ (AGENT/SKILL/FEATURE/BUG)** | 9 | 8 | FIX | Standardize authoring + the "Lessons Learned → Add to Skill" hook. SKILL template **was missing frontmatter** → fixed. |
| **WORKFLOW.md (lifecycle + Loop Recovery)** | 9 | 8 | FIX | Loop Recovery Protocol + Context Update Triggers are pure gold. Source had "5 vs 6 phase" drift → reconciled to one. |
| **agents/ split (core / domain / custom)** | 8 | 8 | ADOPT | Clean tiering; reviewers read-only by tool scope. |
| **hooks (settings.json)** | 8 | 7 | ADAPT | The real enforcement layer. Ship a *minimal safe* example (auto-format + context note); only exit code 2 blocks. |
| **rules/ (path-scoped)** | 8 | 7 | ADOPT | Loads only when matching files touched → saves context vs. inlining in CLAUDE.md. |
| **product/{todo,in-progress,done}** | 7 | 7 | ADOPT (opt-in) | Filesystem Kanban backend; or use GitHub Issues. |
| **sessions/ (context_session)** | 6 | 6 | FIX | Living scratchpad. Source had naming drift (`context_` vs `content_`, `sessions/` vs `tasks/`) → standardized to `sessions/CURRENT-SESSION.md`. |
| scripts/ (GH project-board sync) | 5 | 6 | ADAPT | Useful but every board ID was a `"TODO"` placeholder → needs per-project fill or drop. |

★ = the two assets to adopt first if you adopt nothing else.

---

## 6. Headline numbers

- **Inventoried:** ~30 agents · ~40 skills · ~24 commands · 6 CLAUDE.md files across 6 projects.
- **Promoted to Agentic Base Layer base:** 9 agents · 10 skills (8 lifecycle + 2 meta) · 12 commands · 4 templates · knowledge registry · workflow + context-passing contracts · hooks + rules examples.
- **Recommended as optional stack-packs:** ~15 domain skills.
- **Dropped as project-specific/stale:** the finance app-design-system, frontend-aesthetics, marketing-strategist, audio-pipeline-reviewer, anthropic-claude-api (until refreshed).
- **Defects fixed:** 7 classes (hardcoded paths, missing frontmatter ×2, copy-paste agent bug, stale models, persona-coupling, non-invokable skill, phase-count drift, session-naming drift).
