# Personal global instructions

Personal settings shared across all repositories and projects. When a repository has its own `AGENTS.md`, that file takes precedence (this file complements it).

## Basic stance (Agentic Coding)

- Work in a style where I make the decisions — not fully hands-off vibe coding.
- When something is ambiguous or open to interpretation, do not decide on your own; present options with pros/cons and confirm.
- Get my confirmation before destructive operations (force push, `reset --hard`, deleting branches/files) and before git operations (commit, push, merge).
- Do not revert or overwrite my changes without an explicit request.

## Language

- Conversation, explanations, documents, and PR/Issue bodies: Japanese.
- PR/Issue titles, commit message first line, identifiers, branch names, comments in code, logs/error messages/UI labels: English.
- Commit message body: Japanese.
- Draw diagrams with Mermaid. Do not use ASCII-art diagrams.

## Development style

- Keep commits small (one commit = one logical change) and follow Conventional Commits.
- Never commit directly to `main`. Work on a branch and open a PR.
- Follow TDD (t_wada style): Red, Green, Refactor.
- Do not report "done" after merely committing and pushing. Confirm CI has passed and the change works before calling it done. If you cannot confirm, say "pushed, waiting for CI".

## Tool preferences

- For Python, use the uv ecosystem instead of pip (`uv sync --locked`, `uv run pytest`; always `--locked` in CI/CD).
- Be careful when adding new dependencies. Never remove supply-chain defenses (Dependabot `cooldown`, uv's `exclude-newer = "7d"`, etc.) without my approval.

## Environment

- Main development environments are Windows 11 (PowerShell) and WSL2. Confirm which environment applies before giving paths or command examples.

## When starting a new repository

- Agent configuration template: https://github.com/suchi/suagtemplate
- If a repository has no `AGENTS.md`, suggest adopting it from the template.
