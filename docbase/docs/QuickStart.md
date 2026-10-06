# Quick Start

## Prerequisites

- Git
- A GitHub account with push access to `dev-001`
- (Optional) `gh` CLI for secrets configuration
- (Optional) A local markdown previewer that supports mermaid

## Clone and preview locally

```bash
git clone https://github.com/Mcc-Mak/security-certs.git
cd security-certs
git checkout dev-001
```

To preview the Docsify site locally, use any static file server:

```bash
# Option 1: Python
python3 -m http.server 3000

# Option 2: npx (no install)
npx serve -p 3000
```

Open `http://localhost:3000/pages/` in your browser. Docsify will render the markdown with mermaid support.

Alternatively, open any `.md` file directly on GitHub — mermaid blocks render natively.

## Edit a note

1. Pick a chapter file under `codebase/{exam}/note/chapter/`
2. Edit the markdown — add content, mermaid diagrams, tables
3. Run the validator locally:
   ```bash
   ./scripts/validate-notes.sh
   ```
4. Commit with a Conventional Commits message:
   ```bash
   git add -A
   git commit -m "fix: correct VLAN trunking diagram in session-08"
   ```
5. Push to `dev-001`:
   ```bash
   git push origin dev-001
   ```

The CI/CD pipeline runs automatically from there.

## Add a new session note

1. Create the file: `codebase/{exam}/note/chapter/session-{NN}-video-{NNN}-to-{NNN}_{description}.md`
2. Follow the filename convention exactly (2-digit session, 3-digit video range, lowercase description)
3. Write the content with `## Video Vxx` headings matching the video numbers in the filename
4. Update the exam's `README.md` session table if one exists
5. Validate, commit (`feat: add session-29 notes`), push

## Configure CI/CD secrets (first time only)

```bash
cp .env.example .env
# Edit .env — fill in PROMOTE_TOKEN and optionally SONAR_TOKEN
./scripts/configure-secrets.sh
```

This pushes secrets to GitHub, enables Pages (Source: GitHub Actions), enables the Wiki, and registers `dev-001` as a deployment branch.
