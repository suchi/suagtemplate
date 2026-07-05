# ADR (Architecture Decision Records)

Records of technology choices and design decisions. One decision per file, named `NNNN-title.md` (4-digit zero-padded sequential number; title in English kebab-case). The body is written in Japanese.

- Template: [0000-template.md](0000-template.md)
- Detailed rules: the "ADR" section of `AGENTS.md` at the repository root

## Rules (summary)

- Whenever a technology choice or design decision is made, record an ADR.
- Never overwrite or edit an existing ADR. When a decision changes:
  1. Change the old ADR's status from 採用 (accepted) to 非推奨 (deprecated), and add a link to the new ADR with the reason at the top
  2. Create a new ADR with the next number, referencing the old ADR it replaces
  3. Update the list in this README, marking the deprecation
- When keeping the status quo despite review findings, add a `Why:` comment in the code and record it in an ADR as well.

## Index

| Number | Title | Status | Date |
| --- | --- | --- | --- |
| [0000](0000-template.md) | Template | - | - |
