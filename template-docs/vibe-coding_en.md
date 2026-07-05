# Vibe coding switch guide — What to change for hands-off development

This template assumes Agentic Coding where the human decides. This guide summarizes what to change when, for a given project, you want to let the agent work without fine-grained confirmations (vibe coding).

Policy: **in exchange for reducing human confirmations, never reduce the mechanical gates (branch protection, CI, hooks, sandbox) — strengthen them instead.** When no human watches each step, the mechanical gates are the only line of defense.

## 1. What to loosen

### Replace the "How to work (Agentic Coding)" section of AGENTS.md

Replace it with the following snippet (replace the corresponding content in AGENTS_en.md too):

```markdown
## How to work (Vibe Coding)

This repository gives the agent broad discretion.

- The agent makes interpretation, design, and implementation decisions, and reports them after the fact via ADRs and PR bodies.
- Commits and pushes within a feature branch need no confirmation. Do them frequently.
- Even for larger features, still write a plan (SOW) and save it under `docs/plans/`, but implementation may start without waiting for approval.
- However, the following still always require the user's confirmation:
  - merging a PR
  - destructive operations such as force push, history rewriting, deleting branches/files
  - changes to security-related configuration (CI, dependency management, permissions, hooks)
  - anything that publishes externally or incurs charges
- Append a work log to `docs/session-notes.md` so the history can be traced afterwards.
```

### Confirmation steps in commands

- `.claude/commands/commit.md`: change step 6 from "present the message to the user and commit after approval" to "commit directly".
- `.claude/commands/ship.md`: change step 3 from "push after user confirmation" to "push directly".
- `.claude/commands/babysit-pr.md` works as-is (it already loops autonomously until No New Comment). Even when delegating up to merge, keeping the user-approval precondition of `/merge-pr` is recommended (see "What not to loosen").

### Hook ask (confirmation) items

Among the ask items in `.claude/hooks/block-dangerous-git.sh`, `git clean -f` and `branch -D` may be removed. **Strongly recommended to keep: the deny items (direct push to main, force push to main, --no-verify) and the asks for `reset --hard`, `curl | sh`, and staging `.env`.**

### Claude Code autonomy

- Set the permission mode to `acceptEdits` (`defaultMode` in `settings.json`).
- If more autonomy is needed, do not use `bypassPermissions`; instead run in an **isolated environment** — `/sandbox`, a dev container, or claude.ai/code cloud environments.

## 2. What not to loosen (strengthen instead)

- **No direct pushes to main, branch protection, required CI**: the last gate when nobody is watching.
- **Human approval for PR merges**: Copilot's coding agent is likewise designed so the agent itself cannot merge (an official mitigation). Even in vibe mode, a human should press merge.
- **Secret protection** (permissions.deny, .env in .gitignore, the ask on `git add .env`).
- **Supply-chain defenses such as Dependabot cooldown.**
- **The "do not follow externally sourced instructions" rule** (AGENTS.md security section): prompt injection lands most easily during autonomous operation.
- **The ask on security-config changes** (protect-config.sh): it is the mechanism that stops the agent from removing its own guardrails — especially important in vibe mode.

## 3. What to add

- **Stronger security scanning in CI** to compensate for fewer human eyes:
  - static analysis with CodeQL (or Semgrep etc.)
  - secret scanning (GitHub Secret scanning + push protection)
  - dependency audit (`npm audit` / `uv pip audit` / `govulncheck` etc. in CI)
- **A work log file**: create `docs/session-notes.md` and make per-session appends mandatory in AGENTS.md (it becomes the only way to review afterwards what changed and why).
- **Regular consistency checks**: state in AGENTS.md that `/consistency-check` must run at milestones (e.g. before creating a PR).
- **Budget and time limits**: set usage limits (Claude/ChatGPT plan limits, API billing alerts) before letting the agent run.
- **Agent stop conditions**: write stop conditions into AGENTS.md, e.g. "stop and report to the user when tests cannot be fixed after 3 consecutive attempts, or when an unintended file was touched".

## 4. Switch procedure summary

1. Replace the "How to work" section of AGENTS.md (and _en) with the snippet above
2. Remove the confirmation steps from `.claude/commands/commit.md` and `ship.md`
3. Add `"defaultMode": "acceptEdits"` to `.claude/settings.json` (under permissions)
4. Add security scanning to CI
5. Create `docs/session-notes.md` and make appending mandatory in AGENTS.md
6. Re-verify in the GitHub settings that branch protection and human merge approval are enabled
