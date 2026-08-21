# sddw development commands

# Install from local source (symlink + register commands)
install:
    bash bin/install.sh --local

# Install the Claude adapter from local source
install-claude:
    bash adapters/claude/install.sh --local

# Install the OpenCode adapter from local source
install-opencode:
    bash adapters/opencode/install.sh --local

# Uninstall (remove symlink and commands)
uninstall:
    rm -rf ~/.claude/sddw
    rm -rf ~/.claude/commands/sddw
    @echo "Uninstalled."

# Uninstall OpenCode command wrappers and local workflow link
uninstall-opencode:
    rm -rf ~/.config/opencode/sddw
    rm -rf ~/.config/opencode/commands/sddw-*.md
    @echo "OpenCode adapter uninstalled."
