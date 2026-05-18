<#
  @file hostgator-atomic-switch.ps1
  @description Atomic mv switch: public_html → OLD, staged → public_html. Zero downtime (<1s).
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:16:32Z
  @modified 2026-05-18T00:16:32Z
#>

[CmdletBinding()]
param(
    [string]$StagedDir = 'public_html_new'
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
$stagedPath = "$parentPath/$StagedDir"

Write-Host "== Atomic Switch =="
Write-Host "Live:   $deployPath"
Write-Host "Staged: $stagedPath"

$switchStart = Get-Date

# Atomic switch: mv live→OLD, mv staged→live, rotate old versions (keep 3)
$remoteCmd = @"
set -e
TIMESTAMP=`$(date +%s)
OLD_DIR="${deployPath}_OLD_`${TIMESTAMP}"

# Verify staged dir exists and has content
test -f "${stagedPath}/index.html" || { echo "FAIL: staged dir missing index.html"; exit 1; }

# Atomic swap (two mv operations — minimal window)
mv "$deployPath" "`$OLD_DIR"
mv "$stagedPath" "$deployPath"

# Verify switch succeeded
test -f "${deployPath}/index.html" || { echo "FAIL: switch verification failed"; exit 1; }
ls -ld "$deployPath"

# Rotate: keep only last 3 OLD versions
cd "$parentPath"
ls -1dt ${baseName}_OLD_* 2>/dev/null | tail -n +4 | xargs -r rm -rf

echo "SWITCH_OK"
echo "OLD_VERSION=`$OLD_DIR"
"@

$output = & ssh -p $port -o BatchMode=yes -o ConnectTimeout=10 $remote $remoteCmd 2>&1
if ($LASTEXITCODE -ne 0) { Write-Fail "Atomic switch failed: $output" }

$outputStr = $output -join "`n"
if ($outputStr -notmatch 'SWITCH_OK') { Write-Fail "Switch not confirmed — SWITCH_OK not found in output" }

$switchTime = (New-TimeSpan -Start $switchStart -End (Get-Date)).TotalSeconds
Write-Ok ("Atomic switch completed in {0:n2}s" -f $switchTime)
$output | ForEach-Object { Write-Host "  $_" }

exit 0
