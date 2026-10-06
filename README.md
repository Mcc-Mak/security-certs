# Security Certs

> **Live site:** https://mcc-mak.github.io/security-certs/

Study notes for two IT security certifications, deployed as a Docsify site (GitHub Pages) and a GitHub Wiki via a seven-job CI/CD pipeline.

## Exams

| Exam | Sessions | Chapters | Diagrams | Question Bank |
| :--- | :--- | :--- | :--- | :--- |
| [CompTIA Network+ (N10-009)](codebase/comptia-network+/README.md) | 28 | 28 | 1 course diagram | Placeholder |
| [ISC CISSP](codebase/isc-cissp/README.md) | 34 | 34 | 39 intermediate + 6 SVGs | 12 MCQ sets + 16 result CSVs |

## Repository structure

```
codebase/                    Study-notes content (the actual notes)
  comptia-network+/          28 Network+ session summaries
  isc-cissp/                 34 CISSP session summaries + diagrams
docbase/                     Engineering documentation (SRS, Architecture, etc.)
pages/                       Docsify shell (index.html, README.md, .nojekyll)
scripts/                     CI/CD helper scripts (validate, build, sync)
.github/workflows/ci-cd.yml  Seven-job pipeline (release → checks → promote → deploy)
```

## Content conventions

- **Chapter files**: `session-{NN}-video-{NNN}-to-{NNN}_{description}.md`
- **Intermediate files**: lowercase kebab-case (e.g. `diagram-part-1.md`, `session-02.md`)
- **Directories**: singular nouns (`note/`, `chapter/`, `tip/`, `intermediate/`)
- **Diagrams**: Mermaid fenced code blocks (`graph TD`, `mindmap`, `sequenceDiagram`, etc.)
- **Encoding**: UTF-8 without BOM

See [AGENTS.md](AGENTS.md) for the full convention guide.

## CI/CD pipeline

```
dev-001 push
  → release (auto CHANGELOG from Conventional Commits)
  → fast_checks (validate-notes.sh — filenames, fences, encoding)
  → security_checks (SonarQube Cloud, optional)
  → promote (dev-001 → dev → main, direct push)
  → pages + wiki + sonar_baseline (parallel, from main)
```

All jobs chain in a single workflow run. See [docbase/docs/CICD-Pipeline.md](docbase/docs/CICD-Pipeline.md) for details.

## Engineering documentation

Full engineering docs (SRS, Architecture, CI/CD Pipeline, etc.) live in [`docbase/`](docbase/TOCTREE.md) and are published to the [GitHub Wiki](https://github.com/Mcc-Mak/security-certs/wiki).

## Getting started

```bash
git clone https://github.com/Mcc-Mak/security-certs.git
cd security-certs
git checkout dev-001
./scripts/validate-notes.sh    # verify conventions
```

See [docbase/docs/QuickStart.md](docbase/docs/QuickStart.md) for local preview and editing instructions.

## Versioning

This is a notes repository, so versions track **content** changes:

| Bump | When |
| :--- | :--- |
| major | Content removed, restructured, or renamed (breaks links) |
| minor | New sessions, notes, diagrams, or question banks added |
| patch | Corrections to existing content |

The `release` CI job auto-generates CHANGELOG entries from [Conventional Commits](https://www.conventionalcommits.org/).
