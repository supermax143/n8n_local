Write-Host "Starting n8n with tunnel (for webhooks)..." -ForegroundColor Green
Write-Host ""
Write-Host "This will create a public URL for Telegram webhooks" -ForegroundColor Cyan
Write-Host "n8n will be available at: http://localhost:5678" -ForegroundColor Cyan
Write-Host "Public webhook URL will be shown in the console" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop n8n" -ForegroundColor Yellow
Write-Host ""

npm run start:tunnel
