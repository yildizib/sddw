---
name: sddw:design_and_taskify
description: "Generate design.md plus hybrid task files in one combined flow"
argument-hint: "<feature-name> [--auto]"
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
@~/.claude/sddw/core/instructions/design_and_taskify.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/design_and_taskify.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/quality-plan.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/run-manifest.md

# NEXT STEP
After generating the design and task files, suggest:
> Run `/clear` to free up context, then `/sddw:implement <feature-name> --task 1`
