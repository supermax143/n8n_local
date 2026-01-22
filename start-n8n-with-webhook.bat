@echo off
echo Starting n8n with webhook URL from ngrok...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0start-n8n-with-webhook.ps1"
