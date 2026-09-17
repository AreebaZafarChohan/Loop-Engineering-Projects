# Project 12 Dreaming Loop Proposal

## Evidence
- P12-FIXTURE-01 — 2026-09-11
- P12-FIXTURE-02 — 2026-09-12
- P12-FIXTURE-03 — 2026-09-13
- P12-FIXTURE-04 — 2026-09-14
- P12-FIXTURE-05 — 2026-09-15
- P12-FIXTURE-06 — 2026-09-16

## Proposed Improvement
**Old rule** (SKILL.md:21):
```
- Add missing operations when they are clearly present in the source code.
```

**New rule** (replaces old rule — +1/-1):
```diff
- Add missing operations when they are clearly present in the source code.
+ Before submitting, re-read all exported functions in src/ and confirm every one has a matching documentation entry in docs/.
```

**Frequency**: 2 out of 6 analyzed runs exhibited the repeated failure (33%) — P12-FIXTURE-01 and P12-FIXTURE-02 both failed because an exported calculator operation was not documented.

**Why the evidence supports the change**: P12-FIXTURE-01 and P12-FIXTURE-02 both failed because the Maker did not verify that all exported functions had documentation before submitting. The existing passive rule "Add missing operations when they are clearly present in the source code" was not sufficient to prevent this failure. The new mandatory verification step directly addresses the repeated root cause and prevents recurrence.

## Proposed Deletion

**Guardrail vs. Corrective classification**: The deleted rule — "Preserve existing documentation style." — is a **guardrail rule**: a generic, precautionary guideline not derived from any specific observed failure. Guardrail rules are added defensively in anticipation of potential issues rather than in response to documented incidents. By contrast, the new rule being added ("Before submitting, re-read all exported functions...") is a **corrective rule**: it is derived from repeated, observed failures (P12-FIXTURE-01 and P12-FIXTURE-02) where the Maker did not perform verification before submission. Corrective rules have direct evidence backing their necessity. Because the deleted guardrail rule was never exercised across four recent runs (0% invocation rate) and no failure in the analyzed period was caused by its absence, its removal is justified by the evidence. This does not mean guardrail rules are inherently unnecessary — only that this specific guardrail had no demonstrated need in recent history.

**Deleted rule**: `Preserve existing documentation style.`

**Deletion-test Run IDs**:
- P12-FIXTURE-03 — 2026-09-13 — PASS — Rule not needed
- P12-FIXTURE-04 — 2026-09-14 — PASS — Rule not needed
- P12-FIXTURE-05 — 2026-09-15 — PASS — Rule not needed
- P12-FIXTURE-06 — 2026-09-16 — PASS — Rule not needed

**Frequency**: 0 out of 4 analyzed runs required this rule (0%).

**Justification**: In all four recent runs, documentation synchronization completed without any style-related correction or intervention. The rule was not needed to resolve any run. Based only on the recent analyzed evidence (after cursor date 2026-09-08), this rule has not been exercised and is considered obsolete.

## Scope
The proposed target change is limited to `project8-daily-loop/task2/.claude/skills/doc-freshness/SKILL.md`. No source code is changed. Project 12 evidence and state files are part of the capstone artifact and are not target-skill changes.

## Human Gate
Human merge required. No target skill change is effective until the PR is manually reviewed and merged.

