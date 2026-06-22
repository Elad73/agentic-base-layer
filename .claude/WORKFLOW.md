# Agentic Workflow — Canonical Lifecycle

A structured, role-based development workflow. Phases are executed by de-personalized role agents in `.claude/agents/`: **orchestrator, product-manager, developer, code-reviewer, test-engineer, release-gatekeeper, security-reviewer, database-reviewer, design-reviewer**.

This workflow is **task-backend-agnostic**. It works with either:
- **Filesystem Kanban** — `.claude/product/{todo,in-progress,done}/` holding `FT-XXX` / `BUG-XXX` files, or
- **GitHub Issues** — issues with `status:*` labels as the source of truth.

Where a step differs, both modes are noted.

---

## Phase Overview

```
PLAN/MATURE  →  BUILD  →  REVIEW  →  TEST  →  SECURITY GATE  →  COMPLETE/RETROSPECT
```

| Phase | Role | Purpose |
|-------|------|---------|
| PLAN/MATURE | product-manager (orchestrated) | Turn a request into a ready, testable task |
| BUILD | developer | Implement all acceptance criteria + tests |
| REVIEW | code-reviewer + parallel domain sub-reviewers | Validate correctness & quality |
| TEST | test-engineer | Prove it works; find edge cases |
| SECURITY GATE | security-reviewer (or inline scan) | MANDATORY — block secrets/leaks before merge |
| COMPLETE/RETROSPECT | release-gatekeeper + orchestrator | Merge, close, capture lessons |

---

## Status Lifecycle (state machine)

```
backlog
  → maturing
    → ready
      → in-progress
        → ready-for-review
          → in-review
            → ready-for-testing
              → testing
                → pr-open
                  → done

(blocked)  ← any state can transition to blocked, and back to its prior state when unblocked
```

| Status | Owning role | Next command |
|--------|-------------|--------------|
| backlog | product-manager | `/mature-task` |
| maturing | product-manager | (finishing maturation) |
| ready | developer | `/execute-task` |
| in-progress | developer | (finishing build) |
| ready-for-review | code-reviewer | `/review-task` |
| in-review | code-reviewer | (review in progress) |
| ready-for-testing | test-engineer | `/test-task` |
| testing | test-engineer | (tests running) |
| pr-open | release-gatekeeper | `/approve-task` |
| done | — | — |
| blocked | orchestrator | investigate, then restore prior status |

**Mode mapping:**
- GitHub Issues: each status is a `status:<name>` label; transitions swap the label.
- Filesystem Kanban: `backlog`→`todo/`, the working statuses→`in-progress/`, `done`→`done/`; the precise status is recorded in the file's `**Status:**` line.

---

## Phase 1 — PLAN / MATURE

**Role:** product-manager. **Command:** `/mature-task <ref>`.

1. Read the request; sharpen description + user story.
2. Write concrete, testable acceptance criteria.
3. Add technical notes for «PROJECT-STACK».
4. Set priority (p0–p3) and size (xs–xl).
5. Transition `backlog → maturing → ready`.

**Handoff to BUILD** (4-field, see `CONTEXT-PASSING.md`): Task / Files / Context / Constraints.

---

## Phase 2 — BUILD

**Role:** developer. **Command:** `/execute-task <ref>`.

1. Branch `feature/<ref>-<slug>` (or `fix/…`).
2. Implement every acceptance criterion — no more, no less.
3. Write tests alongside the code.
4. Run «PROJECT-VERIFY-CMD» (type-check + lint + tests) green.
5. Transition `ready → in-progress → ready-for-review`.

---

## Phase 3 — REVIEW (parallel domain sub-reviewers)

**Role:** code-reviewer. **Command:** `/review-task <ref>`.

The code-reviewer inspects the diff and **spawns domain sub-reviewers in parallel** based on what changed:

```
              ┌─ database-reviewer   (schema / migrations / models)
diff ─────────┼─ security-reviewer   (auth / middleware / api / input handling)
              └─ design-reviewer     (UI components / styles / pages)
```

Each sub-reviewer returns `APPROVED` or `CHANGES REQUESTED` with `file:line` findings. The code-reviewer aggregates:
- **APPROVE** → `ready-for-testing`.
- **REJECT** → `in-progress` (back to developer).

---

## Phase 4 — TEST

**Role:** test-engineer. **Command:** `/test-task <ref>`.

1. Run unit/integration tests with coverage; run lint + type-check.
2. Exercise edge cases and error paths (test what could break).
3. Green → open PR, transition `testing → pr-open`.
4. Red → back to `in-progress`.

