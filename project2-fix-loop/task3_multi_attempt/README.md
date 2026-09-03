# Task 3: Multi-Attempt Fix Loop (Node.js & Jest)

> **Concepts Covered:**
> - **Concept 5:** Conditional Loop (Keep iterating until condition is met or capped)
> - **Concept 11:** Maker-Checker Pattern (Agent modifies code; Test runner verifies correctness)
> - **Difficulty:** Easy to Medium

---

## 📌 Overview

This project demonstrates an agentic loop engineering pattern where an AI agent (**Maker**) iterates to fix multiple bugs in implementation code (`calc.js`), while an external deterministic test suite (**Checker** via `npm test`) serves as the single source of truth for completion.

The loop is capped at a maximum of **6 attempts**, ensuring the process halts cleanly whether tests pass or reach the safety limit.

---

## 🎯 The Lesson & Core Philosophy

1. **Test Runner is the Checker:** The agent does not declare itself "done" based on assumption or confidence. Only an exit code of `0` from `npm test` indicates success.
2. **Untouchable Test Suite:** `calc.test.js` is never modified to make tests pass artificially.
3. **Multi-Step Bug Diagnosis:** The agent diagnoses test failures one-by-one or across iterations and refines implementation until all assertions pass.

---

## 🐛 Bugs Fixed in `calc.js`

| Function | Bug Description | Expected Behavior / Fix |
| :--- | :--- | :--- |
| `divide(a, b)` | Did not handle division by zero | Throws `Error('Cannot divide by zero')` when `b === 0` |
| `isEven(n)` | Inverted logic (`n % 2 === 1`) | Returns `n % 2 === 0` |
| `factorial(n)` | Base case returned `0` for `0!` | Returns `1` when `n === 0` (`0! = 1`) |

---

## 🧪 Test Suite (`calc.test.js`)

The test suite contains 6 tests covering normal execution and edge cases:
- `divides normally`
- `divide by zero throws error`
- `isEven works for even numbers`
- `isEven works for odd numbers`
- `factorial of 0 is 1`
- `factorial of 5 is 120`

---

## 🚀 How to Run

### 1. Install Dependencies
```bash
npm install
```

### 2. Run Tests (Checker)
```bash
npm test
```

### 3. Verification Output
```text
PASS ./calc.test.js
  ✓ divides normally (2 ms)
  ✓ divide by zero throws error (1 ms)
  ✓ isEven works for even numbers
  ✓ isEven works for odd numbers
  ✓ factorial of 0 is 1
  ✓ factorial of 5 is 120

Test Suites: 1 passed, 1 total
Tests:       6 passed, 6 total
Snapshots:   0 total
Time:        ...
Ran all test suites.
```
