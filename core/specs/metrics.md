# Lifecycle Metrics

Records consistently defined delivery and quality measurements for one feature.

**Location:** `.sddw/<feature-name>/metrics.md`

## Format

```markdown
# Metrics: <feature-name>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Measured at:** <ISO-8601 UTC>
- **Source period/baseline:** <timestamps and baseline SHA>

| Metric | Value | Unit | Definition/window | Evidence/source |
|---|---:|---|---|---|
| Lead time | <value> | hours | request created to production release | <links/timestamps> |
| Cycle time | <value> | hours | approved work start to release | <links/timestamps> |
| First-pass rate | <value> | percent | gates passing on first execution / gates first executed x 100 | <run IDs> |
| Remediation | <count/time> | count/hours | findings or failed gates requiring rework, and elapsed remediation time | <CR/review/run IDs> |
| Escaped defects | <count> | count | feature-caused defects found after release in the observation window | <incident IDs> |
| Churn | <value> | percent | changed lines later replaced/reverted before release / total changed lines x 100 | <diff source> |
| Trace coverage | <value> | percent | FR/NFR rows with all required lifecycle links / total FR/NFR rows x 100 | traceability-matrix.md |
| Human interventions | <count> | count | manual decisions, overrides, retries, or recovery actions beyond mandatory approvals | <run/approval IDs> |
| Cost | <value> | <currency/tokens> | optional model, compute, and service cost using stated rates | <billing/run source> |

## Notes
- **Excluded data:** <items and reasons or none>
- **Interpretation:** <material context, not conclusions unsupported by evidence>
```

## Rules

- Use source timestamps and immutable evidence; state timezone, observation window, exclusions, and missing data. Unknown values are `not-available`, never zero.
- Keep definitions stable across features. If a project overrides a definition, record the exact formula and source while retaining the standard metric name.
- Cost is optional; all other metrics SHALL be recorded at release closure when source data exists.
- Metrics are diagnostic, not approval gates. They SHALL NOT incentivize skipped tests, hidden interventions, compressed review, or other unsafe behavior.