---

## Phase 5 — SECURITY GATE (MANDATORY)

**Role:** security-reviewer (or inline). **Never skip.**

```bash
# Secrets in staged diff
git diff --cached | grep -iE "(api[_-]?key|password|secret|token)" && { echo "BLOCKED"; exit 2; }
# Sensitive files
git diff --cached --name-only | grep -E "\.(env|sql|backup|pem|key)$" && { echo "BLOCKED"; exit 2; }
```

**Only hook exit code `2` blocks the action.** Any non-empty match above means STOP: unstage, remediate, re-run. A finding here is a hard stop, not a warning.

---

## Phase 6 — COMPLETE / RETROSPECT

**Roles:** release-gatekeeper (`/approve-task`) then orchestrator.

1. Re-run the security scan against the PR diff.
2. Verify the task flowed through all phases and all acceptance criteria are checked.
3. Squash-merge, delete branch, close task, transition to `done`.
4. **Retrospect:** capture lessons learned (see the loop below).

---

## Context Update Triggers

Update the right artifact at the right moment so context never goes stale.

| Trigger | Action | Update (Kanban / Issues) |
|---------|--------|--------------------------|
| Session start | Read status, report | «PROJECT-STATUS-FILE» / `gh issue list` |
| Task started | Move + branch | `product/in-progress/` / `status:in-progress` label |
| Subtask completed | Tick progress | task-file checkboxes / issue checklist |
| Major decision | Document | session notes / issue comment |
| Blocker hit | Log blocker | `blocked` status + reason |
| Bug found | File ticket | new `BUG-XXX` in `todo/` / new issue |
| Task completed | Move + close | `product/done/` / close issue |
| Lesson learned | Capture knowledge | update/create skill in `.claude/skills/` |
| Before commit | Security scan | security gate (Phase 5) |
| Session end | Persist context | «PROJECT-STATUS-FILE» |

---

## Loop Recovery Protocol

**Warning signs:** same error 3+ times, repeating the same approach, each fix breaking something new, complexity spiraling.

When the **same error appears 3+ times**, STOP the retry loop and run:

```
┌──────────────────────────────────────────────────────────────┐
│ LOOP DETECTED — RECOVERY PROTOCOL                              │
├──────────────────────────────────────────────────────────────┤
│ 1. STOP      — do not attempt another fix                     │
│ 2. DOCUMENT  — log the loop + each attempt in session notes   │
│ 3. ANALYZE   — what are we ACTUALLY trying to solve?          │
│ 4. SIMPLIFY  — can we solve a smaller sub-problem first?      │
│ 5. ALTERNATE — is there a completely different approach?      │
│ 6. ESCALATE  — still stuck → mark task `blocked`, recommend   │
│                an alternative, and pause (don't spin cycles)  │
└──────────────────────────────────────────────────────────────┘
```

Blocker record:
```markdown
## Blockers
- [ ] [BLK-001] <description>
  - Tried: <approach 1>, <approach 2>, <approach 3>
  - Blocked by: <specific reason>
  - Needs: <what would unblock this>
```

---

## Lessons Learned → Skills Loop

Every completed task (and every fixed bug) feeds the knowledge base. The `Lessons Learned → Add to Skill` table in `FEATURE-TEMPLATE.md` / `BUG-TEMPLATE.md` is the capture point.

| Situation | Action |
|-----------|--------|
| Solved a tricky problem | Document the pattern in a skill |
| Found a better approach | Update an existing skill |
| Hit the same issue twice | Create a prevention skill |
| Discovered a useful pattern | Add to the relevant skill |

**Capture template:**
```markdown
## Lesson: <short title>
**Context:** what were we doing?
**Problem:** what was hard / went wrong?
**Solution:** how did we solve it?
**Prevention:** how to avoid it next time?
→ Add to skill: <skill-name> (or create new)
```

**Create a new skill from a lesson:**
1. `cp .claude/templates/SKILL-TEMPLATE.md .claude/skills/<name>/SKILL.md`
2. Fill the YAML frontmatter (`name`, `description`) — required for the skill to be invokable.
3. Add the core concept + a code example.
4. Add a checklist item for future prevention.

---

## Token Economy

- Pass only the exact files an agent needs (4-field handoff).
- One task per handoff.
- Archive old session notes; compact regularly.
- Avoid dumping the whole codebase or full conversation history into a sub-agent.
