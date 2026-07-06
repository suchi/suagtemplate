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

Before Claude Code finishes responding, it detects uncommitted changes, untracked files, commits with signature problems (unsigned, broken signature, or a committer email that does not match the expected one — these typically show as Unverified on GitHub), and unpushed commits, and notifies the agent.

- GitHub-generated commits (merge/squash commits with committer email `noreply@github.com`) are signed with GitHub's web-flow key and show as Verified, so they are exempt from the committer-email mismatch check (unsigned/broken signatures are detected regardless of committer email).
- The signature check only runs where `commit.gpgsign` is enabled (e.g. Claude Code on the web). If you sign locally with your own key, adjust `expected_email` at the top of the script.
- Claude Code on the web may provision a similar hook on the environment side; if the content differs, the installer backs it up.
- On native Windows, [Microsoft Core Utils](https://learn.microsoft.com/en-us/windows/core-utils/overview) is assumed to be available ([microsoft/coreutils](https://github.com/microsoft/coreutils): a Microsoft build of the uutils coreutils, findutils, and grep; `winget install Microsoft.Coreutils`). However, bash, awk, and sed are not included, so the hook itself (a bash script) runs through Git Bash — the same requirement as Claude Code's Bash tool. If `$HOME` does not resolve, adjust the command in settings.json to a full path.

## Recommended global git configuration

- `git config --global fetch.prune true`: automatically cleans up remote-tracking refs for branches deleted on merge. Leaving them causes the Stop hook to falsely report "unpushed commits".

## Relationship with a repository's AGENTS.md

- Some overlap with `AGENTS.md` is intentional, so that the shared style also applies in repositories without an `AGENTS.md`.
- The repository's `AGENTS.md` always takes precedence. Keep only project-independent preferences in the personal configuration.

## In production repositories

In a repository created from the template for actual use, delete this folder (assuming each machine has already been set up). See `template-docs/setup-guide.md`.
