# Requirements Questionnaire

Gather and validate one requirements concern at a time. Never combine unanswered questions. In `--auto`, answer discovery questions from evidence where possible, record unsupported answers as assumptions or open questions, and never approve requirements.

## Discover

Ask these concerns naturally, one question at a time, waiting after each:

1. Resolve whether the target is the current directory or another project, then resolve it to an absolute project root and capture the full baseline SHA.
2. Ask what problem the feature solves and who experiences it.
3. Follow the user's emphasis, challenge vague terms, and request a concrete user journey.
4. Clarify observable success, failure behavior, boundaries, prohibitions, and out-of-scope outcomes.
5. Clarify measurable quality expectations and applicable security, privacy, performance, accessibility, reliability, operability, compatibility, and compliance constraints.
6. Clarify testing expectations, issue/branch identity, risk owners, and any unresolved decision.

For each claim, determine its source. Ask one source, assumption, or open-question clarification at a time when evidence is absent or contradictory.

Before proposals, ensure the draft has enough information for:

- stable feature identity, absolute project root, issue, branch, and baseline SHA;
- purpose and `US-##` user stories;
- atomic `FR-##` behavior and measurable `NFR-##` quality attributes;
- `AC-<requirement-number>.<scenario-number>` happy, failure, and boundary scenarios;
- in-scope, out-of-scope, and prohibited behavior;
- sources and supported claims;
- assumptions with validation status/owner;
- open questions with owner and blocking status;
- initial risks and repository-derived quality gates.

## Research and Propose

Research repository evidence, domain standards, security/compliance needs, and relevant external sources. Present findings as text before asking for a decision. Propose exactly one section or one unresolved decision at a time and wait for the response.

Use this order unless the conversation makes another order clearer:

1. Purpose and source basis
2. User stories with stable IDs
3. Functional requirements with stable IDs and RFC 2119 language
4. Non-functional requirements with stable IDs and measurable thresholds
5. Acceptance criteria with stable IDs, one requirement at a time
6. Scope, exclusions, and prohibitions
7. Sources, assumptions, and open questions
8. Risks, testing approach, and draft quality gates

After each proposal, ask one approval or correction question. Mark accepted content as agreed draft content, not as lifecycle approval.

## Generate and Approve

Present one generation confirmation containing counts, blocking questions, key risks, and the artifact set to be initialized. On confirmation, stage and validate:

- `requirements.md`
- `feature-manifest.md`
- `traceability-matrix.md`
- `risk-register.md`
- `quality/plan.md`
- the requirements run manifest

Publish only after IDs, references, hashes, trace rows, risks, and ledger entries are internally consistent.

Then ask the mandatory requirements gate question:

> "Do you approve requirements revision [revision] with SHA-256 [hash] for downstream use?"

Offer `Approve`, `Reject`, and `Request changes`. Record identity, decision, ISO-8601 UTC time, and a platform-verifiable approval reference. Free-text identity without that reference remains unverified.

After requirements approval, ask one separate quality-plan gate question using the same options and evidence requirements. In `--auto`, do not ask on the user's behalf or choose either answer: leave both approvals `pending`, mark downstream work blocked, and report that human approvals are required.

Requested changes to an approved revision require a change request and a new revision; never edit the approved artifact directly.
