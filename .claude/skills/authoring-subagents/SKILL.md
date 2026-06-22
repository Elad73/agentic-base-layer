---
name: authoring-subagents
description: Guide for authoring and managing Claude Code subagents. Use when creating a new subagent, choosing its tools/model/permissions, writing trigger-rich descriptions, deciding when to delegate vs do work inline, or troubleshooting why an agent isn't selected or behaves wrong.
allowed-tools: Read, Grep, Glob
---

# Authoring Subagents

Subagents are specialized assistants the main agent **delegates** tasks to. The defining trait: each subagent runs in its **own context window**, separate from the main conversation. It does NOT see the conversation history. This single fact drives every design decision below.

## File Structure

Subagents are **flat Markdown files** (NOT directories) with YAML frontmatter:

| Scope | Path |
|-------|------|
| Project | `.claude/agents/<name>.md` |
| User (all projects) | `~/.claude/agents/<name>.md` |
| Plugin | the plugin's `agents/` directory |

```markdown
---
name: code-reviewer
description: Reviews a diff for quality and security after implementation. Use proactively before tests.
tools: Read, Grep, Glob
model: sonnet
---

System prompt: the agent's role, procedure, and output format.
```

## Frontmatter Fields

| Field | Required | Notes |
|-------|----------|-------|
| `name` | Yes | Lowercase-hyphen, unique in scope (e.g. `test-engineer`). Use a ROLE, not a persona. |
| `description` | Yes | Third-person, trigger-rich. Says WHAT it does AND WHEN to invoke. The discovery field — add "use proactively" where the agent should fire unprompted. |
| `tools` | No | Comma-separated allowlist. **Omit to grant ALL tools.** |
| `model` | No | `sonnet` · `opus` · `haiku` · `inherit`. Use `inherit` unless there's a reason. Pin ids: `claude-opus-4-8`, `claude-sonnet-4-6`, `claude-haiku-4-5`. |
| `permissionMode` | No | `default` · `acceptEdits` · `bypassPermissions` · `plan`. |
| `color` | No | UI hint. |

## The Core Constraint: Isolated Context

A subagent starts cold. It cannot ask you a clarifying question mid-run and cannot read what came before. Therefore:

> **The first invocation must carry everything.** Every file path, task id, constraint, and convention the agent needs goes into the prompt up front. No mid-run clarification is possible.

Design each agent's system prompt to be self-sufficient: state its role, what it must NOT do, the procedure, and the exact output format.

## Design Principles

1. **Single responsibility** — one focused job per agent. "Review security" beats "review everything."
2. **Least-privilege tools** — grant only what the job needs.
   - Read-only reviewers: `Read, Grep, Glob` (+ `WebFetch, WebSearch` if research helps). They must state they NEVER modify code or change status and return a structured BRIEF.
   - Implementers: `Read, Edit, Write, Bash, Grep, Glob`.
3. **Trigger-rich description** — this is how the agent gets selected. Be specific about the signals that should invoke it.
4. **Structured output** — define the return shape (e.g. IDed findings `CR-001` with severity, file:line, fix) so the caller can act on it mechanically.

## When to Delegate

Delegate to a subagent when:
- A task spans **10+ files** or is large enough to pollute the main context.
- There are **3+ independent pieces** that can run in parallel.
- The work is a **specialized, repeatable role** (review, test, security scan).
- You want a clean isolated context for a focused result.

Do NOT delegate trivial one-step work — the spin-up cost isn't worth it.

### Parallelism rule

You can run independent agents concurrently. **Never parallelize two agents that write the same file** — isolated contexts can't see each other's edits and will clobber one another. Parallel reviewers (read-only) are safe; parallel writers on disjoint files are safe; parallel writers on the same file are a bug.

## Agents vs Skills

| Aspect | Subagents | Skills |
|--------|-----------|--------|
| Structure | Flat `.md` file in `.claude/agents/` | Directory with `SKILL.md` in `.claude/skills/` |
| Context | **Own** isolated context window | Loaded into the **current** context |
| Sees conversation history | No | Yes |
| Invocation | Delegated as a task | Auto-loaded when its description matches |
| Purpose | Do a specialized job and return a result | Inject expertise/instructions into the current agent |
| Frontmatter tool field | `tools` (omit = all) | `allowed-tools` |

Rule of thumb: reach for a **skill** to teach the current agent how to do something; reach for a **subagent** to hand a self-contained job to a fresh worker.

## Troubleshooting

- **Agent not found:** confirm a `.md` file in `.claude/agents/` (not a directory).
- **Wrong/no agent selected:** sharpen the `description` triggers; remove overlap with other agents.
- **Agent missing context:** you didn't front-load it — the agent can't see your history.
- **Edits clobbered:** two agents wrote the same file in parallel; serialize them.

Manage interactively with `/agents`, or edit the files directly.
