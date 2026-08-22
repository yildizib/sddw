# Code Analysis Instructions

Analyse the actual target codebase and record reproducible evidence that can ground feature design.

## Prerequisites

Load the feature manifest and its exact requirements revision. Requirements SHALL be human-approved, current, hash-valid, and bound to the same absolute project root and baseline. A missing, stale, unapproved, or conflicting input blocks analysis.

Create a run manifest at run start. Record the full baseline SHA and all input revisions/hashes.

## Process

1. **Scope** - ask one question at a time about relevant areas, exclusions, conventions, and known hazards. In `--auto`, determine scope from requirements and repository evidence.
2. **Scan** - inspect relevant architecture, interfaces, flows, dependencies, conventions, tests, policies, and reusable components at the recorded baseline.
3. **Publish** - validate findings, publish a new or regenerated code-analysis revision, and update the feature manifest and run manifest with its hash and result.

## Evidence Rules

- Record the full code baseline SHA, scan time, scanner/tool identity, explicitly scanned paths, and skipped/excluded paths with reasons.
- Every material finding SHALL cite resolvable evidence such as `path:line`, symbol, policy file, command result, or immutable URL.
- Assign each finding a confidence level with rationale and a freshness statement tied to the baseline and observation time.
- Distinguish observed facts from inference and unknowns. SHALL NOT present an assumption as repository fact.
- Identify reusable components, dependency direction, integration boundaries, tests affected by interface changes, and conventions implementation must follow.
- A baseline change or changed evidence makes affected findings stale; do not silently carry them forward.

## Publication and Revision

- Preserve project-level analysis that remains valid; add feature-relevant evidence without deleting unrelated valid findings.
- If the shared analysis is approved or baselined, SHALL NOT edit it in place. Use a change request and a new revision, preserve superseded history, and invalidate dependent artifacts where applicable.
- Update `feature-manifest.md` with the analysis revision/hash/status/inputs and update the run manifest with actual actions, scanned/skipped scope, output hash, and success, failure, or blocked state.
- Interactive mode requires confirmation before publication. `--auto` may publish a draft revision but cannot grant a human approval or waiver.

## Clean Transition

Apply current metadata and evidence rules only when generating or regenerating analysis. Do not rewrite unchanged legacy analysis merely to migrate its format.

## Output

```text
<resolved-sddw-path>/code-analysis.md
<resolved-sddw-path>/<feature-name>/runs/run-<YYYYMMDDTHHMMSSZ>-code-analysis.md
```
