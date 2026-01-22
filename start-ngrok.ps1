Write-Host "Starting n8n with ngrok tunnel..." -ForegroundColor Green
Write-Host ""

# Check if ngrok is available
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
}

Write-Host "Starting n8n in background..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm start" -WindowStyle Minimized

Write-Host "Waiting for n8n to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "Starting ngrok tunnel..." -ForegroundColor Green
Write-Host "Public URL will be shown below:" -ForegroundColor Cyan
Write-Host ""

ngrok http 5678
