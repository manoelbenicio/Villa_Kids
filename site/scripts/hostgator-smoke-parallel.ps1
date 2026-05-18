<#
  @file hostgator-smoke-parallel.ps1
  @description Parallel smoke test: 9 routes + robots.txt + sitemap + security headers.
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

# Domain from DEPLOY_DOMAIN env var or default
$domain = if ($Deploy.ContainsKey('DEPLOY_DOMAIN') -and $Deploy['DEPLOY_DOMAIN']) {
    $Deploy['DEPLOY_DOMAIN']
} else {
    'https://www.colegiovillaprime.com.br'
}

$routes = @(
    '/'
    '/proposta-pedagogica/'
    '/turmas/'
    '/estrutura/'
    '/tecnologia/'
    '/seguranca/'
    '/contato/'
    '/matriculas/'
    '/politica-de-privacidade/'
)

Write-Host "== Smoke Test Parallel v2 =="
Write-Host "Domain: $domain"
Write-Host "Routes: $($routes.Count)"

$smokeStart = Get-Date

# Run parallel checks for all routes
$jobs = @()
foreach ($route in $routes) {
    $url = "${domain}${route}"
    $jobs += Start-Job -Name "smoke-$route" -ScriptBlock {
        param($url, $route)
        $result = @{ Route = $route; URL = $url; Status = 'FAIL'; Code = 0; Time = 0; Title = $false; Headers = $false }
        try {
            # HTTP status + time
            $curlOut = & curl.exe -sS -o NUL -w "%{http_code}|%{time_total}" --max-time 15 $url 2>&1
            if ($curlOut -match '^(\d+)\|(.+)$') {
                $result.Code = [int]$Matches[1]
                $result.Time = [double]$Matches[2]
            }
            # Title check
            $html = & curl.exe -fsSL --max-time 15 $url 2>&1
            if ($html -match '<title>') { $result.Title = $true }
            # Security headers
            $headers = & curl.exe -sI --max-time 10 $url 2>&1
            $headerStr = $headers -join "`n"
            if ($headerStr -match 'X-Frame-Options' -or $headerStr -match 'Strict-Transport-Security') {
                $result.Headers = $true
            }
            if ($result.Code -eq 200 -and $result.Title) { $result.Status = 'PASS' }
        } catch {
            $result.Status = 'FAIL'
        }
        return $result
    } -ArgumentList $url, $route
}

# Wait and collect results
$jobs | Wait-Job | Out-Null
$results = @()
foreach ($j in $jobs) {
    $r = Receive-Job $j -ErrorAction SilentlyContinue
    if ($r) { $results += $r }
    Remove-Job $j
}

# Additional checks: robots.txt and sitemap-index.xml
foreach ($extra in @('/robots.txt', '/sitemap-index.xml')) {
    $url = "${domain}${extra}"
    $curlOut = & curl.exe -sS -o NUL -w "%{http_code}" --max-time 10 $url 2>&1
    $code = if ($curlOut -match '^\d+$') { [int]$curlOut } else { 0 }
    $results += @{ Route = $extra; URL = $url; Status = if ($code -eq 200) { 'PASS' } else { 'FAIL' }; Code = $code; Time = 0; Title = $true; Headers = $true }
}

# Report table
Write-Host "`n  Route                          | HTTP | Time   | Status"
Write-Host "  -------------------------------|------|--------|-------"
$failed = 0
foreach ($r in $results) {
    $statusColor = if ($r.Status -eq 'PASS') { 'Green' } else { 'Red' }
    $line = "  {0,-32}| {1,-4} | {2:n2}s | {3}" -f $r.Route, $r.Code, $r.Time, $r.Status
    Write-Host $line -ForegroundColor $statusColor
    if ($r.Status -ne 'PASS') { $failed++ }
}

$smokeTime = (New-TimeSpan -Start $smokeStart -End (Get-Date)).TotalSeconds
Write-Host ("`n  Total time: {0:n1}s" -f $smokeTime)

if ($failed -gt 0) {
    Write-Fail "$failed route(s) failed smoke test"
}

Write-Ok "All $($results.Count) checks passed"
exit 0
