#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
    echo "Missing adapter name." >&2
    exit 2
fi

ADAPTER="$1"
shift

SOURCE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FORCE=false
UNINSTALL=false
CHECK_ONLY=false
MANIFEST_NAME=".sddw-install-manifest"
COMMAND_MARKER="<!-- managed-by: sddw -->"

usage() {
    cat <<EOF
Usage: install.sh [--force] [--uninstall]

Install the $ADAPTER adapter as a user-global snapshot copied from this checkout.

  --force       Replace existing unrecognized sddw runtime or command files.
  --uninstall   Remove the managed user-global adapter snapshot and commands.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --force)
            FORCE=true
            shift
            ;;
        --uninstall)
            UNINSTALL=true
            shift
            ;;
        --check)
            CHECK_ONLY=true
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            usage >&2
            exit 2
            ;;
    esac
done

case "$ADAPTER" in
    claude)
        PLATFORM_NAME="Claude"
        PLATFORM_ROOT="$HOME/.claude"
        COMMANDS_DIR="$PLATFORM_ROOT/commands/sddw"
        COMMAND_SOURCE="$SOURCE_ROOT/adapters/claude/commands"
        ;;
    opencode)
        PLATFORM_NAME="OpenCode"
        PLATFORM_ROOT="$HOME/.config/opencode"
        COMMANDS_DIR="$PLATFORM_ROOT/commands"
        COMMAND_SOURCE="$SOURCE_ROOT/adapters/opencode/commands"
        ;;
    *)
        echo "Unsupported adapter: $ADAPTER" >&2
        exit 2
        ;;
esac

RUNTIME_ROOT="$PLATFORM_ROOT/sddw"
MANIFEST="$RUNTIME_ROOT/$MANIFEST_NAME"

if [ ! -d "$SOURCE_ROOT/core" ] || [ ! -f "$SOURCE_ROOT/adapters/$ADAPTER/bridge.md" ]; then
    echo "The installer must run from a complete sddw checkout." >&2
    exit 1
fi

shopt -s nullglob
SOURCE_COMMANDS=("$COMMAND_SOURCE"/*.md)
if [ "${#SOURCE_COMMANDS[@]}" -eq 0 ]; then
    echo "No $PLATFORM_NAME command wrappers found in $COMMAND_SOURCE" >&2
    exit 1
fi

is_managed_command() {
    local path="$1"
    [ -f "$path" ] || return 1
    grep -q -x -F "$COMMAND_MARKER" "$path"
}

is_safe_command_name() {
    local name="$1"
    case "$name" in
        ""|.|..|*/*|*\\*) return 1 ;;
        *.md) return 0 ;;
        *) return 1 ;;
    esac
}

is_valid_manifest() {
    local format_count=0
    local platform_count=0
    local commit_count=0
    local command_count=0
    local seen_commands=""
    local line
    local name

    [ -f "$MANIFEST" ] || return 1
    while IFS= read -r line || [ -n "$line" ]; do
        case "$line" in
            format=1) format_count=$((format_count + 1)) ;;
            platform="$ADAPTER") platform_count=$((platform_count + 1)) ;;
            source_commit=*)
                [ -n "${line#source_commit=}" ] || return 1
                commit_count=$((commit_count + 1))
                ;;
            command=*)
                name="${line#command=}"
                is_safe_command_name "$name" || return 1
                case "$ADAPTER:$name" in
                    claude:*.md|opencode:sddw-*.md) ;;
                    *) return 1 ;;
                esac
                case "$seen_commands" in
                    *"|$name|"*) return 1 ;;
                esac
                seen_commands="$seen_commands|$name|"
                command_count=$((command_count + 1))
                ;;
            *) return 1 ;;
        esac
    done < "$MANIFEST"

    [ "$format_count" -eq 1 ] &&
        [ "$platform_count" -eq 1 ] &&
        [ "$commit_count" -eq 1 ] &&
        [ "$command_count" -gt 0 ] &&
        [ "$command_count" -le 100 ]
}

RUNTIME_STATE="absent"
if [ -e "$RUNTIME_ROOT" ] || [ -L "$RUNTIME_ROOT" ]; then
    RUNTIME_STATE="unknown"
    if is_valid_manifest &&
        [ -d "$RUNTIME_ROOT/core" ] &&
        [ -f "$RUNTIME_ROOT/adapters/$ADAPTER/adapter.json" ] &&
        [ -f "$RUNTIME_ROOT/adapters/$ADAPTER/bridge.md" ]; then
        RUNTIME_STATE="managed"
    elif [ -L "$RUNTIME_ROOT" ] &&
        [ -f "$RUNTIME_ROOT/core/steps.txt" ] &&
        [ -f "$RUNTIME_ROOT/adapters/$ADAPTER/bridge.md" ]; then
        RUNTIME_STATE="legacy"
    elif [ -d "$RUNTIME_ROOT/.git" ]; then
        origin="$(git -C "$RUNTIME_ROOT" remote get-url origin 2>/dev/null || true)"
        case "$origin" in
            https://github.com/yildizib/sddw.git|git@github.com:yildizib/sddw.git)
                if [ -z "$(git -C "$RUNTIME_ROOT" status --porcelain)" ]; then
                    RUNTIME_STATE="legacy"
                else
                    echo "Existing legacy sddw checkout has uncommitted changes: $RUNTIME_ROOT" >&2
                fi
                ;;
        esac
    fi
