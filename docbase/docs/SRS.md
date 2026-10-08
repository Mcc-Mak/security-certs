# Software Requirements Specification (SRS)

## 1. Purpose

The security-certs repository provides a structured, version-controlled home for study notes covering two IT security certifications: **CompTIA Network+ (N10-009)** and **ISC CISSP**. It deploys two browsable documentation surfaces — a Docsify site (GitHub Pages) and a GitHub Wiki — from the same markdown source.

## 2. Scope

The system manages markdown-formatted study notes, validates their structure, and publishes them to two surfaces. It does not provide interactive features (quizzing, progress tracking) — that is out of scope.

## 3. Requirements

### 3.1 Content management

| ID | Requirement |
| :--- | :--- |
| REQ-01 | Store chapter notes as `session-{NN}-video-{NNN}-to-{NNN}_{description}.md` under `codebase/{exam}/note/chapter/` |
| REQ-02 | Store intermediate diagrams as lowercase kebab-case `[a-z0-9][a-z0-9-]*.(md\|svg)` under `note/chapter/intermediate/` |
| REQ-03 | Use singular directory names throughout the study tree (`note/`, `chapter/`, `tip/`, `intermediate/`, `result/`) |
| REQ-04 | Keep `note/tip/` PDFs read-only — never edit, rename, or bulk-read |
| REQ-05 | Encode all markdown as UTF-8 without BOM |
| REQ-06 | Balance every mermaid code fence (even count of ``` markers) |

### 3.2 CI/CD pipeline

| ID | Requirement |
| :--- | :--- |
| REQ-07 | Auto-generate CHANGELOG entries from Conventional Commits on every `dev-001` push |
| REQ-08 | Validate note conventions (filenames, directories, fences, encoding) before promotion |
| REQ-09 | Run SonarQube Cloud quality gate when `SONAR_TOKEN` is configured; skip with notice when absent |
| REQ-10 | Promote `dev-001` HEAD to `dev` and `main` via direct `git push` (no PRs) |
| REQ-11 | Deploy a Docsify site to GitHub Pages (no build step, client-side rendered) |
| REQ-12 | Sync engineering docs (docbase/) to the GitHub Wiki |

### 3.3 Documentation surfaces

| ID | Requirement |
| :--- | :--- |
| REQ-13 | Pages site must render mermaid diagrams via a client-side plugin |
| REQ-14 | Pages landing page must act as a TOCTREE: exams → {note, question-bank} |
| REQ-15 | Wiki must publish docbase/ engineering docs only (no study notes) |
| REQ-16 | Pages sidebar links must use absolute paths (`/`-prefixed) so navigation works from any page depth with `relativePath: true` |
| REQ-17 | Pages exam READMEs must link to individual session note files for in-site navigation |
| REQ-18 | Wiki Home.md must transform dead links: `codebase/` → Pages site URLs, `docbase/docs/X.md` → wiki page `X`, `AGENTS.md` → GitHub source URL |
| REQ-19 | Pages search plugin must index all session pages (`paths: 'all'`); sidebar must list all chapter files so search has full coverage |

### 3.4 Pages UI

| ID | Requirement |
| :--- | :--- |
| REQ-20 | Pages site must use Bootstrap 5.3 for styling, loaded before the Docsify theme so Docsify overrides conflicts |
| REQ-21 | Pages sidebar must be collapsible (docsify-sidebar-collapse plugin) with `sidebarDisplayLevel: 1` (Overview expanded, exam folders collapsed by default) |
| REQ-22 | Pages landing page must use Bootstrap cards with exam identity colors (`primary` for Network+, `success` for CISSP) and category badges (`primary`=sessions, `info`=diagrams, `warning`=question bank, `secondary`=reference PDFs) |
| REQ-23 | Pages question-bank index must use Bootstrap cards with category color scheme (`primary` for domain-specific, `danger` for full practice tests) |
| REQ-24 | Bootstrap Icons must be self-hosted under `pages/vendor/bootstrap-icons/` (no CDN/SRI dependency) |
| REQ-25 | Search result titles must display filenames (not page titles) via a custom Docsify plugin (`searchFilenamePlugin`) |
| REQ-26 | CSS must override Bootstrap `.collapse` to prevent sidebar-collapse plugin conflicts (`.sidebar-nav li.collapse { display: list-item !important; }`) |
| REQ-27 | Card badges and buttons must use `align-self: flex-start` to prevent stretching in flex-column card-body layout |

### 3.5 Exam README content

| ID | Requirement |
| :--- | :--- |
| REQ-28 | Exam READMEs must include a Diagrams section linking to intermediate/ diagrams (consolidated sets, per-session, appendices, SVG overviews) |
| REQ-29 | Exam READMEs must include a Reference PDFs section linking to `note/tip/` PDFs |
| REQ-30 | Sidebar must include links to Diagrams and Reference PDFs sections via `?id=` anchors |
| REQ-31 | Raw HTML `<a>` tags in exam READMEs must use site-root-relative paths (not Docsify `#/` hashes) for `relativePath: true` compatibility |

### 3.6 Project management

| ID | Requirement |
| :--- | :--- |
| REQ-32 | Track version history via GitHub milestones — one per release, closed when the release ships |
| REQ-33 | Maintain a GitHub project board linked to the repo with views: Backlog (table), Board (Kanban by Status), By Milestone (table), Completed (filtered to closed issues) |
| REQ-34 | Use parent (epic) issues per milestone, with sub-issues linked via `addSubIssue` for hierarchical tracking |

## 4. Non-functional requirements

| ID | Requirement |
| :--- | :--- |
| NFR-01 | Pipeline completes in a single workflow run (no cascading triggers) |
| NFR-02 | Wiki sync is non-blocking until the wiki repo is initialized via the web UI |
| NFR-03 | `GITHUB_TOKEN` pushes to `dev`/`main` do not re-trigger the workflow |
| NFR-04 | All scripts are POSIX-bash compatible and run on `ubuntu-latest` |
