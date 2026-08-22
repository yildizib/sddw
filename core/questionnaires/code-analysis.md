# Code Analysis Questionnaire

Gather scope and review evidence one question at a time. In `--auto`, derive answers from approved requirements and repository evidence without inventing facts or approvals.

## Preflight

Present the exact requirements revision/hash, approval, absolute project root, baseline SHA, and manifest freshness. If any value is invalid, ask at most one resolution question and otherwise stop blocked.

## Discover

Ask one question, wait, and then choose the next based on the answer:

- Which module or behavior deserves the deepest scan?
- Should any path be excluded, and why?
- Is there a known convention, integration boundary, or technical-debt area to investigate?
- Is there a relevant flow, interface, or test suite whose behavior is easy to misunderstand?

Do not turn this list into a multi-part prompt.

## Scan and Propose

Record the full baseline SHA, scan time, tools, scanned paths, and skipped paths with reasons. Inspect patterns, interfaces, flows, dependency direction, conventions, policies, reusable components, and affected tests.

Present one evidence category at a time as readable text. For each finding include:

- finding ID and statement;
- `path:line`, symbol, command result, or immutable source;
- observed fact versus inference;
- confidence and rationale;
- freshness relative to baseline and observation time.

After presenting one category, ask one correction/confirmation question. Continue with relevant patterns, interfaces and boundaries, existing flows, conventions/policies, tests, and unknowns. In `--auto`, record the evidence assessment without claiming user confirmation.

## Generate

Present one publication confirmation with baseline, scanned/skipped scope, finding counts by confidence, and unresolved unknowns. On confirmation, publish a new or regenerated analysis revision and update the feature manifest and run manifest.

If an approved or baselined analysis would change, ask whether to initiate a change request; never offer direct editing or overwrite. A changed baseline marks affected findings stale and requires regeneration rather than silent carry-forward.
