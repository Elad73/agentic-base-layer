# Agentic Base Layer

> A reusable, cross-project Claude Code layer — agents, skills, commands, an authoring toolkit, and a knowledge system. **Install it once** and it's live in every project. *Dotfiles, but for your AI agent.*

Everything here is **global by nature** — meant to be reused across *every* project. The repo has two payloads, because there are two levels:

- **`global/`** — the reusable engine (agents, skills, commands, conventions). Installed once into your Claude Code config home; available in all projects.
- **`project-seed/`** — the per-project starter (a `CLAUDE.md` seed, a knowledge scaffold, rules, a docs skeleton). Copied into each new project; that's where project-*specific* facts live.

Synthesized from a real multi-project Claude Code setup and reconciled against official Anthropic docs. The full study + a visual deck live in [`meta/`](meta/).

---

## Install (global — use across all projects)

```bash
git clone https://github.com/Elad73/agentic-base-layer ~/agentic-base-layer
~/agentic-base-layer/install.sh          # symlinks global/* into ~/.claude (or $CLAUDE_CONFIG_DIR)
# update anytime:  git -C ~/agentic-base-layer pull
```

Now the roster, skills, and commands are available in **every** project. `install.sh --copy` makes a frozen snapshot instead of live symlinks; it never overwrites assets you already have.

## Start a project (per-project seed)

```bash
~/agentic-base-layer/bin/new-project.sh ~/projects/my-app my-app
```

Drops a `CLAUDE.md` seed + knowledge/docs scaffold into the project (and `git init`s it). Fill in the `«PLACEHOLDERS»`, then build with `/wake-up → /feature → /wrap-up`. The base repo never changes from project work.

---

## What's global vs project-wise

| | **Global** (`global/`, installed everywhere) | **Project-wise** (`project-seed/`, per project) |
|---|---|---|
| Agents, skills, commands | ✅ the reusable roster + toolkit | a project's *own* domain asset (rare) |
| `CLAUDE.md` | — | ✅ this project's invariants, stack, gotchas |
| `knowledge/REGISTRY.md` | — | ✅ this project's own lessons |
| `docs/STATUS.md`, rules, settings | — | ✅ project state & config |

---

## What's in the box

```
agentic-base-layer/
├── install.sh                 ← global install (symlink/copy into ~/.claude)
├── bin/new-project.sh         ← per-project scaffold
├── global/                    ←★ THE ENGINE (installed everywhere)
│   ├── agents/                · roster (universal · SDLC spine · on-demand domain) — see agents/README.md
│   ├── skills/                · lifecycle (advise, retrospect, cleanup, station, wrap-up, …)
│   │                            + authoring toolkit (create-agent-skills, create-subagents,
│   │                            create-slash-commands, create-hooks, create-meta-prompts,
│   │                            create-plans, debug-like-expert)
│   ├── commands/              · lifecycle + thin wrappers + consider/ (12 mental models)
│   ├── WORKFLOW.md            · the task lifecycle + Loop Recovery Protocol
│   └── CONTEXT-PASSING.md     · the 4-field sub-agent handoff
├── project-seed/              ←★ PER-PROJECT STARTER (copied into each project)
│   ├── CLAUDE.md              · the seed to fill in
│   ├── .claude/{knowledge,rules,hooks,templates,settings.example.jsonc}
│   └── docs/STATUS.md
└── meta/                      ← about the framework (SCORING · GAPS · REFERENCE · presentation)
```

---

## The two ideas behind every choice

**① Context is finite.** CLAUDE.md loads every turn (keep it < 200 lines); skills load only when triggered (progressive disclosure); subagents get their own context window; the 4-field handoff passes ~50–100 tokens, not 1,000-line dumps.

**② Prose suggests; hooks enforce.** CLAUDE.md *shapes* behavior; it isn't enforcement. Where a rule must hold — secret scanning, formatting, gates — use a **hook** (only exit code 2 blocks) or a script-enforced gate.

## Authoring more

The toolkit builds itself: `/create-subagent`, `/create-agent-skill`, `/create-slash-command`, `/create-hook`, `/create-plan`, `/debug`. Each is a thin command over a full router skill in `global/skills/`.

## License
MIT. See `meta/` for the rationale, scoring, and the developer presentation.
