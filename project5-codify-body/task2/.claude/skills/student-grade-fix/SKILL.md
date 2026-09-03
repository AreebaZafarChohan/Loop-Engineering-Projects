---
name: student-grade-fix
description: Fix the student grade calculation bug in src/student_result.py without modifying tests.
---

# Student Grade Fix Skill

## Goal

Fix the student grade calculation bug without modifying tests.

## Fix Procedure

1. Inspect the failing tests.
2. Inspect `src/student_result.py`.
3. Identify why the grade boundaries are incorrect.
4. Modify only the implementation code.
5. Do not modify or delete tests.
6. Run pytest.
7. Confirm that all tests pass.
8. Report exactly what was changed.

## Requirements

- 90 or above must return A.
- 80 or above must return B.
- 70 or above must return C.
- 60 or above must return D.
- Below 60 must return F.

## Restrictions

- Do not modify test files.
- Do not weaken, delete, skip, or bypass tests.
- Do not change pytest configuration to hide failures.
- Do not claim success unless pytest reports all tests passing.
