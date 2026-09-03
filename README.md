# 🔄 Loop Engineering Monorepo

Welcome to the **Loop Engineering Monorepo** — a comprehensive suite of practical, production-ready engineering patterns for **Autonomous AI Agents**, **Feedback Loops**, **Maker-Checker Architectures**, and **Scheduled Unattended Automation** using tools like Claude CLI, Python, Node.js, and Git.

---

## 📚 Table of Contents
- [Repository Overview](#-repository-overview)
- [Projects Breakdown](#-projects-breakdown)
  - [Project 1: Watch Loop](#1-project-1-watch-loop)
  - [Project 2: Fix-Loop & Agentic Feedback Loops](#2-project-2-fix-loop--agentic-feedback-loops)
  - [Project 3: Morning Brief (The Spine & Unattended Schedule)](#3-project-3-morning-brief-the-spine--unattended-schedule)
  - [Project 4: Review Loop (Maker-Checker & Git Worktrees)](#4-project-4-review-loop-maker-checker--git-worktrees)
- [Core Engineering Concepts Demonstrated](#-core-engineering-concepts-demonstrated)
- [Tech Stack & Tooling](#-tech-stack--tooling)
- [Getting Started](#-getting-started)

---

## 🎯 Repository Overview

This repository captures key design patterns for building robust, deterministic, and self-healing agentic workflows:

```text
Loop-Engineering/
├── project1-watch-loop/        # In-session polling loops for long-running tasks
├── project2-fix-loop/          # Bounded iterative fix loops with test-driven checkers
├── project3-morning-brief/     # State persistence across runs via The Spine Pattern
├── project4-review-loop/       # Multi-agent Maker-Checker review loops in Git Worktrees
├── .gitignore                  # Clean repository ignores (Node, Python, Caches)
└── README.md                   # Monorepo Master Documentation
```

---

## 🚀 Projects Breakdown

### 1. [Project 1: Watch Loop](./project1-watch-loop/README.md)
* **Core Concept**: *Concept 4 — In-Session Watch Loop*
* **Difficulty**: Easy
* **Motive**: Eliminates manual terminal babysitting for long asynchronous background jobs.
* **Key Implementations**:
  - **Task 1 (Python)**: `long_task.py` simulates background processing while `watch_loop.py` polls and alerts immediately upon detecting `output.txt`.
  - **Task 2 (Bash / CLI)**: `long_task.sh` executes for 3 minutes in the background, monitored cleanly via in-session CLI loops checking for `done.txt`.

---

### 2. [Project 2: Fix-Loop & Agentic Feedback Loops](./project2-fix-loop/README.md)
* **Core Concepts**: *Concept 5 (Conditional Loops)*, *Concept 11 (Maker-Checker Pattern)*
* **Difficulty**: Medium
* **Motive**: Replaces self-approving LLMs with deterministic test runners acting as ground truth checkers.
* **Key Implementations**:
  - **Task 1 (Python / Pytest)**: `fix-loop.ps1` orchestrates headless Claude CLI (`claude -p`) over `student_result.py` with bounded attempts (max 6).
  - **Task 2 (Node.js / Jest)**: Standard Jest test-driven baseline.
  - **Task 3 (Multi-Bug Iterative Fix)**: Multi-defect repair in `calc.js` resolving divide-by-zero, parity, and factorial edge cases.

---

### 3. [Project 3: Morning Brief (The Spine & Unattended Schedule)](./project3-morning-brief/README.md)
* **Core Concepts**: *Concept 6 (Unattended Schedule)*, *Concept 12 (The Spine Pattern)*
* **Difficulty**: Medium
* **Motive**: Solves **Agent Amnesia** in recurring scheduled runs by maintaining persistent state in `progress.md`.
* **Key Implementations**:
  - **Task 1 (Interactive / Prompt-driven)**: JavaScript codebase scanning for `TODO` comments using LLM contextual deduplication.
  - **Task 2 (Programmatic Python CLI)**: Pure Python AST/line scanner (`gather.py` & `brief.py`) calculating diffs with zero token overhead.
  - **Task 3 (Headless Claude CLI Agent)**: Unattended shell/PowerShell scripts (`run_brief.sh` / `run_brief.ps1`) ingesting git commit history and TODOs with restricted tool execution.

---

### 4. [Project 4: Review Loop (Maker-Checker & Git Worktrees)](./project4-review-loop/task2/README.md)
* **Core Concepts**: *Maker-Checker Architecture*, *Git Worktree Isolation*, *Claude Code Skills*
* **Difficulty**: Advanced
* **Motive**: Protects the production branch through isolated experimentation and adversarial peer reviews.
* **Key Implementations**:
  - **Claude Code Skill (`student-grade-fix`)**: Standard Operating Procedure (SOP) guiding the Maker agent to fix grade boundary defects without tampering with tests.
  - **Git Worktree Isolation**: Safely branch into temporary worktrees (`fix/student-grade-boundaries`) and discard invalid iterations with zero main branch pollution.
  - **Adversarial Negative Testing**: Verified the reviewer agent issues a definitive `FAIL` on broken implementations and a `PASS` only on 100% compliant fixes.

---

## 🧠 Core Engineering Concepts Demonstrated

| Concept | Description | Project |
| :--- | :--- | :--- |
| **In-Session Polling** | Background polling loops that alert upon task completion and terminate cleanly. | [Project 1](./project1-watch-loop/README.md) |
| **Maker vs. Checker** | Separation of code generation (Maker) from deterministic evaluation (Checker). | [Project 2](./project2-fix-loop/README.md), [Project 4](./project4-review-loop/task2/README.md) |
| **Bounded Iteration** | Strict termination criteria (exit code 0 or max attempt thresholds) preventing infinite loops. | [Project 2](./project2-fix-loop/README.md) |
| **The Spine Pattern** | Using a structured, persistent artifact (`progress.md`) as external memory for stateless agents. | [Project 3](./project3-morning-brief/README.md) |
| **Unattended Execution** | Running autonomous batch CLI workflows via scripts without human intervention. | [Project 3](./project3-morning-brief/README.md) |
| **Git Worktrees** | Isolated filesystem work environments for safe AI code modifications. | [Project 4](./project4-review-loop/task2/README.md) |

---

## 🛠️ Tech Stack & Tooling

- **Languages**: Python 3.10+, JavaScript (Node.js / ES6+), PowerShell, Bash
- **Testing Frameworks**: `pytest`, `jest`
- **Agent Tooling**: Claude Code CLI (`claude -p`), Custom Claude Skills (`.claude/skills/`)
- **Version Control**: Git & Git Worktrees

---

## 🏁 Getting Started

Clone the repository:
```bash
git clone https://github.com/AreebaZafarChohan/Loop-Engineering-Projects.git
cd Loop-Engineering-Projects
```

Navigate to any project directory to explore individual task guides and instructions!
