# Project 9: One-off Runs — Status vs Transcript

## Goal
Explain the difference between a routine/run's status (green/success) and what actually happened inside it. Prove that a green status does not mean the task was accomplished — it only means the session ended without an infrastructure error.

## Setup
- Created 2 dummy commits ("Add hello log", "Add world log") in this repo.
- Ran two one-off `opencode run` commands (not scheduled/repeating).

## Run 1 — Good Task
- Prompt: "Summarize the last 2 commits in this repo (use git log). Create a new branch called claude/summary and write the summary into a file called SUMMARY.md on that branch. Commit it."
- Exit code: 0
- Result: Branch `claude/summary` created, SUMMARY.md written with accurate commit summary, commit made.
- Verified by reading the full transcript (run1_transcript.txt) and checking `git branch` + `git show`.

## Run 2 — Bad Task (deliberately broken)
- Prompt: "Read the file called this-file-does-not-exist.md and summarize its content into a new branch called claude/summary-2."
- Exit code: 0 (same as Run 1!)
- Result: File did not exist. Model correctly reported it could not read the file and did NOT create the branch or any output.
- Verified by reading the full transcript (run2_transcript.txt) and confirming `claude/summary-2` was never created (`git branch | findstr summary`).

## The Lesson (A5)
Both runs returned exit code 0 / a "success" status. The status column alone could not distinguish a real success from a real failure. Only reading the full transcript revealed the difference.

**One-sentence takeaway:** Green means the session ended without an infrastructure error — nothing more. It never confirms the model actually achieved the goal.

## Files
- run1_transcript.txt — full transcript of the successful run
- run2_transcript.txt — full transcript of the failed run
- SUMMARY.md — output of Run 1 (on branch claude/summary)
