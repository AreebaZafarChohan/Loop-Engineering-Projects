# Project 9 — Rehearse a Routine

## Goal

Practice a one-off routine and demonstrate why a green run/status does not necessarily mean the actual task succeeded.

This project uses OpenCode to run a single, non-repeating prompt. Two runs are executed — one that works and one that is intentionally broken — to show that exit code alone cannot confirm task completion.

## Experiment

### Run 1 — Successful Run

**Prompt** (`run-working.ps1`):
> Read NOTES.md completely.
> Create SUMMARY.md containing a concise summary of the file.
> At the end, clearly state that the task was completed successfully.

**Transcript** (`transcript-working.log`):
- OpenCode read `NOTES.md`.
- OpenCode wrote `SUMMARY.md`.
- The transcript reported: "Wrote file successfully."
- The transcript reported: "Task completed successfully."
- Exit code: **0**.

### Run 2 — Intentional Logical Failure

**Prompt** (`run-broken.ps1`):
> Read THIS_FILE_DOES_NOT_EXIST.md completely.
> Create SUMMARY.md containing a summary of that file.
> Do not use any other file as a substitute.

**Transcript** (`transcript-broken.log`):
- OpenCode attempted to read `THIS_FILE_DOES_NOT_EXIST.md`.
- The file did not exist.
- The transcript showed a file-not-found error.
- `SUMMARY.md` was not created.
- Exit code: **0**.

## A5 Lesson

**Green means the session ended without an infrastructure error, nothing more.**

Exit code and status alone cannot prove that the task succeeded. A logical failure — such as reading a file that does not exist — can occur while the process still returns exit code 0. The transcript and concrete output artifacts must be inspected to verify actual task completion.

## Evidence

| File | Purpose |
|---|---|
| `transcript-working.log` | Transcript of the successful run (Run 1). Shows NOTES.md was read and SUMMARY.md was written. |
| `transcript-broken.log` | Transcript of the intentionally broken run (Run 2). Shows the file-not-found error. |
| `progress.md` | Experiment record documenting both runs, their results, and exit codes. |
| `NOTES.md` | Source file read during Run 1. Contains topics on Loop Engineering, one-off runs, and transcript inspection. |
| `SUMMARY.md` | Output artifact created during Run 1. Not present after Run 2 (the file was not created). |

## Experiment Flow

```
Prompt → OpenCode → Agent action → Transcript → Output artifact → Human verification
```

1. **Prompt**: A human-readable instruction is provided (via `run-working.ps1` or `run-broken.ps1`).
2. **OpenCode**: The CLI receives the prompt and dispatches it to the agent.
3. **Agent action**: The agent executes tool calls (read files, write files).
4. **Transcript**: A log records every action and its result.
5. **Output artifact**: Concrete files are created (or not) as evidence of success.
6. **Human verification**: A human inspects the transcript and artifacts — not just the exit code.

## What We Learned

- **One-off execution**: Each run is a single, non-repeating invocation. There is no schedule or loop.
- **Transcript inspection**: The transcript is the primary source of truth for what the agent actually did.
- **Logical failure vs infrastructure failure**: A logical failure (e.g., missing file) is not an infrastructure crash. The process can complete "successfully" while the task fails.
- **Green status vs actual task success**: Exit code 0 means the process ended without an infrastructure error. It does not mean the intended task was completed.
- **Observable evidence in agentic systems**: In agentic workflows, trust is placed in observable artifacts — transcripts, created files, and logged actions — not in status codes alone.
