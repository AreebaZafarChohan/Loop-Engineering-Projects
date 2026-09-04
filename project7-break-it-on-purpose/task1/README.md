# Project 7: Sabotage Loop — Observability and Cost

## 1. Overview
This project evaluates an automated autonomous loop based on the Project 3 morning-brief pattern. In this exercise, we:
- Measure the single-beat token usage and financial cost of the loop.
- Deliberately sabotage the loop execution by directing the prompt toward a nonexistent file (`nonexistent-file.md`).
- Inspect and diagnose the failure exclusively via the spine (`progress.md` and `run.log`), demonstrating how robust observability enables immediate troubleshooting without replaying the full session transcripts.

---

## 2. Concepts Used
- **Observability:** Designing autonomous agents to leave structured, human-readable breadcrumbs and execution traces in dedicated log files and state files.
- **Concept 13 (Cost Math & Unit Economics):** Measuring per-beat token consumption to project real-world operating expenses over different cadences (daily, weekly, monthly).
- **Concept 14 (Failure Handling & Escalation):** Preventing silent failures by implementing fallback instructions that explicitly flag errors and alert human operators.

---

## 3. Step 1: Measuring a Beat
A baseline normal run was executed using the headless CLI flag `--output-format json`:

```bash
claude -p "Read progress.md. Scan notes.md for TODO comments. Write a short summary and append a dated entry to progress.md." --permission-mode acceptEdits --output-format json
```

The output returned a structured JSON payload detailing token usage and cost metrics for a single beat:

- **Input Tokens:** 79,870
- **Output Tokens:** 769
- **Total Cost USD:** ~$0.443 (~$0.4429)

---

## 4. Step 2: The Cost Math (Concept 13)
The operating cost of an autonomous loop scales predictably based on its execution frequency:

$$\text{Monthly Cost} = \text{Cost per Beat} \times \text{Cadence (runs/month)}$$

### Cost Projections Table
| Cadence | Runs per Month | Projected Monthly Cost |
| :--- | :--- | :--- |
| **Daily Cadence** | 30 runs / month | **~$13.20 / month** ($0.443 × 30) |
| **Weekly Cadence** | 4 runs / month | **~$1.76 / month** ($0.443 × 4) |

> **Note on Pricing:** This run utilized the specific model environment configuration available during the run. Standard production Claude Sonnet pricing will vary based on current Anthropic token rates and prompt caching optimizations. However, the core engineering lesson remains the same: **measure one beat accurately, then multiply by cadence**.

---

## 5. Step 3: Sabotaging the Loop
To test resilience and failure observability, we introduced intentional sabotage in `run_brief_sabotaged.ps1` by pointing the prompt to a missing file (`nonexistent-file.md`), paired with an explicit human-escalation instruction:

```powershell
claude -p "Read nonexistent-file.md. Scan notes.md for TODO comments. Write a short summary and append a dated entry to progress.md. If nonexistent-file.md does not exist, write 'ERROR: nonexistent-file.md not found — needs human review' as the entry instead, with today's date." --permission-mode acceptEdits --output-format json
```

This prompt guarantees that instead of failing silently or crashing out without recording state, the agent explicitly documents the failure condition.

---

## 6. Step 4: What the Spine Showed
After running the sabotaged script, the system state was inspected using only the two spine files:

### `run.log` Entry
```
[2026-09-04 20:42:04] Run completed
```

### `progress.md` Entry
```markdown
# Progress Log

## 2026-09-04
- ERROR: nonexistent-file.md not found — needs human review
```

### Diagnosis
Without opening session transcripts or inspecting debug traces:
1. **When it failed:** `2026-09-04 20:42:04` (recorded in `run.log`).
2. **What failed:** `nonexistent-file.md` was missing, and human review is required (recorded in `progress.md`).

---

## 7. Step 5: An Unexpected Finding — The Spine Overwrote Itself
During the sabotaged execution, an important observability bug surfaced:

- `progress.md` previously contained the valid TODO scan summary from the baseline run.
- When the sabotaged run executed, the model **replaced** the entire content of `progress.md` with only the error entry, despite the prompt instruction containing the word *"append"*.

### Observability Lesson & Fix
A spine that silently overwrites historical progress defeats the purpose of persistent state tracking. To guarantee append-only behavior:
- **Prompt Hardening:** Explicitly forbid destructive edits in the prompt:
  > *"Only append a new section to the end of progress.md; never remove, overwrite, or replace existing content."*
- **Harness Verification:** When necessary, use tooling, Git history, or wrapper scripts to enforce append-only state invariants.

---

## 8. Results Table

| Failure Type | Silent? | Spine Diagnosis Possible? | Needs-Human Note? |
| :--- | :--- | :--- | :--- |
| **Missing file** | No | Yes | Yes |

---

## 9. Key Lessons
1. **Predictable Unit Economics:** A loop's monthly cost is one multiplication once you measure a single beat.
2. **Instant Diagnosis via Spine:** A well-structured spine turns a 3:00 AM production failure into a two-line diagnosis rather than requiring an exhaustive transcript replay.
3. **Spine Invariants Require Guardrails:** The spine itself needs verification. Natural language instructions like "append" can still be misinterpreted as full-file rewrites unless explicitly restricted.

---

## 10. How to Reproduce

1. **Set Up Baseline Files:** Create `notes.md` with sample TODO comments and initialize `progress.md` with `# Progress Log`.
2. **Measure Baseline Beat:** Run `run_brief.ps1` with `--output-format json` and inspect `run.log` to extract token counts and `total_cost_usd`.
3. **Calculate Monthly Cost:** Multiply `total_cost_usd` by target cadence (e.g., 30 for daily, 4 for weekly).
4. **Execute Sabotaged Run:** Run `run_brief_sabotaged.ps1` targeting `nonexistent-file.md`.
5. **Inspect the Spine:** Open `progress.md` and `run.log` to confirm error logging and assess whether previous entries were preserved or overwritten.
