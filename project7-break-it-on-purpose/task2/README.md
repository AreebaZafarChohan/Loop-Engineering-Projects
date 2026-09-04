# Project 7 — Break It on Purpose

## Task 2 — Bounded Failure & Human Escalation

## Objective
The objective of this task was to intentionally engineer a deterministic failure scenario in an automated runner loop and demonstrate that robust autonomous systems must implement bounded retries and graceful escalation rather than retrying indefinitely upon encountering unsolvable failures.

---

## Failure Scenario
To create a predictable and measurable failure condition:
- **Missing Input:** The prompt and runner intentionally requested operations against `nonexistent-file.md`, an artifact that does not exist in the working directory.
- **Objective Success Condition:** The harness defined success strictly by the creation and presence of an objective artifact: `required-success.md`.
- **Deliberate Failure Constraint:** Because `required-success.md` was never created during the runs, the objective success check consistently evaluated to `False`.

---

## Loop Design
The execution loop follows a strict bounded lifecycle:

```text
   RUN
    ↓
   FAIL
    ↓
LOG FAILURE
    ↓
SAVE STATE
    ↓
CHECK LIMIT
    ↓
   STOP
    ↓
NEEDS HUMAN
```

---

## Implementation
The bounded retry logic is implemented in `run_failure_test.ps1`:

- **Maximum Attempts:** Configured to a hard boundary of `$maxAttempts = 3`.
- **Deterministic Success Detection:** Uses PowerShell's `Test-Path .\required-success.md` to objectively evaluate whether the required success artifact exists.
- **Persistent Logging:** On every failed attempt, the script appends a timestamped `FAILURE` entry directly to `progress.md`.
- **Bounded Exit & Escalation:** Once the attempt counter exceeds the limit (3 failed attempts), the loop terminates, appends a `NEEDS HUMAN` marker to `progress.md`, and exits with return code `1`.
- **No Infinite Loops:** Eliminates unbounded `while($true)` constructs in favor of a strictly bounded `for` loop with explicit termination and state persistence.

### Script Definition (`run_failure_test.ps1`):
```powershell
Set-Location $PSScriptRoot

$maxAttempts = 3
$successFile = ".\required-success.md"

for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "ATTEMPT $attempt/$maxAttempts"

    claude -p "Read nonexistent-file.md. Do not create required-success.md. Report what you find and stop." --allowedTools "Edit,Write"

    if (Test-Path $successFile) {
        Add-Content .\progress.md "`n## $timestamp`nSUCCESS: Required artifact was created on attempt $attempt."
        Write-Host "SUCCESS"
        exit 0
    }

    Add-Content .\progress.md "`n## $timestamp`nFAILURE: Attempt $attempt/$maxAttempts failed because required-success.md was not created."
    Write-Host "FAILURE: required-success.md not found"
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content .\progress.md "`n## $timestamp`nNEEDS HUMAN: Maximum attempts ($maxAttempts) reached. Loop stopped to prevent unbounded retries."
Write-Host "NEEDS HUMAN: maximum attempts reached"
exit 1
```

---

## Experiment Results

The experiment ran through the full bounded failure cycle with the following verified execution path:

| Stage | Action / Check | Outcome | Status |
|---|---|---|---|
| Attempt 1/3 | Check `required-success.md` | Missing | `FAILURE` logged to `progress.md` |
| Attempt 2/3 | Check `required-success.md` | Missing | `FAILURE` logged to `progress.md` |
| Attempt 3/3 | Check `required-success.md` | Missing | `FAILURE` logged to `progress.md` |
| Limit Reached | Check `$attempt -gt $maxAttempts` | Threshold reached (3) | `NEEDS HUMAN` logged; loop stopped |

### Verified Experiment Metrics:
- **`required-success.md` Status:** Remained absent throughout all attempts.
- **Total Failed Attempts:** `3`
- **Human Escalation Count:** `1` (`NEEDS HUMAN` triggered)
- **Final Exit Code:** `1`

---

## Evidence
All failure cycles and status transitions are recorded with exact timestamps in `progress.md`:

```markdown
## 2026-09-04 17:10:29
FAILURE: Attempt 1/3 failed because required-success.md was not created.

## 2026-09-04 17:11:10
FAILURE: Attempt 2/3 failed because required-success.md was not created.

## 2026-09-04 17:11:40
FAILURE: Attempt 3/3 failed because required-success.md was not created.

## 2026-09-04 17:12:14
NEEDS HUMAN: Maximum attempts (3) reached. Loop stopped to prevent unbounded retries.
```

By persisting timestamps, attempt counts, and specific failure reasons to disk, engineers can fully diagnose failure causes and review escalation history post-mortem without needing to re-run failing workflows.

---

## Normal vs Sabotaged Runner

Two standalone runners were created to separate working baseline logic from deliberate failure scenarios:

- **`run_brief.normal.ps1` (Preserved Normal Version):**
  Reads `progress.md`, checks git commits from the last 24 hours, scans codebase TODOs, and appends genuine summary updates.
- **`run_brief.ps1` (Intentionally Sabotaged Version):**
  Altered to attempt reading `nonexistent-file.md` to trigger deliberate file-resolution failures during automation testing.

---

## Key Lesson

Autonomous execution agents and automated scripts must never assume transient success will resolve fundamental, deterministic blockers.

```text
BAD:
FAIL → RETRY → RETRY → RETRY → ... (Infinite loop, wasted tokens/compute, silent hangs)

GOOD:
FAIL → LOG → CHECK LIMIT → NEEDS HUMAN → STOP (Deterministic limit, persisted state, operator alert)
```

---

## Git Checkpoints
The implementation and baseline verification were committed under:
- `2e916bc` — *Project7 task2: add failure experiment baseline*
- `b376bba` — *Project7 task2: bounded failure and human escalation*

---

## How to Run

To run the bounded failure experiment, execute the following PowerShell script from this directory:

```powershell
.\run_failure_test.ps1
```

> **Note:** An exit code of `1` is **EXPECTED** and correct for this intentional failure experiment, representing clean termination and successful escalation to human intervention after exhausting the retry threshold.

---

## Safety / Scope
- The experiment is strictly isolated inside `project7-break-it-on-purpose/task2`.
- No unrelated working files or uncommitted modifications from Project 3 or other directories were included in the task commits or affected by the runner scripts.

---

## Conclusion
This experiment demonstrates that building resilient autonomous agent loops requires:
1. **Bounded retries:** Hard ceilings on loop attempts to prevent runaway processes and resource exhaustion.
2. **Deterministic verification:** Evaluating success using concrete filesystem/artifact assertions rather than unvalidated assumptions.
3. **Evidence preservation:** Logging structured failure data with timestamps for post-incident debugging.
4. **Graceful escalation:** Yielding control via clear signaling (`NEEDS HUMAN`) and non-zero exit codes when autonomous resolution is not possible.
