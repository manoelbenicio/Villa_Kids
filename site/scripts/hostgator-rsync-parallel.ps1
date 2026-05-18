<#
  @file hostgator-rsync-parallel.ps1
  @description Parallel rsync upload to staged directory (4 jobs: _astro, images, HTML root, routes).
  @author CODEX-OPS
  @phase 7-PRE
  @created 2026-05-18T00:16:32Z
  @modified 2026-05-18T00:16:32Z
#>

[CmdletBinding()]
param(
    [string]$StagedDir = 'public_html_new',
    [switch]$DryRun
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
$DistPath   = Join-Path $SiteRoot 'dist'
$Deploy     = Load-DeployEnv -EnvPath (Join-Path $SiteRoot '.env.deploy.local')

$remote     = "$($Deploy['DEPLOY_USER'])@$($Deploy['DEPLOY_HOST'])"
$port       = $Deploy['DEPLOY_PORT']
$parentPath = Split-Path $Deploy['DEPLOY_PATH'].TrimEnd('/') -Parent
$stagedPath = "$parentPath/$StagedDir"
$sshCmd     = "ssh -p $port"

Write-Host "== Rsync Parallel v2 =="
Write-Host "Staged dir: $stagedPath"

# Create staged directory on remote
& ssh -p $port -o BatchMode=yes -o ConnectTimeout=10 $remote "mkdir -p '$stagedPath'" 2>&1
if ($LASTEXITCODE -ne 0) { Write-Fail "Failed to create staged dir: $stagedPath" }
Write-Ok "Staged directory created/verified"

# Common rsync flags
$rsyncBase = @('-avz', '--checksum', '--delete', "--exclude='.env*'", "--exclude='backup_*'")
if ($DryRun) { $rsyncBase += '--dry-run' }

$rsyncStart = Get-Date

# Define 4 parallel rsync jobs
$jobDefs = @(
    @{ Name = 'astro';  Src = "$DistPath/_astro/";  Dst = "${remote}:${stagedPath}/_astro/" }
    @{ Name = 'images'; Src = "$DistPath/images/";  Dst = "${remote}:${stagedPath}/images/" }
    @{ Name = 'root';   Src = "$DistPath/";         Dst = "${remote}:${stagedPath}/";
       Extra = @('--include=*.html', '--include=favicon.*', '--include=og-image.*',
                 '--include=robots.txt', '--include=*.xml', '--include=.htaccess',
                 '--exclude=*/', '--exclude=_astro', '--exclude=images') }
    @{ Name = 'routes'; Src = "$DistPath/";         Dst = "${remote}:${stagedPath}/";
       Extra = @('--include=*/', '--include=*/index.html', '--include=*/**.css',
                 '--include=*/**.js', '--exclude=_astro/**', '--exclude=images/**',
                 '--exclude=*.html', '--exclude=favicon.*', '--exclude=og-image.*',
                 '--exclude=robots.txt', '--exclude=*.xml', '--exclude=.htaccess') }
)

$jobs = @()
foreach ($def in $jobDefs) {
    $src = $def.Src; $dst = $def.Dst; $name = $def.Name
    $flags = $rsyncBase
    if ($def.Extra) { $flags = $rsyncBase + $def.Extra }
    $flagStr = $flags -join ' '

    # For routes and root, use filter approach; for astro/images use direct path
    if ($name -eq 'astro' -or $name -eq 'images') {
        $jobs += Start-Job -Name "rsync-$name" -ScriptBlock {
            param($src, $dst, $sshCmd, $flagStr)
            if (Test-Path $src) {
                $result = & rsync $flagStr.Split(' ') -e $sshCmd $src $dst 2>&1
                if ($LASTEXITCODE -ne 0) { throw "rsync $src failed: $result" }
                return "rsync $src OK"
            } else {
                return "rsync $src SKIPPED (dir not found)"
            }
        } -ArgumentList $src, $dst, $sshCmd, $flagStr
    } else {
        # Root files and routes: rsync from dist/ with filters
        $jobs += Start-Job -Name "rsync-$name" -ScriptBlock {
            param($src, $dst, $sshCmd, $flagStr)
            $result = & rsync $flagStr.Split(' ') -e $sshCmd $src $dst 2>&1
            if ($LASTEXITCODE -ne 0) { throw "rsync failed for ${name}: $result" }
            return "rsync ${name} OK"
        } -ArgumentList $src, $dst, $sshCmd, $flagStr
    }
}

# Wait for all rsync jobs
$jobs | Wait-Job | Out-Null
$failed = $false
foreach ($j in $jobs) {
    $output = Receive-Job $j -ErrorAction SilentlyContinue
    if ($j.State -eq 'Failed') {
        $errMsg = $j.ChildJobs[0].JobStateInfo.Reason.Message
        Write-Host "[FAIL] $($j.Name): $errMsg" -ForegroundColor Red
        $failed = $true
    } else {
        Write-Ok "$($j.Name) completed"
    }
    Remove-Job $j
}

if ($failed) { Write-Fail "One or more rsync jobs failed. Aborting." }

$rsyncTime = (New-TimeSpan -Start $rsyncStart -End (Get-Date)).TotalSeconds
Write-Ok ("All 4 rsync jobs completed in {0:n1}s" -f $rsyncTime)

# Verify staged dir has content
$verifyOut = & ssh -p $port -o BatchMode=yes $remote "ls '$stagedPath/index.html' 2>/dev/null && echo STAGED_OK" 2>&1
if ("$verifyOut" -notmatch 'STAGED_OK') {
    Write-Fail "Staged dir verification failed — index.html not found in $stagedPath"
}
Write-Ok "Staged dir verified: index.html present"

exit 0
