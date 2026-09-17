Set-Location $PSScriptRoot\..

$repoRoot = (git -C $PSScriptRoot rev-parse --show-toplevel 2>$null).Trim()
if (-not $repoRoot) {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
}

$prompt = @"
You are running the ANALYSIS phase of Project 12: Dreaming Loop.

REPOSITORY ROOT:
$repoRoot

You are NOT allowed to modify the target skill.
You are NOT allowed to create a branch.
You are NOT allowed to commit.
You are NOT allowed to push.
You are NOT allowed to create or merge a PR.

Use these EXACT absolute paths:

STATE:
$repoRoot\project12-dreaming-loop\task1\dreaming-state.md

DREAMING SKILL:
$repoRoot\project12-dreaming-loop\task1\.claude\skills\dreaming-loop\SKILL.md

SOURCE SPINE:
$repoRoot\project8-daily-loop\task2\loop\progress.md

TARGET SKILL:
$repoRoot\project8-daily-loop\task2\.claude\skills\doc-freshness\SKILL.md

Do not resolve these paths relative to project12-dreaming-loop/task1.

Follow the Dreaming Loop skill exactly.

CURSOR:
Read dreaming-state.md first.
Analyze ONLY progress entries strictly after the cursor date.
Do not use older entries as evidence for current findings.

REPEATED FAILURE:
A valid improvement candidate requires at least two separate logged runs or attempts with:
- exact dates
- exact Run IDs when available
- materially similar failure/correction
- direct evidence-to-rule connection

The deliberately planted P12 fixtures are valid capstone test evidence.
Do NOT describe them as normal production history.

The repeated-failure evidence should identify:
- P12-FIXTURE-01 — 2026-09-11
- P12-FIXTURE-02 — 2026-09-12

DELETION TEST:
The assignment asks for a deletion proposal for a rule that was not needed in recent runs.

Inspect:
"Preserve existing documentation style."

Use these deliberately planted test entries as evidence:
- P12-FIXTURE-03 — 2026-09-13
- P12-FIXTURE-04 — 2026-09-14
- P12-FIXTURE-05 — 2026-09-15
- P12-FIXTURE-06 — 2026-09-16

The deletion proposal MUST:
- identify the exact rule
- cite the exact recent Run IDs and dates
- state the frequency of recent runs where the rule was not needed
- explain that the proposal is based on the analyzed recent evidence only
- NOT claim that the rule is universally useless unless the evidence actually proves that

If the evidence is still insufficient even under the assignment's "no recent run needed" criterion, write:
NO EVIDENCE — NO DELETION

IMPROVEMENT:
Propose the smallest evidence-backed addition/replacement to:
$repoRoot\project8-daily-loop\task2\.claude\skills\doc-freshness\SKILL.md

Do not rewrite unrelated rules.

OUTPUT:
Write the final analysis to:
$repoRoot\project12-dreaming-loop\task1\evidence\analysis.md

Required sections:

# Dreaming Loop Analysis

## Cursor Used

## Repeated Failure Evidence

## Proposed Improvement

## Proposed Deletion

## Human Gate

Use exactly:
Human merge required. No target skill change is effective until the PR is manually reviewed and merged.

## Verification

Confirm:
- repository root was used
- only entries after cursor were analyzed
- target skill was not modified
- no branch was created
- no commit was made
- no push occurred
- evidence is explicitly identified as capstone fixtures where applicable
"@

opencode run --model opencode/mimo-v2.5-free $prompt
