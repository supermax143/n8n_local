@echo off
echo Stopping n8n...
echo.

REM Find process listening on port 5678
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":5678" ^| findstr "LISTENING"') do (
    echo Found n8n process with PID: %%a
    taskkill /PID %%a /F >nul 2>&1
    if errorlevel 1 (
        echo Failed to stop process %%a
    ) else (
        echo Successfully stopped n8n (PID: %%a)
    )
)

REM Also try to stop all node processes (if no process found on port)
netstat -ano | findstr ":5678" | findstr "LISTENING" >nul
if errorlevel 1 (
    echo No n8n process found on port 5678
    echo Trying to stop all node processes...
    taskkill /IM node.exe /F >nul 2>&1
    if errorlevel 1 (
        echo No node processes found
    ) else (
        echo Stopped all node processes
    )
)

echo.
echo Done!
timeout /t 2 >nul
