# Release Step Instructions

Prepare release readiness for a reviewed feature and, after humans perform the release, record the actual release, deployment, smoke, monitoring, and rollback evidence.

## Goal

Maintain a truthful release record without allowing an AI command to silently perform or claim remote release actions. Release preparation and post-release recording are separate modes.

## Input

- `<feature-name>` - the feature being released
- `--post-release` - record and assess evidence from the release that actually occurred
- `--auto` - automate non-gated analysis only

Without `--post-release`, `/release <feature-name>` prepares a release readiness plan. With `--post-release`, it records actual outcomes and determines the post-release result.

## Mandatory Human Gate

Remote Git operations and release/deployment actions always require explicit human authorization and execution/confirmation at the point of action. This includes push, remote branch changes, pull/merge requests, merge, tag creation or push, hosted release creation, deployment, promotion, rollback, and equivalent remote side effects.

- The AI may inspect local state, prepare commands/checklists, and draft release content.
- The AI SHALL NOT perform, approve, or claim any remote Git, tag, merge, release, deployment, promotion, or rollback action without an explicit human gate for that action.
- `--auto` SHALL NOT bypass or imply this gate.
- A prior generic request to automate the workflow is not evidence that a remote action occurred.

## Prerequisites

Resolve the feature and load all artifacts required by the feature manifest, release-report spec, and trust model. A valid review report with result exactly `PASS` for the same release revision is mandatory.

If the persisted review `Result` is missing, not exactly `PASS`, stale, or references a different revision, stop release preparation with a blocking readiness item and direct the user to an independent Review step.

Also validate the required verification, traceability, quality, and run evidence referenced by the review and manifest. Do not rely on review PASS if its underlying evidence has changed or expired.

Create a release run manifest before material readiness or post-release work. Record exact inputs, planned versus actual actions, human gates, evidence, outputs, failures, and final state.

## Mode A: Release Readiness Plan

Follow the questionnaire's Prepare phase:

1. Identify the exact candidate revision, release target, version, environment, and included scope from persisted artifacts.
2. Revalidate review PASS and evidence freshness for that revision.
3. Build an ordered readiness plan covering local checks, required human approvals, remote Git/tag/merge/release steps, deployment/promotion, smoke checks, monitoring, rollback criteria, evidence capture, and ownership.
4. Mark every remote side-effect step as a mandatory explicit human gate.
5. Write `release/plan.md` as defined by the release-plan spec. Record planned actions as planned, never completed.

Readiness means the plan and prerequisites are complete; it does not mean the feature has been released. The lifecycle remains incomplete.

## Mode B: Post-Release Recording

`--post-release` records what actually happened; it does not infer execution from the readiness plan.

Follow the questionnaire's Record & Assess phase:

1. Load the existing release plan and identify the intended candidate revision and targets.
2. Collect persisted or human-supplied evidence for actual remote release actions, deployment/promotion, smoke tests, monitoring observations, and rollback readiness or execution.
3. Validate evidence provenance, timestamps, revision/version/environment consistency, commands or URLs/IDs where applicable, and outcomes.
4. Record omissions, mismatches, failures, and unverifiable claims explicitly.
5. Write a new immutable release report and assign its execution result and lifecycle status as defined by the release-report spec.

Required post-release evidence includes:

- actual release identity and revision/version
- remote Git, merge, tag, and hosted release outcomes as applicable
- deployment or promotion outcome and target environment as applicable
- actual smoke-test commands/checks and results
- monitoring window, signals checked, observations, and owner
- rollback procedure/readiness, trigger criteria, and any rollback outcome

If an item is not applicable, record the justified `N/A` form permitted by the spec. Missing evidence is `unverifiable`. A plan, command preview, or statement that an action "should" succeed is not actual evidence.

## Lifecycle Completion

The feature lifecycle SHALL NOT be called complete after review PASS or readiness planning. It is complete only after:

1. the release report contains post-release evidence,
2. `Execution result` is `succeeded`, and
3. `Lifecycle status` is `closed` rather than recording or monitoring.

Use the exact result vocabulary and completion semantics from the release-report spec.

## Rules

- SHALL preserve a clear distinction between planned and actual actions.
- SHALL bind review, release, deployment, and evidence to an exact revision/version.
- SHALL treat stale, missing, contradictory, or unverifiable required evidence as blocking or unsuccessful according to the release-report spec.
- SHALL record human approver/operator ownership for gated actions.
- SHALL NOT alter review results or underlying evidence to make a release ready.
- SHALL NOT state that release, deployment, smoke testing, monitoring, or rollback occurred without actual evidence.
- SHALL NOT call the lifecycle complete during readiness mode.
- `--auto` affects only analysis and document preparation; all mandatory human gates remain.
- SHALL update the feature manifest with exact release plan/report revisions and hashes, gate state, and lifecycle state.
- Post-release mode SHALL update traceability, risks, and metrics from actual evidence before a release report may become `closed`.

## Output

Readiness mode writes the canonical release plan defined by `core/specs/release-plan.md`. Post-release mode writes a new immutable report under `release/runs/` and updates only `release/latest.md`; it records actual evidence without rewriting history as if planned actions had already occurred.
