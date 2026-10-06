# Configurations

## Secrets

The pipeline uses two optional GitHub repository secrets, documented in `.env.example`:

| Secret | Purpose | Required? |
| :--- | :--- | :--- |
| `PROMOTE_TOKEN` | GitHub PAT (repo scope) used by the `wiki` job to push to the `.wiki.git` repo | Required for wiki sync |
| `SONAR_TOKEN` | SonarQube Cloud analysis token for the `security_checks` and `sonar_baseline` jobs | Optional — skipped when absent |

### Setting secrets

```bash
cp .env.example .env
# Fill in real values
./scripts/configure-secrets.sh
```

The script uses `gh secret set` to push values into GitHub's encrypted store. The local `.env` is gitignored and never committed.

## GitHub Pages

- **Source**: GitHub Actions (not the `gh-pages` branch)
- **Build type**: `workflow` — the `pages` job uploads `_site/` as the artifact
- **Deployment branches**: `dev-001` and `main` are registered in the `github-pages` environment policy

Enable via `scripts/configure-secrets.sh` or manually at Settings → Pages → Source: GitHub Actions.

## GitHub Wiki

- The wiki feature must be enabled in Settings → General → Features → Wikis
- The `.wiki.git` repo is **not created** until the first page is saved through the web UI
- Until then, the `wiki` job prints a warning and exits 0 (non-blocking)
- Once initialized, `scripts/sync-wiki.sh` populates it automatically on every promotion

## Conventional Commits and versioning

The `release` job parses commit subjects since the last `chore(release):` commit:

| Commit type | Version bump |
| :--- | :--- |
| `feat!:` or `BREAKING CHANGE:` in body | major |
| `feat:` | minor |
| `fix:`, `chore:`, `docs:`, anything else | patch |

Version policy for this notes repo:

| Bump | When |
| :--- | :--- |
| major | Content removed, restructured, or renamed (breaks links) |
| minor | New sessions, notes, diagrams, or question banks added |
| patch | Corrections to existing content |

## sonar-project.properties

```
sonar.organization=mcc-mak
sonar.projectKey=mcc-mak_security-certs
sonar.projectName=security-certs
sonar.sources=codebase
sonar.exclusions=**/*.pdf,**/*.svg,**/*.html,**/*.csv,**/.git/**,.scannerwork/**
sonar.sourceEncoding=UTF-8
```

Excludes binary assets (PDFs, SVGs, HTML pages, CSV results) — only markdown is analyzed.
