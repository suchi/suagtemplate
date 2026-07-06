#!/bin/sh
# PostToolUse hook for Edit/Write (registered in .claude/settings.json).
#
# Meta-repository hook: when a file under template/ or template_ja/ is
# modified and a counterpart exists on the other side, remind the agent to
# apply the same change to the counterpart in the same change (AGENTS.md:
# template sync rule). Files without a counterpart (single-side files such
# as template_ja/.github/copilot-code-review.yml) are ignored.
#
# Exit code 2 feeds the reminder on stderr back to the agent.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
else
  path=$(printf '%s' "$input" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
fi

[ -n "$path" ] || exit 0

# Normalize to a repository-relative path (hooks run at the project root).
rel=$path
case "$rel" in
  "$PWD"/*) rel=${rel#"$PWD"/} ;;
esac

case "$rel" in
  template/*) other="template_ja/${rel#template/}" ;;
  template_ja/*) other="template/${rel#template_ja/}" ;;
  *) exit 0 ;;
esac

if [ -f "$other" ]; then
  echo "Reminder: $rel has a counterpart at $other. Keep template/ and template_ja/ in sync in the same change (AGENTS.md: template sync rule). Code files must stay byte-identical; documents must stay equivalent in meaning." >&2
  exit 2
fi

exit 0
