# Task 2: Bash Script Background Task & Watch Loop

This task demonstrates a shell-based background job and in-session terminal/CLI watch loop.

---

## 📁 Files

- `long_task.sh`: Simulates a 3-minute long job (`sleep 180`), then writes the completion timestamp into `done.txt`.
- `done.txt`: Artifact created upon completion.

---

## ⚙️ How to Run

### Step 1: Clean up any previous run files
```bash
rm -f done.txt
```

### Step 2: Run the script in the background
```bash
bash long_task.sh &
```

### Step 3: Run the in-session Watch Loop

#### Option A: Using a Bash one-liner polling loop
```bash
while [ ! -f done.txt ]; do
  echo "⏳ Checking... Task still running ($(date +%T))"
  sleep 10
done
echo "✅ Task finished! Content: $(cat done.txt)"
```

#### Option B: Using Claude Code `/loop` command
```text
/loop 1m check if task2/done.txt exists and notify me if completed
```

---

## 💡 Expected Output

```text
⏳ Checking... Task still running (12:00:00)
⏳ Checking... Task still running (12:00:10)
...
✅ Task finished! Content: Task finished at Tue Sep  1 12:03:00 2026
```
