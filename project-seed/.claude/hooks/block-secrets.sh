#!/usr/bin/env bash
# ============================================================================
# block-secrets.sh — PreToolUse guard that blocks obvious secret leaks.
#
# Wire it in .claude/settings.json as a PreToolUse hook (see settings.example.jsonc).
# Claude Code pipes the tool call as JSON on STDIN (not as args) — we read that.
#
# CONTRACT: exit code 2 BLOCKS the tool call (exit 1 does NOT block — Claude proceeds).
# We scan the Bash command text / written content for high-signal secret patterns and
# block on a match. This is a coarse safety net, not a replacement for the discipline of
# scanning diffs yourself (it does not catch PII like emails or private project names).
# ============================================================================
set -uo pipefail

payload="$(cat)"

# Pull the fields we care about without requiring jq (fallback to a grep of the blob).
if command -v jq >/dev/null 2>&1; then
  text="$(printf '%s' "$payload" | jq -r '.tool_input.command // .tool_input.content // .tool_input.new_string // empty' 2>/dev/null)"
else
  text="$payload"
fi
[ -z "$text" ] && exit 0

# High-signal secret patterns (extend per project).
patterns='(ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_\-]{30,}|(api[_-]?key|secret|password|token)\s*[:=]\s*['"'"'"][^'"'"'"]{8,}'

if printf '%s' "$text" | grep -qiE "$patterns"; then
  echo "⛔ block-secrets: a possible secret was detected in this tool call. Move it to an env var / secret manager and reference it by name. (Override only if this is a false positive.)" >&2
  exit 2   # exit 2 blocks
fi
exit 0
