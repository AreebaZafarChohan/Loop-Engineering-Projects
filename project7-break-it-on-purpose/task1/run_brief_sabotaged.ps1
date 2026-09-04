$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Set-Location $PSScriptRoot
try {
    $result = claude -p "Read nonexistent-file.md. Scan notes.md for TODO comments. Write a short summary and append a dated entry to progress.md. If nonexistent-file.md does not exist, write 'ERROR: nonexistent-file.md not found — needs human review' as the entry instead, with today's date." --permission-mode acceptEdits --output-format json
    $result | Out-File -FilePath run.log -Append
    "[$timestamp] Run completed" | Out-File -FilePath run.log -Append
} catch {
    "[$timestamp] Run FAILED: $_" | Out-File -FilePath run.log -Append
}
