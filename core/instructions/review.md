# Review Step Instructions

Perform an independent, evidence-based review of a feature before release. Review the specification chain, implementation, security, tests, and recorded execution evidence, then write the review report defined by the review-report spec.

## Goal

Decide whether the feature is ready to enter release preparation. A review PASS is a release gate, not a substitute for verification, quality checks, or release approval.

## Input

- `<feature-name>` - the feature to review
- `--auto` - perform non-gated decisions autonomously

## Independence Gate

The reviewer SHALL be independent from the implementation context.

- A fresh agent/context that did not implement or direct the implementation may perform the AI review.
- An agent/context that implemented, edited, or directed the feature SHALL NOT attest that its own review is independent.
- If independence cannot be established, stop before issuing a result and require a human reviewer to perform or explicitly own the review.
- `--auto` SHALL NOT waive, infer, or fabricate reviewer independence.

Record reviewer identity/type and compare its run/context identifier with every implementation run/context identifier. Record the concrete independence basis in the report.

Create the review run manifest after independence is established and before material review work. Record exact inputs, reviewed code revision, evidence inspected, report output, and final state.

## Required Inputs

Resolve the `.sddw/` base path once, then load the following artifacts and validate each against its loaded spec:

| Artifact | Required |
|----------|----------|
| Requirements | Yes |
| Design | Yes |
| Design task files | Yes |
| Task completion reports | Yes |
| Verification report | Yes |
| Feature manifest | Yes |
| Traceability artifact | Yes |
| Quality plan and verification evidence | Yes |
| Run evidence | Yes |

Use the canonical locations and formats declared by the relevant specs. Do not substitute conversation claims, planned commands, stale output, or inferred results for persisted evidence.

If any required artifact is missing, malformed, stale, internally inconsistent, or does not identify the reviewed revision, classify the gap as blocking and do not PASS. If the verification result is not exactly `PASS`, record the Review result as `BLOCKED`.

## Process

Follow the questionnaire's three phases:

1. **Establish** - establish reviewer independence, resolve scope and revision, load every required artifact, and check evidence freshness and consistency.
2. **Review** - inspect specification conformance, implementation quality, security, tests, traceability, quality gates, and run evidence. Record findings with evidence and severity.
3. **Decide & Report** - resolve the overall result and write a new run-specific report under `<resolved-sddw-path>/<feature-name>/review/runs/` exactly as defined by the review-report spec.

## Review Dimensions

### Specification and Traceability

- Confirm requirements, design, tasks, completion reports, and implementation describe the same scope and revision.
- Confirm every requirement and acceptance criterion is traceable through design/tasks to implementation and tests. Future commit, PR, and release links may remain pending at this stage.
- Treat missing, ambiguous, stale, or broken trace links as blocking.
- Confirm manifest entries are complete and agree with the artifact set.

### Code

- Inspect correctness, error handling, boundary conditions, maintainability, architecture compliance, compatibility, and unintended changes.
- Ground findings in concrete files, symbols, diffs, or behavior.
- Do not accept completion reports as proof when code or evidence contradicts them.

### Security

- Review trust boundaries, authentication/authorization, validation, secret handling, injection risks, dependency exposure, data handling, and abuse/failure paths relevant to the feature.
- A known exploitable vulnerability, missing required security control, or unresolved high-risk uncertainty is blocking.

### Tests and Evidence

- Confirm tests cover requirements, acceptance criteria, failure paths, and security-sensitive behavior.
- Confirm the verification report result is exactly `PASS`.
- Confirm quality gates meet their declared thresholds with no unresolved gaps.
- Confirm run evidence contains actual commands/results, revision identity, timestamps, and sufficient provenance to reproduce or audit the result.
- Traceability or quality gaps always block PASS, even if tests currently pass.

## Findings and Result

Classify findings using the severities and required fields from the review-report spec. Any finding designated blocking by that spec, or by these instructions, prevents PASS.

The result SHALL be:

- `PASS` only when verification is `PASS`, all required evidence is valid and current, traceability is complete through code/test evidence for the review stage, quality has no gaps, and no blocking finding remains.
- `FAIL` when review findings require remediation.
- `BLOCKED` when required evidence or reviewer independence is unavailable.

Commit, PR, and release trace links MAY remain `pending` before those lifecycle events occur and do not block Review when all links required through code/test evidence are complete. Warnings and suggestions may be recorded only when they do not weaken a required criterion. Never downgrade a required evidence, traceability, quality, security, or correctness failure to make the review pass.

## Rules

- SHALL review the actual implementation and persisted evidence, not summaries alone.
- SHALL identify the exact reviewed revision and detect evidence from a different revision.
- SHALL give every finding a stable ID, severity, evidence, impact, and required remediation per the review-report spec.
- SHALL write a new immutable run-specific report when re-run and MAY update only the latest pointer.
- SHALL NOT modify implementation, specifications, evidence, or reports other than the review report.
- SHALL NOT create, approve, merge, tag, release, deploy, or perform another remote action.
- SHALL NOT PASS conditionally or on promised future work.
- `--auto` may complete analysis and reporting, but it cannot bypass independence or any required gate.
- SHALL update the feature manifest with the immutable report revision/hash and review gate result; changed inputs later mark that report stale.

## Output

```text
.sddw/<feature-name>/review/
|-- latest.md
`-- runs/<run-id>.md
```

The report SHALL conform to `core/specs/review-report.md`.
