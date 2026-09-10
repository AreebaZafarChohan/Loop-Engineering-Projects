# Project 8 Task 2 — Documentation Freshness Loop

A robust, fully guarded, recurring autonomous chore designed to keep project documentation continuously synchronized with source code implementations while strictly preserving source integrity and requiring human review.

---

## 1. Executive Summary

In software engineering, documentation decay is one of the most common forms of technical debt. When developers add, update, or deprecate public functions, API documentation often lags behind. 

**Project 8 Task 2** implements an autonomous **Documentation Freshness Loop** that eliminates manual documentation drift. Operating under strict Loop Engineering principles, this recurring chore:
1. Validates preconditions and repository cleanliness via a **Connector**.
2. Deploys an isolated **OpenCode Maker** agent to inspect exported functions and update stale markdown documentation.
3. Enforces an immutable **Source Integrity Guard** to prevent the Maker from modifying production code.
4. Uses an independent, read-only **OpenCode Checker** agent to adversarially verify that every function name, parameter, and description matches the code.
5. Logs every execution attempt into an auditable **Spine** (`loop/progress.md`).
6. Updates a **Human Understanding Checkpoint** (`human_review.md`), ensuring that automated runs never self-approve.

---

## 2. Objective & Architectural Concepts

### The Problem
Automated code generation often leads to "silent hallucination" or out-of-scope edits where an AI agent tasked with updating docs accidentally modifies implementation files or introduces incorrect parameters. Furthermore, unconstrained retry loops can spin indefinitely, burning API budgets.

### The Solution: A Complete, Guarded Engineering Loop
This project implements a complete closed-loop architecture where no single component has unilateral control:

```
[Heartbeat Trigger] 
       │
       ▼
[Connector Pre-Flight] ──(Fail)──► [Halt Loop & Log Spine]
       │ (Pass)
       ▼
[Budget Guard (Max 3)] ──(Exceeded)──► [Halt Loop & Log Spine]
       │ (Within Budget)
       ▼
[OpenCode Maker Agent] ──(Inspects src/ & Edits docs/)
       │
       ▼
[Source Integrity Guard] ──(Source Modified)──► [Halt Loop & Log Spine]
       │ (Source Clean)
       ▼
[OpenCode Checker Agent] ──(FAIL)──► [Retry Loop (Back to Budget)]
       │ (PASS)
       ▼
[Append Audit Spine] ──► [Record Attempt & Status in progress.md]
       │
       ▼
[Human Review Checkpoint] ──► [Set PENDING & Update Timestamp in human_review.md]
```

### Core Loop Engineering Concepts Demonstrated

1. **Heartbeat (`heartbeat.ps1`)**: The idempotent external trigger (cron/scheduler equivalent) that starts the autonomous loop cycle.
2. **Scheduler Wrapper (`scheduler_wrapper.ps1`)**: Windows Task Scheduler entry point that wraps heartbeat for fully autonomous daily execution.
3. **Dedicated Worktree (`project8-task2-loop`)**: Total filesystem and Git isolation from the main branch and other tasks (such as Task 1).
4. **Skill (`SKILL.md`)**: Reusable, codified operational instructions defining explicit inspection steps, Maker constraints, and Checker criteria.
5. **Maker (`run_maker.ps1`)**: An LLM agent configured with scoped write permissions restricted exclusively to `docs/**`.
6. **Checker (`run_checker.ps1`)**: An independent, adversarial, read-only LLM agent that verifies truth against implementation without the ability to modify files.
7. **Connector (`connector.ps1`)**: Pre-flight inspection script that asserts filesystem and Git clean state before agent execution.
8. **Spine (`progress.md`)**: An append-only persistent ledger tracking every attempt, status outcome, and diagnostic detail.
9. **Budget Guards (`run_loop.ps1`)**: Bounded retry execution (`$MaxAttempts = 3`) preventing infinite loops and runaway API costs.
10. **Source Integrity (`git diff --quiet`)**: Cryptographic and Git-level guarantees ensuring the Maker never mutates underlying source code.
11. **Human Understanding / Concept 15 (`human_review.md`)**: An explicit approval barrier requiring human operators to verify and sign off on automated changes.

---

## 3. Final Project Structure

