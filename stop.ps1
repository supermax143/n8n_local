Write-Host "Stopping n8n..." -ForegroundColor Yellow
Write-Host ""

# Find process listening on port 5678
$listening = netstat -ano | Select-String ":5678" | Select-String "LISTENING"

if ($listening) {
    # NOTE: $PID is an automatic, read-only variable in PowerShell (current process id).
    # Use a different variable name to avoid "VariableNotWritable".
    $n8nPid = ($listening -split '\s+')[-1]
    Write-Host "Found n8n process with PID: $n8nPid" -ForegroundColor Cyan
    
    try {
        Stop-Process -Id $n8nPid -Force -ErrorAction Stop
        Write-Host "Successfully stopped n8n (PID: $n8nPid)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to stop process $n8nPid" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}
else {
    Write-Host "No n8n process found on port 5678" -ForegroundColor Yellow
    Write-Host "Trying to stop all node processes..." -ForegroundColor Yellow
    
    $nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
    if ($nodeProcesses) {
        $nodeProcesses | Stop-Process -Force
        Write-Host "Stopped all node processes" -ForegroundColor Green
    }
    else {
        Write-Host "No node processes found" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Start-Sleep -Seconds 1
