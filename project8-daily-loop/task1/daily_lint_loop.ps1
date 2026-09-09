$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$date = Get-Date -Format "yyyy-MM-dd"
Set-Location D:\Gemini_Cli\Loop-Engineering

$progressPath = "project8-daily-loop\task1\progress.md"
$logPath = "project8-daily-loop\task1\run.log"

# Budget guard: skip if already ran today
$alreadyRanToday = $false
if (Test-Path $progressPath) {
    $alreadyRanToday = Select-String -Path $progressPath -Pattern $date -Quiet -ErrorAction SilentlyContinue
}

if ($alreadyRanToday) {
    "[$timestamp] Skipped - already ran today (budget guard)" | Out-File -FilePath $logPath -Append
    exit
}

$branchName = "lint-sweep/$date-$(Get-Date -Format 'HHmmss')"
$worktreePath = "D:\Gemini_Cli\lint-attempt-$date"

if (Test-Path $worktreePath) {
    Remove-Item -Recurse -Force $worktreePath -ErrorAction SilentlyContinue
    git worktree prune 2>&1 | Out-Null
}

if (Test-Path $worktreePath) {
    Remove-Item -Recurse -Force $worktreePath -ErrorAction SilentlyContinue
    git worktree prune 2>&1 | Out-Null
}

git worktree add $worktreePath -b $branchName
if ($LASTEXITCODE -ne 0) {
    "[$timestamp] FAILED - could not create worktree, needs human review" | Out-File -FilePath $logPath -Append
    exit 1
}

if (!(Test-Path "$worktreePath\project8-daily-loop\task1")) {
    "[$timestamp] FAILED - worktree path missing after creation, needs human review" | Out-File -FilePath $logPath -Append
    exit 1
}

Set-Location "$worktreePath\project8-daily-loop\task1"
npm install --silent 2>&1 | Out-Null

$makerResult = claude -p "Read SKILL.md. Run npm run lint. Fix every reported error following the fix steps exactly. Do not change function behavior. Re-run npm run lint to confirm zero errors. Then commit your change with git. If there are no lint errors, say NOTHING_TO_FIX and do not commit." --permission-mode bypassPermissions --output-format json

$hasCommit = (git log --oneline -1 2>&1) -join ""

if ($makerResult -notmatch "NOTHING_TO_FIX") {
    $checkerResult = claude -p "Read SKILL.md's Reviewer checklist. Run npm run lint yourself. Show the git diff of the last commit. Reply with exactly PASS or FAIL, followed by reasons." --permission-mode bypassPermissions --output-format json

    if ($checkerResult -match "PASS") {
        git push -u origin $branchName 2>&1 | Out-Null
        gh pr create --title "Daily lint sweep: $date" --body "Automated fix. Reviewer verdict: PASS" --base main 2>&1 | Out-Null
        $verdict = "PASS - PR opened for $branchName"
    } else {
        $verdict = "FAIL - needs human review. See branch $branchName"
    }
} else {
    $verdict = "No issues found today"
}

Set-Location D:\Gemini_Cli\Loop-Engineering
"## $date`n- Run time: $timestamp`n- Verdict: $verdict`n" | Out-File -FilePath $progressPath -Append
"[$timestamp] Run completed - $verdict" | Out-File -FilePath $logPath -Append

git worktree remove $worktreePath --force 2>&1 | Out-Null
