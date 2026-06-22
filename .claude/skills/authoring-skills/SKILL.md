---
name: authoring-skills
description: Guide for authoring and refining Claude Code Agent Skills. Use when creating a new skill, writing or improving a SKILL.md, crafting the discovery description, structuring progressive disclosure and bundled files, building evals, or troubleshooting why a skill isn't triggered.
allowed-tools: Read, Grep, Glob
---

# Authoring Skills

A Skill packages reusable expertise the agent can discover and load on demand. The defining trait: skills are **model-invoked** — Claude autonomously decides when to use one based on its description and the current task. (Contrast: slash commands are **user-invoked**.) A skill loads into the **current** context window; it sees the conversation and teaches the current agent how to do something.

## File Structure

Skills are **directories** containing a required `SKILL.md`, plus optional bundled files:

```
my-skill/
├── SKILL.md          (required)
├── reference.md      (optional, loaded on demand)
├── examples.md       (optional)
└── scripts/
    └── helper.py     (optional)
```

| Scope | Path |
|-------|------|
| Project | `.claude/skills/<name>/SKILL.md` |
| User (all projects) | `~/.claude/skills/<name>/SKILL.md` |
| Plugin | the plugin's `skills/` directory |

## Frontmatter

```yaml
---
name: your-skill-name           # lowercase/hyphens/numbers, ≤ 64 chars
description: What it does AND when to use it.   # ≤ 1024 chars — the discovery field
allowed-tools: Read, Grep, Glob # optional; restricts tools while active
---
```

- **`name`** ≤ 64 chars, lowercase letters, numbers, hyphens.
- **`description`** ≤ 1024 chars. **This is the most important field** — it alone decides whether the skill is discovered. Write it in the **third person**, stating both WHAT the skill does and WHEN to use it, with specific trigger terms.

```yaml
# Good — what + when, specific triggers
description: Extract text from PDFs, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
# Bad — vague, no triggers
description: Helps with documents
```

## Progressive Disclosure (3-level loading)

Skills stay cheap because content loads in three stages:

1. **Metadata (always loaded, ~100 tokens):** just `name` + `description` from every skill's frontmatter. This is the permanent footprint — keep descriptions tight.
2. **SKILL.md body (loaded when triggered):** the instructions. Keep the body **under ~500 lines**.
3. **Bundled files (loaded on demand):** reference docs, examples, and scripts are read only when the body points Claude to them.

Push detail into level-3 files and reference them from the body, so the common path stays lean.

## Build Evals First

> **Write 3+ evals before writing the skill.** Define concrete prompts that should trigger the skill and the outcomes that count as success. Evals turn "seems good" into a measurable target and catch description drift and regressions as you iterate.

## The Four Craft Principles

1. **Focus** — one capability per skill. "Git commit messages" is a skill; "Document processing" is too broad. Split broad ideas into several focused skills.
2. **Trigger-rich descriptions** — discovery is everything; load the description with the words and situations that should fire it.
3. **Progressive disclosure** — front-load only what's always needed; defer the rest to bundled files.
4. **Right altitude** — aim for actionable mid-altitude guidance.
   - Too low: hardcoded values, exact pixel/hex constants, brittle step-by-step that ignores context.
   - Too high: vague guidance that assumes shared context the agent doesn't have.
   - Right: concrete, reusable instructions Claude can apply across cases.

## Skills vs Subagents

| Aspect | Skills | Subagents |
|--------|--------|-----------|
| Structure | Directory with `SKILL.md` in `.claude/skills/` | Flat `.md` file in `.claude/agents/` |
| Context | Loaded into the **current** context | Runs in its **own** isolated context |
| Sees conversation history | Yes | No |
| Invocation | Auto-loaded when the description matches | Delegated as a self-contained task |
| Purpose | Teach the current agent how to do something | Hand a focused job to a fresh worker |
| Tool field | `allowed-tools` | `tools` (omit = all) |

Rule of thumb: use a **skill** to inject expertise into the agent you're already talking to; use a **subagent** when a job deserves its own isolated context and a returned result.

## Troubleshooting

- **Skill never triggers:** weak `description` — add specific what + when triggers; verify the YAML (`---` fences, no tabs).
- **Wrong skill among several:** make trigger terms distinct across skills.
- **Body too heavy:** move detail into bundled files and reference them.
- **Location:** must be `.claude/skills/<name>/SKILL.md` (or the user/plugin equivalent).

## Key Takeaways

1. The **description** determines discovery — invest there.
2. **Progressive disclosure** keeps the always-on cost near zero.
3. **Evals first** make quality measurable.
4. One focused capability, at the right altitude, beats a sprawling catch-all.
