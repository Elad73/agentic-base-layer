---
name: station
description: "End-of-session bundle. Chains retrospect → document → cleanup → wrap-up so nothing is missed when closing a session."
---

# Station — End-of-Session Bundle

Run the full closing pipeline in one command: capture knowledge, sync docs to code, prune stale artifacts, then commit and PR. Useful when you're done with a meaningful work block and want to leave the project in a clean, documented state.

**Orchestrator pattern.** Each phase is its own slash command, edited in its own file. `/station` only conducts the chain — when you want to improve any single phase, edit that command directly without touching this file.

**Usage:** `/station`

---

## Pre-flight — security scan

Before any doc writes, scan for leaked secrets:

```bash
grep -rn -iE "(sk_|pk_live_|api[_-]?key|secret|password|bearer|postgresql://[^l]|mongodb\+srv://)" \
  README.md CLAUDE.md docs/ .claude/ \
  --include="*.md" 2>/dev/null
```

If anything matches: **STOP**. Surface the finding, replace with placeholders (`<YOUR_API_KEY>`), warn the user about git history, and only continue once the file is clean.

## Phases

Run these in order. Each phase respects the others — if one phase has nothing to do, it logs a one-line skip and the chain continues.

| # | Phase | Command | Purpose |
|---|---|---|---|
| 1 | Retrospect | `/retrospect` | Extract patterns / pitfalls / decisions into the knowledge base |
| 2 | Document | `/document` | Sync STATUS / READMEs / CLAUDE.md to current code |
| 3 | Cleanup | `/cleanup` | Audit and prune stale branches / sessions / temp / backups |
| 4 | Wrap-up | `/wrap-up` | Final commit + push + PR |

If any phase reports a hard error, stop the chain and surface it — don't barrel forward.

## Output — final session summary

Compose a single combined summary from each phase's individual output:

```
+------------------------------------------------------------------------------+
|                            SESSION STATION COMPLETE                          |
+------------------------------------------------------------------------------+
|  Phase 1 — RETROSPECT                                                        |
|    Patterns: N    Pitfalls: N    Decisions: N    (others): N
|    Top insight: <one-line>
|
|  Phase 2 — DOCUMENT
|    Files updated: N        New files: N        Contradictions fixed: N
|
|  Phase 3 — CLEANUP
|    Branches pruned: N      Stale tasks moved: N    Artifacts cleared: <size>
|
|  Phase 4 — WRAP-UP
|    Commit: <hash>          PR: <url>             Branch: <name>
+------------------------------------------------------------------------------+
|  Tracking system synced: <model A | B | C>
|  Ready to close session.
+------------------------------------------------------------------------------+
```

## Constraints

- **Never** skip the security scan — even when the user is in a hurry.
- **Never** mute or batch-approve `/cleanup` destructive actions; cleanup retains its own confirmation prompt within this chain.
- **Never** mention `Claude` or `Anthropic` in the final commit / PR text (this is enforced inside `/wrap-up` already, but the rule is restated here because it's the most common slip-up).
- **All doc changes go in one commit.** Don't scatter the doc-sync diff across several commits — that defeats the purpose of bundling.
- **Phase 1's knowledge writes are part of phase 4's commit** — don't push them in a separate commit.
- If the user only wants one phase, suggest they invoke that command directly rather than running the full bundle.
