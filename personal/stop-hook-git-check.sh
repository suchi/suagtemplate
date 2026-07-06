#!/bin/bash
# Stop hook for Claude Code: check the git state before the agent finishes
# responding, so work does not silently stop with uncommitted or unpushed
# changes.
#
# Checks, in order: uncommitted changes, untracked files, commits that
# GitHub will show as Unverified (only when commit signing is configured),
# and unpushed commits. Exit code 2 feeds the message back to the agent.
#
# Registration: merge claude-user-settings-snippet.json (in this folder)
# into ~/.claude/settings.json manually.

# Committer identity expected for signed commits. Claude Code on the web
# registers its signing key to this address; adjust if your setup signs
# with a different identity.
expected_email="noreply@anthropic.com"
# GitHub-generated commits (merge/squash/suggestion commits) are signed by
# GitHub's web-flow key and always show as Verified on GitHub, so they are
# excluded from the check.
github_email="noreply@github.com"

input=$(cat)

# Recursion prevention: do nothing if the stop hook is already active.
# Use jq when available; otherwise fall back to a crude string match,
# which is sufficient for this guard.
if command -v jq >/dev/null 2>&1; then
  stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active' 2>/dev/null)
  if [[ "$stop_hook_active" == "true" ]]; then
    exit 0
  fi
elif [[ "$input" == *'"stop_hook_active":true'* || "$input" == *'"stop_hook_active": true'* ]]; then
  exit 0
fi

# Bail when not in a git repository.
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

# Bail when there is no remote to push to.
if [[ -z "$(git remote)" ]]; then
  exit 0
fi

# Uncommitted changes (staged or unstaged).
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "There are uncommitted changes in the repository. Please commit and push them." >&2
  exit 2
fi

# Untracked files.
untracked_files=$(git ls-files --others --exclude-standard)
if [[ -n "$untracked_files" ]]; then
  echo "There are untracked files in the repository. Add and commit them, add them to .gitignore, or remove them, then push." >&2
  exit 2
fi

current_branch=$(git branch --show-current)
if [[ -n "$current_branch" ]]; then
  # Determine the comparison target: prefer the configured upstream, then
  # the same-name branch on the first remote, then that remote's HEAD.
  # (The remote is not necessarily named "origin".)
  remote=$(git remote | head -n1)
  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || true)
  if [[ -z "$upstream" ]]; then
    if git rev-parse --verify "$remote/$current_branch" >/dev/null 2>&1; then
      upstream="$remote/$current_branch"
    else
      upstream="$remote/HEAD"
    fi
  fi

  # Never skip silently: if the comparison target cannot be resolved (e.g.
  # a remote added without fetching, or remote HEAD unset), say so instead
  # of treating the checks below as passed.
  if ! git rev-parse --verify "$upstream^{commit}" >/dev/null 2>&1; then
    echo "Could not resolve '$upstream', so the push state of branch '$current_branch' cannot be verified. Set an upstream (git branch --set-upstream-to=...) or fetch the remote, then check manually." >&2
    exit 2
  fi

  # Commits GitHub will show as Unverified: unsigned (%G? == N), a bad
  # signature (%G? == B), or signed with an unexpected committer email.
  # %G? values E/U (signature cannot be checked locally, e.g. the signer's
  # public key is not in the local keyring) are intentionally NOT flagged:
  # commits signed by Claude Code on the web report E locally while showing
  # as Verified on GitHub. Only checked when commit signing is configured.
  # GitHub-generated commits are excluded (see github_email).
  if [[ "$(git config --type=bool commit.gpgsign 2>/dev/null)" == "true" ]]; then
    unverifiable=$(git log --format='%h %G? %ce' "$upstream..HEAD" 2>/dev/null | awk -v ok="$expected_email" -v gh="$github_email" '$3 != gh && ($2 == "N" || $2 == "B" || $3 != ok)')
    if [[ -n "$unverifiable" ]]; then
      echo "There are commit(s) on branch '$current_branch' that GitHub will show as Unverified (missing or bad signature, or committer email is not $expected_email):" >&2
      echo "$unverifiable" >&2
      echo "Fix the committer identity of those commits (set user.email/user.name, then git commit --amend --no-edit; amending updates the committer and re-signs without changing the author), then push." >&2
      exit 2
    fi
  fi

  unpushed=$(git rev-list "$upstream..HEAD" --count 2>/dev/null) || unpushed=0
  if [[ "$unpushed" -gt 0 ]]; then
    echo "There are $unpushed unpushed commit(s) on branch '$current_branch'. Please push them to the remote repository." >&2
    exit 2
  fi
fi

exit 0
