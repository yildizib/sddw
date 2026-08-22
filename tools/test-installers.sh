#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
trap 'rm -rf "$TEST_ROOT"' EXIT

fail() {
    echo "FAIL: $1" >&2
    exit 1
}

mtime() {
    if stat -c %Y "$1" >/dev/null 2>&1; then
        stat -c %Y "$1"
    else
        stat -f %m "$1"
    fi
}

SOURCE_ROOT="$TEST_ROOT/source"
HOME_ROOT="$TEST_ROOT/home"
mkdir -p "$SOURCE_ROOT" "$HOME_ROOT/.claude/commands" "$HOME_ROOT/.config/opencode/commands"
cp -R "$ROOT_DIR/core" "$ROOT_DIR/adapters" "$ROOT_DIR/bin" "$ROOT_DIR/tools" "$SOURCE_ROOT/"

echo "unrelated" > "$HOME_ROOT/.claude/commands/unrelated.md"
echo "unrelated" > "$HOME_ROOT/.config/opencode/commands/unrelated.md"

HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/claude/install.sh"
HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/opencode/install.sh"

test -d "$HOME_ROOT/.claude/sddw/core" || fail "Claude core snapshot is missing"
test -d "$HOME_ROOT/.config/opencode/sddw/core" || fail "OpenCode core snapshot is missing"
test ! -L "$HOME_ROOT/.claude/sddw" || fail "Claude runtime must not be a symlink"
test ! -L "$HOME_ROOT/.config/opencode/sddw" || fail "OpenCode runtime must not be a symlink"
test ! -e "$HOME_ROOT/.claude/sddw/.git" || fail "Claude runtime must not contain Git metadata"
test ! -e "$HOME_ROOT/.config/opencode/sddw/.git" || fail "OpenCode runtime must not contain Git metadata"
test -f "$HOME_ROOT/.claude/sddw/.sddw-install-manifest" || fail "Claude manifest is missing"
test -f "$HOME_ROOT/.config/opencode/sddw/.sddw-install-manifest" || fail "OpenCode manifest is missing"
test -f "$HOME_ROOT/.claude/sddw/adapters/claude/bridge.md" || fail "Claude bridge is missing"
test -f "$HOME_ROOT/.config/opencode/sddw/adapters/opencode/bridge.md" || fail "OpenCode bridge is missing"
test ! -e "$HOME_ROOT/.claude/sddw/adapters/opencode" || fail "Claude snapshot contains the OpenCode adapter"
test ! -e "$HOME_ROOT/.config/opencode/sddw/adapters/claude" || fail "OpenCode snapshot contains the Claude adapter"
diff -qr "$SOURCE_ROOT/core" "$HOME_ROOT/.claude/sddw/core" >/dev/null || fail "Claude core snapshot is incomplete"
diff -qr "$SOURCE_ROOT/core" "$HOME_ROOT/.config/opencode/sddw/core" >/dev/null || fail "OpenCode core snapshot is incomplete"
cmp "$SOURCE_ROOT/adapters/claude/adapter.json" "$HOME_ROOT/.claude/sddw/adapters/claude/adapter.json" >/dev/null || fail "Claude adapter metadata is incorrect"
cmp "$SOURCE_ROOT/adapters/opencode/adapter.json" "$HOME_ROOT/.config/opencode/sddw/adapters/opencode/adapter.json" >/dev/null || fail "OpenCode adapter metadata is incorrect"
test -f "$HOME_ROOT/.claude/commands/unrelated.md" || fail "Claude install removed an unrelated command"
test -f "$HOME_ROOT/.config/opencode/commands/unrelated.md" || fail "OpenCode install removed an unrelated command"

