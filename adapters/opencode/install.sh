#!/usr/bin/env bash
set -euo pipefail

OPENCODE_DIR="$HOME/.config/opencode"
SDDW_DIR="$OPENCODE_DIR/sddw"
COMMANDS_DIR="$OPENCODE_DIR/commands"
REPO_URL="https://github.com/yildizib/sddw.git"
SOURCE_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LOCAL=false
PROJECT_DIR=""

usage() {
    cat <<'EOF'
Usage: install.sh [--local] [--project <path>]

  --local              Use the current repository instead of cloning it.
  --project <path>     Install command wrappers into <path>/.opencode/commands.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --local)
            LOCAL=true
            shift
            ;;
        --project)
            [ "$#" -ge 2 ] || { usage >&2; exit 2; }
            PROJECT_DIR="$(cd "$2" && pwd)"
            shift 2
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

if [ -n "$PROJECT_DIR" ] && [ "$PROJECT_DIR" = "$SOURCE_ROOT" ]; then
    echo "Refusing to install project-local commands into the sddw repository root." >&2
    echo "Pass the path of the project that will use sddw instead." >&2
    exit 1
fi

if [ "$LOCAL" = true ]; then
    if [ -L "$SDDW_DIR" ]; then
        rm "$SDDW_DIR"
    elif [ -e "$SDDW_DIR" ]; then
        echo "Refusing to replace existing non-symlink: $SDDW_DIR" >&2
        exit 1
    fi
    mkdir -p "$OPENCODE_DIR"
    ln -s "$SOURCE_ROOT" "$SDDW_DIR"
else
    if [ -d "$SDDW_DIR/.git" ]; then
        git -C "$SDDW_DIR" pull --ff-only origin main
    elif [ -e "$SDDW_DIR" ]; then
        echo "Refusing to replace existing non-git installation: $SDDW_DIR" >&2
        exit 1
    else
        mkdir -p "$OPENCODE_DIR"
        git clone "$REPO_URL" "$SDDW_DIR"
    fi
fi

if [ -n "$PROJECT_DIR" ]; then
    COMMANDS_DIR="$PROJECT_DIR/.opencode/commands"
fi

mkdir -p "$COMMANDS_DIR"
count=0
for source in "$SDDW_DIR"/adapters/opencode/commands/*.md; do
    destination="$COMMANDS_DIR/$(basename "$source")"
    if [ -e "$destination" ]; then
        echo "Updating managed command: $destination"
    else
        echo "Installing command: $destination"
    fi
    cp "$source" "$destination"
    count=$((count + 1))
done

echo "Installed $count OpenCode commands to $COMMANDS_DIR"
echo "Shared core: $SDDW_DIR/core"
