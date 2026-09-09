# Project 8: Daily Lint Loop — Capstone Project

## 1. Overview

This capstone project integrates all six fundamental building blocks of an autonomous **Loop Engineering** system—**Heartbeat**, **Worktree**, **Skill**, **Maker-Checker**, **Connector**, and **Spine**—alongside runtime **Budget Guards** into a real, boring, recurring engineering chore: an **automated daily lint sweep**.

Rather than relying on human intervention to manually trigger sweeps, review fixes, create branches, or record audit trails, this architecture runs autonomously on a scheduled trigger, ensures complete working directory isolation, executes standardized fix rules, validates code modifications with an independent checker agent, opens GitHub Pull Requests on passing verdicts, and tracks execution history in persistent audit logs.

---

## 2. The Six Parts, Mapped

The loop engineering architecture is mapped to concrete tools and system components as follows:

| Loop Component | Implementation & Role |
| :--- | :--- |
| **Heartbeat** | **Windows Task Scheduler**, scheduled to run automatically on a daily cadence at 9:00 AM. |
| **Worktree** | **Isolated Git Worktree** (`git worktree add`) created per run on a timestamped, unique branch (`lint-sweep/yyyy-MM-dd-HHmmss`). Guarantees zero pollution of the main branch and enables safe rollback. |
| **Skill** | **`SKILL.md`**, encoding domain-specific fix rules (ESLint best practices) and an explicit, verifiable reviewer rubric. |
| **Maker-Checker** | Dual-agent verification model: A **Maker Claude agent** inspects and fixes lint errors; an independent **Checker Claude agent** re-runs the linter, analyzes the diff, and issues a strict `PASS` or `FAIL` grade. |
| **Connector** | **GitHub CLI (`gh pr create`)**, automatically opening a Pull Request with reviewer notes against `main` when the checker issues a `PASS`. |
| **Spine** | **`progress.md`** & **`run.log`**, providing a persistent, durable audit log recording timestamps, branch references, execution details, and verdicts across sessions. |
| **Budget Guard** | Script-level check inspecting the spine (`progress.md`) at startup to gracefully skip execution if a run has already completed today. |

---

## 3. The Chore Being Automated

In everyday software maintenance, static analysis rules frequently detect minor code smells, syntax inconsistencies, and anti-patterns. In this Node.js repository (`calc.js`, `greet.js`), the daily chore resolves common ESLint rules:

* `no-var`: Replacing legacy `var` declarations with scoped `let` or `const`.
* `no-unused-vars`: Safely cleaning up dead or unreferenced variables.
* `prefer-const`: Converting `let` declarations to `const` when variables are never reassigned.
* `eqeqeq`: Enforcing type-safe strict equality (`===` and `!==`) over loose equality (`==` and `!=`).

---

## 4. The Skill (`SKILL.md`)

The skill file defines explicit boundaries to ensure automated changes are strictly safe, minimal, and non-destructive.

### Fix Rules & Steps
1. **Analyze:** Run `npm run lint` and read every reported error.
2. **Safe Replacement:** Apply minimal syntax repairs matching the specific rule (e.g., `var` $\rightarrow$ `let`/`const`, `==` $\rightarrow$ `===`).
3. **Preserve Behavior:** Never alter existing function contracts, inputs, outputs, or runtime semantics.
4. **Verification:** Re-run `npm run lint` locally to confirm zero errors remain.
5. **Standard Commit:** Commit the changes with an automated message format: `"lint: fix N issues (automated sweep)"`.

### Reviewer Checklist (PASS / FAIL)
The independent Checker agent evaluates the candidate fix against strict criteria:
* Does `npm run lint` report **zero errors** when executed independently?
* Was any function's logic, control flow, or runtime behavior modified beyond safe styling?
* Were any lint rules disabled or suppressed via inline comments (e.g., `// eslint-disable-next-line`) instead of being genuinely fixed?
* **Verdict Decision:** If lint is not clean, logic was altered, or suppressions are detected, output **`FAIL`** with specific justifications. Output **`PASS`** only if the diff is minimal, safe, genuine, and verified.

---

## 5. The Automation Script (`daily_lint_loop.ps1`)

The core execution engine coordinates the full lifecycle of each loop iteration:

```
[Heartbeat Trigger]
         │
         ▼
[Budget Guard Check] ────── Already Ran Today? ─────► [Log Skip & Exit]
         │ No
         ▼
[Create Isolated Worktree & Branch]
         │
         ▼
[Install Dependencies (`npm install`)]
         │
         ▼
[Maker Agent: Read SKILL.md -> Fix Lint -> Commit]
         │
         ├─── Output == NOTHING_TO_FIX ─────────────► [Log No Issues & Exit]
         ▼
[Checker Agent: Independent Lint Run + Diff Review]
         │
         ├─── Verdict == FAIL ──────────────────────► [Log FAIL -> Human Alert]
         ▼ (PASS)
[Connector: Push Branch & `gh pr create`]
         │
         ▼
[Update Spine (`progress.md` & `run.log`)]
         │
         ▼
[Cleanup: Prune & Remove Worktree]
```

