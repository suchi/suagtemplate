---
description: Check consistency across docs and code; report only
---

Check the consistency of this repository's documentation. Report only; do not change files.

1. README / AGENTS.md vs reality: documented commands exist and work, directory structure matches the tree, dependency names/versions match the manifests.
2. ADR (when `docs/adr/` exists): the index in `docs/adr/README.md` matches the files, numbering is sequential (report gaps), deprecated ADRs are marked.
3. Cross-references: links between documents resolve; no references to deleted or renamed files remain.

Report findings as a bullet list grouped by severity. If everything is consistent, report "consistency check OK".
