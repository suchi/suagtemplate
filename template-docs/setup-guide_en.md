# Setup guide — Creating a production repository from the template

Steps for starting a new repository/project from this template.

## 1. Create the repository

- If this repository is configured as a template repository on GitHub, create a new repository via "Use this template".
- Otherwise, clone it and replace the remote.
- When retrofitting the template onto an existing repository, run `git add --renormalize .` after adding the template files to normalize line endings. Files stored with CRLF before `.gitattributes` existed are not fixed just by adding the attributes (this causes the "shown as modified though untouched" symptom).

## 2. Apply the personal global configuration (first time only)

This only needs to be done once per machine. If not done yet:

- Linux / macOS / WSL2: `personal/install.sh`
- Windows (PowerShell): `personal/install.ps1`
- Copilot personal instructions: paste manually following `personal/copilot-personal-instructions.md`

## 3. Delete the template-only folders

```bash
git rm -r template-docs personal
```

This can happen before or after the first commit, but record the deletion in the commit message.

## 4. Rewrite the README

Rewrite `README.md` and `README_en.md` for the project.

## 5. Fill in the AGENTS.md placeholders

Search for the `TODO(project)` markers:

```bash
grep -rn "TODO(project)" .
```

Things to fill in:

- Project overview: purpose, tech stack, and target environment in 2-5 lines
- Verification commands: the actual setup/test/lint/type-check/build commands (most important — the commands, hooks, and CI all depend on this)
- Language rule overrides: e.g. when UI labels should be Japanese (default is all English)

Apply the same changes to `AGENTS_en.md`.

## 6. Enable ecosystems in dependabot.yml

Uncomment the blocks for the ecosystems actually used (npm, uv, gomod, ...) in `.github/dependabot.yml`. Always keep the `cooldown` settings — they are a supply-chain defense.

## 7. Create the CI workflow

Create a workflow under `.github/workflows/` that runs the same verification commands as AGENTS.md.

- Target branches: pushes to `main` and pull_requests targeting `main` (plus pushes to `feature/**` etc. if needed)
- Minimum: test + lint + build
- Verify that action version tags actually exist before pinning them (some actions support short tags like `v4`, others require full versions)

## 8. GitHub repository settings (in the browser)

- Branch protection / ruleset (main): require PRs, require CI status checks, forbid direct pushes
- Automatic Copilot code review: enable "Request pull request review from Copilot" in a ruleset (or consistently use `--add-reviewer @copilot` when creating PRs)
- Actions permission (only if creating PRs from GitHub Actions): Settings → Actions → enable "Allow GitHub Actions to create and approve pull requests" (cannot be changed via API)
- Labels: create them beforehand if using `gh pr create --label` (specifying a nonexistent label fails)

## 9. Decide the license

Add a LICENSE file, or state the no-license policy explicitly in the README.

## 10. Verification checklist

- [ ] `/commit`, `/ship`, etc. are visible in Claude Code
- [ ] The hook works: asking the agent to run `git push origin main` gets blocked
- [ ] The hook works: editing a Japanese md that has an `_en.md` triggers the sync reminder
- [ ] Copilot (including code review) references the AGENTS.md conventions
- [ ] Codex reads AGENTS.md and responds in Japanese
- [ ] CI runs on PRs
- [ ] `grep -rn "TODO(project)" .` finds nothing

## 11. Per-project customization candidates

- See [agent-notes_en.md](agent-notes_en.md) for detailed per-agent caveats (copy needed items into AGENTS.md).
- To move toward hands-off development (vibe coding), loosen things following [vibe-coding_en.md](vibe-coding_en.md) (never loosen the security gates).

Adjust AGENTS.md (and the _en version) as needed:

- Make UI labels / ARIA labels Japanese (override the language rule table)
- Allow emoji in documents
- Add a rule against spaces between ASCII and Japanese characters (for environments where the renderer inserts them automatically)
- Add test coverage targets and test count standards
- Add parallel subagent operation patterns (for larger projects)
- Add framework-specific conventions (e.g. enforcing named imports for React types)
