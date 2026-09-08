Set-Location $PSScriptRoot\..

$makerPrompt = @"
Act as the Maker for the documentation freshness task.
Read and follow .claude/skills/doc-freshness/SKILL.md exactly.
Inspect src/ and docs/.
If documentation is stale, update ONLY files under docs/.
Do NOT modify anything under src/.
Do NOT commit or push.
When finished, report the files changed and whether documentation is synchronized.
"@

opencode run --agent doc-freshness-maker --model opencode/mimo-v2.5-free $makerPrompt
