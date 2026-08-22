# Help Instructions

Provide a workflow overview, list features, and show feature status. This is a
utility step and does not require a questionnaire.

## Routing

Parse the platform command arguments:

- No argument: show the workflow overview.
- `list`: list all features.
- `status <feature-name>`: show detailed feature status.

## Workflow Overview

Describe the lifecycle:

1. Requirements
2. Code Analysis (optional)
3. Design
4. Taskify
5. Implement
6. Verify
7. Review
8. Release
9. Self-Improve

List utilities separately from lifecycle steps: combined Design and Taskify,
Chat, and Help. The platform adapter supplies the actual command names.

## List Features

Scan `.sddw/` for feature directories. Exclude shared files such as
`.sddw/code-analysis.md`.

For each feature, report the status of:

- Requirements
- Code Analysis
- Design
- Generated tasks and total task count
- Completed task reports and completion count
- Verification report and result
- Review report and result
- Release record and result
- Self-improve report and proposal count

Use the feature manifest as lifecycle authority. Confirm referenced files exist,
their revision/hash matches the ledger, and their status is not stale. For
legacy features without a manifest, report only observed files and mark governed
status unavailable; do not infer completion.

If `.sddw/` does not exist or contains no feature directories, report that no
features were found and refer the user to the platform's Requirements command.

## Feature Status

For a requested feature, report:

- The feature name
- Each completed or pending workflow step
- Concrete absolute file paths
- Task completion counts
- Pending task dependencies
- Verification result and date when available
- Review result and date when available
- Release result and date when available
- Self-improve result and date when available

If the feature does not exist, report that it was not found and refer the user
to the platform's Help list command.

## Rules

- Scan the actual filesystem.
- Use resolved absolute paths in user-facing output.
- Detect governed status from the manifest and verify referenced file evidence.
- Handle a missing `.sddw/` directory gracefully.
- Never hardcode a platform command name in this core instruction.
