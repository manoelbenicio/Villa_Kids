<#
  @file hostgator-backup.ps1
  @description Creates remote tar.gz backup of webroot with rotation (keep last 5).
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:16:32Z
  @modified 2026-05-18T00:16:32Z
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

function Write-Ok   { param([string]$Msg) Write-Host "[OK] $Msg" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Error "[FAIL] $Msg"; exit 1 }

function Load-DeployEnv {
    param([string]$EnvPath)
    if (-not (Test-Path -LiteralPath $EnvPath)) { Write-Fail ".env.deploy.local not found at $EnvPath." }
    $values = @{}
    Get-Content -LiteralPath $EnvPath | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq '' -or $line.StartsWith('#')) { return }
        $parts = $line -split '=', 2
        if ($parts.Count -ne 2) { return }
        $values[$parts[0].Trim()] = $parts[1].Trim().Trim('"').Trim("'")
    }
    foreach ($required in @('DEPLOY_HOST', 'DEPLOY_USER', 'DEPLOY_PATH', 'DEPLOY_PORT')) {
        if (-not $values.ContainsKey($required) -or [string]::IsNullOrWhiteSpace($values[$required])) {
            Write-Fail ".env.deploy.local missing: $required"
        }
    }
    return $values
}

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteRoot   = Resolve-Path (Join-Path $ScriptRoot '..')
$Deploy     = Load-DeployEnv -EnvPath (Join-Path $SiteRoot '.env.deploy.local')

$remote = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port   = $Deploy['DEPLOY_PORT']
$path   = $Deploy['DEPLOY_PATH'].TrimEnd('/')
$parentDir = Split-Path $path -Parent
$baseName  = Split-Path $path -Leaf

Write-Host "== Backup v2 =="

# Create ~/backups dir if needed, tar.gz the webroot, rotate keeping last 5
$remoteCmd = @"
set -e
mkdir -p ~/backups
TIMESTAMP=`$(date +%Y%m%d_%H%M%S)
BACKUP_FILE=~/backups/backup_`${TIMESTAMP}.tar.gz
tar -czf "`$BACKUP_FILE" -C "$parentDir" "$baseName"
ls -lh "`$BACKUP_FILE"
echo "BACKUP_CREATED=`$BACKUP_FILE"
cd ~/backups && ls -1t backup_*.tar.gz | tail -n +6 | xargs -r rm -f
echo "ROTATION_DONE"
"@

$output = & ssh -p $port -o BatchMode=yes -o ConnectTimeout=30 $remote $remoteCmd 2>&1
if ($LASTEXITCODE -ne 0) { Write-Fail "Remote backup failed: $output" }

# Verify output contains success markers
$outputStr = $output -join "`n"
if ($outputStr -notmatch 'BACKUP_CREATED') { Write-Fail "Backup creation not confirmed in output" }
if ($outputStr -notmatch 'ROTATION_DONE')  { Write-Fail "Rotation not confirmed in output" }

Write-Ok "Backup created in ~/backups/ (rotation: keep last 5)"
$output | ForEach-Object { Write-Host "  $_" }

exit 0
