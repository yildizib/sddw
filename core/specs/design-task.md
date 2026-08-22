## Task File Format

Each implementation task has a permanent ID and pins the artifact revisions it was designed from. Cross-cutting content is referenced by stable design IDs.

**Location:** `.sddw/<feature-name>/design/tasks/task-<N>-<slug>.md`

**Format:**
```
# TASK-001: [Action-oriented title]

## Governance
- **Feature ID:** FEAT-<stable-id>
- **Task revision:** <integer>
- **Status:** draft | in-review | ready | blocked | in-progress | completed | superseded
- **Input revisions:** requirements=<revision>; code-analysis=<revision>; design=<revision>
- **Input hashes:** requirements.md=<sha256>; code-analysis.md=<sha256>; design.md=<sha256>
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>

## Trace
- **FR-IDs:** FR-01
- **NFR-IDs:** NFR-01
- **AC-IDs:** AC-01.1, AC-01.2
- **Design IDs:** DES-COMP-01, DES-DATA-01, ADR-01
- **Depends on:** none | TASK-000
- **Dependency state:** ready | blocked — [evidence or blocking reason]

## Files
- `path/to/create.py` — create
- `path/to/modify.py` — modify
- `tests/test_existing.py` — update (interface change)

## Contracts (task-specific)
- **TASK-CONTRACT-01:** [interface and pre/postconditions] — **Trace:** AC-01.1

## Acceptance Criteria

### AC-01.1 — FR-01: [scenario copied verbatim from requirements]
- **GIVEN** [precondition]
- **WHEN** [action]
- **THEN** [expected outcome]

## Verification Links
- **TEST-01:** [test name/type and expected assertion] — AC-01.1
- **QG-01:** [exact command or objective gate] — NFR-01

## Rollback
- **Trigger:** [condition requiring rollback]
- **Procedure:** [concrete reversal steps]
- **Data handling:** [restore/retain/migrate data or none]
- **Verification:** [how successful rollback is confirmed]

## Done Criteria
- [ ] [Specific, programmatically verifiable outcome] — AC-01.1
- [ ] `TEST-01` passes
- [ ] `QG-01` passes or has an approved waiver
```

**Rules:**
- `TASK-*` IDs SHALL be stable and SHALL NOT change when titles, ordering, or filenames change.
- `draft` and `in-review` tasks are non-executable. Only a human-approved task-set revision may mark a canonical task `ready`.
- Artifact revisions and hashes SHALL identify exact task inputs. A changed input SHALL block implementation until impact is reviewed and task revision/status updated.
- Every task SHALL link applicable FR, NFR, AC, design/ADR, test, and quality gate IDs.
- `Depends on` SHALL use task IDs; dependency state SHALL include current evidence and SHALL be `ready` before implementation.
- Relevant acceptance criteria SHALL be copied verbatim with their original AC IDs.
- Cross-cutting content SHALL be referenced by design ID, not duplicated. Only task-specific files, contracts, criteria, and checks are inlined.
- File paths SHALL be concrete. Existing tests affected by public interface changes SHALL be listed as `update (interface change)`.
- Rollback SHALL define a trigger, procedure, data handling, and verification; use `none — <reason>` only when reversal has no meaningful action.
- Empty optional sections SHALL be omitted.

**Example:**
> # TASK-001: Create password reset token storage
>
> - **FR-IDs:** FR-01, FR-02
> - **NFR-IDs:** NFR-01
> - **AC-IDs:** AC-01.1, AC-02.1
> - **Design IDs:** DES-DATA-01, ADR-01
> - **Depends on:** none
> - **Dependency state:** ready — no predecessors
>
> - **TEST-01:** `test_expired_token_is_rejected` — AC-02.1
> - **QG-01:** `pytest tests/auth -q` exits 0 — FR-01, FR-02
