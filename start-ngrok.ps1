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
# Start ngrok without spawning a separate PowerShell window (more reliable in tasks/CI).
# Capture logs so we can show actionable errors (e.g. missing authtoken).
$ngrokOut = Join-Path $PWD "ngrok.out.log"
$ngrokErr = Join-Path $PWD "ngrok.err.log"
if (Test-Path $ngrokOut) { Remove-Item -Force $ngrokOut -ErrorAction SilentlyContinue }
if (Test-Path $ngrokErr) { Remove-Item -Force $ngrokErr -ErrorAction SilentlyContinue }

$ngrokArgs = @("http", "5678", "--log=stdout")
try {
    $ngrokProc = Start-Process -FilePath $ngrokCmd -ArgumentList $ngrokArgs -WindowStyle Hidden -PassThru -RedirectStandardOutput $ngrokOut -RedirectStandardError $ngrokErr
} catch {
    Write-Host "ERROR: Failed to start ngrok" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host "Waiting for ngrok to start..." -ForegroundColor Yellow
# ngrok's local API usually comes up on http://localhost:4040
$tunnel = $null
for ($i = 0; $i -lt 30; $i++) {
    Start-Sleep -Seconds 1
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels" -Method Get -TimeoutSec 2
        $tunnel = $response.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1
        if ($tunnel) { break }
    } catch {
        # keep waiting
    }
}

Write-Host "Getting public URL from ngrok..." -ForegroundColor Cyan
try {
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
        if (Test-Path $ngrokErr) {
            $tail = Get-Content -Path $ngrokErr -ErrorAction SilentlyContinue | Select-Object -Last 20
            if ($tail) {
                Write-Host "ngrok error log (last lines):" -ForegroundColor DarkYellow
                $tail | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
            }
        }
    }
} catch {
    Write-Host "WARNING: Could not get ngrok URL. Starting n8n anyway..." -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Gray
}

Write-Host "Starting n8n..." -ForegroundColor Green
Write-Host "n8n will be available at: http://localhost:5678" -ForegroundColor Cyan
Write-Host ""

npm start
