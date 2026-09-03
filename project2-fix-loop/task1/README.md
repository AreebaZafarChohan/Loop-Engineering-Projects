# Task 1: Python Pytest Maker-Checker Loop

> **Concepts Covered:**
> - **Concept 5:** Conditional Loop (Bounded iteration loop with PowerShell)
> - **Concept 11:** Maker-Checker Pattern (Separation of code generation & evaluation)
> - **Stack:** Python 3, Pytest, PowerShell

---

## 📌 Overview

This project implements an automated **Maker-Checker Loop** for Python using a PowerShell orchestration script (`fix-loop.ps1`).

- **Maker (Claude Agent):** Invoked in non-interactive / prompt mode (`claude -p ...`) to inspect pytest failures and modify `src/student_result.py`.
- **Checker (Pytest Runner):** Executes `pytest` via `run-tests.ps1` and checks `$LASTEXITCODE`.

The loop iterates up to **6 attempts** and terminates immediately once all tests pass.

---

## 📂 Project Structure

```
task1/
├── src/
│   ├── __init__.py
│   └── student_result.py       # Implementation code (calculate_average, get_grade, is_passing)
├── tests/
│   └── test_student_result.py  # Untouchable pytest assertions
├── fix-loop.ps1                # Automated loop script (Max 6 attempts)
├── run-tests.ps1               # Checker script executing pytest
├── pytest.ini                  # Pytest configuration
└── README.md
```

---

## 🔄 How the Fix Loop Works

1. `fix-loop.ps1` sets `$MAX_ATTEMPTS = 6`.
2. On each iteration:
   - **Step 1 (Maker):** Prompts the agent to inspect pytest failures and fix `src/student_result.py`.
   - **Step 2 (Checker):** Runs `.\run-tests.ps1`.
   - **Step 3 (Evaluation):**
     - If exit code is `0`, outputs `🎉 SUCCESS: Tests passed!` and exits.
     - If non-zero and attempts remain, logs failure and triggers the next attempt.
     - If attempt 6 fails, stops with `🛑 Maximum attempts reached.`

---

## 🚀 How to Run

### Manual Test Execution:
```powershell
pytest
# or
.\run-tests.ps1
```

### Run the Automated Fix Loop:
```powershell
.\fix-loop.ps1
```
