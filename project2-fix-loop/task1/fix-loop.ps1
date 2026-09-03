$MAX_ATTEMPTS = 6

for ($attempt = 1; $attempt -le $MAX_ATTEMPTS; $attempt++) {

    Write-Host ""
    Write-Host "========================================"
    Write-Host "Attempt $attempt of $MAX_ATTEMPTS"
    Write-Host "========================================"

    Write-Host ""
    Write-Host "🤖 Maker: Claude is working..."

    claude -p @"
We are working on a test-fixing task.

You are the MAKER.

Your job:
1. Inspect the current failing pytest tests.
2. Fix ONLY the implementation code.
3. NEVER modify test files.
4. After fixing, run pytest.
5. Do not stop just because you think the code is correct.
6. The test runner is the source of truth.

If tests are still failing, diagnose the failures and continue fixing.
If all tests pass, stop.

Do not change tests to make them pass.
"@ --permission-mode acceptEdits

    Write-Host ""
    Write-Host "🔍 Checker: running tests..."

    .\run-tests.ps1

    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "🎉 SUCCESS: Tests passed!"
        Write-Host "Loop stopped because the checker returned exit code 0."
        exit 0
    }

    Write-Host ""
    Write-Host "❌ Tests still failing."

    if ($attempt -eq $MAX_ATTEMPTS) {
        Write-Host ""
        Write-Host "🛑 Maximum attempts reached."
        exit 1
    }

    Write-Host "🔄 Continuing to next attempt..."
}

exit 1