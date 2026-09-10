# Project 9 — Rehearse a Routine: Status vs Transcript

## Overview

This project explores the critical concept of **one-off routine execution** in agentic workflows, focusing specifically on **A5 Lesson: Green status vs. actual task success**. 

Across both tasks, we demonstrate why a "green" status (Exit Code 0) merely indicates that a session completed without an infrastructure crash—it does **not** guarantee that the agent logically completed the intended task.

---

## Project Structure

```
project9-rehearse-routine/
├── README.md                     # Main Project Overview & Comparative Analysis
├── task1/                        # Task 1: File-based Summary Experiment
│   ├── NOTES.md                  # Source notes file
│   ├── SUMMARY.md                # Output summary (Run 1 artifact)
│   ├── run-working.ps1           # Script for valid execution
│   ├── run-broken.ps1            # Script for intentionally failing execution
│   ├── transcript-working.log    # Transcript showing successful file read/write
│   ├── transcript-broken.log     # Transcript showing file-not-found error
│   ├── progress.md               # Detailed experiment record
│   └── README.md                 # Task 1 documentation
└── task2/                        # Task 2: Git Commit & Branching Experiment
    ├── app.js                    # Base project script
    ├── run1_transcript.txt       # Transcript of successful git summary task
    ├── run2_transcript.txt       # Transcript of failed non-existent file task
    └── README.md                 # Task 2 documentation
```

---

## Summary of Tasks

### [Task 1: File Processing Routine](./task1/README.md)
- **Goal:** Execute one-off prompts with OpenCode to summarize a local file (`NOTES.md`) vs. a non-existent file (`THIS_FILE_DOES_NOT_EXIST.md`).
- **Run 1 (Success):** Read `NOTES.md` and successfully generated `SUMMARY.md`. *(Exit Code: 0)*
- **Run 2 (Logical Failure):** Target file was missing; agent logged error and did not create `SUMMARY.md`. *(Exit Code: 0)*

### [Task 2: Git Log & Branching Routine](./task2/README.md)
- **Goal:** Execute one-off runs using `opencode run` to inspect git history, create a branch (`claude/summary`), and commit a summary vs. reading a missing file into a new branch (`claude/summary-2`).
- **Run 1 (Success):** Summarized the last 2 git commits, created `claude/summary`, and committed `SUMMARY.md`. *(Exit Code: 0)*
- **Run 2 (Logical Failure):** Attempted to read `this-file-does-not-exist.md`, reported inability to proceed, and aborted branch creation. *(Exit Code: 0)*

---

## Key Takeaway & Core Lesson (A5)

> **"Green means the session ended without an infrastructure error — nothing more."**

1. **Exit Code 0 is Not Proof of Success:** Both successful and logically failed runs exited with status code `0` across both tasks.
2. **Transcript as Source of Truth:** The full execution transcript and observable artifacts (e.g., created files, git branches, commits) must be inspected to verify actual task completion.
3. **Observable Evidence:** Trust in agentic systems is built on inspectable evidence rather than binary status indicators.
