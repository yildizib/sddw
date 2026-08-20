#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CORE_DIR="$ROOT_DIR/core"

failures=0

fail() {
    echo "FAIL: $1" >&2
    failures=$((failures + 1))
}

if [ ! -f "$CORE_DIR/steps.txt" ]; then
    fail "core/steps.txt is missing"
fi

for forbidden in AskUserQuestion '~/.claude' '.opencode' '/sddw:' '/clear'; do
    if grep -R -F -- "$forbidden" "$CORE_DIR" >/dev/null 2>&1; then
        fail "platform-specific reference found in core: $forbidden"
    fi
done

if grep -R -E 'Claude|OpenCode|Codex' "$CORE_DIR" >/dev/null 2>&1; then
    fail "platform name found in core"
fi

if grep -R -E 'adapters/(claude|opencode)' "$CORE_DIR" >/dev/null 2>&1; then
    fail "core references an adapter"
fi

if grep -R -F 'adapters/opencode' "$ROOT_DIR/adapters/claude" >/dev/null 2>&1; then
    fail "Claude adapter references OpenCode"
fi

if grep -R -F 'adapters/claude' "$ROOT_DIR/adapters/opencode" >/dev/null 2>&1; then
    fail "OpenCode adapter references Claude"
fi

claude_steps=(
    chat code-analysis design design_and_taskify help implement requirements self-improve taskify verify
)
for step in "${claude_steps[@]}"; do
    if [ ! -f "$ROOT_DIR/adapters/claude/commands/$step.md" ]; then
        fail "Claude command is missing: $step"
    fi
done

opencode_steps=(
    chat code-analysis design design-and-taskify help implement requirements self-improve taskify verify
)
for step in "${opencode_steps[@]}"; do
    if [ ! -f "$ROOT_DIR/adapters/opencode/commands/sddw-$step.md" ]; then
        fail "OpenCode command is missing: sddw-$step"
    fi
done

if [ "$failures" -gt 0 ]; then
    echo "$failures boundary validation failure(s)" >&2
    exit 1
fi

echo "Core and adapter boundary validation passed."
