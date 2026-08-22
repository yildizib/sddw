# Change Request

Records a proposed change to an approved or implementation-active feature and determines invalidation and reapproval.

**Location:** `.sddw/<feature-name>/changes/CR-<NNN>-<slug>.md`

## Format

```markdown
# CR-<NNN>: <title>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Status:** <proposed | analyzing | approved | rejected | implemented | verified | closed>
- **Requested by:** <identity>
- **Requested at:** <ISO-8601 UTC>
- **Reason:** <why the change is needed>

## Proposed Change
- **Before:** <current behavior/scope>
- **After:** <requested behavior/scope>
- **Out of scope:** <explicit exclusions>

## Impact
| Area/artifact | Impact | Risk | Action | Reapproval required |
|---|---|---|---|---|
| <ID/path> | <none | direct | transitive> | <summary> | <regenerate/update/none> | <yes/no> |

## Trace Changes
- **Add:** <trace IDs or none>
- **Modify:** <trace IDs or none>
- **Remove:** <trace IDs or none>

## Decision
- **Decision:** <pending | approved | rejected>
- **Approver:** <named human or pending>
- **Decided at:** <ISO-8601 UTC or pending>
- **Approval reference:** <immutable platform event ID/URL or pending>
- **Conditions:** <conditions or none>

## Completion
- **Artifacts revised:** <artifact@revision list>
- **Code/PR:** <commit and PR links or none>
- **Verification:** <evidence link or pending>
```

## Rules

- Analysis SHALL cover requirements, NFRs, acceptance criteria, design/ADRs, tasks, tests, security/privacy, data/migration, operations, documentation, release, and rollback.
- Approval SHALL precede implementation when scope, accepted behavior, architecture, risk, or release commitments change.
- Approved impact SHALL update the feature manifest: increment affected artifacts, mark downstream artifacts stale, clear invalid approvals, and set required gates to `pending`.
- Reapproval is required for every materially changed artifact and for every affected mandatory human gate. A reviewer SHALL NOT infer approval from implementation.
- `implemented` requires traceable code evidence; `verified` requires passing affected checks; `closed` requires manifest and traceability updates.
