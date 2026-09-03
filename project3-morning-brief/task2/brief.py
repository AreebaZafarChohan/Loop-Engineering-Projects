from pathlib import Path
from datetime import date

PROGRESS_FILE = Path("progress.md")


def read_progress():
    return PROGRESS_FILE.read_text(encoding="utf-8")


def find_new_todos(todos, progress):
    return [
        todo for todo in todos
        if todo not in progress
    ]


def make_summary(new_todos):
    today = date.today().isoformat()

    if not new_todos:
        return f"""Morning Brief — {today}

No new TODOs found."""

    lines = [
        f"Morning Brief — {today}",
        "",
        f"New TODOs found: {len(new_todos)}",
    ]

    for todo in new_todos:
        lines.append(f"- {todo}")

    return "\n".join(lines)

def update_progress(new_todos):
    if not new_todos:
        return

    today = date.today().isoformat()

    with PROGRESS_FILE.open("a", encoding="utf-8") as file:
        file.write(f"\n## {today}\n\n")

        for todo in new_todos:
            file.write(f"- {todo}\n")


def main():
    progress = read_progress()

    # Temporary: gather.py ka function use karenge
    from gather import find_todos

    todos = find_todos()
    new_todos = find_new_todos(todos, progress)

    summary = make_summary(new_todos)

    print()
    print(summary)

    update_progress(new_todos)


if __name__ == "__main__":
    main()