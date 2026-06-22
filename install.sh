#!/usr/bin/env bash
# ============================================================================
# install.sh — install the Agentic Base Layer GLOBALLY.
#
# Symlinks (or copies) global/{agents,skills,commands} into your Claude Code
# config home, so the roster, skills, and commands are available in EVERY
# project. Default is symlink, so `git pull` in this repo updates everything.
#
#   Usage:  ./install.sh            # symlink (recommended — live updates)
#           ./install.sh --copy     # static copy (frozen snapshot)
#
# Installs into ~/.claude by default; honors $CLAUDE_CONFIG_DIR only if you've set one.
# Never overwrites a non-symlink you already have — it skips and warns.
# ============================================================================
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
MODE="link"; [ "${1:-}" = "--copy" ] && MODE="copy"

echo "Installing Agentic Base Layer → $CONFIG  (mode: $MODE)"

for kind in agents skills commands; do
  mkdir -p "$CONFIG/$kind"
  for item in "$BASE_DIR/global/$kind"/*; do
    [ -e "$item" ] || continue
    name="$(basename "$item")"
    [ "$name" = "README.md" ] && continue   # roster/index docs aren't assets
    target="$CONFIG/$kind/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "  ⚠ skip $kind/$name (exists and is not a symlink — left untouched)"; continue
    fi
    rm -f "$target"
    if [ "$MODE" = "copy" ]; then cp -R "$item" "$target"; else ln -s "$item" "$target"; fi
    echo "  + $kind/$name"
  done
done

# shared conventions live at the config-home root
for f in WORKFLOW.md CONTEXT-PASSING.md; do
  if [ "$MODE" = "copy" ]; then cp "$BASE_DIR/global/$f" "$CONFIG/$f"; else ln -sf "$BASE_DIR/global/$f" "$CONFIG/$f"; fi
done

echo "✅ Installed. Agents, skills, and commands are now available in every project."
echo "   Update later:  git -C \"$BASE_DIR\" pull   (symlinks pick it up automatically)"
echo "   Per-project setup:  $BASE_DIR/bin/new-project.sh <path>"
