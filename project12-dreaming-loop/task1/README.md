# Project 12: Evidence-First Dreaming Loop

## 1. Title & Summary
Project 12 (Dreaming Loop) is an evidence-first, autonomous meta-improvement engine designed to analyze execution histories from continuous agent loops, detect systemic recurring failures and obsolete operational rules, and safely synthesize minimal, human-gated improvements back into the target system's core instructions without manual heuristic intervention.

---

## 2. Relationship to Project 8 (IMPORTANT — Architecture Context)
Project 12 does **not** operate as an isolated or standalone process. It functions strictly as a **meta-loop** built on top of the pre-existing **Project 8 (`project8-daily-loop`)**:

- **Pre-Existing Execution Spine**: Project 8's Task 2 already established a daily Maker/Checker loop governing documentation freshness (`project8-daily-loop/task2/.claude/skills/doc-freshness/SKILL.md`) and logging run outcomes to `project8-daily-loop/task2/loop/progress.md`.
- **Zero Synthetic Disconnect**: Project 12 does not manufacture artificial telemetry or run independent scratchpads; it ingests Project 8's real chronological progress spine as its primary source of truth.
- **Targeted Feedback Ingestion**: The sole objective of Project 12 is to inspect Project 8's historical operational log, identify verifiable patterns of repeated failure (occurring $\ge 2$ times) or demonstrably unexercised rules, and propose targeted, minimal rule patches directly back to Project 8's `SKILL.md`.
- **Self-Improving Architecture**: This architecture renders Project 8 self-improving over time without modifying any of Project 8's internal daily Maker/Checker operational mechanics or execution harnesses.

---

## 3. Motivation / Concept
Traditional agentic loops execute reactively: if a single run fails, the agent makes a local, ephemeral patch or retries within that immediate context. However, this misses systemic, multi-session deficiencies.

The **Dreaming Loop** introduces periodic, non-reactive reflection (reminiscent of biological sleep/dream consolidation cycles). By analyzing accumulated cross-session execution logs at scheduled intervals, the Dreaming Loop asks:
> *"What specific failure mode repeatedly bypasses our guardrails, and what is the smallest, safest instruction patch to permanently eliminate it?"*

This evidence-driven reflection guarantees that prompt engineering and skill evolutions are backed by empirical run records rather than speculative instincts.

---

## 4. Architecture & End-to-End Flow

```text
+-------------------------------------------------------------------------------+
|                    Project 8: Daily Execution Spine                           |
|          (project8-daily-loop/task2/loop/progress.md)                         |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                     Dreaming State Cursor Check                               |
|        (project12-dreaming-loop/task1/dreaming-state.md: 2026-09-08)          |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                    ANALYSIS Phase (OpenCode Runner)                           |
|  - Read ONLY entries strictly after cursor (2026-09-11 to 2026-09-16)         |
|  - Detect repeated failure: P12-FIXTURE-01 & 02 (exported func missing docs)  |
|  - Detect unexercised rule: P12-FIXTURE-03..06 (style preservation unused)   |
|  - Generate evidence/analysis.md and evidence/proposal.md                     |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                     MAKER Phase (Target Skill Patch)                          |
|  - Patch project8-daily-loop/task2/.claude/skills/doc-freshness/SKILL.md      |
|    (+1 explicit verification rule, -1 obsolete style-preservation rule)       |
|  - Advance cursor date in dreaming-state.md on proposal branch                |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                   INDEPENDENT CHECKER Audit Phase                             |
|  - Separate OpenCode instance re-verifies raw git diff & execution logs       |
|  - Confirms zero source code modification & strict evidence compliance        |
|  - Audit Verdict: PASS                                                        |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|               Git Branching & Scoped Staging (claude/...)                     |
|  - git add explicit file list only (no untracked leaks)                       |
|  - Push branch: claude/p12-dreaming-improvement                              |
|  - Open GitHub Pull Request #7                                                |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|              Automated Review Round 1 (GitHub Actions / Bot)                  |
|  - Flagged: hardcoded paths, invalid checkout@v6, ambiguous diff, etc.        |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                        Follow-up Fix Commit #1                                |
|  - Fix dynamic repo path resolution ($PSScriptRoot), checkout@v4,             |
|    cursor clarity & guardrail-vs-corrective deletion justification            |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|              Automated Review Round 2 (GitHub Actions / Bot)                  |
|  - Flagged: ambiguous proposal.md diff representation                         |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                        Follow-up Fix Commit #2                                |
|  - Clarify diff presentation as explicit single-line replacement (+1/-1)      |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                      HUMAN GATE (Review & Merge)                              |
|  - Manual human inspection of diff, artifacts, and test runs                  |
|  - Explicit human merge into main branch (no auto-merge)                      |
+-------------------------------------------------------------------------------+
                                      |
                                      v
+-------------------------------------------------------------------------------+
|                             Finalized State                                   |
|  - main branch updated with optimized Project 8 doc-freshness SKILL.md        |
|  - dreaming-state.md cursor advanced to 2026-09-16 on main                    |
|  - Feature branch deleted cleanly                                             |
+-------------------------------------------------------------------------------+
```

---

## 5. Safety Principles Enforced Throughout

