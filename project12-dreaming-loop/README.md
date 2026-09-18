# Project 12: Dreaming Loop (Autonomous Meta-Improvement Engine)

## 1. Executive Summary & Concept

**Project 12 (Dreaming Loop)** implements an **evidence-first, autonomous meta-improvement engine** for long-running agentic systems. Inspired by biological sleep and memory consolidation ("dreaming"), the Dreaming Loop periodically analyzes historical execution logs from continuous agent loops, surfaces systemic recurring failure modes ($\ge 2$ occurrences), identifies obsolete or unexercised instructions, and safely synthesizes minimal, citation-backed rule patches through human-gated pull requests.

Traditional agent loops react locally to single-session failures. The Dreaming Loop introduces scheduled, non-reactive reflection across multiple historical runs:
> *"What failure mode repeatedly bypasses our guardrails across sessions, and what is the smallest, evidence-backed rule patch to eliminate it permanently?"*

---

## 2. Directory Structure

```text
project12-dreaming-loop/
├── README.md                      # Root documentation (this file)
├── task1/                         # Task 1: Meta-Improvement Loop over Project 8 Task 2
│   ├── .claude/skills/            # Dreaming loop skill definitions
│   ├── evidence/                  # Evidence artifacts (analysis.md, proposal.md)
│   ├── loop/                      # Execution harness (run-analysis.ps1)
│   ├── dreaming-state.md          # State cursor tracking last analyzed date
│   └── README.md                  # Comprehensive Task 1 documentation
└── task2/                         # Task 2: Meta-Improvement Loop over Project 8 Task 1
    ├── source-project8-task1/     # Isolated target artifacts (progress.md, SKILL.md, state)
    ├── run_dreaming_loop.txt      # Execution run transcript
    └── README.md                  # Comprehensive Task 2 documentation
```

---

## 3. High-Level Architecture & End-to-End Workflow

```text
+-------------------------------------------------------------------------------+
|                    Target System Execution History (Progress Log)             |
|          (Project 8 Task 2 doc-freshness / Project 8 Task 1 lint-sweep)       |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                        Dreaming State Cursor Check                            |
|             (Only analyze runs strictly after last analyzed date)             |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                      EVIDENCE & ANALYSIS PHASE                                |
|  - Parse execution history post-cursor                                        |
|  - Detect recurring failures (>= 2 occurrences with same root cause)          |
|  - Detect unexercised/obsolete rules across window                            |
|  - Generate evidence/analysis.md with strict run timestamps & citations       |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                          PROPOSAL & PATCH PHASE                               |
|  - Propose minimal, targeted patch (+1 rule addition, -1 rule deletion)       |
|  - Patch target SKILL.md on isolated branch (`claude/...`)                    |
|  - Advance dreaming-state.md cursor                                           |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                       INDEPENDENT CHECKER AUDIT                               |
|  - Separate context audits raw git diff & citation veracity                   |
|  - Verifies zero source code modification & strict evidence compliance        |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                    MANDATORY HUMAN GATE (PR Review & Merge)                   |
|  - No auto-merges or direct pushes to `main`                                  |
|  - Human reviews evidence, diff, and PR before applying to production         |
+-------------------------------------------------------------------------------+
```

---

## 4. Sub-Tasks Overview

### Task 1: Dreaming Loop over Documentation Freshness (Project 8 Task 2)
- **Target Subsystem**: `project8-daily-loop/task2/.claude/skills/doc-freshness/SKILL.md` and `loop/progress.md`.
- **Cursor Lifecycle**: Started at `2026-09-08`, advanced to `2026-09-16`.
- **Evidence-Based Rule Addition (+1)**:
  - *Citations*: `P12-FIXTURE-01` (2026-09-11) and `P12-FIXTURE-02` (2026-09-12).
  - *Observed Failure*: Checker rejected PR because newly exported functions in `src/` were missing in `docs/`.
  - *Patch*: Added an explicit pre-submission checklist requirement to verify all exported functions against `docs/`.
- **Evidence-Based Rule Deletion (-1)**:
  - *Citations*: `P12-FIXTURE-03` through `P12-FIXTURE-06` (2026-09-13 to 2026-09-16).
  - *Observed Behavior*: 0 style-related failures or interventions across the analysis window.
  - *Patch*: Removed redundant legacy guardrail `"Preserve existing documentation style."` to reduce instruction overhead.
- **Workflow & PR**: Multi-round review on PR `#7`, verified via independent checker and merged through a human gate.

### Task 2: Dreaming Loop over Daily Lint Sweep (Project 8 Task 1)
- **Target Subsystem**: `source-project8-task1/.claude/skills/daily-lint-sweep/SKILL.md` and `source-project8-task1/progress.md`.
- **Cursor Lifecycle**: Started at `2026-09-10`, advanced to `2026-09-15`.
- **Planted Failure Verification**:
  - *Citations*: Runs on `2026-09-11` (`no-unused-vars`) and `2026-09-12` (`eqeqeq`).
  - *Observed Failure*: Agent suppressed lint errors with `eslint-disable` comments instead of applying real code fixes.
  - *Patch*: Added Step 5 to Fix steps—proactively grep for and reject `eslint-disable` comments prior to commit.
- **Rule Deletion (-1)**:
  - *Citations*: All runs from `2026-09-08` through `2026-09-15`.
  - *Observed Behavior*: Zero `prefer-const` violations reported or exercised across all log entries.
  - *Patch*: Removed `prefer-const` rule as unexercised.
- **Safety**: Conducted on branch `claude/dreaming-loop-improvement` without touching `main` directly.

---

## 5. Core Safety Principles & Guardrails

1. **Strict Evidence Requirement**: Every rule modification (+1 addition or -1 deletion) must trace back to explicit historical timestamps and run IDs in `progress.md`. Speculative edits or uncited prompt changes are rejected.
2. **Never Directly Modify `main`**: All dreaming loop proposals operate strictly on isolated feature branches (`claude/...`) and open pull requests.
3. **Cursor State Tracking**: The `dreaming-state.md` cursor ensures runs prior to the last analyzed timestamp are ignored, preventing redundant analysis and proposal loops.
4. **Mandatory Human Gate**: Self-improving agents are structurally forbidden from merging their own rule proposals into production. A human must review the citations and approve the PR.
5. **Guardrail vs. Corrective Distiction**: Distinguishes between broad defensive guardrails and targeted corrective rules when considering instruction deletions.

---

## 6. How to Run

### Task 1 Analysis
```powershell
cd D:\Gemini_Cli\Agent-Factory-Book-Projects\Loop-Engineering\project12-dreaming-loop\task1
.\loop\run-analysis.ps1
```

### Task 2 Evidence & Transcripts
Refer to `task2/evidence/analysis.md` and `task2/run_dreaming_loop.txt` for the complete execution trace and validation logs.
