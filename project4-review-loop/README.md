# Project 4 — Fix Loop with Reviewer (Maker-Checker Pattern)

A comprehensive exploration of the **Maker-Checker Review Loop** pattern using Claude Code, Git Worktrees, and Reusable Skills across multiple tech stacks (JavaScript/Node.js and Python/Pytest).

---

## 📋 Table of Contents

- [Overview](#overview)
- [Core Architecture: The Maker-Checker Pattern](#core-architecture-the-maker-checker-pattern)
- [Key Concepts Demonstrated](#key-concepts-demonstrated)
- [Task Breakdown](#task-breakdown)
  - [Task 1: JavaScript Discount Calculation Fix](#task-1-javascript-discount-calculation-fix)
  - [Task 2: Python Student Grade Boundary Fix](#task-2-python-student-grade-boundary-fix)
- [Comparative Summary Matrix](#comparative-summary-matrix)
- [The Importance of an Independent Checker](#the-importance-of-an-independent-checker)
- [Repository Structure](#repository-structure)
- [How to Run & Reproduce](#how-to-run--reproduce)

---

## 🎯 Overview

In autonomous software development, enabling an AI agent to write code and immediately merge it into main branches introduces significant risks:
- **Test Cheating / Hardcoding**: Agents may hardcode return values matching specific test parameters instead of writing generalized logic.
- **Test Suite Tampering**: Agents may alter or delete assertions in test files to achieve false passes.
- **Edge Case Regressions**: Passing simple test cases does not guarantee boundary condition correctness.

**Project 4** addresses these challenges by implementing an autonomous **Fix Loop with an Independent Reviewer (Maker-Checker)**:
1. **Maker Agent (Implementer)**: Operates in an isolated Git worktree, follows a dedicated skill specification, fixes source defects, and runs automated tests.
2. **Checker Agent (Reviewer)**: Operates independently in read-only mode, inspects the exact `git diff`, validates test suite immutability, verifies domain requirements against a checklist, runs tests for real, and issues a strict binary verdict: **`PASS`** or **`FAIL`**.
3. **Gated Integration**: Pull Requests and branch merges are granted **only on a verified PASS**.

---

## 🏗️ Core Architecture: The Maker-Checker Pattern

```
                       +---------------------------------+
                       |        Developer / System       |
                       +----------------+----------------+
                                        |
                                        v
                       +---------------------------------+
                       |      Create Git Worktree        |
                       | (Branch: fix/<task-name>)       |
                       +----------------+----------------+
                                        |
                                        v
                       +---------------------------------+
                       |           MAKER AGENT           |
                       |  - Reads SKILL.md Fix Rules     |
                       |  - Modifies implementation code |
                       |  - Runs local tests (pass/fail) |
                       |  - Commits changes to branch    |
                       +----------------+----------------+
                                        |
                                        v
                       +---------------------------------+
                       |        INDEPENDENT CHECKER      |
                       |  - Inspects `git diff`          |
                       |  - Validates test immutability  |
                       |  - Evaluates SKILL.md checklist |
                       |  - Independently runs tests     |
                       +----------------+----------------+
                                        |
                       +----------------+----------------+
                       |                                 |
                       v                                 v
             [ Verdict: PASS ]                 [ Verdict: FAIL ]
                       |                                 |
                       v                                 v
        +-----------------------------+   +-----------------------------+
        | Open PR / Merge to Main     |   | Reject Changes / Refactor   |
        | Clean up Worktree           |   | Remove Worktree (--force)   |
        +-----------------------------+   +-----------------------------+
```

---

## 💡 Key Concepts Demonstrated

| Concept | Description |
| :--- | :--- |
| **Concept 8 — Git Worktree (`git worktree`)** | Complete workspace and branch isolation, allowing the maker agent to experiment, modify, and test without touching or dirtying the primary repository working directory. |
| **Concept 9 — Skill (`SKILL.md`)** | Reusable domain-specific knowledge encoding fix steps, mathematical/business rules, anti-patterns (no test modification), and a reviewer checklist. |
| **Concept 11 — Maker-Checker Pattern** | Separation of concerns: Maker produces the fix; an independent, adversarial Checker validates code quality, test integrity, and specification compliance before merging. |

---

## 📂 Task Breakdown

---

### Task 1: JavaScript Discount Calculation Fix
- **Directory**: `project4-review-loop/task1/`
- **Tech Stack**: JavaScript (Node.js, Jest)
- **Skill**: `.claude/skills/fix-discount/SKILL.md`

#### 1. The Defect & Fix
- **Buggy Code**: `return price - percent;` (subtracted percentage as a flat amount).
- **Correct Logic**: `return price - (price * percent / 100);` (calculates proportional percentage discount).

#### 2. Maker & Checker Execution
- **Positive Path**:
  - Implementer fixed formula in `discount.js`.
  - Tests passed (2/2).
  - Reviewer checked diff, confirmed test suite was untouched, and confirmed general formula logic.
  - **Verdict**: **`PASS`** &rarr; [PR #1](https://github.com/AreebaZafarChohan/Loop-Engineering-Projects/pull/1) opened.
- **Negative Path (Adversarial Hardcoded Cheat)**:
  - Planted hardcoded branch: `if (price===100 && percent===10) return 90; ...`
  - Tests technically passed (2/2) by coincidence.
  - Reviewer inspected diff, detected hardcoded values violating `SKILL.md`, and issued **`FAIL`** (No PR opened).

---

### Task 2: Python Student Grade Boundary Fix
- **Directory**: `project4-review-loop/task2/`
- **Tech Stack**: Python (pytest)
- **Skill**: `.claude/skills/student-grade-fix/SKILL.md`

#### 1. The Defect & Fix
- **Buggy Code**: Strict inequality checks (`if average > 90: return "A"`, etc.), causing students on exact boundaries (90, 80, 70, 60) to receive lower grades (90 got 'B', 80 got 'C', etc.).
- **Correct Logic**: Inclusive inequality checks (`if average >= 90: return "A"`, etc.).

#### 2. Maker & Checker Execution
- **Positive Path**:
  - Implementer updated `src/student_result.py` with `>=` operators.
  - Tests passed (5/5).
  - Reviewer verified boundary rules against `SKILL.md` and confirmed test integrity.
  - **Verdict**: **`PASS`** &rarr; merged into base branch.
- **Negative Path (Incomplete Fix)**:
  - Planted broken fix missing grade boundary `D` (`average >= 60`).
  - Pytest failed for score 65; Reviewer detected missing logic and issued **`FAIL`**.

---

## 📊 Comparative Summary Matrix

| Attribute | Task 1 (`task1`) | Task 2 (`task2`) |
| :--- | :--- | :--- |
| **Language & Testing** | JavaScript (Node.js + Jest) | Python (Python 3 + pytest) |
| **Domain Problem** | E-commerce Percentage Discount | Academic Grade Boundaries |
| **Skill Name** | `fix-discount` | `student-grade-fix` |
| **Maker Worktree** | `fix/discount-formula` | `fix/student-grade-boundaries` |
| **Maker Action** | Fixed mathematical formula | Fixed inclusive boundary operators (`>=`) |
| **Reviewer PASS Criteria** | Correct formula + clean diff + real test pass | All 5 grade tiers covered + clean diff + pytest pass |
| **Adversarial Negative Test** | Hardcoded `if/else` lookup table (passing tests) | Missing boundary tier `D` (failing tests) |
| **Reviewer FAIL Result** | **`FAIL`** (Detected cheat despite test pass) | **`FAIL`** (Detected missing grade logic) |
| **Integration Action** | PR Opened on PASS | Merged into main on PASS |

---

## 🛡️ The Importance of an Independent Checker

The central finding across both tasks in Project 4 is that **automated test success is necessary, but not sufficient**:

1. **Test-Passing Cheats**: In Task 1, an agent was able to pass 100% of unit tests by writing hardcoded conditionals for known test inputs. A basic CI check or uncritical agent would have approved this code.
2. **Diff Verification**: The Checker agent inspected the actual AST/diff against `SKILL.md` requirements and caught that the implementation was not generalized.
3. **Test Immutability**: The Checker verified that the Maker agent did not alter test assertions (`git diff HEAD~1 HEAD -- tests/`) to make broken code pass.

---

## 📁 Repository Structure

```
project4-review-loop/
├── README.md                            # Main project overview (this file)
├── task1/                               # JavaScript Discount Task
│   ├── README.md                        # Detailed Task 1 documentation
│   ├── .claude/
│   │   └── skills/
│   │       └── fix-discount/
│   │           └── SKILL.md             # Skill with fix steps & reviewer checklist
│   ├── discount.js                      # Implementation file
│   ├── discount.test.js                 # Jest unit tests
│   └── package.json                     # NPM package configuration
└── task2/                               # Python Student Grade Task
    ├── README.md                        # Detailed Task 2 documentation
    ├── .claude/
    │   └── skills/
    │       └── student-grade-fix/
    │           └── SKILL.md             # Skill with grade rules & reviewer checklist
    ├── pytest.ini                       # Pytest configuration
    ├── src/
    │   ├── __init__.py
    │   └── student_result.py            # Grade calculation implementation
    └── tests/
        └── test_student_result.py       # Pytest unit tests
```

---

## 🚀 How to Run & Reproduce

### 1. Task 1 (JavaScript / Jest)
```bash
cd project4-review-loop/task1

# 1. Run tests to see initial failure
npm test

# 2. Work in an isolated worktree
git worktree add -b fix/discount-formula ../worktree-task1
cd ../worktree-task1

# 3. Apply formula fix in discount.js
# return price - (price * percent / 100);

# 4. Verify tests and commit
npm test
git add discount.js
git commit -m "fix(discount): apply correct percentage discount formula"

# 5. Run independent reviewer check
git diff HEAD~1 HEAD -- discount.js
npm test
```

### 2. Task 2 (Python / pytest)
```bash
cd project4-review-loop/task2

# 1. Run tests to see boundary failures
pytest

# 2. Work in an isolated worktree
git worktree add -b fix/student-grade ../worktree-task2
cd ../worktree-task2

# 3. Apply fix in src/student_result.py using '>=' comparisons

# 4. Verify tests and commit
pytest
git add src/student_result.py
git commit -m "fix(grades): use inclusive boundary operators"

# 5. Run independent reviewer check
git diff HEAD~1 HEAD -- src/student_result.py
pytest
```
