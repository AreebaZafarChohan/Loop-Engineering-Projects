# Task 2: Python Programmatic Morning Brief & Automation Runner

> **Focus**: Deterministic Implementation of Concept 6 (Unattended Schedule) & Concept 12 (The Spine Pattern) using Python

---

## 🎯 Overview

Task 2 provides a programmatic, deterministic implementation of the Morning Brief loop. Rather than relying solely on LLM prompt parsing, it uses Python modules (`gather.py` and `brief.py`) to systematically scan source code, compare current findings against the persistent spine (`progress.md`), format a morning brief summary, and append only new findings.

---

## 📁 Files in this Folder

| File | Purpose |
| :--- | :--- |
| `app.py` | Python application file with sample business logic and `# TODO` comments. |
| `gather.py` | Scanner module that traverses `*.py` files and extracts TODOs with file name and line number. |
| `brief.py` | Core engine: reads `progress.md`, computes delta (`new_todos`), prints summary, and writes dated updates. |
| `run-brief.ps1` | PowerShell script designed for unattended scheduling (e.g. Windows Task Scheduler / CI). |
| `progress.md` | The persistent state file (Spine) tracking recorded TODOs across runs. |
| `README.md` | Documentation and execution guide for Task 2. |

---

## ⚙️ Architecture & Code Flow

```text
[Scheduled Trigger: run-brief.ps1]
              │
              ▼
         [brief.py]
         ├── 1. Reads 'progress.md' (The Spine)
         ├── 2. Calls gather.py:find_todos() -> Scans codebase (*.py)
         ├── 3. Compares findings: find_new_todos()
         │      └── Filter: [todo for todo in todos if todo not in progress]
         ├── 4. Generates formatted Morning Brief summary
         └── 5. Appends new TODOs to 'progress.md' with current ISO date
```

---

## 🚀 How to Run & Verify

### Step 1: Baseline Execution (Run 1)
Run the brief script:
```powershell
python brief.py
# Or using the PowerShell runner:
.\run-brief.ps1
```

**Output:**
```text
Morning Brief — 2026-09-01

New TODOs found: 3
- app.py:1: # TODO: Add user authentication
- app.py:2: # TODO: Add payment integration
- app.py:3: # TODO: Add email notifications
```

`progress.md` is updated with these initial 3 items.

### Step 2: Immediate Re-run (Proving Non-Duplication)
Run the script again without modifying code:
```powershell
python brief.py
```

**Output:**
```text
Morning Brief — 2026-09-01

No new TODOs found.
```
`progress.md` remains unchanged because the spine already contains all current TODOs.

### Step 3: Adding New Code & Running Delta Pass
Add a new comment in `app.py`:
```python
# TODO: Add SMS verification
```
Run `python brief.py` again. Only `app.py:4: # TODO: Add SMS verification` will be printed and appended to `progress.md`.

---

## 📄 State File (`progress.md`)

```markdown
# Progress Log

## 2026-09-01

- app.py:1: # TODO: Add user authentication
- app.py:2: # TODO: Add payment integration
- app.py:3: # TODO: Add email notifications
```

---

## 💡 Key Lessons
- **Zero Token Cost & High Speed**: Programmatic scanning is instant, free, and deterministic for structured markers like TODOs.
- **Robust Deduplication**: Line-level signatures (`file:line: comment`) prevent accidental duplicate log entries across days.
- **Unattended Ready**: Encapsulating the run command in `run-brief.ps1` allows easy integration into OS schedulers (Cron / Windows Task Scheduler).
