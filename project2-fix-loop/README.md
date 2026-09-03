# Project 2: Fix-Loop & Agentic Feedback Loops

> **Core Engineering Concepts:**
> - **Concept 5:** Conditional Loops (Bounded iteration with explicit stop criteria)
> - **Concept 11:** Maker-Checker Pattern (Separation of code generation & evaluation)

---

## 📖 Introduction & Philosophy

When building agentic workflows, relying on the LLM to decide whether its own output is correct often leads to premature stops, hallucinated confidence, or regression bugs. 

**Fix-Loop Engineering** solves this by establishing two fundamental rules:
1. **Maker vs. Checker Separation:** An LLM or agent acts as the **Maker** (modifies implementation code only). An automated test runner acts as the **Checker** (deterministic source of truth).
2. **Deterministic Termination:** The loop terminates **only** when the checker command exits with code `0` (success) or when reaching an explicit maximum attempt threshold (e.g., 6 attempts).

```
   ┌─────────────────────────────────────────────────────────┐
   │                                                         │
   │               ┌───────────────────────┐                 │
   │               │     Start / Retry     │                 │
   │               └───────────┬───────────┘                 │
   │                           │                             │
   │                           ▼                             │
   │               ┌───────────────────────┐                 │
   │               │   MAKER (AI Agent)    │                 │
   │               │  Fixes Implementation │                 │
   │               └───────────┬───────────┘                 │
   │                           │                             │
   │                           ▼                             │
   │               ┌───────────────────────┐                 │
   │               │  CHECKER (Test Runner)│                 │
   │               │  `npm test` / `pytest`│                 │
   │               └───────────┬───────────┘                 │
   │                           │                             │
   │              ┌────────────┴────────────┐                │
   │              │                         │                │
   │        [Exit Code 0]             [Exit Code != 0]       │
   │              │                         │                │
   │              ▼                         ▼                │
   │    ┌──────────────────┐      ┌──────────────────┐       │
   │    │  🎉 All Passed   │      │ Attempts < Max?  │       │
   │    │  (Loop Succeeds) │      └───┬──────────┬───┘       │
   │    └──────────────────┘          │          │           │
   │                                [Yes]       [No]         │
   │                                  │          │           │
   │                                  │          ▼           │
   │                                  │   ┌──────────────┐   │
   │                                  │   │ 🛑 Max Cap   │   │
   │                                  │   │   Reached    │   │
   │                                  │   └──────────────┘   │
   └──────────────────────────────────┴──────────────────────┘
```

---

## 📂 Sub-Projects Overview

| Sub-Project | Language & Framework | Description | Key Artifacts |
| :--- | :--- | :--- | :--- |
| [`task1/`](./task1/README.md) | Python 3 + `pytest` | PowerShell-orchestrated headless Claude CLI loop | `fix-loop.ps1`, `student_result.py` |
| [`task2/`](./task2/README.md) | Node.js + `jest` | Baseline Jest test suite setup | `math.js`, `math.test.js` |
| [`task3_multi_attempt/`](./task3_multi_attempt/README.md) | Node.js + `jest` | Multi-bug iterative fix loop with capped attempts | `calc.js`, `calc.test.js` |

---

## 🛠️ Tasks Breakdown

### 1. `task1` — Python Pytest Automated Loop
- **Implementation:** `src/student_result.py` (calculates averages, grades, passing status).
- **Test Suite:** `tests/test_student_result.py`.
- **Loop Orchestration:** `fix-loop.ps1` runs a 6-attempt loop using `claude -p` to fix broken functions while `run-tests.ps1` executes pytest as the checker.

### 2. `task2` — Node.js Baseline
- **Implementation:** `math.js` (basic arithmetic).
- **Test Suite:** `math.test.js`.
- Serves as the standard Jest environment baseline for JavaScript test-driven loops.

### 3. `task3_multi_attempt` — Multi-Bug Iterative Fix
- **Implementation:** `calc.js` containing multiple intentional bugs:
  - Zero division error handling in `divide()`.
  - Inverted even/odd parity condition in `isEven()`.
  - Zero base case handling in `factorial()`.
- **Test Suite:** `calc.test.js` (6 tests).
- **Goal:** Agent iteratively diagnoses and fixes all bugs within 6 attempts, with `npm test` acting as the sole arbiter of success.

---

## 🔑 Key Lessons

- **Never Let the Agent Self-Approve:** The agent cannot decide when it is done based on its internal chain-of-thought. The test command's exit code is the only valid stop signal.
- **Protect Test Files:** The prompt/loop must enforce that test files are read-only to prevent false positives.
- **Tune Prompts When Hitting Caps:** If a loop consistently hits its maximum attempt cap, improve the failure diagnostics provided to the prompt rather than increasing the cap indefinitely.
