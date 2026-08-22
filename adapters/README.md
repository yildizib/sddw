# Platform Adapters

Each adapter connects the platform-independent workflow in `../core/` to a
host agent. Adapters are independent of one another and must not change core
workflow semantics.

## Adapter Responsibilities

- Define platform command wrappers.
- Map the core interaction contract to platform tools.
- Provide platform-specific installation instructions and scripts.
- Preserve the shared `.sddw/` artifact layout.
- Preserve feature-manifest revisions, hashes, invalidation, status, and evidence semantics.
- Expose every lifecycle command and the Chat and Help utilities supported by `core/steps.txt`.
- Preserve mandatory human gates; platform auto-approval settings must never be interpreted as lifecycle approval.
- Run adapter-specific smoke and conformance checks.

Installers copy the complete core and only the selected adapter runtime files
from the current checkout into a platform-specific user-global snapshot.
Installed command wrappers remain separate from the copied core, and Claude
and OpenCode never share a runtime snapshot.

## Semantic Boundary

Adapters translate command syntax, interaction primitives, and tool names only.
They must not weaken the core trust model, infer human approval from a platform
permission, collapse independent Review into Verify, report planned release
work as completed, or treat `--auto` as authorization for a gated action.

All adapters expose the same governed sequence: Requirements, optional Code
Analysis, Design, Taskify, Implement, Verify, independent Review, Release
readiness/post-release, and Self-Improve. The combined Design & Taskify command
has the same governance as the separate stages. Chat and Help remain utilities,
not shortcuts around lifecycle gates.

New and regenerated artifacts use the current feature-manifest and revision
model. Adapters do not provide legacy migration, compatibility, or dual-write
behavior for older artifacts.

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
