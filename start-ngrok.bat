@echo off
echo Starting n8n with ngrok tunnel...
echo.

REM Check if ngrok is available
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
)

echo Starting n8n in background...
start "n8n" cmd /c "npm start"

echo Waiting for n8n to start...
timeout /t 5 /nobreak >nul

echo.
echo Starting ngrok tunnel...
echo Public URL will be shown below:
echo.
ngrok http 5678
