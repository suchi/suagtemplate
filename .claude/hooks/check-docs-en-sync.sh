#!/bin/sh
# PostToolUse hook for Edit/Write (registered in .claude/settings.json).
#
# When a Japanese base Markdown file is modified and an English counterpart
# <name>_en.md exists, remind the agent to update the English version in the
# same change (AGENTS.md: Japanese/English sync rule).
#
# Exit code 2 feeds the reminder on stderr back to the agent.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
else
  path=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
fi

[ -n "$path" ] || exit 0

case "$path" in
  *_en.md) exit 0 ;;
  *.md) ;;
  *) exit 0 ;;
esac

base=${path%.md}
en_path="${base}_en.md"

if [ -f "$en_path" ]; then
  echo "Reminder: $path has an English counterpart. Update $en_path in the same change (AGENTS.md: Japanese/English sync). The sync-docs-en skill describes the procedure." >&2
  exit 2
fi

exit 0
