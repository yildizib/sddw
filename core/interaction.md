# Core Interaction Contract

The workflow uses the following platform-independent interaction concepts:

- **Open-ended question** — ask the user for a free-form answer.
- **Single-choice question** — offer 2-4 concrete options and ask the user to select one.
- **Multiple-choice question** — allow the user to select more than one option when choices are not mutually exclusive.
- **Confirmation** — ask the user to approve, edit, or reject a proposal.
- **Context preview** — present code, architecture, or specification content as normal context before asking for a decision.
- **Context reset** — recommend a fresh context between isolated workflow steps when the platform supports it.

Platform adapters map these concepts to the host agent's question, context, and command mechanisms. Core instructions must not name a host platform or tool.
