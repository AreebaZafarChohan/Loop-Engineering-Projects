# Task 3: Headless AI Agent Morning Brief (Git Commits + Code TODOs)

> **Focus**: Concept 6 (Unattended Schedule) & Concept 12 (The Spine Pattern) using Headless Claude CLI (`claude -p`)

---

## 🎯 Overview

Task 3 takes the Morning Brief concept to production-grade automation. It uses headless Claude Code (`claude -p`) wrapped in scheduled shell scripts (`run_brief.sh` and `run_brief.ps1`). 

Instead of only checking TODOs, the agent performs a multi-source intelligence brief:
1. Gathers Git commits created in the last 24 hours (`git log --since='1 day ago'`).
2. Scans the codebase for newly added `TODO` comments.
3. Compares all findings against the existing `progress.md` spine.
4. Generates an intelligent executive summary and logs only incremental deltas under a new dated entry.

---

## 📁 Files in this Folder

| File | Purpose |
| :--- | :--- |
| `app.js` | JavaScript application file with authentication functions and `TODO` comments. |
| `utils.js` | JavaScript utility functions containing `TODO` comments. |
| `run_brief.sh` | Bash script for unattended/cron execution invoking headless Claude CLI. |
| `run_brief.ps1` | PowerShell script for Windows unattended scheduling with scoped tool permissions (`--allowedTools "Edit,Write"`). |
| `progress.md` | The persistent state file (Spine) logging git commits, TODOs, and summaries. |
| `README.md` | Documentation and verification details for Task 3. |

---

## ⚙️ Unattended Runner Scripts

### 1. Bash Runner (`run_brief.sh`)
```bash
#!/bin/bash
cd "$(dirname "$0")"
claude -p "Read progress.md. Look at git log for commits from the last 24 hours (git log --since='1 day ago'). Also scan for any new TODO comments not already logged. Write a short summary and append a new dated entry to progress.md. Do not repeat anything already logged."
```

### 2. PowerShell Runner (`run_brief.ps1`)
```powershell
Set-Location $PSScriptRoot
claude -p "Read progress.md. Look at git log for commits from the last 24 hours (git log --since='1 day ago'). Also scan for any new TODO comments not already logged. Write a short summary and append a new dated entry to progress.md. Do not repeat anything already logged." --allowedTools "Edit,Write"
```

---

## 🛠️ Step-by-Step Verification & Results

### 1. Run 1 (Baseline Capture)
- **Git Commits Scanned**: `8d77a82`, `71c1d46`, `ae0ccf0`.
- **TODOs Scanned**: 4 items across `app.js` and `utils.js`.
- **Result in `progress.md`**: Created baseline entry under `## 2026-09-01` with an executive summary, list of recent commits, and open TODOs.

### 2. New Code & Commit Added
- Added new TODO comment in `app.js`: `// TODO: add cross origins`
- Committed changes: `git commit -m "Add rate limiting TODO"` (commit `35bba31`).

### 3. Run 2 (Delta-Only Autonomous Update)
- Invoked `run_brief.ps1` / `run_brief.sh`.
- The agent read `progress.md`, verified that `8d77a82`, `71c1d46`, and `ae0ccf0` were already recorded, and noticed that only commit `35bba31` and TODO `app.js:12` were new.
- Appended `## 2026-09-01 (Update)` recording **only the new commit and new TODO**.

---

## 📄 Final `progress.md` State

```markdown
# Progress Log

## 2026-09-01

### Summary
Initial project setup and scaffolding for authentication functions (`login`, `logout`) and utility functions (`sum`), along with morning brief automation scripts.

### Commits (Last 24 Hours)
- `8d77a82`: Add rate limiting TODO
- `71c1d46`: Initial setup with login and logout functions
- `ae0ccf0`: Initial project

### TODOs Found
- `app.js:1`: add input validation
- `app.js:3`: hash the password before saving
- `app.js:7`: write tests for logout
- `app.js:11`: add rate limiting to login
- `utils.js:1`: handle edge case when array is empty

## 2026-09-01 (Update)

### Summary
Added cross origins TODO comment to `app.js` and updated automation script permissions.

### Commits (Last 24 Hours)
- `35bba31`: Add rate limiting TODO

### TODOs Found
- `app.js:12`: add cross origins
```

---

## 💡 Key Lessons
- **Multi-Source Synthesis**: Combining Git logs with static source scanning gives a complete picture of project momentum.
- **Unattended AI**: Using `claude -p` with `--allowedTools` allows safe, non-interactive execution inside CI/CD or cron jobs.
- **True Spine Memory**: The second run did not restart from zero or duplicate previous commits/TODOs, proving the loop has durable memory.
