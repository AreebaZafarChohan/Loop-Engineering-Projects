# Project 3: Morning Brief (The Spine & Unattended Schedule)

> **Difficulty**: Medium · **Concepts**: Concept 6 (Unattended Schedule), Concept 12 (The Spine Pattern)

---

## 📌 Project Overview & Objective

In autonomous systems and scheduled AI loops (daily standup summaries, codebase monitors, morning briefs, CI assistants), a major failure mode is **"Agent Amnesia"** — where each independent execution starts from zero, forgets past actions, and blindly repeats previously recorded items.

This project implements and evaluates **The Spine Pattern** (`progress.md`) across multiple programming paradigms and execution environments. A persistent state log file acts as the long-term memory ("spine"), ensuring each scheduled run reads previous state, gathers fresh changes (TODO comments, Git commit history), outputs high-signal summaries, and logs only incremental deltas.

### 🎯 Core Acceptance Criteria ("Done When")
1. **Run 1 (Baseline Run)**: The loop executes, reads `progress.md`, discovers existing TODOs/commits, generates a summary, and logs the baseline with the current date.
2. **Run 2 (Incremental Run)**: When run a second time after code changes, the loop reads the updated `progress.md`, gathers new changes, and **only logs the new items without repeating already recorded data**.

---

## 📂 Repository Structure & Task Implementations

This repository explores three distinct architectural implementations of the Morning Brief problem:

```text
project3-morning-brief/
├── README.md               # Master documentation & architectural comparison
├── task1/                  # Implementation 1: Interactive / Prompt-driven JS Spine Loop
│   ├── app.js              # JavaScript sample source with TODO comments
│   ├── utils.js            # JavaScript utility functions with TODO comments
│   ├── progress.md         # The persistent Spine tracking TODO deltas
│   └── README.md           # Task 1 documentation & verification logs
├── task2/                  # Implementation 2: Pure Python Programmatic Loop & CLI Runner
│   ├── app.py              # Python sample source with TODO comments
│   ├── gather.py           # AST/Line scanner module for extracting TODOs
│   ├── brief.py            # Core engine: Spine reader, delta calculator & updater
│   ├── run-brief.ps1       # Automated scheduled runner script (PowerShell)
│   ├── progress.md         # The persistent Spine tracking Python TODOs
│   └── README.md           # Task 2 documentation & execution instructions
└── task3/                  # Implementation 3: Headless CLI AI Agent (Claude CLI + Git + TODOs)
    ├── app.js              # JavaScript sample source with TODO comments
    ├── utils.js            # JavaScript utility functions with TODO comments
    ├── run_brief.sh        # Unattended bash script running headless Claude CLI
    ├── run_brief.ps1       # Unattended PowerShell script with strict tool permissions
    ├── progress.md         # The persistent Spine tracking Git commits & TODOs
    └── README.md           # Task 3 documentation & execution instructions
```

---

## 🏗️ Architectural Approaches Comparison

| Feature / Aspect | Task 1: Prompt-Driven Spine | Task 2: Programmatic Python Loop | Task 3: Headless Claude CLI Agent |
| :--- | :--- | :--- | :--- |
| **Language / Stack** | JavaScript, Markdown, LLM Prompting | Python 3, PowerShell | Shell / PowerShell, Claude CLI (`claude -p`) |
| **Data Gathered** | Codebase `TODO` comments | Python file `TODO` comments with lines | Git commits (last 24h) + `TODO` comments |
| **State File (Spine)** | `task1/progress.md` | `task2/progress.md` | `task3/progress.md` |
| **Deduplication Method** | LLM Contextual comparison | Deterministic string/line matching | LLM prompt instruction with tool restriction |
| **Execution Mode** | Interactive Session | Scheduled CLI (`run-brief.ps1`) | Scheduled Unattended (`run_brief.sh` / `.ps1`) |
| **Strengths** | Simple, flexible, zero build setup | Fast, deterministic, zero token cost | Rich contextual summaries, multi-source ingestion |

---

## 🧠 Key Concepts Explained

### 1. Concept 12: The Spine Pattern
- **Problem**: Stateless agent runs re-scan and report the entire codebase repeatedly, spamming teams with duplicate noise.
- **Solution**: A shared, append-only or versioned artifact (`progress.md`) acts as the external nervous system and memory. The agent or script reads the spine at entry, computes `diff = current_state - spine_state`, and records only the `diff`.

### 2. Concept 6: Unattended Schedule
- **Problem**: Autonomous tools must run without human intervention (via cron, Windows Task Scheduler, or CI pipelines).
- **Solution**: Encapsulating the run command into single-trigger scripts (`run-brief.ps1`, `run_brief.sh`) with defined tool permissions (`--allowedTools "Edit,Write"`) so the brief generates quietly in the background.

---

## 🚀 Quick Start & How to Run

### Task 1 (Interactive LLM Loop):
Open `task1/` and follow the prompt-based verification outlined in [`task1/README.md`](task1/README.md).

### Task 2 (Deterministic Python CLI):
```powershell
cd task2
# Run 1: Captures initial TODOs into progress.md
python brief.py

# Add a new TODO in task2/app.py, then trigger Run 2:
python brief.py
```
*(Or invoke via PowerShell: `.\run-brief.ps1`)*

### Task 3 (Unattended Claude CLI Agent):
```bash
# On Linux/macOS/Git Bash:
cd task3
chmod +x run_brief.sh
./run_brief.sh

# On Windows PowerShell:
cd task3
.\run_brief.ps1
```

---

## 📊 Summary of Results

All three implementations successfully proved the Spine Pattern:
- **Run 1**: Established baseline capture with accurate date stamps.
- **Run 2**: Ingested new code/commits and appended **only the delta updates** into `progress.md` without duplicating existing records.
