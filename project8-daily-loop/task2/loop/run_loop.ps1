Set-Location $PSScriptRoot\..

$MaxAttempts = 3
$Attempt = 0
$Result = "FAIL"
$BaselineHash = (Get-Content .\loop\source_baseline.sha256).Trim()

function Write-Spine {
    param(
        [int]$AttemptNumber,
        [string]$Status,
        [string]$Details
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content .\loop\progress.md ""
    Add-Content .\loop\progress.md "### Run - $Timestamp"
    Add-Content .\loop\progress.md "- Attempt: $AttemptNumber"
    Add-Content .\loop\progress.md "- Status: $Status"
    Add-Content .\loop\progress.md "- Details: $Details"
}

while ($Attempt -lt $MaxAttempts) {
    $Attempt++

    Write-Host ""
    Write-Host "=== ATTEMPT $Attempt / $MaxAttempts ==="

    Write-Host "--- MAKER ---"
    powershell -ExecutionPolicy Bypass -File .\loop\run_maker.ps1

    $CurrentHash = (Get-FileHash .\src\calculator.js -Algorithm SHA256).Hash

    if ($CurrentHash -ne $BaselineHash) {
        Write-Host "SOURCE INTEGRITY: FAIL"
        Write-Spine $Attempt "FAIL" "Source file changed during Maker execution. Loop stopped by integrity guard."
        exit 1
    }

    Write-Host "SOURCE INTEGRITY: PASS"

    Write-Host "--- CHECKER ---"
    $CheckerOutput = powershell -ExecutionPolicy Bypass -File .\loop\run_checker.ps1 2>&1 | Out-String

    Write-Host $CheckerOutput

    if ($CheckerOutput -match "(?m)^\s*\**PASS\**\s*$") {
        $Result = "PASS"
        Write-Spine $Attempt "PASS" "Checker verified documentation synchronization and source integrity remained unchanged."
        break
    }

    Write-Spine $Attempt "FAIL" "Checker did not return PASS; retrying Maker."
}

if ($Result -eq "PASS") {
    Write-Host ""
    Write-Host "LOOP RESULT: PASS"
    Write-Host "Completed successfully on attempt $Attempt."
    exit 0
}

Write-Spine $Attempt "FAILED" "Maximum attempt budget of $MaxAttempts reached."
Write-Host ""
Write-Host "LOOP RESULT: FAIL"
Write-Host "Maximum attempt budget of $MaxAttempts reached."
exit 1
