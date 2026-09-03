# Project 1: Watch Loop

> **Difficulty:** Easy  
> **Concept:** Concept 4 (In-session Loop)

---

## 🎯 Main Motive / Objective

> **"Build. Start a long task in your repo (for example, a script that sleeps for a while and then writes a file). Set up an in-session loop that checks every minute whether the task has finished, and tells you the moment it has.**  
> **Done when the loop notices the task finished, says so once, and you can stop it cleanly, and you never sat watching the terminal."**

The goal of this project is to automate monitoring for long-running asynchronous tasks (background jobs/scripts). Instead of manually waiting and staring at terminal output, an automated in-session watch loop polls the environment periodically (e.g., checking for completion artifacts like output files), alerts immediately upon completion, and terminates cleanly.

---

## 📂 Repository Structure

```text
project1-watch-loop/
│
├── task1/
│   ├── README.md           # Task 1 documentation & usage guide
│   ├── long_task.py        # Python script simulating a long-running background task
│   ├── watch_loop.py       # Python script implementing the polling watch loop
│   └── output.txt          # File created upon task completion
│
├── task2/
│   ├── README.md           # Task 2 documentation & usage guide
│   ├── long_task.sh        # Bash script simulating a 3-minute long task
│   └── done.txt            # File generated with completion timestamp
│
└── README.md               # Main project documentation
```

---

## 🚀 Tasks Overview

### 1. [Task 1: Python In-Session Watch Loop](./task1/README.md)
- **Long Task (`long_task.py`):** Runs for 20 seconds and writes `"Task completed!"` to `output.txt`.
- **Watch Loop (`watch_loop.py`):** Polls every 5 seconds checking for the creation of `output.txt`, notifies with `✅ Task finished! output.txt found.`, and exits cleanly.

### 2. [Task 2: Bash Shell / In-Session CLI Watch Loop](./task2/README.md)
- **Long Task (`long_task.sh`):** A shell script running in the background for 180 seconds (3 minutes) and outputting completion timestamp to `done.txt`.
- **Watch Loop:** Monitored via an in-session CLI/Bash loop (or Claude Code `/loop`) checking for `done.txt` and alerting once ready.

---

## 🏁 Success Criteria

- ✅ Background task starts and produces a target completion file.
- ✅ Watch loop polls regularly without user intervention.
- ✅ The moment completion is detected, the loop notifies once and exits cleanly.
- ✅ Zero manual waiting/babysitting the terminal.
