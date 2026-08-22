## Codebase Analysis

Evidence-backed baseline of existing patterns, interfaces, and flows. It is shared across features and updated without deleting still-valid findings.

**Location:** `.sddw/code-analysis.md`

**Format:**
```
# Codebase Analysis

## Governance
- **Revision:** <integer>
- **Status:** draft | current | stale | superseded
- **Feature ID:** FEAT-<stable-id> | shared
- **Baseline SHA:** <full 40-character commit SHA>
- **Baseline date:** <ISO-8601 timestamp>
- **Analysed by:** <agent name and version>
- **Input hashes:** <requirements/design source>=<sha256>; ...
- **Approval:** pending | <approver, ISO-8601 timestamp, decision/reference>
- **Freshness:** current as of <SHA/date> | stale because <reason>

## Scan Scope
- **Scanned paths:** [explicit files/directories/globs]
- **Skipped paths:** [explicit paths and reason, or none]

## Relevant Patterns
- **CA-01:** [pattern and behavior] — **Evidence:** `path/file.ext:L10-L24` — **Confidence:** high | medium | low

## Key Interfaces
- **CA-02:** `[Interface.method(params) -> type]`: [purpose] — **Evidence:** `path/file.ext:L30-L42` — **Confidence:** high

## Existing Flows
- **CA-03:** [step-by-step behavior] — **Evidence:** `path/file.ext:L10-L20`, `path/other.ext:L4-L12` — **Confidence:** medium

## Conventions and Dependency Direction
- **CA-04:** [convention or allowed dependency direction] — **Evidence:** `path/file.ext:L1-L18` — **Confidence:** high

## Unknowns
- **CA-Q01:** [unknown] — **Needed evidence:** [path, owner, or runtime observation]
```

**Rules:**
- Baseline SHA SHALL be exact, full-length, and captured with date and analysing agent before conclusions are written.
- Scanned and skipped paths SHALL be explicit enough to reproduce coverage; no skipped area may be implied as analysed.
- Every material finding SHALL have a stable ID, file-and-line evidence, and confidence. Runtime claims SHALL cite run/log evidence in addition to source lines.
- Freshness SHALL be reassessed against the current target SHA before design or implementation. Changed relevant paths make the analysis stale until reviewed.
- SHALL identify reusable components, conventions, and dependency direction before proposing new ones.
- SHALL NOT propose patterns that conflict with observed conventions without flagging the conflict.
- Existing analysis SHALL be revised in place: increase revision, preserve still-valid findings, mark invalid findings superseded, and add feature-relevant sections.
- Unverified conclusions SHALL be recorded under Unknowns rather than stated as facts.

**Example:**
> - **Baseline SHA:** `0123456789abcdef0123456789abcdef01234567`
> - **Baseline date:** 2026-03-25T10:15:00Z
> - **Analysed by:** sddw-agent 1.4.0
> - **Scanned paths:** `src/auth/**`, `src/services/email.py`, `tests/auth/**`
> - **Skipped paths:** `vendor/**` — third-party code
>
> - **CA-01:** Business logic lives in service classes; controllers delegate after validation — **Evidence:** `src/auth/controller.py:L18-L39`, `src/auth/service.py:L11-L58` — **Confidence:** high
> - **CA-02:** `EmailService.send(to, template, context) -> Awaitable[None]` sends through SES — **Evidence:** `src/services/email.py:L22-L47` — **Confidence:** high
