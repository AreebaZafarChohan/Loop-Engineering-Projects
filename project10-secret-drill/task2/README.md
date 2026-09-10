# Project 10: The Secret Drill — .env vs Environment Variables

## Goal
Prove that a gitignored .env file never survives a fresh clone (like a cloud routine run would create), and that credentials must be passed via environment variables instead.

## Setup
- Created a dummy token in a `.env` file: `DUMMY_TOKEN=sk-fake-12345`
- Added `task2/.env` to `.gitignore` so it would never be committed.
- Committed a dummy `app.js` that "needs" the token.
- Simulated a cloud clone by running `git clone .` into a separate folder.

## Run 1 — Reading from .env (FAILED)
- Prompt: "Read the DUMMY_TOKEN value from a .env file in this directory and use it to construct an Authorization header like 'Bearer <token>'. Print the header."
- Exit code: 0 (still "green"!)
- Result: The .env file did not exist in the fresh clone. The tool call to read it was auto-rejected because the file was missing. No header was produced.

## Run 2 — Reading from an environment variable (SUCCESS)
- Set `$env:DUMMY_TOKEN = "sk-fake-12345"` directly in the shell (simulating a cloud environment-variables panel).
- Prompt: "Credentials are available as environment variables; do not look for a .env file. Read the DUMMY_TOKEN environment variable and use it to construct an Authorization header like 'Bearer <token>'. Print the header."
- Exit code: 0
- Result: Successfully printed `Authorization: Bearer sk-fake-12345`.

## The Lesson (A4)
A .gitignore entry only controls whether a file is committed and pushed to GitHub. A fresh clone only contains files that Git has tracked — so a gitignored .env file is physically absent from any new clone, cloud runner, or CI/CD environment, even though it exists locally.

**One-sentence takeaway:** Gitignored files never reach GitHub, so a fresh cloud clone never contains them — secrets must be passed as environment variables, not files.

## Files
- run1_transcript.txt — transcript of the failed .env-based run
- run2_transcript.txt — transcript of the successful environment-variable run