```
project8-daily-loop/
└── task2/
    ├── .claude/
    │   └── skills/
    │       └── doc-freshness/
    │           └── SKILL.md          # Freshness inspection rules & reviewer checklist
    ├── docs/
    │   └── calculator.md             # API documentation for calculator module
    ├── loop/
    │   ├── connector.ps1             # Pre-flight environment & git status inspector
    │   ├── heartbeat.ps1             # Main loop trigger and exit code handler
    │   ├── progress.md               # Audit spine recording all execution history
    │   ├── run_checker.ps1           # Independent verification agent runner
    │   ├── run_loop.ps1              # Core loop orchestrator with guards & retry logic
    │   ├── run_maker.ps1             # Documentation synchronization agent runner
    │   └── scheduler_wrapper.ps1     # Windows Task Scheduler entry point
    ├── src/
    │   └── calculator.js             # Source implementation module (exported functions)
    ├── human_review.md               # Human understanding & sign-off checkpoint
    ├── opencode.json                 # Agent permissions & model configuration
    └── README.md                     # Engineering lab record & build documentation
```

### File Responsibilities

| File | Purpose |
|---|---|
| `src/calculator.js` | Source code under test containing arithmetic functions (`add`, `subtract`, `multiply`). |
| `docs/calculator.md` | Public documentation describing available calculator operations. |
| `.claude/skills/doc-freshness/SKILL.md` | Skill definition providing procedural guidance to Maker and Checker agents. |
| `opencode.json` | Declarative security sandbox configuration restricting agent tools and write paths. |
| `loop/connector.ps1` | Returns structured JSON describing source existence, doc existence, Git branch, commit, and source cleanliness. |
| `loop/heartbeat.ps1` | Top-level runner invoked by schedulers to trigger `run_loop.ps1`. |
| `loop/scheduler_wrapper.ps1` | Windows Task Scheduler entry point that wraps heartbeat for automated daily execution. |
| `loop/run_maker.ps1` | Invokes the `doc-freshness-maker` agent using OpenCode and `mimo-v2.5-free`. |
| `loop/run_checker.ps1` | Invokes the `doc-freshness-checker` agent to output an unambiguous `PASS` or `FAIL`. |
| `loop/run_loop.ps1` | Coordinates the full cycle: Connector → Budget → Maker → Source Integrity → Checker → Spine → Review. |
| `loop/progress.md` | Append-only execution history documenting every run timestamp, attempt count, and verdict. |
| `human_review.md` | Explicit review gate enforcing human sign-off on changes. |

---

## 4. Git Worktree Isolation Strategy

To adhere to enterprise safety standards, Task 2 was completely isolated from the default branch (`main`) and from sibling tasks (`task1`).

```
D:\Gemini_Cli\Loop-Engineering\ (Repository Root)
├── .worktrees/
│   └── project8-task2-loop/     <-- Dedicated Worktree on branch 'project8-task2-loop'
│       └── project8-daily-loop/
│           └── task2/           <-- Isolated Execution Directory
```

### Isolation Principles Followed:
1. **No Direct Commits to `main`**: All experimental loops, agent executions, and prompt adjustments occurred inside branch `project8-task2-loop`.
2. **Zero Blast Radius for Task 1**: Task 1 files remained untouched in their own workspace.
3. **No `git add .` Wildcards**: Bulk staging was strictly avoided. All commits used targeted, selective staging (`git add <file>`) to guarantee no unwanted artifacts, cache files, or dirty temporary files entered version control.
4. **Clean Baseline Tracking**: Changes were audited using `git diff --cached --check` prior to final commit.

---

## 5. Step-by-Step Build Process

This section documents the actual chronological process undertaken to build, debug, harden, and verify the loop.

---

### Step 1 — Establish Baseline Source and Documentation

#### Objective
Create the initial mathematical functions in `src/calculator.js` and matching baseline documentation in `docs/calculator.md`.

#### Implementation
```javascript
// src/calculator.js (Initial State)
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

module.exports = { add, subtract };
```

```markdown
<!-- docs/calculator.md (Initial State) -->
# Calculator

The calculator provides two operations:

- `add(a, b)` — adds two numbers.
- `subtract(a, b)` — subtracts the second number from the first.
```

#### Verification & Commit
Baseline established and committed under commit `9cd215c`:
```powershell
git commit -m "Project8 task2: add documentation freshness baseline"
```

---

### Step 2 — Define the Freshness Skill

