---
name: sddw:implement
description: Implement tasks from the design spec following TDD and existing codebase patterns
argument-hint: "<feature-name> [--task <task-number>] [--auto]"
---

<!-- managed-by: sddw -->

<feature_name> #$ARGUMENTS </feature_name>

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# INTERACTION CONTRACT
@~/.claude/sddw/core/interaction.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# TRUST MODEL
@~/.claude/sddw/core/security/trust-model.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/implement.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/implement.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/task-completion.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/change-request.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/quality-plan.md
@~/.claude/sddw/core/specs/run-manifest.md

# NEXT STEP
After completing a task, suggest the next unblocked task:
> `/sddw:implement <feature-name> --task <next-N>`
When all tasks are complete, suggest verification:
> Run `/clear` to free up context, then `/sddw:verify <feature-name>` to check everything works.
