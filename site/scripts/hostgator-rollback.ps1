<#
  @file hostgator-rollback.ps1
  @description Restores the latest or selected HostGator webroot backup.
  @author CODEX-OPS
  @phase 7
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
#>

param(
  [string]$BackupFile
)

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
Require-Command 'curl.exe'
$Deploy = Load-DeployEnv -EnvPath (Join-Path $SiteRoot '.env.deploy.local')

$remote = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port = $Deploy['DEPLOY_PORT']
$path = $Deploy['DEPLOY_PATH'].TrimEnd('/')
$siteUrl = 'https://www.colegiovillaprime.com.br'

Write-Host "== HostGator rollback =="
Write-Host "Available backups:"
& ssh -p $port -o BatchMode=yes -o ConnectTimeout=20 $remote "cd '$path' && ls -1t backup_*.tar.gz 2>/dev/null || true"
if ($LASTEXITCODE -ne 0) {
  Fail "Could not list remote backups."
}

if ([string]::IsNullOrWhiteSpace($BackupFile)) {
  $BackupFile = (& ssh -p $port -o BatchMode=yes -o ConnectTimeout=20 $remote "cd '$path' && ls -1t backup_*.tar.gz 2>/dev/null | head -n 1").Trim()
  if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($BackupFile)) {
    Fail "No backup file found on remote server."
  }
}

if ($BackupFile -notmatch '^backup_[0-9]{8}_[0-9]{6}\.tar\.gz$') {
  Fail "Invalid backup filename: $BackupFile"
}

Write-Host "Restoring $BackupFile"
$remoteCommand = "cd '$path' && test -f '$BackupFile' && find . -mindepth 1 ! -name 'backup_*.tar.gz' -exec rm -rf {} + && tar -xzf '$BackupFile'"
& ssh -p $port -o BatchMode=yes -o ConnectTimeout=20 $remote $remoteCommand
if ($LASTEXITCODE -ne 0) {
  Fail "Rollback extraction failed."
}

$status = (& curl.exe -s -o NUL -w "%{http_code}" $siteUrl).Trim()
if ($LASTEXITCODE -ne 0 -or $status -ne '200') {
  Fail "Rollback restored files, but health check failed for $siteUrl with HTTP $status."
}

Write-Host "[OK] Rollback completed and health check returned HTTP 200"
exit 0
