---
name: release
description: Release a new version of flutter_line_sdk. Handles changelog, version bumps, git tag, GitHub release, and pub.dev publish.
allowed-tools: Bash(git:*), Bash(gh:*), Bash(flutter:*), Bash(dart:*), Read, Edit, Write, Grep, Glob
---

# Release Skill for flutter_line_sdk

Release a new version of the `flutter_line_sdk` Flutter plugin. This skill walks through the full release pipeline step by step, with user confirmation at each critical stage.

## Input

The user may provide:
- `$VERSION` — the new version number (e.g. `2.8.0`). If not provided, ask for it.
- `$BUMP_TYPE` — one of `major`, `minor`, `patch`. If provided instead of a version, calculate the new version from the current one.
- Release notes or a description of what changed. If not provided, infer from git log since the last tag.

## Pre-flight Checks

Before starting, verify:

1. Working directory is clean (`git status --porcelain` is empty). If not, warn the user and stop.
2. Current branch is `master`. If not, warn and stop.
3. Read the current version from `pubspec.yaml` (line starting with `version:`).
4. Read the latest git tag (`git describe --tags --abbrev=0`).
5. Confirm the new version is greater than the current version.

## Step 1: Generate Changelog Entry

Collect changes since the last tag:

```bash
git log $(git describe --tags --abbrev=0)..HEAD --oneline --no-merges
```

Also check for merged PRs:

```bash
git log $(git describe --tags --abbrev=0)..HEAD --oneline --grep="Merge pull request"
```

Categorize commits into sections following the existing CHANGELOG.md format:
- `### Added` — new features
- `### Changed` — changes to existing functionality
- `### Fixed` — bug fixes
- `### Removed` — removed features

Draft the changelog entry in this format:

```markdown
## $VERSION

### Added

* Description of addition. [#N](https://github.com/line/flutter_line_sdk/pull/N)

### Fixed

* Description of fix. [#N](https://github.com/line/flutter_line_sdk/issues/N)
```

**Present the draft to the user for review and editing before proceeding.**

## Step 2: Update CHANGELOG.md

Prepend the approved changelog entry to the top of `CHANGELOG.md` (before the first `## X.Y.Z` line).

## Step 3: Bump Version Numbers

Three files must be updated with the new version:

### 3a. pubspec.yaml
Update `version: X.Y.Z` on line 3.

### 3b. ios/flutter_line_sdk.podspec
Update `s.version = 'X.Y.Z'` on line 3.

### 3c. example/pubspec.yaml
Update `version: X.Y.Z+N` on line 4.
- The build number `N` is the total commit count of the repo: `git rev-list --count HEAD`.
- Note: this count will increase by 1 after the version bump commit in Step 5, so use the value **after** committing (i.e. current count + 1 for the upcoming commit).

## Step 4: Validate

Run checks to ensure everything is in order:

```bash
flutter pub get
flutter analyze --fatal-infos
flutter test
```

If any check fails, report the error and stop. Do NOT proceed with committing broken code.

## Step 5: Commit and Tag

**Ask the user for confirmation before committing.**

Create a single commit with all version-bump changes:

```bash
git add pubspec.yaml ios/flutter_line_sdk.podspec example/pubspec.yaml CHANGELOG.md
git commit -m "Bump version to $VERSION"
```

Then tag:

```bash
git tag $VERSION
```

## Step 6: Push

**Ask the user for confirmation before pushing.**

```bash
git push origin master
git push origin $VERSION
```

## Step 7: Create GitHub Release

Create a GitHub release using the changelog entry as the body. The repo is on `github.com` (NOT `git.linecorp.com`).

```bash
gh release create $VERSION --title "$VERSION" --notes-file - <<'EOF'
<changelog entry content for this version>
EOF
```

## Step 8: Publish to pub.dev

**Ask the user for confirmation before publishing.** This is irreversible.

```bash
flutter pub publish
```

If the user wants to do a dry run first:

```bash
flutter pub publish --dry-run
```

## Post-release Summary

After completing all steps, display a summary:

```
✓ CHANGELOG.md updated
✓ Version bumped to $VERSION in 3 files
✓ Committed and tagged $VERSION
✓ Pushed to origin/master
✓ GitHub release created: https://github.com/line/flutter_line_sdk/releases/tag/$VERSION
✓ Published to pub.dev
```

## Important Notes

- **Never force-push or rewrite history.**
- **Always confirm with the user before**: committing, pushing, creating the GitHub release, and publishing to pub.dev.
- If anything goes wrong mid-process, explain the current state clearly so the user can decide how to proceed.
- The GitHub repo is `line/flutter_line_sdk` on `github.com`. Do NOT use `GH_HOST=git.linecorp.com`.
- Keep commit messages concise and consistent with existing style (see `git log --oneline`).
