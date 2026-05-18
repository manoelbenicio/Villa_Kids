<#
  @file hostgator-backup.ps1
  @description Creates and rotates HostGator webroot backups before deploy.
  @author CODEX-OPS
  @phase 7
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
#>

$ErrorActionPreference = 'Stop'

function Fail {
  param([string]$Message)
  Write-Error "[FAIL] $Message"
  exit 1
}

function Require-Command {
  param([string]$Name)
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    Fail "Required command not found in PATH: $Name"
  }
}

function Load-DeployEnv {
  param([string]$EnvPath)

  if (-not (Test-Path -LiteralPath $EnvPath)) {
    Fail ".env.deploy.local not found at $EnvPath."
  }

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
      Fail ".env.deploy.local is missing required variable $required."
    }
  }

  if ($values['DEPLOY_PORT'] -notmatch '^\d+$') {
    Fail "DEPLOY_PORT must be numeric."
  }

  return $values
}

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteRoot = Resolve-Path (Join-Path $ScriptRoot '..')
Require-Command 'ssh'
$Deploy = Load-DeployEnv -EnvPath (Join-Path $SiteRoot '.env.deploy.local')

$timestamp = Get-Date -AsUTC -Format 'yyyyMMdd_HHmmss'
$backupFile = "backup_$timestamp.tar.gz"
$remote = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port = $Deploy['DEPLOY_PORT']
$path = $Deploy['DEPLOY_PATH'].TrimEnd('/')

Write-Host "== HostGator backup =="
Write-Host "Creating $backupFile from $path"

$remoteCommand = "cd '$path' && tar --exclude='backup_*.tar.gz' -czf '$backupFile' . && ls -la '$backupFile' && ls -1t backup_*.tar.gz 2>/dev/null | tail -n +4 | xargs -r rm -f"
& ssh -p $port -o BatchMode=yes -o ConnectTimeout=20 $remote $remoteCommand
if ($LASTEXITCODE -ne 0) {
  Fail "Remote backup failed."
}

Write-Host "[OK] Backup created and rotation policy applied: keep last 3"
exit 0
