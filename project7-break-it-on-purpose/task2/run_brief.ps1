Set-Location $PSScriptRoot
claude -p "Read nonexistent-file.md. Look at git log for commits from the last 24 hours (git log --since='1 day ago'). Also scan for any new TODO comments not already logged. Write a short summary and append a new dated entry to progress.md. Do not repeat anything already logged." --allowedTools "Edit,Write"
