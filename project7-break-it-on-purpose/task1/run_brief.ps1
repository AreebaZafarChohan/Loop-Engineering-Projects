$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Set-Location $PSScriptRoot
try {
    $result = claude -p "Read progress.md. Scan notes.md for TODO comments. Write a short summary and append a dated entry to progress.md." --permission-mode acceptEdits --output-format json
    $result | Out-File -FilePath run.log -Append
    "[$timestamp] Run completed successfully" | Out-File -FilePath run.log -Append
} catch {
    "[$timestamp] Run FAILED: $_" | Out-File -FilePath run.log -Append
}
