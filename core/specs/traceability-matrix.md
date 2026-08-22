# Traceability Matrix

Provides bidirectional, evidence-based traceability from intent through release.

**Location:** `.sddw/<feature-name>/traceability-matrix.md`

## Format

```markdown
# Traceability Matrix: <feature-name>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Status:** <draft | in-review | approved | stale | superseded>

| Story | FR/NFR | AC | Design/ADR | Task | Test | Commit | PR | Release |
|---|---|---|---|---|---|---|---|---|
| US-01 | FR-01, NFR-01 | AC-01.1 | design.md#..., ADR-001 | TASK-001 | test/path::name | <SHA> | <URL/#> | release/latest.md#... |

## Gaps
| Missing link | Reason | Owner | Due | Blocking |
|---|---|---|---|---|

## Approval
- **Decision:** <pending | approved | rejected>
- **Approver:** <identity>
- **At:** <ISO-8601 UTC>
- **Approval reference:** <immutable platform event ID/URL>
```

## Rules

- Every story SHALL map to at least one FR or NFR. Every FR/NFR SHALL map to acceptance criteria, design or an explicit `not-needed` rationale, tasks, and test/quality evidence before Review may pass.
- Commit and PR links become required before merge; release links become required before release closure. Those future-stage cells SHALL be `pending` before the lifecycle reaches them and SHALL NOT block an earlier gate. Use `not-applicable: <reason>` only when justified.
- Each non-pending cell SHALL contain stable IDs and resolvable paths, anchors, SHAs, or URLs.
- Traceability is bidirectional: no task, production code commit, test, or release item may be orphaned from an FR/NFR or approved change request.
- Removed requirements remain as `superseded` trace rows linked to the approving change request; history SHALL NOT be silently deleted.
- Approval requires no unexplained blocking gap. Any input change marks the matrix stale through the feature manifest.
