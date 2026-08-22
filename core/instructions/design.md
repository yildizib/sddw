# Design Instructions

Generate the governed cross-cutting design revision for a feature. Task decomposition is handled separately.

## Prerequisites

- Load `feature-manifest.md` and verify the exact requirements revision and hash.
- Requirements SHALL be human-approved, current, complete enough to design, and tied to the current baseline. Validate the requirements approval and manifest freshness; any stale, missing, superseded, or conflicting input blocks design.
- If code analysis is listed, validate its revision, hash, baseline, evidence freshness, and applicability. Otherwise perform and record targeted code scanning.
- Create the design run manifest before material work and record all inputs.

## Process

1. **Discover** - ask one question at a time about architecture, integration, migration, compatibility, operations, and constraints. In `--auto`, draft autonomously from valid evidence.
2. **Research and propose** - present one concern at a time with evidence, ranked alternatives, consequences, and unresolved risks.
3. **Generate, validate, and gate** - stage the design revision, validate traceability and lifecycle concerns, publish it as `in-review`, then request human approval and update traceability, risk, feature, and run records.

## Design Rules

- Assign stable IDs to design elements, including components, data models, interfaces, flows, and controls. Use explicit IDs such as `DES-###`; use `ADR-###` for non-obvious decisions and `RISK-###` for risks.
- Every design element SHALL trace to one or more approved FR/NFR/AC IDs or an approved change request. Every FR/NFR SHALL map to design or an explicit `not-needed: <reason>` disposition.
- Document architecture, data models, interfaces, dependency direction, trust boundaries, and affected tests using actual codebase evidence.
- Include applicable ADRs, risks and mitigations, migration and data-conversion strategy, backward/forward compatibility, rollback/forward-fix strategy, and observability signals, thresholds, ownership, and response.
- Record rejected alternatives and rationale. SHALL NOT introduce patterns that conflict with repository policy or evidenced conventions.
- Update `traceability-matrix.md`, `risk-register.md`, `feature-manifest.md`, and the run manifest with exact revision/hash links and actual outcomes.
- Validate complete requirement-to-design trace links, resolvable references, risks, compatibility, migration, rollback, and observability before success.
- SHALL NOT generate task files.

## Existing Design and Revision

- SHALL NOT overwrite or directly mutate an approved or baselined design.
- A design change requires a change request and a new revision. Recalculate hashes, preserve superseded history, mark affected downstream artifacts and approvals stale, and record invalidation in the manifest and traceability matrix.
- An existing draft may be regenerated only with explicit interactive confirmation or a recorded `--auto` regeneration intent; regeneration creates a revision and never erases history.
- `--auto` may draft or regenerate but cannot approve an ADR risk acceptance, waiver, or mandatory human gate.
- Design and applicable ADR approval are mandatory human gates. Record a platform-verifiable approval reference, approver, decision, and time; pending approval blocks Taskify.

## Clean Transition

Use current design and lifecycle formats only for newly generated or regenerated feature artifacts. Do not migrate unchanged legacy artifacts.

## Output

```text
<resolved-sddw-path>/<feature-name>/design/design.md
<resolved-sddw-path>/<feature-name>/decisions/ADR-<NNN>-<slug>.md
<resolved-sddw-path>/<feature-name>/runs/run-<YYYYMMDDTHHMMSSZ>-design.md
```
