# Agentic Base Layer — Authoritative Reference Brief

Facts behind the framework, verified against official Anthropic documentation (June 2026). Every section cites its source. Use this as the citation backbone for the presentation.

---

## 1. Agent Skills

**Definition.** Modular capabilities packaged as a *directory* with a required `SKILL.md` (YAML frontmatter + Markdown body) plus optional bundled files (reference docs, templates, scripts). **Model-invoked** — Claude autonomously decides when to use a skill from its `description`; this differs from slash-commands, which are *user-invoked*.

**`SKILL.md` frontmatter (all optional; only `description` is truly needed):**

| Field | Limit / values | Behavior |
|---|---|---|
| `name` | ≤64 chars, lowercase/numbers/hyphens; no "anthropic"/"claude"/XML | Display name; directory name used if omitted. |
| `description` | ≤1024 chars (≤1536 with `when_to_use`) | **The critical discovery field.** Must state WHAT it does AND WHEN to use it, in third person. |
| `disable-model-invocation` | boolean | `true` = user-invocable only; prevents preloading into subagents. Use for side-effecting skills (deploy/commit). |
| `user-invocable` | default `true` | `false` = hidden from `/` menu; Claude-only. |
| `allowed-tools` | space/comma list | Grants tools without per-use approval while skill active. (Skills use `allowed-tools`; **subagents use `tools`** — a real naming difference.) |
| `model` / `effort` | model id / `low…max` | Override for this skill; does not persist after the turn. |
| `context: fork` + `agent` | `Explore`/`Plan`/`general-purpose`/custom | Run the skill in an isolated subagent context. |
| `paths` | globs | Skill auto-loads only when Claude works with matching files. |
| `argument-hint` / `arguments` | — | Autocomplete + `$name` substitution. |

**Progressive disclosure — the 3-level loading model (the central mechanism):**

| Level | When loaded | Cost |
|---|---|---|
| 1 — Metadata (`name`+`description`) | **Always**, at startup | ~100 tokens/skill |
| 2 — `SKILL.md` body | When the skill triggers | keep <5,000 tokens (<500 lines) |
| 3 — Bundled files/scripts | Only when referenced/run | ~0 until used (scripts execute without source entering context) |

**Best practices.** Keep the body <500 lines (*"The context window is a public good"*; *"Default assumption: Claude is already very smart"*). Trigger-rich descriptions (good: *"Extract text from PDF files, fill forms… Use when working with PDFs, forms, or document extraction"*; bad: *"Helps with documents"*). One capability per skill. **Build 3+ evals before writing the docs.** Don't put recurring procedures in CLAUDE.md — move them to skills (load only when needed). Don't use reserved names or deeply nested references.

*Sources:* platform.claude.com/docs/en/agents-and-tools/agent-skills/overview · /agent-skills/best-practices · code.claude.com/docs/en/skills · anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills

---

## 2. Subagents

**Definition.** *"Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions… It does not see your conversation history."* Flat Markdown files (NOT directories) in `.claude/agents/` (project) or `~/.claude/agents/` (user). Frontmatter: `name`, `description`, `tools` (omit = all tools), `model` (`sonnet|opus|haiku|inherit`), `permissionMode`. The spawning tool was renamed `Task`→`Agent` (v2.1.63; `Task` still aliases).

**When to delegate (the rule of thumb):** *"When a task requires exploring ten or more files, or involves three or more independent pieces of work, that's a strong signal to direct Claude toward subagents."* **Stay in the main thread** for tightly-sequential/iterative work and latency-sensitive edits.

**DO:** one job per agent; least-privilege tools (read-only reviewers get `Read, Grep, Glob`); isolate verbose work so only a summary returns (explore for tens of thousands of tokens, return 1–2k); write the `description` around **trigger conditions** + "use proactively". **DON'T:** parallelize agents that write the same file (*"a recipe for conflict"*); expect mid-run clarification — *"the first invocation has to carry everything it needs… most sub-agent failures aren't execution failures, they're invocation failures."*

*Sources:* code.claude.com/docs/en/sub-agents · claude.com/blog/subagents-in-claude-code

---

## 3. CLAUDE.md (memory)

**Loaded in full every session** and competes with the task for attention. *"Keep it concise. For each line, ask: 'Would removing this cause Claude to make mistakes?' If not, cut it. Bloated CLAUDE.md files cause Claude to ignore your actual instructions!"* Official target: **under 200 lines** ("Files over 200 lines consume more context and may reduce adherence").

**Hierarchy (broad → specific; specific loads later = higher priority):** enterprise managed → `~/.claude/CLAUDE.md` (user) → `./CLAUDE.md` (project, git) → `./CLAUDE.local.md` (gitignored) → subdirectory files (load **on demand**).

**DO:** `/init` then prune; concrete/testable rules ("2-space indent", not "format properly"); include only what Claude can't infer (non-default commands, gotchas, etiquette); reserve `IMPORTANT`/`YOU MUST` for the few critical rules. **DON'T:** include readable-from-code facts, standard conventions, full API docs, frequently-changing info, or mark everything important (*"If everything is marked IMPORTANT, nothing is."*).

**Imports:** `@path/to/file` (max 4 hops) — but *"imported files load at launch, so @imports help organization, not context size."* For real token savings use path-scoped `.claude/rules/`. For real enforcement use a **hook** — *"CLAUDE.md instructions shape behavior but are not a hard enforcement layer."*

*Sources:* code.claude.com/docs/en/best-practices · /memory

---

## 4. Hooks (the enforcement layer)

*"User-defined shell commands, HTTP endpoints, or LLM prompts that execute automatically at specific points in Claude Code's lifecycle."* They give **deterministic control** — the harness, not the model, runs them.

