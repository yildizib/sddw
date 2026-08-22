# Implement Step Instructions

Implement a single task from the design spec. The user specifies which task to execute.

## Input

- `<feature-name>` — the feature being implemented
- `--task <N>` — the task number to execute (e.g., `--task 1`)

If no `--task` is provided, list available tasks and ask the user which to execute.

## Prerequisites

**Step 1 — Read `design.md` (required):**

Read `<resolved-sddw-path>/<feature-name>/design/design.md`.

If `design.md` is missing: inform the user that `design.md` is required for this feature, suggest regenerating the Design step, and do NOT propose implementation.

**Step 2 — Read the task file:**

Read `<resolved-sddw-path>/<feature-name>/design/tasks/task-<N>-*.md`.

Read `<resolved-sddw-path>/<feature-name>/feature-manifest.md`. It is the lifecycle authority. A missing manifest blocks implementation.

Use the canonical absolute Project path from `<resolved-sddw-path>/<feature-name>/requirements.md` as the working directory only after confirming it exactly matches the validated project root.

Check `Depends on:`. Every dependency SHALL be complete before implementation; risk acceptance cannot override DAG order.

Reference only if needed:
- `<resolved-sddw-path>/code-analysis.md` — for codebase patterns and conventions (may not exist)
- `<resolved-sddw-path>/<feature-name>/requirements.md` — if acceptance criteria need clarification

## Preflight

Before proposing or changing code, SHALL:

1. Resolve and validate the project root and the allowed write boundary.
2. Inspect repository instructions to discover branch, commit, test, formatting, and dependency conventions.
3. Record the current branch and stop on a protected branch unless repository instructions explicitly permit the work and the user approves the exception.
4. Inspect the worktree and preserve all pre-existing user changes; do not require a clean worktree.
5. Validate every task dependency. Stop unless each is complete and evidenced by a valid completion report.
6. Record each requirements, design, task, and quality-plan ledger revision and SHA-256 plus the manifest revision and code baseline SHA. Stop if an input is not approved, or any revision/hash is stale, missing, or conflicting.
7. Create the implementation run manifest before material work and record actual actions, checks, outputs, failures, and recovery state throughout execution.

Preflight SHALL NOT fetch, switch branches, install dependencies, modify lockfiles, discard changes, or create commits implicitly. Any applicable action remains subject to common.md human gates.

## Process

Follow the three-phase flow defined in the questionnaire:

1. **Discover** — Identify the task, check dependencies, ask if there's any context since the design was written. *In `--auto`: perform non-gated discovery autonomously.*

2. **Research & Propose** — Scan codebase for current state of files, research test patterns and library usage. Propose implementation approach grounded in BOTH `design.md` (cross-cutting Architecture / Data Models / Design Decisions) AND the task file (task-specific Files / Contracts / Acceptance Criteria / Done Criteria), and TDD applicability. User confirms. *In `--auto`: research and decide approach autonomously.*

3. **Execute & Report** — Implement following TDD Protocol, Commit Protocol, and Deviation Handling below. Write the completion report, then make an optional commit only when explicitly authorized. Report completion and suggest the next task.

---

## TDD Protocol

Check the Testing Approach in `.sddw/<feature-name>/requirements.md` Constraints section. Follow the user's chosen approach:
- **TDD** — always write tests first
- **Test-after** — implement first, add tests after
- **Selective TDD** — TDD for business logic/APIs, skip for config/glue code
- **No automated tests** — treat automated tests as waived only by an approved human requirements decision; perform all other required checks and record the waiver

If Selective TDD or no preference specified, use TDD for tasks involving business logic, APIs, validation, data transformations, or algorithms. Skip TDD for UI layout, configuration, glue code, and simple CRUD.

**Heuristic:** Can you write `expect(fn(input)).toBe(output)` before writing `fn`? If yes, use TDD.

