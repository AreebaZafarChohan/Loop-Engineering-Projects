export const meta = {
  name: 'fix-and-review-student-grade',
  description: 'Parallel fix-and-review candidate workflow for student grade calculations with isolated worktrees',
  phases: [
    { title: 'Maker', detail: 'Implement candidate grade fixes in isolated worktrees' },
    { title: 'Reviewer', detail: 'Independently inspect diffs and run pytest in each worktree' }
  ]
};

const CANDIDATES = [
  {
    id: 1,
    title: 'Candidate 1 - Standard Implementation',
    prompt: `You are Maker Agent 1 working in an isolated worktree.
Target project directory: project5-codify-body/task2

Goal:
1. Inspect project5-codify-body/task2/src/student_result.py and project5-codify-body/task2/tests/test_student_result.py.
2. Implement standard grade boundary logic in project5-codify-body/task2/src/student_result.py:
   - 90 or above: "A"
   - 80 or above: "B"
   - 70 or above: "C"
   - 60 or above: "D"
   - below 60: "F"
3. DO NOT modify, bypass, or weaken any tests in project5-codify-body/task2/tests/test_student_result.py.
4. Run pytest inside project5-codify-body/task2.
5. Return a JSON object with:
   - change_made: description of what you implemented
   - pytest_output: output summary of pytest`
  },
  {
    id: 2,
    title: 'Candidate 2 - Clean Alternative Implementation',
    prompt: `You are Maker Agent 2 working in an isolated worktree.
Target project directory: project5-codify-body/task2

Goal:
1. Inspect project5-codify-body/task2/src/student_result.py and project5-codify-body/task2/tests/test_student_result.py.
2. Implement a clean alternative implementation (e.g. data-driven threshold mapping tuple/dict/loop or bisect) in project5-codify-body/task2/src/student_result.py:
   - 90 or above: "A"
   - 80 or above: "B"
   - 70 or above: "C"
   - 60 or above: "D"
   - below 60: "F"
3. DO NOT modify, bypass, or weaken any tests in project5-codify-body/task2/tests/test_student_result.py.
4. Run pytest inside project5-codify-body/task2.
5. Return a JSON object with:
   - change_made: description of what you implemented
   - pytest_output: output summary of pytest`
  },
  {
    id: 3,
    title: 'Candidate 3 - Independent Attempted Implementation',
    prompt: `You are Maker Agent 3 working in an isolated worktree.
Target project directory: project5-codify-body/task2

Goal:
1. Inspect project5-codify-body/task2/src/student_result.py and project5-codify-body/task2/tests/test_student_result.py.
2. Implement the fix for student grade calculation in project5-codify-body/task2/src/student_result.py meeting all requirements:
   - 90 or above: "A"
   - 80 or above: "B"
   - 70 or above: "C"
   - 60 or above: "D"
   - below 60: "F"
3. DO NOT modify, bypass, or weaken any tests in project5-codify-body/task2/tests/test_student_result.py.
4. Run pytest inside project5-codify-body/task2.
5. Return a JSON object with:
   - change_made: description of what you implemented
   - pytest_output: output summary of pytest`
  }
];

const MAKER_SCHEMA = {
  type: 'object',
  properties: {
    change_made: { type: 'string' },
    pytest_output: { type: 'string' }
  },
  required: ['change_made', 'pytest_output']
};

const REVIEWER_SCHEMA = {
  type: 'object',
  properties: {
    verdict: { type: 'string', enum: ['PASS', 'FAIL'] },
    tests_modified: { type: 'boolean' },
    pytest_result: { type: 'string' },
    reviewer_notes: { type: 'string' }
  },
  required: ['verdict', 'tests_modified', 'pytest_result', 'reviewer_notes']
};

log('Starting dynamic workflow: 3 candidates running in parallel isolated worktrees...');

const results = await pipeline(
  CANDIDATES,
  async (candidate) => {
    log(`[Maker] Launching maker for ${candidate.title}`);
    const makerResult = await agent(candidate.prompt, {
      label: `maker:${candidate.id}`,
      phase: 'Maker',
      isolation: 'worktree',
      schema: MAKER_SCHEMA
    });
    return { candidate, makerResult };
  },
  async (step1) => {
    log(`[Reviewer] Launching reviewer for ${step1.candidate.title}`);
    const reviewerPrompt = `You are a strict, independent Reviewer Agent.
You are inspecting Candidate ${step1.candidate.id}'s work in this worktree.
Target directory: project5-codify-body/task2

Review Checklist:
1. Inspect git status and git diff in project5-codify-body/task2.
2. Verify test integrity: Confirm test files (specifically tests/test_student_result.py) were NOT modified, weakened, bypassed, or deleted. If any test file was modified, verdict MUST be FAIL.
3. Verify implementation in src/student_result.py: Does it correctly implement 90+=A, 80+=B, 70+=C, 60+=D, <60=F?
4. Run pytest inside project5-codify-body/task2. Confirm all tests pass.
5. Provide a PASS or FAIL verdict.

Return structured output according to the schema.`;

    const reviewResult = await agent(reviewerPrompt, {
      label: `reviewer:${step1.candidate.id}`,
      phase: 'Reviewer',
      schema: REVIEWER_SCHEMA
    });

    return {
      candidate_id: step1.candidate.id,
      candidate_title: step1.candidate.title,
      change_made: step1.makerResult?.change_made || 'N/A',
      pytest_result: reviewResult?.pytest_result || step1.makerResult?.pytest_output || 'N/A',
      reviewer_verdict: reviewResult?.verdict || 'FAIL',
      tests_modified: reviewResult?.tests_modified || false,
      reviewer_notes: reviewResult?.reviewer_notes || 'N/A'
    };
  }
);

log('All 3 candidate fix-and-review pipelines completed.');
return results;
