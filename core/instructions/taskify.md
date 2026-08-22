# Taskify Instructions

Generate a complete, dependency-safe task plan from approved lifecycle inputs.

## Prerequisites

Load the feature manifest and validate exact revisions and SHA-256 hashes for requirements, design, applicable ADRs, code analysis, traceability, risks, and quality plan. Requirements and design SHALL be approved and current; all required inputs SHALL share a compatible baseline. Missing, stale, superseded, unapproved, or conflicting inputs block taskification.

If an approved change request references remediation proposals, load the exact CR revision/hash, immutable approval event, and proposal directory. Validate proposal provenance and impact before incorporating them into the staged task graph. Draft, rejected, stale, or unverified CRs SHALL NOT publish tasks.

Create the taskify run manifest at run start and record all input revisions/hashes.

## Process

1. **Discover** - ask one question at a time about task granularity, ownership, and safe parallelism. In `--auto`, infer preferences conservatively.
2. **Propose** - present the task graph with IDs, dependencies, trace links, files, tests, and quality gates.
3. **Generate, validate, and gate** - stage the complete task set, validate it as a graph and against traceability, publish it as `in-review`, request human task-set approval, then update lifecycle records.

## Task Rules

- Assign immutable `TASK-###` IDs. Filenames may include sequence and slug but references SHALL use stable task IDs.
- Every task SHALL link applicable US/FR/NFR/AC, design element, ADR/risk, test obligation, and quality-gate IDs.
- Every approved FR/NFR and AC SHALL be covered by at least one task and planned test, or have an explicit approved `not-applicable: <reason>` disposition.
- Include concrete production and test paths, task-specific contracts and acceptance criteria, verifiable done criteria, and affected existing tests for interface changes.
- Declare dependencies by task ID. Validate that every reference exists, the directed graph has no cycles, and the order is topologically executable. Identify tasks safe for parallel execution without inventing dependencies.
- Validate bidirectional trace completeness: no task, test obligation, or quality activity may be orphaned from an approved requirement or change request.
- Update `traceability-matrix.md`, `feature-manifest.md`, and the run manifest with exact task-set revision/hash links and outcomes.

## Publication and Revision

- Publish task files only after the whole staged set passes ID, DAG, path, AC/test/quality-link, and trace-completeness validation. On failure, publish none of the staged task changes and record recovery in the run manifest.
- SHALL NOT directly mutate approved or baselined tasks. Changes require a change request and regenerated task-set revision, preserving superseded history and invalidating affected downstream work.
- Interactive mode requires confirmation before publication. `--auto` may publish a draft task set but cannot approve gates, waivers, or risks.
- Task-set approval is a mandatory human gate. Record a platform-verifiable approval reference, approver, decision, and time; pending approval blocks Implement.
- Publishing remediation converts approved proposals into canonical task files within the new task-set revision, records the source CR/proposal links, and leaves the proposal evidence unchanged.

## Clean Transition

Apply current task and lifecycle formats only to newly generated or regenerated feature artifacts. Do not rewrite unchanged legacy tasks.

## Output

```text
<resolved-sddw-path>/<feature-name>/design/tasks/task-<N>-<slug>.md
<resolved-sddw-path>/<feature-name>/runs/run-<YYYYMMDDTHHMMSSZ>-taskify.md
```
