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

## 4. Non-functional requirements

| ID | Requirement |
| :--- | :--- |
| NFR-01 | Pipeline completes in a single workflow run (no cascading triggers) |
| NFR-02 | Wiki sync is non-blocking until the wiki repo is initialized via the web UI |
| NFR-03 | `GITHUB_TOKEN` pushes to `dev`/`main` do not re-trigger the workflow |
| NFR-04 | All scripts are POSIX-bash compatible and run on `ubuntu-latest` |
