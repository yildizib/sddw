# Risk Register

Tracks feature risks from discovery through post-release closure.

**Location:** `.sddw/<feature-name>/risk-register.md`

## Format

```markdown
# Risk Register: <feature-name>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Status:** <draft | in-review | approved | stale | superseded>

| ID | Category | Risk/cause/consequence | Likelihood | Impact | Score | Mitigation | Trigger/indicator | Owner | Status | Residual risk | Approval |
|---|---|---|---:|---:|---:|---|---|---|---|---|---|
| RISK-001 | <security/data/...> | If <cause>, then <event>, causing <impact> | 1-5 | 1-5 | LxI | <preventive action> | <observable signal> | <identity> | <open | mitigated | accepted | occurred | closed> | <L/I/score> | <identity/date or pending> |

## Review
- **Reviewed at:** <ISO-8601 UTC>
- **Next review:** <date or lifecycle event>
- **Approved by:** <identity or pending>
```

## Rules

- Assess security, privacy, safety, data integrity, dependency, delivery, operability, migration, rollback, and compliance risks where applicable.
- Score is likelihood multiplied by impact. The project SHALL define action thresholds; absent project policy, scores 15-25 are blocking, 8-14 require mitigation and owner, and 1-7 are monitored.
- Risk acceptance SHALL include residual score, rationale, expiry/review point, named human approval, and an immutable platform event ID/URL. Free-text identity alone is unverified. Automation cannot accept risk.
- Occurred risks link incidents, change requests, tests, or release evidence. Artifact changes that alter risk invalidate dependent approvals in the feature manifest.
