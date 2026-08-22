# Chat Step Instructions

Fast-track interaction with a feature that already has artifacts. Skips the full questionnaire ceremony. The user describes what they need in plain conversation after invoking the command.

## Goal

Provide a direct, low-ceremony way to ask questions, make quick edits, or apply small changes to an existing feature — grounded in its artifacts.

## Prerequisites

Read the feature artifacts from `<resolved-sddw-path>/<feature-name>/`:

| Artifact | Path | Required |
|----------|------|----------|
| Requirements | `<feature-name>/requirements.md` | Yes |
| Feature manifest | `<feature-name>/feature-manifest.md` | For any mutation |
| Code analysis | `code-analysis.md` | No |
| Design | `<feature-name>/design/design.md` | No |
| Task files | `<feature-name>/design/tasks/task-*.md` | No |
| Completion reports | `<feature-name>/implement/tasks/*.done.md` | No |

If `requirements.md` does not exist for the feature, stop and say:
> "Feature '<feature-name>' not found. Start the Requirements step for this feature first."

If the feature manifest is missing, questions remain allowed, but SHALL NOT mutate artifacts or code. Stop mutation requests and direct the user to the owning lifecycle step to establish the manifest.

If no feature name is provided, ask the user with `structured question mechanism`.

## Context Loading

Load all available artifacts **silently** — do not list or summarize what was found. Use them as background context for the conversation.

## Default Interaction Mode

Chat is not interactive by default. It assumes the user knows what they want and acts directly.

The only things that pause and ask:
- All mandatory human gates from common.md
- Changes to approved or baselined artifacts
- Ambiguous requests where the wrong interpretation could cause damage

The `--auto` flag from common.md is respected for non-gated work only. It SHALL NOT remove these pauses.

## Process

After loading artifacts, ask the user what they need:

> "Loaded context for **<feature-name>**. What do you need?"

Then handle requests conversationally. Classify each request and act:

### Question

Trigger: user asks "why", "what", "how", "explain", or any question about the feature.

Action: Answer using loaded artifacts and codebase. No file changes.

### Spec Update

Trigger: user asks to update, change, add to, or remove from requirements, FRs, acceptance criteria, task files, or other spec content.

Action:
1. Identify which artifact to edit
2. Show the proposed change (before/after or diff summary)
3. Determine its lifecycle state. An artifact is directly editable only when explicitly marked as a draft.
4. For a draft, apply the edit unless a mandatory human gate applies.
5. For an approved or baselined artifact, SHALL NOT mutate the current revision. Create the canonical change request under `changes/`, obtain all applicable human approvals, create a new revision through the owning lifecycle step, and update `feature-manifest.md`. If that lifecycle is unavailable, stop and direct the user to the owning step.

### Quick Implementation

Trigger: user describes a code change, fix, or small addition.

Action:
1. Identify which FRs or tasks the change relates to
2. Run the Implement preflight and follow its TDD Protocol, Commit Protocol, and Deviation Handling
3. Write a completion note — but only if a corresponding task file exists. Do not create `.done.md` files for ad-hoc changes that have no task file.
4. Do not commit unless the user explicitly authorizes it; then follow discovered repository conventions

### Status

Trigger: user asks about progress, status, or what remains.

Action: Show feature status using the same logic as `the Help step status <feature-name>`.

## Guardrails

If a request is too large for chat — would require new task files, new architecture, or multiple independent changes — redirect:

> "This looks like it needs a full design pass. Start the combined Design and Taskify step for this feature."

Heuristic: if the change would touch more than 3 files or require more than 1 commit, suggest the full workflow.

## Rules

- SHALL resolve paths using common.md Path Resolution rules (resolve `.sddw/` from current working directory)
- SHALL load artifacts silently — no preamble about what was found
- SHALL reference FR-IDs when making changes that trace to requirements
- SHALL follow commit protocol from implement instructions for any code changes
- SHALL follow deviation handling from implement instructions for any code changes
- SHALL use `structured question mechanism` for disambiguation and all human gates
- SHALL NOT start a full questionnaire flow
- SHALL NOT invent ad-hoc artifact types; lifecycle-required change requests, revisions, and manifest records are allowed
- SHALL NOT create task files — if the work needs a task file, redirect to `the combined Design and Taskify step` or `the Taskify step`
- SHALL NOT directly modify approved or baselined artifacts; use their change request and revision lifecycle
