---
name: sddw:self-improve
description: Analyse feature execution to identify workflow gaps and propose improvements to sddw steps and components
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

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/self-improve.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/self-improve.md

# SPECS
@~/.claude/sddw/core/specs/improvement-report.md
@~/.claude/sddw/core/specs/verification-report.md
@~/.claude/sddw/core/specs/task-completion.md

# NEXT STEP
After the improvement report is generated:
- If improvements were proposed: summarise the report and its diff previews without modifying workflow files.
- Suggest that maintainers review and apply accepted proposals separately.
- If no improvements identified: congratulate and summarise the feature's clean execution.
