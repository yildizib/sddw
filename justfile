# sddw development commands

# Choose adapters interactively and install snapshots from this checkout
install:
    bash bin/install.sh

# Install the Claude adapter from local source
install-claude:
    bash adapters/claude/install.sh

# Install the OpenCode adapter from local source
install-opencode:
    bash adapters/opencode/install.sh

# Uninstall the managed Claude snapshot and commands
uninstall:
    bash adapters/claude/install.sh --uninstall

# Uninstall the managed OpenCode snapshot and commands
uninstall-opencode:
    bash adapters/opencode/install.sh --uninstall
