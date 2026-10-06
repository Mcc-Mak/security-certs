#!/usr/bin/env bash
# Assemble the Docsify site into _site/ for GitHub Pages deployment.
#
# Copies the Docsify shell (pages/) and all study-note content from
# codebase/{comptia-network+,isc-cissp}/ into _site/. Docsify runs
# client-side (no build step), so _site/ is a static copy of the
# markdown + the docsify index.html.
#
# Usage: scripts/build-pages.sh [output_dir]  (default: _site)

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

out="${1:-_site}"

rm -rf "$out"
mkdir -p "$out"

# ── Docsify shell ────────────────────────────────────────────────────────────
cp pages/index.html "$out/"
cp pages/.nojekyll "$out/"

# Vendored assets (self-hosted Bootstrap Icons CSS + fonts, no CDN/SRI needed)
if [[ -d "pages/vendor" ]]; then
  cp -r pages/vendor "$out/vendor"
fi

# Landing page: pages/README.md is the TOCTREE for study content.
cp pages/README.md "$out/README.md"

# ── Auto-generate sidebar with all session links ─────────────────────────────
# The sidebar lists every chapter file so that:
#   1. Users can navigate directly to any session from the sidebar
#   2. The Docsify search plugin (paths: 'all') indexes all pages
# Session titles are extracted from filenames: session-{NN}-video-..._{desc}.md
{
  echo "- [Home](/)"

  for exam in comptia-network+ isc-cissp; do
    exam_label="CompTIA Network+"
    [[ "$exam" == "isc-cissp" ]] && exam_label="ISC CISSP"

    echo "- [$exam_label](/$exam/README.md)"

    # Collect chapter filenames, sort by session number
    while IFS= read -r _filename; do
      # Extract description from filename: everything after the last underscore, before .md
      desc="${_filename#*session-??-video-???-to-???_}"
      desc="${desc%.md}"
      # Replace underscores with spaces, title-case each word
      desc="${desc//_/ }"
      desc=$(echo "$desc" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')

      # Extract session number for display
      snum="${_filename#session-}"
      snum="${snum%%-*}"
      # Remove leading zero
      snum="${snum#0}"

      echo "  - [Session ${snum} — ${desc}](/${exam}/note/chapter/${_filename})"
    done < <(
      for f in "codebase/$exam/note/chapter"/session-*.md; do
        [[ -f "$f" ]] && basename "$f"
      done | sort -t- -k2 -n
    )

    # ── Question-bank link (if a README.md index exists) ─────────────────────
    qb_dir="codebase/$exam/question-bank"
    if [[ -f "$qb_dir/README.md" ]]; then
      echo "  - [Question Bank](/$exam/question-bank/README.md)"
    fi
  done
} > "$out/_sidebar.md"

# ── Study-note content ───────────────────────────────────────────────────────
for exam in comptia-network+ isc-cissp; do
  if [[ -d "codebase/$exam" ]]; then
    mkdir -p "$out/$exam"
    cp -r "codebase/$exam/." "$out/$exam/"
  fi
done

echo "Site assembled at $out/"
find "$out" -type f | wc -l | xargs -I{} echo "{} files staged."
