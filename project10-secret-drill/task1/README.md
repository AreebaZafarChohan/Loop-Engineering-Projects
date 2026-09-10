# Project 10 — Secret Drill

A hands-on engineering exercise demonstrating the fundamental difference between a local `.env` file and runtime environment variables in a fresh/cloud-like environment.

---

## 1. Objective

The objective of this project is to demonstrate:
- Why a local `.env` file does not automatically reach a fresh or cloud-like runtime environment.
- How `.gitignore` protects secrets from being committed to version control.
- How runtime environment variables reliably supply secrets to applications and AI agents.
- Why explicit agent prompting regarding credential locations optimizes agent workflows.
- Why transcript and artifact inspection is necessary over simple process exit codes.

---

## 2. Project Concept

In software development and AI engineering, applications frequently need access to API tokens, credentials, and private keys. 

- **Local `.env` vs. Cloud Runtime**: Developers often store secrets locally in a `.env` file. However, `.env` files are excluded from version control via `.gitignore` to prevent secret leakage.
- **The Role of `.gitignore`**: When code is pushed to a remote repository and cloned into a fresh CI/CD runner, container, or cloud instance, ignored files (like `.env`) are naturally absent.
- **Supplying Secrets**: Secrets must therefore be injected directly into the runtime process environment (e.g., via environment variables or secret management tools like AWS Secrets Manager, HashiCorp Vault, or GitHub Secrets) rather than committed files.

---

## 3. Project Structure

The files present in the task directory:

```text
task1/
├── .env                  # Local file containing dummy demonstration credential (ignored by Git)
├── .gitignore            # Excludes .env from version control
├── progress.md           # Authoritative record of drill runs, evidence, and conclusions
├── prompt-first.txt      # Prompt used during Run 1 (missing secret scenario)
├── README.md             # Project documentation and summary
├── secret-check.ps1      # PowerShell helper script
├── secret-task.md        # Task description outlining credential requirement
├── transcript-first.log  # Run 1 log file
└── transcript-second.log # Run 2 log file
```

---

## 4. Run 1 — Missing Secret

### Experiment Setup
- A clean temporary directory was created to simulate a fresh cloud environment clone.
- Only tracked Git files were copied; the local `.env` file was intentionally excluded.
- The `API_TOKEN` variable was removed from the active PowerShell environment.
- The agent (OpenCode) was executed using the instructions in `prompt-first.txt` to find `API_TOKEN` and complete `secret-task.md`.

### Observed Result
```text
NOT AVAILABLE
```
Environment check confirmed: `API_TOKEN is NOT available`.

### Why This Happened
The local repository had a `.env` file, but the fresh cloud simulation environment did not. Because `.env` is tracked in `.gitignore`, it does not travel with the repository. Without injecting the secret into the runtime environment, the agent could not access `API_TOKEN`.

```text
Local .env ──(Blocked by .gitignore)──x Not Committed ──> Fresh Cloud Runtime (No .env / No API_TOKEN)
```

---

## 5. Run 2 — Runtime Environment Secret

### Experiment Setup
- The same clean cloud simulation environment was used.
- The `.env` file remained completely absent.
- `API_TOKEN` was supplied directly to the runtime process as an environment variable in PowerShell.
- The prompt explicitly instructed the agent:
  - The credential is available as an environment variable `API_TOKEN`.
  - Do not look for a `.env` file.
  - Do not reveal or print the actual token value.
  - Only report whether the credential is available.

### Observed Result
```text
API_TOKEN is available.
```

### Outcome
The agent detected the credential directly from the runtime environment without searching for `.env` and without leaking the secret value in the output.

---

## 6. Run Comparison

| Condition / Dimension | Run 1 (Missing Secret) | Run 2 (Runtime Environment) |
| :--- | :--- | :--- |
| **Fresh / Cloud Environment** | Yes | Yes |
| **`.env` File Present** | No | No |
| **`API_TOKEN` Environment Variable** | No | Yes |
| **Agent Result** | `NOT AVAILABLE` | `API_TOKEN is available` |
| **Secret Value Exposed** | No | No |

---

## 7. Security Lesson

- **Never commit secrets**: Real API keys, passwords, access tokens, and credentials must never be committed to Git.
- **Maintain `.gitignore`**: Keep `.env` and similar configuration files strictly listed in `.gitignore`. Verify with:
  ```bash
  git check-ignore -v .env
  ```
- **Use Runtime Injection**: Always inject secrets into applications and agent environments via runtime environment variables or secure secret managers.

---

## 8. Agent Lesson

Agents should be given explicit instructions on where credentials reside. Providing context such as:
> *"The credential is available as environment variable `API_TOKEN`. Do not look for a `.env` file."*

prevents the agent from hallucinating, failing unnecessarily, or wasting cycles searching for local files that do not and should not exist in cloud runtimes.

---

## 9. Verification Lesson

An execution exit code alone (e.g., `0`) is insufficient to confirm that an agent task succeeded. An agent may exit cleanly while failing to retrieve the required credential or perform the task. Proper verification requires inspecting:
- Agent transcripts and output text.
- Concrete task artifacts and runtime state.
- Security boundaries (verifying secrets are not printed or leaked).

---

## 10. Final Result

**Project 10 — Secret Drill proved that repository files and runtime secrets are distinct layers.**

1. **Repository**: Contains source code, documentation, safe configuration, and prompt templates.
2. **Runtime Environment**: Contains execution-specific secrets injected at runtime.
3. **Outcome**: Moving agentic workflows from local development to fresh cloud environments requires decoupled, secure runtime secret injection.
