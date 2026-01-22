Write-Host "Updating .env file with current ngrok URL..." -ForegroundColor Green
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -Method Get
    $tunnel = $response.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1
    
    if ($tunnel) {
        $url = $tunnel.public_url
        $hostName = $url.Replace("https://", "").Replace("http://", "")
        $content = "WEBHOOK_URL=$url`nN8N_HOST=$hostName`nN8N_PROTOCOL=https"
        $content | Out-File -FilePath ".env" -Encoding utf8 -NoNewline
        
        Write-Host ".env file updated!" -ForegroundColor Green
        Write-Host "WEBHOOK_URL: $url" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Please restart n8n to apply changes:" -ForegroundColor Yellow
        Write-Host "1. Stop n8n (stop.bat)" -ForegroundColor Yellow
        Write-Host "2. Start n8n (start.bat)" -ForegroundColor Yellow
    } else {
        Write-Host "ERROR: Could not get ngrok URL" -ForegroundColor Red
        Write-Host "Make sure ngrok is running: .\start-ngrok.bat" -ForegroundColor Yellow
    }
} catch {
    Write-Host "ERROR: Could not get ngrok URL" -ForegroundColor Red
    Write-Host "Make sure ngrok is running on port 4040" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
}
