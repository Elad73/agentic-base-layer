#!/usr/bin/env bash
# ============================================================================
# new-project.sh — scaffold a new project from the Agentic Base Layer.
#
# Copies the per-project starter (project-seed/) — the CLAUDE.md seed, knowledge
# scaffold, rules, docs skeleton — into a target dir and `git init`s it. Also drops
# the shared conventions (WORKFLOW.md, CONTEXT-PASSING.md) into the project's .claude/
# so the agents/commands resolve them locally even without a global install.
#
# The reusable engine (agents/skills/commands) is NOT copied per project — install it
# once globally with ./install.sh. The base repo never changes from project work.
#
#   Usage:  bin/new-project.sh <target-dir> [project-name]
# ============================================================================
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:?Usage: new-project.sh <target-dir> [project-name]}"
NAME="${2:-$(basename "$TARGET")}"

if [ -e "$TARGET/.claude" ] || [ -e "$TARGET/CLAUDE.md" ]; then
  echo "⛔ $TARGET already has .claude/ or CLAUDE.md — refusing to overwrite." >&2
  exit 1
fi

mkdir -p "$TARGET"
cp -R "$BASE_DIR/project-seed/." "$TARGET/"
# shared conventions, so project-relative .claude/WORKFLOW.md references resolve
cp "$BASE_DIR/global/WORKFLOW.md"        "$TARGET/.claude/WORKFLOW.md"
cp "$BASE_DIR/global/CONTEXT-PASSING.md" "$TARGET/.claude/CONTEXT-PASSING.md"
[ -f "$BASE_DIR/.gitignore" ] && cp "$BASE_DIR/.gitignore" "$TARGET/.gitignore"

cd "$TARGET"
git init -q

cat <<EOF
✅ Scaffolded '$NAME' at $TARGET

Next steps:
  1. cd $TARGET
  2. Edit CLAUDE.md — fill in the «PLACEHOLDERS» (product, stack, invariants).
  3. Make sure the engine is installed globally:  $BASE_DIR/install.sh
  4. git add -A && git commit -m "chore: scaffold project from agentic base layer"
  5. Build:  /wake-up → /feature … → /wrap-up
EOF
