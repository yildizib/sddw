---
name: sddw:implement
description: Implement tasks from the design spec following TDD and existing codebase patterns
argument-hint: "<feature-name> [--task <task-number>] [--auto]"
---

<feature_name> #$ARGUMENTS </feature_name>

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/implement.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/implement.md

# SPECS
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/task-completion.md

# NEXT STEP
After completing a task, suggest the next unblocked task:
> `/sddw:implement <feature-name> --task <next-N>`
When all tasks are complete, suggest verification:
> Run `/clear` to free up context, then `/sddw:verify <feature-name>` to check everything works.
