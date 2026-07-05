#!/bin/sh
# Install personal global agent instructions:
#   global-instructions.md -> ~/.claude/CLAUDE.md   (Claude Code)
#                          -> ~/.codex/AGENTS.md    (Codex)
# An existing file with different content is backed up with a timestamp
# suffix before being overwritten.
#
# Copilot personal instructions cannot be scripted; see
# copilot-personal-instructions.md for the manual steps.

set -eu

here=$(cd "$(dirname "$0")" && pwd)
src="$here/global-instructions.md"
ts=$(date +%Y%m%d%H%M%S)

install_one() {
  dest=$1
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ] && ! cmp -s "$src" "$dest"; then
    cp "$dest" "$dest.bak.$ts"
    echo "Backed up existing $dest -> $dest.bak.$ts"
  fi
  cp "$src" "$dest"
  echo "Installed $dest"
}

install_one "$HOME/.claude/CLAUDE.md"
install_one "$HOME/.codex/AGENTS.md"

echo "Done. Copilot personal instructions must be set manually:"
echo "see $here/copilot-personal-instructions.md"
