# template-docs/ — Documentation of the template itself

This folder documents **the template (suagtemplate) itself** and is deleted in repositories created from the template for actual use.

- Steps to apply to a new repository: [setup-guide_en.md](setup-guide_en.md)
- List of official documents consulted: [references_en.md](references_en.md)
- Per-agent operation notes (caveats the template cannot express): [agent-notes_en.md](agent-notes_en.md)
- What to change when switching to vibe coding (hands-off development): [vibe-coding_en.md](vibe-coding_en.md)
- Change history of the template (session records): [history_en.md](history_en.md)
- Japanese translations of the `.claude/` commands and skills (English): [ja/](ja/)

## Purpose of the template

A repository template preconfigured with standard precautions and my personal development style, so that starting development with GitHub Copilot, Claude Code, and Codex does not require copy-pasting instructions every time. It is oriented toward Agentic Coding, where the human makes the decisions — not fully hands-off vibe coding.

## Structure

```text
.
├── AGENTS.md / AGENTS_en.md      Single source of shared agent instructions (Japanese is canonical)
├── CLAUDE.md                     Pointer for Claude Code (only @AGENTS.md)
├── README.md / README_en.md      Repository README (rewritten in actual use)
├── .github/
│   ├── copilot-instructions.md   Thin pointer for Copilot + Japanese review instruction
│   ├── copilot-code-review.yml   Review language setting (compatibility; see below)
│   └── dependabot.yml            Dependency updates + supply-chain defense (cooldown)
├── .claude/
│   ├── settings.json             Secret-read deny rules + hook registration
│   ├── hooks/
│   │   ├── block-dangerous-git.sh    Guard against dangerous git operations
│   │   └── check-docs-en-sync.sh     Japanese/English doc sync reminder
│   ├── commands/                 /commit /ship /babysit-pr /consistency-check /merge-pr
│   └── skills/                   adr (create/supersede ADRs), sync-docs-en (ja/en sync)
├── docs/adr/                     ADR scaffolding (template + index)
├── personal/                     Personal (per-machine) global configuration (deleted in actual use)
└── template-docs/                This folder (deleted in actual use)
```

## Design principles

### AGENTS.md as the single source

Instructions are consolidated in `AGENTS.md`. Copilot and Codex read `AGENTS.md` natively; Claude Code imports it via `@AGENTS.md` in `CLAUDE.md`. Agent-specific files contain only tool-specific settings and never duplicate instructions.

### Keep instructions concise (one rule, one home)

Verbose instructions lower agent compliance, so norms are written briefly in AGENTS.md and procedural detail is split into referenced files. Each rule has exactly one canonical home: ADR rules in `docs/adr/README.md`, the consistency checklist in `.claude/commands/consistency-check.md`, commit conventions in AGENTS.md. Other files point there.

### Japanese/English sync rule

- The Japanese `<name>.md` is canonical; `<name>_en.md` is its English version. When the Japanese version changes, update the English version in the same commit.
- Exceptions (no English version): thin pointers such as `CLAUDE.md` and `.github/copilot-instructions.md`, and per-project ADRs in real projects.
- `.claude/commands/` and `.claude/skills/` are **English-based**, because placing `commit_en.md` inside `commands/` would register a duplicate `/commit_en` command. Japanese translations live in [ja/](ja/) (translations are best-effort; English is canonical for these files).

### Hooks

| Hook | Event | Behavior |
| --- | --- | --- |
| `block-dangerous-git.sh` | PreToolUse (Bash) | Denies direct/force pushes to main/master and `--no-verify`. Escalates force push (other branches), `reset --hard`, `clean -f`, `branch -D`, committing on main, piping downloaded scripts into a shell (`curl \| sh` etc.), and staging `.env` files to a user confirmation (ask) |
| `protect-config.sh` | PreToolUse (Edit/Write) | Escalates changes to security-defining files (`.claude/settings.json`, `.claude/hooks/`, `.github/workflows/`, `.github/dependabot.yml`) to a user confirmation (ask), preventing the agent from removing its own guardrails |
| `check-docs-en-sync.sh` | PostToolUse (Edit/Write) | When a Japanese md with an `_en.md` counterpart is edited, reminds the agent to update the English version in the same change |

The hooks are shell scripts; on Windows they run via Git Bash (the same prerequisite as Claude Code's Bash tool). They use `jq` for precise matching when available and fall back to pattern-matching the raw payload otherwise.

### About copilot-code-review.yml

`.github/copilot-code-review.yml` (`language: "ja"`) is not documented in the official GitHub docs as of 2026-07. It is kept for compatibility with an earlier repository (cc-todo), but the reliable way to get Japanese reviews is the instruction inside `.github/copilot-instructions.md`, which is the primary mechanism.

## When changing this template itself

1. Make changes on a feature branch (this repository also follows the AGENTS.md flow).
2. Update the Japanese and English versions together.
3. Append the background of the change to [history.md](history.md).
