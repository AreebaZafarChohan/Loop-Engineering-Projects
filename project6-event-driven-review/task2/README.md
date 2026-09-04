# Project 6: Automated PR Review via Event-Driven Heartbeat (OpenCode)

## 1. Overview
This project makes a repository review its own pull requests automatically using an **event-driven heartbeat**—a GitHub Actions workflow triggered by `pull_request` events. Instead of relying on a manual Claude Code Routine or an open interactive session, this automated review agent is built using the **OpenCode GitHub integration**.

---

## 2. Concepts Used
- **Concept 7: Event-Driven Heartbeat** — Automated workflows that activate reactively in response to external events (such as Git webhooks or CI/CD lifecycle triggers) rather than polling on a timer or running interactively.
- **Concept 10: Connectors & Integrations** — Bridging AI agent capabilities directly into existing developer platforms (GitHub Actions, PR review threads, webhook receivers) to act natively within standard developer workflows.

---

## 3. Setup
The setup was initialized by executing the following command once at the repository root:

```bash
opencode github install
```

This generated the workflow configuration at `.github/workflows/opencode.yml`. The workflow is configured to listen for standard `pull_request` event activity types:
- `opened`
- `synchronize`
- `reopened`
- `ready_for_review`

On every PR opened or updated in the repository, GitHub Actions spins up an OpenCode review agent that analyzes the changes and posts feedback directly back to GitHub.

---

## 4. The File Under Test
The baseline implementation in `array-utils.js` was clean, properly guarded, and verified against edge cases:

```javascript
function getItemAt(arr, index) {
  if (arr === null || arr === undefined) {
    return undefined;
  }
  if (index < 0 || index >= arr.length) {
    return undefined;
  }
  return arr[index];
}
```

---

## 5. The Planted Bugs
A separate branch named `bug/off-by-one-array` was created and pushed with deliberate defects introduced into `array-utils.js`:

```javascript
function getItemAt(arr, index) {
  if (index < 0 || index > arr.length) {
    return undefined;
  }
  return arr[index];
}
```

### Planted Defect Breakdown:
1. **Off-by-One Error**: Changed the upper bounds check from `>= arr.length` to `> arr.length`. When `index === arr.length`, the function fails to exit early and attempts to access an out-of-range element.
2. **Removed Null/Undefined Guard**: Removed the `arr === null || arr === undefined` check entirely. Passing `null` or `undefined` will now cause a `TypeError: Cannot read properties of null/undefined (reading 'length')` rather than returning `undefined` safely.

---

## 6. What Happened
1. A pull request was opened from `bug/off-by-one-array` into `main`.
2. The `pull_request` event automatically triggered the `.github/workflows/opencode.yml` GitHub Actions workflow—requiring no manual command or prompt from the developer.
3. The OpenCode agent:
   - Checked out the PR branch.
   - Computed and analyzed the diff against `main`.
   - Identified logic errors, edge cases, and missing guards.
   - Posted a detailed review comment directly on the pull request.

---

## 7. The Review Result
The automated review agent successfully caught **both planted bugs** with high precision:

- **Missing Null Guard**: Flagged missing checks for `null` and `undefined` with file and line locations, explaining the resulting runtime crash.
- **Off-by-One Bounds Error**: Highlighted the boundary condition vulnerability where `arr[arr.length]` evaluated to an out-of-bounds access.
- **Proposed Fix**: Provided the exact corrected implementation restoring safe behavior.
- **Verdict**: Issued a **Request changes** status on the pull request.

---

## 8. Event Heartbeat, Proven
This project validates the mechanics of an event-driven heartbeat:
- **Zero Idle Overhead**: No background processes, active terminal sessions, polling loops, or cron schedules were maintained.
- **Purely Event-Driven**: The workflow executed solely because a `pull_request` event was emitted by GitHub.
- **Continuous Lifecycle Support**: Pushing an additional commit to the open PR automatically triggers the `synchronize` event, causing the exact same review heartbeat to re-fire and evaluate the updated diff.

---

## 9. All Four Heartbeats, Completed
With the completion of this project, all four primary agent heartbeat architectures have been demonstrated hands-on across the course:

| Project | Heartbeat Type | Execution Model |
|---|---|---|
| **Project 1** | In-Session Heartbeat | Interactive loop within an active CLI/agent session |
| **Project 2** | Conditional / Run-Until-Done | Agent loops until an exit condition or test suite passes |
| **Project 3** | Scheduled Heartbeat | Time-based periodic execution via Cron schedules |
| **Project 6** | Event-Driven Heartbeat | Reactive execution triggered by external events (GitHub PRs) |

---

## 10. How to Reproduce
Follow these steps to reproduce this automated PR review setup:

1. **Install OpenCode GitHub Workflow**:
   ```bash
   opencode github install
   ```
2. **Configure Secrets**:
   - Add `ANTHROPIC_API_KEY` (or the respective LLM API key) to your repository's **GitHub Secrets** (`Settings > Secrets and variables > Actions`).
3. **Commit Clean Baseline**:
   - Push the clean baseline version of `array-utils.js` to `main`.
4. **Plant Bugs on a Branch**:
   - Create and checkout a new branch (e.g., `git checkout -b bug/off-by-one-array`).
   - Introduce the off-by-one and null-safety defects, commit, and push to GitHub.
5. **Open Pull Request & Verify**:
   - Open a pull request against `main`.
   - Check the **Actions** tab to watch the workflow execute and inspect the PR conversation tab for the automated review comment and verdict.