#### Objective
Codify operational guidelines for AI agents to prevent behavioral drift, enforce documentation style, and strictly forbid source modification.

#### Implementation
Created `.claude/skills/doc-freshness/SKILL.md`:

```markdown
---
name: doc-freshness
description: Keep documentation synchronized with current source code in project8-daily-loop/task2
---

# Documentation Freshness Skill

## Goal
Keep documentation synchronized with the current source code.

## Inspect
1. Read the source files under src/.
2. Read the documentation under docs/.
3. Compare documented operations with exported functions.

## Maker Rules
- Update only files under docs/.
- Do not modify source code.
- Do not change function behavior.
- Preserve existing documentation style.
- Add missing operations when they are clearly present in the source code.

## Reviewer Checklist
- Every exported calculator operation is documented.
- Function names and descriptions match the source code.
- No source files were modified.
- Documentation changes are limited to docs/.
```

---

### Step 3 — Configure OpenCode Model and Agent Permissions

#### Objective
Configure OpenCode CLI (`1.18.27`) with the high-throughput, low-latency model `opencode/mimo-v2.5-free`, establishing distinct roles for `doc-freshness-maker` and `doc-freshness-checker`.

#### Initial Configuration (`opencode.json`)
```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "doc-freshness-maker": {
      "mode": "primary",
      "model": "opencode/mimo-v2.5-free",
      "description": "Updates documentation to match the current source code.",
      "permission": {
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "skill": "allow",
        "edit": {
          "docs/**": "allow",
          "*": "deny"
        },
        "bash": "deny",
        "task": "deny",
        "webfetch": "deny",
        "websearch": "deny"
      }
    },
    "doc-freshness-checker": {
      "mode": "primary",
      "model": "opencode/mimo-v2.5-free",
      "description": "Independently verifies documentation against source code.",
      "permission": {
        "read": "allow",
        "glob": "allow",
        "grep": "allow",
        "skill": "allow",
        "edit": "deny",
        "bash": "deny",
        "task": "deny",
        "webfetch": "deny",
        "websearch": "deny"
      }
    }
  }
}
```

---

### Step 4 — OpenCode Permission Debugging & Path Resolution (Crucial Lab Discovery)

#### The Problem Encountered
During early execution of the Maker agent against stale documentation, OpenCode threw permission denial errors when attempting to edit `docs/calculator.md`.

#### Investigation & Diagnosis
Running the OpenCode agent inspection tool revealed that permission evaluation was collapsing `edit` and `write` capabilities to `false`:
```powershell
opencode debug agent doc-freshness-maker
```
*Observed Output:*
```json
"tools": {
  "read": true,
  "glob": true,
  "grep": true,
  "edit": false,
  "write": false,
  "bash": false
}
```

#### Root Cause Analysis:
1. **Rule Evaluation Order**: In OpenCode's declarative permission engine, putting `"*": "deny"` after `"docs/**": "allow"` caused the global wildcard to override the specific allow rule.
2. **Working Directory Path Resolution**: When executing from the repository root or task directory, OpenCode resolved target file paths relative to both the workspace root and the local task root (`project8-daily-loop/task2/docs/**`). When only `"docs/**"` was specified, requests evaluated against the repo-relative path were denied.

#### Solution & Remediation
Updated `opencode.json` to evaluate `"*": "deny"` first, followed by explicit glob allowances for both relative and repo-rooted paths:

```json
"edit": {
  "*": "deny",
  "docs/**": "allow",
  "project8-daily-loop/task2/docs/**": "allow"
}
```

#### Re-Verification
```powershell
opencode debug agent doc-freshness-maker
```
*Confirmed Diagnostic Output:*
```json
"tools": {
  "read": true,
  "glob": true,
  "grep": true,
  "edit": true,
  "write": true,
  "bash": false
}
```

---

### Step 5 — Implement Maker Script (`loop/run_maker.ps1`)

#### Objective
Wrap the OpenCode Maker agent invocation into a standalone, reproducible PowerShell script that injects the freshness prompt and loads the skill.

#### Code (`loop/run_maker.ps1`)
```powershell
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
```

---

### Step 6 — Implement Checker Script (`loop/run_checker.ps1`)

#### Objective
Create an isolated, read-only verification agent that inspects source vs documentation and emits an authoritative, machine-parseable `PASS` or `FAIL` verdict.

