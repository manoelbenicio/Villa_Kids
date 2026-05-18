<#
  @file hostgator-deploy.ps1
  @description Runs preflight, backup, rsync deploy, and post-deploy validation.
  @author CODEX-OPS
  @phase 7
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
#>

$ErrorActionPreference = 'Stop'
$startedAt = Get-Date

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
$EnvPath = Join-Path $SiteRoot '.env.deploy.local'
$DistPath = Join-Path $SiteRoot 'dist'
$PreflightScript = Join-Path $ScriptRoot 'hostgator-preflight.ps1'
$BackupScript = Join-Path $ScriptRoot 'hostgator-backup.ps1'
$ValidateScript = Join-Path $ScriptRoot 'hostgator-validate.ps1'

Write-Host "== HostGator deploy =="
Require-Command 'rsync'

& $PreflightScript
if ($LASTEXITCODE -ne 0) {
  Fail "Preflight failed. Deploy aborted."
}

& $BackupScript
if ($LASTEXITCODE -ne 0) {
  Fail "Backup failed. Deploy aborted."
}

$Deploy = Load-DeployEnv -EnvPath $EnvPath
$remoteTarget = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST']):$($Deploy['DEPLOY_PATH'].TrimEnd('/'))/"
$sshTransport = "ssh -p $($Deploy['DEPLOY_PORT'])"

Write-Host "Uploading dist/ to $remoteTarget"
& rsync -avz --delete -e $sshTransport --exclude='.env*' --exclude='backup_*' "$DistPath/" $remoteTarget
if ($LASTEXITCODE -ne 0) {
  Fail "rsync failed with exit code $LASTEXITCODE."
}

& $ValidateScript
if ($LASTEXITCODE -ne 0) {
  Write-Warning 'Post-deploy validation failed. Review the site and run hostgator-rollback.ps1 manually if needed.'
}
else {
  Write-Host '[OK] Post-deploy validation passed'
}

$duration = New-TimeSpan -Start $startedAt -End (Get-Date)
Write-Host ("[OK] Deploy finished in {0:n1}s" -f $duration.TotalSeconds)
exit 0
