# Cross-Reference Matrix (CRM)

Maps requirements → documents → artifacts. Keep updated when requirements or docs change.

## Requirements to documents

| Requirement | SRS | Architecture | QuickStart | Configurations | CICD-Pipeline | RTM |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| REQ-01 Chapter filenames | §3.1 | — | §Edit a note | — | §2 fast_checks | ✓ |
| REQ-02 Intermediate filenames | §3.1 | — | §Edit a note | — | §2 fast_checks | ✓ |
| REQ-03 Singular directories | §3.1 | Overview | — | — | §2 fast_checks | ✓ |
| REQ-04 tip/ read-only | §3.1 | — | — | — | — | ✓ |
| REQ-05 UTF-8 no BOM | §3.1 | — | — | — | §2 fast_checks | ✓ |
| REQ-06 Mermaid fence balance | §3.1 | — | — | — | §2 fast_checks | ✓ |
| REQ-07 Auto CHANGELOG | §3.2 | Data flow | — | §Conventional Commits | §2 release | ✓ |
| REQ-08 Validate notes | §3.2 | — | §Edit a note | — | §2 fast_checks | ✓ |
| REQ-09 Sonar gate | §3.2 | — | — | §Secrets | §2 security_checks | ✓ |
| REQ-10 Promote | §3.2 | Data flow | — | — | §2 promote | ✓ |
| REQ-11 Docsify on Pages | §3.2 | §Pages | §Preview | §Pages | §2 pages | ✓ |
| REQ-12 Wiki sync (docbase) | §3.2 | §Wiki | — | §Wiki | §2 wiki | ✓ |
| REQ-13 Mermaid on Pages | §3.3 | §Pages | — | — | §2 pages | ✓ |
| REQ-14 Pages TOCTREE | §3.3 | §Pages | — | — | §2 pages | ✓ |
| REQ-15 Wiki docbase-only | §3.3 | §Wiki | — | — | §2 wiki | ✓ |
| REQ-16 Sidebar absolute links | §3.3 | §Pages | — | — | §2 pages | ✓ |
| REQ-17 Exam README session links | §3.3 | §Pages | — | — | §2 pages | ✓ |
| REQ-18 Wiki dead-link transform | §3.3 | §Wiki | — | — | §2 wiki | ✓ |
| REQ-19 Search indexes all sessions | §3.3 | §Pages | — | — | §2 pages | ✓ |
| REQ-20 Bootstrap 5.3 styling | §3.4 | §Pages | — | §Bootstrap | — | ✓ |
| REQ-21 Collapsible sidebar | §3.4 | §Pages | — | §Sidebar | — | ✓ |
| REQ-22 Landing page Bootstrap cards | §3.4 | §Pages | — | §Pages UI | — | ✓ |
| REQ-23 Question-bank index cards | §3.4 | §Pages | — | §Pages UI | — | ✓ |
| REQ-24 Self-hosted Bootstrap Icons | §3.4 | §Pages | — | §Bootstrap | — | ✓ |
| REQ-25 Search filename plugin | §3.4 | §Pages | — | §Search | — | ✓ |
| REQ-26 CSS collapse override | §3.4 | §Pages | — | §CSS overrides | — | ✓ |
| REQ-27 Card flexbox alignment | §3.4 | §Pages | — | §CSS overrides | — | ✓ |
| REQ-28 Diagrams section in READMEs | §3.5 | §Pages | — | — | — | ✓ |
| REQ-29 Reference PDFs section | §3.5 | §Pages | — | — | — | ✓ |
| REQ-30 Sidebar diagrams/reference links | §3.5 | §Pages | — | §Sidebar | — | ✓ |
| REQ-31 Raw HTML site-root-relative paths | §3.5 | §Pages | — | §Pages UI | — | ✓ |
| REQ-32 GitHub milestones | §3.6 | — | — | — | — | ✓ |
| REQ-33 GitHub project board | §3.6 | — | — | — | — | ✓ |
| REQ-34 Parent/child issue hierarchy | §3.6 | — | — | — | — | ✓ |

## Documents to artifacts

| Document | File |
| :--- | :--- |
| SRS | `docbase/docs/SRS.md` |
| Architecture | `docbase/docs/Architecture.md` |
| QuickStart | `docbase/docs/QuickStart.md` |
| Configurations | `docbase/docs/Configurations.md` |
| CICD-Pipeline | `docbase/docs/CICD-Pipeline.md` |
| RTM | `docbase/docs/RTM.md` |
| CRM | `docbase/docs/CRM.md` |
| TOCTREE | `docbase/TOCTREE.md` |
| AGENTS.md | `AGENTS.md` |
| CI/CD workflow | `.github/workflows/ci-cd.yml` |
| validate-notes.sh | `scripts/validate-notes.sh` |
| build-pages.sh | `scripts/build-pages.sh` |
| sync-wiki.sh | `scripts/sync-wiki.sh` |
| configure-secrets.sh | `scripts/configure-secrets.sh` |
| Docsify shell | `pages/index.html`, `pages/README.md`, `pages/_sidebar.md`, `pages/.nojekyll` |
