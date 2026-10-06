# Requirements Traceability Matrix (RTM)

Maps each requirement from the [SRS](SRS.md) to the CI/CD job or script that verifies it.

| Requirement | Description | Verified by |
| :--- | :--- | :--- |
| REQ-01 | Chapter filename convention | `validate-notes.sh` (fast_checks job) |
| REQ-02 | Intermediate filename convention | `validate-notes.sh` (fast_checks job) |
| REQ-03 | Singular directory names | `validate-notes.sh` (fast_checks job) |
| REQ-04 | `tip/` read-only | Not automated — enforced by AGENTS.md convention |
| REQ-05 | UTF-8 without BOM | `validate-notes.sh` (fast_checks job) |
| REQ-06 | Mermaid fence balance | `validate-notes.sh` (fast_checks job) |
| REQ-07 | Auto-generate CHANGELOG | `release` job |
| REQ-08 | Validate notes before promotion | `fast_checks` job |
| REQ-09 | SonarQube Cloud quality gate | `security_checks` job (when `SONAR_TOKEN` configured) |
| REQ-10 | Promote dev-001 → dev → main | `promote` job |
| REQ-11 | Deploy Docsify site to Pages | `pages` job + `build-pages.sh` |
| REQ-12 | Sync engineering docs to GitHub Wiki | `wiki` job + `sync-wiki.sh` |
| REQ-13 | Mermaid rendering on Pages | `pages/index.html` (mermaid CDN plugin) |
| REQ-14 | Pages TOCTREE landing page | `pages/README.md` + `build-pages.sh` |
| REQ-15 | Wiki is docbase-only | `sync-wiki.sh` (no codebase/ content) |
| REQ-16 | Sidebar absolute links | `pages/_sidebar.md` (absolute `/`-prefixed paths) |
| REQ-17 | Exam README session links | `codebase/{exam}/README.md` (clickable session links) |
| REQ-18 | Wiki dead-link transform | `sync-wiki.sh` (sed transforms in Home.md generation) |
| REQ-19 | Search indexes all sessions | `pages/index.html` (`paths: 'all'`) + `build-pages.sh` (auto-generated sidebar) |
| NFR-01 | Single workflow run | `paths-ignore: CHANGELOG.md` + `GITHUB_TOKEN` push semantics |
| NFR-02 | Wiki non-blocking | `wiki` job exits 0 when wiki repo not found |
| NFR-03 | No cascading triggers | `GITHUB_TOKEN` pushes do not re-trigger workflows |
| NFR-04 | POSIX-bash scripts | `ubuntu-latest` runner with `set -euo pipefail` |
