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
  README.md           overview / session index
  notes/
    chapters/         the actual study material, one file per session
    tips/             vendor PDFs — study guides, exam objectives, study plans
  question-banks/     practice material (CISSP only, currently a placeholder)
```

- **`notes/chapters/`** — the session summaries. This is what you read and what you edit.
- **`notes/tips/`** — multi-megabyte vendor PDFs. Read-only reference, never edited.
  Committed deliberately; there is no `.gitignore`.
- **`question-banks/`** — reserved for real exam material. Currently a placeholder in
  both exams.
- CISSP additionally has `notes/chapters/intermediates/` — mermaid diagram sets and a
  hand-drawn SVG overview, supporting the 34 chapters.

## Conventions

- Filenames encode the session: `04_Session_4_Risk_Management.md` (CISSP) and
  `Session 09 (V68-V79).md` (Network+). The two schemes are intentionally **not**
  normalized — match the local file.
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
