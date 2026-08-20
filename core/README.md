# sddw Core

The core contains the platform-independent Spec-Driven Development workflow.

## Contents

- `instructions/` — workflow process rules
- `questionnaires/` — platform-neutral interaction guidance
- `specs/` — artifact formats and output contracts
- `interaction.md` — normalized interaction concepts
- `steps.txt` — supported workflow steps

The core must not reference a host platform, platform-specific tool, command
syntax, installation path, or adapter directory. Platform adapters consume the
core and provide those mappings separately.
