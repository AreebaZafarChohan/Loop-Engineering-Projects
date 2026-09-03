# Project 5 Task 2 — Codify the Body

## Objective
The goal of this task is to take the fix-and-review body pattern from Project 4 Task 2 and codify it into a single, reusable, automated Claude Code dynamic workflow script instead of manually prompting each step across individual sessions.

---

## What the Workflow Does
With a single command invocation (`/fix-and-review-student-grade`), the dynamic workflow:
- **Launches 3 Candidate Implementations**: Explores multiple implementation strategies simultaneously.
- **Runs in Parallel**: Executes candidate pipelines concurrently using `pipeline()` and `agent()` execution hooks.
- **Provides Isolated Worktrees**: Grants each candidate an isolated git worktree (`isolation: 'worktree'`) to prevent file collisions and workspace race conditions.
- **Maker-Reviewer Separation**:
  - **Maker Agent**: Inspects the buggy function, applies the fix to `src/student_result.py`, and runs `pytest`.
  - **Reviewer Agent**: Independently inspects the git diff, checks test integrity, and runs `pytest` in the candidate's worktree.
- **Anti-Tampering Integrity Checks**: Verifies that tests were **not** modified, weakened, deleted, skipped, or bypassed.
- **Strict Verification & Structured Output**: Produces structured JSON output reporting `candidate_id`, `candidate_title`, `change_made`, `pytest_result`, `tests_modified`, and `reviewer_verdict` (`PASS`/`FAIL`).

---

## Candidates
The workflow explores 3 distinct implementation strategies against the standard grade boundaries:

1. **Candidate 1 — Standard Grade-Boundary Implementation**:
   - Classic branching structure (`if / elif / else`).
2. **Candidate 2 — Clean Alternative / Data-Driven Implementation**:
   - Tuple/list mapping (`GRADE_THRESHOLDS`) iterated in a loop for maintainability.
3. **Candidate 3 — Independent Attempted Implementation**:
   - Independent attempt evaluated strictly under reviewer scrutiny.

### Required Grade Boundaries:
- `90+` $\rightarrow$ **A**
- `80+` $\rightarrow$ **B**
- `70+` $\rightarrow$ **C**
- `60+` $\rightarrow$ **D**
- Below `60` $\rightarrow$ **F**

---

## Verification & Execution Results
The workflow was executed live and verified with the following results:

- **Total Agents**: 6 agents (3 Makers + 3 Reviewers)
- **Isolation**: 3 isolated git worktrees
- **Pytest Suite**: All 5 test cases in `tests/test_student_result.py` passed across all candidates
- **Test Integrity**: `tests_modified: false` confirmed for all candidates
- **Reviewer Verdicts**: `PASS` for all 3 candidates
- **Workflow Status**: Completed successfully with 0 errors

### Candidate Results Matrix

| Candidate | Strategy | Pytest Result | Tests Modified | Reviewer Verdict |
|:---|:---|:---:|:---:|:---:|
| **Candidate 1** | Standard `if/elif/else` | 5 passed (0.41s) | No (`false`) | **PASS** |
| **Candidate 2** | Data-driven tuple loop | 5 passed (1.70s) | No (`false`) | **PASS** |
| **Candidate 3** | Independent logic check | 5 passed (0.67s) | No (`false`) | **PASS** |

---

## Saved Command
The workflow is codified as a reusable command:
```bash
/fix-and-review-student-grade
```
- **Workflow File**: `.claude/workflows/fix-and-review-student-grade.js`
- **Reusability**: Can be invoked directly in future Claude Code sessions via `/fix-and-review-student-grade` or via `Workflow({ name: "fix-and-review-student-grade" })`.

---

## Engine vs Loop
A central architectural takeaway of this task is understanding the distinction between an **Engine (Body)** and a **True Autonomous Loop**:

- **The Workflow is an Engine / Body**: It contains all domain knowledge and orchestration logic of *HOW* to perform candidate generation, parallel execution, isolation, and review.
- **What It Lacks**: It does not automatically trigger itself on an external schedule (heartbeat), nor does it track or persist cross-session state (memory/progress file) between independent runs.

A **True Autonomous Loop** requires two additional components:
1. **Heartbeat / Scheduler**: An external timer or cron trigger (e.g., `/loop`, cron job, daemon) to wake up and execute the body periodically.
2. **Persistent Progress / State**: A durable file (e.g., `progress.md` or a state database) that records what tasks are pending, in-progress, or resolved across sessions.

---

## Fresh Session Experiment

Use this template to record verification in a clean session:

- **Fresh session started**: `[fill in date / time / session id]`
- **Workflow invoked**: `/fix-and-review-student-grade`
- **Previous run state remembered automatically**: `No`
- **What this proves**: The workflow operates purely as a stateless, deterministic execution body (engine). It reliably runs the pipeline on demand, but requires an external driver and persistent storage to achieve true loop behavior.

---

## Key Concepts Learned
- **Dynamic Workflows**: Authoring structured JavaScript workflow scripts using `pipeline()`, `parallel()`, `agent()`, and JSON schemas.
- **Parallel Fan-out**: Spawning concurrent agents to explore and test multiple solution candidates simultaneously.
- **Isolated Worktrees**: Running parallel agents inside ephemeral git worktrees (`isolation: 'worktree'`) to prevent file mutation conflicts.
- **Maker / Reviewer Separation**: Decoupling the agent that implements code changes from the agent that validates diffs and test results.
- **Structured Workflow Output**: Forcing validated schema outputs to produce predictable, typed candidate reports.
- **Reusable Slash Commands**: Exposing workflow scripts as first-class CLI commands in `.claude/workflows/`.
- **Engine vs Loop**: Distinguishing between an execution engine (the body) and a self-sustaining autonomous system (heartbeat + state).
- **Heartbeat & Persistent Progress**: Identifying the missing requirements needed to bridge an execution body into an autonomous loop.

---

## Project Structure
```text
project5-codify-body/task2/
├── .claude/
│   └── skills/
│       └── student-grade-fix/
│           └── SKILL.md
├── src/
│   └── student_result.py
├── tests/
│   └── test_student_result.py
└── README.md
```
*(Parent workflow definition located at `.claude/workflows/fix-and-review-student-grade.js`)*
