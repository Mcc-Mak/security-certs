# AGENTS.md

Personal study notes for security certification exams. Mostly prose and diagrams — no
build, no lint, no test suite, no package manifest. "Verification" means reading your own
diff and checking your mermaid parses.

## Change workflow

**Every change follows these four steps, in order. No exceptions.**

1. **Update `README.md`** first — the content change and its documentation land together.
2. **Update `CHANGELOG.md`**, bumping the version as `major.minor.patch`:
   - `major` — content removed, restructured, or renamed in a way that breaks existing links
   - `minor` — new sessions, notes, diagrams, or question banks added
   - `patch` — corrections to existing content
3. **Commit**, with the version in the subject. Write a real subject and body:
   - Subject: imperative, under ~72 chars, states *what* changed.
   - Body: **why** it changed and anything non-obvious. Not a restatement of the diff.
   - Format: `v1.2.0: add Network+ sessions 22-24`
4. **Push to `dev-001`.** Never commit or push directly to `dev` or `main`.

### Promotion pipeline

```
dev-001  ──merge──▶  dev  ──merge──▶  main
```

A push to `dev-001` flows `dev-001` → `dev` → `main` in that order. `dev` is the
integration branch, `main` is stable. **Never skip or reorder a stage** — `dev-001` is
never merged straight into `main`, and `dev` is never merged into `dev-001`.

Promotion runs automatically via `.github/workflows/promote.yml` on every push to
`dev-001`:

- `dev-001` → `dev` is automatic.
- `dev` → `main` requires approving the `main` environment. **If that protection is not
  configured** (Settings → Environments → `main` → Required reviewers), `main` receives
  commits with no human in the loop. Verify it before the first real promotion.

Do not force-push, rebase, or amend published branches, and do not delete `dev` or `main`.
If the branches diverge, `promote.yml` uses `--ff-only` and fails rather than merging —
resolve that by hand, don't weaken the workflow.

## Layout

One git repo rooted here. There are **no nested repos** — don't create any.

```
security-certs/
  isc-cissp/
    README.md
    question-banks/                 reserved, empty (.gitkeep)
    notes/
      chapters/                     34 session summaries
        intermediates/              39 mermaid files + 6 SVGs
      tips/                         1 PDF
  comptia-network+/
    README.md                       session → summary index
    question-banks/                 reserved, empty (.gitkeep)
    notes/
      chapters/                     28 session summaries
      tips/                         3 PDFs
      Diagram - Course (...).md     course-wide mermaid diagram
```

- `chapters/` = the authored study material, one file per session. This is what you edit.
- `intermediates/` = supporting diagrams for the CISSP chapters. Read-only in practice.
- `tips/` = vendor PDFs (study guides, exam objectives, study plans). Reference material;
  don't edit, and don't reproduce their contents in the notes.
- `question-banks/` is a placeholder, not an oversight. Don't fill it with generated
  questions; only add real exam material.
- This repo consolidates two older GitHub repos, `Mcc-Mak/isc-cissp-summary` and
  `Mcc-Mak/comptia-network--summary`. Their pre-consolidation history is **not** here —
  clone them separately if you ever need it.

## The two note sets are deliberately inconsistent

Don't normalize them against each other. Match the local file.

| | `isc-cissp/` | `comptia-network+/` |
| :--- | :--- | :--- |
| Exam | CISSP (2024) | Network+ N10-009 (superseded) |
| Chapters | 34 | 28 |
| Filename | `04_Session_4_Risk_Management.md` | `Session 09 (V68-V79).md` |
| Heading | `## Video V22: ...` / `### Video V22 (Outline)` | `# Session 9: ...` / `## V68 - ...` |
| Diagrams | `intermediates/` (three sets) + SVG | one course-wide file |
| Index | `README.md` is a title line only | `README.md` is a real session→summary table |

- **In `comptia-network+/`, the video range in the filename is authoritative** for what a
  chapter covers. The `README.md` table is lossy prose and drifts from the files.
- `isc-cissp/README.md` is a title, not an index. Don't try to keep it in sync.
- Note `comptia-network+` contains a literal `+`. Quote every path in shell commands.

## Trap: `isc-cissp/notes/chapters/intermediates/` holds three diagram sets

Editing one does **not** update the others. This is the easiest mistake to make here.

1. `Session NN.md` — per-session, one block per video. Covers Sessions **02–33** only
   (no `01`, no `34`). Headed `### Video Vxx`. 4,429 lines for 02–17 alone.
2. `Diagrams (Part 1).md` (sessions 2–17) and `Diagrams (Part 2).md` (18, 19, 21–34) —
   hand-curated, coarser, headed `## Session N: ...`. **Not** generated from, and not
   concatenations of, the `Session NN.md` files: Part 1 is 1,082 lines against 4,429 for
   `Session 02`–`17` combined, and **zero** `Session NN.md` files appear verbatim in it.
   Part 2 also **skips Session 20**, which does have a `Session 20.md`.
3. `Consolidated.md` — one large cross-session graph.

Also in that folder: `Appendix 1.md`, `Appendix 2.md`, `Diagram - Appendix 1.md`,
`Diagram - Appendix 2.md`, and the six `NN - <layer name>.svg` overview files (hand-drawn,
**not** mermaid).

So Session 20 has a diagram in set 1 but not set 2; Session 34 exists only in set 2;
Session 01 has no diagram anywhere. Coverage is genuinely uneven — don't assume the sets
should match, and don't "fix" the gaps without being asked.

Decide which set you are changing before you write. If a diagram belongs in more than
one, you have to edit each file separately.

## Diagrams

All diagrams are ```mermaid fenced blocks (452 in `isc-cissp`, 114 in `comptia-network+`).
Nothing renders or validates them here, so correctness is on you. Types in use:

`graph` 247/66, `flowchart` 151/24, `mindmap` 49/11, `sequenceDiagram` 2/7, `pie` 1/3,
`timeline` 2/2, plus a single `gantt` in `comptia-network+` (the study-plan chart).

Match the mermaid type already used in the file you are editing. Tables use a
`| :--- | :--- |` alignment row.

## `tips/` — do not read wholesale

Vendor PDFs: the CISSP masterpiece overview plus the Network+ study guide, exam
objectives, and study plan (the study guide alone is 3.9 MB). Never extract or grep
these in full, it will flood your context. There is **no `.gitignore`** and they are
committed on purpose — don't add ignores and don't "clean them up".

Filenames throughout contain spaces and parentheses. Always quote paths.

## Windows encoding gotcha (verified)

All Markdown here is **valid UTF-8** (confirmed with a strict decoder) and contains
U+2013 `–`, U+2192 `→`, U+00D7 `×`.

PowerShell 5.1's `Get-Content` and `Select-String` default to ANSI and render those as
mojibake (`�`) in your terminal. The file is fine — the display is not.

- Always pass `-Encoding UTF8` when reading these files.
- **Do not "repair" the mojibake you see.** It is not in the file, and a blind
  find-and-replace will corrupt the notes for real.
