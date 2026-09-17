---
name: dreaming-loop
description: Evidence-first weekly improvement loop for Project 8 Task 2
---

# Dreaming Loop Skill

## Mission

Analyze the existing Project 8 Task 2 execution spine and identify only evidence-backed repeated failures or corrections that justify a small improvement to the target skill.

The Dreaming Loop is an improvement loop over an existing working loop.

It MUST prefer no proposal over a speculative proposal.

## Source Spine

Read:

- `project8-daily-loop/task2/loop/progress.md`

Read the cursor from:

- `dreaming-state.md`

Read the current target skill:

- `project8-daily-loop/task2/.claude/skills/doc-freshness/SKILL.md`

## Cursor Rule

Only analyze progress entries strictly after the date recorded in `dreaming-state.md`.

Do not silently analyze older entries.

Do not invent missing runs, dates, attempts, failures, or corrections.

## Repeated Failure Rule

A failure or correction may become an improvement candidate only when:

1. It appears in at least two separate logged runs or attempts.
2. Each occurrence can be cited with its exact date and run/attempt information.
3. The repeated behavior is materially similar.
4. The proposed improvement directly addresses that repeated behavior.
5. The evidence is strong enough to explain why the proposed rule would prevent recurrence.

If these conditions are not satisfied:

`NO EVIDENCE — NO CHANGE`

Do not manufacture a proposal merely because one sounds reasonable.

## Evidence Requirements

Every improvement proposal MUST include:

- Exact source file
- Exact dated log entries
- Run/attempt identifiers when available
- Frequency count
- Description of the repeated failure or correction
- Explanation connecting the evidence to the proposed rule
- Exact smallest proposed rule/skill change

Do not cite generic summaries when an exact log entry exists.

## Smallest-Change Rule

Propose the smallest change that directly prevents the repeated failure.

Do not rewrite the skill.

Do not add unrelated safeguards.

Do not refactor working rules without evidence.

## Deletion Proposal

Also inspect the target skill for one rule that may be obsolete.

A deletion proposal is allowed only when recent log evidence demonstrates that the rule has not been needed or exercised during the analyzed period.

The deletion proposal MUST cite the relevant recent runs.

If the evidence is insufficient:

`NO EVIDENCE — NO DELETION`

Do not delete the rule automatically.

## Maker-Checker Boundary

The Dreaming Loop is a Maker.

It may create:

- a `claude/...` branch
- a proposed change
- a pull request
- evidence documentation
- an updated `dreaming-state.md` on the proposal branch

It MUST NOT:

- modify the target skill on `main`
- commit directly to `main`
- push directly to `main`
- merge its own pull request
- approve its own pull request

## Pull Request Requirements

The PR MUST be opened from a branch whose name starts with:

`claude/`

The PR description MUST contain:

### Repeated Failure

- What repeated
- Frequency
- Exact runs/attempts
- Evidence citations

### Proposed Improvement

- Current rule
- Smallest proposed replacement/addition
- Why the evidence supports it

### Proposed Deletion

- Rule considered obsolete
- Recent evidence
- Why deletion is justified

### Human Gate

State explicitly:

`Human merge required. No target skill change is effective until the PR is manually reviewed and merged.`

## Evidence-First Stop Condition

If the logs do not contain sufficient repeated evidence:

- do not invent a change
- do not create a speculative rule
- record `NO EVIDENCE — NO CHANGE`
- still finish the analysis safely

An improvement loop that guesses is worse than no improvement loop because its guesses influence future runs.

## State Update

After analysis, update `dreaming-state.md` on the proposal branch to the newest successfully analyzed log date.

The state update must never be used as a reason to modify the target skill outside the PR.

## Final Verification

Before finishing, verify:

1. Evidence comes from real log entries.
2. Repeated failure appears at least twice.
3. Proposal is the smallest reasonable change.
4. Deletion proposal has evidence or explicitly says no evidence.
5. Branch starts with `claude/`.
6. Target skill was not changed on `main`.
7. PR contains the evidence.
8. Human merge is still required.
