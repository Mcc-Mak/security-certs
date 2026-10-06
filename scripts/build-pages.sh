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

# Landing page: pages/README.md is the TOCTREE for study content.
cp pages/README.md "$out/README.md"
# Persistent sidebar for Docsify navigation.
cp pages/_sidebar.md "$out/_sidebar.md"

# ── Study-note content ───────────────────────────────────────────────────────
for exam in comptia-network+ isc-cissp; do
  if [[ -d "codebase/$exam" ]]; then
    mkdir -p "$out/$exam"
    cp -r "codebase/$exam/." "$out/$exam/"
  fi
done

echo "Site assembled at $out/"
find "$out" -type f | wc -l | xargs -I{} echo "{} files staged."
