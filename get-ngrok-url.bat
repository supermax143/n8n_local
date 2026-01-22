@echo off
echo Getting ngrok public URL...
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0get-ngrok-url.ps1"
pause
