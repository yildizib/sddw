---
name: sddw:design_and_taskify
description: "Generate design.md plus hybrid task files in one combined flow"
argument-hint: "<feature-name> [--auto]"
---

<feature_name> #$ARGUMENTS </feature_name>

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/design_and_taskify.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/design_and_taskify.md

# SPECS
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/design-task.md

# NEXT STEP
After generating the design and task files, suggest:
> Run `/clear` to free up context, then `/sddw:implement <feature-name> --task 1`
