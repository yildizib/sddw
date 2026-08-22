## Design File Format

Cross-cutting, traceable design for a feature. Task files reference stable design element and ADR IDs instead of duplicating content.

**Location:** `.sddw/<feature-name>/design/design.md`

**Format:**
```
# Design: <feature-name>

## Governance
- **Feature ID:** FEAT-<stable-id>
- **Revision:** <integer>
- **Status:** draft | in-review | approved | superseded
- **Updated:** <ISO-8601 timestamp>
- **Input revisions:** requirements=<revision>; code-analysis=<revision>
- **Input hashes:** requirements.md=<sha256>; ../code-analysis.md=<sha256>
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>

## Trace
- **FR-IDs covered:** FR-01, FR-02
- **NFR-IDs covered:** NFR-01
- **Requirements:** ../requirements.md
- **Code analysis:** ../../code-analysis.md

## Architecture

### DES-COMP-01: [Component]
- **Responsibility:** [responsibility]
- **Change:** new | existing | modified
- **Trace:** FR-01; NFR-01
- **Evidence:** CA-01, CA-02

### DES-FLOW-01: [Flow]
- **Flow:** [Source] -> [Transform/Action] -> [Destination]
- **Trace:** FR-01; NFR-01

## Data Models

### DES-DATA-01: [Entity/schema]
- **Contract:** [fields, relationships, validation]
- **Migration:** [forward migration and data handling]
- **Trace:** FR-02; NFR-01

## Interface Contracts

### DES-API-01: [METHOD] [path]
- **Input:** [schema]
- **Output:** [status code, schema]
- **Errors:** [status codes and meanings]
- **Compatibility:** [consumer/version impact]
- **Trace:** FR-01; NFR-01

### DES-INT-01: [Module.method(params) -> return_type]
- **Pre:** [preconditions]
- **Post:** [postconditions]
- **Trace:** FR-01; NFR-01

## Design Decisions

### ADR-01: [Decision title]
- **Status:** proposed | accepted | superseded
- **Trace:** FR-01; NFR-01
- **Chosen:** [approach]
- **Rationale:** [why]
- **Rejected:** [alternative] — [why]
- **Risks:** [risk, likelihood/impact, mitigation]
- **Migration:** [rollout/data transition or none]
- **Compatibility:** [backward/forward compatibility impact]
- **Rollback:** [trigger and concrete reversal procedure]
- **Observability:** [logs, metrics, traces, alerts, success threshold]
```

**Rules:**
- Every component, flow, data model, interface, and decision SHALL have a stable `DES-*` or `ADR-*` ID and per-element FR/NFR links. IDs SHALL NOT be renumbered or reused.
- The Trace section SHALL account for every applicable FR and NFR. Any uncovered requirement SHALL be explicit and block approval.
- Governance SHALL pin exact input revisions and hashes; changed inputs make an approved design stale until reviewed.
- Each ADR SHALL address risks, migration, compatibility, rollback, and observability, using `none — <reason>` where genuinely inapplicable.
- Sections with no feature content SHALL be omitted.
- Design SHALL contain only cross-cutting content. Per-task contracts and acceptance criteria belong in task files.

**Example:**
> ### DES-COMP-01: ResetService
> - **Responsibility:** Orchestrate token creation and email dispatch
> - **Change:** new
> - **Trace:** FR-01, FR-02; NFR-01
> - **Evidence:** CA-01, CA-02
>
> ### ADR-01: Store reset tokens in PostgreSQL
> - **Status:** accepted
> - **Trace:** FR-02; NFR-02
> - **Chosen:** Existing PostgreSQL database
> - **Rationale:** Tokens survive restarts without new infrastructure
> - **Rejected:** Redis TTL — unnecessary dependency for expected load
> - **Risks:** Expired-row growth; medium/low; scheduled deletion
> - **Migration:** Add token table before deploying writers
> - **Compatibility:** Additive schema change; old application version remains compatible
> - **Rollback:** Disable writers, deploy prior version, then drop the unused table
> - **Observability:** Count create/consume failures and alert above 1% for 5 minutes
