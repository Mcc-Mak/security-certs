# Changelog

All notable changes to this project are documented here. Versions follow semver.

## 3.2.3 (2026-10-06)

### Fixed
- self-host Bootstrap Icons to resolve SRI SonarCloud issue

## 3.2.2 (2026-10-06)

### Fixed
- remove broken SRI for Bootstrap Icons and resolve SonarCloud issues

## 3.2.1 (2026-10-06)

### Fixed
- resolve Bootstrap collapse conflict and improve color contrast

## 3.2.0 (2026-10-06)

### Added
- add Bootstrap styling, collapsible sidebar, and question-bank index

## 3.1.3 (2026-10-06)

### Other
- refactor: extract shared MCQ CSS/JS into external files to fix SonarQube duplication

## 3.1.2 (2026-10-06)

### Fixed
- resolve remaining SonarQube issues, add question-bank to sidebar

## 3.1.1 (2026-10-06)

### Fixed
- resolve all SonarQube code quality issues

## 3.1.0 (2026-10-06)

### Added
- full-text search across all 62 session notes

## 3.0.4 (2026-10-06)

### Fixed
- Docsify navigation, session links, wiki dead links

## 3.0.3 (2026-10-06)

### Other
- docs: add deployed Pages URL to root README

## 3.0.2 (2026-10-06)

### Fixed
- sonar_baseline scans as main, QG NONE is non-fatal

## 3.0.1 (2026-10-06)

### Fixed
- handle SonarCloud free-plan QG NONE status gracefully

## 3.0.0 (2026-10-06)

### Breaking
- Breaking change introduced in this release

### Added
- rebrand repo with 7-job CI/CD pipeline and separated deploy surfaces

### Other
- v2.0.0: unify note naming and fix promotion pipeline
- v1.0.0: initial release of consolidated security-certs repo
- Initial commit

## 2.0.0 (2026-09-30)

Every chapter and diagram file in both exams was renamed, and the promotion pipeline was
fixed. A **major** bump under the rule above, because the chapter files were restructured
outright.

### Changed

- **Chapter filenames unified across both exams.** All 62 files in
  `*/note/chapter/*.md` now follow one scheme:
  `session-{NN}-video-{NNN}-to-{NNN}_{content_description}.md` — 2-digit session,
  3-digit first and last video, lowercase `[a-z0-9_']` description. The two exams
  previously used deliberately *different* schemes (`NN_Session_N_Name.md` for CISSP,
  `Session NN (Vxx-Vyy).md` for Network+). For example
  `04_Session_4_Risk_Management.md` → `session-04-video-022-to-027_risk_management.md`.
- Video ranges were read from each file's own `## Video Vxx` headings rather than assumed,
  so they reflect what the chapter actually covers. Single-video sessions repeat the number,
  e.g. `session-34-video-260-to-260_...`.
- **`intermediate/` filenames normalized to lowercase kebab-case with singular nouns**,
  46 files, matching `[a-z0-9][a-z0-9-]*.(md|svg)`. E.g. `Diagrams (Part 1).md` →
  `diagram-part-1.md`, `Consolidated.md` → `consolidation.md`, `Session 02.md` →
  `session-02.md`.
- `comptia-network+/note/Diagram - Course (Session 1 to Session 28).md` moved into
  `note/chapter/intermediate/diagram-course.md`, so both exams now keep their
  supporting diagrams in the same place.
- **`AGENTS.md` / `README.md`** — documented the two filename rules, corrected the layout
  tree, and dropped the claim that the two exams' filenames are intentionally different.

### Added

- **`isc-cissp/question-bank/isc-cissp-official-practice-tests-4th-edition/`** — the
  practice-test material, previously untracked: 12 MCQ sets (8 domain, 4 practice test)
  and 16 archived result CSVs including the two summary rollups. Filenames normalized to
  `mcq-{domain|practice-test}-NN.html` and `{domain|practice-test}-NN-tNN.csv`.
  Each MCQ page hardcodes its own export filename (`domain1_results.csv`) and downloads
  to the browser, so `result/` is archived output rather than an input — renaming those
  CSVs does not affect the pages. There is still no Domain 8 result archived.

### Changed — directory names are now singular

Every directory in the study tree dropped its plural, so the layout now matches the
singular file naming:

