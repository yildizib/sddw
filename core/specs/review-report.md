# Review Report

Records an independent review of approved specifications, code changes, tests, traceability, and release readiness.

**Location:** `.sddw/<feature-name>/review/runs/<run-id>.md`

**Optional latest pointer:** `.sddw/<feature-name>/review/latest.md` SHALL contain only the latest run ID/path and SHALL NOT duplicate the report.

## Format

```markdown
# Review Report: <feature-name>
- **Feature ID:** <ID>
- **Run ID:** <stable run ID>
- **Revision:** <integer>
- **Status:** <in-progress | final | stale>
- **Reviewed code:** <full commit SHA | baseline SHA + normalized diff SHA-256>
- **Artifact inputs:** <artifact@revision#hash list>
- **Reviewer:** <human identity or agent/model/run ID>
- **Independence:** <human | separate-agent | fresh-context> — compared with <implementation run/context IDs>
- **Reviewed at:** <ISO-8601 UTC>

## Scope
- <paths, diff range, artifacts, and exclusions>

## Findings
| ID | Severity | Trace/risk IDs | Location | Finding and evidence | Required action | Status |
|---|---|---|---|---|---|---|
| REV-001 | <critical | high | medium | low> | <IDs> | <path:line> | <specific defect> | <remediation> | <open | resolved | accepted> |

## Checks
- **Requirements/design conformance:** <pass/fail + evidence>
- **Test adequacy and results:** <pass/fail + evidence>
- **Security/privacy:** <pass/fail/not-applicable + evidence>
- **Traceability:** <pass/fail + evidence>
- **Quality gates:** <pass/fail + evidence>
- **Release/rollback readiness:** <pass/fail/not-ready + evidence>

## Verdict
- **Result:** <PASS | FAIL | BLOCKED>
- **Residual concerns:** <list or none>
- **Human approval:** <identity/date/immutable event ID or URL, or pending>
```

## Rules

- The implementer SHALL NOT be the sole reviewer. Review requires a human reviewer, a separate agent, or a fresh context without the implementation chain-of-context; record which boundary was used.
- Run ID SHALL be unique and the report SHALL NOT be overwritten. Re-runs create new files and MAY update only the latest pointer.
- Review SHALL use exact manifest revisions, hashes, and code baseline. Changed inputs make the report stale and require review again.
- Findings come first, are evidence-based, and link locations and trace/risk IDs. Critical or high findings block `PASS` and cannot be waived into passage. Accepted lower-severity findings require named human risk acceptance.
- `PASS` requires resolved blocking findings, passing required quality gates, stage-complete traceability, and release/rollback readiness. `FAIL` means review findings require remediation. `BLOCKED` means required evidence or independence is unavailable.