fi

command_names=()
for source in "${SOURCE_COMMANDS[@]}"; do
    command_names+=("$(basename "$source")")
done

if [ "$RUNTIME_STATE" = "unknown" ] && [ "$FORCE" = false ]; then
    echo "Refusing to replace unrecognized runtime: $RUNTIME_ROOT" >&2
    echo "Re-run with --force only if this path may be replaced." >&2
    exit 1
fi

for name in "${command_names[@]}"; do
    destination="$COMMANDS_DIR/$name"
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        if ! is_managed_command "$destination" && [ "$FORCE" = false ]; then
            echo "Refusing to replace unrecognized command: $destination" >&2
            echo "Re-run with --force only if this file may be replaced." >&2
            exit 1
        fi
    fi
done

if [ "$CHECK_ONLY" = true ]; then
    echo "$PLATFORM_NAME adapter preflight passed."
    exit 0
fi

if [ "$UNINSTALL" = true ]; then
    mkdir -p "$PLATFORM_ROOT"
    UNINSTALL_STAGING="$(mktemp -d "$PLATFORM_ROOT/.sddw-uninstall.XXXXXX")"
    UNINSTALL_COMMAND_BACKUP="$UNINSTALL_STAGING/commands"
    UNINSTALL_RUNTIME_BACKUP="$UNINSTALL_STAGING/runtime"
    UNINSTALL_COMMITTED=false

    # shellcheck disable=SC2317,SC2329  # Invoked indirectly by the EXIT trap.
    cleanup_uninstall() {
        if [ "$UNINSTALL_COMMITTED" = false ]; then
            mkdir -p "$COMMANDS_DIR"
            for name in "${command_names[@]}"; do
                if [ -e "$UNINSTALL_COMMAND_BACKUP/$name" ] || [ -L "$UNINSTALL_COMMAND_BACKUP/$name" ]; then
                    mv "$UNINSTALL_COMMAND_BACKUP/$name" "$COMMANDS_DIR/$name"
                fi
            done
            if [ -e "$UNINSTALL_RUNTIME_BACKUP" ] || [ -L "$UNINSTALL_RUNTIME_BACKUP" ]; then
                mv "$UNINSTALL_RUNTIME_BACKUP" "$RUNTIME_ROOT"
            fi
        fi
        rm -rf "$UNINSTALL_STAGING"
    }
    trap cleanup_uninstall EXIT

    mkdir -p "$UNINSTALL_COMMAND_BACKUP"
    for name in "${command_names[@]}"; do
        destination="$COMMANDS_DIR/$name"
        if [ -e "$destination" ] || [ -L "$destination" ]; then
            mv "$destination" "$UNINSTALL_COMMAND_BACKUP/$name"
        fi
    done

    if [ -e "$RUNTIME_ROOT" ] || [ -L "$RUNTIME_ROOT" ]; then
        mv "$RUNTIME_ROOT" "$UNINSTALL_RUNTIME_BACKUP"
    fi

    UNINSTALL_COMMITTED=true
    rm -rf "$UNINSTALL_STAGING" || true
    trap - EXIT
    echo "$PLATFORM_NAME adapter uninstalled."
    exit 0
fi

mkdir -p "$PLATFORM_ROOT"
STAGING_ROOT="$(mktemp -d "$PLATFORM_ROOT/.sddw-install.XXXXXX")"
BACKUP_CONTAINER="$(mktemp -d "$PLATFORM_ROOT/.sddw-backup.XXXXXX")"
BACKUP_ROOT="$BACKUP_CONTAINER/runtime"
COMMAND_BACKUP="$STAGING_ROOT/command-backup"
MANIFEST_BACKUP="$STAGING_ROOT/manifest-backup"
TRANSACTION_COMMITTED=false
NEW_RUNTIME_INSTALLED=false
MANIFEST_UPDATE_PENDING=false

