# ADR (Architecture Decision Records)

Records of technology choices and design decisions. One decision per file, named `NNNN-title.md` (4-digit zero-padded sequential number; kebab-case title). Template: [0000-template.md](0000-template.md).

## Rules

- Record an ADR for every technology choice or design decision. The number is the existing maximum + 1. Add it to the index below.
- Never rewrite the decision content of an existing ADR. The only allowed edit is the deprecation procedure below (status change and a note at the top). When a decision changes:
  1. Change the old ADR's status from accepted to deprecated and add at the top:

     ```markdown
     - Status: ~~accepted~~ deprecated → replaced by [ADR-NNNN: new-title](NNNN-new-title.md)

     > Deprecation reason: ...
     ```

  2. Create a new ADR with the next number, stating the replacement:

     ```markdown
     - Replaces: [ADR-NNNN: old-title](NNNN-old-title.md); this ADR is now the current decision
     ```

  3. Update the index below, marking the deprecation.
- When keeping the status quo for technical or environmental reasons despite review findings, add a 1-3 line `Why:` comment (referencing the ADR number) at the code and record it in an ADR as well.

## Index

| Number | Title | Status | Date |
| --- | --- | --- | --- |
| [0000](0000-template.md) | Template | - | - |
