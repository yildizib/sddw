# Review Questionnaire

Three-phase dialog for an independent feature review. In `--auto`, perform ordinary analysis autonomously, but never bypass reviewer independence or evidence gates.

---

## Phase 1: Establish

### 1.1 Independence

Determine whether the current reviewer context implemented, edited, or directed the feature.

- If independence is established, record the reviewer and basis and continue.
- If the same implementation context is being used, stop and require a human reviewer.
- If independence is unknown, use the structured question mechanism to ask for human reviewer ownership or a fresh independent context. Do not offer self-attestation as an option.

### 1.2 Scope and Evidence

Resolve the feature path and reviewed revision. Load every required artifact and present a compact readiness table:

| Input | Status | Revision/freshness | Blocking issue |
|-------|--------|--------------------|----------------|
| Requirements | | | |
| Design and tasks | | | |
| Completion reports | | | |
| Verification report | | | |
| Feature manifest | | | |
| Traceability | | | |
| Quality plan and verification evidence | | | |
| Run evidence | | | |

Missing, invalid, stale, or cross-revision evidence is a blocking finding. A verification result other than `PASS` is blocking.

---

## Phase 2: Review

Review and present findings in this order:

1. Specification and manifest consistency
2. End-to-end traceability
3. Code correctness and architecture
4. Security and trust boundaries
5. Test adequacy and failure paths
6. Quality gates and run evidence

For each finding show its proposed stable ID, severity, evidence, impact, and required remediation. Mark blocking findings explicitly. Do not ask the user to reclassify objective failed gates.

In interactive mode, use one structured question to request clarification only when evidence is genuinely ambiguous. A clarification may add evidence but SHALL NOT replace required persisted evidence. In `--auto`, preserve ambiguity as a blocking finding rather than assuming success.

---

## Phase 3: Decide & Report

Present the decision basis:

- Verification: `PASS` or blocking
- Traceability: complete or blocking gaps
- Quality: gates satisfied or blocking gaps
- Blocking findings: count
- Review result: `PASS`, `FAIL`, or `BLOCKED`

Generate a unique `.sddw/<feature-name>/review/runs/<run-id>.md` using the review-report spec and update only `review/latest.md`.

Complete the review run manifest and update the feature manifest with the report hash and gate result. Do not modify the reviewed implementation or its evidence.

- Choose `PASS` only when every mandatory condition is satisfied and no blocking finding remains.
- Choose `FAIL` when findings require remediation. Choose `BLOCKED` when evidence or independence is unavailable.
- Never issue a conditional PASS.

After a PASS, direct the user to the Release step for readiness planning. After a FAIL, direct the user to remediate, regenerate affected evidence, verify again when necessary, and then obtain a new independent review.
