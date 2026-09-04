Set-Location $PSScriptRoot

$maxAttempts = 3
$successFile = ".\required-success.md"

for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "ATTEMPT $attempt/$maxAttempts"

    claude -p "Read nonexistent-file.md. Do not create required-success.md. Report what you find and stop." --allowedTools "Edit,Write"

    if (Test-Path $successFile) {
        Add-Content .\progress.md "`n## $timestamp`nSUCCESS: Required artifact was created on attempt $attempt."
        Write-Host "SUCCESS"
        exit 0
    }

    Add-Content .\progress.md "`n## $timestamp`nFAILURE: Attempt $attempt/$maxAttempts failed because required-success.md was not created."
    Write-Host "FAILURE: required-success.md not found"
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content .\progress.md "`n## $timestamp`nNEEDS HUMAN: Maximum attempts ($maxAttempts) reached. Loop stopped to prevent unbounded retries."
Write-Host "NEEDS HUMAN: maximum attempts reached"
exit 1
