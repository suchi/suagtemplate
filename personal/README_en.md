# personal/ — Personal (per-machine) global configuration

Instructions that belong in personal memory (global configuration) rather than in each repository. Apply them to the agents when setting up a new machine or after updating the content.

## Contents

| File | Destination |
| --- | --- |
| `global-instructions.md` | `~/.claude/CLAUDE.md` (Claude Code), `~/.codex/AGENTS.md` (Codex) |
| `stop-hook-git-check.sh` | `~/.claude/stop-hook-git-check.sh` (the Claude Code Stop hook itself) |
| `claude-user-settings-snippet.json` | merged manually into `~/.claude/settings.json` (Stop hook registration) |
| `copilot-personal-instructions.md` | GitHub Copilot personal custom instructions (pasted manually) |

## How to apply

- Linux / macOS / WSL2: `./install.sh`
- Windows (PowerShell): `./install.ps1`

If an existing file has different content, it is backed up with a timestamped `.bak` suffix before being overwritten.

Manual steps that cannot be scripted:

- Stop hook registration: merge the content of `claude-user-settings-snippet.json` into `~/.claude/settings.json` (not automated, to avoid clobbering existing settings).
- Copilot personal instructions: paste following `copilot-personal-instructions.md`.

## About the Stop hook (git state check)

Before Claude Code finishes responding, it detects uncommitted changes, untracked files, commits that GitHub will show as Unverified, and unpushed commits, and notifies the agent.

- GitHub-generated commits (merge/squash commits with committer `noreply@github.com`) are excluded from the check, since they show as Verified on GitHub.
- The signature check only runs where `commit.gpgsign` is enabled (e.g. Claude Code on the web). If you sign locally with your own key, adjust `expected_email` at the top of the script.
- Claude Code on the web may provision a similar hook on the environment side; if the content differs, the installer backs it up.
- The hook is a bash script and the registration snippet's `command` assumes `$HOME`, so on Windows it assumes execution via Git Bash (WSL2 recommended). If `$HOME` does not resolve on native Windows, adjust the command in settings.json to run the script through Git Bash with a full path.

## Recommended global git configuration

- `git config --global fetch.prune true`: automatically cleans up remote-tracking refs for branches deleted on merge. Leaving them causes the Stop hook to falsely report "unpushed commits".

## Relationship with a repository's AGENTS.md

- Some overlap with `AGENTS.md` is intentional, so that the shared style also applies in repositories without an `AGENTS.md`.
- The repository's `AGENTS.md` always takes precedence. Keep only project-independent preferences in the personal configuration.

## In production repositories

In a repository created from the template for actual use, delete this folder (assuming each machine has already been set up). See `template-docs/setup-guide.md`.
