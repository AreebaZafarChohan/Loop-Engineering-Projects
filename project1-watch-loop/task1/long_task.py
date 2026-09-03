import time

print("Long task started...")

time.sleep(20)

with open("output.txt", "w") as f:
    f.write("Task completed!")

print("Long task finished!")