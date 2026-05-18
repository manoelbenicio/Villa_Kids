<#
  @file hostgator-preflight.ps1
  @description Validates SSH connectivity, env config, disk space, and dist/ readiness.
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
    if (-not (Test-Path -LiteralPath $EnvPath)) {
        Write-Fail ".env.deploy.local not found at $EnvPath. Copy .env.deploy.example and fill values."
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
            Write-Fail ".env.deploy.local missing required variable: $required"
        }
    }
    if ($values['DEPLOY_PORT'] -notmatch '^\d+$') { Write-Fail "DEPLOY_PORT must be numeric." }
    return $values
}

# --- Resolve paths ---
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteRoot   = Resolve-Path (Join-Path $ScriptRoot '..')
$EnvPath    = Join-Path $SiteRoot '.env.deploy.local'
$DistPath   = Join-Path $SiteRoot 'dist'

Write-Host "== Preflight v2 =="

# Check required commands
foreach ($cmd in @('ssh', 'rsync', 'npm')) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Fail "Required command not found: $cmd"
    }
}
Write-Ok "Required commands available (ssh, rsync, npm)"

# Load and validate .env.deploy.local
$Deploy = Load-DeployEnv -EnvPath $EnvPath
Write-Ok "Loaded .env.deploy.local (4 vars validated)"

$remote = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port   = $Deploy['DEPLOY_PORT']
$path   = $Deploy['DEPLOY_PATH']

# SSH connectivity test
$sshOut = & ssh -p $port -o BatchMode=yes -o ConnectTimeout=5 $remote "echo OK" 2>&1
if ($LASTEXITCODE -ne 0 -or "$sshOut" -notmatch 'OK') {
    Write-Fail "SSH connectivity failed for $remote`:$port"
}
Write-Ok "SSH connectivity to $remote`:$port"

# Remote disk space check (need >= 500MB free)
$dfOut = & ssh -p $port -o BatchMode=yes -o ConnectTimeout=5 $remote "df -BM '$path' | tail -1 | awk '{print `$4}'" 2>&1
if ($LASTEXITCODE -eq 0 -and $dfOut -match '(\d+)M') {
    $freeMB = [int]$Matches[1]
    if ($freeMB -lt 500) { Write-Fail "Insufficient disk space: ${freeMB}MB free (need 500MB)" }
    Write-Ok "Remote disk space: ${freeMB}MB free"
} else {
    Write-Host "[WARN] Could not parse disk space, continuing..." -ForegroundColor Yellow
}

# Check dist/ exists with content
if (-not (Test-Path -LiteralPath $DistPath -PathType Container)) {
    Write-Fail "dist/ directory not found at $DistPath. Run 'npm run build' first."
}

# Count index.html files (one per route)
$indexFiles = Get-ChildItem -LiteralPath $DistPath -Recurse -Filter 'index.html'
if ($indexFiles.Count -lt 9) {
    Write-Fail "dist/ has only $($indexFiles.Count) index.html files (expected >= 9 routes)"
}
Write-Ok "dist/ contains $($indexFiles.Count) routes (index.html files)"

# Summary listing
$allFiles  = Get-ChildItem -LiteralPath $DistPath -Recurse -File
$totalSize = ($allFiles | Measure-Object -Property Length -Sum).Sum
$totalMB   = [Math]::Round($totalSize / 1MB, 2)
Write-Ok "dist/ ready: $($allFiles.Count) files, $totalMB MB total"

exit 0
