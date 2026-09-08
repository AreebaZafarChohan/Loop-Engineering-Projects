---
name: doc-freshness
description: Keep documentation synchronized with current source code in project8-daily-loop/task2
---

# Documentation Freshness Skill

## Goal
Keep documentation synchronized with the current source code.

## Inspect
1. Read the source files under src/.
2. Read the documentation under docs/.
3. Compare documented operations with exported functions.

## Maker Rules
- Update only files under docs/.
- Do not modify source code.
- Do not change function behavior.
- Preserve existing documentation style.
- Add missing operations when they are clearly present in the source code.

## Reviewer Checklist
- Every exported calculator operation is documented.
- Function names and descriptions match the source code.
- No source files were modified.
- Documentation changes are limited to docs/.
