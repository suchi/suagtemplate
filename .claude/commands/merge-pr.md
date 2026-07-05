---
description: Merge an approved PR, clean up the branch, and sync main
argument-hint: <PR number> [version tag]
---

Merge the PR given as the first argument of $ARGUMENTS after final checks.

## Preconditions (verify every one; do not skip)

1. Review is complete: no unresolved threads, and the latest Copilot review generated no new comments.
2. All CI jobs are green.
3. The user has explicitly approved the merge (the user invoking this command counts as approval).

If any precondition fails, stop and report instead of merging.

## Steps

1. `gh pr merge <PR number> --merge --delete-branch`
2. `git checkout main && git pull`
3. If a version tag was given as the second argument:
   a. `git tag -a <version> -m "<version>"`
   b. `git push origin --tags`
4. Delete the local feature branch if it still exists, then report completion in Japanese.
