---
name: sddw:requirements
description: Generate requirements spec for a feature with user stories, functional requirements, acceptance criteria, and constraints
argument-hint: "<feature-name> [--auto]"
---

<!-- managed-by: sddw -->

<feature_name> #$ARGUMENTS </feature_name>

If no feature name is provided, ask the user to describe the feature they want to build.

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# INTERACTION CONTRACT
@~/.claude/sddw/core/interaction.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# TRUST MODEL
@~/.claude/sddw/core/security/trust-model.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/requirements.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/requirements.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/quality-plan.md
@~/.claude/sddw/core/specs/run-manifest.md

# NEXT STEP
After the user approves the requirements, suggest:
> Run `/clear` to free up context.
> If you have an existing codebase, run `/sddw:code-analysis <feature-name>` to ground design decisions in the actual code.
> Otherwise, go straight to `/sddw:design_and_taskify <feature-name>` (recommended default).
> 
> *Alternative for design review iteration:* Run `/sddw:design <feature-name>` to establish architecture, then `/sddw:taskify <feature-name>` to generate tasks.
