---
name: sddw:design
description: Generate cross-cutting design artefact (design.md) with architecture, data models, interfaces, and decisions — without generating task files
argument-hint: "<feature-name> [--auto]"
---

<feature_name> #$ARGUMENTS </feature_name>

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/design.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/design.md

# SPECS
@~/.claude/sddw/core/specs/design.md

# NEXT STEP
After the user approves the design, suggest:
> Run `/clear` to free up context, then `/sddw:taskify <feature-name>`
