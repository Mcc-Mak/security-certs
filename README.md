# security-certs

Personal study notes for security certification exams.

> **This repo is mostly prose.** It's Markdown notes and diagrams, not software. There is
> no build, no test suite, and no package manifest. "Correct" means the content is accurate
> and the mermaid diagrams parse — not that a test suite passes.

## What's here

| Exam | Path | Chapters | Status |
| :--- | :--- | :--- | :--- |
| **CISSP** | [`isc-cissp/`](isc-cissp/) | 34 | 2024 study guide |
| **CompTIA Network+** | [`comptia-network+/`](comptia-network+/) | 28 | N10-009, superseded exam |

Each exam folder has a similar shape:

```
<exam>/
  README.md             overview / session index
  note/
    chapter/            the actual study material, one file per session
      intermediate/     cross-session mermaid diagram sets
    tip/                vendor PDFs — study guides, exam objectives, study plans
  question-bank/        practice material
```

- **`note/chapter/`** — the session summaries. This is what you read and what you edit.
- **`note/chapter/intermediate/`** — supporting mermaid diagram sets and, for CISSP, a
  hand-drawn SVG overview.
- **`note/tip/`** — multi-megabyte vendor PDFs. Read-only reference, never edited.
  Committed deliberately; there is no `.gitignore`.
- **`question-bank/`** — real exam material only. CISSP holds the official practice-test
  MCQ sets and their archived result CSVs; Network+ is still a placeholder.
- **Directory names are singular** — `note/`, `chapter/`, `intermediate/`, `tip/`,
  `question-bank/`. The exam folders and the practice-test book folder keep their real
  names.

## Conventions

- Every `note/chapter/*.md` filename follows one scheme, in both exams:
  `session-{NN}-video-{NNN}-to-{NNN}_{content_description}.md` — 2-digit session,
  3-digit first/last video, lowercase description. For example
  `session-04-video-022-to-027_risk_management.md` and
  `session-09-video-068-to-079_ip_addressing.md`. A single-video session repeats the number.
- Files in `intermediate/` are cross-session diagram sets, named `[a-z0-9][a-z0-9-]*`
  with **singular** nouns: `session-02.md`, `diagram-part-1.md`, `consolidation.md`.
- Question-bank files are `mcq-{domain|practice-test}-NN.html` and
  `{domain|practice-test}-NN-tNN.csv`, with `summary-*.csv` for the rollups.
- Diagrams are ```mermaid fenced blocks. Nothing renders or validates them here, so check
  your syntax.
- `comptia-network+/` contains a literal `+`. **Quote every path** in shell commands.

Working in this repo? Read [`AGENTS.md`](AGENTS.md) first — it documents the diagram-set
trap, the encoding gotcha, and the required change workflow.

## Contributing

Every change follows the same four steps, in order. See
[AGENTS.md](AGENTS.md#change-workflow) for the full version and for the
`dev-001` → `dev` → `main` promotion pipeline.

1. Update `README.md`
2. Update `CHANGELOG.md`, bumping the version as `major.minor.patch`
3. Commit with a real subject and body, version in the subject
4. Push to `dev-001`

## License

[MIT](LICENSE) © 2026 Mcc-Mak
