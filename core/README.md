# sddw Core

The core contains the platform-independent Spec-Driven Development workflow.

It governs the full lifecycle: Requirements, optional Code Analysis, Design,
Taskify, Implement, Verify, independent Review, Release readiness and
post-release recording, then Self-Improve. `design_and_taskify` combines Design
and Taskify without changing their outputs or gates. Chat and Help are
utilities rather than lifecycle gates.

## Contents

- `instructions/` — workflow process rules
- `questionnaires/` — platform-neutral interaction guidance
- `specs/` — artifact formats and output contracts
- `interaction.md` — normalized interaction concepts
- `steps.txt` — supported workflow steps
- `security/trust-model.md` — instruction precedence, trust boundaries, safeguards, and mandatory human gates

The core must not reference a host platform, platform-specific tool, command
syntax, installation path, or adapter directory. Platform adapters consume the
core and provide those mappings separately.

## Governance Contract

The feature manifest is the lifecycle authority. It binds artifacts to a
stable feature identity, code baseline, revision, SHA-256 hash, dependency,
approval, invalidation state, and gate result. Steps consume exact
`artifact@revision#hash` inputs and record actual work in run manifests.

Automation may recommend decisions and prepare evidence, but it cannot approve
requirements or material scope changes, accept security or production risk,
approve waivers, accept unresolved review findings, authorize destructive or
remote operations, or sign off a release. `--auto`, delegation, retries, and
adapter permissions do not bypass these gates. Missing named-human approval is
recorded as pending and blocks dependent work.

Changing an upstream artifact makes affected downstream artifacts `stale`,
invalidates their approvals, resets their gates to `pending`, and blocks
progress until regeneration or explicit human disposition. A stale artifact
cannot authorize implementation, review, or release.

## Artifacts and Status

The core specifications define the feature manifest, requirements, optional
code analysis, decisions, design and tasks, task completion reports,
traceability matrix, risk register, quality plan, run manifests, verification
report, independent review report, release plan and report, metrics, change
requests, and self-improvement report. A stage may create or update several of
these artifacts; the lifecycle is not a one-file-per-step pipeline.

Lifecycle, artifact, gate, verification, run, review, and release statuses are
separate vocabularies defined by their specs. In particular, verification
`PASS` requires all tasks complete, every FR and NFR `PASS`, and every required quality
gate `PASS`. `PARTIAL`, `UNVERIFIED`, `WAIVED`, pending, stale, or failed
required evidence prevents overall `PASS`. A waiver remains `WAIVED` and is
never converted into `PASS`.

Review must be independent and tied to exact current revisions and the code
baseline. Review `PASS` requires valid evidence, complete traceability, passing
quality gates, release/rollback readiness, and no blocking findings. It permits
release preparation only. Lifecycle completion requires actual post-release
evidence, `Execution result: succeeded`, and `Lifecycle status: closed` with final human sign-off.

## Artifact Transition

Every new or regenerated artifact uses the current manifest/revision templates.
Existing artifacts remain readable evidence, but the core does not migrate
them solely to adopt the current model and has no legacy migration,
compatibility, or dual-write layer.
