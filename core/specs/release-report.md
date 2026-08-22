# Release Report

Records what actually occurred during release and post-release validation.

**Location:** `.sddw/<feature-name>/release/runs/<run-id>.md`

**Optional latest pointer:** `.sddw/<feature-name>/release/latest.md` SHALL contain only the latest run ID/path and SHALL NOT duplicate the report.

## Format

```markdown
# Release Report: <feature-name> <version>
- **Feature ID:** <ID>
- **Run ID:** <stable run ID>
- **Report revision:** <integer>
- **Prior report:** <run ID/hash or none>
- **Plan revision/hash:** <revision#sha256>
- **Execution result:** <pending | succeeded | failed | rolled-back | unverifiable>
- **Lifecycle status:** <recording | monitoring | closed>
- **Target:** <environment>
- **Released SHA/artifacts:** <full SHA and immutable IDs>
- **Started/ended:** <ISO-8601 UTC>
- **Release owner/approver:** <identities>

## Execution
| Phase/time | Actual action | Result | Evidence | Deviation/CR |
|---|---|---|---|---|

## Release and Deployment
- **Hosted release:** <succeeded | failed | unverifiable | N/A: justified reason> — <immutable ID/URL and evidence>
- **Deployment/promotion:** <succeeded | failed | rolled-back | unverifiable | N/A: justified reason> — <target, actor, time, and evidence>

## Migration
- **Result:** <not-required | succeeded | failed | reversed | forward-fixed>
- **Evidence:** <logs/checks/backups>

## Smoke Tests
| ID | Result | Observed evidence | Trace ID |
|---|---|---|---|

## Monitoring
| Signal/window | Observed | Threshold | Result | Action |
|---|---|---|---|---|

## Rollback or Incident
- **Triggered:** <yes/no>
- **Reason/decision time:** <details or none>
- **Outcome:** <rollback/forward-fix result or none>
- **Incident/problem link:** <link or none>

## Post-Release
- **Known issues:** <items or none>
- **Follow-up owners/dates:** <items or none>
- **Observation window complete:** <ISO-8601 UTC or pending>
- **Final human sign-off:** <identity/date/immutable event ID or URL, or pending>
```

## Rules

- Record actual actions, times, immutable released identifiers, evidence, and deviations. Do not copy planned values without verification.
- `Execution result: succeeded` requires completed applicable release/deployment actions and smoke tests. `Lifecycle status: closed` additionally requires the monitoring window, follow-up assignment, trace update, metrics update, and final human sign-off.
- Failure or rollback SHALL preserve evidence, link the incident/change request, and update risks and the feature manifest. Released status SHALL never be inferred from CI success alone.
- `N/A` is allowed only for a named field that is genuinely inapplicable and SHALL include a concrete reason. Missing evidence is `unverifiable`, not `N/A`.
- Run ID SHALL be unique and a report SHALL NOT be overwritten. New observations or reassessments create a new report linked to the prior report and MAY update only `release/latest.md`.
