## Verification Report

Immutable, run-specific evidence produced after verification. A convenience pointer may identify the latest run without replacing run history.

**Location:** `.sddw/<feature-name>/verify/runs/<run-id>.md`

**Optional latest pointer:** `.sddw/<feature-name>/verify/latest.md` SHALL contain only the latest run ID/path (or an equivalent symlink) and SHALL NOT duplicate or overwrite the run report.

**Format:**
```
# Verification Report: <feature-name> / <run-id>

## Governance
- **Feature ID:** FEAT-<stable-id>
- **Run ID:** VERIFY-<timestamp-or-stable-run-id>
- **Report revision:** <integer>
- **Status:** final | superseded
- **Started/finished:** <ISO-8601 timestamps>
- **Verified by:** <agent/person and version>
- **Input revisions:** requirements=<N>; code-analysis=<N>; design=<N>; tasks=<IDs/revisions>; completion=<revisions>
- **Input hashes:** [artifact]=<sha256>; ...
- **Code under test:** <full SHA or baseline SHA plus diff hash>
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>

## Summary
- **Requirements:** [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED counts]
- **Tasks:** [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED counts]
- **Quality gates:** [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED counts]
- **Trace completeness:** [covered links]/[required links] — [missing IDs or none]
- **Result:** PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED

## Test and Quality Gate Execution
- **TEST-01:** PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED — [exact command, result, duration, output artifact]
- **QG-01:** PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED — [exact command and evidence]

## Requirement Verification

### FR-01: [title] — PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED
- **AC-01.1:** [status] — [test/evidence]
- **NFR links:** NFR-01 — [status/evidence]
- **Issues:** [issue or none]

### NFR-01: [title] — PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED
- **Evidence:** [quality gate, test, metric, or observation]
- **Issues:** [issue or none]

## Task Verification
- **TASK-001:** [status] — [done criteria met/total; completion report and diff evidence]

## Trace Completeness
- **US -> FR/NFR:** [status and missing links]
- **FR/NFR -> AC:** [status and missing links]
- **AC -> DES/ADR -> TASK:** [status and missing links]
- **TASK -> TEST/QG -> evidence:** [status and missing links]

## Waivers
- **WVR-01:** [criterion/check] — **Reason/Risk:** [details] — **Approver:** [owner/date/reference] — **Expiry:** [date/condition]

## Deviations
- **DEV-01:** [completion deviation] — resolved | unresolved | accepted — [verification evidence]

## Remediation Tasks
- **TASK-004:** [fix] — **Severity:** FAIL | PARTIAL | UNVERIFIED — **Origin:** requirements | design | implementation | external — **Evidence:** [specific ID/output]

## Warnings
- [Non-blocking concern or none]
```

**Status semantics:**
- `PASS`: fully demonstrated by current evidence.
- `FAIL`: evidence demonstrates the criterion is not met.
- `PARTIAL`: only part of the criterion or required scope is demonstrated.
- `UNVERIFIED`: no sufficient evidence was produced.
- `WAIVED`: not demonstrated, but an authorised, time-bounded risk acceptance exists.

**Rules:**
- Run ID SHALL be unique and the run report SHALL NOT be overwritten. Re-runs create new files and MAY update only the latest pointer.
- SHALL use actual command output and evidence, never assumptions, and reference exact test names/errors for failures.
- SHALL classify every FR, NFR, AC, task, test, and quality gate with one defined status.
- Trace completeness SHALL cover all links required through implementation and test/quality evidence at the Verify stage and explicitly list missing links. Future commit, PR, and release links remain `pending` and do not block Verify.
- Overall `PASS` requires every Verify-stage required item to be `PASS`, stage-complete traceability, and zero waivers. Any waiver excludes `PASS`; use `WAIVED` when waivers are the only exception.
- `FAIL` takes precedence over all other statuses. `PARTIAL` applies to incomplete evidence; `UNVERIFIED` applies where evidence is absent.
- Waivers SHALL identify approver, accepted risk, and expiry. Expired or unapproved waivers are `UNVERIFIED`, not `WAIVED`.
- Remediation tasks SHALL include severity, origin, and specific evidence.

**Example:**
> - **Run ID:** VERIFY-20260325T101500Z
> - **Code under test:** `0123456789abcdef0123456789abcdef01234567`
> - **Trace completeness:** 18/18 — none missing
> - **Result:** FAIL
>
> - **TEST-01:** FAIL — `pytest tests/auth/test_reset_token.py -q`; `test_expired_token_is_rejected` accepted a token at exactly 24h
> - **AC-02.1:** FAIL — covered by failing `test_expired_token_is_rejected`
> - **TASK-004:** Fix expiry boundary — **Severity:** FAIL — **Origin:** implementation — **Evidence:** TEST-01 / AC-02.1
