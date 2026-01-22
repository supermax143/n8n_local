@echo off
echo Updating webhook URL in .env file...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0update-webhook-url.ps1"
pause
