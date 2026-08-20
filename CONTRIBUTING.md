# Contributing to sddw

Thank you for contributing to `sddw`.

This repository uses an issue-driven, pull-request-based workflow. All normal
development work starts from an issue, is implemented on an issue branch, and
is merged into `develop` through a pull request.

## Branch Strategy

The repository uses the following branch model:

```text
main       Production and release branch
  ^
develop    Integration branch for completed work
  ^
issue-*    Short-lived branches created from develop
```

### Protected Branches

- `main` is the production and release branch.
- `develop` is the integration branch for normal development.
- Direct commits to `main` and `develop` are not allowed.
- Direct merges from a local checkout are not allowed. All merges must happen
  through GitHub pull requests.
- Normal feature and bug-fix pull requests must target `develop`.
- Normal feature and bug-fix pull requests must never target `main` directly.
- The `master` branch is not currently used. If it is introduced later, it
  must follow the same protection and release rules as `main`.

Recommended GitHub branch protection settings:

- Require a pull request before merging.
- Require passing status checks before merging.
- Require conversation resolution before merging.
- Restrict direct pushes.
- Restrict force pushes and branch deletion.
- Require at least one approval where repository permissions support it.

### Initialize `develop`

The `develop` branch must be created from the current release branch. In this
repository the release branch is `main`; use `master` instead only if that is
the repository's configured release branch.

Run this one-time setup only when `develop` does not already exist:

```bash
git fetch origin
git switch main
git pull --ff-only origin main
git switch -c develop
git push --set-upstream origin develop
```

If `develop` already exists locally or on the remote, do not recreate it. Bring
it up to date instead:

```bash
git fetch origin
git switch develop
git pull --ff-only origin develop
```

## Prerequisites

Install and authenticate the required tools before starting:

```bash
git --version
gh --version
gh auth status
```

Authenticate with GitHub if necessary:

```bash
gh auth login
```

Confirm the repository and remotes:

```bash
gh repo view --web
git remote -v
```

## End-to-End Contribution Workflow

Every contribution follows this sequence:

```text
1. Create or select an issue
2. Get the issue number
3. Create an issue branch from develop
4. Implement and validate the change
5. Commit using the required commit format
6. Push the branch
7. Open a pull request targeting develop
8. Resolve review comments and pass CI
9. Merge the pull request through GitHub
10. Delete the local and remote issue branch
11. Close the issue, unless GitHub closed it automatically
```

Do not skip the issue or branch step for non-trivial changes. If a change is
too small to justify a separate issue, confirm the exception with a maintainer
before modifying a protected branch.

## 1. Create an Issue

Create an issue before starting implementation. Use a precise, action-oriented
title and describe the problem or desired outcome.

Create an issue interactively:

```bash
gh issue create --title "Add OpenCode adapter" --body "Describe the problem, proposed outcome, scope, and acceptance criteria." --label enhancement
```

Create an issue from a file:

```bash
gh issue create --title "Add OpenCode adapter" --body-file .github/ISSUE_TEMPLATE/feature_request.md --label enhancement
```

The issue should contain, when applicable:

- Problem statement
- Proposed outcome
- Scope and non-goals
- Acceptance criteria
- Testing or validation expectations
- Related issues or dependencies

## 2. Get the Issue Number

`gh issue create` returns the created issue URL. Capture it and derive the
issue number for use in the branch name and pull request:

```bash
ISSUE_URL=$(gh issue create --title "Add OpenCode adapter" --body-file .github/ISSUE_TEMPLATE/feature_request.md --label enhancement)

ISSUE_NUMBER=$(basename "$ISSUE_URL")
echo "Created issue #$ISSUE_NUMBER"
```

Verify the issue before creating the branch:

```bash
gh issue view "$ISSUE_NUMBER"
```

If the issue already exists, do not create a duplicate. Find and inspect it:

```bash
gh issue list --search "OpenCode adapter"
gh issue view <issue-number>
```

## 3. Create an Issue Branch

Always create issue branches from the latest `develop` branch:

```bash
git fetch origin
git switch develop
git pull --ff-only origin develop
```

Use this branch naming format:

```text
issue-<issue-number>-<kebab-case-issue-title>
```

Examples:

