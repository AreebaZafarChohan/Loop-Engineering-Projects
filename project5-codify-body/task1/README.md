# Project 5 Task 1: Codify the Body (Dynamic Workflows)

## 1. Overview
This project takes the maker-checker fix loop from Project 4 and codifies its orchestration as a re-runnable dynamic workflow script, rather than manually running and prompting each step interactively across turns. By structuring the workflow in code, Claude Code can autonomously spawn isolated subagents in parallel to draft fixes and grade them through independent reviewers without manual intervention.

---

## 2. Concepts Used
- **The Dynamic-Workflows Interlude**: Orchestrating multi-agent pipelines programmatically using execution hooks (`pipeline()`, `parallel()`, `agent()`, `log()`, `phase()`) and strict JSON output schemas.
- **Concept 8 (Worktree)**: Running parallel candidate fix agents in ephemeral, isolated git worktrees (`isolation: 'worktree'`) to prevent file collisions, race conditions, and dirty working trees.
- **Concept 11 (Maker-Checker)**: Decoupling the role of the creator (Maker) from the evaluator (Checker/Reviewer) to ensure objective verification, anti-tampering validation, and high solution fidelity.

---

## 3. The Bugs
The file `utils.js` originally contained three distinct buggy functions:

```javascript
function calculateDiscount(price, percent) {
  return price - percent;   // BUG: percentage formula nahi hai
}

function isPalindrome(str) {
  return str === str;   // BUG: hamesha true return karta hai
}

function average(arr) {
  return arr.reduce((a, b) => a + b, 0);   // BUG: length se divide nahi kiya
}

module.exports = { calculateDiscount, isPalindrome, average };
```

### Bug Explanations:
1. **`calculateDiscount(price, percent)`**: Subtracts `percent` directly from `price` instead of computing the discount amount using the percentage formula `price - (price * percent / 100)`.
2. **`isPalindrome(str)`**: Evaluates identity `str === str`, returning `true` for all inputs rather than verifying if the string reads identically backwards and forwards.
3. **`average(arr)`**: Computes the sum of elements via `reduce` but fails to divide the sum by the array length (`arr.length`).

---

## 4. The Skill (`SKILL.md`)
The domain instructions and evaluation criteria defined in `.claude/skills/fix-utils-bugs/SKILL.md`:

### Fix Rules:
- `calculateDiscount(price, percent) = price - (price * percent / 100)`
- `isPalindrome(str)` must correctly check if `str` reads the same backward.
- `average(arr) = sum of arr divided by arr.length`

### Reviewer Checklist (PASS or FAIL):
- Is the fix a genuine logic fix (not hardcoded to pass just the given tests)?
- Do all related tests pass when run for real (`npm test`)?
- Was `utils.test.js` left unmodified?
- *Reply `FAIL` with reasons if any checklist answer is no.*

---

## 5. The Workflow Prompt
The exact plain-English instruction given to Claude Code to initiate orchestration:

> "Use a workflow to draft fixes for these three bugs (calculateDiscount, isPalindrome, average in utils.js) in parallel worktrees, following SKILL.md, and have a separate reviewer agent grade each fix PASS or FAIL against the checklist. Show me the verdict for each."

---

## 6. How It Ran
1. **Agent Fan-out**: Claude Code spun up **6 background agents** in total:
   - **3 Maker Agents**: Executed in parallel, each isolated in its own dedicated git worktree (`isolation: 'worktree'`). Each maker inspected the respective bug, applied the code fix to `utils.js`, ran the test suite (`npm test`), and generated a git diff.
   - **3 Reviewer Agents**: Independently evaluated each fix diff against the checklist rules, verified test suite integrity, and enforced structured schema verdicts.
2. **Execution Flow**: Driven seamlessly by the `pipeline()` construct in the background with zero intermediate step-by-step human prompting.

---

## 7. Results Table

| Function | Verdict | Genuine Fix | Tests Passed |
|:---|:---:|:---:|:---:|
| `calculateDiscount` | **PASS** | Yes | Yes |
| `isPalindrome` | **PASS** | Yes | Yes |
| `average` | **PASS** | Yes | Yes |

---

## 8. Saving as a Command
Once executed, the dynamic workflow was saved from the `/workflows` view by pressing `s`. This created a reusable command:
- **Command Name**: `/fix-and-review-utils-bugs`
- **Script Location**: `.claude/workflows/fix-and-review-utils-bugs.js` (at the repository root)
- **Invocation**: The workflow can now be re-executed directly at any time by typing `/fix-and-review-utils-bugs` or calling `Workflow({ name: "fix-and-review-utils-bugs" })`.

---

## 9. Proving No Memory (The Key Lesson)
When the saved command `/fix-and-review-utils-bugs` was re-run in a brand new Claude Code session:
- It executed the entire draft-and-review process again completely from scratch.
- New task IDs were assigned, new ephemeral worktrees were provisioned, and fresh maker/reviewer agents ran independently without awareness of previous executions.
- **The Core Lesson**: A dynamic workflow script has **no memory** of past executions. It operates as a stateless execution engine, not an autonomous, state-tracking loop.

---

## 10. Engine vs Loop
A dynamic workflow represents the **body** of one execution beat, rather than a self-sustaining loop.

```text
┌────────────────────────────────────────────────────────┐
│                      TRUE LOOP                         │
│                                                        │
│   ┌───────────────┐     reads/writes    ┌──────────┐   │
│   │   Heartbeat   │ ──────────────────► │  Spine   │   │
│   │ (/loop, cron) │                     │(prog.md) │   │
│   └───────┬───────┘                     └────┬─────┘   │
│           │ triggers                         │         │
│           ▼                                  ▼ tracks  │
│   ┌────────────────────────────────────────────────┐   │
│   │                  Engine / Body                 │   │
│   │         (Dynamic Workflow Execution)           │   │
│   │      [Maker Agents] ──► [Reviewer Agents]      │   │
│   └────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────┘
```

To transform this execution body into a true autonomous loop, two critical components are required:
1. **A Heartbeat**: A scheduling trigger (such as `/loop`, dynamic wakeup, or a recurring cron schedule) that fires the workflow automatically at defined intervals without manual human invocation.
2. **A Spine**: A persistent state tracker (e.g., `progress.md` or a durable state file) that successive runs read from and write to, allowing future runs to recognize completed tasks and pick up where previous runs left off instead of starting from zero every time.

---

## 11. How to Reproduce
1. **Navigate to the Project Directory**:
   ```bash
   cd D:\Gemini_Cli\Loop-Engineering\project5-codify-body\task1
   ```
2. **Inspect Code and Tests**:
   Ensure `utils.js` contains the 3 original bugs and `utils.test.js` provides test coverage.
3. **Review Domain Skill**:
   Check `.claude/skills/fix-utils-bugs/SKILL.md` for fix rules and checklist criteria.
4. **Trigger the Dynamic Workflow**:
   Run the workflow prompt in Claude Code or invoke the saved slash command:
   ```bash
   /fix-and-review-utils-bugs
   ```
5. **Observe Execution & Verification**:
   Monitor the parallel worktree makers and independent reviewers completing the pipeline with structured PASS verdicts.
