# Agentic Base Layer

> A reusable, cross-project Claude Code base layer — agents, skills, commands, hooks, a knowledge registry, and a CLAUDE.md seed. Clone it to start any new project with a complete, opinionated agentic setup. *Dotfiles, but for your AI agent.*

Everything here is **global by nature** — meant to be reused across *every* project, never tied to one app. You don't run it; it's configuration that shapes how Claude Code behaves: the deterministic scaffolding around a non-deterministic model.

Synthesized from six mature projects and reconciled against official Anthropic documentation (Agent Skills, context windows, tool-context, effort control, managed agents, webhooks). The full study lives in [`meta/`](meta/).

---

## How you use it

This repo is a **template**. Each new project gets its *own* copy and its *own* git history — **the base repo never changes from project work.**

```bash
# Option A — bootstrap script (copies .claude/ + CLAUDE.md, runs git init)
bin/new-project.sh ~/projects/my-app my-app

# Option B — GitHub "Use this template" → a fresh repo, then delete meta/ and bin/

# Option C — manual
cp -R agentic-base-layer/.claude  my-app/.claude
cp    agentic-base-layer/CLAUDE.md my-app/CLAUDE.md
```

Then: edit `CLAUDE.md` (fill the «PLACEHOLDERS»), `git init`, and build with `/wake-up → /feature → /wrap-up`. From that point everything you change belongs to *your* project repo.

> **Independence by design.** Fixing or extending the base later does **not** retro-update existing projects — each carries the copy it was born with. (If you'd rather have central, updatable distribution, the same `.claude/` can later be published as a Claude Code plugin; see `meta/GAPS.md`.)

---

## What's in the box

```
agentic-base-layer/
├── CLAUDE.md          ← the single reusable SEED (each project fills in its specifics)
├── .claude/           ← THE PAYLOAD — copied into every project
│   ├── agents/        · 9 subagents (orchestrator, product-manager, developer,
│   │                    code/security/database/design reviewers, test-engineer, gatekeeper)
│   ├── skills/        · 10 skills (advise, retrospect, cleanup, document, wake-up,
│   │                    wrap-up, station, pre-ship + authoring-skills/-subagents meta-skills)
│   ├── commands/      · 12 slash-commands (the task lifecycle)
│   ├── knowledge/     · REGISTRY.md — append-only lessons DB (K-PAT/PIT/ARC/PRF/SEC)
│   ├── templates/     · AGENT / SKILL / FEATURE / BUG authoring templates
│   ├── rules/         · path-scoped rules (load only when matching files are touched)
│   ├── hooks/         · deterministic guardrails (the enforcement layer)
│   ├── settings.json  · hooks + permissions  (+ settings.example.jsonc, annotated)
│   ├── WORKFLOW.md        · the canonical task lifecycle + Loop Recovery Protocol
│   └── CONTEXT-PASSING.md · the 4-field sub-agent handoff contract
├── bin/new-project.sh ← scaffolds a new project from this base
├── meta/              ← ABOUT the framework (delete in your project)
│   ├── SCORING.md     · every source asset scored: reuse × quality + verdict
│   ├── GAPS.md        · defects fixed + gaps filled + distribution options
│   ├── REFERENCE.md   · authoritative facts, cited to Anthropic docs
│   └── presentation/  · index.html — the 18-slide visual deck for developers
├── LICENSE            ← MIT
└── .gitignore
```

---

## The two ideas behind every choice

**① Context is finite.** *"Find the smallest set of high-signal tokens that maximize the desired outcome."* CLAUDE.md loads every turn (keep it < 200 lines); skills load only when triggered (progressive disclosure); subagents get their own context window; the 4-field handoff passes ~50–100 tokens, not 1,000-line dumps.

**② Prose suggests; hooks enforce.** CLAUDE.md and agent prompts *shape* behavior but are not a hard enforcement layer. Where a rule must hold — secret scanning, formatting, gates — use a **hook** (only exit code 2 blocks) or a script-enforced gate, not a paragraph.

---

## The task lifecycle

```
 /wake-up                                                      /wrap-up · /station
    │ start                                                        │ end
    ▼                                                              ▼
 PLAN/MATURE → BUILD → REVIEW → TEST → SECURITY GATE → COMPLETE/RETROSPECT
 product-mgr   developer  code-reviewer  test-eng  gatekeeper      (knowledge++)
                         (+ parallel db/security/design)
    ▲                                                              │
    └─────── advise (read REGISTRY before) ◄── retrospect (write after) ◄┘
```

The **knowledge loop** is the compounding asset: `advise` reads `.claude/knowledge/REGISTRY.md` before non-trivial work; `retrospect` writes typed lessons after. The base ships the schema + a few example entries; the value accrues from your real usage.

---

## The name

The accurate, collision-free category for this is *a personal Claude Code base layer / "AI dotfiles"* — **Agentic Base Layer**. (Avoided: *Agent OS* — product collision; *agentic framework* — collides with LangChain/CrewAI; *harness* — Claude Code **is** the harness.) Full rationale in `meta/REFERENCE.md §9`.

---

## Provenance

Mined from six of my own mature projects (a finance app, a music SaaS, an AI-briefing SaaS, and three earlier orchestration prototypes); de-personalized, de-duplicated, defect-fixed. Verified: valid `settings.json`, zero project-name leaks, current model names, read-only reviewers, well-formed deck. See `meta/SCORING.md` and `meta/GAPS.md`.
