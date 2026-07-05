---
name: adr
description: Create or supersede an Architecture Decision Record (ADR) in docs/adr/. Use when making a technology choice or design decision, when deliberately not adopting a reviewer suggestion, or when changing a past decision.
---

# ADR management

ADRs live in `docs/adr/` as `NNNN-title.md` (4-digit, zero-padded, sequential numbers; title in English kebab-case). The body is written in Japanese. `docs/adr/0000-template.md` is the template and `docs/adr/README.md` is the index.

## Creating a new ADR

1. Determine the next number: list `docs/adr/` and take the maximum + 1.
2. Copy `0000-template.md` to `NNNN-title.md` and fill in 背景 (context), 決定 (decision), and 結果 (consequences).
3. Add the new ADR to the index table in `docs/adr/README.md`.

## Changing a decision (supersede — never edit in place)

Existing ADRs must never be rewritten or overwritten. Instead:

1. Deprecate the old ADR: change its status from 採用 to 非推奨, and add a link to the new ADR with the deprecation reason at the top:

   ```markdown
   - ステータス: ~~採用~~ 非推奨 → [ADR-NNNN: new-title](NNNN-new-title.md) に置き換え

   > 非推奨理由: ...
   ```

2. Create a new ADR with the next number, referencing the ADR it replaces:

   ```markdown
   - 置き換え: [ADR-NNNN: old-title](NNNN-old-title.md) を非推奨とし、本ADRが最新の決定となる
   ```

3. Update the index in `docs/adr/README.md`, marking the old ADR as deprecated.

## Why: comments

When code stays as-is for technical or environmental reasons despite review findings, put a 1-3 line `Why:` comment at the location and reference the ADR:

```ts
// Why: Codespaces extensions inject classes into <body>, so we suppress the
// false-positive hydration warning here. See ADR-0009.
```
