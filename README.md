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
  - [Project 5: Codify the Body (Dynamic Workflows)](#5-project-5-codify-the-body-dynamic-workflows)
  - [Project 6: Event-Driven Automated PR Review Loop](#6-project-6-event-driven-automated-pr-review-loop)
- [Core Engineering Concepts Demonstrated](#-core-engineering-concepts-demonstrated)
- [Comparison of Heartbeat Architectures](#-comparison-of-heartbeat-architectures)
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
├── project5-codify-body/       # Codified multi-agent dynamic workflows (.claude/workflows/)
├── project6-event-driven-review/ # Event-driven PR review heartbeat (GitHub Actions & OpenCode)
├── .github/workflows/          # CI/CD & automated event-driven PR review workflows
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

### 4. [Project 4: Review Loop (Maker-Checker & Git Worktrees)](./project4-review-loop/README.md)
* **Core Concepts**: *Concept 8 (Git Worktrees)*, *Concept 9 (Skills)*, *Concept 11 (Maker-Checker Pattern)*
* **Difficulty**: Advanced
* **Motive**: Protects the production branch through isolated experimentation and adversarial peer reviews.
* **Key Implementations**:
  - **Task 1 (JavaScript / Jest)**: E-commerce percentage discount fix with `.claude/skills/fix-discount/SKILL.md` and adversarial negative testing (detecting hardcoded cheats).
  - **Task 2 (Python / Pytest)**: Student grade boundary fix with `.claude/skills/student-grade-fix/SKILL.md` in temporary isolated worktrees (`fix/student-grade-boundaries`).

---

### 5. [Project 5: Codify the Body (Dynamic Workflows)](./project5-codify-body/README.md)
* **Core Concepts**: *Dynamic Workflows Interlude*, *Concept 8 (Worktree Isolation)*, *Concept 11 (Maker-Checker)*
* **Difficulty**: Advanced
* **Motive**: Transitions manual, interactive fix loops into codified, autonomous, and reusable JavaScript workflow scripts (`.claude/workflows/*.js`).
* **Key Implementations**:
  - **Task 1 (JavaScript / Jest — Multi-Bug Fix & Review)**: Spawns 6 subagents (3 parallel Makers in isolated worktrees + 3 independent Reviewers) via `/fix-and-review-utils-bugs` to resolve 3 distinct defects in `utils.js`.
  - **Task 2 (Python / Pytest — Multi-Candidate Exploration)**: Benchmarks 3 distinct architectural strategies in parallel for student grade calculation via `/fix-and-review-student-grade` with anti-tampering test validation.
  - **Architectural Insight**: Distinguishes between the **Execution Engine (The Body)** and a **True Loop** (which requires a Heartbeat + Persistent Spine).

---

### 6. [Project 6: Event-Driven Automated PR Review Loop](./project6-event-driven-review/README.md)
* **Core Concepts**: *Concept 7 (Event-Driven Heartbeat)*, *Concept 10 (Connectors & Integrations)*
* **Difficulty**: Advanced
* **Motive**: Replaces manual sessions and polling timers with an event-driven heartbeat that triggers autonomous AI code reviews reactively on GitHub Pull Request events.
* **Key Implementations**:
  - **Task 1 (Python Student Grade Review)**: OpenCode AI agent automatically reviews PRs modifying grading calculation, detects strict inequality boundary bugs (`average > 90`), and posts actionable feedback.
  - **Task 2 (JavaScript Array Utilities Review)**: Inspects PR diffs in `array-utils.js`, catches off-by-one upper bound errors (`> arr.length`) and missing null/undefined guards, and requests changes.
  - **GitHub Actions Integration (`.github/workflows/opencode.yml`)**: Continuous automated CI review pipeline powered by `anomalyco/opencode/github@latest`.

---

## 🧠 Core Engineering Concepts Demonstrated

| Concept | Description | Project |
| :--- | :--- | :--- |
| **In-Session Polling** | Background polling loops that alert upon task completion and terminate cleanly. | [Project 1](./project1-watch-loop/README.md) |
| **Maker vs. Checker** | Separation of code generation (Maker) from deterministic evaluation (Checker). | [Project 2](./project2-fix-loop/README.md), [Project 4](./project4-review-loop/README.md), [Project 5](./project5-codify-body/README.md) |
| **Bounded Iteration** | Strict termination criteria (exit code 0 or max attempt thresholds) preventing infinite loops. | [Project 2](./project2-fix-loop/README.md) |
| **The Spine Pattern** | Using a structured, persistent artifact (`progress.md`) as external memory for stateless agents. | [Project 3](./project3-morning-brief/README.md) |
| **Unattended Execution** | Running autonomous batch CLI workflows via scripts without human intervention. | [Project 3](./project3-morning-brief/README.md) |
| **Git Worktrees** | Isolated filesystem work environments (`isolation: 'worktree'`) for safe AI code modifications. | [Project 4](./project4-review-loop/README.md), [Project 5](./project5-codify-body/README.md) |
| **Dynamic Workflows** | Codified multi-agent orchestration pipelines using execution hooks (`pipeline`, `parallel`, `agent`). | [Project 5](./project5-codify-body/README.md) |
| **Event-Driven Heartbeat** | Triggering autonomous agent reviews reactively from Git/CI webhooks with zero idle cost. | [Project 6](./project6-event-driven-review/README.md) |
| **Connectors & Integrations** | Embedding AI capabilities directly into developer platforms (GitHub Actions, PR threads). | [Project 6](./project6-event-driven-review/README.md) |

---

## 💓 Comparison of Heartbeat Architectures

Across the engineering loop series, four distinct agent heartbeat patterns were established:

| Project | Heartbeat Type | Mechanism / Trigger | Use Case |
| :--- | :--- | :--- | :--- |
| **Project 1** | In-Session Heartbeat | Interactive loop within active CLI | Real-time interactive monitoring |
| **Project 2** | Conditional / Run-Until-Done | Loop until exit condition/tests pass | Automated bug-fixing & TDD |
| **Project 3** | Scheduled Heartbeat | Time-based periodic Cron / Scripts | Regular audits, standups & health checks |
| **Project 6** | Event-Driven Heartbeat | Reactive triggers from Git/PR events | Autonomous CI/CD PR reviews |

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
