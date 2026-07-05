#!/bin/sh
# PostToolUse hook for Edit/Write (registered in .claude/settings.json).
#
# Warns when a file governed by an LF policy in .gitattributes was written
# containing CRLF line endings, so the mismatch is fixed before it causes
# confusion. Files whose policy is CRLF (e.g. *.ps1) are exempt.
#
# Exit code 2 feeds the warning on stderr back to the agent.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
else
  path=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
fi

[ -n "$path" ] || exit 0
[ -f "$path" ] || exit 0

# Only check files inside the project.
case "$path" in
  "$PWD"/*) ;;
  *) exit 0 ;;
esac

eol=$(git check-attr eol -- "$path" 2>/dev/null | sed 's/.*: eol: //')
[ "$eol" = "crlf" ] && exit 0

# grep -I skips binary files.
if grep -Iq "$(printf '\r')" "$path" 2>/dev/null; then
  echo "Warning: $path contains CRLF line endings, but the repository policy (.gitattributes) requires LF. Rewrite it with LF endings." >&2
  exit 2
fi

exit 0
