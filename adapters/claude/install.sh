#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
SDDW_DIR="$CLAUDE_DIR/sddw"
COMMANDS_DIR="$CLAUDE_DIR/commands/sddw"
REPO_URL="https://github.com/yildizib/sddw.git"
LOCAL=false

for arg in "$@"; do
    case "$arg" in
        --local) LOCAL=true ;;
        *) echo "Unknown argument: $arg" >&2; exit 2 ;;
    esac
done

echo "sddw Claude adapter installer"
echo "============================"

if [ "$LOCAL" = true ]; then
    SRC_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
    mkdir -p "$CLAUDE_DIR"
    echo "Installing from local source: $SRC_DIR"

    if [ -L "$SDDW_DIR" ]; then
        rm "$SDDW_DIR"
    elif [ -e "$SDDW_DIR" ]; then
        echo "Refusing to replace existing non-symlink: $SDDW_DIR" >&2
        exit 1
    fi

    ln -s "$SRC_DIR" "$SDDW_DIR"
    echo "Linked $SDDW_DIR -> $SRC_DIR"
else
    if [ -d "$SDDW_DIR/.git" ]; then
        echo "Updating existing installation at $SDDW_DIR"
        git -C "$SDDW_DIR" pull --ff-only origin main
    elif [ -e "$SDDW_DIR" ]; then
        echo "Refusing to replace existing non-git installation: $SDDW_DIR" >&2
        exit 1
    else
        echo "Installing to $SDDW_DIR"
        git clone "$REPO_URL" "$SDDW_DIR"
    fi
fi

mkdir -p "$COMMANDS_DIR"

count=0
for source in "$SDDW_DIR"/adapters/claude/commands/*.md; do
    command_name="$(basename "$source")"
    destination="$COMMANDS_DIR/$command_name"
    if [ -e "$destination" ]; then
        echo "Updating managed command: $destination"
    else
        echo "Installing command: $destination"
    fi
    cp "$source" "$destination"
    count=$((count + 1))
done

echo "Installed $count Claude commands to $COMMANDS_DIR"