| Was | Now |
| :--- | :--- |
| `notes/` | `note/` |
| `notes/chapters/` | `note/chapter/` |
| `notes/tips/` | `note/tip/` |
| `question-banks/` | `question-bank/` |
| `notes/chapters/intermediates/` | `note/chapter/intermediate/` |
| `…/results/` | `…/result/` |

The two exam folders (`isc-cissp/`, `comptia-network+/`) and
`isc-cissp-official-practice-tests-4th-edition/` keep their names — those are product and
book titles, not descriptive categories. `.github/` is fixed by GitHub and is never renamed.

### Fixed

- **`.github/workflows/promote.yml` could never promote anything.** It ran
  `git push origin "dev-001:dev" --ff-only`, but `git push` has no `--ff-only` option, so
  every run died with `error: unknown option 'ff-only'` and nothing ever reached `dev`.
  Replaced with an explicit `git merge-base --is-ancestor` check followed by a plain,
  non-forced push — divergence still fails loudly, but with a readable error naming the
  branches.
- **Job summaries were always empty.** Both jobs diffed against `origin/<branch>` *after*
  the push had already advanced that ref, so `Summarize` had nothing left to report. The
  pre-push base commit is now captured to `$GITHUB_ENV` and used as the diff base.

### Notes

- No file *contents* changed — every one of the 136 renames is byte-identical, recorded by
  git as a 100% rename. The only edited files are the three docs and the workflow.
- Nothing in the repo linked to a chapter or diagram file by name, so no link broke.
- Historical 1.0.0 entries below still refer to directories by their old plural names in
  the prose where it describes the shape at that release; the 2.0.0 table above is
  authoritative for current paths.
- There is still no archived result for Domain 8; only `mcq-domain-08.html` exists.

## 1.0.0 (2026-09-30)

First release of the consolidated repository. Unifies two previously separate repos and
adds the structure and workflow that did not previously exist.

### Added

- **`isc-cissp/note/chapter/`** — 34 session summaries from the 2024 CISSP study guide.
- **`isc-cissp/note/chapter/intermediate/`** — three independent mermaid diagram sets
  (per-session `Session NN.md` for sessions 02–33, hand-curated `Diagrams (Part 1).md` /
  `Diagrams (Part 2).md` covering 2–19 and 21–34, and `Consolidated.md`), the two
  `Appendix` notes and their diagrams, and a six-layer SVG overview set.
- **`comptia-network+/note/chapter/`** — 28 session summaries for Network+ N10-009.
- **`*/note/tip/`** — vendor reference PDFs: the CISSP masterpiece overview, and the
  Network+ study guide, exam objectives, and study plan.
- **`question-bank/`** — placeholder for future practice material, in both exams.
- **`AGENTS.md`** — agent-facing notes: change workflow, the diagram-set trap, content
  conventions, the `tip/` read-only rule, and the PowerShell UTF-8 gotcha.
- **`.github/workflows/promote.yml`** — promotion pipeline. `dev-001` → `dev` is
  automatic; `dev` → `main` is gated on approval of the `main` environment. Divergence is
  meant to fail loudly rather than merge, so published branches are never clobbered.
  (How that check is actually implemented was corrected in 2.0.0 — as shipped here the
  fast-forward guard did not work at all.)
- **Change workflow** — four-step sequence (`README.md` → `CHANGELOG.md` → commit → push
  to `dev-001`) with `major.minor.patch` versioning.

### Changed

- Consolidated `Mcc-Mak/isc-cissp-summary` and `Mcc-Mak/comptia-network--summary` into a
  single repository under a `security-certs` umbrella. The pre-consolidation history is
  **not** carried over; both source repos remain available on GitHub.
- Reorganized each exam folder to a common `note/{chapter,tip}/` + `question-bank/`
  shape.
- Replaced the one-line root `README.md` with a real index: exam table, folder shapes,
  conventions, and the contribution workflow.

### Notes

- Network+ N10-009 is a **superseded** exam version. The notes are kept for reference.
- The `tip/` PDFs and `intermediate/` SVGs are committed deliberately and must not be
  edited or bulk-read.
- The three CISSP diagram sets are intentionally divergent and have uneven coverage:
  Session 20 exists only in the per-session set, Session 34 only in the Part 2 set, and
  Session 01 has no diagram. This is pre-existing, not a bug to be auto-corrected.
