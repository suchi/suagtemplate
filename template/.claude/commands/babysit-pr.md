---
description: Watch a PR, fix review findings, and loop until No New Comment
argument-hint: <PR number>
---

Check PR #$ARGUMENTS for unresolved review threads and the latest review, and handle them.

## Steps

1. Get the latest reviews: `gh api repos/{owner}/{repo}/pulls/$ARGUMENTS/reviews`
2. List unresolved threads (`isResolved: false`) via `gh api graphql`
3. For each finding:
   a. Fix the code and run the verification commands from AGENTS.md
   b. Commit (format per AGENTS.md) and push
   c. Reply to the thread describing the fix
      (`gh api repos/{owner}/{repo}/pulls/$ARGUMENTS/comments --method POST -f body="Fixed: ..." -F in_reply_to=COMMENT_ID`)
   d. Resolve the thread with the `resolveReviewThread` GraphQL mutation
4. Request a Copilot re-review: ALWAYS `gh pr edit $ARGUMENTS --add-reviewer @copilot` (requires gh >= 2.88.0). The REST endpoint `.../requested_reviewers` does not trigger a re-review on an already-reviewed PR.
5. When no unresolved threads remain and the latest review generated no new comments, report "No New Comment achieved". Do NOT merge — merging requires explicit user approval (/merge-pr).

## Environment adaptation

- Local Claude Code (gh available): follow the steps above as written. Re-run the loop after each round of fixes until No New Comment.
- Claude Code on the web (no gh): perform the same steps with the GitHub MCP tools, and subscribe to the PR with the `subscribe_pr_activity` tool so review comments and CI events arrive automatically. Request (re-)reviews with the `request_copilot_review` MCP tool — the gh command in step 4 is unavailable here, and the REST `requested_reviewers` endpoint must not be substituted for it. Handle each event with the loop above, and unsubscribe once the PR is merged or closed, or when the user says to stop.

## Important rules

- Reply BEFORE resolving a thread (prevents Copilot from repeating the finding).
- Never close/reopen or recreate the PR for a re-review (does not work; ruins history).
- Never call `DELETE .../requested_reviewers` (breaks reviewer state).
