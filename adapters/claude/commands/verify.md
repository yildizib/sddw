---
name: sddw:verify
description: Verify implementation against requirements, run tests, and create remediation tasks if needed
argument-hint: "<feature-name> [--auto]"
---

<feature_name> #$ARGUMENTS </feature_name>

# ADAPTER BRIDGE
@~/.claude/sddw/adapters/claude/bridge.md

# COMMON RULES
@~/.claude/sddw/core/instructions/common.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/verify.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/verify.md

# SPECS
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/verification-report.md

# NEXT STEP
After verification:
- If all checks pass, suggest:
  > Feature verified. Run `/clear` to free up context, then `/sddw:self-improve <feature-name>` to analyse the execution and improve the workflow.
- If remediation tasks were created, suggest:
  > Run `/clear` to free up context, then `/sddw:implement <feature-name> --task <N>` for each remediation task. After remediation, re-run `/sddw:verify <feature-name>`.
