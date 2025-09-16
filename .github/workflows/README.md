# GitHub Workflows for AtomicArch

This directory contains GitHub Actions workflows for continuous integration and automated releases for the AtomicArch project.

## Available Workflows

### 1. CI Workflow (`ci.yml`)
Runs on pushes to `main` and all pull requests.
- Builds the project
- Runs all tests
- Uploads test results as artifacts

### 2. PR Checks Workflow (`pr_checks.yml`)
Runs on pull requests to `main`.
- Runs SwiftLint checks
- Builds the project
- Runs all tests
- Uploads test results

### 3. Release Workflow (`release.yml`)
Triggered when a tag with format `v*.*.*` is pushed.
- Builds and tests the project
- Creates a GitHub release with:
  - Auto-generated changelog
  - Feature summary
  - Installation instructions

## How to Create a Release

1. Ensure your code is ready for release and merged to `main`
2. Create and push a new tag:
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```
3. The release workflow will automatically create a GitHub release

## Requirements

The workflows assume:
- macOS latest runner
- Xcode latest version
- AtomicArch.xcodeproj at the root of the repository
- `AtomicArch` as the primary scheme