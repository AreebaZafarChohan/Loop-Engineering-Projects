export const meta = {
  name: 'fix-and-review-utils-bugs',
  description: 'Fix utils.js bugs in parallel worktrees and independently review each against checklist',
  phases: [
    { title: 'Draft Fixes', detail: 'Parallel worktree agents fixing each bug' },
    { title: 'Review', detail: 'Reviewer agents validating fixes against checklist' }
  ]
};

const BUGS = [
  {
    fn: 'calculateDiscount',
    target: 'calculateDiscount(price, percent)',
    rule: 'calculateDiscount(price, percent) = price - (price * percent / 100)',
    task: 'Fix the calculateDiscount function in utils.js. Ensure you run npm test or node test to verify. Do not modify utils.test.js.'
  },
  {
    fn: 'isPalindrome',
    target: 'isPalindrome(str)',
    rule: 'isPalindrome(str) must correctly check if str reads the same backward',
    task: 'Fix the isPalindrome function in utils.js. Ensure you run npm test or node test to verify. Do not modify utils.test.js.'
  },
  {
    fn: 'average',
    target: 'average(arr)',
    rule: 'average(arr) = sum of arr divided by arr.length',
    task: 'Fix the average function in utils.js. Ensure you run npm test or node test to verify. Do not modify utils.test.js.'
  }
];

const REVIEW_SCHEMA = {
  type: 'object',
  properties: {
    fn: { type: 'string' },
    verdict: { type: 'string', enum: ['PASS', 'FAIL'] },
    genuineLogicFix: { type: 'boolean' },
    testsPass: { type: 'boolean' },
    testFileUnmodified: { type: 'boolean' },
    reasoning: { type: 'string' },
    fixedCode: { type: 'string' }
  },
  required: ['fn', 'verdict', 'genuineLogicFix', 'testsPass', 'testFileUnmodified', 'reasoning', 'fixedCode']
};

const results = await pipeline(
  BUGS,
  async (bug) => {
    log(`Drafting fix for ${bug.fn} in isolated worktree...`);
    const fixResult = await agent(
      `You are in an isolated worktree for fixing the ${bug.fn} bug in utils.js.
Requirements:
- Rule: ${bug.rule}
- ${bug.task}
- utils.test.js MUST NOT be modified.
- Make the edit directly in utils.js.
- Verify tests using bash: npx jest or npm test.
- Output the git diff and the updated function implementation in your final response.`,
      {
        label: `fix:${bug.fn}`,
        phase: 'Draft Fixes',
        isolation: 'worktree'
      }
    );
    return { bug, fixResult };
  },
  async ({ bug, fixResult }) => {
    log(`Reviewing fix for ${bug.fn}...`);
    const review = await agent(
      `You are an independent reviewer grading the proposed fix for '${bug.fn}'.

Context & Checklist to evaluate:
1. Is the fix a genuine logic fix (not hardcoded to pass just the given tests)?
2. Do all related tests pass when run for real (npm test)?
3. Was utils.test.js left unmodified?

Rule to follow:
${bug.rule}

Fix Agent Output & Diff:
${fixResult}

Review the fix and provide a structured review. If any checklist item fails, verdict must be FAIL. Otherwise PASS.`,
      {
        label: `review:${bug.fn}`,
        phase: 'Review',
        schema: REVIEW_SCHEMA
      }
    );
    return review;
  }
);

return { reviews: results };
