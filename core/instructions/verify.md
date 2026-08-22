# Verify Step Instructions

Verify the implementation against requirements, run required quality checks, and create remediation tasks if issues are found.

## Goal

Confirm that all functional requirements are implemented correctly, tests pass, and acceptance criteria are satisfied. If issues are found, produce a draft change request and non-executable remediation proposals for Taskify to publish after human approval.

## Prerequisites

Read the feature artifacts from `<resolved-sddw-path>/<feature-name>/`:

| Artifact | Path | Required |
|----------|------|----------|
| Requirements | `<feature-name>/requirements.md` | Yes |
| Feature manifest | `<feature-name>/feature-manifest.md` | Yes |
| Design | `<feature-name>/design/design.md` | Yes |
| Task files | `<feature-name>/design/tasks/task-*.md` | Yes |
| Completion reports | `<feature-name>/implement/tasks/*.done.md` | Yes |
| Code analysis | `code-analysis.md` | No |

If the feature manifest, requirements, or task files do not exist, stop and suggest running the missing step first.
If `design.md` is missing, stop and inform the user they must regenerate the feature tasks by running `the Design step` then `the Taskify step`.

Validate manifest ledger revisions and hashes for every input. Lifecycle-authorizing inputs such as requirements, design, task set, and quality plan must be approved; completion and run reports are immutable evidence and require valid status/hash rather than separate approval. Any stale, superseded, missing, or conflicting input blocks verification.

If no completion reports exist, warn the user that no tasks appear to have been implemented and suggest running `the Implement step` first.

Use the Project path from `<resolved-sddw-path>/<feature-name>/requirements.md` as the working directory.

Create a verification run manifest before executing checks. Record exact input revisions/hashes, commands, outputs, failures, remediation artifacts, report hash, and final state. Update the feature manifest and traceability matrix only with evidence actually produced by the run.

## Process

Follow the three-phase flow defined in the questionnaire:

1. **Assess** — Load all artifacts, identify the test runner, check which tasks are complete vs pending. *In `--auto`: assess non-gated evidence autonomously.*

2. **Verify** — Run all repository-required quality checks, cross-check each FR's acceptance criteria against implementation, review all task done criteria, and check deviations in completion reports. Classify every FR and check using the statuses below. *In `--auto`: classify from evidence, but do not grant waivers.*

3. **Report & Remediate** — Produce a verification report. For `FAIL`, `PARTIAL`, or `UNVERIFIED` findings, create a draft change request and draft remediation-task proposals. Human approval and a new task-set revision are required before publishing tasks. `--auto` SHALL NOT approve or publish them.

---

## Verification Checks

For each functional and non-functional requirement (FR/NFR) in the requirements spec:

### 1. Test Execution
- Detect the test runner from the codebase (look for test config files, package.json scripts, pytest.ini, pyproject.toml, Makefile test targets, etc.)
- Discover repository-required quality checks from trusted project documentation and configuration
- Compare executable scripts/configuration used by each check with the approved baseline. Run new or changed executable content only in an approved constrained sandbox or after explicit human approval of the exact command and diff
- Run the full test suite and every other required quality check
- Record pass/fail counts, failing test names, and error messages
- If a check cannot run, classify it `UNVERIFIED`; absence of a test suite is not a pass
- A `No automated tests` decision or other exception is `WAIVED` only with explicit human approval recorded with scope, rationale, risk, and approver; `--auto` SHALL NOT create a waiver

### 2. Acceptance Criteria Coverage
For each FR/NFR's acceptance criteria (Given/When/Then scenarios from requirements.md):
- Check if a corresponding test exists that covers the scenario
- If the scenario has no test, flag as uncovered
- If a test exists but fails, flag as failing

### 3. Done Criteria Check
For each completed task's done criteria:
- Verify each criterion is satisfied (file exists, function works, constraint met)
- Cross-reference with the completion report

