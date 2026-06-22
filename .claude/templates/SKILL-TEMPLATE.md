---
name: «skill-name»
description: «One sentence — what this skill provides AND when Claude should use it (include trigger keywords).»
# allowed-tools is OPTIONAL. Omit to inherit all tools. Restrict only when the skill should be sandboxed.
# allowed-tools: Read, Grep, Glob
---

# «Skill Name»

> Brief one-line description of what this skill provides.

> NOTE: To register as a real skill, save this file as `.claude/skills/«skill-name»/SKILL.md`.
> The YAML frontmatter above is REQUIRED — `name` must match the directory and be kebab-case;
> `description` is what triggers model invocation, so make it specific.

---

## Overview

2–3 sentences: what this skill covers, when to use it, and the value it adds.

---

## Core Concepts

### Concept 1

**Definition:** What is this concept?

**Why it matters:** Why should developers care?

**Implementation:**
```
// Example showing the concept
```

### Concept 2

**Definition:** …

**Why it matters:** …

**Implementation:**
```
// Example
```

---

## Patterns

### «Pattern Name»

**Use When:** Describe the scenario.

**Structure:**
```
Diagram or code structure
```

**Example:**
```
// Concrete implementation example
```

**Anti-pattern to avoid:**
```
// What NOT to do
```

---

## Checklist

When applying this skill, verify:

- [ ] Item 1
- [ ] Item 2
- [ ] Item 3

---

## Quick Reference

| Concept | Description | Example |
|---------|-------------|---------|
| Term 1 | Brief explanation | `code` |
| Term 2 | Brief explanation | `code` |

---

## Resources

- «Resource 1» — brief description
- «Resource 2» — brief description
