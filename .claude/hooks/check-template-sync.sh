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
#
# Requires jq to parse the hook payload (docs/setup-guide.md lists jq as a
# prerequisite tool). If jq is missing or the payload does not parse, the
# hook reminds the agent instead of silently doing nothing.

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required by check-template-sync.sh but was not found. Install jq (docs/setup-guide.md, step 2: personal global setup)." >&2
  exit 2
fi

path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || {
  echo "check-template-sync.sh: failed to parse the hook payload as JSON; cannot check the template sync rule." >&2
  exit 2
}

[ -n "$path" ] || exit 0

# Normalize to a repository-relative path (hooks run at the project root)
# so absolute, relative, and "./"-prefixed file_path values all match.
# Backslashes are converted first because Windows-native setups pass paths
# such as C:\repo\template\AGENTS.md.
path=$(printf '%s' "$path" | tr '\\' '/')
root=$(printf '%s' "${CLAUDE_PROJECT_DIR:-$PWD}" | tr '\\' '/')
case "$path" in
  /*|[A-Za-z]:/*) ;;
  *) path="$root/$path" ;;
esac
rel=${path#"$root"/}
case "$rel" in
  ./*) rel=${rel#./} ;;
esac

case "$rel" in
  template/*|template_ja/*) ;;
  *)
    # The same absolute path can be spelled differently from $root on
    # Windows (C:/... vs /c/...), which defeats the prefix strip above,
    # so fall back to matching the template path segment.
    case "$path" in
      */template/*) rel="template/${path##*/template/}" ;;
      */template_ja/*) rel="template_ja/${path##*/template_ja/}" ;;
      *) exit 0 ;;
    esac
    ;;
esac

case "$rel" in
  template/*) other="template_ja/${rel#template/}" ;;
  template_ja/*) other="template/${rel#template_ja/}" ;;
  *) exit 0 ;;
esac

if [ -f "$root/$other" ]; then
  echo "Reminder: $rel has a counterpart at $other. Keep template/ and template_ja/ in sync in the same change (AGENTS.md: template sync rule). Code files must stay byte-identical; documents must stay equivalent in meaning." >&2
  exit 2
fi

exit 0
