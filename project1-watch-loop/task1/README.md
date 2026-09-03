# Task 1: Python-based Watch Loop

This task demonstrates an in-session polling watch loop implemented in Python.

---

## 📁 Files

- `long_task.py`: Simulates a long-running workload (`time.sleep(20)`), then writes `"Task completed!"` into `output.txt`.
- `watch_loop.py`: Runs a polling loop that inspects the directory for `output.txt` every 5 seconds.
- `output.txt`: Artifact created upon task completion.

---

## ⚙️ How to Run

### Step 1: Clean up any old output
```bash
rm -f output.txt
```

### Step 2: Start the long-running task in the background
```bash
python long_task.py &
```

### Step 3: Start the watch loop
```bash
python watch_loop.py
```

---

## 💡 Expected Output

```text
👀 Watch loop started...
⏳ Task still running...
⏳ Task still running...
⏳ Task still running...
⏳ Task still running...
✅ Task finished! output.txt found.
👋 Watch loop stopped.
```
