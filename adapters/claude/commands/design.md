---
name: sddw:design
description: Generate cross-cutting design artefact (design.md) with architecture, data models, interfaces, and decisions — without generating task files
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
@~/.claude/sddw/core/instructions/design.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/design.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/decision-record.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/run-manifest.md

# NEXT STEP
After the user approves the design, suggest:
> Run `/clear` to free up context, then `/sddw:taskify <feature-name>`
