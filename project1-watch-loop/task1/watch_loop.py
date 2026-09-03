import time
import os

print("👀 Watch loop started...")

while True:
    if os.path.exists("output.txt"):
        print("✅ Task finished! output.txt found.")
        break

    print("⏳ Task still running...")
    time.sleep(5)

print("👋 Watch loop stopped.")