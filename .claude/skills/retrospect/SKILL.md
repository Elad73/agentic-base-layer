---
name: retrospect
description: Post-session learning capture. Mines the current conversation for reusable patterns, pitfalls, architecture decisions, performance and security insights, then appends them to the project knowledge registry. Use this at the end of a working session, after a bug is fixed, or after a non-obvious decision is made — so the next session starts smarter. Writes structured entries to .claude/knowledge/REGISTRY.md.
---

# retrospect — Session Knowledge Extraction

Analyze the session and capture durable knowledge while context is fresh.

**Usage:** `/retrospect`

---

## Phase 1: Session Analysis

Review the entire conversation and identify:

1. **What was accomplished** — features, fixes, PRs.
2. **What worked** — effective approaches worth repeating.
3. **What didn't** — failed attempts, bugs hit, rework needed.
4. **Key decisions** — choices made and the trade-offs accepted.
5. **Root causes** — the underlying reason behind any bug, not just the symptom.

## Phase 2: Extract & Classify

For each significant, non-obvious insight, assign a category:

| Category | Code | Captures |
|----------|------|----------|
| Pattern | K-PAT | A reusable approach that worked |
| Pitfall | K-PIT | A gotcha to avoid, with the avoidance |
| Architecture | K-ARC | A design decision and its rationale |
| Performance | K-PRF | An optimization or cost insight |
| Security | K-SEC | A security consideration |

Skip the obvious. Capture only what a competent engineer would NOT already know walking in.

### Entry schema
```markdown
## K-XXX-NNN: [Title]

**Category**: [Pattern|Pitfall|Architecture|Performance|Security]
**Created**: YYYY-MM-DD
**Domain**: [feature area / technology tags]

### Context
The situation that led to this learning.

### Learning
The concise, actionable insight.

### Application
How to apply it next time (concrete, not abstract).

### Metric
A falsifiable signal that proves this matters — e.g. "shipped to prod 3x before caught", "cut p95 from 800ms to 120ms", "removed 2 round-trips per request". If you cannot state a metric, the entry is probably not worth recording.
```

## Phase 3: Save to Registry

```bash
# Read existing entries to find the next free ID per namespace
cat .claude/knowledge/REGISTRY.md 2>/dev/null
```

For each entry: pick the next sequential ID within its namespace (K-PAT-001, K-PAT-002, …), append the entry body, and add a row to the matching category index table plus the relevant By-Technology / By-Domain / By-Skill cross-reference lists at the top of the registry. If the registry file does not exist, create it from the scaffold before appending.

## Phase 4: Output Summary

```
SESSION RETROSPECTIVE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FOCUS: [main topic]
OUTCOME: [success | partial | blocked]

KNOWLEDGE EXTRACTED
- Patterns: N   Pitfalls: N   Architecture: N   Perf: N   Security: N

KEY INSIGHTS
1. [most important, cite new ID]
2. [...]

MISTAKES & CORRECTIONS
| Mistake | Correction | Prevention |
|---------|-----------|------------|
| [issue] | [fix] | [how to avoid next time] |

NEXT SESSION
- [what to do next / what to watch]
```

## Quality Rules

1. **Actionable** — "do X to avoid Y", never "learned about X".
2. **Falsifiable metric** — every entry carries a concrete signal of impact.
3. **Standalone** — readable months later with zero session context.
4. **Tagged** — domain/technology tags so `/advise` can find it.
5. **No secrets** — never paste keys, tokens, or credentials into the registry.