#### Code (`loop/run_checker.ps1`)
```powershell
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
```

---

### Step 7 — Build the Pre-Flight Connector (`loop/connector.ps1`)

#### Objective
Ensure that prerequisites are met before invoking AI models: source files exist, doc files exist, Git repository is clean, and HEAD commit is known.

#### Code (`loop/connector.ps1`)
```powershell
Set-Location $PSScriptRoot\..

$SourcePath = ".\src\calculator.js"
$DocsPath = ".\docs\calculator.md"

$SourceExists = Test-Path $SourcePath
$DocsExists = Test-Path $DocsPath

git diff --quiet HEAD -- .\src\calculator.js
$SourceClean = ($LASTEXITCODE -eq 0)

$Branch = (git branch --show-current).Trim()
$Commit = (git rev-parse --short HEAD).Trim()

$result = [ordered]@{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    branch = $Branch
    commit = $Commit
    source = @{
        path = $SourcePath
        exists = $SourceExists
        git_clean = $SourceClean
    }
    documentation = @{
        path = $DocsPath
        exists = $DocsExists
    }
}

$result | ConvertTo-Json -Depth 4
```

---

### Step 8 — Source Integrity Guard Architecture

#### From Static SHA256 to Dynamic Git Diff
In early iterations, source integrity was checked against a static file hash (`source_baseline.sha256`). However, static hash files introduce drift when legitimate source modifications occur across commits.

#### The Modern Git-Native Solution
We replaced static hash files with Git's internal index check:
```powershell
git diff --quiet HEAD -- .\src\calculator.js
```
- If the Maker leaves source code untouched: exit code is `0` (`SOURCE INTEGRITY: PASS`).
- If the Maker alters even a single byte of `src/calculator.js`: exit code is non-zero, immediately failing the loop and preventing bad state propagation.

---

### Step 9 — Orchestrate the Master Loop (`loop/run_loop.ps1`)

#### Objective
Combine Connector, Budget Guards, Maker execution, Source Integrity verification, Checker evaluation, Spine recording, and Human Review signaling into a single robust engine.