### Script Execution Logic:
1. **Budget Guard Evaluation:** Checks `progress.md` for today's date stamp. If present, appends a skip notice to `run.log` and terminates early.
2. **Worktree Isolation:** Cleans any stale paths, creates an isolated worktree folder (e.g., `D:\Gemini_Cli\lint-attempt-<date>`), and checks out a new branch (`lint-sweep/<date>-<time>`).
3. **Maker Execution:** Runs Claude in JSON output mode to read `SKILL.md`, repair lint errors in the worktree, and commit the diff.
4. **Maker-Checker Validation:** If fixes were committed, launches an isolated Checker Claude session to verify the diff and grade the patch.
5. **Connector Action:** Upon a `PASS` verdict, pushes the branch upstream and creates a GitHub Pull Request with `gh pr create`.
6. **Spine Persistence & Teardown:** Records the run outcome to `progress.md` and `run.log`, removes the worktree, and prunes git references.

---

## 6. Real Bugs Found and Fixed During Build-Out

During the engineering of this production-grade loop, several critical edge cases were discovered and resolved:

### Bug 1: Silent Worktree Creation Failure Causing Unsandboxed Execution
* **Issue:** A leftover, stale worktree folder caused `git worktree add` to fail. Because standard error was piped away without checking `$LASTEXITCODE`, the script fell back to the root directory, causing the Maker agent to commit modifications directly onto the `main` branch with zero isolation or review.
* **Fix & Lesson:** Added explicit `$LASTEXITCODE` validation immediately following worktree creation, combined with pre-cleanup steps (`Remove-Item` and `git worktree prune`) before initializing new runs. Never assume directory allocation succeeded.

### Bug 2: External Human Tooling Corrupting the Spine
* **Issue:** `progress.md` was accidentally wiped and saved with empty content because an external text editor retained a stale buffer and saved over the file after an automated run had already appended new records.
* **Fix & Lesson:** Spines can be corrupted by human editors and race conditions, not just internal loop failures. Spines must be resilient, validated regularly, and treated as persistent state files rather than casual working buffers.

### Bug 3: Silent Failure in Scheduled Runs Due to Battery Settings
* **Issue:** An unattended scheduled task registered `LastTaskResult: 0` (success) in Task Scheduler history, but performed zero work.
* **Diagnosis & Fix:** Diagnosed without session replays by comparing scheduled timestamps in `scheduler_debug.log` against entries in `progress.md`. The root cause was Windows Task Scheduler's default setting *"Stop if the computer switches to battery power / Do not start on battery"*. Fixed by explicitly registering the task with `-AllowStartIfOnBatteries`.

---

## 7. Results Table

| Date | Trigger | Verdict | PR / Action |
| :--- | :--- | :--- | :--- |
| **2026-09-08** | Manual test | **PASS** | [PR #5](https://github.com/AreebaZafarChohan/Loop-Engineering-Projects/pull/5) merged |
| **2026-09-08** | Manual test | **PASS** | [PR #6](https://github.com/AreebaZafarChohan/Loop-Engineering-Projects/pull/6) merged |
| **2026-09-09** | Scheduled (after battery fix) | **No issues found** | Clean state (`NOTHING_TO_FIX`), N/A |

---

## 8. Concept 15 — Keeping Up With the Loop

An automated loop is not an excuse for blind trust. Human oversight remains a vital safeguard:

* **Diff Review Discipline:** After every run where a PR is generated, the human engineer reads the exact diff and the checker's verdict before merging. We do not auto-merge purely because "the checker always passes."
* **Cadence Management:** The operational protocol follows a strict comprehension rule: review every generated PR closely for one week. If human understanding of the codebase begins to lag behind the volume or speed of automated modifications, immediately throttle the heartbeat cadence (e.g., from daily to weekly) until mental models and architectural comprehension catch up.

---

## 9. How to Reproduce

Follow these steps to deploy the daily lint loop in a new or existing repository:

1. **Set Up the Project & Linter:**
   Initialize your Node.js application and configure ESLint (`package.json`, `eslint.config.js`). Ensure `npm run lint` is defined in scripts.
2. **Define the Skill:**
   Create `.claude/skills/daily-lint-sweep/SKILL.md` containing specific fix rules, behavior invariants, and the Maker-Checker checklist.
3. **Configure the Orchestration Script:**
   Set up `daily_lint_loop.ps1` with worktree isolation, budget guard checks, maker/checker prompts, GitHub CLI connector calls, and spine appending.
4. **Register with Windows Task Scheduler:**
   Register the task or wrapper script (`run_wrapper.bat`), ensuring the task is configured to start on battery power:
   ```powershell
   $action = New-ScheduledTaskAction -Execute "D:\Gemini_Cli\Loop-Engineering\project8-daily-loop\task1\run_wrapper.bat"
   $trigger = New-ScheduledTaskTrigger -Daily -At 9am
   $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
   Register-ScheduledTask -TaskName "DailyLintSweep" -Action $action -Trigger $trigger -Settings $settings
   ```
5. **Verify and Monitor:**
   Let the scheduler trigger automatically or test manually, inspecting `progress.md`, `run.log`, and incoming GitHub PRs.

---

## 10. Engine vs Loop, Completed

Earlier workflows (such as Project 5's skill runner) acted as **engines**: stateless execution mechanisms that require manual human invocation and carry no memory between runs.

This Capstone represents a complete, true **Loop**:
* **Autonomous Heartbeat:** Executes reliably on a recurring schedule without human initiation.
* **Persistent Spine:** Retains cross-session memory (`progress.md`), enabling the system to evaluate past runs, avoid redundant work through budget guards, and maintain historical auditability.
