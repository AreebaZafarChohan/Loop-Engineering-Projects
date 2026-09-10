# Project 9 Progress

## Run 1 — Successful Task
- Prompt: Read NOTES.md and create SUMMARY.md.
- Result: SUCCESS
- Evidence: NOTES.md was read and SUMMARY.md was created.
- Transcript: transcript-working.log
- Exit code: 0

## Run 2 — Intentional Logical Failure
- Prompt: Read THIS_FILE_DOES_NOT_EXIST.md and create SUMMARY.md.
- Result: LOGICAL FAILURE
- Evidence: File-not-found error; SUMMARY.md was not created.
- Transcript: transcript-broken.log
- Exit code: 0

## A5 Lesson

Green means the session ended without an infrastructure error; it does not prove that the actual task succeeded.
