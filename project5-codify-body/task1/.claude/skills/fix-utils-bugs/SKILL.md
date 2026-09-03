---
name: fix-utils-bugs
description: Fix bugs in utils.js according to rules without modifying tests.
---

# Skill: Fixing utils.js bugs

## Rules
- calculateDiscount(price, percent) = price - (price * percent / 100)
- isPalindrome(str) must correctly check if str reads the same backward
- average(arr) = sum of arr divided by arr.length

## Reviewer checklist (PASS or FAIL)
- Is the fix a genuine logic fix (not hardcoded to pass just the given tests)?
- Do all related tests pass when run for real (npm test)?
- Was utils.test.js left unmodified?
- Reply FAIL with reasons if any answer is no.