#### Code Highlights (`loop/run_loop.ps1`)
```powershell
Set-Location $PSScriptRoot\..

$Attempt = 0
$Result = "FAIL"
$MaxAttempts = 3
$BudgetUsed = 0

# 1. Run Connector
$ConnectorState = powershell -ExecutionPolicy Bypass -File .\loop\connector.ps1 | Out-String
Write-Host "--- CONNECTOR ---"
Write-Host $ConnectorState
$ConnectorJson = $ConnectorState | ConvertFrom-Json
if (-not $ConnectorJson.source.exists -or -not $ConnectorJson.documentation.exists -or -not $ConnectorJson.source.git_clean) {
    Write-Host "CONNECTOR GUARD: FAIL"
    Write-Spine 0 "FAIL" "Connector detected missing required files or pre-existing source changes. Loop stopped before Maker."
    exit 1
}
Write-Host "CONNECTOR GUARD: PASS"

function Write-Spine {
    param([int]$AttemptNumber, [string]$Status, [string]$Details)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content .\loop\progress.md ""
    Add-Content .\loop\progress.md "### Run - $Timestamp"
    Add-Content .\loop\progress.md "- Attempt: $AttemptNumber"
    Add-Content .\loop\progress.md "- Status: $Status"
    Add-Content .\loop\progress.md "- Details: $Details"
}

# 2. Execution & Retry Loop
while ($Attempt -lt $MaxAttempts) {
    $Attempt++
    $BudgetUsed = $Attempt
    Write-Host "BUDGET: $BudgetUsed / $MaxAttempts attempts used"
    if ($BudgetUsed -gt $MaxAttempts) {
        Write-Host "BUDGET GUARD: FAIL"
        Write-Spine $Attempt "FAILED" "Attempt budget exceeded."
        exit 1
    }
    Write-Host "BUDGET GUARD: PASS"

    Write-Host ""
    Write-Host "=== ATTEMPT $Attempt / $MaxAttempts ==="

    # 3. Maker Execution
    Write-Host "--- MAKER ---"
    powershell -ExecutionPolicy Bypass -File .\loop\run_maker.ps1

    # 4. Source Integrity Check
    git diff --quiet HEAD -- .\src\calculator.js
    if ($LASTEXITCODE -ne 0) {
        Write-Host "SOURCE INTEGRITY: FAIL"
        Write-Spine $Attempt "FAIL" "Source file changed during Maker execution. Loop stopped by integrity guard."
        exit 1
    }
    Write-Host "SOURCE INTEGRITY: PASS"

    # 5. Checker Execution
    Write-Host "--- CHECKER ---"
    $CheckerErrorPath = ".\loop\checker_stderr.tmp"
    $CheckerOutput = powershell -ExecutionPolicy Bypass -File .\loop\run_checker.ps1 2> $CheckerErrorPath | Out-String
    if (Test-Path $CheckerErrorPath) { Remove-Item $CheckerErrorPath -Force }

    Write-Host $CheckerOutput

    # 6. Evaluation & Human Review Checkpoint Update
    if ($CheckerOutput -match "(?m)^\s*\**PASS\**\s*$") {
        $Result = "PASS"
        Write-Spine $Attempt "PASS" "Checker verified documentation synchronization and source integrity remained unchanged."
        
        $ReviewPath = ".\human_review.md"
        $ReviewContent = Get-Content $ReviewPath -Raw
        $ReviewContent = [regex]::Replace($ReviewContent, '(?m)^- Last automated attempt:.*\r?\n?', '')
        $ReviewContent = [regex]::Replace($ReviewContent, '(?m)^- Last automated review timestamp:.*\r?\n?', '')
        $ReviewContent = $ReviewContent.Replace("- Last automated run: PASS", "- Last automated run: PASS`r`n- Last automated attempt: $Attempt`r`n- Last automated review timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
        $ReviewContent | Set-Content $ReviewPath
        Write-Host "HUMAN REVIEW: REQUIRED"
        break
    }

    Write-Spine $Attempt "FAIL" "Checker did not return PASS; retrying Maker."
}

if ($Result -eq "PASS") {
    Write-Host ""
    Write-Host "LOOP RESULT: PASS"
    Write-Host "Completed successfully on attempt $Attempt."
    exit 0
}

Write-Spine $Attempt "FAILED" "Maximum attempt budget of $MaxAttempts reached."
Write-Host ""
Write-Host "LOOP RESULT: FAIL"
Write-Host "Maximum attempt budget of $MaxAttempts reached."
exit 1
```

---

### Step 10 — Create the Heartbeat Entrypoint (`loop/heartbeat.ps1`)

#### Objective
Provide a unified, single-command entry point suitable for task schedulers (Windows Task Scheduler, cron, CI runners).

#### Code (`loop/heartbeat.ps1`)
```powershell
Set-Location $PSScriptRoot\..
Write-Host "=== HEARTBEAT START ==="
Write-Host "Trigger time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
powershell -ExecutionPolicy Bypass -File .\loop\run_loop.ps1
$ExitCode = $LASTEXITCODE
Write-Host "=== HEARTBEAT END ==="
Write-Host "Loop exit code: $ExitCode"
exit $ExitCode
```

---

### Step 11 — Create the Scheduler Wrapper (`loop/scheduler_wrapper.ps1`)

#### Objective
Provide a Windows Task Scheduler-compatible entry point that wraps the heartbeat trigger, enabling fully autonomous daily execution without manual intervention.

#### Implementation
```powershell
Set-Location $PSScriptRoot\..
Write-Host "=== SCHEDULER WRAPPER START ==="
Write-Host "Trigger time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Host "Working directory: $(Get-Location)"

powershell -ExecutionPolicy Bypass -File .\loop\heartbeat.ps1
$ExitCode = $LASTEXITCODE

Write-Host "=== SCHEDULER WRAPPER END ==="
Write-Host "Exit code: $ExitCode"
exit $ExitCode
```

#### Windows Task Scheduler Configuration
- **Task Name:** `Project8-Task2-Documentation-Freshness`
- **Trigger:** Daily at 9:00 AM
- **Action:** `powershell.exe -NoProfile -ExecutionPolicy Bypass -File "...\loop\scheduler_wrapper.ps1"`
- **Last Result:** `0` (Success)

---

### Step 12 — Establish Human Understanding Gate (`human_review.md`)

#### Objective
Ensure that autonomous actions do not automatically deploy without human validation. Under Concept 15, automation assists the human; it does not replace human responsibility.

