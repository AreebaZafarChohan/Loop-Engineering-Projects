# Project 4 (Task 2) — Review Loop with Real Checker

A robust implementation of an autonomous **Maker-Checker Review Loop** using Claude Code and Git Worktrees. This project demonstrates how to isolate code generation, enforce strict quality gates through automated testing, and conduct independent verification with a separate AI reviewer before integrating changes into the primary branch.

**Workspace Directory**: `D:\Gemini_Cli\Loop-Engineering\project4-review-loop\task2`

---

## Table of Contents

- [Overview](#overview)
- [What This Project Demonstrates](#what-this-project-demonstrates)
- [Architecture & Workflow](#architecture--workflow)
- [Repository & Task Structure](#repository--task-structure)
- [The Bug & Grade Requirements](#the-bug--grade-requirements)
  - [Grade Boundary Specification](#grade-boundary-specification)
  - [The Buggy Implementation](#the-buggy-implementation)
  - [The Correct Implementation](#the-correct-implementation)
- [Claude Code Skill (`student-grade-fix`)](#claude-code-skill-student-grade-fix)
- [Maker-Checker Execution Walkthrough](#maker-checker-execution-walkthrough)
  - [1. The Good Fix Workflow (Positive Path)](#1-the-good-fix-workflow-positive-path)
  - [2. The Deliberately Bad Fix Test (Negative Path)](#2-the-deliberately-bad-fix-test-negative-path)
- [Why the Independent Checker Matters](#why-the-independent-checker-matters)
- [Testing & Test Integrity](#testing--test-integrity)
- [Git Concepts Demonstrated](#git-concepts-demonstrated)
- [Claude Code Concepts Demonstrated](#claude-code-concepts-demonstrated)
- [Git History & Key Commits](#git-history--key-commits)
- [How to Run and Reproduce](#how-to-run-and-reproduce)
- [Current Final State](#current-final-state)

---

## Overview

In modern AI-assisted software engineering, letting an autonomous agent modify code and merge directly into production without oversight risks regressions, untested edge cases, and weakened test suites.

**Project 4 (Task 2)** implements a dual-agent **Maker-Checker Review Loop**:
1. **Maker Agent**: Works in an isolated Git worktree, follows a dedicated skill specification, fixes the source code bug, and validates with local automated tests (`pytest`).
2. **Reviewer Agent (Checker)**: Operates independently in read-only plan mode, inspects the exact `git diff`, validates that no tests were tampered with, checks that requirements are satisfied, verifies test outcomes, and issues a strict binary verdict: **`PASS`** or **`FAIL`**.
3. **Integration Gate**: Only solutions that receive a **`PASS`** from the independent reviewer are eligible for merge into the `master` branch.

---

## What This Project Demonstrates

1. **Reusable Claude Code Skill**: A standardized fix procedure encapsulated in `.claude/skills/student-grade-fix/SKILL.md`.
2. **Git Worktree Isolation**: Complete filesystem and branch isolation (`fix/student-grade-boundaries`) keeping the main working tree clean.
3. **Autonomous Maker Agent**: An agent that inspects failing tests, locates the defect, modifies *only* implementation code, runs tests, and commits the fix.
4. **Independent Reviewer (Checker)**: An agent running with `--permission-mode plan` that verifies code quality and requirement compliance without relying on the Maker's claims.
5. **Strict Binary Outcome**: The reviewer must explicitly conclude with `PASS` or `FAIL`.
6. **Positive Validation**: A fully correct fix receives a `PASS` and is safely integrated.
7. **Adversarial / Negative Testing**: A deliberately broken fix (`fix/bad-student-grade` missing boundary `D`) correctly triggers a `FAIL` verdict with detailed failure rationale.
8. **Test Immutability**: Strict enforcement that tests cannot be weakened, modified, or skipped to achieve a false pass.

---

## Architecture & Workflow

```
                        +---------------------------+
                        |      Developer / User     |
                        +-------------+-------------+
                                      |
                                      v
                        +---------------------------+
                        |   Git Worktree Creation   |
                        | (fix/student-grade-...)  |
                        +-------------+-------------+
                                      |
                                      v
                        +---------------------------+
                        |        MAKER AGENT        |
                        |   (claude -p / skill)     |
                        +-------------+-------------+
                                      |
                                      v
                        +---------------------------+
                        |   Modify Implementation   |
                        |  (src/student_result.py)  |
                        +-------------+-------------+
                                      |
                                      v
                        +---------------------------+
                        |    Run Automated Tests    |
                        |         (pytest)          |
                        +-------------+-------------+
                                      |
                                      v
                        +---------------------------+
                        |    INDEPENDENT CHECKER    |
                        |  (claude -p --mode plan)  |
                        |  • Review Git Diff        |
                        |  • Check Grade Rules      |
                        |  • Verify Test Integrity  |
                        |  • Run Test Suite         |
                        +-------------+-------------+
                                      |
                        +-------------+-------------+
                        |                           |
                        v                           v
                  [ Verdict: PASS ]           [ Verdict: FAIL ]
                        |                           |
                        v                           v
          +---------------------------+   +---------------------------+
          | Integrate into `master`   |   | Reject Changes            |
          | Clean up Worktree         |   | Remove Worktree (--force) |
          +---------------------------+   +---------------------------+
```

### Why Git Worktrees?
- **Isolation**: Changes occur in a separate working directory without switching branches or altering uncommitted files in the primary repository.
- **Safe Experimentation**: Broken or experimental agent attempts can be discarded instantly (`git worktree remove --force`) without polluting the main branch.
- **Concurrent Inspection**: Allows an external human or reviewer agent to examine the branch state in its dedicated directory.

### Why Independent Verification?
- The Maker agent may suffer from hallucinations, confirmation bias, or overlook subtle boundary specifications.
- Passing tests alone are not sufficient if tests are missing edge cases or if tests were altered by the Maker.
- The Checker provides defense-in-depth by re-evaluating the diff against the product requirements.

---

## Repository & Task Structure

Workspace root: `D:\Gemini_Cli\Loop-Engineering\project4-review-loop\task2`

```
task2/
├── README.md                            # Comprehensive project documentation
├── .claude/
│   └── skills/
│       └── student-grade-fix/
│           └── SKILL.md                 # Standardized Claude skill for fixing the bug
├── pytest.ini                           # Pytest configuration (pythonpath = .)
├── src/
│   ├── __init__.py
│   └── student_result.py                # Grade calculation implementation
└── tests/
    └── test_student_result.py           # Pytest unit tests for grade boundaries
```

---

## The Bug & Grade Requirements

### Grade Boundary Specification

The system calculates academic letter grades based on average student scores:

| Average Score Range | Expected Grade | Boundary Condition |
| :--- | :---: | :--- |
| **90 and above** | **A** | `average >= 90` |
| **80 to 89.99...** | **B** | `average >= 80` |
| **70 to 79.99...** | **C** | `average >= 70` |
| **60 to 69.99...** | **D** | `average >= 60` |
| **Below 60** | **F** | `average < 60` |

### The Buggy Implementation

In the original implementation (`a05d15d`), the comparison operators used strict greater-than (`>`) instead of greater-than-or-equal-to (`>=`):

```python
# BUGGY (src/student_result.py)
def calculate_grade(average):
    if average > 90:
        return "A"
    elif average > 80:
        return "B"
    elif average > 70:
        return "C"
    elif average > 60:
        return "D"
    else:
        return "F"
```

#### Why it Failed:
When exact boundary scores (`90`, `80`, `70`, `60`) were evaluated:
- `calculate_grade(90)`: `90 > 90` evaluated to `False`. The code evaluated `90 > 80` (`True`) and incorrectly returned **`"B"`** instead of **`"A"`**.
- `calculate_grade(80)`: fell through to `80 > 70` and returned **`"C"`**.
- `calculate_grade(70)`: fell through to `70 > 60` and returned **`"D"`**.
- `calculate_grade(60)`: fell through to `else` and returned **`"F"`**.

This caused 4 out of 5 tests in `tests/test_student_result.py` to fail.

### The Correct Implementation

The fix replaces all strict `>` comparisons with inclusive `>=` operators:

```python
# FIXED (src/student_result.py)
def calculate_grade(average):
    if average >= 90:
        return "A"
    elif average >= 80:
        return "B"
    elif average >= 70:
        return "C"
    elif average >= 60:
        return "D"
    else:
        return "F"
```

All boundary scores now return the expected letter grade.

---

## Claude Code Skill (`student-grade-fix`)

Located at `.claude/skills/student-grade-fix/SKILL.md` (within `task2`), this skill defines the exact contract and boundaries for the Maker agent:

- **Goal**: Fix student grade calculation in `src/student_result.py` without modifying tests.
- **Fix Procedure**:
  1. Inspect failing tests.
  2. Inspect `src/student_result.py`.
  3. Identify boundary comparison defects.
  4. Modify *only* the implementation file.
  5. Preserve test files without modification.
  6. Execute `pytest` and verify clean execution.
  7. Report exact modifications.
- **Hard Restrictions**:
  - Do not modify, weaken, skip, or bypass tests.
  - Do not alter `pytest.ini` to hide failures.
  - Success is only declared if `pytest` reports all tests passing.

---

## Maker-Checker Execution Walkthrough

### 1. The Good Fix Workflow (Positive Path)

```
[Master Branch] ──> [Worktree: fix/student-grade-boundaries]
                         │
                         ├── 1. Initial Test Run (Failing)
                         ├── 2. Maker Fixes src/student_result.py
                         ├── 3. Automated Test Run (5 Passed)
                         ├── 4. Commit: "Fix student grade boundaries"
                         ├── 5. Reviewer Verification (PASS)
                         │
[Master Branch] <── Merged & Integrated
```

1. **Worktree Creation**: An isolated branch and worktree were provisioned from repository root:
   ```powershell
   git worktree add -b fix/student-grade-boundaries worktrees/good-student-grade-fix master
   ```
2. **Skill Invocation / Maker Execution**: The Maker agent ran non-interactively in the worktree workspace:
   ```powershell
   claude -p "Apply the /student-grade-fix skill to fix the bug" --permission-mode acceptEdits
   ```
3. **Execution & Validation**:
   - The Maker diagnosed the strict `>` operator bug.
   - Modified only `src/student_result.py` to use `>=`.
   - Executed `pytest` -> **`5 passed in 1.05s`**.
   - Verified that `tests/test_student_result.py` remained untouched.
4. **Commit**:
   ```powershell
   git commit -m "Fix student grade boundaries"
   ```
5. **Independent Reviewer (Plan Mode)**:
   The Reviewer agent was executed in read-only plan mode:
   ```powershell
   claude -p "Review git diff against master, verify test suite and requirements, and output PASS or FAIL" --permission-mode plan
   ```
   - **Diff Inspected**: Confirmed only 4 lines changed in `src/student_result.py`.
   - **Test Immutability Checked**: Confirmed `tests/test_student_result.py` diff was empty.
   - **Requirements Verified**: Confirmed `90 -> A`, `80 -> B`, `70 -> C`, `60 -> D`, `<60 -> F`.
   - **Tests Run**: Confirmed `5 passed`.
   - **Verdict**: **`PASS`**.
6. **Integration**: The approved commit was merged into `master`, and the temporary worktree was cleanly removed.

---

### 2. The Deliberately Bad Fix Test (Negative Path)

To prove that the Checker is genuinely enforcing correctness rather than acting as a rubber stamp, an adversarial negative test was conducted.

```
[Master Branch] ──> [Worktree: fix/bad-student-grade]
                         │
                         ├── 1. Maker applies faulty fix (drops D branch)
                         ├── 2. Test Run: 1 Failed (60 -> F instead of D)
                         ├── 3. Reviewer Inspection: Detects missing requirement
                         │
                         └── Verdict: FAIL (Specific failure reasons logged)
                         │
[Worktree Removed] ──> Discarded with `git worktree remove --force`
```

1. **Bad Fix Worktree**:
   ```powershell
   git worktree add -b fix/bad-student-grade worktrees/bad-student-grade-fix master
   ```
2. **Defective Modification**: The `60+ -> D` branch was deliberately omitted from `src/student_result.py`:
   ```python
   def calculate_grade(average):
       if average >= 90:
           return "A"
       elif average >= 80:
           return "B"
       elif average >= 70:
           return "C"
       # OMITTED: elif average >= 60: return "D"
       else:
           return "F"
   ```
3. **Test Execution Result**:
   ```text
   FAILED tests/test_student_result.py::test_grade_d - AssertionError: assert 'F' == 'D'
   ======================== 1 failed, 4 passed in 0.08s ========================
   ```
4. **Checker Evaluation**:
   The Reviewer agent independently evaluated the worktree:
   - **Detected Missing Branch**: Noticed that scores between 60 and 69 fall through to `"F"`.
   - **Detected Test Failure**: Noticed that `test_grade_d` failed.
   - **Verdict**: **`FAIL`** with specific, actionable feedback explaining that the `D` boundary was missing.
5. **Teardown**: The defective branch and worktree were discarded:
   ```powershell
   git worktree remove --force worktrees/bad-student-grade-fix
   ```

---

## Why the Independent Checker Matters

| Quality Dimension | Without Checker | With Independent Checker |
| :--- | :--- | :--- |
| **Maker Hallucination** | Risk of accepting hallucinated completion | Checker re-runs and verifies independently |
| **Weakened Tests** | Maker might edit tests to force a green run | Checker checks `git diff tests/` for zero modifications |
| **Missing Requirements** | Subtly omitted logic might slip by | Checker validates logic against domain specifications |
| **Flaky / Soft Approvals** | High risk of false confidence | Strict requirement of binary `PASS` / `FAIL` |

---

## Testing & Test Integrity

The test suite in `tests/test_student_result.py` covers all critical boundary thresholds:

```python
from src.student_result import calculate_grade

def test_grade_a():
    assert calculate_grade(90) == "A"

def test_grade_b():
    assert calculate_grade(80) == "B"

def test_grade_c():
    assert calculate_grade(70) == "C"

def test_grade_d():
    assert calculate_grade(60) == "D"

def test_grade_f():
    assert calculate_grade(59) == "F"
```

### Pytest Execution Summary

- **Good Fix Output**:
  ```text
  collected 5 items
  tests\test_student_result.py .....                                       [100%]
  ============================== 5 passed in 1.05s ==============================
  ```
- **Deliberate Bad Fix Output**:
  ```text
  tests\test_student_result.py ...F.                                       [100%]
  ======================== 1 failed, 4 passed in 0.08s ========================
  ```

---

## Git Concepts Demonstrated

- **Git Worktrees (`git worktree add`, `git worktree remove`)**: Allows checking out multiple branches simultaneously in isolated directories.
- **Feature Branches (`fix/student-grade-boundaries`, `fix/bad-student-grade`)**: Dedicated branch lifecycles for isolated tasks.
- **Diff Inspection (`git diff master...HEAD`)**: Reviewing exact line modifications before staging.
- **Clean Workspace Management**: Ensuring generated runtime artifacts (`__pycache__`, `.pytest_cache`) do not pollute the repository.
- **Fast-Forward / Merge Integration**: Integrating verified commits into `master`.

---

## Claude Code Concepts Demonstrated

- **Claude Skills (`.claude/skills/`)**: Custom instructions and standard operating procedures loaded dynamically by Claude Code.
- **Role Separation**:
  - **Maker Agent**: Runs with `--permission-mode acceptEdits` to implement fixes and run tests.
  - **Reviewer Agent**: Runs with `--permission-mode plan` (read-only inspection mode) to review diffs and evaluate criteria without making unauthorized edits.
- **Non-Interactive Batch Mode (`claude -p "<prompt>"`)**: Scriptable execution suitable for automated CI/CD loops.

---

## Git History & Key Commits

The commit log reflects the intentional development and verification process:

```text
* 0405da8 (HEAD -> master, fix/bad-student-grade) Fix student grade boundaries
| * 2e7c2f9 (fix/student-grade-boundaries) Fix student grade boundaries
|/  
* 45545fe Add student grade fix skill
* a05d15d Add buggy student grade calculator
```

### Commit Breakdown:
1. `a05d15d` — **Add buggy student grade calculator**: Initial baseline containing the strict `>` operator bug and failing test suite.
2. `45545fe` — **Add student grade fix skill**: Introduces the `student-grade-fix` skill definition in `.claude/skills/`.
3. `2e7c2f9` — **Fix student grade boundaries**: The clean, verified fix produced on the `fix/student-grade-boundaries` worktree.
4. `0405da8` — **Fix student grade boundaries**: Integrated and verified commit on `master`.

---

## How to Run and Reproduce

### 1. Prerequisites
- Python 3.10+
- `pytest` installed (`pip install pytest`)
- Git

### 2. Verify Current Implementation
From `task2`:
```powershell
cd D:\Gemini_Cli\Loop-Engineering\project4-review-loop\task2
pytest
```
Expected output: `5 passed`.

### 3. Test with Claude Code Maker
```powershell
# Create an isolated worktree from repo root
cd D:\Gemini_Cli\Loop-Engineering\project4-review-loop
git worktree add -b fix/demo-fix worktrees/demo-fix master

# Run Maker in the worktree task2 directory
cd worktrees/demo-fix/task2
claude -p "Use the /student-grade-fix skill to fix any issues in src/student_result.py" --permission-mode acceptEdits

# Verify tests
pytest
```

### 4. Run Reviewer Check
```powershell
# Run Checker in read-only plan mode
claude -p "Review git diff against master, verify test suite and grade requirements, and output PASS or FAIL" --permission-mode plan
```

---

## Current Final State

- **Branch**: `master`
- **Location**: `D:\Gemini_Cli\Loop-Engineering\project4-review-loop\task2`
- **Status**: Working tree clean (`nothing to commit, working tree clean`)
- **Tests**: `5 passed` (100% test pass rate)
- **Worktrees**: All temporary worktrees have been cleaned up.
- **Integration**: The verified grade calculation fix is fully merged into `master`.
