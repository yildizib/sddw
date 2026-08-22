## Requirements File Format

Governed statement of feature intent. IDs are permanent trace keys used by design, tasks, tests, verification, and improvement reports.

**Location:** `.sddw/<feature-name>/requirements.md`

**Format:**
```
# Requirements: <feature-name>

## Governance
- **Feature ID:** FEAT-<stable-id>
- **Revision:** <integer>
- **Status:** draft | in-review | approved | superseded
- **Updated:** <ISO-8601 timestamp>
- **Input hashes:** <source path or URI>=<sha256>; ...
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>

## Project
- **Path:** [resolved absolute target project root]

## Purpose
[What the feature does and why it matters, without implementation detail.]

## User Stories
- **US-01:** As a [role], I want [capability], so that [benefit]. — **Source:** SRC-01 — **Confidence:** high | medium | low

## Functional Requirements
- **FR-01:** [Subject] SHALL [atomic, testable capability]. — **Source:** SRC-01 — **Confidence:** high | medium | low

## Non-Functional Requirements
- **NFR-01:** [Subject] SHALL [measurable quality, security, performance, or operational constraint]. — **Source:** SRC-01 — **Confidence:** high | medium | low

## Acceptance Criteria

### AC-01.1 — FR-01: [Scenario title]
- **Type:** happy | failure | boundary
- **Basis:** SRC-01
- **GIVEN** [precondition]
- **WHEN** [action]
- **THEN** [expected, measurable outcome]

## Constraints

### In Scope
- [What this feature delivers]

### Out of Scope
- [What is excluded] — [reason]

### Prohibitions
- SHALL NOT [prohibited behavior] — [reason]

### Testing Approach
- [TDD | Test-after | Selective TDD | No automated tests (human waiver required)] — [rationale]

## Sources and Evidence
- **SRC-01:** [path, URL, issue, interview, or observation] — [claim supported] — [accessed ISO date]

## Assumptions
- **ASM-01:** [assumption] — **Confidence:** high | medium | low — **Impact if false:** [impact]

## Open Questions
- **Q-01:** [question] — **Owner:** [name/role] — **Blocking:** yes | no — **Status:** open | resolved — **Resolution evidence:** [SRC-ID or none]
```

**Rules:**
- Project path SHALL be resolved once and persisted as an absolute canonical project root. User input `.` or a relative path is allowed only before resolution and SHALL NOT be stored as relative text.
- `Feature ID` SHALL remain unchanged for the life of the feature.
- `Revision` SHALL increase whenever approved meaning changes; status and approval metadata SHALL reflect the current decision state.
- Input hashes SHALL cover every source artifact used to produce the revision and SHALL use a named deterministic algorithm.
- Every user story, FR, NFR, AC, source, assumption, and question SHALL have a stable ID. IDs SHALL NOT be reused or renumbered after publication; removed entries remain recorded as deprecated.
- FRs and NFRs SHALL be separate, atomic, testable, and use RFC 2119 keywords. NFRs SHALL include a measurable threshold or an explicit verification method.
- Every FR and NFR SHALL have at least one AC. Relevant NFRs SHALL also be linked by ID from downstream design elements.
- Acceptance criteria SHALL include happy, failure, and at least one feature-level boundary scenario, with enough precision to generate tests without interpretation.
- In Scope SHALL align with stories and requirements. Every exclusion and prohibition SHALL include a reason.
- Claims SHALL cite source or evidence IDs. Unknowns SHALL be recorded as assumptions or open questions, not presented as facts.
- Low-confidence assumptions and blocking open questions SHALL prevent approval unless the approver explicitly records acceptance.

**Example:**
> - **US-01:** As a registered user, I want to request a password reset, so that I can regain account access. — **Source:** SRC-01 — **Confidence:** high
> - **FR-01:** The system SHALL send a reset link for a registered account. — **Source:** SRC-01 — **Confidence:** high
> - **NFR-01:** The request endpoint SHALL return the same response for registered and unknown email addresses. — **Source:** SRC-02 — **Confidence:** high
>
> ### AC-01.1 — FR-01: Registered account
> - **Type:** happy
> - **Basis:** SRC-01
> - **GIVEN** a registered user with email `user@example.com`
> - **WHEN** the user requests a password reset
> - **THEN** the system SHALL enqueue one email containing a unique reset link within 60 seconds
