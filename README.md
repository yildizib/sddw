<p align="center">
  <img src="assets/banner.png" alt="SDD — Spec Driven Development" width="600">
</p>

# `sddw`

[![X (Twitter)](https://img.shields.io/badge/X-@SDDWorkflows-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/SDDWorkflows)
[![Slides](https://img.shields.io/badge/Slides-SDD%20Workflow-FBBC04?style=for-the-badge&logo=googleslides&logoColor=white)](https://docs.google.com/presentation/d/1SjKXF7hkoqyiN9-3tBGY4PDGvS3iqVyovDlJC_hYvMA/edit?usp=sharing)

> This repository is a fork of [sermakarevich/sddw](https://github.com/sermakarevich/sddw).
> The original project history, author attribution, and MIT license are preserved.
> This fork is independently maintained at [yildizib/sddw](https://github.com/yildizib/sddw)
> and adds an isolated platform-independent core with Claude Code and OpenCode adapters.
>
> This fork is not the upstream repository and is not affiliated with the original
> maintainers unless explicitly stated. Original project links and branding are
> retained for attribution.

Platform-independent Spec-Driven Development Workflow with adapters for
[Claude Code](https://docs.anthropic.com/en/docs/claude-code) and OpenCode.

- Govern work from **requirements** through **release and post-release evidence**, with optional code analysis, design, task planning, implementation, verification, independent review, and self-improvement
- Persist a revisioned feature manifest, traceability, risks, quality gates, run evidence, review findings, release records, metrics, and change requests
- Keep humans in control of scope, risk acceptance, waivers, destructive operations, remote side effects, and release sign-off; `--auto` cannot bypass these gates
- Use guided dialog by default or `--auto` for non-gated analysis and drafting
- Keep the workflow lightweight and customizable with Markdown artifacts and no runtime dependencies

The workflow core is isolated from platform integrations. Claude and OpenCode
adapters provide only command syntax, tool mappings, and installation. A new
platform can be added under `adapters/` without changing the core workflow.

Platform support is installed through the adapter installers. Native Claude
plugin metadata is not required.

## Why

The standard way to use AI coding agents is short, interactive prompts: describe what you want, get code, fix it, repeat. This works for small tasks but breaks down for anything non-trivial — context gets lost between sessions, architectural decisions live only in chat history, and there's no artifact a teammate can review before code is written.

`sddw` inverts this. Instead of prompting for code, you collaborate with the agent to write **specifications** — requirements, architecture, interface contracts, task breakdowns. The specs become the primary artifact: reviewable by peers, version-controlled, persistent across sessions. Code generation is then a mechanical step guided by approved specs, not a creative leap from a vague prompt.

Detailed specifications reduce AI code errors by up to 50% (Piskala, 2026), security defects by 73% (Marri, 2026), and architecture-misaligned PRs by 60% (GitHub Spec Kit). `sddw` is designed for medium to large projects that don't fit into a single context window. By splitting work into discrete steps — requirements, codebase analysis, design, per-task implementation — each step operates within a focused context where models are more accurate, rather than a sprawling conversation where critical details get lost.

## Install

Clone the source repository outside the platform configuration directories:

```bash
git clone https://github.com/yildizib/sddw.git ~/sddw
cd ~/sddw
```

Choose install or uninstall and then select Claude, OpenCode, or both:

```bash
bash bin/install.sh
```

For non-interactive use, provide the action and adapter target:

```bash
bash bin/install.sh install all
bash bin/install.sh uninstall opencode
```

### Direct Adapter Installers

Install only the Claude adapter globally:

```bash
bash adapters/claude/install.sh
```

This copies an isolated runtime snapshot to `~/.claude/sddw` and installs the
commands under `~/.claude/commands/sddw`.

Install only the OpenCode adapter globally:

```bash
bash adapters/opencode/install.sh
```

This copies a separate runtime snapshot to `~/.config/opencode/sddw` and
installs the commands under `~/.config/opencode/commands`.

The installers never create runtime Git clones or source symlinks. Source core
and adapter command changes affect an installed snapshot only after its
installer is run again. Claude and OpenCode snapshots can be updated
independently.

Unknown command or runtime collisions are rejected. Use `--force` only when an
existing conflicting sddw installation may be replaced:

```bash
bash adapters/opencode/install.sh --force
```

The first migration from a pre-snapshot clone or symlink installation also
requires `--force` when legacy command wrappers already exist. Later snapshot
updates are managed automatically.

Uninstall only the files managed by an adapter:

```bash
bash adapters/claude/install.sh --uninstall
bash adapters/opencode/install.sh --uninstall
```

Run an installed OpenCode command from the project directory:

```bash
opencode run --auto --command sddw-help
opencode run --auto --command sddw-requirements -- \
  "--auto feature-name Describe the feature to specify"
```

OpenCode's CLI `--auto` flag approves tool permissions. The second `--auto`,
inside the command message after `--`, enables the sddw workflow's autonomous
mode.

Restart Claude Code or OpenCode after installing or updating an adapter so the
new command definitions are loaded.

## Interaction Modes

Lifecycle commands support two interaction modes:

| Mode | Flag | Behavior |
|------|------|----------|
| **Interactive** | *(default)* | Guided dialog, explicit decisions, and human confirmation at required gates |
| **Auto** | `--auto` | Automates non-gated discovery, analysis, drafting, and local execution within granted permissions |

`--auto` is not blanket authorization. It cannot accept requirements or material
scope changes, accept security or production risk, approve a waiver, resolve a
blocking review finding, use secrets, transfer non-public data, perform a
destructive operation, or authorize remote Git, deployment, rollback, or
release actions. A named human must approve each mandatory gate, and missing
approval leaves the gate pending and blocks dependent work.

Run lifecycle commands from the target project root. If the host adapter accepts
additional arguments, `--project <path>` may identify that root explicitly;
commands never search unrelated parent or Git directories for `.sddw/`.

Claude Code uses the `/sddw:<step>` command format. OpenCode uses the
equivalent `/sddw-<step>` command format. Both adapters use the same core
workflow instructions, questionnaires, specifications, and `.sddw/` artifact
layout.

## Usage

Use the default mode when decisions should be developed interactively. Use
`--auto` to reduce ceremony while preserving repository policy, evidence
requirements, and mandatory human control points.

## Governed Lifecycle

1. **Requirements** — collaboratively produce a feature spec with user stories, FRs, and acceptance criteria
2. **Code Analysis** *(optional)* — inspect an existing codebase, its interfaces, and project conventions
3. **Design** — define architecture, models, contracts, decisions, risks, and quality implications
4. **Taskify** — create dependency-ordered task files tied to requirements and design revisions
5. **Implement** — execute scoped tasks, record deviations and actual run evidence, and follow discovered repository policy
6. **Verify** — evaluate every requirement, task, and required quality gate against current evidence
7. **Independent Review** — review exact artifact revisions, code, tests, risks, and release/rollback readiness outside the implementer's chain of context
8. **Release** — first prepare release readiness; after authorized humans perform the release, record deployment, smoke, monitoring, rollback, and final sign-off evidence
9. **Self-Improve** — analyse lifecycle evidence and propose workflow changes without applying them automatically

**Design & Taskify** (`/sddw:design_and_taskify`) is a combined command for
running the Design and Taskify stages together. It produces the same governed
artifacts and does not skip approvals or revision checks.

**Chat** and **Help** are utilities, not lifecycle gates. Chat can answer
questions and handle appropriately scoped artifact or code changes while still
enforcing invalidation and authorization rules. Help describes commands, lists
features, and reports manifest-derived status.

### 1. Requirements

```
/sddw:requirements <feature-name> [--auto]
```

Collaboratively produce a requirements spec through guided dialog:

- **Discover** — understand the feature through one-at-a-time questions
- **Research & Propose** — research SOTA, codebase, domain; propose each section with ranked options
- **Confirm & Generate** — user approves each block, spec is written

Output: `.sddw/<feature-name>/requirements.md`
Requirements also initialize or update the feature manifest and supporting
governance artifacts. Human acceptance of requirements and material scope
changes is mandatory.

### 2. Code Analysis (optional)

```
/sddw:code-analysis <feature-name> [--auto]
```

Analyse the existing codebase to ground design decisions in reality:

- **Discover** — understand which areas of the codebase matter most
- **Research & Propose** — scan for patterns, interfaces, flows, conventions
- **Confirm & Generate** — user approves each section, analysis is written

Output: `.sddw/code-analysis.md` (shared across features and referenced by exact revision/hash)
Sections: Relevant Patterns, Key Interfaces, Existing Flows, Conventions

Skip this step for greenfield projects with no existing codebase.

### 3. Design

```
/sddw:design <feature-name> [--auto]
```

Produce a cross-cutting `design.md` through guided dialog:

- **Discover** — understand architectural preferences and constraints
- **Research & Propose** — propose architecture, data models, contracts, and decisions
- **Confirm & Generate** — user approves each block, `design.md` is written

Output: `.sddw/<feature-name>/design/design.md`

### 4. Taskify

```
/sddw:taskify <feature-name> [--auto]
```

Break the feature into hybrid task files based on requirements and design:

- **Discover** — understand task granularity preferences
- **Research & Propose** — propose task breakdown in dependency order
- **Confirm & Generate** — user approves task list, task files are written

Output:

```
.sddw/<feature-name>/
└── design/
    ├── design.md
    └── tasks/
        ├── task-1-<slug>.md  # hybrid: files, criteria, references design.md
        ├── task-2-<slug>.md
        └── ...
```

Each task file includes task-specific details inline and references `design.md` for architecture, models, and shared contracts, so the implementation agent has full context without duplication.

### Design & Taskify (Combined Alias)

```
/sddw:design_and_taskify <feature-name> [--auto]
```

Runs the design and taskify steps in one shot. Use this for small features where iterating on architecture independently is not needed.

### 5. Implement

```
/sddw:implement <feature-name> --task <N> [--auto]
```

Execute a single task from the design spec:

- **Discover** — select task, check dependencies, gather context
- **Research & Propose** — scan codebase, propose implementation approach and TDD applicability
- **Execute** — implement following the approved artifacts, discovered project conventions, test protocol, and deviation handling

Each task file is a hybrid — the agent loads it alongside `design.md` so it has full context.

After each task, a completion report (`task-<N>-<slug>.done.md`) is written to
`implement/tasks/`, documenting what was done, evidence, deviations, and
difficulties. SDDW does not commit merely because implementation completed;
commits occur only when the user explicitly authorizes them and must follow the
target repository's issue, branch, commit, and pull request conventions.

### 6. Verify

```
/sddw:verify <feature-name> [--auto]
```

Verify the implementation against requirements after all tasks are complete:

- **Assess** — load artifacts, detect test runner, check task completion status
- **Verify** — run test suite, cross-check each FR's acceptance criteria, review done criteria
- **Report & Remediate** — produce verification report, create remediation tasks if issues found

Output:

```
.sddw/<feature-name>/
└── verify/
    ├── latest.md
    └── runs/<run-id>.md    # immutable verification evidence
```

If issues are found, remediation tasks or change requests are created and the
affected artifacts are revised. Downstream artifacts become stale until they
are regenerated or explicitly dispositioned, then implementation and
verification repeat.

### 7. Independent Review

```
/sddw:review <feature-name> [--auto]
```

Review approved specifications, implementation, tests, traceability, quality
evidence, risks, and release/rollback readiness. The implementer cannot be the
sole reviewer: record a human reviewer, separate agent, or fresh-context
boundary. A changed input revision or code baseline makes the report stale and
requires a new review. Review cannot pass conditionally or with unresolved
blocking findings.

Output: `.sddw/<feature-name>/review/runs/<run-id>.md` with `review/latest.md` pointing to the current report

### 8. Release Readiness and Post-Release

```
/sddw:release <feature-name> [--auto]
/sddw:release <feature-name> --post-release [--auto]
```

Readiness mode requires an independent review `PASS` for the exact candidate
revision and creates an ordered plan for approvals, remote actions, deployment,
smoke tests, monitoring, and rollback. It records planned work as planned and
does not claim that a release occurred.

Post-release mode records actual, attributable evidence after authorized humans
perform release and deployment actions. The lifecycle is complete only when
the release report is `closed`: rollout and smoke checks succeeded, the
monitoring window completed, follow-ups, traceability, and metrics were
updated, and a named human gave final sign-off.

Outputs: `.sddw/<feature-name>/release/plan.md` and immutable reports under
`.sddw/<feature-name>/release/runs/`, with `release/latest.md` as a pointer

### 9. Self-Improve

```
/sddw:self-improve <feature-name> [--auto]
```

Analyse the governed lifecycle evidence after release/post-release handling.
Identify what went wrong or could be better and propose concrete improvements
to the workflow itself:

- **Analyse** — extract signals: deviations, difficulties, remediation task origins, spec gaps
- **Diagnose** — classify findings by workflow step, identify patterns, propose improvements
- **Report** — record proposals with concrete diff previews without modifying workflow files

Output:

```
.sddw/<feature-name>/
└── self-improve/
    ├── latest.md
    └── reports/<report-id>.md    # findings and proposals with diff previews
```

Each improvement targets a specific workflow component (instruction, questionnaire, or spec) with a concrete diff. Maintainers can review and apply those proposals separately.

### Chat

```
/sddw:chat <feature-name> [--auto]
```

Fast-track interaction with a feature that already has artifacts. Skips the full questionnaire ceremony — just load context and talk.

- **Questions** — ask anything about the feature; answered from loaded artifacts and codebase
- **Spec updates** — revise requirements, FRs, acceptance criteria, or task files through the manifest and invalidate affected downstream evidence
- **Quick implementation** — small code changes following TDD and commit protocols
- **Status** — check feature progress

Chat assumes you know what you want and only pauses for scope-affecting changes or ambiguous requests.

If a request is too large (new task files, new architecture, >3 files), chat redirects you to the full workflow.

### Help

```
/sddw:help [list | status <feature-name>]
```

- `/sddw:help` — workflow overview and available commands
- `/sddw:help list` — list all features with progress indicators
- `/sddw:help status <feature-name>` — detailed feature status: which steps are done, task progress, completion reports

## Artifact Model

Artifacts are a revisioned evidence graph, not one output per step. The feature
manifest is the authority for identity, code baseline, artifact revisions and
hashes, approvals, invalidation, lifecycle status, and gates. Dependencies use
`<artifact-id>@<revision>#<sha256>` so consumers can prove exactly which input
they used.

```text
.sddw/
├── code-analysis.md                         # optional shared analysis
└── <feature-name>/
    ├── feature-manifest.md                  # lifecycle authority and ledger
    ├── requirements.md
    ├── traceability-matrix.md               # intent through release evidence
    ├── risk-register.md
    ├── metrics.md
    ├── decisions/
    │   └── ADR-<NNN>-<slug>.md
    ├── changes/
    │   └── CR-<NNN>-<slug>.md
    ├── history/
    │   └── <artifact-id>/rev-<N>.md
    ├── quality/
    │   └── plan.md
    ├── design/
    │   ├── design.md
    │   └── tasks/task-<N>-<slug>.md
    ├── implement/
    │   └── tasks/task-<N>-<slug>.done.md
    ├── runs/
    │   └── run-<timestamp>-<step>.md
    ├── verify/
    │   ├── latest.md
    │   └── runs/<run-id>.md
    ├── review/
    │   ├── latest.md
    │   └── runs/<run-id>.md
    ├── release/
    │   ├── plan.md
    │   ├── latest.md
    │   └── runs/<run-id>.md
    └── self-improve/
        ├── latest.md
        └── reports/<report-id>.md
```

Changing an upstream artifact increments its revision. Dependent artifacts are
marked `stale`, their approvals are cleared, affected gates return to
`pending`, and the lifecycle is `blocked` until the impact is resolved. Change
requests preserve the reason and impact instead of silently rewriting history.

### Clean Transition

The current manifest and revision model applies to every newly generated or
regenerated artifact. Existing artifacts remain readable evidence, but SDDW
does not migrate them merely to adopt the model and provides no legacy
migration, compatibility, or dual-write layer. Regeneration uses the current
template and governance rules.

### Status and PASS Semantics

Status vocabularies are scoped and must not be mixed:

- **Lifecycle:** `proposed`, `specified`, `designed`, `planned`, `implementing`, `verifying`, `reviewed`, `release-ready`, `released`, `blocked`, or `cancelled`.
- **Artifacts:** `draft`, `in-review`, `approved`, `stale`, `superseded`, or `waived`.
- **Manifest gates:** quality is `pending`, `passed`, `failed`, or `waived`; review is `pending`, `PASS`, `FAIL`, or `BLOCKED`; release is `pending`, `approved`, `blocked`, or `released`.
- **Verification items:** `PASS`, `FAIL`, `PARTIAL`, `UNVERIFIED`, or `WAIVED`.
- **Runs:** `running`, `succeeded`, `failed`, `blocked`, `interrupted`, or `resumed`.
- **Review reports:** `in-progress`, `final`, or `stale`, with a result of `PASS`, `FAIL`, or `BLOCKED`.
- **Release plans:** `draft`, `approved`, `executing`, `blocked`, `completed`, or `stale`.
- **Release reports:** execution is `pending`, `succeeded`, `failed`, `rolled-back`, or `unverifiable`; lifecycle status is `recording`, `monitoring`, or `closed`.

Verification is overall `PASS` only when every task is complete, every FR and
NFR is `PASS`, and every required quality check is `PASS`. `PARTIAL`, `UNVERIFIED`,
`WAIVED`, pending work, or a failed required check prevents overall `PASS`; a
waiver is always reported as `WAIVED`, never promoted to `PASS`. Independent
review passes only for the exact current revisions and baseline when all
mandatory evidence is valid, traceability and quality are complete, and no
blocking finding remains. Review `PASS` enables release preparation but is not
release approval or proof of release.

## Anatomy of a Step

Lifecycle behavior is assembled from platform-independent core components and
thin adapter commands:

| Component | Purpose | Folder |
|-----------|---------|--------|
| **Command** | Thin platform entry point with frontmatter and core references | `adapters/<platform>/commands/` |
| **Claude adapter** | Claude command wrappers, bridge, and installer | `adapters/claude/` |
| **OpenCode adapter** | OpenCode command wrappers, bridge, and installer | `adapters/opencode/` |
| **Instructions** | Process rules — what to do, in what order | `core/instructions/` |
| **Questionnaire** | Platform-neutral dialog guidance | `core/questionnaires/` |
| **Specs** | Output format templates — what to produce | `core/specs/` |

A command wires these together:

```
┌──────────────────────────────────────────────────────────┐
│ adapters/<platform>/commands/<step>.md                    │
│                                                          │
│  core/instructions/<step>.md    ← process rules           │
│  core/questionnaires/<step>.md  ← dialog flow             │
│  core/specs/<step>.md           ← output format           │
│                                                          │
│  reads:  manifest-selected artifact revisions             │
│  writes: governed artifacts, evidence, and ledger updates │
└──────────────────────────────────────────────────────────┘
```

Each component lives in its own folder so it can be reused, tested, and evolved
independently. Commands remain thin references and glue. Individual stages use
the interaction phases appropriate to their work, while all stages share the
same trust model, revision checks, evidence rules, and non-bypassable gates.
