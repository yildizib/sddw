# Self-Improve Questionnaire

Analyse a closed release and generate an advisory, versioned improvement report. Ask one question at a time. Self-improve never edits workflow files or approved feature artifacts.

## Closure Check

Present the exact released revision and evidence state:

- release rollout and smoke result: `succeeded` or not;
- release report lifecycle status: `closed` or not;
- monitoring window and final human sign-off;
- review report and independence boundary;
- manifest, traceability, risk, metrics, and run freshness.

If actual release/post-release closure is not proven, stop with a blocked run manifest. Do not treat a release plan, CI result, verification PASS, review PASS, or `monitoring` state as closure.

## Analyse

Load exact revisions/hashes for requirements, design/ADRs, tasks, completion reports, verification, independent review, quality results, release plan/report, traceability, risks, metrics, and runs.

Present evidence in focused groups:

- requirement/design ambiguity and approved changes;
- implementation deviations, difficulties, and remediation;
- verification and review findings;
- release deviations, migration/rollback, smoke, monitoring, incidents, and escaped defects;
- trace coverage, first-pass rate, lead/cycle time, churn, interventions, and cost where available.

Unknown values remain `not-available`. If root-cause attribution is ambiguous, present the evidence and ask one attribution question. Wait before continuing.

## Diagnose and Propose

Group findings by lifecycle area and cite artifact revisions, run IDs, finding IDs, trace/risk IDs, metrics, or source locations. Distinguish workflow gaps from feature-specific events.

Present proposals as readable text. Each proposal includes:

- stable `IMP-###` ID;
- type and target file/process;
- affected lifecycle area;
- evidence-backed finding;
- minimal proposed change;
- exact diff preview.

After presenting all proposals, ask one question about required clarification or adjustment. Do not offer to apply them.

## Report

Present one report-generation confirmation with evidence coverage, findings, proposals, unavailable data, and any metrics revision. Then:

- write a unique `self-improve/reports/<report-id>.md`;
- never overwrite or rewrite a prior report;
- create a new `metrics.md` revision when post-release evidence changes measurements;
- update the feature manifest and self-improve run manifest with exact revisions/hashes and prior-report links.

Corrections to approved/baselined inputs use their owning change-request and revision lifecycle, never direct mutation.
