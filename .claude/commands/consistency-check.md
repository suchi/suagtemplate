---
description: Check consistency across docs, code, and ja/en pairs; report only
---

Check the consistency of this repository's documentation and report findings. This command only reports; do not change files.

## Checks

1. README / AGENTS.md vs reality:
   - documented commands and script names exist and work
   - directory structure descriptions match the actual tree
   - dependency names and versions match the manifests
2. Japanese/English pairs:
   - for every `<name>.md` that has a `<name>_en.md`, the heading structure matches and the English content is not stale
3. ADR (when `docs/adr/` exists):
   - the index in `docs/adr/README.md` lists every ADR file, and every listed file exists
   - numbering is sequential; report gaps
   - deprecated ADRs are marked in the index
4. Cross-references:
   - links between documents resolve
   - no references to deleted or renamed files remain

## Output

Report findings as a bullet list grouped by severity, in Japanese. If everything is consistent, report "整合性チェック OK".
