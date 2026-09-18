# Project 12 Task 2: Dreaming Loop over Project 8 Task 1 (daily-lint-sweep)

## Goal
Build a second, weekly-scheduled loop that reads a target loop's dated log history, detects any repeated failure (2+ occurrences), proposes the smallest rules-file fix as a PR on a claude/ branch (never a direct commit), cites its evidence, proposes one deletion for an unused rule, and updates its own dreaming-state.md cursor.

## Relationship to Project 8 Task 1
This loop targets a copy of Project 8 Task 1's real artifacts, isolated in source-project8-task1/ to keep this exercise independent of Project 12 Task 1 (which already targeted Project 8 Task 2):
- source-project8-task1/progress.md — copied from project8-daily-loop/task1/progress.md
- source-project8-task1/.claude/skills/daily-lint-sweep/SKILL.md — copied from the same location
- A repeated failure was manually planted in progress.md (two eslint-disable suppression FAILs on 2026-09-11 and 2026-09-12) to test whether the dreaming loop catches it.

## Cursor Mechanism
- dreaming-state.md started with 'Last analyzed date: 2026-09-10'.
- The loop only analyzed entries strictly after that date (2026-09-11 onward), correctly ignoring older history already reviewed.

## Evidence-Based Proposal

### Addition (cited)
- Cited runs: 2026-09-11 09:15:22 (no-unused-vars suppressed) and 2026-09-12 10:41:07 (eqeqeq suppressed) — both FAIL, same root cause (eslint-disable comments instead of real fixes).
- Proposed patch: added step 5 to Fix steps — grep for eslint-disable comments before committing, and fix properly if found.

### Deletion (cited)
- Cited runs: all entries from 2026-09-08 through 2026-09-15 — no run ever reported a prefer-const violation.
- Proposed patch: removed the prefer-const rule as never-exercised.

## Safety Mechanism
- All work was done on branch claude/dreaming-loop-improvement.
- Nothing was pushed or merged. The main branch does not contain this folder at all until a human reviews and merges it — verified by checking out main and confirming the files don't exist there.

## Done Criteria Met
1. The proposal traces to real, cited log entries — no guesses (see evidence/analysis.md).
2. The planted repeated failure (2026-09-11, 2026-09-12) was caught and turned into a proposal.
3. Nothing changed in the rules file on main without a human merge.

## The Lesson (Capstone)
A self-improvement loop must never be allowed to edit its own rules directly. It should only ever produce a reviewable, evidence-cited proposal — a human remains the final gate before any instruction that will steer future runs is allowed to take effect. An improvement loop that proposes changes without citations is worse than no improvement loop at all, because unverified guesses would steer every future run.

## Files
- source-project8-task1/progress.md — the source log (with planted failure)
- source-project8-task1/dreaming-state.md — cursor file, advanced to 2026-09-15
- source-project8-task1/.claude/skills/daily-lint-sweep/SKILL.md — patched rules file (on this branch only)
- source-project8-task1/evidence/analysis.md — full citation-backed reasoning
- run_dreaming_loop.txt — transcript of the dreaming loop run
