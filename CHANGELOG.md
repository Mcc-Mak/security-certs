# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## How versions are decided here

This is a notes repository, so the version tracks **content**, not software APIs.

| Bump | When |
| :--- | :--- |
| `major` | Content removed, restructured, or renamed in a way that breaks existing links |
| `minor` | New sessions, notes, diagrams, or question banks added |
| `patch` | Corrections to existing content |

Every change bumps the version, adds an entry here, and updates `README.md` — in that
order. See [`AGENTS.md`](AGENTS.md#change-workflow).

---

## [1.0.0] - 2026-09-30

First release of the consolidated repository. Unifies two previously separate repos and
adds the structure and workflow that did not previously exist.

### Added

- **`isc-cissp/notes/chapters/`** — 34 session summaries from the 2024 CISSP study guide.
- **`isc-cissp/notes/chapters/intermediates/`** — three independent mermaid diagram sets
  (per-session `Session NN.md` for sessions 02–33, hand-curated `Diagrams (Part 1).md` /
  `Diagrams (Part 2).md` covering 2–19 and 21–34, and `Consolidated.md`), the two
  `Appendix` notes and their diagrams, and a six-layer SVG overview set.
- **`comptia-network+/notes/chapters/`** — 28 session summaries for Network+ N10-009.
- **`*/notes/tips/`** — vendor reference PDFs: the CISSP masterpiece overview, and the
  Network+ study guide, exam objectives, and study plan.
- **`question-banks/`** — placeholder for future practice material, in both exams.
- **`AGENTS.md`** — agent-facing notes: change workflow, the diagram-set trap, content
  conventions, the `tips/` read-only rule, and the PowerShell UTF-8 gotcha.
- **`.github/workflows/promote.yml`** — promotion pipeline. `dev-001` → `dev` is
  automatic; `dev` → `main` is gated on approval of the `main` environment. Merges are
  `--ff-only`, so divergence fails loudly instead of merging.
- **Change workflow** — four-step sequence (`README.md` → `CHANGELOG.md` → commit → push
  to `dev-001`) with `major.minor.patch` versioning.

### Changed

- Consolidated `Mcc-Mak/isc-cissp-summary` and `Mcc-Mak/comptia-network--summary` into a
  single repository under a `security-certs` umbrella. The pre-consolidation history is
  **not** carried over; both source repos remain available on GitHub.
- Reorganized each exam folder to a common `notes/{chapters,tips}/` + `question-banks/`
  shape.
- Replaced the one-line root `README.md` with a real index: exam table, folder shapes,
  conventions, and the contribution workflow.

### Notes

- Network+ N10-009 is a **superseded** exam version. The notes are kept for reference.
- The `tips/` PDFs and `intermediates/` SVGs are committed deliberately and must not be
  edited or bulk-read.
- The three CISSP diagram sets are intentionally divergent and have uneven coverage:
  Session 20 exists only in the per-session set, Session 34 only in the Part 2 set, and
  Session 01 has no diagram. This is pre-existing, not a bug to be auto-corrected.

[1.0.0]: https://github.com/Mcc-Mak/security-certs/releases/tag/v1.0.0
