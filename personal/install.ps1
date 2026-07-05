# Install personal global agent instructions:
#   global-instructions.md -> ~\.claude\CLAUDE.md   (Claude Code)
#                          -> ~\.codex\AGENTS.md    (Codex)
# An existing file with different content is backed up with a timestamp
# suffix before being overwritten.
#
# Copilot personal instructions cannot be scripted; see
# copilot-personal-instructions.md for the manual steps.

$ErrorActionPreference = "Stop"

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $here "global-instructions.md"
$ts = Get-Date -Format "yyyyMMddHHmmss"

function Install-One([string]$dest) {
    $dir = Split-Path -Parent $dest
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
    if ((Test-Path $dest) -and ((Get-FileHash $dest).Hash -ne (Get-FileHash $src).Hash)) {
        Copy-Item $dest "$dest.bak.$ts"
        Write-Host "Backed up existing $dest -> $dest.bak.$ts"
    }
    Copy-Item $src $dest -Force
    Write-Host "Installed $dest"
}

Install-One (Join-Path $HOME ".claude\CLAUDE.md")
Install-One (Join-Path $HOME ".codex\AGENTS.md")

Write-Host "Done. Copilot personal instructions must be set manually:"
Write-Host "see $here\copilot-personal-instructions.md"
