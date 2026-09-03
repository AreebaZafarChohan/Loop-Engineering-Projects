# Project 5: Codify the Body (Dynamic Workflows)

## 📌 Overview
**Project 5: Codify the Body** focuses on transitioning from interactive, manual maker-checker fix loops to **fully codified, autonomous, and reusable Dynamic Workflows**. 

By programming multi-agent orchestration logic into deterministic workflow scripts (`.claude/workflows/*.js`), Claude Code can autonomously fan out isolated subagents, explore candidate solutions or fix distinct bugs in parallel, run tests in ephemeral git worktrees, and pass diffs to independent reviewer agents for strict verification without human micro-management.

---

## 🗂️ Project Structure & Sub-Tasks

This repository is structured into two core demonstration tasks:

```text
project5-codify-body/
├── README.md                                  # Root Documentation (This file)
├── .claude/
│   └── workflows/
│       ├── fix-and-review-utils-bugs.js       # Task 1 Dynamic Workflow script
│       └── fix-and-review-student-grade.js    # Task 2 Dynamic Workflow script
│
├── task1/                                     # Task 1: Multi-Bug Parallel Fix & Review
│   ├── .claude/skills/fix-utils-bugs/SKILL.md
│   ├── utils.js                               # JavaScript functions containing 3 distinct bugs
│   ├── utils.test.js                          # Jest test suite for verification
│   └── README.md                              # Detailed Task 1 documentation
│
└── task2/                                     # Task 2: Multi-Candidate Strategy Exploration
    ├── .claude/skills/student-grade-fix/SKILL.md
    ├── src/
    │   ├── __init__.py
    │   └── student_result.py                  # Python grade calculation logic
    ├── tests/
    │   └── test_student_result.py             # Pytest test suite with anti-tampering verification
    ├── pytest.ini
    └── README.md                              # Detailed Task 2 documentation
```

---

## 🚀 Tasks Breakdown

### 1. [Task 1: Multi-Bug Parallel Fix & Review (`task1/`)](./task1/README.md)
- **Tech Stack**: Node.js, Jest, JavaScript.
- **Problem**: `utils.js` contained 3 independent bugs (`calculateDiscount`, `isPalindrome`, `average`).
- **Orchestration**: Spawns **6 subagents** in total (3 parallel Maker agents in isolated worktrees + 3 independent Reviewer agents).
- **Saved Command**: `/fix-and-review-utils-bugs`
- **Key Focus**: Parallel task decomposition, worktree isolation (`isolation: 'worktree'`), domain-specific skill enforcement (`SKILL.md`), and automated checklist grading.

### 2. [Task 2: Multi-Candidate Strategy Exploration (`task2/`)](./task2/README.md)
- **Tech Stack**: Python, Pytest.
- **Problem**: Implementing student grade boundaries across multiple diverse architectural strategies (`if/elif/else`, data-driven loop, independent logic).
- **Orchestration**: Spawns **6 subagents** (3 parallel candidate Makers + 3 independent Reviewers) to explore alternative solutions simultaneously.
- **Saved Command**: `/fix-and-review-student-grade`
- **Key Focus**: Multi-candidate strategy benchmarking, anti-tampering test integrity validation (`tests_modified: false`), and structured JSON schema reporting.

---

## 🧠 Core Concepts & Architectural Insights

### 1. Dynamic Workflows
Multi-agent pipelines are expressed as plain JavaScript scripts utilizing execution hooks:
- `pipeline(items, stage1, stage2, ...)`: Default continuous execution without unnecessary synchronization barriers.
- `parallel(thunks)`: Concurrently runs tasks where aggregation or dedup is required.
- `agent(prompt, options)`: Spawns subagents with structured output schemas and execution options.
- `phase(title)` & `log(msg)`: Real-time progress monitoring and narration.

### 2. Worktree Isolation (`isolation: 'worktree'`)
Running parallel subagents in ephemeral git worktrees prevents:
- Workspace file collisions and race conditions.
- Dirty working tree pollution during candidate experimentation.
- Unintended cross-agent code overwrites.

### 3. Maker-Checker Separation
Decoupling the creator (Maker) from the evaluator (Checker/Reviewer):
- **Maker Agent**: Modifies the source file, executes the test suite, and generates a clean diff.
- **Reviewer Agent**: Independently inspects the diff against strict criteria, verifies that tests were not tampered with, and outputs a structured `PASS` / `FAIL` verdict.

### 4. The Core Lesson: Engine (Body) vs. True Loop

A dynamic workflow represents the **Execution Engine (The Body)** of a system, but it is **not** a self-sustaining loop on its own:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                              TRUE LOOP                                 │
│                                                                        │
│   ┌───────────────────┐     reads/writes      ┌────────────────────┐   │
│   │     Heartbeat     │ ────────────────────► │       Spine        │   │
│   │ (/loop, cron, etc)│                       │   (progress.md)    │   │
│   └─────────┬─────────┘                       └────────┬───────────┘   │
│             │ triggers                                 │               │
│             ▼                                          ▼ tracks        │
│   ┌────────────────────────────────────────────────────────────────┐   │
│   │                    Execution Engine / Body                     │   │
│   │                 (Dynamic Workflow Script)                      │   │
│   │             [Maker Agents] ──► [Reviewer Agents]               │   │
│   └────────────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────────────┘
```

- **Stateless Nature**: Workflows have no persistent memory across sessions. Re-running a command in a fresh session starts completely from scratch.
- **Transforming to a True Loop requires**:
  1. **A Heartbeat**: A recurring scheduler/trigger (such as `/loop`, dynamic wakeups, or cron).
  2. **A Spine**: A persistent state tracker (like `progress.md` or a state database) to coordinate progress across successive iterations.

---

## 🛠️ Quick Execution Guide

You can run each codified workflow directly via Claude Code:

```bash
# To run Task 1 (JavaScript Utils Multi-Bug Fix & Review)
/fix-and-review-utils-bugs

# To run Task 2 (Python Student Grade Multi-Candidate Fix & Review)
/fix-and-review-student-grade
```
