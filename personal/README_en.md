# personal/ — Personal (per-machine) global configuration

Instructions that belong in personal memory (global configuration) rather than in each repository. Apply them to the agents when setting up a new machine or after updating the content.

## Contents

| File | Destination |
| --- | --- |
| `global-instructions.md` | `~/.claude/CLAUDE.md` (Claude Code), `~/.codex/AGENTS.md` (Codex) |
| `copilot-personal-instructions.md` | GitHub Copilot personal custom instructions (pasted manually) |

## How to apply

- Linux / macOS / WSL2: `./install.sh`
- Windows (PowerShell): `./install.ps1`

If an existing file has different content, it is backed up with a timestamped `.bak` suffix before being overwritten.

Copilot personal instructions cannot be scripted; paste them manually following `copilot-personal-instructions.md`.

## Relationship with a repository's AGENTS.md

- Some overlap with `AGENTS.md` is intentional, so that the shared style also applies in repositories without an `AGENTS.md`.
- The repository's `AGENTS.md` always takes precedence. Keep only project-independent preferences in the personal configuration.

## In production repositories

In a repository created from the template for actual use, delete this folder (assuming each machine has already been set up). See `template-docs/setup-guide.md`.
