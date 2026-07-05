---
description: Verify, check consistency, and commit with a Conventional Commits message
---

Commit the current changes following the repository conventions (AGENTS.md).

## Steps

1. Run `git status` and `git diff` (plus `git diff --staged` if anything is staged) to understand the changes.
2. Consistency check (skip only for trivial changes):
   - Commands and structure described in README / AGENTS.md match reality
   - Code comments and docs do not contradict the implementation
   - If the change involves a technology choice or design decision, an ADR exists in `docs/adr/`
   - If a Japanese document `<name>.md` changed and `<name>_en.md` exists, it is updated too
   - Fix inconsistencies before committing
3. Run the verification commands from the AGENTS.md "検証コマンド" table (test / lint / type check). Fix failures before committing. If the table is still "(未設定)", tell the user and proceed only with their consent.
4. Stage the related files explicitly (avoid `git add -A` when unrelated changes exist) and review `git diff --staged`.
5. Compose a Conventional Commits message:
   - First line: English, imperative mood, 50 characters or less (e.g. `feat: add filter feature`)
   - Body: Japanese, explaining background and content
6. Present the message to the user and commit after approval.
