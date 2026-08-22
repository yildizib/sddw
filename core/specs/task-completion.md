## Task Completion Report

Written after implementation and checks, before any optional commit. It records observed code and verification state without depending on commit hashes or editing the task specification.

**Location:** `.sddw/<feature-name>/implement/tasks/task-<N>-<slug>.done.md`

**Format:**
```
# <TASK-ID> Completion: [task title]

## Governance
- **Feature ID:** FEAT-<stable-id>
- **Report revision:** <integer>
- **Status:** complete | partial | blocked
- **Completed:** <ISO-8601 timestamp>
- **Prepared by:** <agent/person>
- **Implementation run/context:** <run ID and context/session identifier>
- **Input revisions:** task=<N>; requirements=<N>; code-analysis=<N>; design=<N>
- **Input hashes:** task=<sha256>; requirements=<sha256>; code-analysis=<sha256>; design=<sha256>
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>

## Inputs
- **Task:** <path> revision <N>, sha256 <hash>
- **Requirements:** <path> revision <N>, sha256 <hash>
- **Code analysis:** <path> revision <N>, baseline <full SHA>, sha256 <hash>
- **Design:** <path> revision <N>, sha256 <hash>

## Summary
[One to three sentences describing implemented behavior.]

## Code Baseline and Diff
- **Baseline SHA:** <full pre-implementation SHA>
- **Working tree diff:** [paths changed and concise behavior summary]
- **Diff evidence:** `git diff <baseline>` | patch/artifact reference

## Checks
- **TEST-01:** PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED — [command, result, evidence]
- **QG-01:** PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED — [command, result, evidence]

## Waivers
- **WVR-01:** [check/criterion] — **Reason:** [reason] — **Risk:** [accepted risk] — **Approved by:** [owner/date/reference] — **Expires:** [date/condition]

## Deviations
- **DEV-01:** [planned vs actual] — **Reason:** [why] — **Impact:** [trace IDs] — **Disposition:** resolved | accepted | open

## Difficulties
- [Unexpected issue] — [resolution or current blocker]

## Notes
[Optional handoff information.]
```

**Rules:**
- SHALL be written after implementation checks and before any optional commit. Commit hashes SHALL NOT be required.
- SHALL NOT cite itself as evidence; evidence SHALL be source, diff, command output, test result, or external decision record.
- SHALL pin task and artifact input revisions/hashes plus the code baseline used for implementation.
- SHALL identify the implementation run and context so reviewer independence can be checked against durable evidence.
- SHALL summarize the actual diff, including all changed paths relevant to the task.
- Every linked test and quality gate SHALL have a status and evidence. A waiver SHALL include approver, risk, and expiry.
- SHALL list every deviation, including auto-fixed deviations, with trace impact and disposition.
- Difficulties SHALL include their resolution or current blocker.
- SHALL remain concise and SHALL NOT modify the original task file.

**Example:**
> ## Code Baseline and Diff
> - **Baseline SHA:** `0123456789abcdef0123456789abcdef01234567`
> - **Working tree diff:** Added token model and reversible migration in `src/models/reset_token.py` and `db/migrations/003_reset_tokens.py`
> - **Diff evidence:** `git diff 0123456789abcdef0123456789abcdef01234567 -- src/models/reset_token.py db/migrations/003_reset_tokens.py`
>
> ## Checks
> - **TEST-01:** PASS — `pytest tests/auth/test_reset_token.py -q`; 6 passed
> - **QG-01:** PASS — `alembic upgrade head && alembic downgrade -1`; exit 0
