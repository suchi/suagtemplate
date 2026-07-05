---
description: Check consistency across docs, code, and ja/en pairs; report only
---

Check the consistency of this repository's documentation. Report only; do not change files.

1. README / AGENTS.md vs reality: documented commands exist and work, directory structure matches the tree, dependency names/versions match the manifests.
2. Japanese/English pairs: for every `<name>.md` with a `<name>_en.md`, headings match and the English content is not stale.
3. ADR (when `docs/adr/` exists): the index in `docs/adr/README.md` matches the files, numbering is sequential (report gaps), deprecated ADRs are marked.
4. Cross-references: links between documents resolve; no references to deleted or renamed files remain.

Report findings as a bullet list grouped by severity, in Japanese. If everything is consistent, report "整合性チェック OK".
