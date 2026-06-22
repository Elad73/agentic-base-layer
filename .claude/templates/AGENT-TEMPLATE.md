---
# Lowercase-hyphen role name (NOT a persona). e.g. code-reviewer, test-engineer
name: agent-name
# Trigger-rich, third person, says WHEN to invoke. Add "Use proactively"
# where the agent should fire without being asked. This field is how the
# orchestrator/main agent discovers and selects this agent — make it specific.
description: Reviews/implements/… <what> when <trigger conditions>. Use proactively when <signal>.
# Least privilege. Omit this line entirely to grant ALL tools.
#   Read-only reviewers: Read, Grep, Glob  (+ WebFetch, WebSearch if research helps)
#   Implementers:        Read, Edit, Write, Bash, Grep, Glob
tools: Read, Grep, Glob
# sonnet | opus | haiku | inherit. Use `inherit` unless there's a reason.
# Current model ids if you pin: claude-opus-4-8, claude-sonnet-4-6, claude-haiku-4-5.
model: inherit
# Optional. default | acceptEdits | bypassPermissions | plan
# permissionMode: default
# Optional UI hint.
color: blue
---

# Agent Name

> Role: «Role» · Phase: «When active»

**Mission:** One sentence capturing this agent's core purpose.

## Role & Mission

What this agent owns and, just as important, what it does NOT do. Each agent runs
in its OWN context window and sees none of the main conversation — so state any
assumptions explicitly. Read-only reviewers must say plainly: "I NEVER modify code
and I NEVER change task status; I return a findings BRIEF." Implementers do the work.

## When to Invoke

- Trigger 1 — the concrete situation that should call this agent.
- Trigger 2 — another scenario.
- Trigger 3 — a third scenario.

## Core Responsibilities

1. **Responsibility** — what it covers and the expected outcome.
2. **Responsibility** — …
3. **Responsibility** — …

## Procedure

1. Read the inputs / task / context first.
2. Do the work, step by step.
3. Verify.
4. Hand off (transition status if you own it, or return your BRIEF if read-only).

Use «PLACEHOLDER» tokens for anything project-specific (commands, paths, stacks).
No hardcoded absolute paths, no assumed framework.

## Output Format

Define the exact shape of what this agent returns. For reviewers, use IDed findings:

```
<AGENT> BRIEF   ·   Verdict: APPROVE | CHANGES REQUESTED

[XX-001] HIGH  path/to/file.ext:42
  Issue: <what's wrong>
  Fix:   <concrete remedy>
```

For implementers/orchestrators, summarize what was done and the resulting status.

## Checklist

- [ ] Read context before acting
- [ ] Core responsibilities covered
- [ ] Output matches the format above
- [ ] (Reviewers) No code modified, no status changed — BRIEF only
- [ ] (Implementers) Verification run and green before handoff

## Philosophy

"A short, relevant quote that captures this agent's stance." — Attribution
