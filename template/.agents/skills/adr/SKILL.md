---
name: adr
description: Create or supersede an Architecture Decision Record (ADR) in docs/adr/. Use when making a technology choice or design decision, when deliberately not adopting a reviewer suggestion, or when changing a past decision.
---

# ADR management

`docs/adr/README.md` is the canonical rulebook (naming, supersede procedure with snippets, `Why:` comments, index). Read it first and follow it.

Quick reference:

1. New ADR: copy `docs/adr/0000-template.md` to `NNNN-title.md` (next number = existing max + 1), fill in Context/Decision/Consequences, add it to the index in `docs/adr/README.md`.
2. Changed decision: never edit an accepted ADR in place — deprecate it and create a new one using the snippets in the rulebook.
3. Keeping code as-is despite a review finding: add a 1-3 line `Why:` comment referencing the ADR.
