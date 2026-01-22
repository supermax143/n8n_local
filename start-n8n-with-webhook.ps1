Write-Host "Getting ngrok public URL..." -ForegroundColor Green

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -Method Get
    $tunnel = $response.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1
    
    if (-not $tunnel) {
        Write-Host "ERROR: ngrok is not running or no HTTPS tunnel found" -ForegroundColor Red
        Write-Host "Please start ngrok first: .\start-ngrok.bat" -ForegroundColor Yellow
        exit 1
    }
    
    $webhookUrl = $tunnel.public_url
    Write-Host "Found ngrok URL: $webhookUrl" -ForegroundColor Green
    Write-Host ""
    Write-Host "Starting n8n with WEBHOOK_URL=$webhookUrl" -ForegroundColor Cyan
    Write-Host ""
    
    # Set environment variable and start n8n
    $env:WEBHOOK_URL = $webhookUrl
    $env:N8N_HOST = $webhookUrl.Replace("https://", "").Replace("http://", "")
    $env:N8N_PROTOCOL = "https"
    
    npm start
} catch {
    Write-Host "ERROR: Could not get ngrok URL" -ForegroundColor Red
    Write-Host "Make sure ngrok is running: .\start-ngrok.bat" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
