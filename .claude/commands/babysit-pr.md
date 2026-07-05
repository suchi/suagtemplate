---
description: Watch a PR, fix review findings, and loop until No New Comment
argument-hint: <PR number>
---

Check PR #$ARGUMENTS for unresolved review threads and the latest review, and handle them.

## Steps

1. Get the latest reviews: `gh api repos/{owner}/{repo}/pulls/$ARGUMENTS/reviews`
2. List unresolved threads (`isResolved: false`) via `gh api graphql`
3. If there are findings:
   a. Fix the code
   b. Run the verification commands from AGENTS.md (test / lint / build)
   c. Commit and push (Conventional Commits: first line English, body Japanese)
   d. Reply to each thread describing the fix, in Japanese
      (`gh api repos/{owner}/{repo}/pulls/$ARGUMENTS/comments --method POST -f body="修正しました: ..." -F in_reply_to=COMMENT_ID`)
   e. Resolve the thread with the `resolveReviewThread` GraphQL mutation
   f. Request a Copilot re-review (see below)
4. When there are no unresolved threads and the latest review generated no new comments, report "No New Comment 達成". Do NOT merge — merging requires explicit user approval (/merge-pr).

## Requesting Copilot reviews

- Initial request: `gh pr create --add-reviewer @copilot`, or after creation `gh pr edit $ARGUMENTS --add-reviewer @copilot`
- Re-review after fixes: ALWAYS use `gh pr edit $ARGUMENTS --add-reviewer @copilot` (requires gh >= 2.88.0; check with `gh --version`).
  The REST endpoint `.../requested_reviewers` does not trigger a re-review on an already-reviewed PR.

## Important rules

- Always post the reply comment BEFORE resolving a thread (prevents Copilot from repeating the same finding).
- Never close/reopen or recreate the PR to trigger a re-review (it does not work and it ruins history).
- Never call `DELETE .../requested_reviewers` (breaks reviewer state).
