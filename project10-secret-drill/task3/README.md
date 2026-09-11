# Project 10 — Secret Drill: Task 3

## Purpose

This task demonstrates how to securely pass a secret (API_TOKEN) into a CI/CD runtime environment without storing the secret in repository files. It validates the use of GitHub Actions secrets for injecting credentials at runtime.

## Objective

Verify that `API_TOKEN` is available as a runtime environment variable in the GitHub Actions workflow, and output `PASS` if present or `FAIL` if not—without ever exposing the secret’s value.

## How It Works

```
GitHub Secret (API_TOKEN)
  → GitHub Actions workflow (workflow_dispatch)
  → Runtime environment variable (API_TOKEN)
  → Availability check
  → Result: PASS or FAIL
```

The workflow manually triggered via `workflow_dispatch` injects the GitHub secret into the job’s environment. A shell step then checks if the variable is set and non‑empty, printing `PASS` or `FAIL` accordingly.

## Security Rules

- **API_TOKEN must never be printed, echoed, or logged.**
- **API_TOKEN must never be written to any file.**
- **API_TOKEN must not be hard‑coded in the repository.**
- **Only availability is checked** (presence and non‑empty value).
- **The secret value must remain hidden** throughout the entire process.

## Files

| File | Purpose |
|------|---------|
| `secret-task.md` | Defines the goal, instructions, and prohibited actions for the task. |
| `prompt.md` | Provides the AI agent with environment context and rules for executing the task. |
| `progress.md` | Tracks progress (currently empty). |
| `../.github/workflows/secret-drill.yml` | GitHub Actions workflow that runs the availability check. |

## GitHub Actions Workflow

The workflow (`secret-drill.yml`) uses:

- **`workflow_dispatch`** – allows manual triggering.
- **`secrets.API_TOKEN`** – injects the stored secret as the runtime environment variable `API_TOKEN`.

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

## Verification / Evidence

| Field | Value |
|-------|-------|
| Workflow | Project 10 — Secret Drill |
| Run | #1 |
| Job | Verify API_TOKEN Availability |
| Status | Success |
| Branch | main |
| Commit | `f7b6fb6` |
| Duration | 8 seconds |
| Trigger | Manually triggered |

The job completed successfully, confirming that `API_TOKEN` was available as a runtime environment variable.

## Result

Task 3 successfully demonstrated secure runtime secret availability. The `API_TOKEN` was injected via GitHub Actions secrets and verified to be present without exposing its value.

## Lessons Learned

| Storing secrets in repository/local files | Injecting secrets at runtime via CI/CD |
|-------------------------------------------|----------------------------------------|
| Secrets are visible in source control history. | Secrets never enter the repository. |
| Risk of accidental exposure through logs or files. | Only availability is checked; value remains hidden. |
| Requires manual management of `.env` files. | Managed centrally in GitHub repository settings. |
| Not scalable for multiple environments. | Easily rotated and audited. |

By injecting secrets at runtime, we maintain security while enabling automated verification of credential availability.