# Project 10 — Secret Drill (Master Overview)

A comprehensive, hands-on engineering drill demonstrating how secrets and credentials behave across local development, clean clone environments, agentic workflows, and CI/CD pipelines.

---

## 📌 Executive Summary & Key Objective

In modern software development and agentic AI systems, applications depend heavily on credentials (API tokens, private keys, database passwords). 

This project explores and proves the critical distinction between:
1. **Repository Layer / Tracked Files**: Source code, documentation, prompt templates, and safe configuration.
2. **Ignored Local Files (`.env`)**: Files strictly excluded from Git via `.gitignore` to prevent secret leakage.
3. **Runtime Injected Secrets**: Credentials supplied directly to the execution process via Environment Variables (Shell, Container, CI/CD Secrets).

> **Core Takeaway:** Gitignored files (like `.env`) never reach remote repositories or fresh clones. Secrets must **always** be decoupled from source files and injected directly into the runtime environment.

---

## 🗂️ Project & Task Structure

```text
project10-secret-drill/
├── task1/                   # Task 1: Fundamentals of .env vs. Process Environment & Transcript Auditing
│   ├── .gitignore           # Excludes .env from Git
│   ├── .env                 # Dummy credential file (not tracked in Git)
│   ├── secret-check.ps1     # Verification script
│   ├── secret-task.md       # Task specifications
│   ├── prompt-first.txt     # Run 1 prompt (missing secret scenario)
│   ├── transcript-first.log # Evidence: Run 1 transcript
│   ├── transcript-second.log# Evidence: Run 2 transcript
│   ├── progress.md          # Drill progress log
│   └── README.md            # Task 1 detailed documentation
│
├── task2/                   # Task 2: Fresh Clone Simulation & Authorization Header Construction
│   ├── app.js               # Sample application demanding token
│   ├── run1_transcript.txt  # Run 1 failure transcript (missing .env in clone)
│   ├── run2_transcript.txt  # Run 2 success transcript (environment variable)
│   └── README.md            # Task 2 detailed documentation
│
├── task3/                   # Task 3: CI/CD Pipeline & GitHub Actions Secret Injection
│   ├── secret-task.md       # Task rules & security boundaries
│   ├── prompt.md            # Agent environment guidelines
│   ├── progress.md          # Task 3 progress log
│   └── README.md            # Task 3 detailed documentation
│
├── .github/workflows/
│   └── secret-drill.yml     # GitHub Actions workflow for Task 3
└── README.md                # Root master overview (this file)
```

---

## 🔬 Breakdown by Task

### 1. [Task 1 — Secret Drill Fundamentals & Agent Prompting](./task1/README.md)
* **Focus**: Simulating a fresh environment, demonstrating `.gitignore` mechanics, and testing agent behavior.
* **Run 1 (Failure)**: In a clean environment clone, the `.env` file was physically absent. The agent looked for the secret and output `NOT AVAILABLE`.
* **Run 2 (Success)**: `API_TOKEN` was supplied directly into the runtime process environment with explicit prompt instructions (`"Credentials exist in environment variable API_TOKEN; do not search for .env"`). The agent successfully confirmed token availability without leaking token values.
* **Key Insight**: Exit code `0` can be misleading. Proper verification requires inspecting transcripts, artifacts, and security boundaries.

### 2. [Task 2 — Fresh Clone Simulation & Real-World Use Case](./task2/README.md)
* **Focus**: Demonstrating why an application in a fresh clone fails when relying on local `.env` vs. succeeding with runtime environment variables.
* **Run 1**: Attempted to read `DUMMY_TOKEN` from `.env` in a clean cloned folder. Tool calls failed because `.env` was never committed.
* **Run 2**: Injected `$env:DUMMY_TOKEN = "sk-fake-12345"` into the shell. The agent successfully generated `Authorization: Bearer sk-fake-12345`.
* **Key Insight**: Gitignored files never survive a fresh clone. Applications and agents must read from process environment variables.

### 3. [Task 3 — GitHub Actions CI/CD Secret Injection](./task3/README.md)
* **Focus**: Automating credential verification in CI/CD without writing or committing secrets to disk.
* **Workflow**: `.github/workflows/secret-drill.yml` triggered via `workflow_dispatch`.
* **Mechanism**: Secret injected from GitHub Secrets (`${{ secrets.API_TOKEN }}`) directly to the runner environment:
  ```yaml
  - name: Check API_TOKEN availability
    env:
      API_TOKEN: ${{ secrets.API_TOKEN }}
    run: |
      if [ -n "$API_TOKEN" ]; then
        echo "PASS: API_TOKEN is available."
      else
        echo "FAIL: API_TOKEN is not available."
        exit 1
      fi
  ```
* **Result**: Passed (Run #1, Commit `f7b6fb6`), confirming availability without ever logging or exposing the secret value.

---

## 📊 Comprehensive Comparison Matrix

| Dimension | Local `.env` File | Process Environment Variable | GitHub Actions Secret |
| :--- | :--- | :--- | :--- |
| **Storage Location** | Local filesystem (disk) | Active process memory (`process.env` / `$env:`) | Encrypted GitHub vault |
| **Tracked by Git?** | ❌ Excluded via `.gitignore` | ❌ Not tracked | ❌ Not tracked |
| **Survives Fresh Clone?** | ❌ No | ❌ Must be re-set/injected | ✅ Injected by CI/CD runner |
| **Risk of Exposure** | ⚠️ High if accidentally committed | 🟢 Low (isolated to process memory) | 🟢 Very Low (masked in runner logs) |
| **Agent Guidance Needed** | Requires searching files | Explicit prompt (`env var`) avoids confusion | Passed automatically into job step |

---

## 🛡️ Core Security & Engineering Principles Learned

1. **Decouple Code from Secrets**: Never commit API keys, tokens, or private credentials to source control.
2. **Enforce Strict `.gitignore`**: Verify that all sensitive configuration files (`.env`, `.env.local`, `*.pem`) are ignored:
   ```bash
   git check-ignore -v .env
   ```
3. **Inject at Runtime**: Supply credentials via process environment variables, container env vars, or dedicated secret managers (AWS Secrets Manager, HashiCorp Vault, GitHub Secrets).
4. **Agent Context Optimization**: Explicitly tell AI agents where credentials live (e.g., *"The credential is available as environment variable `API_TOKEN`. Do not look for a `.env` file."*) to avoid hallucination or wasted search loops.
5. **Zero-Leak Logging**: Verify token availability (check presence / non-empty) without echoing or logging actual secret strings.
