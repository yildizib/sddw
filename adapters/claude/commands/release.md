---
name: sddw:release
description: Prepare release readiness or record actual post-release evidence
argument-hint: "<feature-name> [--post-release] [--auto]"
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
@~/.claude/sddw/core/instructions/release.md

# QUESTIONNAIRE
@~/.claude/sddw/core/questionnaires/release.md

# SPECS
@~/.claude/sddw/core/specs/feature-manifest.md
@~/.claude/sddw/core/specs/verification-report.md
@~/.claude/sddw/core/specs/traceability-matrix.md
@~/.claude/sddw/core/specs/risk-register.md
@~/.claude/sddw/core/specs/quality-plan.md
@~/.claude/sddw/core/specs/metrics.md
@~/.claude/sddw/core/specs/run-manifest.md
@~/.claude/sddw/core/specs/review-report.md
@~/.claude/sddw/core/specs/release-plan.md
@~/.claude/sddw/core/specs/release-report.md

# NEXT STEP
After readiness planning, state that human-gated release actions must occur before running:
> `/sddw:release <feature-name> --post-release`

Only after the post-release lifecycle status is `closed` may the feature lifecycle be described as complete. Then suggest `/sddw:self-improve <feature-name>`.