**RED — Write failing test:**
1. Create test file following project conventions
2. Write test describing expected behaviour from the acceptance criteria
3. Run test — it MUST fail
4. If test passes: feature already exists or test is wrong — investigate

**GREEN — Implement to pass:**
1. Write minimal code to make the test pass
2. No cleverness, no optimisation — just make it work
3. Run test — it MUST pass

**REFACTOR (if needed):**
1. Clean up implementation if obvious improvements exist
2. Run tests — MUST still pass

**Rules:**
- Limit refinement to 3-5 iterations — if still failing, escalate to user
- SHALL NOT modify tests to make them pass — fix the implementation instead
- If tests reveal a spec gap, stop and use the artifact change request and revision lifecycle; SHALL NOT directly modify an approved or baselined task or requirement

---

## Commit Protocol

One task is one logical change and, if a commit is authorized, one final commit. TDD RED/GREEN/REFACTOR phases SHALL occur in the worktree and SHALL NOT require separate commits.

Commits are optional. SHALL NOT stage or commit unless the user explicitly authorizes that action. Authorization to implement, `--auto`, or a task instruction is not commit authorization.

Before an authorized commit, discover and follow repository conventions from project documentation. SHALL NOT impose a hardcoded message format. Commit only after the completion report is written and all required checks pass or each exception has an explicit human-approved waiver.

**Stage individually:**
```
git add src/specific/file.py
git add tests/specific/test_file.py
```

**Never use** `git add .` or `git add -A`.

**Rules:**
- Commit messages SHALL follow discovered repository conventions and SHOULD reference applicable FR-IDs when those conventions allow it
- SHALL NOT commit partial implementations that break tests
- SHALL NOT commit unrelated changes in the same commit
- SHALL NOT push, open a pull request, or merge without a separate mandatory human approval

---

## Deviation Handling

Deviations during implementation are normal. Classify and handle:

| Rule | Trigger | Action | Permission |
|------|---------|--------|------------|
| **1: Bug** | Broken behaviour, errors, type errors, security vulnerabilities | Fix → test → verify → document | Auto only when no common.md gate applies |
| **2: Missing Critical** | Missing essentials: error handling, validation, auth checks, input sanitisation | Add → test → verify → document | Auto only when no common.md gate applies |
| **3: Blocking** | Prevents completion: wrong types, broken imports, missing config | Fix blocker → verify → document | Auto only within approved scope and safety boundaries |
| **4: Architectural** | Structural change: new DB table, schema change, new service, switching libraries, breaking API | STOP → present impact → document | Mandatory human gate |

**Priority:** common.md mandatory gates > Rule 4 (STOP) > Rules 1-3 (auto) > unsure → Rule 4.

**Rules:**
- ALL deviations SHALL be documented (rule number, what was found, what was done)
- Auto-fixed deviations (Rules 1-3) SHALL be recorded in the completion report
- Dependency changes and all common.md gated changes SHALL NOT be auto-fixed
- If a deviation reveals a spec gap, record it in the completion report and initiate the artifact revision lifecycle; do not mutate the current task file

---

## Completion Report

After implementation and required checks, write a completion report before any optional authorized commit:
`.sddw/<feature-name>/implement/tasks/task-<N>-<slug>.done.md`

Create the `implement/tasks/` directory if it does not exist. The report documents artifact revisions, what was done, checks and waivers, deviations, difficulties, and whether a commit is pending. Update the feature manifest for the report before any optional commit. The report SHALL NOT require its own commit hash. Record commit links later in the artifact manifest or pull request metadata; do not rewrite the report solely to add a self-referential hash.

Complete the run manifest with the report hash, code diff evidence, quality results, and final state. Update the traceability matrix and feature manifest with actual test, quality, completion, and optional later commit/PR evidence; never invent links that do not yet exist.

## Output

- Implemented code for the specified task
- Completion report (`.done.md`) in `implement/tasks/`
- Optional single commit, only with explicit user authorization
