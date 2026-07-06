---
description: Doc consistency check, final commit, and push of the current branch
---

Prepare the current branch for a PR.

1. Run the checks defined in `.claude/commands/consistency-check.md`, then fix findings (doc-side errors in the docs, code-side errors in the code). Report what was fixed, or "consistency check OK".
2. Commit any remaining changes following the /commit procedure.
3. After user confirmation, push the branch (`git push -u origin <branch>` when upstream is unset). Report the pushed branch and, if a PR exists, its CI status.
