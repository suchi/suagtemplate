# AGENTS.md — Shared instructions for AI coding agents

This file is the single source of truth for instructions to all AI coding agents such as GitHub Copilot, Claude Code, and Codex. Add or change instructions in this file. Agent-specific files (`CLAUDE.md`, `.github/copilot-instructions.md`) are kept thin and point back to this file.

This file contains placeholders starting with `TODO(project):`. After creating a new repository from the template, fill them in following `template-docs/setup-guide.md`.

## Project overview

<!-- TODO(project): describe the project's purpose, tech stack, and target environment in 2-5 lines -->

(Not set — write an overview of this repository here)

## Verification commands

<!-- TODO(project): replace with the actual commands for this repository -->

| Purpose | Command |
| --- | --- |
| Setup | (not set) |
| Test | (not set) |
| Lint / format | (not set) |
| Type check | (not set) |
| Build | (not set) |

- Always run tests and lint before committing and confirm they are green.
- If this table is still "(not set)", ask the user to configure it before starting implementation work.

## How to work (Agentic Coding)

This repository is developed with Agentic Coding, where the human makes the decisions — not fully hands-off vibe coding.

- When something is ambiguous or open to interpretation, do not decide on your own; present options with pros/cons and confirm.
- Always get the user's confirmation before:
  - destructive operations such as force push, `reset --hard`, or deleting branches/files
  - major decisions affecting architecture, dependencies, or data formats
  - merging a PR
- Do not revert or overwrite changes made by the user without an explicit request.
- For larger features, agree on a plan (SOW) first, then implement. Save plans under `docs/plans/`.
- Record important instructions received during sessions, and points raised repeatedly, by appending them to this file (when appending, update `AGENTS.md` and this file together — the Japanese file is the source of truth).

## Language rules

| Target | Language |
| --- | --- |
| Conversation, explanations, progress reports | Japanese |
| Documents (*.md), PR/Issue bodies, review comments | Japanese |
| PR/Issue titles | English |
| Commit message first line | English |
| Commit message body | Japanese |
| Identifiers (variables, functions, file names), branch names | English |
| Comments in code | English |
| Logs, error messages, UI labels | English |

<!-- TODO(project): override this table if UI labels etc. should be in Japanese -->

- Draw diagrams with Mermaid (`flowchart`, `sequenceDiagram`, etc.). Do not use ASCII-art diagrams.
- Do not use emoji in documents.

## Development flow

- Follow GitHub Flow. Committing or pushing directly to `main` is forbidden.
- Branch names are English kebab-case: `feature/xxx`, `fix/xxx`, `docs/xxx`, `chore/xxx`.
- Follow TDD (t_wada style):
  1. Red: write a failing test first
  2. Green: write the minimum implementation that passes
  3. Refactor: clean up while keeping tests green
- Keep commits small: one commit = one logical change. Push to the branch at each milestone.
- Do not add speculative features or abstractions (YAGNI).

## Commit messages

Follow Conventional Commits.

```text
<type>: <subject>   <- English, imperative mood, 50 chars or less

<body>              <- explain background and content in Japanese
```

- type: `feat` / `fix` / `docs` / `test` / `refactor` / `chore` / `style` / `ci`
- Example:

```text
feat: add todo filter feature

フィルター機能(すべて・未完了・完了)を追加した。
```

## PR, review, and merge

1. Work on a feature branch and create a PR (title in English, body in Japanese).
2. Do not write `\n` literals in PR bodies. Use real line breaks (`--body-file` recommended).
3. Request a Copilot review (`gh pr edit <number> --add-reviewer @copilot`).
4. Address findings with follow-up commits, reply to each review thread describing the fix, then resolve the thread.
5. Request a re-review and repeat steps 4-5 until there are no new comments ("No New Comment").
6. Confirm that all CI jobs are green.
7. Merge only when all three are satisfied: review complete, CI green, and user approval.

Forbidden:

- Merging with an unfinished review or failing CI. Do not skip based on your own judgment such as "it is taking too long".
- Closing and recreating a PR to trigger a re-review (it destroys history, and close/reopen does not trigger a re-review anyway).
- Reporting "done" after merely committing and pushing. It is not done until CI has passed and the merge state is confirmed. If you cannot confirm, report "pushed, waiting for CI".

## Documentation

### Consistency

- Keep README, this file, and `docs/` consistent with reality in the code (command names, structure, dependencies).
- When adding, deleting, or renaming files, update related documentation in the same change.

### Japanese/English sync

- The Japanese document `<name>.md` is the source of truth; `<name>_en.md` is its English version.
- Whenever the Japanese version changes, update `<name>_en.md` in the same commit.
- Thin pointer-only files such as `CLAUDE.md` and `.github/copilot-instructions.md` do not get English versions.

### ADR (Architecture Decision Records)

- Record technology choices and design decisions in `docs/adr/NNNN-title.md` (template: `docs/adr/0000-template.md`).
- Never overwrite or edit an existing ADR. When a decision changes, deprecate the old ADR and create a new one with the next number (procedure: `docs/adr/README.md`).
- When keeping the status quo for technical or environmental reasons despite review findings, add a `Why:` comment (1-3 lines) at the relevant code and record it in an ADR as well.

## Security

- Never hardcode secrets, tokens, or credentials. Use environment variables or secret managers in examples.
- Validate external inputs; sanitize file paths and user-provided data.
- Pin dependencies to stable versions; avoid unmaintained libraries.
- The `cooldown` setting in `.github/dependabot.yml` is an important defense against supply-chain attacks. Even if a review tool flags it as an "invalid key", verify against the official documentation and fix it to follow the spec. Never delete or disable it without the user's explicit approval.
- Always confirm with the user before removing or loosening any security-related configuration (CI, dependency management, permissions).

## Per-agent configuration files

| Tool | Loading | Notes |
| --- | --- | --- |
| Claude Code | `CLAUDE.md` (imports via `@AGENTS.md`) | commands, skills, and hooks live under `.claude/` |
| GitHub Copilot | Native `AGENTS.md` support | `.github/copilot-instructions.md` only sets the review language |
| OpenAI Codex | Native `AGENTS.md` support | global configuration is `~/.codex/AGENTS.md` |

Add or change instructions in this file; write only tool-specific settings in the agent-specific files.
