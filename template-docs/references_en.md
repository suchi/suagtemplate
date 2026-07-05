# References — Official documents this template is based on

Official documentation consulted as best-practice sources for the design and content of this template. Referenced on: 2026-07-05. Tool specifications change frequently; when in doubt, always check the latest official documentation.

## Agent configuration mechanisms

| Document | Used for |
| --- | --- |
| [AGENTS.md specification](https://agents.md/) | Basis for the AGENTS.md single-source structure |
| [GitHub Changelog: Copilot code review and coding agent now support agent-specific instructions (2025-11-12)](https://github.blog/changelog/2025-11-12-copilot-code-review-and-coding-agent-now-support-agent-specific-instructions/) | Confirmation of Copilot's native AGENTS.md support (nearest directory wins) and `excludeAgent` |
| [GitHub Docs: Adding repository custom instructions for GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot) | Relationship between copilot-instructions.md, path-specific `*.instructions.md`, and AGENTS.md |
| [GitHub Changelog: Copilot code review: Customization for all (2025-06-13)](https://github.blog/changelog/2025-06-13-copilot-code-review-customization-for-all/) | Confirmation that code review reads copilot-instructions.md |
| [GitHub Docs: About GitHub Copilot code review](https://docs.github.com/en/copilot/concepts/agents/code-review) | Review operation (automatic review setup, language instruction) |
| [Claude Code Docs: Settings](https://code.claude.com/docs/en/settings) | Structure of `.claude/settings.json` and permissions |
| [Claude Code Docs: Hooks](https://code.claude.com/docs/en/hooks) | PreToolUse/PostToolUse hook spec, `permissionDecision` (deny/ask), exit code 2 behavior |
| [Claude Code Docs: Slash commands](https://code.claude.com/docs/en/slash-commands) | Format of `.claude/commands/*.md` (`$ARGUMENTS`, frontmatter) |
| [Claude Code Docs: Skills](https://code.claude.com/docs/en/skills) | Format of `.claude/skills/<name>/SKILL.md` |
| [Claude Code Docs: Memory (CLAUDE.md)](https://code.claude.com/docs/en/memory) | `@AGENTS.md` import and `~/.claude/CLAUDE.md` (personal memory) |
| [OpenAI Codex Docs: Config basics](https://developers.openai.com/codex/config-basic) | Codex AGENTS.md loading and `~/.codex/AGENTS.md` (global) |
| [OpenAI Codex Docs: Config reference](https://developers.openai.com/codex/config-reference) | AGENTS.md size limit, trusted/untrusted projects |

## Security

| Document | Used for |
| --- | --- |
| [Claude Code Docs: Security](https://code.claude.com/docs/en/security) | Prompt injection defenses (do not trust external content; curl/wget not auto-approved), permission architecture, best practices for untrusted content |
| [Claude Code Docs: Permission modes](https://code.claude.com/docs/en/permission-modes) | Each mode (acceptEdits etc.) and its relationship to hooks |
| [Claude Code Docs: Sandboxing](https://code.claude.com/docs/en/sandboxing) | Filesystem and network isolation |
| [GitHub Docs: Risks and mitigations for GitHub Copilot cloud agent](https://docs.github.com/en/copilot/concepts/agents/cloud-agent/risks-and-mitigations) | Coding agent mitigations (mandatory human review, Actions run approval, firewall, comments from users without write access are blocked) |
| [GitHub Docs: Best practices for using GitHub Copilot](https://docs.github.com/en/copilot/get-started/best-practices) | Understand generated code before adopting it; verify with automated tests and tooling |
| [GitHub Docs: Responsible use of Copilot cloud agent](https://docs.github.com/en/copilot/responsible-use/copilot-coding-agent) | Design such as mandatory human merge of agent PRs |
| [OpenAI Codex Docs: Agent approvals & security](https://developers.openai.com/codex/agent-approvals-security) | Separation of sandbox (technical boundary) and approval policy (human confirmation); confirmation of dangerous operations |
| [OpenAI Codex Docs: Sandboxing](https://developers.openai.com/codex/concepts/sandboxing) | Network disabled by default in workspace-write; cached web search reduces injection risk |
| [GitHub Docs: Dependabot options reference — cooldown](https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference#cooldown) | Specification of the cooldown setting as a supply-chain defense |
| [uv Docs: Settings — exclude-newer](https://docs.astral.sh/uv/reference/settings/#exclude-newer) | Supply-chain defense for Python dependencies (noted in personal configuration) |

## Development process and conventions

| Document | Used for |
| --- | --- |
| [Conventional Commits](https://www.conventionalcommits.org/) | Commit message convention |
| [GitHub Docs: GitHub flow](https://docs.github.com/en/get-started/using-github/github-flow) | Branch + PR development flow |
| [Architectural Decision Records](https://adr.github.io/) | ADR concepts and template structure |

## Notes

- In addition to the above, the template reflects operational knowledge accumulated in the owner's past repositories (cc-todo, cc-todo-next, sucheme-go, etc.), such as: Copilot re-reviews require `gh pr edit --add-reviewer @copilot`, gh 2.88.0 or later is needed, and closing/reopening a PR does not trigger a re-review. See [history_en.md](history_en.md) for background.
- `.github/copilot-code-review.yml` could not be confirmed in the official documentation as of the reference date (checked via search). It is bundled for compatibility.
