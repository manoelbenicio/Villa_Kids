<#
  @file hostgator-rollback-fast.ps1
  @description Fast rollback via mv reversal (<2s). Uses latest *_OLD_* version.
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:16:32Z
  @modified 2026-05-18T00:16:32Z
#>

[CmdletBinding()]
param(
    [string]$Version
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

$remote     = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port       = $Deploy['DEPLOY_PORT']
$deployPath = $Deploy['DEPLOY_PATH'].TrimEnd('/')
$parentPath = Split-Path $deployPath -Parent
$baseName   = Split-Path $deployPath -Leaf

Write-Host "== Rollback Fast =="
$rollbackStart = Get-Date

# Build remote command: find latest OLD version, swap back
$versionFilter = if ($Version) { "${baseName}_OLD_${Version}" } else { '' }

$remoteCmd = @"
set -e
cd "$parentPath"

# Find the OLD version to restore
if [ -n "$versionFilter" ]; then
    OLD_DIR="$versionFilter"
else
    OLD_DIR=`$(ls -1dt ${baseName}_OLD_* 2>/dev/null | head -1)
fi

if [ -z "`$OLD_DIR" ]; then
    echo "FAIL: No OLD version found for rollback"
    exit 1
fi

echo "Restoring: `$OLD_DIR"

# Move current (failed) to FAILED marker
TIMESTAMP=`$(date +%s)
mv "$deployPath" "${deployPath}_FAILED_`${TIMESTAMP}"

# Restore OLD version as live
mv "$parentPath/`$OLD_DIR" "$deployPath"

# Verify
test -f "${deployPath}/index.html" || { echo "FAIL: rollback verification failed"; exit 1; }

echo "ROLLBACK_OK"
echo "RESTORED=`$OLD_DIR"
"@

$output = & ssh -p $port -o BatchMode=yes -o ConnectTimeout=10 $remote $remoteCmd 2>&1
if ($LASTEXITCODE -ne 0) { Write-Fail "Rollback failed: $output" }

$outputStr = $output -join "`n"
if ($outputStr -notmatch 'ROLLBACK_OK') { Write-Fail "Rollback not confirmed — ROLLBACK_OK not in output" }

$rollbackTime = (New-TimeSpan -Start $rollbackStart -End (Get-Date)).TotalSeconds
Write-Ok ("Rollback completed in {0:n2}s (target <2s)" -f $rollbackTime)
$output | ForEach-Object { Write-Host "  $_" }

exit 0