cleanup() {
    if [ "$TRANSACTION_COMMITTED" = false ]; then
        if [ "$MANIFEST_UPDATE_PENDING" = true ] && [ -f "$MANIFEST_BACKUP" ]; then
            mv "$MANIFEST_BACKUP" "$MANIFEST"
        fi
        for name in "${command_names[@]}"; do
            destination="$COMMANDS_DIR/$name"
            if [ -e "$COMMAND_BACKUP/$name" ] || [ -L "$COMMAND_BACKUP/$name" ]; then
                rm -f "$destination"
                mkdir -p "$COMMANDS_DIR"
                mv "$COMMAND_BACKUP/$name" "$destination"
            elif [[ "${changed_command_lookup:-}" == *"|$name|"* ]]; then
                rm -f "$destination"
            fi
        done

        if [ "$NEW_RUNTIME_INSTALLED" = true ]; then
            rm -rf "$RUNTIME_ROOT"
        fi
        if [ -e "$BACKUP_ROOT" ] || [ -L "$BACKUP_ROOT" ]; then
            mv "$BACKUP_ROOT" "$RUNTIME_ROOT"
        fi
    fi

    rm -rf "$STAGING_ROOT"
    rm -rf "$BACKUP_CONTAINER"
}
trap cleanup EXIT

STAGED_RUNTIME="$STAGING_ROOT/runtime"
STAGED_COMMANDS="$STAGING_ROOT/commands"
mkdir -p "$STAGED_RUNTIME/adapters/$ADAPTER" "$STAGED_COMMANDS"
cp -R "$SOURCE_ROOT/core" "$STAGED_RUNTIME/core"
cp "$SOURCE_ROOT/adapters/$ADAPTER/adapter.json" "$STAGED_RUNTIME/adapters/$ADAPTER/adapter.json"
cp "$SOURCE_ROOT/adapters/$ADAPTER/bridge.md" "$STAGED_RUNTIME/adapters/$ADAPTER/bridge.md"

for source in "${SOURCE_COMMANDS[@]}"; do
    cp "$source" "$STAGED_COMMANDS/$(basename "$source")"
done

SOURCE_COMMIT="$(git -C "$SOURCE_ROOT" rev-parse HEAD 2>/dev/null || true)"
{
    echo "format=1"
    echo "platform=$ADAPTER"
    echo "source_commit=${SOURCE_COMMIT:-unknown}"
    for source in "${SOURCE_COMMANDS[@]}"; do
        echo "command=$(basename "$source")"
    done
} > "$STAGED_RUNTIME/$MANIFEST_NAME"

PAYLOAD_CHANGED=true
if [ "$RUNTIME_STATE" = "managed" ] &&
    diff -qr "$RUNTIME_ROOT/core" "$STAGED_RUNTIME/core" >/dev/null &&
    cmp -s "$RUNTIME_ROOT/adapters/$ADAPTER/adapter.json" "$STAGED_RUNTIME/adapters/$ADAPTER/adapter.json" &&
    cmp -s "$RUNTIME_ROOT/adapters/$ADAPTER/bridge.md" "$STAGED_RUNTIME/adapters/$ADAPTER/bridge.md"; then
    PAYLOAD_CHANGED=false
    cp "$MANIFEST" "$MANIFEST_BACKUP"
fi

changed_commands=("")
changed_command_lookup=""
for source in "${SOURCE_COMMANDS[@]}"; do
    name="$(basename "$source")"
    destination="$COMMANDS_DIR/$name"
    if [ ! -f "$destination" ] || ! cmp -s "$STAGED_COMMANDS/$name" "$destination"; then
        changed_commands+=("$name")
        changed_command_lookup="$changed_command_lookup|$name|"
    fi
done

mkdir -p "$COMMANDS_DIR" "$COMMAND_BACKUP"
for name in "${changed_commands[@]}"; do
    [ -n "$name" ] || continue
    destination="$COMMANDS_DIR/$name"
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        mv "$destination" "$COMMAND_BACKUP/$name"
    fi
done

if [ "$PAYLOAD_CHANGED" = true ] && { [ -e "$RUNTIME_ROOT" ] || [ -L "$RUNTIME_ROOT" ]; }; then
    mv "$RUNTIME_ROOT" "$BACKUP_ROOT"
fi

if [ "$PAYLOAD_CHANGED" = true ]; then
    NEW_RUNTIME_INSTALLED=true
    mv "$STAGED_RUNTIME" "$RUNTIME_ROOT"
fi

for name in "${changed_commands[@]}"; do
    [ -n "$name" ] || continue
    destination="$COMMANDS_DIR/$name"
    mv "$STAGED_COMMANDS/$name" "$destination"
    echo "Installed managed command: $destination"
done

if [ "$PAYLOAD_CHANGED" = false ]; then
    if ! cmp -s "$STAGED_RUNTIME/$MANIFEST_NAME" "$MANIFEST"; then
        MANIFEST_UPDATE_PENDING=true
        mv "$STAGED_RUNTIME/$MANIFEST_NAME" "$MANIFEST"
    fi
fi

TRANSACTION_COMMITTED=true
rm -rf "$BACKUP_CONTAINER" "$COMMAND_BACKUP"

echo "Installed ${#SOURCE_COMMANDS[@]} $PLATFORM_NAME commands to $COMMANDS_DIR"
echo "$PLATFORM_NAME runtime snapshot: $RUNTIME_ROOT"
