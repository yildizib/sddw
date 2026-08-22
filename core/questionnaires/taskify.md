# Taskify Questionnaire

Create a complete executable task graph one question at a time. In `--auto`, infer conservative defaults but never approve gates, waivers, or risks.

## Preflight

Present validated requirement, design, ADR, traceability, risk, quality-plan, code-analysis, manifest, and baseline revisions/hashes. If any required input is missing, stale, superseded, unapproved, or conflicting, stop with the single blocking reason.

If the manifest lists an approved remediation change request, present its exact revision/hash, immutable approval reference, impact, and proposal paths. Validate it before including those proposals in the task graph; do not consume draft, rejected, stale, or unverified requests.

If an approved task set exists and no approved CR was loaded for this task-set revision, ask whether to initiate a change request. When a validated approved remediation CR is loaded, use it as the sole change authorization and do not require a second CR. Never offer direct mutation or overwrite.

## Discover

Ask one question about task granularity. Wait for the answer. If needed, ask one separate question about ownership or safe parallel streams. Do not combine preferences in one prompt.

## Propose

Present the candidate graph as text before asking for a decision. Each row includes:

| Task ID | Outcome | Depends on | FR/NFR/AC | Design/ADR/Risk | Tests | Quality gates |
|---|---|---|---|---|---|---|
| TASK-001 | <outcome> | none | <IDs> | <IDs> | <obligations> | <QG IDs> |

Include concrete production/test paths, affected existing tests, task-specific contracts, acceptance criteria, and verifiable done criteria. Then ask one question about the breakdown. If sequencing needs adjustment, ask that as a later separate question.

## Validate and Generate

Before publication, report:

- ID/reference validation;
- missing FR/NFR/AC, test, design, risk, or quality links;
- orphan tasks/test obligations;
- missing dependencies;
- DAG cycle result and topological order;
- safe parallel groups.

Ask one final generation confirmation. Stage all task files and lifecycle updates, then publish only if the complete set passes validation. On failure, publish no staged task changes and record recovery in the run manifest.

Update traceability, the feature manifest, and the run manifest with the task-set revision and exact hashes. Request formal human task-set approval and record its platform-verifiable reference. Regenerating approved/baselined tasks requires a change request and new revision.
