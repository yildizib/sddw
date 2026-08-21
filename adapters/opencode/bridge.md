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

## Command Map

- Requirements: `/sddw-requirements`
- Code Analysis: `/sddw-code-analysis`
- Design: `/sddw-design`
- Taskify: `/sddw-taskify`
- Design and Taskify: `/sddw-design-and-taskify`
- Implement: `/sddw-implement`
- Verify: `/sddw-verify`
- Self-Improve: `/sddw-self-improve`
- Chat: `/sddw-chat`
- Help: `/sddw-help`

These mappings belong to the OpenCode adapter and must not be copied into core files.
