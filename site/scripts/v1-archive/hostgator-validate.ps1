<#
  @file hostgator-validate.ps1
  @description Validates deployed HostGator site health, robots, sitemap, and OG metadata.
  @author CODEX-OPS
  @phase 7
  @created 2026-05-18T00:26:30Z
  @modified 2026-05-18T00:26:30Z
#>

$ErrorActionPreference = 'Stop'
$SiteUrl = 'https://www.colegiovillaprime.com.br'
$Curl = Get-Command curl.exe -ErrorAction SilentlyContinue

if (-not $Curl) {
  Write-Error '[FAIL] curl.exe is required for validation.'
  exit 1
}

function Test-Status {
  param(
    [string]$Name,
    [string]$Url,
    [string]$Expected = '200'
  )

  $status = (& $Curl.Source -s -o NUL -w "%{http_code}" $Url).Trim()
  if ($LASTEXITCODE -eq 0 -and $status -eq $Expected) {
    Write-Host "[OK] $Name returned HTTP $status"
    return $true
  }

  Write-Host "[FAIL] $Name returned HTTP $status; expected $Expected"
  return $false
}

function Test-HomeOgTitle {
  $html = & $Curl.Source -fsSL $SiteUrl
  if ($LASTEXITCODE -ne 0) {
    Write-Host '[FAIL] Could not fetch home page HTML'
    return $false
  }

  if ($html -match 'og:title') {
    Write-Host '[OK] Home page contains og:title'
    return $true
  }

  Write-Host '[FAIL] Home page does not contain og:title'
  return $false
}

Write-Host "== HostGator validation =="
$checks = @(
  (Test-Status -Name 'Home page' -Url $SiteUrl),
  (Test-HomeOgTitle),
  (Test-Status -Name 'robots.txt' -Url "$SiteUrl/robots.txt"),
  (Test-Status -Name 'sitemap-index.xml' -Url "$SiteUrl/sitemap-index.xml")
)

if ($checks -contains $false) {
  exit 1
}

Write-Host '[OK] All validation checks passed'
exit 0
