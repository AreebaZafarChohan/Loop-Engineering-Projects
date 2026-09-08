Set-Location $PSScriptRoot\..
Write-Host "=== HEARTBEAT START ==="
Write-Host "Trigger time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
powershell -ExecutionPolicy Bypass -File .\loop\run_loop.ps1
$ExitCode = $LASTEXITCODE
Write-Host "=== HEARTBEAT END ==="
Write-Host "Loop exit code: $ExitCode"
exit $ExitCode
