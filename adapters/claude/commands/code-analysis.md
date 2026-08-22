---
name: sddw:code-analysis
description: Analyse existing codebase to extract patterns, interfaces, flows, and conventions
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
@~/.claude/sddw/core/instructions/code-analysis.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/code-analysis.md

# SPECS
@~/.claude/sddw/core/specs/code-analysis.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/run-manifest.md

# NEXT STEP
After the user approves the code analysis, suggest:
> Run `/clear` to free up context, then `/sddw:design <feature-name>`
