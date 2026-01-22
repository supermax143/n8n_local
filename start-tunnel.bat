@echo off
echo Starting n8n with tunnel (for webhooks)...
echo.
echo This will create a public URL for Telegram webhooks
echo n8n will be available at: http://localhost:5678
echo Public webhook URL will be shown in the console
echo Press Ctrl+C to stop n8n
echo.
npm run start:tunnel
