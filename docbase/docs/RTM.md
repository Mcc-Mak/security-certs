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
| REQ-20 | Bootstrap 5.3 styling | `pages/index.html` (Bootstrap CDN + SRI, loaded before Docsify theme) |
| REQ-21 | Collapsible sidebar | `pages/index.html` (docsify-sidebar-collapse plugin, `sidebarDisplayLevel: 1`) |
| REQ-22 | Landing page Bootstrap cards | `pages/README.md` (Bootstrap card grid with exam identity colors + category badges) |
| REQ-23 | Question-bank index cards | `codebase/isc-cissp/question-bank/README.md` (Bootstrap cards: `primary` for domains, `danger` for practice tests) |
| REQ-24 | Self-hosted Bootstrap Icons | `pages/vendor/bootstrap-icons/` (no CDN dependency for icons) |
| REQ-25 | Search filename plugin | `pages/index.html` (`searchFilenamePlugin` — MutationObserver replaces search result titles with filenames) |
| REQ-26 | CSS collapse override | `pages/index.html` (`.sidebar-nav li.collapse { display: list-item !important; }`) |
| REQ-27 | Card flexbox alignment | `pages/index.html` (`.card .badge, .card .btn { align-self: flex-start; }`) |
| REQ-28 | Diagrams section in READMEs | `codebase/{exam}/README.md` (Diagrams section with links to intermediate/ diagrams) |
| REQ-29 | Reference PDFs section | `codebase/{exam}/README.md` (Reference PDFs section linking to `note/tip/`) |
| REQ-30 | Sidebar diagrams/reference links | `build-pages.sh` (auto-generates `?id=diagrams` and `?id=reference-pdfs` sidebar links) |
| REQ-31 | Raw HTML site-root-relative paths | `codebase/{exam}/README.md` (raw `<a>` tags use `isc-cissp/note/...` paths, not `#/` hashes) |
| REQ-32 | GitHub milestones | Not automated — managed via `gh` CLI per AGENTS.md workflow |
| REQ-33 | GitHub project board | Not automated — managed via `gh` CLI / GraphQL per AGENTS.md workflow |
| REQ-34 | Parent/child issue hierarchy | Not automated — managed via GraphQL `addSubIssue` per AGENTS.md workflow |
| NFR-01 | Single workflow run | `paths-ignore: CHANGELOG.md` + `GITHUB_TOKEN` push semantics |
| NFR-02 | Wiki non-blocking | `wiki` job exits 0 when wiki repo not found |
| NFR-03 | No cascading triggers | `GITHUB_TOKEN` pushes do not re-trigger workflows |
| NFR-04 | POSIX-bash scripts | `ubuntu-latest` runner with `set -euo pipefail` |
