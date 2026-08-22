---
name: sddw:verify
description: Verify implementation against requirements, run tests, and create remediation tasks if needed
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
@~/.claude/sddw/core/instructions/verify.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/verify.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/task-completion.md
@~/.claude/sddw/core/specs/verification-report.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/change-request.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/quality-plan.md
@~/.claude/sddw/core/specs/run-manifest.md

# NEXT STEP
After verification:
- If all checks pass, suggest:
  > Feature verified. Run `/clear` to establish a fresh context, then `/sddw:review <feature-name>` for an independent review before release.
- If remediation proposals were drafted, require human approval of the change request, then suggest:
  > Run `/clear`, then `/sddw:taskify <feature-name>` to publish an approved task-set revision. Only then run `/sddw:implement <feature-name> --task <N>` and re-run verification.
