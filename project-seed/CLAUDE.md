<!--
================================================================================
CLAUDE.md SEED  ·  Agentic Base Layer
This is the reusable seed. `bin/new-project.sh` copies it into a new project for you
(or copy it yourself). In your project: fill in every «PLACEHOLDER» and delete this
comment block. In the base repo, leave it as-is — it's the template.

GOLDEN RULES (from Anthropic's own guidance — this file loads in FULL every turn):
  • Keep it UNDER ~200 lines. "Files over 200 lines consume more context and may
    reduce adherence." For each line ask: "Would removing this make Claude make a
    mistake?" If not — cut it.
  • Only include what Claude CANNOT infer from the code: non-default commands, ports,
    gotchas, invariants, repo etiquette. NOT file-by-file tours or standard conventions.
  • Concrete, testable rules ("2-space indent"), not vibes ("format nicely").
  • Reserve **IMPORTANT** / **NEVER** / **YOU MUST** for the few load-bearing rules.
    If everything is important, nothing is.
  • Heavy, changing prose (full specs, status logs, product algorithms) → docs/, NOT here.
  • Prefer pointers: "see .claude/WORKFLOW.md" beats pasting the workflow inline.
Delete any section below that doesn't apply. Sections marked (optional) often don't.
================================================================================
-->

# CLAUDE.md — «Project Name» («one-line product definition»)

«Project» is a «what it is in one sentence — who it's for and the single job it does». The whole system exists to «the ultimate product question it answers / the outcome it produces».

> Status: **«current phase»** — see `docs/STATUS.md` for where we left off.

---

## 1. Reconnection protocol (read first, every session)

On any new work, read in this order:

1. `docs/STATUS.md` — current phase, what's done, what's in progress, blockers. *(your "where we left off")*
2. `.claude/WORKFLOW.md` — the task lifecycle + Loop Recovery Protocol.
3. The relevant spec in `docs/«…»` for the area you're touching.

<!-- If you have a locked spec set, list its source-of-truth index file here. -->

---

## 2. Architecture invariants (NON-NEGOTIABLE)

The load-bearing rules. Violating one is a bug even if it "works."

- **«Invariant 1»** — e.g. *Core logic is pure: `src/«core»/*` has no framework imports — inputs in, outputs out, unit-testable. Adapters wire it to UI/DB.*
- **«Invariant 2»** — e.g. *One owner per entity/contract; modules exchange only typed contracts, never reach into each other's tables.*
- **«Invariant 3»** — e.g. *Shared types are defined in one place; consumers reference, never redefine.*
- **«Invariant 4»** — e.g. *AI output is badged and inert until an explicit user Accept; the model runs behind a Port, never a direct SDK call in core logic.*

<!-- 3–7 bullets max. These are the rules a reviewer should be able to grep-check. -->

---

## 3. Tech & environment

| Layer | Choice |
|-------|--------|
| Runtime | «Node 24 / Python 3.12 / …» |
| Framework | «Next.js 15 / …» |
| DB | «Postgres @ localhost:«port» — start with `«command»`» |
| ORM / Validation | «Prisma / Zod / …» |
| AI | «Anthropic SDK via a Port. Models: `claude-opus-4-8` (synthesis), `claude-sonnet-4-6` (volume). NEVER invent model names.» |
| Process / Ports | «pm2 on port «PORT» — never «reserved ports».» |
| Tests | «Vitest (unit) + Playwright (e2e)» |

Non-default commands Claude can't guess:
- Dev: `«npm run dev»` · Test: `«npm test»` · Lint+types: `«npm run check»` · Build: `«npm run build»`

---

## 4. Database safety (optional — keep if you have a DB)

- **Before any migration: automatic backup** (`«pg_dump …»`). Wrap migrations so this can't be skipped.
- Be careful with schema changes vs existing data; preserve backward compatibility.

---

## 5. Design (optional)

- The design source of truth is `«docs/ux-vision.md / a design skill»` — it wins any UI conflict.
- «Mobile-first OR a documented override (e.g. "desktop-only for MVP — deliberate override of the global mobile-first rule").»
- Reuse the component kit; respect the anti-patterns list in «…».

---

## 6. Testing & release gates

- **Unit:** «pure modules with injected clock + fixtures — no `Date.now()`, no network.»
- **E2E:** «Playwright, «viewport».»
- **Gate:** a unit of work is "done" only when «its checklist / `pre-ship` gates» are green. Run `/pre-ship` before committing.

---

## 7. Workflow

- **Feature branch + PR, never direct to `main`.** Full lifecycle: `.claude/WORKFLOW.md`.
- Use the commands: `/wake-up` (start) · `/feature` or `/bug-fix` (work) · `/wrap-up` or `/station` (end).
- **Commit messages: never mention "claude" or "Anthropic".** Conventional-commit style.
- **NEVER commit sensitive data — scan the diff before every commit.** Check for **secrets** (keys, tokens, passwords, `.env`, `*.pem`/`*.key`) **and** personal/identifying data (real emails, names, unreleased or private project names, home paths like `/home/...` or `/Users/...`, internal URLs). For **public repos**, review the full diff before pushing — a leaked email or private project name is effectively permanent once pushed (it survives a force-push via the old commit SHA). Note: the `/pre-ship` and `/wrap-up` secret scan catches keys/tokens, **not** personal data — do that check yourself.
- Ship the **smallest runnable slice first** — earliest end-to-end path that does something real; widen later.

---

## 8. Key conventions & gotchas (the stuff that bites)

- «Gotcha 1 — e.g. import path quirk, env var caching, a service that's often down.»
- «Convention 1 — e.g. naming, error-handling pattern, where new X goes.»

<!-- This is where hard-won, non-obvious facts live. Add to it via /retrospect → it can graduate into .claude/knowledge/REGISTRY.md. -->
