# Knowledge Registry

Central index of accumulated learnings, patterns, and pitfalls for this project. This file is the project's durable memory: `/advise` reads it before work, `/retrospect` appends to it after.

**Last Updated**: 2026-06-22

## How to Use This Registry

1. **Before starting work** — run `/advise`; it searches this registry for relevant entries.
2. **After completing work** — run `/retrospect`; it appends new entries automatically.
3. **When stuck** — scan the Pitfalls (K-PIT) section first.

## ID Namespaces

| Code | Namespace | Captures |
|------|-----------|----------|
| K-PAT | Patterns | Reusable approaches that worked |
| K-PIT | Pitfalls | Gotchas to avoid, with the avoidance |
| K-ARC | Architecture | Design decisions and their rationale |
| K-PRF | Performance | Optimization / cost insights |
| K-SEC | Security | Security considerations |

IDs are sequential within each namespace: `K-PAT-001`, `K-PAT-002`, …

## Entry Schema

```markdown
## K-XXX-NNN: Title

**Category**: [Pattern|Pitfall|Architecture|Performance|Security]
**Created**: YYYY-MM-DD
**Domain**: [feature area / technology tags]

### Context
The situation that led to this learning.

### Learning
The concise, actionable insight.

### Application
How to apply it next time (concrete).

### Metric
A falsifiable signal of impact (e.g. "caught a bug shipped to prod 3x", "cut p95 by 6x"). No metric → probably not worth recording.
```

---

## Index

### Patterns (K-PAT)
| Entry | Summary |
|-------|---------|
| K-PAT-001 | 4-field sub-agent handoff contract |

### Pitfalls (K-PIT)
| Entry | Summary |
|-------|---------|
| K-PIT-001 | Secrets in env only; never hardcode or commit |

### Architecture (K-ARC)
| Entry | Summary |
|-------|---------|
| K-ARC-001 | Pure-core / adapter separation |

### Performance (K-PRF)
| Entry | Summary |
|-------|---------|
| _(none yet)_ | |

### Security (K-SEC)
| Entry | Summary |
|-------|---------|
| _(none yet)_ | |

---

## Cross-Reference

### By Technology
- _«technology»_: K-XXX-NNN, …

### By Domain
- _«domain»_: K-XXX-NNN, …

### By Skill
- _«skill-name»_: K-XXX-NNN, …

---

## Entries

## K-PAT-001: 4-field sub-agent handoff contract

**Category**: Pattern
**Created**: 2026-06-22
**Domain**: orchestration, multi-agent

### Context
A parent agent delegates a unit of work to a sub-agent and needs a reliable, lossless handoff that the parent can act on without re-reading the sub-agent's working files.

### Learning
Constrain every handoff to four fields (the canonical contract in `global/CONTEXT-PASSING.md`): **Task** (the single outcome wanted, 1–2 sentences), **Files** (exact paths the sub-agent may rely on — never directories), **Context** (why this matters / what changed, 2–3 sentences), and **Constraints** (hard rules, never-dos, the return shape expected). Target ~50–100 tokens. The sub-agent's final message is the only thing the parent reads, so it must be self-contained.

### Application
When spawning a sub-agent, write the prompt as those four labeled fields (Task / Files / Context / Constraints). Demand the result as a compact manifest/verdict and forbid dumping intermediate file contents back to the parent.

### Metric
Eliminates re-reading of sub-agent scratch files; parent acts on one message instead of re-deriving context — measured as zero follow-up "what did you actually change?" round-trips.

## K-PIT-001: Secrets in env only; never hardcode or commit

**Category**: Pitfall
**Created**: 2026-06-22
**Domain**: security, configuration

### Context
A key/token is needed at runtime and the quickest path is to paste it into source, a config file, or a committed `.env`. It works locally and then leaks via git history or a shared doc.

### Learning
Load every secret from the environment («`process.env.X`, `os.environ["X"]`, or the project's secret manager») and read it through a single typed config module. Keep `.env*`, `*.pem`, `*.key`, and `credentials*` in `.gitignore`. Commit a `.env.example` with keys but no values. Run a secret grep before every commit (the `wrap-up` / `document` skills do this).

### Application
Before committing, run `git diff --cached | grep -iE "api[_-]?key|secret|token|password"`. If a real secret already reached a commit, rotate it — scrubbing history is not enough once pushed.

### Metric
A pre-commit secret grep catching even one leaked key pays for itself; rotating a leaked prod credential costs hours and incident review.

## K-ARC-001: Pure-core / adapter separation

**Category**: Architecture
**Created**: 2026-06-22
**Domain**: architecture, testability

### Context
Business logic gets entangled with I/O — HTTP handlers, the database client, third-party SDKs — making it slow to test and hard to swap providers.

### Learning
Keep a **pure core** (deterministic functions: input → output, no side effects) and push all I/O to thin **adapters** at the edges (HTTP, persistence, external APIs). The core depends on interfaces, not concrete clients; adapters implement them. This lets you unit-test the core with zero mocks and swap an adapter (e.g. one provider for another) without touching business rules.

### Application
Wire dependencies at a single composition point (the app entry). Tests hit the core directly with plain values; adapters get a small number of integration tests.

### Metric
Provider swaps and most logic changes touch only one layer; core test suites run with no network/DB and stay fast (sub-second) as the app grows.

---

## Adding New Entries

Prefer `/retrospect`, which analyzes the session and appends entries with correct IDs and cross-references. To add one manually: copy the Entry Schema above, choose the next free ID in the right namespace, append it under "Entries", and add a row to the matching Index table plus the relevant By-Technology / By-Domain / By-Skill lists.