#### Content (`human_review.md`)
```markdown
# Human Understanding Checkpoint

## Review Status

- Status: PENDING
- Human approval: REQUIRED
- Last automated run: PASS
- Last automated attempt: 1
- Last automated review timestamp: 2026-09-08 21:37:38

## What the loop does

The documentation freshness loop inspects source code and documentation, asks the OpenCode Maker to synchronize stale documentation, verifies the result with an independent OpenCode Checker, and records the run in `loop/progress.md`.

## Human Review Checklist

- [ ] I understand what the Maker changed.
- [ ] I understand why the documentation is correct.
- [ ] I confirmed source code was not modified by the Maker.
- [ ] I approve the resulting documentation state.

## Review Notes

_Add human notes here after reviewing an automated run._
```

---

## 6. Verification and Empirical Testing

Two distinct scenarios were executed to test both failure recovery and steady-state behavior.

### Scenario A — Stale Documentation Detection & Auto-Recovery

1. **Initial Condition**:
   - `src/calculator.js` was modified to export `multiply(a, b)` in addition to `add` and `subtract`.
   - `docs/calculator.md` documented only `add` and `subtract`.
2. **Execution**:
   - Connector verified files and Git clean status.
   - Maker ran, inspected `src/calculator.js`, identified missing `multiply` function, and edited `docs/calculator.md` to append:
     ```markdown
     - `multiply(a, b)` — multiplies two numbers.
     ```
   - Source integrity guard confirmed `src/calculator.js` was untouched.
   - Checker inspected both files and returned `PASS`.
   - Spine recorded a successful attempt 1 run.

---

### Scenario B — Steady State (Already Synchronized)

1. **Initial Condition**:
   - Both `src/` and `docs/` contained all 3 operations (`add`, `subtract`, `multiply`).
2. **Execution**:
   ```powershell
   .\loop\heartbeat.ps1
   ```
3. **Observed Output**:
   ```text
   === HEARTBEAT START ===
   Trigger time: 2026-09-08 21:37:38
   --- CONNECTOR ---
   {
       "timestamp": "2026-09-08 21:37:38",
       "branch": "project8-task2-loop",
       "commit": "0e6bfae",
       "source": {
           "path": ".\\src\\calculator.js",
           "exists": true,
           "git_clean": true
       },
       "documentation": {
           "path": ".\\docs\\calculator.md",
           "exists": true
       }
   }
   CONNECTOR GUARD: PASS
   BUDGET: 1 / 3 attempts used
   BUDGET GUARD: PASS

   === ATTEMPT 1 / 3 ===
   --- MAKER ---
   Maker inspected src/ and docs/. All 3 operations (add, subtract, multiply) are already documented. No changes required.
   SOURCE INTEGRITY: PASS
   --- CHECKER ---
   PASS
   Evidence:
   - 3 exported functions in src/calculator.js: add, subtract, multiply.
   - 3 operations documented in docs/calculator.md: add, subtract, multiply.
   - Descriptions accurately reflect implementation.
   - No source files modified.

   HUMAN REVIEW: REQUIRED

   LOOP RESULT: PASS
   Completed successfully on attempt 1.
   === HEARTBEAT END ===
   Loop exit code: 0
   ```

---

## 7. Auditing & The Spine (`loop/progress.md`)

The spine maintains a full ledger of every historical run, including early permission failures and test iterations.

### Sample Entries from `loop/progress.md`:
```markdown
### Run - 2026-09-08 20:12:56
- Attempt: 1
- Status: FAIL
- Details: Source file changed during Maker execution. Loop stopped by integrity guard.

### Run - 2026-09-08 20:50:10
- Attempt: 3
- Status: FAILED
- Details: Maximum attempt budget of 3 reached.

### Run - 2026-09-08 21:37:38
- Attempt: 1
- Status: PASS
- Details: Checker verified documentation synchronization and source integrity remained unchanged.
```

---

## 8. Final Git Audit and Commit Record

All staging was performed selectively in the dedicated worktree to guarantee workspace cleanliness.

### Staging Verification
```powershell
git -C ..worktrees\project8-task2-loop diff --cached --stat
```

