# Decision Record

Captures one consequential architectural, security, data, operational, or workflow decision.

**Location:** `.sddw/<feature-name>/decisions/ADR-<NNN>-<slug>.md`

## Format

```markdown
# ADR-<NNN>: <decision>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Status:** <proposed | accepted | rejected | superseded>
- **Date:** <ISO date>
- **Owners:** <identities>
- **Supersedes/Superseded by:** <ADR IDs or none>

## Context
<forces, constraints, evidence, and linked FR/NFR/risk IDs>

## Options
| Option | Benefits | Costs/risks |
|---|---|---|

## Decision
<chosen option and exact scope>

## Consequences
- **Positive:** <outcomes>
- **Negative:** <trade-offs/debt>
- **Follow-up:** <tasks, tests, monitoring, or none>

## Approval
- **Decision:** <pending | approved | rejected>
- **Approver:** <named human where mandatory>
- **At:** <ISO-8601 UTC>
- **Approval reference:** <immutable platform event ID/URL>
```

## Rules

- Record the decision before dependent implementation. Link affected trace and risk IDs.
- Accepted records are immutable evidence. A changed decision creates a new revision or superseding ADR and invalidates dependent artifacts in the feature manifest.
- Security, privacy, architecture, data-loss, and production-risk acceptance requires named human approval backed by an immutable platform event ID or URL.
