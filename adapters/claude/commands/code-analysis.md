---
name: sddw:code-analysis
description: Analyse existing codebase to extract patterns, interfaces, flows, and conventions
argument-hint: "<feature-name> [--auto]"
---

<feature_name> #$ARGUMENTS </feature_name>

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/code-analysis.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/code-analysis.md

# SPECS
@~/.claude/sddw/core/specs/code-analysis.md

# NEXT STEP
After the user approves the code analysis, suggest:
> Run `/clear` to free up context, then `/sddw:design <feature-name>`
