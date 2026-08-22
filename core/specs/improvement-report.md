## Improvement Report

Written after the self-improve step analyses a completed feature. Stored at `.sddw/<feature-name>/self-improve/report.md`.

**Location:** `.sddw/<feature-name>/self-improve/report.md`

**Format:**
````
# Improvement Report: <feature-name>

## Summary
- **Date:** [ISO date]
- **Feature result:** [PASS | FAIL | PARTIAL] (from verification)
- **Signals:** [deviations] deviations, [difficulties] difficulties, [remediation] remediation tasks
- **Findings:** [count] across [steps affected]
- **Proposals:** [total] proposed with diff previews

## Lifecycle Overview
- **Requirements:** [complete] — [N] FRs, [N] acceptance scenarios
- **Code Analysis:** [exists | skipped]
- **Design:** [N] tasks
- **Implementation:** [N/M] tasks completed, [N] deviations, [N] difficulties
- **Verification:** [result] — [N] remediation tasks

## Signal Analysis

### Deviations
[Summary of deviations from completion reports]
- Task [N]: Rule [R] — [description] ([resolved | unresolved])

### Difficulties
[Summary of difficulties from completion reports]
- Task [N]: [difficulty] — [resolution]

### Remediation Origins
[Breakdown of remediation task root causes]
- [N] from requirements — [pattern description]
- [N] from design — [pattern description]
- [N] from implementation — [pattern description]
- [N] from external — [pattern description]

### Uncovered Criteria
[Acceptance criteria not covered by tests]
- FR-[N]: [criterion] — [why uncovered]

## Findings

### Requirements Step
[Findings for this step, or "No issues identified"]
- **F-01:** [description with evidence from artifacts]

### Design Step
- **F-02:** [description]

### Implementation Step
- **F-03:** [description]

### Verification Step
- **F-04:** [description]

## Improvement Proposals

### IMP-01: [title]
- **Type:** [instruction | questionnaire | spec | process]
- **Target:** [core-relative target file or process]
- **Step:** [affected workflow step]
- **Finding:** [evidence-based finding]
- **Proposal:** [proposal summary]
- **Diff preview:**
  ```diff
  - [old text]
  + [new text]
  ```
````

**Rules:**
- SHALL be written after analysis and proposal review complete
- SHALL base all findings on evidence from artifacts — reference specific deviations, difficulties, remediation tasks, or test results
- SHALL classify every finding by the workflow step where the issue originated
- SHALL include the full list of proposals and diff previews
- SHALL NOT modify workflow files
- SHALL be concise — this is a report, not a narrative
- SHALL NOT include speculative findings without artifact evidence
- Re-running self-improve SHALL overwrite the previous report

**Example:**
> # Improvement Report: password-reset
>
> ## Summary
> - **Date:** 2026-03-26
> - **Feature result:** FAIL (from verification)
> - **Signals:** 3 deviations, 1 difficulty, 2 remediation tasks
> - **Findings:** 3 across 2 steps
> - **Proposals:** 1 proposed with a diff preview
>
> ## Lifecycle Overview
> - **Requirements:** complete — 3 FRs, 7 acceptance scenarios
> - **Code Analysis:** exists
> - **Design:** 3 tasks
> - **Implementation:** 3/3 tasks completed, 3 deviations, 1 difficulty
> - **Verification:** FAIL — 2 remediation tasks
>
> ## Signal Analysis
>
> ### Deviations
> - Task 1: Rule 2 — added `__repr__` to model (resolved)
> - Task 2: Rule 1 — fixed import ordering (resolved)
> - Task 3: Rule 3 — added missing `__init__.py` (resolved)
>
> ### Difficulties
> - Task 1: Alembic autogenerate didn't detect UUID type — manually specified dialect
>
> ### Remediation Origins
> - 0 from requirements
> - 1 from design — task file omitted performance constraint for email delivery
> - 1 from implementation — off-by-one in `is_valid()` boundary comparison
> - 0 from external
>
> ### Uncovered Criteria
> - None — all criteria covered after remediation
>
> ## Findings
>
> ### Requirements Step
> - No issues identified
>
> ### Design Step
> - **F-01:** Task 2 had no performance constraint for email delivery. The 60s SLA from FR-01 acceptance criteria was not carried into the task file's done criteria. This caused the implementation to have no target, and verification caught it as a failure.
> - **F-02:** Alembic UUID difficulty (Task 1) was a known pattern not captured in code analysis. If code analysis had documented ORM-specific quirks, the design step could have included this in the task file.
>
> ### Implementation Step
> - **F-03:** The `is_valid()` boundary comparison used `<` instead of `<=`. The acceptance criterion said "older than 24 hours" which is ambiguous — could mean `>= 24h` or `> 24h`. The requirements step should have been more precise.
>
> ### Verification Step
> - No issues identified
>
> ## Improvement Proposals
>
> ### IMP-01: Carry measurable thresholds into task criteria
> - **Type:** questionnaire
> - **Target:** `core/questionnaires/design.md`
> - **Step:** design
> - **Finding:** The 60s SLA from FR-01 was not carried into the task done criteria.
> - **Proposal:** Prompt design review to preserve measurable thresholds.
> - **Diff preview:**
>   ```diff
>   + Check each acceptance criterion for measurable thresholds and carry them into task done criteria.
>   ```
