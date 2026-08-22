# Design and Taskify Questionnaire

Produce an atomic design and task-set revision through a one-question-at-a-time dialog. In `--auto`, draft autonomously from validated evidence but never grant human approvals, waivers, or risk acceptance.

## Preflight

Present the exact human-approved requirements revision/hash, manifest status/revision, baseline SHA, trace state, risk and quality-plan revisions, and code-analysis freshness. Missing, stale, superseded, unapproved, or conflicting inputs block the operation.

If design or tasks exist, ask one state-appropriate question: abort, regenerate unapproved drafts as new revisions, or initiate a change request for approved/baselined artifacts. Never offer overwrite.

## Discover

Ask one question at a time and wait after each. Start with the most consequential architecture unknown. Ask task granularity and parallelism only after design constraints are understood, and as separate questions.

Cover architecture boundaries, data/migration, compatibility, risks, rollback, observability, task ownership, granularity, and safe parallel work without combining them into a checklist prompt.

## Design Proposals

Present one concern at a time with stable IDs, FR/NFR/AC trace links, repository evidence, alternatives, consequences, and risks:

1. `DES-###` architecture and flows
2. `DES-###` data models and migration
3. `DES-###` interfaces and compatibility
4. `ADR-###` decisions and rejected alternatives
5. `RISK-###` mitigations, triggers, owners, and residual risk
6. rollback/forward-fix and observability

After each concern, ask one correction/acceptance question.

## Task Proposal

After the design draft is coherent, present the complete candidate DAG as text:

| Task ID | Outcome | Depends on | FR/NFR/AC | Design/ADR/Risk | Tests | Quality gates |
|---|---|---|---|---|---|---|

Use stable `TASK-###` IDs and include concrete files, affected tests, contracts, acceptance criteria, and done criteria. Ask one question about task granularity. Ask any sequencing correction as a separate follow-up.

## Atomic Generate

Present one final confirmation summarizing design coverage, ADRs, risks, migration, compatibility, rollback, observability, task/test/quality coverage, and DAG order.

On confirmation:

1. Stage design, ADRs, tasks, traceability, risk, feature-manifest, and run-manifest changes without altering canonical outputs.
2. Validate IDs, hashes, every FR/NFR/AC disposition, bidirectional trace completeness, task references, quality links, and an acyclic topologically executable DAG.
3. Atomically publish the complete set only if every validation passes.

If any stage fails, publish no partial design or task set, restore the pre-run canonical state, and record failure and recovery. Approved/baselined changes require a change request and new revisions.
