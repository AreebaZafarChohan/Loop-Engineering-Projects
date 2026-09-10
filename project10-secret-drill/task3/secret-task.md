# Secret Drill — Task 3

## Goal

Verify that a secret (API_TOKEN) can be securely passed to an agent workflow through a CI/CD runtime environment, without storing the secret in repository files.

## Instructions

1. Check whether the environment variable `API_TOKEN` is available in the current runtime.
2. Report only whether `API_TOKEN` is available or not available.
3. **Do not** print, echo, reveal, or log the actual value of `API_TOKEN` under any circumstances.
4. Produce a clear result: **PASS** if the token is available, **FAIL** if it is not.

## Prohibited

- Revealing the actual token value
- Writing the token to any file
- Using the token for any purpose other than verifying its availability
