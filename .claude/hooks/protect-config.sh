#!/bin/sh
# PreToolUse hook for Edit/Write (registered in .claude/settings.json).
#
# Asks for user confirmation before the agent modifies files that make up
# this repository's security guardrails (AGENTS.md: security section), so
# the guard also works in auto-accept permission modes.
#
# Requires jq to parse the hook payload (personal/README.md: prerequisite
# tools). If jq is missing or the payload does not parse, the hook asks
# instead of deciding, so the guard fails safe rather than silently
# allowing everything.

input=$(cat)

ask() {
  # $1: reason (escaped by jq)
  jq -cn --arg reason "$1" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "ask", permissionDecisionReason: $reason}}'
  exit 0
}

if ! command -v jq >/dev/null 2>&1; then
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"jq is required by this hook but was not found. Install jq (personal/README.md: prerequisite tools)."}}\n'
  exit 0
fi

path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) ||
  ask "Failed to parse the hook payload as JSON. Confirm with the user first."

[ -n "$path" ] || exit 0

# Normalize relative paths (hooks run in the project directory) so the
# guard cannot be bypassed by passing a relative file_path. Backslashes
# are converted first because Windows-native setups pass paths such as
# C:\repo\.claude\settings.json, which the patterns below would miss.
path=$(printf '%s' "$path" | tr '\\' '/')
case "$path" in
  /*|[A-Za-z]:/*) ;;
  *) path="${CLAUDE_PROJECT_DIR:-$PWD}/$path" ;;
esac

case "$path" in
  */.claude/settings.json|*/.claude/settings.local.json|*/.claude/hooks/*|*/.github/workflows/*|*/.github/dependabot.yml)
    ask "Modifying security-related configuration: $path. Requires user approval (AGENTS.md: security)."
    ;;
esac

exit 0
