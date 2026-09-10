Set-Location $PSScriptRoot\..
Write-Host "=== SCHEDULER WRAPPER START ==="
Write-Host "Trigger time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "Working directory: $(Get-Location)"

powershell -ExecutionPolicy Bypass -File .\loop\heartbeat.ps1
$ExitCode = $LASTEXITCODE

Write-Host "=== SCHEDULER WRAPPER END ==="
Write-Host "Exit code: $ExitCode"
exit $ExitCode
