# Project 7 — Break It on Purpose (Loop Engineering)

**Difficulty:** Medium  
**Core Concepts:** Observability, Concept 13 (Unit Economics / Cost Math), Concept 14 (Failure Handling, Bounded Retries & Human Escalation)

---

## 📖 Executive Summary

The objective of **Project 7** is to measure, stress-test, and intentionally sabotage an autonomous agent loop (based on the Project 3 pattern). In production systems, unattended autonomous agents fail overnight—the key engineering goal is ensuring failures are **cheap**, **bounded**, **instantly diagnosable without replaying sessions**, and **loudly escalated to humans** instead of failing silently or entering infinite retry loops.

This project proves three core criteria:
1. **Accurate Cost Projection (Concept 13):** Measuring a single beat in tokens/cost and extrapolating monthly operating expenses across operational cadences.
2. **Instant Spine Diagnosis:** Diagnosing exactly what failed and when using only the spine (`run.log` / `progress.md`), without reading execution traces or replaying runs.
3. **Bounded Failure & Human Escalation (Concept 14):** Halting the loop deterministically at a maximum retry limit and leaving an explicit `"NEEDS HUMAN"` note when success conditions cannot be met.

---

## 📂 Project Structure

```text
project7-break-it-on-purpose/
├── README.md                          # Main Project 7 documentation (This file)
├── task1/                             # Task 1: Single-Beat Cost Math & Spine Failure Diagnosis
│   ├── README.md                      # Detailed Task 1 report and findings
│   ├── notes.md                       # Sample source notes with TODO markers
│   ├── progress.md                    # Spine tracking progress and error states
│   ├── run.log                        # Timestamped execution log
│   ├── run_brief.ps1                  # Baseline execution runner
│   └── run_brief_sabotaged.ps1        # Sabotaged runner (targets missing file)
└── task2/                             # Task 2: Bounded Retries & Human Escalation Harness
    ├── README.md                      # Detailed Task 2 report and escalation flow
    ├── app.js                         # Application source code
    ├── utils.js                       # Utility helper functions
    ├── progress.md                    # Bounded failure log tracking attempt cycles
    ├── run_brief.normal.ps1           # Normal working runner
    ├── run_brief.ps1                  # Sabotaged runner version
    └── run_failure_test.ps1           # Bounded runner script ($maxAttempts = 3 -> NEEDS HUMAN)
```

---

## 🔬 Task Breakdown

### Task 1: Measuring Beat Economics & Spine Observability
*Location: [`task1/`](./task1)*

1. **Measuring One Beat:** Executed the baseline loop using `--output-format json` to measure exact single-beat consumption:
   - **Input Tokens:** 79,870
   - **Output Tokens:** 769
   - **Cost per Beat:** ~$0.443 USD
2. **Concept 13 Math (Monthly Projections):**
   $$\text{Monthly Cost} = \text{Cost per Beat} \times \text{Cadence (runs/month)}$$
   - **Daily Run (30 beats/mo):** ~$13.20 / month
   - **Weekly Run (4 beats/mo):** ~$1.76 / month
3. **Intentional Sabotage:** Prompt redirected to `nonexistent-file.md`.
4. **Spine Diagnosis:**
   - `run.log` recorded exact timestamp: `[2026-09-04 20:42:04] Run completed`
   - `progress.md` recorded the failure: `ERROR: nonexistent-file.md not found — needs human review`
   - **Key Finding:** Identified that loose prompts can cause the agent to overwrite rather than append historical spine entries, revealing the need for explicit append-only guardrails.

---

### Task 2: Bounded Retries & Human Escalation Harness
*Location: [`task2/`](./task2)*

1. **Unsolvable Condition:** The agent was directed to perform tasks on a missing file with an objective condition requiring `required-success.md`.
2. **Bounded Lifecycle:** Built a bounded retry harness (`$maxAttempts = 3`) preventing runaway execution or infinite retry loops (`while($true)`):
   ```text
   RUN → FAIL → LOG FAILURE → SAVE STATE → CHECK LIMIT (≤3) → STOP → LOG "NEEDS HUMAN" (Exit 1)
   ```
3. **Verified Escalation Sequence (`progress.md`):**
   - `Attempt 1/3`: `FAILURE: Attempt 1/3 failed because required-success.md was not created.`
   - `Attempt 2/3`: `FAILURE: Attempt 2/3 failed because required-success.md was not created.`
   - `Attempt 3/3`: `FAILURE: Attempt 3/3 failed because required-success.md was not created.`
   - `Limit Reached`: `NEEDS HUMAN: Maximum attempts (3) reached. Loop stopped to prevent unbounded retries.`

---

## 🎯 Verification Criteria Checklist

| Requirement / Success Metric | Status | Evidence / Location |
| :--- | :---: | :--- |
| **1. Measured 1 beat (Tokens & Cost)** | ✅ Verified | Input: 79,870 tokens, Output: 769 tokens, Cost: $0.443 ([`task1/README.md`](./task1/README.md)) |
| **2. Calculated Monthly Cadence Cost** | ✅ Verified | Daily: ~$13.20/mo, Weekly: ~$1.76/mo ([`task1/README.md`](./task1/README.md)) |
| **3. Sabotaged execution on schedule** | ✅ Verified | Target missing file `nonexistent-file.md` ([`task1/run_brief_sabotaged.ps1`](./task1/run_brief_sabotaged.ps1)) |
| **4. Diagnosed from spine alone** | ✅ Verified | Timestamp from `run.log` + failure cause from `progress.md` |
| **5. "NEEDS HUMAN" escalation note** | ✅ Verified | Hard stop on 3 attempts with `NEEDS HUMAN` in [`task2/progress.md`](./task2/progress.md) |
| **6. No silent failures** | ✅ Verified | Non-zero exit code (`exit 1`) and explicit structured logs |

---

## 💡 Key Architectural Lessons

1. **Unit Economics First (Concept 13):** Measure the cost of one beat before setting an autonomous agent loose on a cron schedule. Unmonitored loops scale financial costs linearly with frequency.
2. **Spine Independence:** Observability artifacts (`run.log`, `progress.md`) must be structured and clear enough that on-call engineers can diagnose a 3:00 AM failure in under 10 seconds without inspecting raw context transcripts.
3. **Deterministic Hard Limits:** Never permit unbounded retry loops. When facing deterministic or unrecoverable blockers (missing credentials, absent files), autonomous systems must halt after a fixed limit ($N$ attempts) and escalate to human intervention.
