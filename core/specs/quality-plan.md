# Quality Plan

Defines project-specific, reproducible quality gates before implementation begins.

**Location:** `.sddw/<feature-name>/quality/plan.md`

## Format

```markdown
# Quality Plan: <feature-name>
- **Feature ID:** <ID>
- **Revision:** <integer>
- **Status:** <draft | approved | stale | superseded>
- **Project profile source:** <policy/config paths>

## Gates
| ID | Gate | Class | Exact command/procedure | Working directory | Pass criteria | Evidence | Status |
|---|---|---|---|---|---|---|---|
| QG-01 | <format/lint/test/build/...> | <required | conditional | waived> | `<command>` | `<absolute/relative path>` | <exit/output/threshold> | <run/result link> | <pending | passed | failed | skipped | waived> |

## Conditional Gates
| Gate | Trigger | Required when triggered | Decision/evidence |
|---|---|---|---|

## Waivers
| Gate | Reason | Risk ID | Compensating control | Expiry | Human approver | Approved at | Approval reference |
|---|---|---|---|---|---|---|---|

## Approval
- **Decision:** <pending | approved | rejected>
- **Approver:** <identity>
- **At:** <ISO-8601 UTC>
- **Approval reference:** <immutable platform event ID/URL>
```

## Rules

- Discover commands from repository policy, scripts, CI, build files, and test configuration; SHALL NOT substitute generic commands when project-specific commands exist.
- Include applicable formatting, static analysis, unit, integration, end-to-end, security, migration, build, packaging, performance, accessibility, and smoke checks.
- `required` gates always run. `conditional` gates define an objective trigger and become required when triggered. `waived` gates require rationale, linked risk, compensating control, expiry, named human approval, and an immutable platform event ID/URL.
- Commands SHALL be exact, non-interactive, and scoped with working directory, environment prerequisites, and deterministic pass criteria. Secrets SHALL be referenced by name, never value.
- A failed, missing, stale, or unapproved required gate blocks review and release. Automated execution cannot approve a waiver.