```text
issue-24-add-opencode-adapter
issue-25-fix-install-script
issue-26-document-release-policy
```

Create and publish the branch:

```bash
BRANCH="issue-${ISSUE_NUMBER}-add-opencode-adapter"

git switch -c "$BRANCH" origin/develop
git push --set-upstream origin "$BRANCH"
```

Do not create normal issue branches from `main`, `master`, or another feature
branch.

## 4. Implement and Validate

Keep changes focused on the issue. Before committing:

- Read the relevant requirements and design artifacts.
- Follow existing project conventions.
- Add or update tests when behavior changes.
- Run the project validation commands.
- Review the complete diff.
- Confirm that no secrets, generated files, or unrelated changes are staged.

Useful checks:

```bash
git status --short
git diff
git diff --check
```

Run the project-specific test and validation commands documented by the
project. If no automated test suite exists, document the manual validation
performed in the pull request.

## 5. Commit Changes

Use Conventional Commit messages with the issue number:

```text
<type>(<scope>): <description> (#<issue-number>)
```

Supported commit types:

- `feat`: New functionality
- `fix`: Bug fix
- `docs`: Documentation-only change
- `test`: Test changes
- `refactor`: Behavior-preserving refactor
- `chore`: Maintenance, tooling, or release work

Examples:

```text
feat(opencode): add command adapter (#24)
fix(install): preserve existing command files (#25)
docs(contributing): document release workflow (#26)
test(workflow): validate adapter generation (#27)
refactor(core): separate platform instructions (#28)
chore(release): prepare v1.0.0
```

Stage files explicitly. Do not use `git add .` or `git add -A`:

```bash
git add CONTRIBUTING.md
git add path/to/changed-file path/to/test-file
git diff --cached --check
git commit -m "docs(contributing): document release workflow (#26)"
```

Keep commits focused. If the change contains unrelated work, split it into
separate issues and branches.

## 6. Push the Branch

Push commits to the issue branch:

```bash
git push
```

Before opening a pull request, confirm the branch and working tree:

```bash
git status --short --branch
git log --oneline --decorate -10
```

## 7. Open a Pull Request

Normal contribution pull requests must target `develop`:

```bash
gh pr create --base develop --head "$BRANCH" --title "[#${ISSUE_NUMBER}] Add OpenCode adapter" --body "Closes #${ISSUE_NUMBER}\n\n## Summary\n- Add the OpenCode adapter\n\n## Validation\n- Describe the tests and checks that were run."
```

A pull request must include:

- A clear summary of the change
- The related issue reference
- Scope and behavior notes
- Tests or manual validation results
- Known limitations or follow-up work
- Any required documentation updates

Inspect the pull request:

```bash
PR_NUMBER=$(gh pr view "$BRANCH" --json number --jq '.number')
gh pr diff "$PR_NUMBER"
```

Monitor required checks:

```bash
gh pr checks "$PR_NUMBER"
gh pr checks "$PR_NUMBER" --watch
```

## 8. Review and Merge

The author must not bypass review or merge directly into a protected branch.
Reviewers should verify:

- The change addresses the linked issue.
- The scope is limited and understandable.
- Tests and validation are sufficient.
- Documentation is updated where necessary.
- No security, compatibility, or release risks are unresolved.

After review comments are addressed and checks pass, merge the pull request
through GitHub CLI or the GitHub web interface. Squash merging is recommended
for short-lived issue branches:

```bash
gh pr merge "$PR_NUMBER" --squash --subject "feat(opencode): add command adapter (#${ISSUE_NUMBER})" --delete-branch
```

Do not use `--admin` to bypass branch protection except for a documented,
time-critical incident approved by a maintainer.

## 9. Delete the Issue Branch

If GitHub did not delete the branch automatically, delete the remote branch:

```bash
git push origin --delete "$BRANCH"
```

Delete the local branch after returning to `develop`:

```bash
git switch develop
git pull --ff-only origin develop
git branch -d "$BRANCH"
```

Use `git branch -D` only when the branch has been intentionally abandoned and
a maintainer has confirmed that no work will be lost.

## 10. Close the Issue

Prefer linking the pull request with a closing keyword:

```markdown
Closes #24
```

