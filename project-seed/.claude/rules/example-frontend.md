---
description: Example path-scoped rule — conventions that apply only to frontend files.
applyTo:
  - "src/components/**"
  - "src/app/**"
  - "**/*.tsx"
  - "**/*.css"
---

# Frontend Rules (example, path-scoped)

> This is a TEMPLATE. The `applyTo` globs above scope these rules to frontend
> files only, so they load into context just when relevant — not on every task.
> Adapt the globs to «PROJECT-STACK» and replace the rules with your own.

## When this applies

Any change under the globs above (components, app/route files, styles).
For non-frontend changes (API, DB, scripts), this rule stays out of context.

## Conventions

- **Mobile-first.** Design and implement the small-viewport layout first, then
  enhance upward. Every new surface must be usable on a narrow screen.
- **Accessibility is non-negotiable.** Semantic elements, labelled controls,
  visible focus states, sufficient contrast, keyboard-navigable.
- **Use the design system.** Pull from «PROJECT-DESIGN-TOKENS» (spacing, color,
  type). No ad-hoc hex values or magic pixel numbers in components.
- **Keep components focused.** One responsibility each; lift shared logic into
  hooks/utilities rather than copy-pasting.
- **No dead code.** Remove `console.log`, commented-out blocks, and unused props
  before review.

## Review hook

When frontend files change, `/review-task` should spawn the **design-reviewer**
sub-reviewer (responsive, a11y, design-system adherence) per `.claude/WORKFLOW.md`.

## Checklist (frontend changes)

- [ ] Renders correctly at a narrow (mobile) viewport.
- [ ] Keyboard-navigable; focus states visible.
- [ ] Uses design tokens, not hard-coded values.
- [ ] No leftover debug output.
