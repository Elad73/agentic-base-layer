#!/usr/bin/env bash
# PostToolUse auto-format stub (referenced by .claude/settings.json).
#
# Fires after Edit/Write. Wire in your project's formatter below.
# IMPORTANT: this hook is intentionally NON-BLOCKING — it always exits 0.
# Only exit code 2 would block the action, which we never want for formatting.
#
# Hook input arrives as JSON on stdin; tool_input.file_path is the edited file.

set -uo pipefail

# Best-effort extract of the edited file path (jq optional).
FILE=""
if command -v jq >/dev/null 2>&1; then
  FILE="$(jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
fi

# Example formatter wiring (uncomment + adapt to «PROJECT-FORMATTER»):
# if [ -n "$FILE" ] && command -v npx >/dev/null 2>&1; then
#   npx prettier --write "$FILE" >/dev/null 2>&1 || true
# fi

exit 0
