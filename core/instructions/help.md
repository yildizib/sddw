# Help Instructions

Provide a workflow overview, list features, and show feature status. This is a
utility step and does not require a questionnaire.

## Routing

Parse the platform command arguments:

- No argument: show the workflow overview.
- `list`: list all features.
- `status <feature-name>`: show detailed feature status.

## Workflow Overview

Describe the seven-step workflow:

1. Requirements
2. Code Analysis (optional)
3. Design
4. Taskify
5. Implement
6. Verify
7. Self-Improve

Also mention the combined Design and Taskify flow, the Chat flow, and the Help
utility. The platform adapter supplies the actual command names.

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
- Self-improve report and applied/skipped counts

Use file existence for status detection. Do not assume a step is complete from
another step's output.

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
- Self-improve result and date when available

If the feature does not exist, report that it was not found and refer the user
to the platform's Help list command.

## Rules

- Scan the actual filesystem.
- Use resolved absolute paths in user-facing output.
- Detect status from file existence and report content only where a result is required.
- Handle a missing `.sddw/` directory gracefully.
- Never hardcode a platform command name in this core instruction.
