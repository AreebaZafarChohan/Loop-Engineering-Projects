# Project 8: Daily Loop Engineering — Capstone Overview

Welcome to **Project 8: Daily Loop Engineering**. This project represents the comprehensive capstone integration of autonomous **Loop Engineering** principles applied to real-world, recurring software maintenance chores.

Both subprojects (**Task 1** and **Task 2**) implement complete, production-grade autonomous loops incorporating the fundamental building blocks of loop engineering: **Heartbeat**, **Worktree Isolation**, **Skill**, **Maker-Checker**, **Connector**, **Spine (Audit Trail)**, **Budget Guards**, and **Human Understanding Checkpoints (Concept 15)**.

---

## 📁 Repository & Project Structure

```text
project8-daily-loop/
├── README.md               # Root Capstone documentation (this file)
├── task1/                  # Task 1: Autonomous Daily Lint Sweep
│   ├── .claude/skills/     # Domain skill for ESLint safe repair & review rules
│   ├── daily_lint_loop.ps1 # Orchestration script with worktree, maker-checker & PR connector
│   ├── run_wrapper.bat     # Windows Task Scheduler wrapper
│   ├── progress.md         # Persistent spine / execution audit log
│   ├── run.log             # Detailed execution log
│   └── README.md           # Task 1 comprehensive architecture & lab record
└── task2/                  # Task 2: Documentation Freshness Loop
    ├── .claude/skills/     # Domain skill for doc inspection & verification
    ├── docs/               # Synchronized markdown documentation
    ├── loop/               # Orchestration scripts (heartbeat, connector, maker, checker, scheduler)
    ├── src/                # Implementation source code under test
    ├── human_review.md     # Concept 15 human review gate (never auto-approves)
    ├── opencode.json       # Sandbox permissions & model configuration
    └── README.md           # Task 2 comprehensive architecture & lab record
```

---

## 🚀 Tasks Overview & Comparison

| Dimension | **Task 1: Daily Lint Sweep** | **Task 2: Documentation Freshness Loop** |
| :--- | :--- | :--- |
| **Chore Target** | Automated static code analysis & ESLint repair (`calc.js`, `greet.js`) | Continuous documentation synchronization against exported APIs (`calculator.js` $\leftrightarrow$ `calculator.md`) |
| **Heartbeat Trigger** | Windows Task Scheduler (`run_wrapper.bat`) / Daily 9:00 AM | Windows Task Scheduler (`scheduler_wrapper.ps1` $\rightarrow$ `heartbeat.ps1`) / Daily 9:00 AM |
| **Worktree Isolation** | Dynamic Git worktrees created per run (`lint-sweep/yyyy-MM-dd-HHmmss`) | Dedicated Git worktree branch (`project8-task2-loop`) |
| **Skill Definition** | `daily-lint-sweep/SKILL.md` (Safe ESLint syntax fix guidelines & reviewer criteria) | `doc-freshness/SKILL.md` (API inspection, doc-only edit rules, truth verification) |
| **Maker Agent** | Claude agent in worktree applying minimal, non-destructive syntax fixes | OpenCode agent (`mimo-v2.5-free`) scoped exclusively to `docs/**` |
| **Checker Agent** | Independent Claude agent re-running `npm run lint` and analyzing diffs | Independent read-only OpenCode agent verifying documentation completeness & correctness |
| **Connector** | GitHub CLI (`gh pr create`) pushing branch and opening PR on PASS | Git status & environment pre-flight validator (`connector.ps1`) |
| **Spine & Audit** | Persistent `progress.md` and `run.log` | Persistent `loop/progress.md` append-only ledger |
| **Budget Guards** | Date-based skip check preventing duplicate runs per day | Bounded retry loop (`$MaxAttempts = 3`) preventing API runaway |
| **Safety / Governance** | Human PR review discipline before merge; battery-aware scheduler config | Git-native Source Integrity (`git diff --quiet`) & Human Review Checkpoint (`human_review.md`) |

---

## 🛠️ Detailed Task Descriptions

### 🔹 [Task 1: Daily Lint Sweep](./task1/README.md)
Task 1 implements an autonomous daily chore that checks the codebase for common lint errors (e.g., `no-var`, `no-unused-vars`, `prefer-const`, `eqeqeq`), creates a throwaway isolated git worktree, repairs issues using safe heuristics defined in `SKILL.md`, verifies the fix with an independent Checker agent, opens a GitHub Pull Request via `gh pr create`, logs history to `progress.md`, and cleans up after itself.

* **Key File**: `task1/daily_lint_loop.ps1`
* **Full Documentation**: See [Task 1 README](./task1/README.md)

---

### 🔹 [Task 2: Documentation Freshness Loop](./task2/README.md)
Task 2 automates the prevention of documentation decay. When developers add or modify public exported functions in `src/`, the freshness loop automatically inspects the exports, invokes a sandboxed Maker agent to update `docs/`, enforces an immutable Source Integrity guard (verifying `src/` was never touched), verifies correctness via a read-only Checker agent, records attempt history in the spine, and updates a human sign-off checkpoint (`human_review.md`).

* **Key File**: `task2/loop/run_loop.ps1`
* **Full Documentation**: See [Task 2 README](./task2/README.md)

---

## 🛡️ Core Loop Engineering Principles Applied

1. **Autonomous Heartbeat**: Idempotent, scheduled triggers without human initiation.
2. **Strict Isolation**: Using Git worktrees to guarantee zero blast radius on the default `main` branch.
3. **Maker-Checker Dual Agent Model**: Segregating write operations from adversarial, read-only verification to eliminate self-confirmation bias.
4. **Persistent Spine**: Durable cross-session memory tracking timestamps, verdicts, and failure reasons.
5. **Runtime Budget Guards**: Hard boundaries preventing runaway retry loops or duplicate daily executions.
6. **Concept 15 (Human Understanding)**: Automation assists engineers; it does not replace human governance. All changes require human review or PR inspection before production deployment.
