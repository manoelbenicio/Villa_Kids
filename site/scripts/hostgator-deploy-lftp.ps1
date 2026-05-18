<#
  @file hostgator-deploy-lftp.ps1
  @description Automated FTP deployment for HostGator using lftp
  @author CODEX-OPS
#>

[CmdletBinding()]
param(
    [switch]$SkipBuild,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$startedAt = Get-Date

# --- Credentials ---
$FTP_HOST = "69.6.212.125"
$FTP_USER = "manoel_benicio@colegiovillaprime.com.br"
$FTP_PASS = "Nicecti0!@)@&"
$REMOTE_DIR = "public_html"
$LOCAL_DIR = "dist"

$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$SiteRoot   = Resolve-Path (Join-Path $ScriptRoot '..')

function Write-Step { param([string]$Msg) Write-Host "`n== $Msg ==" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "[OK] $Msg" -ForegroundColor Green }
function Write-Fail { param([string]$Msg) Write-Error "[FAIL] $Msg"; exit 1 }

Write-Step "Deploy LFTP - Sync automatizado via FTP"

if (-not $SkipBuild) {
    Write-Step "Building project"
    Push-Location $SiteRoot
    try {
        & npm run build
        if ($LASTEXITCODE -ne 0) { Write-Fail "Build failed" }
    } finally {
        Pop-Location
    }
    Write-Ok "Build complete."
}

Write-Step "Uploading files via lftp"

$FullLocalDir = (Join-Path $SiteRoot $LOCAL_DIR) -replace '\\', '/'
$wslDistPath = (wsl wslpath -u "$FullLocalDir")
if ($null -ne $wslDistPath) { $wslDistPath = $wslDistPath.Trim() }

$tempFile = New-TemporaryFile

$mirrorArgs = "-R -v --parallel=10 --delete --only-newer"
if ($DryRun) {
    $mirrorArgs = "--dry-run " + $mirrorArgs
    Write-Host "`[DRY-RUN`] Will only simulate transfer." -ForegroundColor Yellow
}

$lftpScript = @"
set ssl:verify-certificate no
set ftp:ssl-allow yes
set ftp:ssl-force yes
open $FTP_HOST
user "$FTP_USER" "$FTP_PASS"
mirror $mirrorArgs "$wslDistPath/" "$REMOTE_DIR/"
bye
"@

# Write with Unix line endings
$lftpScript = $lftpScript -replace "`r`n", "`n"
[IO.File]::WriteAllText($tempFile.FullName, $lftpScript)

$tempFilePathFixed = $tempFile.FullName -replace '\\', '/'
$wslTempPath = (wsl wslpath -u "$tempFilePathFixed")
if ($null -ne $wslTempPath) { $wslTempPath = $wslTempPath.Trim() }

Write-Host "Running lftp sync..."
& wsl bash -c "lftp -f '$wslTempPath'"
$lftpExitCode = $LASTEXITCODE

Remove-Item $tempFile.FullName -ErrorAction SilentlyContinue

if ($lftpExitCode -ne 0) {
    Write-Fail "lftp sync failed with exit code $lftpExitCode"
}

$totalTime = (New-TimeSpan -Start $startedAt -End (Get-Date)).TotalSeconds
Write-Ok "Sync completed successfully in $($totalTime)s"
exit 0
