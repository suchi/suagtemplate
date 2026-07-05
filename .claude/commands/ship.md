---
description: Doc consistency check, final commit, and push of the current branch
---

Prepare the current branch for a PR: check documentation consistency, commit remaining changes, and push.

## 1. Documentation vs implementation

Read the project documents (README.md, AGENTS.md, docs/) and compare them with reality:

- command and script names (do they exist and work as documented?)
- file paths and directory layout described in docs
- dependency names and versions vs the actual manifests
- feature descriptions vs actual behavior
- no remaining references to deleted or renamed files
- Japanese/English document pairs (`<name>.md` / `<name>_en.md`) are in sync

## 2. Fix inconsistencies

- Fix doc-side errors in the docs and code-side errors in the code.
- Report to the user what was fixed and how.
- If nothing was found, report "整合性OK" and continue.

## 3. Final commit

Only when there are changes. Follow the /commit procedure (verification commands, Conventional Commits message, user confirmation).

## 4. Push

- After user confirmation, push the current branch (`git push -u origin <branch>` when upstream is unset).
- Report the pushed branch name and, if a PR exists, its CI status.
