# Claude Adapter Bridge

This file maps the platform-independent core interaction contract to Claude Code.

- Structured questions use `AskUserQuestion`.
- Multiple-choice questions use the tool's multi-select option.
- Context previews are shown before the question or through the tool's preview support.
- Context reset recommendations use `/clear`.
- The installed workflow root is `~/.claude/sddw`.
- Core files are loaded from `~/.claude/sddw/core/`.
- Claude command names use the `/sddw:<step>` format.

These mappings belong to the Claude adapter and must not be copied into core files.
