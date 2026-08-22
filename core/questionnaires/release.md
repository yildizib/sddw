# Release Questionnaire

Dialog for release readiness planning and post-release evidence recording. `--auto` may automate analysis and drafting, but never remote actions or mandatory human gates.

---

## Mode Selection

- No `--post-release`: run Phase 1 and generate/update `release/plan.md`.
- With `--post-release`: run Phases 2 and 3 to record and assess the actual release.

## Phase 1: Prepare

### 1.1 Gate Check

Load the feature manifest, review report, and referenced verification, traceability, quality, and run evidence. Present:

- Candidate revision/version
- Review result and reviewed revision
- Evidence freshness/consistency
- Target environment/release channel
- Blocking readiness items

The persisted review `Result` must be exactly `PASS` for the candidate revision. Otherwise stop and direct the user to the Review step.

### 1.2 Readiness Plan

Draft an ordered plan containing:

- final local validation and artifact checks
- approvals and owners
- remote branch/PR/merge actions
- tag and hosted release actions
- deployment or promotion actions
- smoke checks with expected outcomes
- monitoring signals, duration, thresholds, and owner
- rollback triggers and procedure
- evidence to capture for every action

Label each remote Git, tag, merge, release, deployment, promotion, or rollback action `MANDATORY HUMAN GATE`. In interactive mode, use structured questions one at a time for missing release metadata or ownership. In `--auto`, leave unknown values as blocking placeholders; do not invent them or execute actions.

Generate/update the release plan. State clearly that the lifecycle is not complete and that `--post-release` is required after the human-operated release.

Complete the readiness run manifest and update the feature manifest with the plan revision/hash and pending human gates.

---

## Phase 2: Record Actual Release

Load the readiness plan and collect evidence category by category:

1. Remote Git/merge/tag/hosted release
2. Deployment or promotion
3. Smoke tests
4. Monitoring
5. Rollback readiness or execution

For each category record actor, timestamp, target, revision/version, command or external identifier/URL where applicable, result, and evidence source. Use the structured question mechanism for one missing evidence category at a time. Human testimony must be attributed; do not silently upgrade it to machine evidence.

In `--auto`, consume only available persisted evidence. Mark absent evidence missing; never infer that a planned action happened.

---

## Phase 3: Assess & Report

Cross-check all evidence against the candidate revision, version, environment, and release plan. Present:

- Release/deployment outcome
- Smoke-test outcome
- Monitoring outcome and observation window
- Rollback status/readiness
- Missing or contradictory evidence
- Proposed post-release result

Generate a new immutable release report using the release-report spec's exact execution-result and lifecycle-status vocabularies; update only `release/latest.md`.

Complete the post-release run manifest and update the feature manifest, traceability matrix, risk register, and metrics only from validated actual evidence.

Call the lifecycle complete only when execution is `succeeded` and lifecycle status is `closed`. Otherwise state whether it is pending, failed, rolled back, unverifiable, recording, or monitoring and list the next required action without claiming completion.
