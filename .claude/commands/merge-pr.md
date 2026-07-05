---
description: Merge an approved PR, clean up the branch, and sync main
argument-hint: <PR number> [version tag]
---

Merge the PR given as the first argument of $ARGUMENTS after final checks.

Preconditions — verify every one; if any fails, stop and report instead of merging:

1. Review complete: no unresolved threads, latest Copilot review generated no new comments.
2. All CI jobs green.
3. User approval (the user invoking this command counts).

Steps:

1. `gh pr merge <PR number> --merge --delete-branch`
2. `git checkout main && git pull`
3. If a version tag was given: `git tag -a <version> -m "<version>"` then `git push origin --tags`
4. Delete the local feature branch if it remains, then report completion in Japanese.
