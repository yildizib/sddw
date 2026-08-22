# Verify Questionnaire

Three-phase dialog for verifying implementation against requirements.

---

## Phase 1: Assess

*In `--auto`: assess non-gated evidence autonomously.*

Understand the current state of the feature. Load artifacts and identify the verification scope.

**Step 1 — Status overview:**

Present a status table showing:
- Total tasks: [count design tasks]
- Completion state: [count `complete`, `partial`, `blocked`, and missing reports by reading each report Status]
- Pending: [list tasks whose completion report is missing or not `complete`]

If there are pending tasks, use `structured question mechanism`:
- "Verify current state" — assess all tasks; pending tasks prevent overall PASS
- "Wait — implement remaining tasks first (Recommended)" — redirect to implement

Wait for response.

Completion state and verification status are separate: a `complete` report proves only that implementation declared completion. During verification, classify every task independently as `PASS`, `FAIL`, `PARTIAL`, `UNVERIFIED`, or `WAIVED` from current evidence.

**Step 2 — Test runner detection:**

Scan the project for test configuration:
- `package.json` (scripts.test), `jest.config.*`, `vitest.config.*`
- `pytest.ini`, `pyproject.toml` ([tool.pytest]), `setup.cfg`
- `Makefile` (test targets), `.github/workflows/*`
- Other common test runners

If detected:
> "I'll run tests using [runner]. Any specific test command or flags I should use instead?"

Use `structured question mechanism` with options:
- "Yes, use [detected command] (Recommended)"
- "I'll provide a different command"

Wait for response.

If not detected, use `structured question mechanism`:
- "Record test execution as UNVERIFIED (Recommended)"
- "Request a test waiver" — present scope, rationale, and risk for explicit human approval; `--auto` cannot select this
- "I'll provide the test command"

Wait for response.

---

## Phase 2: Verify

Run every quality check required by trusted repository documentation and configuration. Present findings grouped by FR and check.

### 2.1 Test Execution

Run the detected test command. Report results:
> "Test results: [pass] passed, [fail] failed, [skip] skipped."
> If failures: list failing tests with brief error summaries.

### 2.2 Requirement-by-Requirement Verification

For each FR and NFR, present the verification result. NFR evidence SHALL use measurable tests, quality gates, metrics, or observations defined by the requirement:

> **FR-01: [title]** — [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED]
> - Acceptance criteria: [N/M covered by tests]
> - Done criteria: [checked / unchecked items]
> - Tests: [pass / fail count for related tests]
> - Issues: [list specific problems, or "none"]
>
> **NFR-01: [title]** — [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED]
> - Verification method/threshold: [method and expected threshold]
> - Evidence: [test, quality gate, metric, or observation]
> - Issues: [list specific problems, or "none"]

*In `--auto`: classify non-gated results autonomously from evidence.*

If there are ambiguous results, use `structured question mechanism` with options:
- "Pass — [reason why it could be acceptable]"
- "Fail — [reason why it should be fixed]"
- "Partial — [explanation]"
- "Unverified — [missing evidence or blocked check]"

`WAIVED` is not an ambiguity resolution. It requires an explicit human decision recording scope, rationale, risk, and approver, and it SHALL NOT be granted by `--auto`.

Wait for response for each ambiguous result.

---

## Phase 3: Report & Remediate

### 3.1 Summary

Present the verification summary:

> **Verification summary for <feature-name>:**
> - FRs passed: [count]
> - FRs failed: [count]
> - FRs partial: [count]
> - FRs unverified: [count]
> - FRs waived: [count]
> - NFRs passed/failed/partial/unverified/waived: [counts]
> - Warnings: [count]
> - Required quality checks: [PASS/FAIL/PARTIAL/UNVERIFIED/WAIVED by check]
> - Overall: [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED]

Overall PASS requires all tasks complete, every FR and NFR PASS, and every required quality check PASS. A waiver SHALL be reported as WAIVED, never PASS.

### 3.2 Remediation (if issues found)

If any FR, NFR, task, test, or required quality gate is FAIL, PARTIAL, or UNVERIFIED, propose remediation tasks:

> "I'd create these remediation tasks:"
> 1. Task [N+1]: Fix [description] (FR-01) — fixes [specific issue]
> 2. Task [N+2]: Add [description] (FR-03) — covers [uncovered criteria]
> "Each proposal follows the design-task format but cannot run until its change request is approved and Taskify publishes a `ready` task-set revision."

Use `structured question mechanism`:
- "Draft all remediation proposals (Recommended)"
- "Draft selected proposals — I'll specify which"
- "Skip — no remediation tasks needed"

Wait for response.

If "selected": use `structured question mechanism` with each proposed task as a multi-select option.

### 3.3 Generate

Generate a unique verification report at `.sddw/<feature-name>/verify/runs/<run-id>.md` and update only `verify/latest.md`.

Generate the draft change request at its canonical path `.sddw/<feature-name>/changes/CR-<NNN>-<slug>.md` and draft remediation proposals under `.sddw/<feature-name>/changes/proposals/CR-<NNN>/`. Proposals are non-executable. Only after human approval may Taskify publish conforming tasks to `.sddw/<feature-name>/design/tasks/` as a new task-set revision.

*In `--auto`: create draft proposals only. Do not approve the change request, publish tasks, grant waivers, or bypass common.md human gates.*
