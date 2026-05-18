<#
  @file hostgator-deploy-v2.ps1
  @description Orchestrator for atomic staged parallel deploy to HostGator. Zero downtime.
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:16:32Z
  @modified 2026-05-18T00:16:32Z
#>

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$SkipBackup,
    [switch]$SkipPreflight,
    [string]$StagedDir = 'public_html_new'
)

$ErrorActionPreference = 'Stop'
$startedAt = Get-Date

# --- Helpers ---
function Write-Step { param([string]$Msg) Write-Host "`n== $Msg ==" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "[OK] $Msg" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Error "[FAIL] $Msg"; exit 1 }

# --- Resolve paths ---
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteRoot   = Resolve-Path (Join-Path $ScriptRoot '..')

$PreflightScript  = Join-Path $ScriptRoot 'hostgator-preflight.ps1'
$BackupScript     = Join-Path $ScriptRoot 'hostgator-backup.ps1'
$RsyncScript      = Join-Path $ScriptRoot 'hostgator-rsync-parallel.ps1'
$SwitchScript     = Join-Path $ScriptRoot 'hostgator-atomic-switch.ps1'
$SmokeScript      = Join-Path $ScriptRoot 'hostgator-smoke-parallel.ps1'

Write-Step "Deploy v2 — Atomic Staged Parallel"
Write-Host "DryRun=$DryRun | SkipBackup=$SkipBackup | SkipPreflight=$SkipPreflight | StagedDir=$StagedDir"

if ($DryRun) { Write-Host "[DRY-RUN] No remote changes will be made." -ForegroundColor Yellow }

# --- STAGE 1: Parallel preflight + backup + build ---
Write-Step "Stage 1: Parallel preflight + backup + build"

$jobs = @()

if (-not $SkipPreflight) {
    $jobs += Start-Job -Name 'Preflight' -ScriptBlock {
        param($script, $dry)
        & $script
        if ($LASTEXITCODE -ne 0) { throw "Preflight failed" }
    } -ArgumentList $PreflightScript, $DryRun
}

if (-not $SkipBackup -and -not $DryRun) {
    $jobs += Start-Job -Name 'Backup' -ScriptBlock {
        param($script)
        & $script
        if ($LASTEXITCODE -ne 0) { throw "Backup failed" }
    } -ArgumentList $BackupScript
}

# Build always runs (local operation)
$jobs += Start-Job -Name 'Build' -ScriptBlock {
    param($siteRoot)
    Push-Location $siteRoot
    try {
        & npm run build 2>&1
        if ($LASTEXITCODE -ne 0) { throw "npm run build failed" }
    } finally { Pop-Location }
} -ArgumentList $SiteRoot

# Wait for all Stage 1 jobs
if ($jobs.Count -gt 0) {
    $jobs | Wait-Job | Out-Null
    foreach ($j in $jobs) {
        $output = Receive-Job $j -ErrorAction SilentlyContinue
        if ($j.State -eq 'Failed') {
            $errMsg = $j.ChildJobs[0].JobStateInfo.Reason.Message
            Write-Fail "Job '$($j.Name)' failed: $errMsg"
        }
        Write-Ok "Job '$($j.Name)' completed"
        if ($output) { $output | ForEach-Object { Write-Host "  $_" } }
        Remove-Job $j
    }
}

$stage1Time = (New-TimeSpan -Start $startedAt -End (Get-Date)).TotalSeconds
Write-Ok ("Stage 1 completed in {0:n1}s" -f $stage1Time)

# --- STAGE 2: Rsync parallel to staged dir ---
Write-Step "Stage 2: Rsync parallel to staged dir"
$rsyncStart = Get-Date

if ($DryRun) {
    Write-Host "[DRY-RUN] Would run: hostgator-rsync-parallel.ps1 -StagedDir $StagedDir -DryRun"
} else {
    & $RsyncScript -StagedDir $StagedDir
    if ($LASTEXITCODE -ne 0) { Write-Fail "Rsync parallel failed (exit $LASTEXITCODE)" }
}

$stage2Time = (New-TimeSpan -Start $rsyncStart -End (Get-Date)).TotalSeconds
Write-Ok ("Stage 2 completed in {0:n1}s" -f $stage2Time)

# --- STAGE 3: Atomic switch ---
Write-Step "Stage 3: Atomic switch"
$switchStart = Get-Date

if ($DryRun) {
    Write-Host "[DRY-RUN] Would run: hostgator-atomic-switch.ps1 -StagedDir $StagedDir"
} else {
    & $SwitchScript -StagedDir $StagedDir
    if ($LASTEXITCODE -ne 0) { Write-Fail "Atomic switch failed (exit $LASTEXITCODE)" }
}

$stage3Time = (New-TimeSpan -Start $switchStart -End (Get-Date)).TotalSeconds
Write-Ok ("Stage 3 completed in {0:n1}s (target <1s)" -f $stage3Time)

# --- STAGE 4: Smoke test production ---
Write-Step "Stage 4: Smoke test production"
$smokeStart = Get-Date

if ($DryRun) {
    Write-Host "[DRY-RUN] Would run: hostgator-smoke-parallel.ps1"
} else {
    & $SmokeScript
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] Smoke failed — initiating rollback-fast..." -ForegroundColor Red
        $rollbackScript = Join-Path $ScriptRoot 'hostgator-rollback-fast.ps1'
        & $rollbackScript
        Write-Fail "Smoke test failed. Rollback executed. Check logs."
    }
}

$stage4Time = (New-TimeSpan -Start $smokeStart -End (Get-Date)).TotalSeconds
Write-Ok ("Stage 4 completed in {0:n1}s" -f $stage4Time)

# --- Summary ---
$totalTime = (New-TimeSpan -Start $startedAt -End (Get-Date)).TotalSeconds
Write-Step "Deploy v2 Summary"
Write-Host ("  Stage 1 (preflight+backup+build): {0:n1}s" -f $stage1Time)
Write-Host ("  Stage 2 (rsync parallel):         {0:n1}s" -f $stage2Time)
Write-Host ("  Stage 3 (atomic switch):          {0:n1}s" -f $stage3Time)
Write-Host ("  Stage 4 (smoke test):             {0:n1}s" -f $stage4Time)
Write-Host ("  TOTAL:                            {0:n1}s" -f $totalTime) -ForegroundColor Green
Write-Host "`nZero-downtime deploy complete." -ForegroundColor Green

exit 0
