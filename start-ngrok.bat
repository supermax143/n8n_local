@echo off
echo Starting n8n with ngrok tunnel...
echo.

REM Check if ngrok is available (local or in PATH)
if exist "ngrok.exe" (
    set NGROK_CMD=ngrok.exe
) else (
    where ngrok >nul 2>&1
    if errorlevel 1 (
        echo ERROR: ngrok is not installed or not in PATH
        echo.
        echo Please:
        echo 1. Download ngrok from https://ngrok.com/download
        echo 2. Add ngrok.exe to PATH or place it in this folder
        echo 3. Get your authtoken from https://dashboard.ngrok.com/get-started/your-authtoken
        echo 4. Run: ngrok config add-authtoken YOUR_TOKEN
        echo.
        pause
        exit /b 1
    ) else (
        set NGROK_CMD=ngrok
    )
)

echo Starting ngrok tunnel first...
start "ngrok" cmd /c "%NGROK_CMD% http 5678"

echo Waiting for ngrok to start...
timeout /t 5 /nobreak >nul

echo Getting public URL from ngrok...
powershell -ExecutionPolicy Bypass -Command "$response = Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -Method Get; $tunnel = $response.tunnels | Where-Object { $_.proto -eq 'https' } | Select-Object -First 1; if ($tunnel) { $webhookUrl = $tunnel.public_url; Write-Host 'Public URL:' $webhookUrl; $env:WEBHOOK_URL = $webhookUrl; $env:N8N_HOST = $webhookUrl.Replace('https://', '').Replace('http://', ''); $env:N8N_PROTOCOL = 'https'; Write-Host 'Environment variables set. Starting n8n...' } else { Write-Host 'ERROR: Could not get ngrok URL'; exit 1 }"

echo.
echo Starting n8n with webhook URL from ngrok...
echo n8n will use the public URL for webhooks automatically
echo.
start "n8n" cmd /c "npm start"

echo.
echo n8n is starting...
echo Check the ngrok window for the public URL
echo n8n will be available at: http://localhost:5678
echo.
pause
