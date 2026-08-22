---
name: sddw:review
description: Independently review a verified feature and its evidence before release
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
@~/.claude/sddw/core/instructions/review.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/review.md

# SPECS
@~/.claude/sddw/core/specs/requirements.md
@~/.claude/sddw/core/specs/design.md
@~/.claude/sddw/core/specs/design-task.md
@~/.claude/sddw/core/specs/task-completion.md
@~/.claude/sddw/core/specs/verification-report.md
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/quality-plan.md
@~/.claude/sddw/core/specs/run-manifest.md
@~/.claude/sddw/core/specs/review-report.md
@~/.claude/sddw/core/specs/release-plan.md

# NEXT STEP
After a PASS, suggest:
> Run `/clear` to establish a fresh context, then `/sddw:release <feature-name>` to prepare the release readiness plan.

After a FAIL, list blocking findings and require remediation, refreshed evidence, and a new independent review.