shopt -s nullglob
claude_commands=("$HOME_ROOT/.claude/commands/sddw"/*.md)
opencode_commands=("$HOME_ROOT/.config/opencode/commands"/sddw-*.md)
test "${#claude_commands[@]}" -eq 10 || fail "Claude command count is not 10"
test "${#opencode_commands[@]}" -eq 10 || fail "OpenCode command count is not 10"

for command in "${claude_commands[@]}"; do
    while IFS= read -r reference; do
        relative_path="${reference#@~/}"
        test -f "$HOME_ROOT/$relative_path" || fail "Claude reference does not resolve: $reference"
    done < <(grep -o -E '@~/[^[:space:]]+' "$command")
done

for command in "${opencode_commands[@]}"; do
    while IFS= read -r reference; do
        relative_path="${reference#@~/}"
        test -f "$HOME_ROOT/$relative_path" || fail "OpenCode reference does not resolve: $reference"
    done < <(grep -o -E '@~/[^[:space:]]+' "$command")
done

# An identical reinstall leaves the runtime, commands, and manifest untouched.
touch -t 200001010000 "$HOME_ROOT/.claude/sddw/core/interaction.md"
touch -t 200001010000 "$HOME_ROOT/.claude/commands/sddw/requirements.md"
touch -t 200001010000 "$HOME_ROOT/.claude/sddw/.sddw-install-manifest"
idempotent_core_mtime="$(mtime "$HOME_ROOT/.claude/sddw/core/interaction.md")"
idempotent_command_mtime="$(mtime "$HOME_ROOT/.claude/commands/sddw/requirements.md")"
idempotent_manifest_mtime="$(mtime "$HOME_ROOT/.claude/sddw/.sddw-install-manifest")"
HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/claude/install.sh"
test "$(mtime "$HOME_ROOT/.claude/sddw/core/interaction.md")" = "$idempotent_core_mtime" || fail "Idempotent install rewrote the Claude core"
test "$(mtime "$HOME_ROOT/.claude/commands/sddw/requirements.md")" = "$idempotent_command_mtime" || fail "Idempotent install rewrote a Claude command"
test "$(mtime "$HOME_ROOT/.claude/sddw/.sddw-install-manifest")" = "$idempotent_manifest_mtime" || fail "Idempotent install rewrote the Claude manifest"

# Reinstalling one component updates only that component's snapshot.
cp "$HOME_ROOT/.claude/commands/sddw/requirements.md" "$TEST_ROOT/claude-command.before"
cp "$HOME_ROOT/.config/opencode/sddw/core/interaction.md" "$TEST_ROOT/opencode-core.before"
touch -t 200001010000 "$HOME_ROOT/.claude/commands/sddw/requirements.md"
command_mtime_before="$(mtime "$HOME_ROOT/.claude/commands/sddw/requirements.md")"
printf '\nSnapshot test change.\n' >> "$SOURCE_ROOT/core/interaction.md"
HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/claude/install.sh"
cmp "$TEST_ROOT/claude-command.before" "$HOME_ROOT/.claude/commands/sddw/requirements.md" >/dev/null || fail "Core update rewrote a Claude command"
test "$(mtime "$HOME_ROOT/.claude/commands/sddw/requirements.md")" = "$command_mtime_before" || fail "Core update physically rewrote a Claude command"
grep -q -F 'Snapshot test change.' "$HOME_ROOT/.claude/sddw/core/interaction.md" || fail "Claude core snapshot did not update"
cmp "$TEST_ROOT/opencode-core.before" "$HOME_ROOT/.config/opencode/sddw/core/interaction.md" >/dev/null || fail "Claude reinstall changed the OpenCode snapshot"

cp "$HOME_ROOT/.claude/sddw/core/interaction.md" "$TEST_ROOT/claude-core.before"
touch -t 200001010000 "$HOME_ROOT/.claude/sddw/core/interaction.md"
core_mtime_before="$(mtime "$HOME_ROOT/.claude/sddw/core/interaction.md")"
printf '\nAdapter command test change.\n' >> "$SOURCE_ROOT/adapters/claude/commands/requirements.md"
HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/claude/install.sh"
cmp "$TEST_ROOT/claude-core.before" "$HOME_ROOT/.claude/sddw/core/interaction.md" >/dev/null || fail "Command update rewrote the Claude core"
test "$(mtime "$HOME_ROOT/.claude/sddw/core/interaction.md")" = "$core_mtime_before" || fail "Command update physically rewrote the Claude core"
grep -q -F 'Adapter command test change.' "$HOME_ROOT/.claude/commands/sddw/requirements.md" || fail "Claude command snapshot did not update"

# Unknown command files are preserved unless replacement is explicit.
COLLISION_HOME="$TEST_ROOT/collision-home"
mkdir -p "$COLLISION_HOME/.config/opencode/commands"
{
    echo "user-owned"
    echo "@~/.config/opencode/sddw/adapters/opencode/bridge.md"
} > "$COLLISION_HOME/.config/opencode/commands/sddw-help.md"
cp "$COLLISION_HOME/.config/opencode/commands/sddw-help.md" "$TEST_ROOT/collision.before"
if HOME="$COLLISION_HOME" bash "$SOURCE_ROOT/adapters/opencode/install.sh"; then
    fail "OpenCode installer accepted an unknown command collision"
fi
cmp "$TEST_ROOT/collision.before" "$COLLISION_HOME/.config/opencode/commands/sddw-help.md" >/dev/null || fail "Rejected collision changed the user command"
test ! -e "$COLLISION_HOME/.config/opencode/sddw" || fail "Rejected collision created a runtime snapshot"
HOME="$COLLISION_HOME" bash "$SOURCE_ROOT/adapters/opencode/install.sh" --force
grep -q -F '<!-- managed-by: sddw -->' "$COLLISION_HOME/.config/opencode/commands/sddw-help.md" || fail "Forced install did not replace the command"

RUNTIME_COLLISION_HOME="$TEST_ROOT/runtime-collision-home"
mkdir -p "$RUNTIME_COLLISION_HOME/.claude/sddw/core" "$RUNTIME_COLLISION_HOME/.claude/sddw/adapters/claude"
echo "user-owned" > "$RUNTIME_COLLISION_HOME/.claude/sddw/unrelated.md"
echo "bridge" > "$RUNTIME_COLLISION_HOME/.claude/sddw/adapters/claude/bridge.md"
{
    echo "format=1"
    echo "not-platform=claude"
} > "$RUNTIME_COLLISION_HOME/.claude/sddw/.sddw-install-manifest"
if HOME="$RUNTIME_COLLISION_HOME" bash "$SOURCE_ROOT/adapters/claude/install.sh"; then
    fail "Claude installer accepted an unknown runtime collision"
fi
test -f "$RUNTIME_COLLISION_HOME/.claude/sddw/unrelated.md" || fail "Rejected runtime collision changed user files"
HOME="$RUNTIME_COLLISION_HOME" bash "$SOURCE_ROOT/adapters/claude/install.sh" --force
test -f "$RUNTIME_COLLISION_HOME/.claude/sddw/.sddw-install-manifest" || fail "Forced runtime replacement did not install a snapshot"

LEGACY_HOME="$TEST_ROOT/legacy-home"
mkdir -p "$LEGACY_HOME/.claude"
ln -s "$SOURCE_ROOT" "$LEGACY_HOME/.claude/sddw"
HOME="$LEGACY_HOME" bash "$SOURCE_ROOT/adapters/claude/install.sh"
test ! -L "$LEGACY_HOME/.claude/sddw" || fail "Legacy source symlink was not migrated"
test -f "$LEGACY_HOME/.claude/sddw/.sddw-install-manifest" || fail "Legacy migration did not install a snapshot"

if HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/opencode/install.sh" --project "$TEST_ROOT"; then
    fail "Removed project-local option was accepted"
fi

cp "$HOME_ROOT/.config/opencode/sddw/.sddw-install-manifest" "$TEST_ROOT/opencode-manifest.before"
echo "command=../unrelated.md" >> "$HOME_ROOT/.config/opencode/sddw/.sddw-install-manifest"
if HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/opencode/install.sh"; then
    fail "Installer accepted an unsafe manifest command"
fi
test -f "$HOME_ROOT/.config/opencode/commands/unrelated.md" || fail "Unsafe manifest command escaped the command directory"
cp "$TEST_ROOT/opencode-manifest.before" "$HOME_ROOT/.config/opencode/sddw/.sddw-install-manifest"

HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/claude/install.sh" --uninstall
HOME="$HOME_ROOT" bash "$SOURCE_ROOT/adapters/opencode/install.sh" --uninstall
test ! -e "$HOME_ROOT/.claude/sddw" || fail "Claude runtime was not uninstalled"
test ! -e "$HOME_ROOT/.config/opencode/sddw" || fail "OpenCode runtime was not uninstalled"
test -f "$HOME_ROOT/.claude/commands/unrelated.md" || fail "Claude uninstall removed an unrelated command"
test -f "$HOME_ROOT/.config/opencode/commands/unrelated.md" || fail "OpenCode uninstall removed an unrelated command"

INTERACTIVE_HOME="$TEST_ROOT/interactive-home"
mkdir -p "$INTERACTIVE_HOME"
printf '1\n3\n' | HOME="$INTERACTIVE_HOME" bash "$SOURCE_ROOT/bin/install.sh"
test -f "$INTERACTIVE_HOME/.claude/sddw/.sddw-install-manifest" || fail "Interactive launcher did not install Claude"
test -f "$INTERACTIVE_HOME/.config/opencode/sddw/.sddw-install-manifest" || fail "Interactive launcher did not install OpenCode"
printf '2\n3\n' | HOME="$INTERACTIVE_HOME" bash "$SOURCE_ROOT/bin/install.sh"
test ! -e "$INTERACTIVE_HOME/.claude/sddw" || fail "Interactive launcher did not uninstall Claude"
test ! -e "$INTERACTIVE_HOME/.config/opencode/sddw" || fail "Interactive launcher did not uninstall OpenCode"

NONINTERACTIVE_HOME="$TEST_ROOT/noninteractive-home"
mkdir -p "$NONINTERACTIVE_HOME"
HOME="$NONINTERACTIVE_HOME" bash "$SOURCE_ROOT/bin/install.sh" install claude
test -f "$NONINTERACTIVE_HOME/.claude/sddw/.sddw-install-manifest" || fail "Non-interactive launcher did not install Claude"
test ! -e "$NONINTERACTIVE_HOME/.config/opencode/sddw" || fail "Claude launcher target installed OpenCode"
HOME="$NONINTERACTIVE_HOME" bash "$SOURCE_ROOT/bin/install.sh" uninstall claude
test ! -e "$NONINTERACTIVE_HOME/.claude/sddw" || fail "Non-interactive launcher did not uninstall Claude"

FORWARD_HOME="$TEST_ROOT/forward-home"
mkdir -p "$FORWARD_HOME/.config/opencode/commands"
echo "user-owned" > "$FORWARD_HOME/.config/opencode/commands/sddw-help.md"
if HOME="$FORWARD_HOME" bash "$SOURCE_ROOT/bin/install.sh" install opencode; then
    fail "Launcher install ignored an OpenCode collision"
fi
HOME="$FORWARD_HOME" bash "$SOURCE_ROOT/bin/install.sh" install opencode --force
grep -q -x -F '<!-- managed-by: sddw -->' "$FORWARD_HOME/.config/opencode/commands/sddw-help.md" || fail "Launcher did not forward --force"

ALL_PREFLIGHT_HOME="$TEST_ROOT/all-preflight-home"
mkdir -p "$ALL_PREFLIGHT_HOME/.config/opencode/commands"
echo "user-owned" > "$ALL_PREFLIGHT_HOME/.config/opencode/commands/sddw-help.md"
if HOME="$ALL_PREFLIGHT_HOME" bash "$SOURCE_ROOT/bin/install.sh" install all; then
    fail "All-adapter launcher ignored an OpenCode collision"
fi
test ! -e "$ALL_PREFLIGHT_HOME/.claude/sddw" || fail "All-adapter preflight left Claude partially installed"

echo "Installer smoke tests passed."
