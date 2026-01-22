Write-Host "Getting ngrok public URL..." -ForegroundColor Green
Write-Host ""

try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -Method Get
    $tunnel = $response.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1
    
    if ($tunnel) {
        Write-Host "Public HTTPS URL:" -ForegroundColor Green
        Write-Host $tunnel.public_url -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Copy this URL and use it in Telegram Trigger webhook settings" -ForegroundColor Yellow
        
        # Copy to clipboard
        $tunnel.public_url | Set-Clipboard
        Write-Host "URL copied to clipboard!" -ForegroundColor Green
    } else {
        Write-Host "No HTTPS tunnel found. Make sure ngrok is running." -ForegroundColor Red
    }
} catch {
    Write-Host "Error: Could not get ngrok URL." -ForegroundColor Red
    Write-Host "Make sure ngrok is running on port 4040." -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Red
}