**Events (classic 9):** SessionStart, UserPromptSubmit, PreToolUse (block calls — the main guardrail), PostToolUse, Notification, Stop, SubagentStop, SessionEnd, PreCompact. (Live docs add more.) Config in `settings.json`, three-level (event → matcher → handlers).

**THE critical gotcha:** *"only exit code 2 blocks the action. Claude Code treats exit code 1 as a non-blocking error and proceeds."* PreToolUse can alternatively return JSON `permissionDecision: allow/deny/ask`. **Security:** *"hooks run with your user permissions and have access to your credentials"* — review hooks from cloned repos before enabling.

*Sources:* code.claude.com/docs/en/hooks

---

## 5. Context windows & management

**Context is finite.** *"Context must be treated as a finite resource with diminishing marginal returns."* LLMs have an *"attention budget"*; goal is *"the smallest possible set of high-signal tokens."* **Context rot:** accuracy/recall degrade as token count grows, *even with large windows* — it's about what's in context, not space available.

**What fills context (load order):** system prompt → CLAUDE.md (all levels) → path-scoped rules → auto-memory (first 200 lines/25KB of MEMORY.md) → **skill descriptions (all)** → conversation history → tool-result blocks → thinking blocks → current message → response.

**Model windows (2026):** Opus 4.8 / Sonnet 4.6 = **1M** tokens, 128k max output; Sonnet 4.5 / Haiku 4.5 = 200k, 64k. Sonnet 4.6+/Haiku 4.5+ get real-time **token-budget awareness** after each tool call.

**Management ladder:** ① prompt caching (cache write +25%, read −90%, breakeven at 2 requests) → ② **tool search** when >20 tools (defer tool defs, +1 latency turn) → ③ **context editing** (remove stale `tool_result` blocks) → ④ **programmatic tool calling** (Claude writes a script; intermediate results never enter history — one Anthropic example went 150k → 2k tokens, **98.7%** reduction) → server-side **compaction** for long sessions.

*Sources:* platform.claude.com/docs/en/build-with-claude/context-windows · /agents-and-tools/tool-use/manage-tool-context · anthropic.com/engineering/effective-context-engineering-for-ai-agents

---

## 6. Effort & reasoning control

`output_config.effort` controls thoroughness without changing the cached system prompt. Levels: `low` (fastest) · `medium` · `high` · `xhigh` (max documented) · `max` (maps to xhigh on most models). **No hidden levels above `xhigh`.** Effort is **orthogonal to extended thinking** and applies to the primary agent *and* its subagents (token usage multiplies). Mid-conversation system *messages* (sent as user turns, not the cached `system` field) can toggle modes like orchestration on/off without busting the prompt cache; refresh the directive ~every 10 turns so it isn't "forgotten".

*Source:* platform.claude.com/docs/en/build-with-claude/mid-conversation-effort-example

---

## 7. Managed agents & webhooks (API-side, for future automation)

**Managed Agent** = a reusable, versioned config (model, system, tools, MCP servers, skills) created once and referenced by ID across sessions (beta header `managed-agents-2026-04-01`). Required: `name`, `model`. Updates are **versioned** and require the current `version` (optimistic concurrency); arrays (`tools`/`skills`/`mcp_servers`) are fully replaced, `metadata` merges per-key. A `multiagent.agents` roster makes an agent a **coordinator** that delegates to other (versioned) agents.

**Webhooks** notify you of session state changes without polling (HTTPS POST, `whsec_`-signed). Events include `session.status_run_started/idled/terminated`, `session.thread_*` (multiagent), `vault.*`. Each event carries only `type`+`id`; you GET the full object. Verify with `client.beta.webhooks.unwrap()`; return any 2xx to ack; ~20 consecutive failures auto-disable the endpoint; no ordering guarantee (sort by `created_at`).

*Sources:* platform.claude.com/docs/en/managed-agents/agent-setup · /managed-agents/webhooks

---

## 8. Context engineering & agent design principles (the philosophy)

- **Right altitude** — *"the Goldilocks zone"*: specific enough to guide, flexible enough to give the model strong heuristics. Not brittle hardcoded logic, not vague hand-waving.
- **Simple-first** — *"find the simplest solution possible, and only increase complexity when it demonstrably improves outcomes."*
- **The agent loop** — agents are *"LLMs using tools based on environmental feedback in a loop"*; ground truth comes from the environment each step (give Claude a pass/fail check and the loop closes itself).
- **Workflows vs agents** — workflows orchestrate through predefined code paths (deterministic); agents direct their own process (flexible, but latency/cost/compounding-error trade-offs).
- **Evals before optimizing** — start with ~20 real queries; LLM-judge on a rubric + human spot-checks.
- **Tools are a contract** between deterministic systems and a non-deterministic agent — consolidate, namespace, return high-signal results, *"poka-yoke your tools."*

*Sources:* anthropic.com/engineering/{effective-context-engineering-for-ai-agents, building-effective-agents, writing-tools-for-agents} · code.claude.com/docs/en/best-practices

---

## 9. Naming the category

"Framework" has two unrelated meanings: runtime/orchestration libraries (LangChain, CrewAI — *not* this) vs. config/convention layers shaping an existing harness (*this*). The accurate category is a **personal Claude Code base layer / "AI dotfiles"** (precedent: `zircote/.claude`; Jesse Vincent's **Superpowers**, distributed as a Claude Code plugin + marketplace). Adopt the **AGENTS.md** standard (Linux Foundation, 60k+ repos) for cross-tool interop. Avoid "Agent OS" (product collision), "agentic framework" (library collision), "harness" (Claude Code is the harness).
