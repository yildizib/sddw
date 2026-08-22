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

if ! command -v python3 >/dev/null 2>&1; then
    fail "python3 is required to validate adapter manifests"
elif ! python3 - "$ROOT_DIR/adapters/claude/adapter.json" "$ROOT_DIR/adapters/opencode/adapter.json" <<'PY'
import json
import sys


def shape(value):
    if isinstance(value, dict):
        return {key: shape(child) for key, child in value.items()}
    return type(value).__name__


manifests = []
for path in sys.argv[1:]:
    try:
        with open(path, encoding="utf-8") as manifest_file:
            manifest = json.load(manifest_file)
    except (OSError, json.JSONDecodeError) as error:
        print(f"FAIL: invalid adapter manifest {path}: {error}", file=sys.stderr)
        sys.exit(1)
    if not isinstance(manifest, dict):
        print(f"FAIL: adapter manifest must contain a JSON object: {path}", file=sys.stderr)
        sys.exit(1)
    manifests.append(manifest)

if shape(manifests[0]) != shape(manifests[1]):
    print("FAIL: Claude and OpenCode adapter manifest keys or value types differ", file=sys.stderr)
    sys.exit(1)

for path, expected_id, manifest in zip(sys.argv[1:], ("claude", "opencode"), manifests):
    if manifest.get("id") != expected_id:
        print(f"FAIL: adapter manifest id does not match its directory: {path}", file=sys.stderr)
        sys.exit(1)
PY
then
    fail "adapter manifest validation failed"
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

steps=()
if [ -f "$CORE_DIR/steps.txt" ]; then
    while IFS= read -r step || [ -n "$step" ]; do
        step="${step%$'\r'}"
        [ -n "$step" ] || continue
        if [[ ! "$step" =~ ^[a-z0-9][a-z0-9_-]*$ ]]; then
            fail "invalid step name in core/steps.txt: $step"
            continue
        fi
        if [ "${#steps[@]}" -gt 0 ]; then
            for existing_step in "${steps[@]}"; do
                if [ "$existing_step" = "$step" ]; then
                    fail "duplicate step in core/steps.txt: $step"
                fi
            done
        fi
        steps+=("$step")
    done < "$CORE_DIR/steps.txt"
fi

step_count=${#steps[@]}
if [ "$step_count" -eq 0 ]; then
    fail "core/steps.txt must list at least one supported command"
fi

if [ "$step_count" -gt 0 ]; then
    for required_step in review release; do
        found=false
        for step in "${steps[@]}"; do
            if [ "$step" = "$required_step" ]; then
                found=true
                break
            fi
        done
        if [ "$found" = false ]; then
            fail "core/steps.txt must include the $required_step step"
        fi
    done
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

required_specs_for_step() {
    case "$1" in
        requirements) echo "requirements feature-manifest traceability-matrix risk-register quality-plan run-manifest" ;;
        code-analysis) echo "code-analysis feature-manifest run-manifest" ;;
        design) echo "requirements design decision-record risk-register feature-manifest traceability-matrix run-manifest" ;;
        taskify) echo "requirements design design-task change-request risk-register quality-plan feature-manifest traceability-matrix run-manifest" ;;
        design_and_taskify) echo "requirements design design-task risk-register quality-plan feature-manifest traceability-matrix run-manifest" ;;
        implement) echo "requirements design design-task task-completion change-request quality-plan feature-manifest traceability-matrix run-manifest" ;;
        verify) echo "requirements design design-task task-completion verification-report change-request risk-register quality-plan feature-manifest traceability-matrix run-manifest" ;;
        review) echo "requirements design design-task task-completion verification-report review-report risk-register release-plan quality-plan feature-manifest traceability-matrix run-manifest" ;;
        release) echo "verification-report review-report release-plan release-report risk-register metrics quality-plan feature-manifest traceability-matrix run-manifest" ;;
        self-improve) echo "requirements design design-task decision-record task-completion verification-report review-report release-plan release-report improvement-report risk-register metrics quality-plan feature-manifest traceability-matrix run-manifest" ;;
        chat) echo "requirements change-request feature-manifest" ;;
        help) echo "feature-manifest" ;;
    esac
}

validate_command() {
    local adapter=$1
    local command=$2
    local step=$3
    local install_prefix
    local bridge_reference
    local reference
    local relative_path
    local spec
    local required_specs=()

    if [ ! -f "$command" ]; then
        fail "$adapter command is missing for step: $step"
        return
    fi

    if ! grep -q -F '<!-- managed-by: sddw -->' "$command"; then
        fail "$adapter command has no managed marker: $(basename "$command")"
    fi
    if [ "$adapter" = Claude ]; then
        install_prefix='@~/.claude/sddw/'
        bridge_reference='@~/.claude/sddw/adapters/claude/bridge.md'
    else
        install_prefix='@~/.config/opencode/sddw/'
        bridge_reference='@~/.config/opencode/sddw/adapters/opencode/bridge.md'
    fi

    for reference in \
        "$bridge_reference" \
        "${install_prefix}core/interaction.md" \
        "${install_prefix}core/instructions/common.md" \
        "${install_prefix}core/security/trust-model.md" \
        "${install_prefix}core/instructions/$step.md"; do
        if ! grep -q -F "$reference" "$command"; then
            fail "$adapter command is missing required reference $reference: $(basename "$command")"
        fi
    done

    if [ -f "$CORE_DIR/questionnaires/$step.md" ] && \
        ! grep -q -F "${install_prefix}core/questionnaires/$step.md" "$command"; then
        fail "$adapter command does not load its questionnaire: $(basename "$command")"
    fi

    read -r -a required_specs <<< "$(required_specs_for_step "$step")"
    for spec in "${required_specs[@]}"; do
        if ! grep -q -F "${install_prefix}core/specs/$spec.md" "$command"; then
            fail "$adapter command does not load required spec $spec.md: $(basename "$command")"
        fi
    done

    while IFS= read -r reference; do
        relative_path="${reference#"$install_prefix"}"
        if [ ! -f "$ROOT_DIR/$relative_path" ]; then
            fail "$adapter command reference is missing: $reference"
        fi
    done < <(grep -o -E "${install_prefix//./\\.}[^[:space:]]+" "$command" || true)
}

if [ "$step_count" -gt 0 ]; then
    for step in "${steps[@]}"; do
        validate_command Claude "$ROOT_DIR/adapters/claude/commands/$step.md" "$step"
        opencode_step="${step//_/-}"
        validate_command OpenCode "$ROOT_DIR/adapters/opencode/commands/sddw-$opencode_step.md" "$step"
        if ! grep -q -F "/sddw:$step" "$ROOT_DIR/adapters/claude/bridge.md"; then
            fail "Claude bridge command map is missing step: $step"
        fi
        if ! grep -q -F "/sddw-$opencode_step" "$ROOT_DIR/adapters/opencode/bridge.md"; then
            fail "OpenCode bridge command map is missing step: $step"
        fi
    done
fi

if ! grep -q -F 'agent: build' "$ROOT_DIR/adapters/opencode/commands/sddw-code-analysis.md"; then
    fail "OpenCode Code Analysis must use the build agent"
fi

if [ "$failures" -gt 0 ]; then
    echo "$failures boundary validation failure(s)" >&2
    exit 1
fi

echo "Core and adapter boundary validation passed."