- **Zero Unreviewed Mutations on Main**: The Dreaming Loop is structurally forbidden from pushing directly to `main` or modifying the target skill outside a pull request.
- **Adversarial Independent Checker**: The verification phase runs in a distinct context that never trusts Maker assertions blindly; it audits raw `git diff` outputs and physical log files.
- **Strictly Scoped Git Staging**: Commands use explicit file paths (`git add <file1> <file2>`) rather than wildcard `git add .` to avoid capturing unrelated local dirty state.
- **Isolation of Pre-Existing Artifacts**: Pre-existing modifications (such as `project8-daily-loop/task1/scheduler_debug.log`) were intentionally isolated and never staged or committed across any iteration.
- **Mandatory Human Gate**: No PR self-merging or automatic approvals are permitted; production target skill changes take effect only after manual human inspection and merge.
- **Rigorous Review Iteration**: Automated review findings and bot critiques are addressed as mandatory blockers through dedicated fix commits before human hand-off.

---

## 6. Evidence-Based Decision Making

All rule modifications require explicit, verifiable citations from historical logs:

### A. Rule Addition (+1)
- **Cited Runs**: `P12-FIXTURE-01` (2026-09-11) and `P12-FIXTURE-02` (2026-09-12).
- **Observed Failure**: In both runs, the Checker rejected the documentation because newly exported calculator functions in `src/` were not documented in `docs/` (failure rate: 2/6 runs = 33%).
- **Adopted Patch**: Replaced the passive instruction (*"Add missing operations..."*) with an imperative, verifiable pre-submission gate:
  ```markdown
  - Before submitting, re-read all exported functions in src/ and confirm every one has a matching documentation entry in docs/.
  ```

### B. Rule Deletion (-1) & The Guardrail vs. Corrective Principle
- **Cited Runs**: `P12-FIXTURE-03` through `P12-FIXTURE-06` (2026-09-13 to 2026-09-16).
- **Observed Behavior**: Across 4 consecutive runs, documentation synchronization succeeded with 0 style-related interventions (0/4 runs required the rule).
- **Candidate for Deletion**: `"Preserve existing documentation style."`
- **Guardrail vs. Corrective Justification**:
  Automated review pushed back on naive deletion, noting that *absence of failure does not automatically prove a guardrail is obsolete*. The proposal was strengthened to explicitly distinguish rule classifications:
  - **Guardrail rules**: Broad, precautionary constraints added defensively without a specific failure incident.
  - **Corrective rules**: Targeted constraints directly addressing an observed, recurring failure.
  Because the style rule was a legacy guardrail that imposed cognitive overhead while remaining entirely unexercised across recent history, its deletion was justified on the basis of minimal instruction overhead, while acknowledging its original defensive context.

---

## 7. Review Iteration History

The table below summarizes the multi-round automated and peer review feedback cycles that ensured complete engineering rigor:

| Issue Identified | Root Cause / Review Finding | Resolution & Fix Applied | Resolving Commit |
| :--- | :--- | :--- | :--- |
| **Hardcoded Paths** | Hardcoded Windows directory strings in `run-analysis.ps1` and `analysis.md`. | Replaced with dynamic path resolution using `$PSScriptRoot` and `git rev-parse --show-toplevel`. | `c97e4e9` |
| **Invalid Action Version** | Workflow specified non-existent `actions/checkout@v6`. | Downgraded to official stable `actions/checkout@v4`. | `c97e4e9` |
| **Cursor Inconsistency** | Ambiguity between historical cursor date (`2026-09-08`) and advanced cursor (`2026-09-16`). | Added explicit cursor lifecycle section explaining cursor progression post-acceptance. | `c97e4e9` |
| **Weak Deletion Case** | Unsubstantiated deletion of a defensive style guardrail rule. | Added explicit "Guardrail vs. Corrective" analysis justifying removal based on empirical telemetry. | `c97e4e9` |
| **Ambiguous Proposal Diff** | Markdown presented the change ambiguously as two insertions rather than a clean replacement. | Formatted as a standard unified diff block showing clear `+1 / -1` replacement. | `393523a` |

---

## 8. How to Run It

### Local Analysis Trigger
The analysis phase can be executed locally via PowerShell, which dynamically computes the workspace root and runs OpenCode:

```powershell
# Navigate to the task directory
cd D:\Gemini_Cli\Loop-Engineering\project12-dreaming-loop\task1

# Execute the dynamic analysis script
.\loop\run-analysis.ps1
```

### GitHub Actions Workflow
The workflow is configured in `.github/workflows/project12-dreaming-loop.yml`:
- **Scheduled Trigger**: Runs automatically every Monday at 09:00 UTC (`cron: "0 9 * * 1"`).
- **Manual Trigger**: Supports `workflow_dispatch` for on-demand execution.
- **Execution Lifecycle**: Runs OpenCode Maker, verifies the cursor, compiles evidence, opens a `claude/...` pull request, and halts at the human gate.

---

## 9. Final Result

- **Pull Request**: PR `#7` successfully reviewed, audited, and merged into `main`.
- **Target Skill Updated**: `project8-daily-loop/task2/.claude/skills/doc-freshness/SKILL.md` updated on `main` with the mandatory export verification rule.
- **Cursor Advanced**: `project12-dreaming-loop/task1/dreaming-state.md` cursor updated to `2026-09-16`.
- **Target Architecture Untouched**: Project 8's daily loop mechanisms, loop scripts, and checker harnesses remained completely unmodified throughout the entire meta-improvement process.

---

## 10. Key Takeaway
Project 12 showcases a complete **autonomous self-improving agent paradigm**: an intelligent meta-loop reads real historical telemetry from an active subsystem (Project 8), synthesizes a minimal evidence-backed improvement proposal, subjects the proposal to independent auditing and multi-round automated code review, and enforces a mandatory human gate before any modification is permitted to reach production.
