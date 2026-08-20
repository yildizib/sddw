# OpenCode Adapter Bridge

This file maps the platform-independent core interaction contract to OpenCode.

- Structured questions use the OpenCode `question` mechanism.
- Multiple-choice questions request multiple selections when supported.
- Context previews are written as normal context before asking for a decision.
- A fresh session is recommended when the core requests a context reset.
- The installed workflow root is `~/.config/opencode/sddw`.
- Core files are loaded from `~/.config/opencode/sddw/core/`.
- OpenCode command names use the `/sddw-<step>` format.
- The current project directory remains the root for `.sddw/` artifacts.

These mappings belong to the OpenCode adapter and must not be copied into core files.
