---
name: sync-docs-en
description: Keep English (_en.md) versions of Japanese Markdown documents in sync. Use after editing a Japanese .md file that has a _en.md counterpart, when the check-docs-en-sync hook reminds you, or when creating a new Japanese document that needs an English version.
---

# Japanese/English document sync

Rule (AGENTS.md): the Japanese `<name>.md` is the source of truth; `<name>_en.md` is its English version and must be updated in the same commit.

## Procedure

1. Identify what changed in the Japanese file: `git diff -- <name>.md` (or treat the whole file as new).
2. Apply the same changes to `<name>_en.md`:
   - Translate prose naturally; do not translate code blocks, commands, file paths, or proper nouns.
   - Keep the heading structure and section order identical so the two files can be compared side by side.
   - Keep examples identical unless they are language-specific by design (e.g. commit message examples keep their Japanese bodies).
3. If `<name>_en.md` does not exist and the file is a content document, create it. The following do not get English versions by default:
   - thin pointer files (`CLAUDE.md`, `.github/copilot-instructions.md`)
   - per-project ADRs under `docs/adr/` (except the template files shipped with the repository template)
4. Commit both files together.
