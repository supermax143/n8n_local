Write-Host "Stopping n8n..." -ForegroundColor Yellow
Write-Host ""

# Find process listening on port 5678
$listening = netstat -ano | Select-String ":5678" | Select-String "LISTENING"

if ($listening) {
    $pid = ($listening -split '\s+')[-1]
    Write-Host "Found n8n process with PID: $pid" -ForegroundColor Cyan
    
    try {
        Stop-Process -Id $pid -Force -ErrorAction Stop
        Write-Host "Successfully stopped n8n (PID: $pid)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to stop process $pid" -ForegroundColor Red
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
