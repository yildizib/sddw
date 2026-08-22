## Improvement Report

Versioned, evidence-based lifecycle improvement record. Reports are immutable snapshots; later reviews create a new report.

**Location:** `.sddw/<feature-name>/self-improve/reports/<report-id>.md`

**Optional latest pointer:** `.sddw/<feature-name>/self-improve/latest.md` SHALL contain only the latest report ID/path (or an equivalent symlink).

**Format:**
````
# Improvement Report: <feature-name> / <report-id>

## Governance
- **Feature ID:** FEAT-<stable-id>
- **Report ID:** IMPREP-<timestamp-or-stable-id>
- **Revision:** <integer>
- **Status:** draft | reviewed | accepted | superseded
- **Date:** <ISO-8601 timestamp>
- **Input revisions/hashes:** [artifact/review/release/metrics source]=<revision and sha256>
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>

## Summary
- **Verification run:** <run-id> — PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED
- **Signals:** [counts by source]
- **Findings:** [count]
- **Proposals:** [count by status]

## Lifecycle Overview
- **Requirements:** [revision/status; FR/NFR/AC counts]
- **Code analysis:** [revision/freshness]
- **Design:** [revision/status; trace completeness]
- **Implementation:** [tasks complete/total; deviations/waivers]
- **Verification:** [run ID/result; remediation count]

## Signal Analysis

### Review Signals
- **SIG-REV-01:** [code/design/security/user review finding] — **Evidence:** [source/reference]

### Release Signals
- **SIG-REL-01:** [deployment, rollback, incident, support signal] — **Evidence:** [release/run/reference]

### Metrics Signals
- **SIG-MET-01:** [metric, baseline, observed value, window] — **Evidence:** [dashboard/query/export]

### Lifecycle Signals
- **SIG-LIF-01:** [deviation, difficulty, remediation, uncovered criterion, or trace gap] — **Evidence:** [artifact ID/path]

## Findings
- **F-01:** [evidence-backed finding] — **Origin step:** requirements | analysis | design | implementation | verification | release

## Improvement Proposals

### IMP-01: [title]
- **Type:** instruction | questionnaire | spec | process | tooling
- **Target:** [core-relative file/process]
- **Owner:** [person/role/team]
- **Priority:** critical | high | medium | low
- **Status:** proposed | accepted | in-progress | implemented | rejected | ineffective
- **Target date/release:** [date, release, or review cycle]
- **Finding/signals:** F-01; SIG-*
- **Proposal:** [concise change]
- **Expected outcome:** [measurable result]
- **Effectiveness measure:** [metric, target, evaluation window, evidence owner]
- **Effectiveness result:** pending | effective | partially-effective | ineffective — [observed evidence]
- **Diff preview:**
  ```diff
  - [old text]
  + [new text]
  ```
````

**Rules:**
- Report IDs SHALL be unique and reports SHALL NOT be overwritten. A new review creates a new report and MAY update only the latest pointer.
- Findings SHALL use artifact, review, release, or metrics evidence; speculative findings are prohibited.
- Signal analysis SHALL consider review, release, metrics, and lifecycle signals, recording `none — <evidence searched>` when a category has no signal.
- Every finding SHALL identify its origin step and supporting signal IDs.
- Every proposal SHALL have an owner, priority, status, target, expected outcome, and effectiveness measure.
- Implemented proposals SHALL later record effectiveness using observed evidence; implementation alone does not mean effective.
- SHALL include reviewed diff previews but SHALL NOT modify workflow files.
- SHALL remain concise.

**Example:**
> ### IMP-01: Preserve measurable thresholds in task gates
> - **Type:** questionnaire
> - **Target:** `core/questionnaires/design.md`
> - **Owner:** workflow maintainers
> - **Priority:** high
> - **Status:** proposed
> - **Target date/release:** next workflow revision
> - **Finding/signals:** F-01; SIG-LIF-02, SIG-MET-01
> - **Proposal:** Require every measurable AC threshold to map to a task quality gate.
> - **Expected outcome:** 100% threshold-to-gate trace completeness.
> - **Effectiveness measure:** Audit the next 10 features; target 10/10 with no verification remediation caused by omitted thresholds.
> - **Effectiveness result:** pending
