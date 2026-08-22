# Implement Questionnaire

Three-phase dialog for executing a single task from the design spec.

---

## Phase 1: Discover

*In `--auto`: perform non-gated discovery autonomously. Stop for common.md human gates.*

Understand which task to execute and any blockers. One question at a time.

**Step 1 — Task selection:**

If no --task flag provided:
Present the task table as context text, then use `structured question mechanism` with each pending task as an option:
- Task 1: [name] (Depends on: none)
- Task 2: [name] (Depends on: task 1)
Question: "Which task would you like to implement?"

Wait for response.

If --task flag provided, check dependencies:
> "Task [N]: [name]. Dependencies: [status of each]."
> If blocked: describe the missing dependency and concrete risks, then use `structured question mechanism` with options "Accept the documented risk for this execution" / "No — pick a different task (Recommended)". Record any acceptance. In `--auto`, stop and request this decision.

Wait for response.

**Step 2 — Context check:**
> "Any context I should know before implementing this? (e.g., changes since the design was written, preferences on approach)"

Wait for response.

---

## Phase 2: Research & Propose

Based on the task file, research implementation approach and propose a plan.

### 2.1 Research

- **Preflight** — resolve project root, inspect repository conventions, branch and protection status, preserve worktree changes, validate dependencies, and record current artifact revisions
- **Codebase scan** — check current state of files listed in the task (may have changed since design)
- **Test patterns** — identify existing test conventions in the project
- **Library docs** — if the task involves unfamiliar APIs or libraries, research usage patterns

### 2.2 Propose

**Implementation approach:**
> "For this task, I'll:"
> 1. [Step 1 — what I'll do first and why]
> 2. [Step 2]
> 3. [Step 3]
> "TDD: [yes/no — with reasoning based on heuristic]"
> "Proceed?"

Wait for response. User confirms → execute following the instructions.

*In `--auto`: decide the non-gated implementation approach autonomously and proceed. Mandatory human gates still stop execution.*

---

## Phase 3: Confirm & Report

After task completion:

> "Task [N] complete:"
> - Implemented: [what was done]
> - Artifact revisions: [requirements/design/task/manifest revisions]
> - Quality checks: [PASS | FAIL | PARTIAL | UNVERIFIED | WAIVED, with evidence]
> - Commit: [not requested | pending authorization | hash if separately authorized]
> - Deviations: [count by rule, or "none"]
> - Done criteria: [all checked / issues]

Write the completion report before any optional authorized commit. The report SHALL NOT require its own commit hash; later commit links belong in the manifest or pull request metadata.

> If unblocked tasks remain:
> "Next unblocked tasks: [list]."
> "**Recommendation:** Start a fresh context before starting the next task. Each task execution is isolated — a fresh context avoids accumulated noise from this implementation."
> "Then start the Implement step for the next task."
>
> If all tasks are complete:
> "All tasks complete."
> "**Recommendation:** Start a fresh context, then complete the Verify step to check everything works."