#### Final Staged Files (6 files):
1. `project8-daily-loop/task2/human_review.md` (new file)
2. `project8-daily-loop/task2/loop/connector.ps1` (new file)
3. `project8-daily-loop/task2/loop/progress.md` (updated spine)
4. `project8-daily-loop/task2/loop/run_loop.ps1` (updated orchestration)
5. `project8-daily-loop/task2/loop/source_baseline.sha256` (removed in favor of Git diff check)
6. `project8-daily-loop/task2/opencode.json` (corrected permission paths)

### Final Commit Details
- **Commit SHA**: `ba5d294`
- **Branch**: `project8-task2-loop`
- **Message**: `Project8 task2: add documentation freshness loop`
- **Statistics**: 6 files changed, 174 insertions(+), 9 deletions(-)
- **Push Status**: Intentionally not pushed (preserved on local feature branch).

---

## 9. Comprehensive Safety Model

| Layer | Component | Defense Mechanism |
|---|---|---|
| **Filesystem Isolation** | Git Worktree | Confines all execution to `project8-task2-loop`, keeping `main` and `task1` pristine. |
| **Agent Prompt Guidance** | `SKILL.md` | Provides deterministic instructions and explicit checklists for Maker and Checker. |
| **Sandbox Permissions** | `opencode.json` | Blocks bash, task, web, and limits Maker edits strictly to `docs/**`. Sets Checker to read-only. |
| **Pre-Flight Inspection** | `connector.ps1` | Halts execution immediately if required files are missing or source code has unstaged diffs. |
| **Source Protection** | `git diff --quiet` | Kills the loop instantly if Maker touches `src/calculator.js`. |
| **Resource Protection** | `$MaxAttempts = 3` | Bounds retry attempts to prevent infinite API billing loops. |
| **Traceability** | `progress.md` | Immutable spine logging timestamps, attempt counts, and failure details for audits. |
| **Human Governance** | `human_review.md` | Enforces Concept 15: requires human sign-off; machines never approve their own work. |

---

## 10. Key Engineering Insights

1. **Declarative Permissions Require Exact Path Matching**: AI tooling like OpenCode resolves paths both locally and relative to the git root. When configuring path-restricted permissions, both `docs/**` and `project8-daily-loop/task2/docs/**` must be explicitly whitelisted.
2. **Git is Superior to Static Hashes**: Hardcoded hash files create maintenance overhead and false alarms across revisions. Leveraging `git diff --quiet HEAD -- <file>` provides instant, zero-maintenance source integrity verification.
3. **Maker and Checker Must Be Strictly Segregated**: A single agent reviewing its own output suffers from self-confirmation bias. Separating into an editing Maker and a read-only Checker ensures objective, adversarial validation.
4. **Autonomous Loops Need Strict Bounds**: Every autonomous loop must implement hard limits ($MaxAttempts) and graceful exits to handle transient model errors without runaway consumption.
5. **Human Understanding is Non-Negotiable**: Fully autonomous commits can easily lead to compounding subtle errors. The human review checkpoint ensures transparency, auditability, and governance over automated maintenance chores.

---

## 11. Final Implementation Checklist

- [x] **Heartbeat Trigger** (`loop/heartbeat.ps1`)
- [x] **Scheduler Wrapper** (`loop/scheduler_wrapper.ps1`)
- [x] **Dedicated Worktree & Branch** (`project8-task2-loop`)
- [x] **Freshness Skill** (`.claude/skills/doc-freshness/SKILL.md`)
- [x] **OpenCode Maker Agent** (`opencode.json` & `loop/run_maker.ps1`)
- [x] **OpenCode Checker Agent** (`opencode.json` & `loop/run_checker.ps1`)
- [x] **Environment Connector** (`loop/connector.ps1`)
- [x] **Git-Native Source Integrity Guard** (`git diff --quiet`)
- [x] **Bounded Budget Guard** (`$MaxAttempts = 3`)
- [x] **Persistent Audit Spine** (`loop/progress.md`)
- [x] **Human Understanding Checkpoint** (`human_review.md`)
- [x] **Stale Documentation Recovery Tested**
- [x] **Already-Fresh Documentation Tested**
- [x] **End-to-End Heartbeat Tested (Exit Code 0)**
- [x] **Selective Git Staging Completed**
- [x] **Final Commit Created (`ba5d294`)**
- [ ] **Push** — *Intentionally not performed*
- [ ] **Human Approval** — *Intentionally remains REQUIRED (PENDING)*
