# Project 11: Two-Routine Human Gate (Task 1 & Task 2)

Welcome to **Project 11: Two-Routine Human Gate**. This project demonstrates and validates the implementation of a robust **Human-in-the-Loop (HITL) approval gate** architecture across two complementary implementations/tasks:

1. **Task 1: GitHub Actions CI/CD Workflow Gate** (`repository_dispatch`)
2. **Task 2: Local Node.js API Gate Server** (Bearer Token & Git Merge Automation)

---

## 🎯 Core Concept & Mental Model

In autonomous agentic workflows and automated CI/CD systems, preparation routines often generate drafts, propose state changes, or build artifacts. Chaining preparation unconditionally into execution introduces critical operational and security risks.

The **Two-Routine Pattern** enforces a hard architectural boundary:

```
+-------------------------------------------------------------+
| Routine A (Preparation / Draft Routine)                     |
| - Trigger: Manual / Workflow Dispatch / One-off Task        |
| - Action: Prepares reviewable artifacts (drafts, plans)     |
| - Boundary: Stops completely without auto-triggering B     |
+-------------------------------------------------------------+
                              │
                              ▼ (No automatic transition)
+-------------------------------------------------------------+
| Human Gate (Inspection & Explicit Decision)                 |
| - Human reviewer inspects Routine A output                  |
| - Decision: Authorizes execution via authenticated trigger  |
+-------------------------------------------------------------+
                              │
                              ▼ (Explicit Authenticated Trigger)
+-------------------------------------------------------------+
| Routine B (Human-Approved Follow-up Routine)                |
| - Trigger: repository_dispatch / Bearer-token API POST      |
| - Action: Performs follow-up action (merge, persist output) |
| - Verification: Asserts concrete execution (not just exit 0)|
+-------------------------------------------------------------+
```

---

## 📂 Project Structure

```
project11-two-routine-gate/
├── README.md               # Root overview (this file)
├── task1/                  # CI/CD (GitHub Actions) human-gated workflow
│   ├── README.md           # Detailed Task 1 documentation & verification logs
│   ├── routine-a/          # Routine A draft & execution plan artifacts
│   ├── routine-b/          # Routine B follow-up execution artifacts
│   ├── evidence/           # CI execution logs and transcripts
│   └── A6-checklist.md     # Security & engineering checklist
└── task2/                  # Local API server & git merge human-gate
    ├── README.md           # Detailed Task 2 documentation
    ├── gate-server.js      # Node.js gate server with Bearer auth on port 3939
    ├── DRAFT.md            # Generated release draft summarizing commits
    ├── APPROVED.md         # State tracking record for approvals
    ├── runA_transcript.txt # Transcript of Routine A drafting process
    └── runB_response.txt   # Response from the approved curl API trigger
```

---

## 🔍 Tasks Overview

### [Task 1: GitHub Actions Two-Routine Gate](./task1/README.md)

- **Routine A (Draft Preparation)**: Triggered via `workflow_dispatch`. Prepares draft review artifacts in `routine-a/output/draft.md` and halts without triggering any webhooks or dispatch events.
- **Human Inspection**: Reviewer inspects `routine-a/output/draft.md` and `routine-a/execution-plan.md`.
- **Routine B (Human-Approved Execution)**: Triggered only via an authenticated GitHub `repository_dispatch` API call (`event_type: routine-b-approved`). Generates and commits `routine-b/output/follow-up.md` with explicit functional assertions (`grep -q "Status: COMPLETED"`).
- **Key Takeaway**: Proves that a "green CI checkmark" is insufficient without explicit functional assertions and durable git evidence.

### [Task 2: Local API Server & Branch Merge Gate](./task2/README.md)

- **Routine A (Draft Generation)**: One-off routine creates branch `claude/release-draft`, writes `DRAFT.md` summarizing recent commits, and stops without merging into `main`.
- **Routine B (Local Bearer-Token Gate Server)**: A Node.js server (`gate-server.js` listening on port 3939) remains idle until an authenticated `POST` request with `Authorization: Bearer <token>` is received.
- **Human Approval & Execution**: After human review of `DRAFT.md`, a `curl` call triggers the merge of `claude/release-draft` into `main` and updates `APPROVED.md` with state metadata to prevent replay/duplicate merges.

---

## 🛡️ Security & Engineering Best Practices

- **Bearer Token Isolation**: Secret tokens (PAT / API Bearer tokens) are kept in gitignored files (`gate_token.txt`) and never logged or committed.
- **No Uncontrolled Automation**: Chaining between Routine A and Routine B is mechanically prohibited.
- **State File Tracking**: Dedicated state files (`APPROVED.md`, `follow-up.md`) record timestamps and execution status to prevent replay actions.
- **Least Privilege**: Only necessary write permissions (`contents: write` scoped specifically to Routine B) are used.
