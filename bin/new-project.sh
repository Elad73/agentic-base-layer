#!/usr/bin/env bash
# ============================================================================
# new-project.sh — bootstrap a new project from the Agentic Base Layer.
#
# Copies the reusable payload (.claude/ + the CLAUDE.md seed) into a target
# directory and initializes a fresh git repo there. The base repo is never
# modified — every change you make afterwards belongs to the new project.
#
#   Usage:  bin/new-project.sh <target-dir> [project-name]
#   e.g.    bin/new-project.sh ~/projects/my-app my-app
# ============================================================================
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:?Usage: new-project.sh <target-dir> [project-name]}"
NAME="${2:-$(basename "$TARGET")}"

if [ -e "$TARGET/.claude" ]; then
  echo "⛔ $TARGET/.claude already exists — refusing to overwrite." >&2
  exit 1
fi

mkdir -p "$TARGET"

# Copy the PAYLOAD only — never the framework's own meta/ docs or bin/.
cp -R "$BASE_DIR/.claude"   "$TARGET/.claude"
cp    "$BASE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
[ -f "$BASE_DIR/.gitignore" ] && cp "$BASE_DIR/.gitignore" "$TARGET/.gitignore"

# Drop the base's seed knowledge entries — a new project starts its own registry.
# (Comment out the next line if you want to inherit the example entries.)
# : > "$TARGET/.claude/knowledge/REGISTRY.md"

cd "$TARGET"
git init -q

cat <<EOF
✅ Scaffolded '$NAME' at $TARGET

Next steps:
  1. cd $TARGET
  2. Edit CLAUDE.md — fill in the «PLACEHOLDERS» (product, stack, invariants).
  3. git add -A && git commit -m "chore: scaffold project from agentic base layer"
  4. Build: /wake-up → /feature … → /wrap-up
EOF
