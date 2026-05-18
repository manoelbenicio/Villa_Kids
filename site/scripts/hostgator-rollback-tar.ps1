<#
  @file hostgator-rollback-tar.ps1
  @description EMERGENCY ROLLBACK — Restore from tar.gz backup. Use only if rollback-fast fails.
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:16:32Z
  @modified 2026-05-18T00:16:32Z
#>

[CmdletBinding()]
param(
    [string]$BackupFile
)

$ErrorActionPreference = 'Stop'

function Write-Ok   { param([string]$Msg) Write-Host "[OK] $Msg" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Error "[FAIL] $Msg"; exit 1 }

function Load-DeployEnv {
    param([string]$EnvPath)
    if (-not (Test-Path -LiteralPath $EnvPath)) { Write-Fail ".env.deploy.local not found." }
    $values = @{}
    Get-Content -LiteralPath $EnvPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) { return }
        $parts = $line -split '=', 2
        if ($parts.Count -ne 2) { return }
        $values[$parts[0].Trim()] = $parts[1].Trim().Trim('"').Trim("'")
    }
    return $values
}

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteRoot   = Resolve-Path (Join-Path $ScriptRoot '..')
$Deploy     = Load-DeployEnv -EnvPath (Join-Path $SiteRoot '.env.deploy.local')

$remote = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port   = $Deploy['DEPLOY_PORT']
$path   = $Deploy['DEPLOY_PATH'].TrimEnd('/')

Write-Host "== EMERGENCY Rollback (tar.gz) ==" -ForegroundColor Red
Write-Host "WARNING: This may cause ~30s downtime while extracting backup." -ForegroundColor Yellow

# List available backups
Write-Host "`nAvailable backups:"
& ssh -p $port -o BatchMode=yes -o ConnectTimeout=10 $remote "ls -lht ~/backups/backup_*.tar.gz 2>/dev/null" 2>&1 |
    ForEach-Object { Write-Host "  $_" }

# Select backup file
if ([string]::IsNullOrWhiteSpace($BackupFile)) {
    $BackupFile = (& ssh -p $port -o BatchMode=yes $remote "ls -1t ~/backups/backup_*.tar.gz 2>/dev/null | head -1" 2>&1).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($BackupFile)) {
        Write-Fail "No backup files found in ~/backups/"
    }
} else {
    $BackupFile = "~/backups/$BackupFile"
}

Write-Host "`nRestoring from: $BackupFile"

$remoteCmd = @"
set -e
test -f "$BackupFile" || { echo "FAIL: backup file not found"; exit 1; }

# Clear current webroot (preserve nothing — full restore)
rm -rf "${path:?}"/*
rm -rf "${path:?}"/.[!.]* 2>/dev/null || true

# Extract backup
tar -xzf "$BackupFile" -C "$path"

# Verify
test -f "${path}/index.html" || { echo "FAIL: restore verification failed"; exit 1; }
echo "EMERGENCY_ROLLBACK_OK"
"@

$output = & ssh -p $port -o BatchMode=yes -o ConnectTimeout=60 $remote $remoteCmd 2>&1
if ($LASTEXITCODE -ne 0) { Write-Fail "Emergency rollback failed: $output" }

$outputStr = $output -join "`n"
if ($outputStr -notmatch 'EMERGENCY_ROLLBACK_OK') { Write-Fail "Rollback not confirmed" }

Write-Ok "Emergency rollback completed from tar.gz backup"
Write-Host "Verify site manually: https://www.colegiovillaprime.com.br" -ForegroundColor Yellow

exit 0
