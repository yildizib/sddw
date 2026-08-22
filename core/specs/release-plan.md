# Release Plan

Defines how an approved feature will be deployed, validated, monitored, and reversed.

**Location:** `.sddw/<feature-name>/release/plan.md`

## Format

```markdown
# Release Plan: <feature-name>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Status:** <draft | approved | executing | blocked | completed | stale>
- **Target/version:** <environment and release version>
- **Candidate SHA/artifacts:** <full SHA and immutable artifact IDs>
- **Window/owner:** <time window and accountable human>

## Preconditions
- [ ] <quality, review, trace, risk, backup, access, capacity, communication gate>

## Ordered Actions and Human Gates
| ID | Depends on | Action type | Planned command/procedure | Mandatory human gate | Approver/operator | Approval reference/status | Evidence to capture | Stop condition |
|---|---|---|---|---|---|---|---|---|
| REL-ACT-01 | none | <local-check/PR/merge/tag/release/deploy/rollback> | <exact action> | <yes/no> | <identity> | <event ID/URL and pending/approved> | <immutable result> | <objective condition> |

## Rollout
| Phase | Scope/percentage | Action | Success criteria | Hold time | Owner | Stop condition |
|---|---|---|---|---|---|---|

## Migration
- **Required:** <yes/no>
- **Procedure:** <ordered, idempotent commands/procedure>
- **Compatibility window:** <old/new compatibility>
- **Backup/restore validation:** <evidence>

## Smoke Tests
| ID | Exact check | Expected result | Trace ID |
|---|---|---|---|

## Monitoring
| Signal | Baseline | Threshold | Window | Dashboard/query | Response owner |
|---|---|---|---|---|---|

## Rollback
- **Decision authority:** <named human/role>
- **Triggers:** <objective conditions>
- **Procedure:** <ordered commands/procedure>
- **Data recovery/forward-fix:** <method>
- **Maximum recovery target:** <RTO/RPO or project target>

## Approval
- **Decision:** <pending | approved | rejected>
- **Approver:** <named human>
- **At:** <ISO-8601 UTC>
- **Approval reference:** <immutable platform event ID/URL>
```

## Rules

- Use exact project-specific deployment and rollback procedures. Production release, migration, destructive operation, and rollback are mandatory human gates.
- Candidate SHA and artifact hashes SHALL match the approved feature manifest. Any change makes the plan stale.
- Rollout SHALL be staged when the platform permits, with measurable success and stop conditions. Irreversible migration requires an approved forward-recovery plan.
- Smoke tests map to critical acceptance criteria. Monitoring includes functional health, errors, latency/capacity, security, and business signals as applicable.
- Release SHALL NOT begin until all preconditions and approvals are complete.
- Every remote Git, PR, merge, tag, hosted release, deployment, promotion, migration, and rollback action SHALL have its own ordered action ID and mandatory human gate. Plan-level approval does not authorize an individual action.
