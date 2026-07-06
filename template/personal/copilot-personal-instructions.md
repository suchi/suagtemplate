# GitHub Copilot personal custom instructions

GitHub Copilot's personal custom instructions must be set manually.

Where to set:

- Copilot Chat on github.com: open https://github.com/copilot and paste into "Personal instructions" from the settings (gear) menu
- VS Code: apply the same content to the `github.copilot.chat` custom instruction settings, or to a profile-wide instructions file

Paste the text below the `---` as is (it is a condensed version due to length limits; the full version is `global-instructions.md`).

---

Write everything in English. Commit messages follow Conventional Commits with an imperative first line of 50 characters or less. When something is ambiguous, do not decide on your own; present options with pros/cons and confirm. Keep commits small; never commit directly to main — use a branch and a PR. Write tests first (TDD). Never hardcode secrets. If the repository has an AGENTS.md, follow it.
