#!/bin/sh
# PreToolUse hook for the Bash tool (registered in .claude/settings.json).
#
# Denies git operations that must never run under this repository's workflow
# (AGENTS.md) and asks for user confirmation on destructive ones, so the
# guard also works in auto-accept permission modes.
#
# Requires jq to parse the hook payload (personal/README.md: prerequisite
# tools). If jq is missing, the hook asks instead of deciding, so the guard
# fails safe rather than silently allowing everything.

input=$(cat)

emit() {
  # $1: permission decision (deny|ask), $2: reason (no double quotes allowed)
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
  exit 0
}

command -v jq >/dev/null 2>&1 ||
  emit ask "jq is required by this hook but was not found. Install jq (personal/README.md: prerequisite tools)."

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')

[ -n "$cmd" ] || exit 0

has() {
  printf '%s' "$cmd" | grep -Eq "$1"
}

is_push=false
if has 'git[[:space:]]+push'; then is_push=true; fi

force_push=false
if [ "$is_push" = true ]; then
  if has 'git[[:space:]]+push[^|;&]*--force' || has 'git[[:space:]]+push[^|;&]*[[:space:]]-f([[:space:]]|$)'; then
    force_push=true
  fi
fi

touches_main=false
if has '[[:space:]:](main|master)([^[:alnum:]_-]|$)'; then touches_main=true; fi

# --- Never allowed ------------------------------------------------------

if [ "$force_push" = true ] && [ "$touches_main" = true ]; then
  emit deny "Force-pushing to main/master is not allowed (AGENTS.md: development flow)."
fi

if has 'git[[:space:]]+push[^|;&]*[[:space:]](HEAD:)?(main|master)([^[:alnum:]_/-]|$)'; then
  emit deny "Direct push to main/master is not allowed. Use a feature branch and a pull request (AGENTS.md)."
fi

if has 'git[[:space:]]+(commit|push)[^|;&]*--no-verify'; then
  emit deny "--no-verify skips hooks and checks, and is not allowed."
fi

if has '(^|[;&|[:space:]"])rm[[:space:]]+-[[:alnum:]]*r[[:alnum:]]*[[:space:]]+(/|~/?)([[:space:]"]|$)'; then
  emit deny "Refusing to delete the filesystem root or the home directory."
fi

# --- Ask the user first ---------------------------------------------------

if [ "$force_push" = true ]; then
  emit ask "Force push detected. Confirm with the user first; prefer --force-with-lease on feature branches (AGENTS.md)."
fi

if has 'git[[:space:]]+reset[^|;&]*--hard'; then
  emit ask "git reset --hard discards local changes. Confirm with the user first (AGENTS.md)."
fi

if has 'git[[:space:]]+clean[^|;&]*[[:space:]]-[[:alnum:]]*f'; then
  emit ask "git clean -f deletes untracked files. Confirm with the user first (AGENTS.md)."
fi

if has 'git[[:space:]]+branch[^|;&]*[[:space:]]-D([[:space:]]|$)'; then
  emit ask "Force-deleting a branch. Confirm with the user first (AGENTS.md)."
fi

if has 'git[[:space:]]+commit'; then
  current_branch=$(git branch --show-current 2>/dev/null || true)
  if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
    emit ask "Committing directly on $current_branch. The workflow requires a feature branch (AGENTS.md). Confirm with the user first."
  fi
fi

if has '(curl|wget)[^|;&]*\|[[:space:]]*(sudo[[:space:]]+)?[a-z]*sh([[:space:]]|$)'; then
  emit ask "Piping a downloaded script directly into a shell. Inspect the script and confirm with the user first (AGENTS.md: security)."
fi

if has 'git[[:space:]]+add[^|;&]*\.env' && ! has '\.env\.(example|sample|template)'; then
  emit ask "Staging a .env file. Secrets must not be committed (AGENTS.md: security). Confirm with the user first."
fi

exit 0
