# Feature Manifest

The lifecycle authority for one feature. All steps SHALL read this file before work and update it after creating, regenerating, approving, invalidating, or releasing an artifact.

**Location:** `.sddw/<feature-name>/feature-manifest.md`

## Format

```markdown
# Feature Manifest: <feature-name>

## Identity
- **Feature ID:** <stable ID>
- **Issue:** <URL or ID>
- **Branch:** <branch name>
- **Project root:** <resolved absolute path>
- **Code baseline SHA:** <full commit SHA>
- **Trusted governance:** <allowlisted path@sha256 entries and approval references>
- **Manifest revision:** <integer, starts at 1>
- **Lifecycle status:** <proposed | specified | designed | planned | implementing | verifying | reviewed | release-ready | released | blocked | cancelled>
- **Updated:** <ISO-8601 UTC>

## Artifact Ledger
| Artifact ID | Location | Revision | SHA-256 | Status | Inputs | Approvals |
|---|---|---:|---|---|---|---|
| requirements | requirements.md | 1 | <hash> | approved | issue@<revision> | <human, ISO time, immutable event ID/URL> |

## Revision Archive
| Artifact ID | Revision | Immutable snapshot | SHA-256 | Superseded by |
|---|---:|---|---|---|
| requirements | 1 | history/requirements/rev-1.md | <hash> | <revision or current> |

## Invalidation
| Source | Changed revision/hash | Invalidated downstream IDs | Reason | Recorded at | Resolution |
|---|---|---|---|---|---|

## Gates
| Area | Status | Evidence | Approval |
|---|---|---|---|
| Quality | <pending/passed/failed/waived> | quality/plan.md#... | <human/date/reference or pending> |
| Review | <pending/PASS/FAIL/BLOCKED> | review/latest.md | <human/date or pending> |
| Release | <pending/approved/blocked/released> | <release/plan.md while approved; release/latest.md when released> | <human/date or pending> |

## Trace Links
- **Change requests:** changes/
- **Traceability:** traceability-matrix.md
- **Decisions:** decisions/
- **Risks:** risk-register.md
- **Runs:** runs/
- **Release:** release/
```

## Rules

- Feature ID is immutable. Project root SHALL be absolute; baseline SHA SHALL identify the code used to create the current specification.
- Artifact status is `draft`, `in-review`, `approved`, `stale`, `superseded`, or `waived`. Revision starts at 1 and increases on every content regeneration.
- SHA-256 is calculated from the exact artifact bytes after writing. The manifest's own revision is stored in its header; a self-hash SHALL NOT be embedded.
- Inputs use `<artifact-id>@<revision>#<sha256>` so the exact dependency is reproducible.
- Approval records contain approver identity, decision, ISO-8601 UTC time, and a platform-verifiable immutable event ID or URL. Free-text approval without that reference is `unverified` and SHALL NOT open a gate. Regeneration clears prior approval unless the content hash is unchanged.
- Before replacing a canonical artifact, copy its exact prior bytes to `history/<artifact-id>/rev-<N>.md`, verify the archive hash, and point its ledger/archive record to that immutable snapshot. Canonical paths represent only the current revision; historical input references SHALL resolve to revision-specific snapshots.
- When an upstream revision or hash changes, all directly and transitively dependent artifacts become `stale`, their approvals become invalid, affected gates become `pending`, and lifecycle status becomes `blocked` until regeneration or explicit human disposition.
- A stale artifact SHALL NOT authorize implementation, review, or release. The invalidation row SHALL name every affected artifact and its resolution.
- Lifecycle status may advance only when required artifact and gate states support it. Automated execution cannot grant mandatory human approvals.
- New and regenerated artifacts SHALL use the current template. Existing artifacts are not migrated solely to adopt this manifest.
- Run manifests never hash or embed the final feature manifest. The feature manifest may reference a completed run manifest and its hash, establishing a one-way link without a hash cycle.
