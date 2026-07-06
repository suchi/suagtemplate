# Personal global instructions

Personal settings shared across all repositories. When a repository has its own `AGENTS.md`, that file takes precedence.

## How to work

- Work in Agentic Coding style, where I decide. When something is ambiguous, do not decide on your own; present options with pros/cons and confirm.
- Get my confirmation before destructive operations (force push, `reset --hard`, deletion) and before git operations (commit, push, merge).
- Do not revert my changes without an explicit request.
- On unexpected behavior, identify the root cause before acting. Never route around it with a workaround while the cause is unknown.
- Report "done" only after CI has passed and behavior is confirmed. If unconfirmed, say "pushed, waiting for CI".

## Language

- Write everything in English: conversation, documents, PR/Issue titles and bodies, commit messages, identifiers, comments in code, logs, error messages, and UI labels.
- Draw diagrams with Mermaid (no ASCII art).

## Development style

- One commit = one logical change. Follow Conventional Commits.
- Never commit directly to `main`. Work on a branch and open a PR.
- TDD (t_wada style): Red → Green → Refactor.

## Tools and environment

- For Python use uv, not pip (`uv sync --locked`, `uv run pytest`; always `--locked` in CI/CD).
- Add dependencies carefully. Never remove supply-chain defenses (Dependabot `cooldown`, uv's `exclude-newer = "7d"`, etc.) without my approval.
- Main environments are Windows 11 (PowerShell) and WSL2. Confirm which one applies before giving paths or command examples.
- On native Windows, assume Microsoft Core Utils (the official coreutils implementation) is available: https://learn.microsoft.com/en-us/windows/core-utils/overview

## When starting a new repository

- If a repository has no `AGENTS.md`, suggest adopting it from the agent configuration template (the suagtemplate repository).
