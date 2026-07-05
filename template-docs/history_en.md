# Template change history (session records)

A record of the process of improving this template together with agents. For each session that changes the template, append the requests, decisions, and design judgments.

## 2026-07-05: Initial version (session with Claude Code)

### Requests

- Create a repository template with default configuration for GitHub Copilot, Claude Code, and Codex
- Oriented toward Agentic Coding where the human decides, not vibe coding
- Include standard precautions plus the personal development style extracted from past repositories
- Documents are Japanese-based, with English versions as `<filename>_en.md`, updated together
- Things that belong in personal memory (global configuration) rather than the repository are created separately
- Use skills/hooks where they fit better than AGENTS.md text
- Separate the documentation of the template itself, so that in actual use the repository works as-is once that folder is removed
- Also create a setup guide for applying the template to a production repository

### Past repositories used as reference

cc-todo, cc-todo-next, copyhooker, dotfiles-fm, gctetris, sucheme-go, sucheme-ruby, sucheme-python, tbpview, yfatest (each repository's AGENTS.md, CLAUDE.md, copilot-instructions.md, commands, etc.)

### Decisions made during the session (Q&A)

1. Create the `.claude/` commands and skills in English, with Japanese translations in `template-docs/ja/` (avoids the problem that placing `commit_en.md` in `commands/` registers a duplicate `/commit_en` command)
2. Personal configuration takes the form of `personal/` + apply scripts (`install.sh` / `install.ps1`)
3. Include the ADR scaffolding (`docs/adr/`) in the template
4. Strings embedded in code (logs, errors, UI labels) default to English, overridable per project

### Main design judgments

- **AGENTS.md as single source**: Copilot and Codex support AGENTS.md natively (Copilot code review / coding agent support confirmed in the 2025-11 GitHub changelog). Claude Code imports it via `@AGENTS.md` in `CLAUDE.md`.
- **No _en versions for thin pointer files**: `CLAUDE.md` and `.github/copilot-instructions.md` are excluded from translation; the rule is stated in AGENTS.md.
- **Hooks**: (1) dangerous-git guard — denies direct/force pushes to main/master and `--no-verify`; escalates other destructive operations to ask (confirmation appears even in auto-accept modes). (2) ja/en sync reminder — notifies the agent when a Japanese md with an `_en.md` counterpart is edited.
- **Skills**: `adr` (creating/deprecating ADRs) and `sync-docs-en` (ja/en sync procedure). Designed so the hook reminder and the skill work together.
- **copilot-code-review.yml**: confirmed to be absent from the official docs as of 2026-07. Kept for compatibility with cc-todo, while the Japanese-review instruction inside `copilot-instructions.md` is the primary mechanism.
- **Dependabot cooldown**: included as a standard supply-chain defense, with "never remove without approval" stated in the AGENTS.md security section (preventing a recurrence of the deletion incident that happened in sucheme-go).
- **Not adopted**: the no-emoji rule (tbpreview) was adopted as standard; the no-space-between-ASCII-and-Japanese rule (tbpreview) is renderer-dependent, so it is a customization candidate in the setup guide instead. The parallel subagent operation patterns (cc-todo-next) are highly project-dependent and likewise listed as a customization candidate.
