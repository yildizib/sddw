---
name: sddw:taskify
description: Generate hybrid task files from requirements.md + design.md
argument-hint: "<feature-name> [--auto]"
---

<feature_name> #$ARGUMENTS </feature_name>

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/taskify.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/taskify.md

# SPECS
@~/.claude/sddw/core/specs/design-task.md

# NEXT STEP
After generating the task files, suggest:
> Run `/clear` to free up context, then `/sddw:implement <feature-name> --task 1`
