pytest

if ($LASTEXITCODE -eq 0) {
    Write-Host "TESTS PASSED"
    exit 0
}
else {
    Write-Host "TESTS FAILED"
    exit 1
}