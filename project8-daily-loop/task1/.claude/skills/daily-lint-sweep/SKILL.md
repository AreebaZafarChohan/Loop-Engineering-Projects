---
name: daily-lint-sweep
description: Run daily lint sweep with npm run lint, fix reported errors safely with minimal changes, and review.
---

# Skill: Daily Lint Sweep

## Rule
Run `npm run lint`. Fix every reported error using the safest, most minimal
change that resolves it without changing behavior:
- `no-var` → change `var` to `let` or `const`
- `no-unused-vars` → remove the unused variable, or use it if it was meant to be used
- `prefer-const` → change `let` to `const` if the variable is never reassigned
- `eqeqeq` → change `==` to `===` and `!=` to `!==`

## Fix steps
1. Run `npm run lint` and read every error
2. Fix each one in place, following the rules above
3. Do not change any function's behavior or output
4. Re-run `npm run lint` to confirm zero errors remain
5. Commit with message: "lint: fix N issues (automated sweep)"

## Reviewer checklist (grade PASS or FAIL)
- Does `npm run lint` report zero errors when run for real?
- Was any function's logic or behavior changed (not just style)?
- Were any lint rules disabled or suppressed (e.g. eslint-disable comments) instead of actually fixed?
- If lint is not clean, or logic changed, or rules were suppressed instead of fixed: FAIL with reasons.
- Only PASS if lint is genuinely clean and no suppression was used.
