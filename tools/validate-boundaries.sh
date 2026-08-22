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

if grep -R -F '@~/.config/opencode/sddw/bridge.md' "$ROOT_DIR/adapters/opencode" >/dev/null 2>&1; then
    fail "OpenCode adapter references the stale bridge path"
fi

step_count=0
while IFS= read -r step; do
    [ -n "$step" ] || continue
    step_count=$((step_count + 1))

    if [ ! -f "$ROOT_DIR/adapters/claude/commands/$step.md" ]; then
        fail "Claude command is missing: $step"
    fi

    opencode_step="${step//_/-}"
    if [ ! -f "$ROOT_DIR/adapters/opencode/commands/sddw-$opencode_step.md" ]; then
        fail "OpenCode command is missing: sddw-$opencode_step"
    fi
done < "$CORE_DIR/steps.txt"

if [ "$step_count" -ne 10 ]; then
    fail "core/steps.txt must list exactly 10 supported commands"
fi

shopt -s nullglob
claude_command_files=("$ROOT_DIR"/adapters/claude/commands/*.md)
opencode_command_files=("$ROOT_DIR"/adapters/opencode/commands/*.md)
if [ "${#claude_command_files[@]}" -ne "$step_count" ]; then
    fail "Claude command count does not match core/steps.txt"
fi
if [ "${#opencode_command_files[@]}" -ne "$step_count" ]; then
    fail "OpenCode command count does not match core/steps.txt"
fi

for command in "$ROOT_DIR"/adapters/claude/commands/*.md; do
    if ! grep -q -F '<!-- managed-by: sddw -->' "$command"; then
        fail "Claude command has no managed marker: $(basename "$command")"
    fi
    if ! grep -q -F '@~/.claude/sddw/adapters/claude/bridge.md' "$command"; then
        fail "Claude command does not load its bridge: $(basename "$command")"
    fi
    if ! grep -q -F '@~/.claude/sddw/core/interaction.md' "$command"; then
        fail "Claude command does not load the interaction contract: $(basename "$command")"
    fi

    while IFS= read -r reference; do
        relative_path="${reference#@~/.claude/sddw/}"
        if [ ! -f "$ROOT_DIR/$relative_path" ]; then
            fail "Claude command reference is missing: $reference"
        fi
    done < <(grep -o -E '@~/.claude/sddw/[^[:space:]]+' "$command")
done

for command in "$ROOT_DIR"/adapters/opencode/commands/*.md; do
    if ! grep -q -F '<!-- managed-by: sddw -->' "$command"; then
        fail "OpenCode command has no managed marker: $(basename "$command")"
    fi
    if ! grep -q -F '@~/.config/opencode/sddw/adapters/opencode/bridge.md' "$command"; then
        fail "OpenCode command does not load its bridge: $(basename "$command")"
    fi
    if ! grep -q -F '@~/.config/opencode/sddw/core/interaction.md' "$command"; then
        fail "OpenCode command does not load the interaction contract: $(basename "$command")"
    fi

    while IFS= read -r reference; do
        relative_path="${reference#@~/.config/opencode/sddw/}"
        if [ ! -f "$ROOT_DIR/$relative_path" ]; then
            fail "OpenCode command reference is missing: $reference"
        fi
    done < <(grep -o -E '@~/.config/opencode/sddw/[^[:space:]]+' "$command")
done

if ! grep -q -F 'agent: build' "$ROOT_DIR/adapters/opencode/commands/sddw-code-analysis.md"; then
    fail "OpenCode Code Analysis must use the build agent"
fi

if [ "$failures" -gt 0 ]; then
    echo "$failures boundary validation failure(s)" >&2
    exit 1
fi

echo "Core and adapter boundary validation passed."
