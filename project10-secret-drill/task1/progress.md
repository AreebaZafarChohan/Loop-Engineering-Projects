# Project 10 — Secret Drill

## Objective

Demonstrate the difference between a local `.env` file and runtime environment variables in a fresh/cloud-like environment.

## Run 1 — Secret missing

A clean cloud simulation directory was created containing only tracked project files.

The local `.env` file was intentionally NOT copied because it is ignored by Git.

### Evidence

- `git check-ignore -v .env` confirmed `.env` is ignored.
- The fresh cloud simulation contained `.gitignore`, `secret-task.md`, and `prompt-first.txt`.
- `.env` was absent from the fresh environment.
- `API_TOKEN` was removed from the PowerShell environment before the run.
- OpenCode checked for `API_TOKEN` and reported `NOT AVAILABLE`.
- Final environment check also reported `API_TOKEN is NOT available`.

### Result

The agent could not access the credential in the fresh environment.

## Run 2 — Secret supplied through runtime environment

The same clean cloud simulation was used.

The `.env` file was still NOT copied.

Instead, `API_TOKEN` was supplied as a runtime environment variable for the current PowerShell process.

The second prompt explicitly instructed the agent:

- The credential is available as environment variable `API_TOKEN`.
- Do not look for a `.env` file.
- Do not reveal or print the actual token.
- Only report whether the credential is available.

### Evidence

- Environment check reported `API_TOKEN is available`.
- OpenCode checked `$env:API_TOKEN` and reported `API_TOKEN is available`.
- Agent final response was `API_TOKEN is available.`
- The actual token value was not revealed in the transcript.

### Result

The agent successfully detected the credential through the runtime environment.

## Lesson

A local `.env` file does not automatically exist in a fresh cloud/runtime environment, especially when it is excluded by `.gitignore`.

Secrets should be injected into the runtime environment rather than committed to the repository.

The agent should also be told where credentials are available so it does not waste effort searching for a local `.env` file.

## Security Note

The token used in this exercise is a dummy demonstration value.

The actual credential value was not intentionally exposed in the agent transcript.

## Conclusion

Project 10 demonstrates that repository files and runtime secrets are two different things.

- Code and configuration that belongs in Git → repository
- Secrets → runtime environment or secret manager
- Agent instructions → explicitly tell the agent to use environment variables when appropriate
- Verification → inspect the transcript and concrete task result, not only the process exit code
