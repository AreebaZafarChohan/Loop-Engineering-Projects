# Project 4 (Task 1) — Review Loop with Checker

A complete implementation of an autonomous **Maker-Checker Review Loop** using Claude Code, Git Worktrees, and Skill checklists. This project demonstrates how an implementer agent drafts a bug fix in an isolated environment and an independent reviewer agent validates it against strict rules before opening a pull request.

---

## 1. Overview

In automated engineering workflows, relying solely on whether automated tests pass can result in brittle or cheated implementations (e.g., hardcoded return values, tampered tests, or partial patches). 

This project implements a **Fix Loop with Checker** (Maker-Checker pattern):
- **Implementer (Maker)**: Drafts a bug fix in an isolated Git worktree following instructions defined in a Claude Code skill (`SKILL.md`).
- **Reviewer (Checker)**: A separate evaluation step that independently grades the change with a strict **PASS** or **FAIL** against a formal checklist (checking real `git diff` and running tests).
- **Quality Gate**: A Pull Request (PR) is opened **only when the reviewer gives a PASS**.

---

## 2. Concepts Used

This task demonstrates three core Loop Engineering and Claude Code architectural concepts:

1. **Concept 8 — Git Worktree (`git worktree`)**:
   Enables isolated branching and editing in a clean workspace directory without touching or dirtying the primary working tree or main branch.
2. **Concept 9 — Skill (`SKILL.md`)**:
   Encapsulates domain rules, standard fix procedures, strict boundary constraints, and reviewer criteria in a reusable skill definition.
3. **Concept 11 — Maker-Checker Pattern**:
   Separates code creation from code evaluation. The maker writes and commits the fix; an independent checker inspects the diff and runs validation tests to ensure genuine implementation quality.

---

## 3. The Bug

### Original Buggy Code (`discount.js`)

```javascript
function calculateDiscount(price, percent) {
  return price - percent;   // BUG: percent ko price se subtract kar raha hai
}

module.exports = { calculateDiscount };
```

### Explanation of the Bug
The function was subtracting the `percent` argument as a flat numeric value from `price` rather than computing the proportional percentage discount of the price.
- **Example**: `calculateDiscount(200, 20)` returned `180` (calculating `200 - 20`) instead of the correct discounted price of `160` (calculating `200 - (200 * 20 / 100)`).

---

## 4. Setup

The initial task directory contains the following components:

- **`discount.js`**: Contains the JavaScript implementation of `calculateDiscount` with the formula defect.
- **`discount.test.js`**: Jest unit test suite covering percentage discounts for edge cases (e.g., 10% off 100, 20% off 200).
- **`.claude/skills/fix-discount/SKILL.md` (or `SKILL.md`)**: The skill definition containing the discount formula rule, constraints, step-by-step fix procedures, and the reviewer PASS/FAIL checklist.
- **`package.json`**: NPM project configuration with Jest test runner setup.

---

## 5. The Skill (`SKILL.md`)

The skill file defines explicit requirements for both the maker and the checker:

```markdown
---
name: fix-discount
description: Fix the calculateDiscount percentage formula bug in discount.js without modifying tests.
---

# Fix Discount Skill

## Goal
Fix the `calculateDiscount` function in `discount.js` to correctly apply percentage discounts without modifying test files.

## Rule
`calculateDiscount(price, percent)` must return price minus (`percent%` of price).
- **Formula:** `price - (price * percent / 100)`

## Fix Procedure
1. Inspect `discount.js`.
2. Replace the buggy line with the correct percentage formula: `price - (price * percent / 100)`.
3. Do **NOT** modify or tamper with `discount.test.js`.
4. Run `npm test` and verify that all tests pass.
5. Ensure the fix is a genuine formula implementation, not a hardcoded return value.

## Restrictions
- Do not modify test files (`discount.test.js`).
- Do not weaken, skip, or hardcode test return values.
- Do not claim success unless `npm test` runs and passes completely.

## Reviewer Checklist (PASS / FAIL)
- Does the code use the formula `price - (price * percent / 100)`, not a hardcoded number?
- Do all tests in `discount.test.js` pass when run for real?
- Was `discount.test.js` left completely unmodified?

> **Verdict Rule:**
> - If any answer is **NO**, reply `FAIL` with the specific reason.
> - Only reply `PASS` if the fix is genuine and all tests pass.
```

---

## 6. Workflow Steps

The execution followed a structured Maker-Checker sequence:

### Step 1: Baseline Verification & Skill Definition
- Initialized the buggy `calculateDiscount` function in `discount.js`.
- Confirmed test awareness via `discount.test.js` (tests failing under the buggy flat-rate subtraction).
- Authored `SKILL.md` defining the mathematical rule and reviewer verification checklist.

