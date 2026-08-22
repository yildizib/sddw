#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ACTION=""
TARGET=""
FORCE=false

usage() {
    cat <<'EOF'
Usage: install.sh [install|uninstall] [claude|opencode|all] [--force]

Run without an action or adapter to choose interactively.

  install      Install selected user-global adapter snapshots.
  uninstall    Uninstall selected managed adapter snapshots.
  claude       Target Claude Code.
  opencode     Target OpenCode.
  all          Target both adapters.
  --force      Replace unrecognized sddw runtime or command files.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        install|uninstall)
            if [ -n "$ACTION" ]; then
                echo "Only one action may be selected." >&2
                exit 2
            fi
            ACTION="$1"
            ;;
        claude|opencode|all)
            if [ -n "$TARGET" ]; then
                echo "Only one adapter target may be selected." >&2
                exit 2
            fi
            TARGET="$1"
            ;;
        --force)
            FORCE=true
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
    shift
done

if [ -z "$ACTION" ]; then
    echo "Select an action:"
    echo "  1) Install"
    echo "  2) Uninstall"
    read -r -p "Choice: " choice
    case "$choice" in
        1) ACTION="install" ;;
        2) ACTION="uninstall" ;;
        *) echo "Invalid action selection." >&2; exit 2 ;;
    esac
fi

if [ -z "$TARGET" ]; then
    echo "Select an adapter:"
    echo "  1) Claude Code"
    echo "  2) OpenCode"
    echo "  3) Both"
    read -r -p "Choice: " choice
    case "$choice" in
        1) TARGET="claude" ;;
        2) TARGET="opencode" ;;
        3) TARGET="all" ;;
        *) echo "Invalid adapter selection." >&2; exit 2 ;;
    esac
fi

run_adapter() {
    local adapter="$1"
    if [ "$ACTION" = "uninstall" ] && [ "$FORCE" = true ]; then
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --uninstall --force
    elif [ "$ACTION" = "uninstall" ]; then
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --uninstall
    elif [ "$FORCE" = true ]; then
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --force
    else
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh"
    fi
}

check_adapter() {
    local adapter="$1"
    if [ "$ACTION" = "uninstall" ] && [ "$FORCE" = true ]; then
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --uninstall --force --check
    elif [ "$ACTION" = "uninstall" ]; then
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --uninstall --check
    elif [ "$FORCE" = true ]; then
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --force --check
    else
        bash "$SCRIPT_DIR/../adapters/$adapter/install.sh" --check
    fi
}

adapter_paths() {
    local adapter="$1"
    if [ "$adapter" = "claude" ]; then
        ADAPTER_RUNTIME="$HOME/.claude/sddw"
        ADAPTER_COMMANDS_DIR="$HOME/.claude/commands/sddw"
    else
        ADAPTER_RUNTIME="$HOME/.config/opencode/sddw"
        ADAPTER_COMMANDS_DIR="$HOME/.config/opencode/commands"
    fi
    ADAPTER_COMMAND_SOURCE="$SCRIPT_DIR/../adapters/$adapter/commands"
}

backup_adapter() {
    local adapter="$1"
    local backup_root="$ROLLBACK_ROOT/$adapter"
    local source
    local name
    adapter_paths "$adapter"
    mkdir -p "$backup_root/commands"

    if [ -e "$ADAPTER_RUNTIME" ] || [ -L "$ADAPTER_RUNTIME" ]; then
        cp -a "$ADAPTER_RUNTIME" "$backup_root/runtime"
        touch "$backup_root/runtime-present"
    fi

    for source in "$ADAPTER_COMMAND_SOURCE"/*.md; do
        name="$(basename "$source")"
        if [ -e "$ADAPTER_COMMANDS_DIR/$name" ] || [ -L "$ADAPTER_COMMANDS_DIR/$name" ]; then
            cp -a "$ADAPTER_COMMANDS_DIR/$name" "$backup_root/commands/$name"
        fi
    done
}

restore_adapter() {
    local adapter="$1"
    local backup_root="$ROLLBACK_ROOT/$adapter"
    local source
    local name
    adapter_paths "$adapter"

    rm -rf "$ADAPTER_RUNTIME"
    if [ -f "$backup_root/runtime-present" ]; then
        mkdir -p "$(dirname "$ADAPTER_RUNTIME")"
        cp -a "$backup_root/runtime" "$ADAPTER_RUNTIME"
    fi

    mkdir -p "$ADAPTER_COMMANDS_DIR"
    for source in "$ADAPTER_COMMAND_SOURCE"/*.md; do
        name="$(basename "$source")"
        rm -rf "${ADAPTER_COMMANDS_DIR:?}/$name"
        if [ -e "$backup_root/commands/$name" ] || [ -L "$backup_root/commands/$name" ]; then
            cp -a "$backup_root/commands/$name" "$ADAPTER_COMMANDS_DIR/$name"
        fi
    done
}

run_all() {
    check_adapter claude
    check_adapter opencode

    ROLLBACK_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/sddw-all.XXXXXX")"
    ROLLBACK_ACTIVE=false
    ALL_COMMITTED=false

    cleanup_all() {
        if [ "$ROLLBACK_ACTIVE" = true ] && [ "$ALL_COMMITTED" = false ]; then
            restore_adapter claude
            restore_adapter opencode
        fi
        rm -rf "$ROLLBACK_ROOT"
    }
    trap cleanup_all EXIT

    backup_adapter claude
    backup_adapter opencode
    ROLLBACK_ACTIVE=true

    run_adapter claude
    run_adapter opencode

    ALL_COMMITTED=true
    rm -rf "$ROLLBACK_ROOT"
    trap - EXIT
}

case "$TARGET" in
    claude) run_adapter claude ;;
    opencode) run_adapter opencode ;;
    all) run_all ;;
esac
