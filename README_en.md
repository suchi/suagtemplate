# suagtemplate — Agent configuration template

A repository template with default configuration for developing with GitHub Copilot, Claude Code, and Codex.

Agent instructions are consolidated in `AGENTS.md` at the repository root as the single source of truth. Agent-specific files (`CLAUDE.md`, `.github/copilot-instructions.md`) are kept thin and point back to `AGENTS.md`.

## How to use this template

- About the template itself and its structure: [template-docs/README_en.md](template-docs/README_en.md)
- Steps to apply it to a new repository: [template-docs/setup-guide_en.md](template-docs/setup-guide_en.md)
- Personal (per-machine) global configuration: [personal/README_en.md](personal/README_en.md)

In a repository created from this template, delete `template-docs/` and `personal/`, and rewrite this README as the project README (see the setup guide).

## About languages

The Japanese document `<name>.md` is the source of truth and `<name>_en.md` is its English version. Whenever the Japanese version changes, the English version must be updated in the same change.
