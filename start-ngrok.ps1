Write-Host "Starting n8n with ngrok tunnel..." -ForegroundColor Green
Write-Host ""

# Check if ngrok is available (local or in PATH)
$ngrokPath = Join-Path $PWD "ngrok.exe"
if (Test-Path $ngrokPath) {
    $ngrokCmd = $ngrokPath
    Write-Host "Using local ngrok.exe" -ForegroundColor Green
} else {
    $ngrokExists = Get-Command ngrok -ErrorAction SilentlyContinue
    if (-not $ngrokExists) {
        Write-Host "ERROR: ngrok is not installed or not in PATH" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please:" -ForegroundColor Yellow
        Write-Host "1. Download ngrok from https://ngrok.com/download" -ForegroundColor Cyan
        Write-Host "2. Add ngrok.exe to PATH or place it in this folder" -ForegroundColor Cyan
        Write-Host "3. Get your authtoken from https://dashboard.ngrok.com/get-started/your-authtoken" -ForegroundColor Cyan
        Write-Host "4. Run: ngrok config add-authtoken YOUR_TOKEN" -ForegroundColor Cyan
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    } else {
        $ngrokCmd = "ngrok"
    }
}

Write-Host "Starting ngrok tunnel..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "& '$ngrokCmd' http 5678" -WindowStyle Normal

Write-Host "Waiting for ngrok to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host "Getting public URL from ngrok..." -ForegroundColor Cyan
try {
    $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -Method Get
    $tunnel = $response.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1
    
    if ($tunnel) {
        $webhookUrl = $tunnel.public_url
        Write-Host "Public URL: $webhookUrl" -ForegroundColor Green
        Write-Host ""
        Write-Host "Starting n8n with webhook URL..." -ForegroundColor Cyan
        
        # Set environment variables
        $env:WEBHOOK_URL = $webhookUrl
        $env:N8N_HOST = $webhookUrl.Replace("https://", "").Replace("http://", "")
        $env:N8N_PROTOCOL = "https"
        
        Write-Host "n8n will use this URL for webhooks automatically" -ForegroundColor Yellow
        Write-Host ""
    } else {
        Write-Host "WARNING: Could not get ngrok URL. Starting n8n anyway..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "WARNING: Could not get ngrok URL. Starting n8n anyway..." -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Gray
}

Write-Host "Starting n8n..." -ForegroundColor Green
Write-Host "n8n will be available at: http://localhost:5678" -ForegroundColor Cyan
Write-Host ""

npm start
