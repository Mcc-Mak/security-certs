# CI/CD Pipeline

## Overview

A single workflow (`.github/workflows/ci-cd.yml`) runs on every `dev-001` push (plus `workflow_dispatch`). All seven jobs chain in one run — no cascading triggers, no separate PR gates.

## Job chain

```
release → fast_checks → security_checks → promote → ┬─ pages
                                                     ├─ wiki
                                                     └─ sonar_baseline
```

## Jobs

### 1. release

**Purpose**: Auto-bump semver and prepend a CHANGELOG entry from Conventional Commits.

- Parses commit subjects since the last `chore(release):` commit
- Computes bump: `feat!:` → major, `feat:` → minor, else patch
- Prepends `## X.Y.Z (date)` section to `CHANGELOG.md`
- Pushes a `chore(release): X.Y.Z` commit to `dev-001`
- Loop-guarded: skips if HEAD is already a release commit
- `CHANGELOG.md` is in `paths-ignore`, so the push does not re-trigger the workflow

### 2. fast_checks

**Purpose**: Validate study-notes conventions. Hard gate.

- Runs `scripts/validate-notes.sh`:
  - Chapter filenames match `session-{NN}-video-{NNN}-to-{NNN}_{description}.md`
  - Intermediate filenames match `[a-z0-9][a-z0-9-]*.(md|svg)`
  - No plural directory names
  - Mermaid fences balanced (even ``` count per file)
  - No UTF-8 BOM

### 3. security_checks

**Purpose**: SonarQube Cloud quality gate. Optional.

- When `SONAR_TOKEN` is **configured**: runs SonarCloud scan + quality gate check
  - Fail-closed on **ERROR** status
  - **NONE** is non-fatal: SonarCloud's free plan blocks non-main branch QG queries via API (HTTP 403); the main-branch fallback returns NONE until a baseline exists. Since the CE task succeeding means the scan was accepted, NONE is treated as a first-run / plan-limitation scenario
  - The QG check tries three API approaches in order: `analysisId`, `projectKey+branch`, `projectKey` (main)
- When `SONAR_TOKEN` is **absent**: emits a notice and passes
- CodeQL is intentionally omitted — no analyzable source code in a prose repo

### 4. promote

**Purpose**: Direct push `dev-001` HEAD to `dev` and `main`.

- Uses `GITHUB_TOKEN` (built-in, no PAT needed)
- `--force-with-lease` handles stale merge commits
- `GITHUB_TOKEN` pushes do not re-trigger workflows (GitHub security feature)

### 5. pages

**Purpose**: Deploy Docsify site to GitHub Pages.

- Checks out `main` (the promoted commit)
- Runs `scripts/build-pages.sh _site` to assemble the site
- Uploads `_site/` as the Pages artifact and deploys
- No build step — Docsify renders client-side

### 6. wiki

**Purpose**: Sync engineering docs (docbase/) to GitHub Wiki.

- Checks out `main`
- Clones the `.wiki.git` repo using `PROMOTE_TOKEN`
- Runs `scripts/sync-wiki.sh` to generate content:
  - `Home.md` from root `README.md`
  - `TOCTREE.md` from `docbase/TOCTREE.md` (links flattened for wiki root)
  - Engineering docs from `docbase/docs/` copied to wiki root
  - `_Sidebar.md` navigation index
- Commits and pushes with `--force-with-lease`
- Non-blocking: exits 0 if the wiki repo does not exist yet (until first page is saved via web UI)

### 7. sonar_baseline

**Purpose**: Establish SonarCloud main-branch baseline (informational only).

- Checks out `main`
- Runs SonarCloud scan with `GITHUB_REF=refs/heads/main`, `GITHUB_REF_NAME=main`, and `args: -Dsonar.branch.name=main` to ensure the scan is attributed to the `main` branch (not the workflow trigger branch `dev-001`)
- No quality-gate check, no fail-closed
- Ensures the dashboard has a current main-branch baseline for new-code calculations

## Concurrency

- `concurrency.group: ci-cd-${{ github.ref }}` with `cancel-in-progress: false`
- Pages and Wiki each have their own concurrency groups (one deploy at a time)
