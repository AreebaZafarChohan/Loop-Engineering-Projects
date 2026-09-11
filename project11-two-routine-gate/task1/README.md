# Project 11: Two-Routine Human-Gated Workflow

## 1. Project Objective

The goal of Project 11 is to design, implement, and verify a **two-routine human-gated workflow** where an autonomous preparation routine cannot trigger downstream actions without explicit human approval.

In real-world agentic systems and CI/CD pipelines, autonomous routines often draft code, generate artifacts, or propose state changes. Allowing automated processes to chain unconditionally into high-impact execution introduces severe operational and security risks. Project 11 establishes a strict human gate separating preparation (Routine A) from execution (Routine B).

---

## 2. Architecture & Mental Model

```
+-------------------------------------------------------------+
| Routine A (One-Off / Manual Trigger)                        |
| - Trigger: workflow_dispatch                                |
| - Action: Executes preparation workflow and stops           |
| - Result: Existing reviewable draft remains for inspection  |
+-------------------------------------------------------------+
                              │
                              ▼ (No automatic transition)
+-------------------------------------------------------------+
| Human Gate (Manual Inspection & Decision)                   |
| - Human reviews Routine A output and execution plan         |
| - Decision: Explicitly authorize execution via API call     |
+-------------------------------------------------------------+
                              │
                              ▼ (Explicit API / repository_dispatch)
+-------------------------------------------------------------+
| Routine B (Human-Approved Follow-Up)                        |
| - Trigger: repository_dispatch (type: routine-b-approved)   |
| - Action: Executes concrete follow-up action                |
| - Verification: Asserts file creation & content integrity   |
| - Persistence: Commits output/follow-up.md to Git repository|
+-------------------------------------------------------------+
```

---

## 3. Workflow Components

### Routine A: Draft Preparation
- **Trigger**: `workflow_dispatch` (one-off / manual trigger).
- **Function**: Executes its preparation workflow (checking out repository, logging start, reading `routine-a/task.md` and `routine-a/prompt.md`, reporting draft is prepared, confirming B was not triggered) and stops, while the existing reviewable draft (`routine-a/output/draft.md`) remains available for human inspection.
- **Isolation**: Routine A contains **no webhooks, no API dispatch calls, and no downstream triggers**. Upon completing its preparation workflow, Routine A stops completely.

### The Human Gate
- The human reviewer inspects the output draft (`routine-a/output/draft.md`) and execution plan (`routine-a/execution-plan.md`).
- Approval requires deliberate, external human action: issuing an authenticated HTTP POST request to GitHub's `repository_dispatch` API endpoint.
- Without this explicit human dispatch, Routine B never executes.

### Routine B: Human-Gated Execution & Persistence
- **Trigger**: `repository_dispatch` with event type `routine-b-approved`.
- **Concrete Follow-Up Action**: Creates and updates the persistent evidence artifact at `project11-two-routine-gate/task1/routine-b/output/follow-up.md`.
- **Verification**: Runs strict verification steps (`test -f`, checking content markers with `grep -q "Status: COMPLETED"`).
- **Evidence Persistence**: Commits and pushes the generated artifact directly back to the repository under `chore(project11): record Routine B follow-up`.

---

## 4. Verification & Evidence

### Routine A Verification
- Both Run #1 and Run #2 of Routine A completed successfully via `workflow_dispatch`.
- In both instances, GitHub Actions confirmed that Routine B had **zero automated executions**. This proves the hard boundary and absence of automatic chaining between routines.

### Routine B Initial Implementation & Failure Diagnosis
During the initial implementation of Routine B:
- **Run #1 ID**: `34618167099`
- **Result**: Failed.
- **Cause**: The initial workflow included an OpenCode action step that reported:
  ```
  Unsupported event type: repository_dispatch
  ```
- **Diagnosis & Fix**: The failure was diagnosed directly rather than masked. In commit `8b48591` (*fix(project11): make Routine B human-gated follow-up concrete*), the unsupported OpenCode step was replaced with a concrete file-based follow-up action, automated content verification, and git commit persistence.

### Successful Routine B Execution
- **Run #2 ID**: `34619569404`
- **Event**: `repository_dispatch` (`routine-b-approved`)
- **Status**: Completed (`success`)
- **Commit SHA**: `8b485916411678398c630ab34e36550492f4e5e4`
- **Verified Job Steps**:
  1. *Perform approved follow-up action* → Passed
  2. *Verify actual action* → Passed (confirmed file creation and valid status marker)
  3. *Commit follow-up evidence* → Passed
  4. *Record B execution evidence* → Passed

### Persistent Git Evidence
- **Commit**: `71b8a31` (*chore(project11): record Routine B follow-up*)
- **Target File**: `project11-two-routine-gate/task1/routine-b/output/follow-up.md`
- **Final File Content**:
  ```markdown
  # Routine B Follow-Up

  Routine B executed the approved follow-up action.

  Trigger: repository_dispatch
  Event type: routine-b-approved
  Approval: human-approved
  Status: COMPLETED
  ```
- **Repository State**: Clean working tree with `HEAD` and `origin/main` synchronized at commit `71b8a31`.

---

## 5. Key Engineering Principle: Why "Green Status" is Insufficient

A foundational lesson in Loop Engineering is that **a green checkmark in CI/CD only indicates that the runner exited with code 0; it does not prove that the intended functional work actually occurred**.

In Project 11:
1. Routine B does not rely on passive success codes.
2. The workflow includes an explicit `Verify actual action` step that tests for file existence (`test -f`) and verifies payload contents (`grep -q "Status: COMPLETED"`).
3. The result is committed to git (`71b8a31`), creating durable, auditable evidence of actual execution.

---

## 6. Security Notes & Best Practices

- **Bearer Token Handling**:
  - The personal access token (PAT) / bearer token used to trigger `repository_dispatch` must **never be committed to Git**.
  - Tokens must **never be printed in workflow logs**, stored in environment files tracked by VCS, or written to markdown files / transcripts.
- **Controlled Permissions & Minimal Connectors**:
  - Unnecessary third-party actions and plugins were pruned from the workflow.
  - Workflows operate with minimal required permissions (`contents: write` scoped specifically to Routine B).
- **Unrestricted Pushes Disabled**:
  - Routine B only modifies and commits its specific target artifact (`routine-b/output/follow-up.md`).
- **Explicit State & Evidence Location**:
  - All outputs and transcripts are strictly isolated within the `project11-two-routine-gate/task1/` directory hierarchy.
