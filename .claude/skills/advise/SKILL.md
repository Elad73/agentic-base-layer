---
name: advise
description: Pre-task knowledge retrieval. Surfaces relevant patterns, pitfalls, architecture decisions, and prior learnings from the project knowledge base BEFORE non-trivial work begins. Use this when about to implement a feature, fix a bug, refactor, touch the database, or change auth/security — anything where past mistakes or established patterns matter. Auto-fires; emits a short PRE-TASK ADVISORY so the upcoming work reuses what is already known.
disable-model-invocation: false
---

# advise — Pre-Task Knowledge Advisor

Search the project knowledge base and surface relevant context before work begins. This is advisory and read-only; it never edits files.

**Usage:** `/advise` (then describe what you are about to do)

---

## Phase 1: Classify the Task

Analyze the request along three axes:

1. **Task type** — API/route, UI surface, background job, data model/migration, auth, config, infra/deploy?
2. **Technologies** — which parts of the stack are touched? (use the project's «STACK» — e.g. web framework, ORM, auth provider, hosting)
3. **Domain** — which feature area or bounded context does this fall under?

## Phase 2: Search Knowledge

Run these in parallel; tolerate missing files.

### 2.1 Project state
```bash
# Current status (path may be docs/STATUS.md or docs/status/STATUS.md)
cat docs/STATUS.md 2>/dev/null | head -40 || cat docs/status/STATUS.md 2>/dev/null | head -40

# Recent context
git log --oneline -10

# Open issues, if the project uses a tracker
gh issue list --state open --json number,title --limit 5 2>/dev/null
```

### 2.2 Knowledge registry
```bash
cat .claude/knowledge/REGISTRY.md 2>/dev/null
```
Scan for entries (K-PAT / K-PIT / K-ARC / K-PRF / K-SEC) whose domain/technology tags match the classified task. Open any referenced detail files that are clearly on-topic.

### 2.3 Match to architecture
Build a small table mapping the affected domain(s) to the key files and patterns you found. Example shape:

| Domain | Key Files | Patterns / Pitfalls |
|--------|-----------|---------------------|
| «domain» | «path/to/file» | «registry entry IDs that apply» |

## Phase 3: Emit the Advisory

Keep it short. Only include sections that have real content — skip empty ones rather than padding.

```
PRE-TASK ADVISORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TASK: [one-line description]
TYPE: [API | UI | Job | Data | Auth | Config | Infra]
DOMAINS: [affected areas]

RELEVANT KNOWLEDGE
- [K-PAT/K-PIT/K-ARC entry — one line each, cite the ID]

KEY FILES
- [path]: [why it is relevant]

WARNINGS
- [known pitfall to watch for, ideally citing a K-PIT entry]
- [security consideration if auth/secrets/user-input are involved]

SUGGESTED APPROACH
1. [high-level step]
2. [high-level step]
```

## Rules

1. Read-only. Never edit, commit, or run side-effecting commands.
2. Cite registry IDs so the user can trace advice to its source.
3. Prefer signal over volume — 3 sharp warnings beat 15 generic ones.
4. If the registry is empty or has no matching entries, say so plainly and advise the user to capture learnings via `/retrospect` after the work.
5. Always flag security-sensitive surfaces (auth, secrets, raw user input, migrations) even if no registry entry exists yet.
