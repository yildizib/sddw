# Run Manifest

Provides reproducible evidence for one lifecycle step execution, including interrupted and resumed runs.

**Location:** `.sddw/<feature-name>/runs/run-<YYYYMMDDTHHMMSSZ>-<step>.md`

## Format

```markdown
# Run: <run ID>
- **Feature ID:** <ID>
- **Step:** <requirements | code-analysis | design | taskify | design_and_taskify | implement | verify | review | release | self-improve | chat | other>
- **Status:** <running | succeeded | failed | blocked | interrupted | resumed>
- **Started/ended:** <ISO-8601 UTC> / <ISO-8601 UTC or pending>
- **Parent run:** <run ID or none>
- **Resume checkpoint:** <checkpoint ID or none>
- **Model:** <provider/model/version or human>
- **Tools:** <tool names and versions>
- **Code baseline SHA:** <full SHA>
- **Input revisions:** <artifact@revision#hash list>

## Actions
| At | Action/tool | Exact command or normalized arguments | Working directory/target | Result | Evidence |
|---|---|---|---|---|---|

## Outputs
| Artifact/path | Revision | SHA-256 | Result |
|---|---:|---|---|

## Failure
- **Failed action:** <row/action or none>
- **Error:** <redacted error or none>
- **State changed before failure:** <paths/resources or none>
- **Recovery required:** <steps or none>

## Resume
- **Safe checkpoint:** <last verified checkpoint>
- **Pre-resume validation:** <input hashes, baseline, filesystem/tool state>
- **Next action:** <exact action>
```

## Rules

- Create the manifest at run start and update it after each material action. Record actual commands/results, not planned execution.
- Redact secrets and sensitive data while preserving useful diagnostics. Link large logs instead of embedding them.
- A resumed run creates a new run manifest linked to its parent. Resume only after verifying baseline, input hashes, outputs, and side effects; otherwise restart from the last safe checkpoint.
- Failures SHALL record partial changes and recovery. Success requires output hashes and a subsequent feature-manifest update. The run manifest SHALL NOT include the final feature-manifest hash; the feature manifest links to the completed run and its hash in one direction.
- Run evidence is outside an artifact publication rollback set: a failed atomic publication restores canonical artifacts but preserves the run record and its recovery evidence.
