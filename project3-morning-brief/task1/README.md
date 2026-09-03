# Task 1: Prompt-Driven Morning Brief Loop (The Spine Pattern)

> **Focus**: Concept 12 (The Spine Pattern) & Concept 6 (Unattended Schedule) via LLM Prompting

---

## 🎯 Overview

Task 1 implements the Morning Brief pattern using prompt-based state evaluation over a JavaScript codebase. It demonstrates how an AI agent uses `progress.md` as an external memory "spine" to prevent agent amnesia across multiple loop cycles.

---

## 📁 Files in this Folder

| File | Purpose |
| :--- | :--- |
| `app.js` | Sample JavaScript application file containing authentication logic and `TODO` comments. |
| `utils.js` | Sample utility functions containing array manipulation and `TODO` comments. |
| `progress.md` | The persistent state file (Spine) logging dated findings and delta updates. |
| `README.md` | Task documentation, walkthrough, and verification report. |

---

## 🛠️ Step-by-Step Walkthrough & Verification

### 1. Initial State
- `app.js` contained 3 initial TODOs (`input validation`, `password hashing`, `tests for logout`).
- `utils.js` contained 1 initial TODO (`handle edge case when array is empty`).
- `progress.md` started empty (`(No runs yet)`).

### 2. First Run (Baseline Capture)
**Agent Instruction:**
> *"Read progress.md. Scan this repo for all TODO comments. Write a short summary of what you found (file names and TODO text). Append a new dated entry to progress.md with this summary. Do not repeat anything already logged."*

**Outcome:**
The agent captured 4 initial TODOs and logged the baseline entry under `## 2026-09-01`.

### 3. Code Modification (Introducing New Delta)
Added a new TODO comment to `app.js`:
```javascript
// TODO: add rate limiting to login
```

### 4. Second Run (Delta Detection & Non-Duplication)
**Agent Instruction:**
> *"Read progress.md. Scan this repo for all TODO comments. Compare with what's already logged. Only report and append NEW TODOs not already in progress.md. Update progress.md with a new dated entry."*

**Outcome:**
The agent compared the codebase against `progress.md` and only recorded the 1 new entry under `## 2026-09-01 (Update)`.

---

## 📄 Final `progress.md` Verification

```markdown
# Progress Log

(No runs yet)

## 2026-09-01
Found 4 TODO comments across 2 files:
- `app.js`:
  - Line 1: `// TODO: add input validation`
  - Line 3: `// TODO: hash the password before saving`
  - Line 7: `// TODO: write tests for logout`
- `utils.js`:
  - Line 1: `// TODO: handle edge case when array is empty`

## 2026-09-01 (Update)
Found 1 new TODO comment:
- `app.js`:
  - Line 12: `// TODO: add rate limiting to login`
```

---

## 💡 Key Lessons
- Stateless LLM prompts become stateful when tethered to a structured log file (`progress.md`).
- Explicit prompting to "Compare with what is already recorded" enables clean delta tracking.