### Step 2: Implementer (Maker) in Isolated Worktree
- Created a Git worktree on branch `fix/discount-formula`:
  ```bash
  git worktree add -b fix/discount-formula ../worktree-fix-discount
  ```
- Ran the Implementer agent with prompt:
  > *"Read SKILL.md. Fix discount.js following the fix steps exactly. Do not modify discount.test.js. Run npm test to confirm it passes. Then commit your change with git."*
- **Implementer Result**:
  - Replaced buggy code with `return price - (price * percent / 100);`.
  - Executed `npm test` — **2/2 tests passed**.
  - Committed changes to branch `fix/discount-formula`.

### Step 3: Reviewer (Checker) Evaluation — Good Fix
- Ran the Reviewer agent with prompt:
  > *"Read SKILL.md's Reviewer checklist. Show the git diff of the last commit (`git diff HEAD~1 HEAD -- discount.js`). Actually run npm test yourself and check the real output. Based on the checklist and real test results, reply with exactly PASS or FAIL, followed by your reasons."*
- **Reviewer Verdict**: **`PASS`**
  - **Reasons**:
    1. Verified `discount.js` uses the general formula `price - (price * percent / 100)`.
    2. Ran `npm test` independently — all 2 unit tests passed.
    3. Checked git diff and confirmed `discount.test.js` remained untouched.
- Pushed branch `fix/discount-formula` and opened Pull Request [#1](https://github.com/AreebaZafarChohan/Loop-Engineering-Projects/pull/1) with `gh pr create`.

### Step 4: Reviewer (Checker) Evaluation — Deliberately Bad / Hardcoded Fix
- Created a second worktree on branch `fix/bad-attempt`.
- Planted a hardcoded "cheat" implementation designed specifically to fool the unit tests:
  ```javascript
  function calculateDiscount(price, percent) {
    if (price === 100 && percent === 10) return 90;
    if (price === 200 && percent === 20) return 160;
    return price - percent;
  }
  ```
- Ran the same Reviewer prompt against the bad branch.
- **Reviewer Verdict**: **`FAIL`**
  - **Reasons**: Although `npm test` technically passed (2/2) due to hardcoded matches, the reviewer detected that the implementation used hardcoded conditional values rather than the required mathematical formula.
  - **Action**: No PR was opened for this attempt.

---

## 7. Results Table

| Fix Type | Tests Passed | Reviewer Verdict | PR Opened |
|---|---|---|---|
| **Good Fix** (`price - (price * percent / 100)`) | Yes (2/2) | **PASS** | Yes ([PR #1](https://github.com/AreebaZafarChohan/Loop-Engineering-Projects/pull/1)) |
| **Bad/Hardcoded Fix** (hardcoded lookup table) | Yes (2/2, by coincidence) | **FAIL** | No |

---

## 8. Key Lesson

This project demonstrates why an independent checker is vital in autonomous agent workflows:

1. **Automated tests alone are insufficient**: The bad fix achieved a 100% test pass rate on existing test cases, yet the code was fundamentally flawed and unmaintainable.
2. **True Quality Gate**: A soft checker that only inspects `exit code 0` from test runners would have approved the hardcoded cheat.
3. **Skill-Grounded Code Review**: By inspecting the `git diff` against explicit criteria in `SKILL.md`, the checker guarantees semantic correctness, formula integrity, and test suite immutability before any pull request is opened.

---

## 9. How to Reproduce

Follow these steps to reproduce the maker-checker workflow:

1. **Clone the Repository & Install Dependencies**:
   ```bash
   cd project4-review-loop/task1
   npm install
   ```

2. **Verify the Initial Failing State**:
   ```bash
   npm test
   # Notice tests failing with output differences
   ```

3. **Create a Worktree for the Implementer**:
   ```bash
   git worktree add -b fix/discount-formula ../worktree-task1
   cd ../worktree-task1
   ```

4. **Implement the Fix & Commit**:
   - Update `discount.js` with the correct formula: `return price - (price * percent / 100);`.
   - Run `npm test` to verify all tests pass.
   - Commit the fix:
     ```bash
     git add discount.js
     git commit -m "fix(discount): apply correct percentage discount formula"
     ```

5. **Run the Independent Reviewer Check**:
   - Inspect the diff: `git diff HEAD~1 HEAD -- discount.js`.
   - Verify `discount.test.js` was not modified: `git diff HEAD~1 HEAD -- discount.test.js`.
   - Run `npm test` independently.
   - If formula is sound and tests pass, grant **`PASS`**.

6. **Create the Pull Request**:
   ```bash
   git push origin fix/discount-formula
   gh pr create --title "Fix discount calculation formula (task1)" --body "Fixes percentage discount bug. Reviewer: PASS"
   ```

7. **Test the Negative Path (Optional)**:
   - Create a branch `fix/bad-attempt` with hardcoded conditionals.
   - Run the checker prompt to observe the **`FAIL`** evaluation.
