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

### Bootstrap

Bootstrap 5.3 is loaded via CDN with SRI integrity hashes, **before** the Docsify theme so Docsify overrides where they conflict:

| Asset | Source | SRI |
| :--- | :--- | :--- |
| Bootstrap CSS | `cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css` | `sha384-QWTK...` |
| Docsify theme | `cdn.jsdelivr.net/npm/docsify@4.13.1/lib/themes/vue.css` | `sha384-jCK8...` |
| Sidebar-collapse CSS | `cdn.jsdelivr.net/npm/docsify-sidebar-collapse/dist/sidebar.min.css` | `sha384-ZGJu...` |

Bootstrap Icons are **self-hosted** under `pages/vendor/bootstrap-icons/` (CSS + font files) — no CDN/SRI needed. The `build-pages.sh` script copies `pages/vendor/` into `_site/vendor/`.

### Sidebar

The docsify-sidebar-collapse plugin makes the sidebar collapsible:

| Config | Value | Effect |
| :--- | :--- | :--- |
| `sidebarDisplayLevel` | `1` | Overview expanded; exam folders collapsed by default |
| `subMaxLevel` | `3` | Show headings up to `###` in sub-sidebars |
| `loadSidebar` | `true` | Load `_sidebar.md` for navigation |

### Search

The Docsify search plugin is configured with:

| Config | Value | Effect |
| :--- | :--- | :--- |
| `paths` | `'all'` | Index all sidebar-linked pages |
| `depth` | `3` | Index headings up to `###` |
| `hideOtherSidebarContent` | `true` | Hide right sidebar when searching |

A custom `searchFilenamePlugin` replaces search result titles with filenames (not page titles) via a MutationObserver on `.results-panel`.

### CSS overrides

Several CSS overrides in `pages/index.html` resolve Bootstrap + Docsify conflicts:

| Override | Purpose |
| :--- | :--- |
| `.sidebar-nav li.collapse { display: list-item !important; }` | Prevent Bootstrap `.collapse` from hiding sidebar folder labels (plugin uses `.collapse` on `<li>`, Bootstrap hides it) |
| `.markdown-section .card .card-body { display: flex; flex-direction: column; }` | Enable flexbox layout for card bodies |
| `.markdown-section .card .badge, .card .btn { align-self: flex-start; }` | Prevent badges/buttons from stretching full-width in flex-column card bodies |
| `.markdown-section .container { width: 100%; padding: 0; margin: 0; }` | Let Bootstrap containers work inside Docsify's `.markdown-section` |
| `.markdown-section a.btn { font-weight: 400; text-decoration: none; }` | Exclude buttons from Docsify link styling |

### Pages UI color scheme

| Element | Network+ | CISSP |
| :--- | :--- | :--- |
| Card border/header | `primary` (blue) | `success` (green) |
| Sessions badge | `primary` | `primary` |
| Diagrams badge | `info text-dark` | `info text-dark` |
| Question Bank badge | `warning text-dark` | `warning text-dark` |
| Reference PDFs badge | `secondary` | `secondary` |
| Browse button | `primary` | `success` |

Question-bank index cards use `primary` for domain-specific tests and `danger` for full practice tests.

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
