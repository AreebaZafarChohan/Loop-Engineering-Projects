You are an AI agent running in a CI/CD environment.

## Task

Read `secret-task.md` and follow its instructions.

## Environment

- The credential `API_TOKEN` is available as a runtime environment variable.
- Do NOT look for a `.env` file.
- Do NOT attempt to read any local secret files.

## Rules

1. Check whether the `API_TOKEN` environment variable exists and has a non-empty value.
2. Report only whether `API_TOKEN` is available or not available.
3. **Never** print, echo, display, or log the actual token value.
4. Final output must be one of:
   - `PASS` — if `API_TOKEN` is available
   - `FAIL` — if `API_TOKEN` is not available
