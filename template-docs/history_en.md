# Template change history (session records)

A record of the process of improving this template together with agents. For each session that changes the template, append the requests, decisions, and design judgments.

## 2026-07-05: Initial version (session with Claude Code)

### Requests

- Create a repository template with default configuration for GitHub Copilot, Claude Code, and Codex
- Oriented toward Agentic Coding where the human decides, not vibe coding
- Include standard precautions plus the personal development style extracted from past repositories
- Documents are Japanese-based, with English versions as `<filename>_en.md`, updated together
- Things that belong in personal memory (global configuration) rather than the repository are created separately
- Use skills/hooks where they fit better than AGENTS.md text
- Separate the documentation of the template itself, so that in actual use the repository works as-is once that folder is removed
- Also create a setup guide for applying the template to a production repository

### Reference material

The full set of agent configuration files (AGENTS.md, CLAUDE.md, copilot-instructions.md, commands, etc.) from the owner's past repositories. As a policy, details such as individual repository names, account information, and counts are not recorded in this repository's documentation.

### Decisions made during the session (Q&A)

1. Create the `.claude/` commands and skills in English, with Japanese translations in `template-docs/ja/` (avoids the problem that placing `commit_en.md` in `commands/` registers a duplicate `/commit_en` command)
2. Personal configuration takes the form of `personal/` + apply scripts (`install.sh` / `install.ps1`)
3. Include the ADR scaffolding (`docs/adr/`) in the template
4. Strings embedded in code (logs, errors, UI labels) default to English, overridable per project
5. PR/Issue titles are English only; bodies are Japanese (made explicit after the auto-generated body of PR #1 came out in English; reflected in the AGENTS.md language rule table, the PR conventions, and the personal configuration)

### Main design judgments

- AGENTS.md as single source: Copilot and Codex support AGENTS.md natively (Copilot code review / coding agent support confirmed in the 2025-11 GitHub changelog). Claude Code imports it via `@AGENTS.md` in `CLAUDE.md`.
- No _en versions for thin pointer files: `CLAUDE.md` and `.github/copilot-instructions.md` are excluded from translation; the rule is stated in AGENTS.md.
- Hooks: (1) dangerous-git guard — denies direct/force pushes to main/master and `--no-verify`; escalates other destructive operations to ask (confirmation appears even in auto-accept modes). (2) ja/en sync reminder — notifies the agent when a Japanese md with an `_en.md` counterpart is edited.
- Skills: `adr` (creating/deprecating ADRs) and `sync-docs-en` (ja/en sync procedure). Designed so the hook reminder and the skill work together.
- copilot-code-review.yml: confirmed to be absent from the official docs as of 2026-07. Kept for compatibility with past repositories, while the Japanese-review instruction inside `copilot-instructions.md` is the primary mechanism.
- Dependabot cooldown: included as a standard supply-chain defense, with "never remove without approval" stated in the AGENTS.md security section (preventing a recurrence of a deletion incident that happened in a past repository).
- Not adopted: the no-emoji rule was adopted as standard; the no-space-between-ASCII-and-Japanese rule is renderer-dependent, so it is a customization candidate in the setup guide instead. The parallel subagent operation patterns are highly project-dependent and likewise listed as a customization candidate.

## 2026-07-05: Security hardening, references, operation notes, and vibe coding switch guide

### Requests

1. Record the official documents consulted as best-practice sources
2. Check against the official security recommendations of Anthropic, GitHub, and OpenAI (both preventing vulnerabilities in product code and guarding against dangerous agent behavior), and reflect what is missing
3. Add caveats for using this template with the three tools that the template itself cannot express
4. Make clear what to change for vibe-coding-style development

### Result of the check against official recommendations

Among the recommendations common to the three vendors, the following were missing in the initial version and were reflected this time:

- Do not follow instructions in externally sourced content (prompt injection defense): added to the AGENTS.md security section (pointed out in common by Claude Code Security, Copilot cloud agent risks and mitigations, and Codex approvals; demonstrated attacks via issue/PR comments have been reported)
- Verify that new dependencies exist and are not typosquatted: added to AGENTS.md
- Prevent committing secret files: added `.env` patterns to .gitignore; `git add .env` now asks via hook
- Direct execution of downloaded scripts (`curl | sh`): now asks via hook (matching Claude Code's design of not auto-approving curl/wget, as a guard that also works in other modes)
- Prevent the agent from removing its own guardrails: new protect-config.sh (changes to `.claude/settings.json`, hooks, workflows, and dependabot.yml now ask), modeled on Codex's reviewer policy checking for "persistent security weakening"
- Protect credential directories: added `~/.ssh` and `~/.aws` to permissions.deny

Already covered in the initial version: merge flow with mandatory human review, no direct pushes to main, no hardcoded secrets, Dependabot cooldown, confirmation of destructive operations, verification of generated code (verification commands + CI).

### Added documents

- `references.md` / `_en.md`: list of official documents consulted (with reference date)
- `agent-notes.md` / `_en.md`: operation notes for Claude Code (hook snapshot behavior, permission modes, no gh in web sessions, etc.), Copilot (nearest AGENTS.md wins, coding agent safety devices, re-review method, etc.), and Codex (no hook mechanism, sandbox defaults, untrusted projects, etc.)
- `vibe-coding.md` / `_en.md`: vibe coding switch guide (what to loosen / what not to loosen / what to add, with a replacement snippet for AGENTS.md)

### Verification

The new and changed hook guards were tested with 17 payload patterns, all passing. Incidentally, the hooks committed in the previous round became active during this very session and denied a command containing test payloads — an unplanned live confirmation that the guard actually works.

## 2026-07-05: Conciseness refactoring of the instructions

### Request

Based on Anthropic's guidance (concise instructions get better compliance), review all configuration, remove redundancy, duplication, and contradictions, and rewrite into the optimal form as of July 2026 while keeping the requirements.

### Problems found and fixes

- ADR rules stated three times (the same procedure duplicated in AGENTS.md, docs/adr/README.md, and the adr skill) plus a circular reference (docs/adr/README.md pointed to "details in AGENTS.md" while AGENTS.md pointed to the README): made `docs/adr/README.md` the single canonical rulebook (complete, including snippets); AGENTS.md now has one line plus a pointer, and the skill shrank to trigger + quick reference.
- Duplicated consistency checklists (nearly identical items in /commit, /ship, and /consistency-check): `/consistency-check` is now canonical; /ship references it, and /commit keeps only a 3-item quick check.
- Repeated commit-convention descriptions (format explained again in AGENTS.md, /commit, /babysit-pr, and personal): AGENTS.md is canonical; commands now say "per AGENTS.md" plus the minimum essentials.
- Verbose prose: compressed each section of AGENTS.md and personal/global-instructions.md without dropping requirements (operations needing confirmation, language rules, prohibitions, security items).
- Added the design principle "keep instructions concise (one rule, one home)" to template-docs/README.

### What was deliberately kept

The verification-command table, language-rule table, every security item, the PR/review/merge prohibitions, and the babysit-pr operational knowledge (gh 2.88.0 requirement, etc.) were all kept, since each stems from a real past incident or an official recommendation.

## 2026-07-05: Removal of account information and addition of the maintenance guide

### Requests

1. Stating that the template is based on past experience is fine, but individual account information (user names, repository names) must not remain in the template or its documentation.
2. Add principles for operating and improving the template itself going forward — in template-docs, not in the template.

### Actions

- Replaced the user-name URL and individual past-repository names with generic wording in 14 places across the documentation (personal, references, history, README, setup-guide). Recorded "no individual repository names or account information" as an ongoing policy in maintenance.md.
- Added `maintenance.md` / `_en.md`: principles (follow the AGENTS.md flow, one rule one home, promote only generic content, mandatory ja/en sync and history entries), recommended procedures per change type (feeding back knowledge from real projects, hook changes, command/skill changes, periodic tracking of official specs), release operation, and a pre-PR checklist.
- Bundled the hook test harness as `tests/hook-tests.sh` in the repository (previously a session-local throwaway script). All 38 cases pass. Hook changes now must add matching test cases in the same change.

## 2026-07-05: Root-cause analysis of the line-ending problem, and a no-workaround rule

### Background

Investigated after the report "there was a CRLF file even though .gitattributes specifies LF for md, which was confusing".

- Cause: the initial commit's README.md was stored as a blob with CRLF, in a commit made before `.gitattributes` was added. Git attributes only act at commit/checkout time, so CRLF in already-stored blobs persists even after the attributes are added. This is what caused the "README.md shown as modified though untouched" symptom.
- Current state: verified that every blob and the whole working tree are LF (the offending blob was resolved when the template's first commit rewrote it). With the attributes now in effect, even writing CRLF gets normalized to LF at commit time, so a CRLF md can no longer enter the repository.
- Lesson: the anomaly (phantom modified) was observed at the start of the session, yet it was passed over via a rewrite without identifying the cause — exactly a "workaround with the cause unknown", which motivated the rule below.

### Actions

- Added to AGENTS.md "How to work": identify the root cause of unexpected behavior before acting; never route around it with a workaround while the cause is unknown (a breeding ground for vulnerabilities and wrong code/architecture); when unavoidable, record the background and report to the user. The same rule was added to personal/global-instructions.md.
- New `check-line-endings.sh`: a PostToolUse hook that warns when CRLF is written into a file whose policy is LF (files with a CRLF policy such as `*.ps1` are exempt). Added 3 test cases; all 41 cases pass.
- setup-guide: added `git add --renormalize .` for retrofitting the template onto existing repositories (prevents the same class of incident as this one).

## 2026-07-05: Withdrawal of the check-line-endings hook, and a rule against bold as headings

### Withdrawal of the check-line-endings hook

The `check-line-endings.sh` added in the previous entry was withdrawn by the user's decision, as it was an excessive response to the actual cause (an existing blob stored before the attributes were added). Line endings should be handled on the configuration side — editor, gitattributes, renormalize — and do not need per-write monitoring by a hook. Removed from settings.json, the test harness, and the hooks table in the README (the `git add --renormalize .` note in the setup guide remains, as the configuration-side measure).

### Rule against bold as headings

Giving bold the meaning of a heading or label, as in `- bold label: description`, is a mistake of expressing structural meaning through formatting, and is now forbidden (same spirit as the emoji restriction).

- Added to the AGENTS.md language rules: do not use bold as a substitute for headings or labels; write labeled list items as "Title: description" (the colon separator was adopted as the common convention in English technical writing).
- Fixed the existing documents in one pass: all bold labels and bold emphasis in the 10 files under template-docs were converted to plain text.
- Lesson from the fix: the bulk replacement also stripped the `**` from `feature/**` (a glob pattern inside a code span), which had to be restored. When bulk-replacing formatting characters, watch out for the same characters inside code spans and code blocks.

## 2026-07-05: Environment adaptation of babysit-pr (starting the review loop with one command)

Made the review-handling loop (fix, reply to threads, resolve, request re-review, until No New Comment) invocable with a single `/babysit-pr <PR number>` regardless of environment.

- Added an "Environment adaptation" section to `/babysit-pr`: locally (with gh) it runs as written; in claude.ai/code (web sessions, no gh) it runs the same loop via the GitHub MCP tools plus PR event subscription (`subscribe_pr_activity`), unsubscribing on merge/close or when the user says to stop.
- Updated the "babysit-pr is for local use" statement in agent-notes to match reality.