GitHub should close the issue when the pull request is merged. Verify the
issue state:

```bash
gh issue view "$ISSUE_NUMBER"
```

If the issue remains open, close it explicitly with a comment:

```bash
gh issue close "$ISSUE_NUMBER" --comment "Implemented and merged through PR #${PR_NUMBER}."
```

Do not close an issue before its pull request is merged unless the issue is
duplicate, invalid, or intentionally superseded. Explain the reason in the
closing comment.

## Release Policy

Releases follow Semantic Versioning:

```text
v<MAJOR>.<MINOR>.<PATCH>
```

The first release of this repository is `v1.0.0`.

### Version Rules

- `MAJOR` changes indicate incompatible behavior or workflow changes.
- `MINOR` changes add backward-compatible functionality.
- `PATCH` changes fix backward-compatible bugs or documentation issues.
- Release tags use the `v` prefix, for example `v1.0.0`.
- Tags are created only on `main`.
- Tags are created only after the release pull request has been merged.
- Existing release tags must never be moved, overwritten, or deleted.
- Every release tag must have a corresponding GitHub Release.

### First Release: v1.0.0

For the first release, confirm that `v1.0.0` does not already exist:

```bash
git fetch --tags origin
git tag --list "v1.0.0"
```

Prepare and review the release on `develop`. For a release that needs no
release-only changes, open a release pull request directly:

```bash
gh pr create --base main --head develop --title "Release v1.0.0" --body "## Release v1.0.0\n\nThis is the first stable release.\n\nReview the complete change history and confirm that all required validation has passed."
```

After the release pull request is approved and merged, create the annotated
tag on the updated `main` branch:

```bash
git switch main
git pull --ff-only origin main

git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

Create the GitHub Release from the tag:

```bash
gh release create v1.0.0 --title "v1.0.0" --generate-notes --verify-tag
```

The tag must point to the merge result on `main`, not to an earlier commit on
`develop` or an issue branch.

### Release Branches

For releases that require release-specific documentation, changelog, or final
validation changes, create a release branch from `develop`:

```bash
git switch develop
git pull --ff-only origin develop
git switch -c release/v1.0.0
git push --set-upstream origin release/v1.0.0
```

The release branch must then follow this flow:

```text
release/v1.0.0 -> pull request -> main -> tag v1.0.0 -> GitHub Release
```

Release branches are short-lived and must be deleted after the release PR is
merged.

### Sync main Back to develop

After every release, synchronize release-only changes back into `develop`:

```bash
gh pr create --base develop --head main --title "Sync v1.0.0 release changes back to develop" --body "Synchronize the v1.0.0 release changes from main back into develop."
```

This keeps both protected branches aligned without bypassing the pull request
workflow.

### Hotfixes

Hotfixes branch from the current `main` release:

```bash
git switch main
git pull --ff-only origin main
git switch -c hotfix/1.0.1-security-fix
git push --set-upstream origin hotfix/1.0.1-security-fix
```

Open the hotfix pull request against `main`. After it is merged:

1. Create and push the next patch tag, such as `v1.0.1`.
2. Create the corresponding GitHub Release.
3. Open a pull request from `main` back into `develop`.
4. Delete the hotfix branch.

Hotfixes must not be silently left out of `develop`.

## Useful GitHub CLI Commands

List open issues:

```bash
gh issue list
```

List pull requests:

```bash
gh pr list
```

View a pull request as JSON:

```bash
gh pr view <pr-number> --json number,state,baseRefName,headRefName,url
```

View release tags:

```bash
gh release list
git tag --list --sort=version:refname
```

Close a pull request without merging only when it is obsolete or superseded:

```bash
gh pr close <pr-number> --comment "Superseded by PR #<new-pr-number>."
```

## Rules Summary

- Start work from an issue.
- Create the issue branch from `develop`.
- Use the issue number in the branch and commit messages.
- Open normal pull requests against `develop`.
- Do not commit or merge directly into `main` or `develop`.
- Merge through GitHub after review and passing checks.
- Delete the issue branch after merge.
- Close the issue after the work is merged.
- Create release tags only on `main`, after the release PR is merged.
- Start releases at `v1.0.0` and follow Semantic Versioning.
