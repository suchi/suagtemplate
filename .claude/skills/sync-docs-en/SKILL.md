---
name: sync-docs-en
description: Keep English (_en.md) versions of Japanese Markdown documents in sync. Use after editing a Japanese .md file that has a _en.md counterpart, when the check-docs-en-sync hook reminds you, or when creating a new Japanese document that needs an English version.
---

# Japanese/English document sync

Rule (AGENTS.md): the Japanese `<name>.md` is the source of truth; update `<name>_en.md` in the same commit.

1. Check what changed: `git diff -- <name>.md` (or treat the file as new).
2. Mirror the change in `<name>_en.md`: translate prose naturally; keep headings, section order, code blocks, commands, paths, and proper nouns identical so the files can be compared side by side.
3. If `<name>_en.md` does not exist, create it — except for thin pointer files (`CLAUDE.md`, `.github/copilot-instructions.md`) and per-project ADRs, which stay Japanese-only.
4. Commit both files together.
