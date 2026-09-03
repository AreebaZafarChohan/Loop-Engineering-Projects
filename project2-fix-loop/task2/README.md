# Task 2: Node.js & Jest Test Runner Baseline

> **Concepts Covered:**
> - **Concept 11:** Maker-Checker Pattern (Deterministic test verification)
> - **Stack:** Node.js, Jest (CommonJS)

---

## 📌 Overview

This project provides the baseline Jest environment for demonstrating the **Maker-Checker Pattern** in JavaScript/Node.js.

- **Implementation (`math.js`):** Contains basic math utility functions (`add`, `double`).
- **Checker Suite (`math.test.js`):** Contains Jest unit tests defining the required contract and behavior.

---

## 📂 Project Structure

```
task2/
├── math.js          # Math utility functions (add, double)
├── math.test.js     # Jest unit test suite
├── package.json     # Node.js project & test script config
└── README.md
```

---

## 🚀 How to Run

### 1. Install Dependencies
```bash
npm install
```

### 2. Run Test Suite
```bash
npm test
```

### 3. Test Output
```text
PASS ./math.test.js
  ✓ adds two numbers
  ✓ doubles a number
  ✓ adds negative numbers

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
Snapshots:   0 total
Ran all test suites.
```
