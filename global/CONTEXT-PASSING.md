# Context Passing Between Agents

The canonical handoff format for multi-agent workflows. Keep it tight: a good handoff is **~50–100 tokens**, names **exact files (not directories)**, and carries **one task**.

---

## The 4-Field Handoff

```markdown
## Handoff: <source role> → <target role>

**Task:** <one line — exactly what to do>

**Files:** <the specific files to read/modify — not directories>
- path/to/file1.ts
- path/to/file2.ts

**Context:** <2–3 sentences max — what's done, key decisions, relevant state>

**Constraints:** <non-negotiables — patterns to follow, things to avoid>
- constraint 1
- constraint 2
```

Four fields, always in this order. If you can't fill `Constraints`, you probably haven't scoped the task.

---

## When to Use / When to Skip

| Use a 4-field handoff | Skip it (inline is fine) |
|-----------------------|--------------------------|
| Crossing into a fresh sub-agent context | Continuing in the same context |
| Phase transition (build → review → test) | A trivial one-liner with no ambiguity |
| Spawning a domain sub-reviewer | Read-only question you can answer yourself |
| Resuming work after a break | The target already has full context loaded |
| Delegating one isolated task | A multi-task batch (split it into separate handoffs instead) |

---

## Examples

### orchestrator → developer
```markdown
## Handoff: orchestrator → developer

**Task:** Implement OAuth2 login per FT-014.

**Files:**
- lib/auth/oauth.ts (create)
- app/api/auth/route.ts (create)
- «schema file» (modify User model)

**Context:** User needs Google OAuth. Auth library chosen per project standards; User table exists and needs an accounts relation.

**Constraints:** Use the existing DB client; follow «PROJECT-PATTERNS»; no client-side auth state (cookies only).
```

### developer → security-reviewer
```markdown
## Handoff: developer → security-reviewer

**Task:** Security review before merge.

**Files:**
- lib/auth/oauth.ts
- app/api/auth/route.ts

**Context:** OAuth2 implemented with session handling and DB persistence. Ready for the security gate.

**Constraints:** Check for credential leaks; verify CSRF protection; confirm secure cookie settings.
```

### code-reviewer → database-reviewer
```markdown
## Handoff: code-reviewer → database-reviewer

**Task:** Review the schema changes for the auth feature.

**Files:**
- «schema file» (lines 15–45)
- lib/db/queries/user.ts

**Context:** Added Account + Session models with cascade deletes and an email index.

**Constraints:** Check N+1 risk; verify index strategy; ensure backward compatibility.
```

---

## The 5 Anti-Patterns

### 1. Too vague
```markdown
**Task:** Review the code
**Files:** All of them
**Context:** I made some changes
```
No target, no scope — the agent re-derives everything (expensive) or guesses (wrong).

### 2. Too verbose
```markdown
**Context:** [three paragraphs of history, alternatives considered, unrelated background…]
```
Burns tokens and buries the signal. Cap context at 2–3 sentences.

### 3. Missing constraints
```markdown
**Task:** Implement feature
**Files:** feature.ts
**Context:** Add the new feature
```
No patterns to follow, nothing to avoid → the agent invents conventions that clash with the codebase.

### 4. Directory instead of files
```markdown
**Files:** src/
```
Forces the agent to scan a whole tree. Name the exact files (and line ranges when you can).

### 5. Full conversation dump
```markdown
**Context:** [pastes the entire prior conversation]
```
The opposite of a handoff. Extract the 2–3 sentences that matter; drop the rest.

---

## Best Practices

1. **Specific** — exact files + line ranges, one clear task.
2. **Concise** — context in 2–3 sentences; remove the obvious.
3. **Complete** — every constraint the target needs, no more.
4. **Actionable** — it's clear what "done" looks like.
