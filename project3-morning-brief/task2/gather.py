from pathlib import Path

def find_todos():
    todos = []

    for file in Path(".").rglob("*.py"):
        if file.name in {"gather.py", "brief.py"}:
            continue

        for line_number, line in enumerate(file.read_text().splitlines(), 1):
            if "TODO" in line:
                todos.append(
                    f"{file}:{line_number}: {line.strip()}"
                )

    return todos


if __name__ == "__main__":
    todos = find_todos()

    print("TODOs found:")

    for todo in todos:
        print(f"- {todo}")