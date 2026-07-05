# Maintenance guide — Operating principles for the template itself

Principles and recommended procedures for evolving this repository (the template itself). For procedures on the side of repositories created from the template, see [setup-guide_en.md](setup-guide_en.md).

## Principles

1. This repository itself follows the AGENTS.md flow (feature branch + PR + Copilot review + merge with user approval).
2. Keep "one rule, one home" (see the design principles in [README_en.md](README_en.md)). When adding a new norm, pick exactly one canonical home and point everything else there.
3. Only generic content goes into the template. Project-specific instructions belong in the setup guide's customization candidates.
4. Every change requires: Japanese/English sync, an entry in [history_en.md](history_en.md), and consistency of related documents.
5. Never write individual account information or repository names into the template or its documentation (stating that something is based on past experience is fine).

## Recommended procedure per change type

### Feeding back knowledge from real projects

1. Periodically review the additions accumulated in the AGENTS.md of production repositories.
2. Promote only instructions that proved useful in multiple projects, rewritten in generic form, into the template's AGENTS.md (or the appropriate canonical home).
3. Record in history.md what the knowledge is for.

### Changing hooks or settings.json

1. After a change, run `sh template-docs/tests/hook-tests.sh` and confirm all cases pass.
2. When adding or changing a guard, add test cases in the same change.
3. These files are covered by protect-config.sh's ask; proceed through the confirmation (be especially careful with changes that remove guards).

### Changing commands or skills

1. Change the English originals and sync the Japanese translations under `template-docs/ja/`.
2. After renaming commands or renumbering steps, grep for references (vibe-coding.md etc.).

### Tracking official specifications (periodic)

- Roughly quarterly, review the documents in [references_en.md](references_en.md) and follow up on spec changes (config file formats, AGENTS.md support status, security recommendations). Update the reference date after checking.
- When supporting a new agent/tool, update together: the "Per-agent configuration files" table in AGENTS.md, agent-notes, references, and the setup guide.

## Release operation

- Tag at milestones after larger structural changes (e.g. `v1.0.0`).
- The template is used by copying, so changes do not propagate automatically to existing production repositories; each repository pulls in needed changes manually. State breaking changes (file renames, hook behavior changes) in history.md.

## Checklist before opening a PR

- [ ] When hooks changed: `sh template-docs/tests/hook-tests.sh` all passing
- [ ] Japanese/English sync (the `_en.md` of changed Japanese docs; the `ja/` translations of English-based commands/skills)
- [ ] `grep -rn "TODO(project)"` output is as intended (template placeholders are not lost)
- [ ] No account information or individual repository names included
- [ ] history.md (+_en) updated
