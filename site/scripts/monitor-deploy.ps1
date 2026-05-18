<#
.SYNOPSIS
  Monitors colegiovillaprime.com.br until it's live, then sends email notification.
.DESCRIPTION
  Checks every 5 minutes. Sends email to specified addresses when site responds with correct content.
#>

$domain = "colegiovillaprime.com.br"
$checkUrl = "http://$domain/"
$emails = @("manoel.benicio@icloud.com", "dataops.cloud.mbf@gmail.com")
$interval = 300  # 5 minutes in seconds
$maxAttempts = 48  # 4 hours max

Write-Host "=== Monitor Deploy - Colegio Villa Prime ===" -ForegroundColor Cyan
Write-Host "Verificando $checkUrl a cada 5 minutos..."
Write-Host "Emails de notificacao: $($emails -join ', ')"
Write-Host ""

$attempt = 0
$siteUp = $false

while (-not $siteUp -and $attempt -lt $maxAttempts) {
    $attempt++
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    try {
        $response = Invoke-WebRequest -Uri $checkUrl -TimeoutSec 15 -UseBasicParsing -ErrorAction Stop
        $statusCode = $response.StatusCode
        $hasVillaPrime = $response.Content -match "Villa Prime"
        
        if ($statusCode -eq 200 -and $hasVillaPrime) {
            $siteUp = $true
            Write-Host "[$timestamp] SITE NO AR! HTTP $statusCode - Conteudo correto detectado" -ForegroundColor Green
        } else {
            Write-Host "[$timestamp] Tentativa $attempt - HTTP $statusCode - Conteudo Villa Prime: $hasVillaPrime" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "[$timestamp] Tentativa $attempt - Erro: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    if (-not $siteUp) {
        Write-Host "  Proxima verificacao em 5 minutos..." -ForegroundColor Gray
        Start-Sleep -Seconds $interval
    }
}

if ($siteUp) {
    $subject = "SITE NO AR - colegiovillaprime.com.br"
    $body = @"
O site do Colegio Villa Prime esta no ar!

URL: https://www.colegiovillaprime.com.br
Status: HTTP 200 - Conteudo correto
Horario: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")
Tentativas: $attempt

Proximos passos:
- Verificar HTTPS (certificado SSL)
- Testar navegacao completa
- Confirmar formularios e WhatsApp
"@

    foreach ($email in $emails) {
        try {
            Send-MailMessage -From "deploy@colegiovillaprime.com.br" `
                -To $email `
                -Subject $subject `
                -Body $body `
                -SmtpServer "smtp.gmail.com" `
                -Port 587 `
                -UseSsl `
                -Credential (Get-Credential -Message "Gmail credentials para envio de notificacao") `
                -ErrorAction Stop
            Write-Host "Email enviado para $email" -ForegroundColor Green
        } catch {
            Write-Host "Falha ao enviar email para $email : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Fallback: notification via Windows toast
    try {
        [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
        [System.Windows.Forms.MessageBox]::Show(
            "O site colegiovillaprime.com.br esta no ar!`n`nAcesse: http://colegiovillaprime.com.br",
            "Deploy Concluido!",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    } catch {}
    
    Write-Host ""
    Write-Host "=== DEPLOY CONFIRMADO ===" -ForegroundColor Green
    Write-Host "Acesse: http://colegiovillaprime.com.br" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "=== TIMEOUT: Site nao respondeu apos $maxAttempts tentativas ===" -ForegroundColor Red
    Write-Host "Verifique os nameservers do dominio no painel HostGator." -ForegroundColor Yellow
}
