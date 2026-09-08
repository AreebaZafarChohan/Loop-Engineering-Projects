Set-Location $PSScriptRoot\..

$checkerPrompt = @"
Act as the independent Checker for the documentation freshness task.
Read and follow .claude/skills/doc-freshness/SKILL.md.
Inspect src/ and docs/ independently.
Verify every exported calculator operation is documented, function names match, and descriptions accurately reflect the implementation.
Do NOT modify, create, delete, commit, or push any file.
Your final verdict MUST contain exactly one line starting with either PASS or FAIL.
After that line, provide concise evidence.
"@

opencode run --agent doc-freshness-checker --model opencode/mimo-v2.5-free $checkerPrompt
