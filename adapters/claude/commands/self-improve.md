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

# TRUST MODEL
@~/.claude/sddw/core/security/trust-model.md

# INSTRUCTIONS
@~/.claude/sddw/core/instructions/self-improve.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/self-improve.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/decision-record.md
@~/.claude/sddw/core/specs/improvement-report.md
@~/.claude/sddw/core/specs/metrics.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/run-manifest.md
@~/.claude/sddw/core/specs/verification-report.md
@~/.claude/sddw/core/specs/task-completion.md
@~/.claude/sddw/core/specs/review-report.md
@~/.claude/sddw/core/specs/release-plan.md
@~/.claude/sddw/core/specs/release-report.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/quality-plan.md

# NEXT STEP
After the improvement report is generated:
- If improvements were proposed: summarise the report and its diff previews without modifying workflow files.
- Suggest that maintainers review and apply accepted proposals separately.
- If no improvements identified: congratulate and summarise the feature's clean execution.
