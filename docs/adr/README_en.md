# ADR (Architecture Decision Records)

Records of technology choices and design decisions. One decision per file, named `NNNN-title.md` (4-digit zero-padded sequential number; English kebab-case title), body in Japanese. Template: [0000-template.md](0000-template.md).

## Rules

- Record an ADR for every technology choice or design decision. The number is the existing maximum + 1. Add it to the index below.
- Never overwrite or edit an existing ADR. When a decision changes:
  1. Change the old ADR's status from 採用 (accepted) to 非推奨 (deprecated) and add at the top:

     ```markdown
     - ステータス: ~~採用~~ 非推奨 → [ADR-NNNN: new-title](NNNN-new-title.md) に置き換え

     > 非推奨理由: ...
     ```

  2. Create a new ADR with the next number, stating the replacement:

     ```markdown
     - 置き換え: [ADR-NNNN: old-title](NNNN-old-title.md) を非推奨とし、本ADRが最新の決定となる
     ```

  3. Update the index below, marking the deprecation.
- When keeping the status quo for technical or environmental reasons despite review findings, add a 1-3 line `Why:` comment (referencing the ADR number) at the code and record it in an ADR as well.

## Index

| Number | Title | Status | Date |
| --- | --- | --- | --- |
| [0000](0000-template.md) | Template | - | - |
