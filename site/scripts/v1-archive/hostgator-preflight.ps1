<#
  @file hostgator-preflight.ps1
  @description Validates local build output and HostGator SSH readiness before deploy.
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

function Pass {
  param([string]$Message)
  Write-Host "[OK] $Message"
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
    Fail ".env.deploy.local not found at $EnvPath. Copy site/scripts/.env.deploy.example to site/.env.deploy.local and fill values."
  }

  $values = @{}
  Get-Content -LiteralPath $EnvPath | ForEach-Object {
    $line = $_.Trim()
    if ($line -eq '' -or $line.StartsWith('#')) { return }
    $parts = $line -split '=', 2
    if ($parts.Count -ne 2) { return }
    $key = $parts[0].Trim()
    $value = $parts[1].Trim().Trim('"').Trim("'")
    $values[$key] = $value
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

Write-Host "== HostGator preflight =="
Require-Command 'ssh'
Require-Command 'npm'

$Deploy = Load-DeployEnv -EnvPath $EnvPath
Pass "Loaded deploy environment from $EnvPath"

$hostName = $Deploy['DEPLOY_HOST']
$port = $Deploy['DEPLOY_PORT']
$user = $Deploy['DEPLOY_USER']
$remotePath = $Deploy['DEPLOY_PATH']
$remote = "$user@$hostName"

if (-not (Test-Connection -ComputerName $hostName -Count 2 -Quiet)) {
  Fail "Host $hostName did not respond to Test-Connection."
}
Pass "Network connectivity to $hostName"

$sshOutput = (& ssh -p $port -o BatchMode=yes -o ConnectTimeout=10 $remote "test -d '$remotePath' && echo OK") -join "`n"
if ($LASTEXITCODE -ne 0 -or $sshOutput -notmatch 'OK') {
  Fail "SSH test failed for $remote on port $port, or remote path does not exist: $remotePath"
}
Pass "SSH connectivity and remote path validated"

Push-Location $SiteRoot
try {
  & npm run build
  if ($LASTEXITCODE -ne 0) {
    Fail "npm run build failed."
  }
}
finally {
  Pop-Location
}
Pass "npm run build completed"

if (-not (Test-Path -LiteralPath $DistPath -PathType Container)) {
  Fail "dist directory was not generated at $DistPath."
}

$files = Get-ChildItem -LiteralPath $DistPath -Recurse -File
if ($files.Count -eq 0) {
  Fail "dist directory is empty."
}

$totalBytes = ($files | Measure-Object -Property Length -Sum).Sum
$totalMb = [Math]::Round(($totalBytes / 1MB), 2)
Pass "dist is ready: $($files.Count) files, $totalBytes bytes ($totalMb MB)"

Write-Host "Files to deploy:"
$files | ForEach-Object {
  $relative = $_.FullName.Substring($DistPath.Length).TrimStart('\', '/')
  Write-Host " - $relative ($($_.Length) bytes)"
}

exit 0
