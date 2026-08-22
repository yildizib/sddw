# Platform Adapters

Each adapter connects the platform-independent workflow in `../core/` to a
host agent. Adapters are independent of one another and must not change core
workflow semantics.

## Adapter Responsibilities

- Define platform command wrappers.
- Map the core interaction contract to platform tools.
- Provide platform-specific installation instructions and scripts.
- Preserve the shared `.sddw/` artifact layout.
- Run adapter-specific smoke and conformance checks.

Installers copy the complete core and only the selected adapter runtime files
from the current checkout into a platform-specific user-global snapshot.
Installed command wrappers remain separate from the copied core, and Claude
and OpenCode never share a runtime snapshot.

## Adding an Adapter

Create a new directory under `adapters/` with:

```text
<platform>/
├── adapter.json
├── bridge.md
├── commands/
└── install.sh
```

Do not modify `core/` to add a platform. New adapters must pass
`tools/validate-boundaries.sh` and provide a command for every step in
`core/steps.txt`.
