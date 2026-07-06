---
description: Verify, check consistency, and commit with a Conventional Commits message
---

Commit the current changes following AGENTS.md.

1. Review the changes: `git status` and `git diff` (plus `git diff --staged` if anything is staged).
2. Quick consistency check (skip for trivial changes): docs match reality, and an ADR exists if the change involves a design decision. Fix issues before committing.
3. Run the verification commands from AGENTS.md (test / lint / type check). If the table is still unset, tell the user and proceed only with their consent.
4. Stage the related files explicitly (no blanket `git add -A` when unrelated changes exist) and review `git diff --staged`.
5. Write the message per the AGENTS.md commit rules (first line imperative, 50 chars or less; body explains background and content).
6. Show the message to the user; commit after approval.
