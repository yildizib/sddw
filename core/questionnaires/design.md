# Design Questionnaire

Develop a traceable design one concern at a time. In `--auto`, draft from validated evidence but never grant approvals, waivers, or risk acceptance.

## Preflight

Present the exact requirements revision/hash and human approval, feature-manifest revision/status, baseline SHA, trace state, and code-analysis freshness. If an input is missing, stale, superseded, unapproved, or conflicting, stop and identify the single blocking resolution.

If a design already exists, ask one question appropriate to its state: abort, continue an unapproved draft as a new revision, or initiate a change request for an approved/baselined design. Never offer overwrite.

## Discover

Ask one question at a time about the highest-value unknown, waiting after each:

- architecture and integration boundaries;
- data ownership and migration;
- interface and compatibility obligations;
- security/privacy and operational risks;
- rollback or forward-fix constraints;
- observability signals, thresholds, and ownership.

Base options on repository evidence and show evidence before asking the question.

## Research and Propose

Present exactly one design concern or decision at a time. Assign stable IDs and include traced FR/NFR/AC IDs, evidence, alternatives, consequences, and risks.

Cover applicable concerns:

1. `DES-###` architecture components and flows
2. `DES-###` data models and migration/data conversion
3. `DES-###` interfaces and backward/forward compatibility
4. `ADR-###` decisions with chosen and rejected alternatives
5. `RISK-###` threats, mitigations, triggers, owners, and residual risk
6. rollback/forward-fix behavior
7. observability signals, thresholds, alerts, dashboards, and response owner

After each proposal, ask one approval or correction question. Human acceptance of a proposal does not bypass formal ADR, risk, waiver, or artifact approval records.

## Generate

Present one final generation confirmation with design IDs, coverage, ADRs, risks, migration, compatibility, rollback, observability, and unresolved items. Then stage and validate the design, ADRs, traceability changes, risk changes, feature-manifest update, and run-manifest result.

Publish as `in-review` only when every FR/NFR has design coverage or an explicit disposition and all references/hashes agree. Request formal human design/ADR approval and record its platform-verifiable reference. Changes to an approved design require a change request and new revision; never mutate or silently overwrite it.
