# Project 11: The Human Gate — Draft, Review, Approve

## Goal
Build a real human-in-the-loop approval gate using two routines: one that drafts something reviewable, and one that only acts when explicitly triggered with a bearer token via curl.

## Routine A — Draft
- Ran a one-off task that created branch `claude/release-draft`, wrote `DRAFT.md` summarizing the last 3 commits, and committed it — without merging to main.
- The draft was reviewed manually before any further action was taken.

## Routine B — API-Triggered Follow-up
- A local Node.js server (`gate-server.js`) listens on port 3939. It only performs its action (merging `claude/release-draft` into `main`) when it receives a POST request with the correct `Authorization: Bearer <token>` header.
- A random token was generated once and saved immediately to `gate_token.txt` (gitignored, never committed).
- Routine B never ran on its own — it stayed idle until a manual `curl` command supplied the correct token.

## Approval
- Reviewed `DRAFT.md` manually.
- Fired the approval with: `curl.exe -X POST http://localhost:3939 -H "Authorization: Bearer <token>"`
- Server transcript confirmed the actual merge happened (`Merge made by the 'ort' strategy`), and the response was echoed back to the caller.

## A6 Checklist
1. **Connectors pruned** — no unused external connectors/integrations were active for this exercise; only local git and a local server were used.
2. **Unrestricted pushes off** — noted that for a real shared repo, branch protection rules (blocking force-push, requiring PR review) should be enabled on `main` via GitHub settings. This is a local single-user repo for the drill.
3. **State file chosen** — `APPROVED.md` records that the merge was approved, with a timestamp, to prevent accidental duplicate merges from a stale or replayed trigger.

## The Lesson
Automation should never decide on its own when to publish or merge a change. A draft is produced, a human reviews it, and only an explicit, secured trigger (a bearer-token-protected API call) causes the follow-up action. This is the mechanical shape of a human approval gate.

## Files
- runA_transcript.txt — transcript of Routine A creating the draft
- runB_response.txt — response from the approval curl call
- gate-server.js — the local API-trigger server simulating Routine B
- APPROVED.md — the state file recording approval