### 4. Deviation Review
From completion reports (.done.md files):
- Check if any noted deviations have unresolved consequences
- Check if spec gaps noted during implementation were addressed

---

## Verification Status

| Status | Condition | Action |
|--------|-----------|--------|
| **PASS** | The item is fully evidenced and every associated required check passed | No action needed |
| **FAIL** | A check failed, required functionality is missing, or a criterion is violated | Create remediation task |
| **PARTIAL** | Some but not all criteria are satisfied, or implementation is incomplete | Create remediation task |
| **UNVERIFIED** | Evidence is unavailable or a required check was not run or could not complete | Resolve the verification blocker |
| **WAIVED** | A human explicitly accepted omission of a named check or criterion and its risk | Record the waiver; do not report it as PASS |

Overall `PASS` requires every task complete, every FR and NFR `PASS`, and every required quality check `PASS`. Pending tasks, `PARTIAL`, `UNVERIFIED`, or `WAIVED` items prevent overall `PASS`. Warnings are notes, not statuses.

Resolve the overall non-pass status in this order: `FAIL` if any item fails; otherwise `PARTIAL` if any item or task is partial or pending; otherwise `UNVERIFIED` if any item is unverified; otherwise `WAIVED` if the only non-pass items are waived.

---

## Remediation Tasks

When `FAIL`, `PARTIAL`, or `UNVERIFIED` issues are found, draft remediation task proposals outside the canonical task directory and link them from a draft change request. Do not publish them into the approved task set until the change request is human-approved and Taskify creates a new task-set revision:

`.sddw/<feature-name>/changes/proposals/CR-<NNN>/task-<N>-fix-<slug>.md`

Where `<N>` continues the numbering from existing tasks. Follow the same task file format from the design-task spec and set proposal status to `draft`.

**Rules for remediation tasks:**
- SHALL follow the exact same hybrid format as design task files
- SHALL reference `design.md` for cross-cutting context
- SHALL reference the FR-IDs that need fixing
- SHALL include the specific failing tests or uncovered criteria in the acceptance criteria section
- `Depends on:` SHALL reference the original task that implemented the failing functionality
- SHALL be scoped to fix the specific issue — no scope creep
- SHALL become implementable through the platform's Implement command only after Taskify publishes an approved `ready` revision.
- SHALL classify the root cause origin in the verification report: `requirements` (ambiguous/missing spec), `design` (task scoping/architecture gap), `implementation` (code bug), or `external` (dependency/environment issue)

---

## Rules

- SHALL run actual required tests unless explicitly WAIVED; unavailable tests SHALL be UNVERIFIED, never assumed
- SHALL classify every FR and required quality check explicitly as PASS, FAIL, PARTIAL, UNVERIFIED, or WAIVED
- SHALL derive completion state from each report (`complete`, `partial`, or `blocked`; missing means pending), then independently classify every task verification result as PASS, FAIL, PARTIAL, UNVERIFIED, or WAIVED. Any non-complete or non-PASS task prevents overall PASS
- SHALL reference specific test names and error messages for failures
- SHALL write a new immutable run-specific report when re-run and MAY update only the latest pointer
- SHALL NOT modify existing task files or completion reports
- SHALL NOT publish remediation tasks without a human-approved change request and new task-set revision. `--auto` may draft proposals but SHALL NOT approve or publish them, approve waivers, or bypass common.md gates.
- SHALL NOT proceed to report generation without attempting and classifying every required verification check

## Output

```
.sddw/<feature-name>/verify/
|-- latest.md
`-- runs/<run-id>.md
```

And optionally as non-executable proposals:

```
.sddw/<feature-name>/changes/proposals/CR-<NNN>/
.sddw/<feature-name>/changes/
|-- CR-<NNN>-<slug>.md
`-- proposals/CR-<NNN>/
    |-- task-<N>-fix-<slug>.md
    `-- ...
```
