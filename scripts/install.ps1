param(
    [string]$MarketplaceName = "qdd-codex-local"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

Push-Location $RepoRoot
try {
    codex plugin marketplace add .
    codex plugin add "qdd-codex@$MarketplaceName"
}
finally {
    Pop-Location
}
