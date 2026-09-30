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
If the branches diverge, `promote.yml` checks ancestry with `git merge-base --is-ancestor`
and fails with an explicit error rather than merging — resolve that by hand, don't weaken
the workflow. Note `git push` has no `--ff-only` flag; a plain, non-forced push already
refuses to clobber a diverged branch, and the ancestry check just makes the failure legible.

## Layout

One git repo rooted here. There are **no nested repos** — don't create any.

```
security-certs/
  isc-cissp/
    README.md
    question-bank/
      .gitkeep
      isc-cissp-official-practice-tests-4th-edition/   book title, left as-is
        mcq/                       8 domain + 4 practice-test MCQ sets
        result/                    14 archived result CSVs + 2 summaries
    note/
      chapter/                     34 session summaries
        intermediate/              39 mermaid files + 6 SVGs
      tip/                         1 PDF
  comptia-network+/
    README.md                       session → summary index
    question-bank/                 reserved, empty (.gitkeep)
    note/
      chapter/                     28 session summaries
        intermediate/              1 course-wide mermaid diagram
      tip/                         3 PDFs
```

- `chapter/` = the authored study material, one file per session. This is what you edit.
- `intermediate/` = supporting diagrams. Read-only in practice.
- `tip/` = vendor PDFs (study guides, exam objectives, study plans). Reference material;
  don't edit, and don't reproduce their contents in the notes.
- **Directory names are singular**, matching the file naming: `note/`, `chapter/`,
  `intermediate/`, `tip/`, `question-bank/`. The two exam folders and the book folder
  keep their real names.
- `comptia-network+/question-bank/` is still a placeholder, not an oversight. Don't fill
  it with generated questions; only add real exam material.
- `isc-cissp/question-bank/isc-cissp-official-practice-tests-4th-edition/` holds the MCQ
  sets. Each page hardcodes its own export filename (`domain1_results.csv`) and downloads
  to the browser, so **`result/` is archived output, not an input** — renaming those CSVs
  does not break the pages, and vice versa. There is no Domain 8 result archived.
- This repo consolidates two older GitHub repos, `Mcc-Mak/isc-cissp-summary` and
  `Mcc-Mak/comptia-network--summary`. Their pre-consolidation history is **not** here —
  clone them separately if you ever need it.

## Chapter filename convention

Every direct child of `note/chapter/` is named:

```
session-{NN}-video-{NNN}-to-{NNN}_{content_description}.md
```

- `NN` — session number, 2-digit zero-padded.
- `NNN` — first and last video covered, 3-digit zero-padded. For a single-video session
  both halves are the same number.
- `content_description` — lowercase `[a-z0-9_']` only. Underscore-separated words.

Examples: `session-04-video-022-to-027_risk_management.md`,
`session-34-video-260-to-260_course_conclusion_and_exam_preparation.md`.

This is uniform across both exams — do not reintroduce per-exam schemes. The pattern
applies to `note/chapter/*.md` only.

Files inside `intermediate/` follow a simpler rule, because they are diagram sets that
span sessions rather than one chapter each:

```
[a-z0-9][a-z0-9-]*.(md|svg)
```

Lowercase kebab-case, **singular** nouns. Examples: `session-02.md`, `diagram-part-1.md`,
`consolidation.md`, `diagram-appendix-1.md`, `diagram-course.md`, and the six
`01-…-06-….svg` layer overviews. Note `diagram-part-1.md`, not `diagrams-part-1.md`.

The singular rule is scoped to `intermediate/`. Chapter `{content_description}` keeps
**plural** nouns, because those are the real course titles — `ports_protocols_and_services`,
`network_services`, `data_security_controls`, and `risk_assessments_and_threat_modeling` are
what the sessions are actually called. Don't singularize them.

## The two note sets are deliberately inconsistent

Chapter **filenames** are now uniform across both exams (see above). Almost everything
else still differs. Don't normalize the rest — match the local file.

| | `isc-cissp/` | `comptia-network+/` |
| :--- | :--- | :--- |
| Exam | CISSP (2024) | Network+ N10-009 (superseded) |
| Chapters | 34 | 28 |
| Filename | `session-04-video-022-to-027_risk_management.md` | `session-09-video-068-to-079_ip_addressing.md` |
| Heading | `## Video V22: ...` / `### Video V22 (Outline)` | `# Session 9: ...` / `## V68 - ...` |
| Diagrams | `intermediate/` (three sets) + SVG | `intermediate/` (one course-wide file) |
| Index | `README.md` is a title line only | `README.md` is a real session→summary table |

- **In `comptia-network+/`, the video range in the filename is authoritative** for what a
  chapter covers. The `README.md` table is lossy prose and drifts from the files.
- `isc-cissp/README.md` is a title, not an index. Don't try to keep it in sync.
- Note `comptia-network+` contains a literal `+`. Quote every path in shell commands.

## Trap: `isc-cissp/note/chapter/intermediate/` holds three diagram sets

Editing one does **not** update the others. This is the easiest mistake to make here.

1. `session-NN.md` — per-session, one block per video. Covers Sessions **02–33** only
   (no `01`, no `34`). Headed `### Video Vxx`. 4,429 lines for 02–17 alone.
2. `diagram-part-1.md` (sessions 2–17) and `diagram-part-2.md` (18, 19, 21–34) —
   hand-curated, coarser, headed `## Session N: ...`. **Not** generated from, and not
   concatenations of, the `session-NN.md` files: Part 1 is 1,082 lines against 4,429 for
   `session-02`–`17` combined, and **zero** `session-NN.md` files appear verbatim in it.
   Part 2 also **skips Session 20**, which does have a `session-20.md`.
3. `consolidation.md` — one large cross-session graph.

Also in that folder: `appendix-1.md`, `appendix-2.md`, `diagram-appendix-1.md`,
`diagram-appendix-2.md`, and the six `NN-<layer name>.svg` overview files (hand-drawn,
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

## `tip/` — do not read wholesale

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
