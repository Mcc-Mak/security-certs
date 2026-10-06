#!/usr/bin/env bash
# Generate wiki content from docbase/ engineering documentation.
#
# GitHub Wiki serves pages by filename at the wiki root — no subdirectories.
# The wiki is engineering-docs-only (docbase/). Study notes (codebase/) are
# published on the GitHub Pages site, not the wiki.
#
# Layout produced:
#   Home.md       ← root README.md (project overview, links to TOCTREE)
#   TOCTREE.md    ← docbase/TOCTREE.md (links flattened for wiki root)
#   *.md          ← docbase/docs/*.md (SRS, Architecture, …)
#   _Sidebar.md   ← navigation index
#
# Usage: scripts/sync-wiki.sh <wiki_dir>
#   <wiki_dir> — target directory (typically a clone of the .wiki.git repo)
#
# The caller handles git add/commit/push after this script populates the dir.

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

wiki_dir="${1:?Usage: sync-wiki.sh <wiki_dir>}"

if [[ ! -d "$wiki_dir/.git" ]]; then
  echo "::error::$wiki_dir is not a git repo (no .git). Clone the wiki repo first."
  exit 1
fi

# ── Wipe existing content (keep .git) ────────────────────────────────────────
find "$wiki_dir" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# ── Home.md from root README.md (transform dead links for wiki context) ──────
# The root README.md contains links to codebase/, docbase/docs/, and AGENTS.md
# that don't exist as wiki pages. Transform them:
# - codebase/ exam links   → live Pages site URLs
# - docbase/docs/X.md      → wiki page name X
# - docbase/TOCTREE.md     → wiki page TOCTREE
# - AGENTS.md              → GitHub source URL
sed \
  -e 's|(codebase/comptia-network+/README\.md)|(https://mcc-mak.github.io/security-certs/#/comptia-network+/README)|g' \
  -e 's|(codebase/isc-cissp/README\.md)|(https://mcc-mak.github.io/security-certs/#/isc-cissp/README)|g' \
  -e 's|(docbase/docs/\([A-Za-z-]*\)\.md)|(\1)|g' \
  -e 's|(docbase/TOCTREE\.md)|(TOCTREE)|g' \
  -e 's|(AGENTS\.md)|(https://github.com/Mcc-Mak/security-certs/blob/main/AGENTS.md)|g' \
  README.md > "$wiki_dir/Home.md"

# ── TOCTREE.md from docbase/TOCTREE.md (flatten links for wiki root) ─────────
# Wiki pages live at the root, so `docs/SRS.md` → `SRS.md`.
# The "Study content" section (links to ../codebase/) is stripped — the
# wiki is engineering-docs-only; study notes live on the Pages site.
if [[ -f docbase/TOCTREE.md ]]; then
  awk '
    /^## Study content/ { skip=1; next }
    skip && /^## / { skip=0 }
    skip { next }
    { gsub(/\]\(docs\//, "]("); print }
  ' docbase/TOCTREE.md > "$wiki_dir/TOCTREE.md"
fi

# ── Engineering docs from docbase/docs/ ──────────────────────────────────────
if [[ -d docbase/docs ]]; then
  cp docbase/docs/*.md "$wiki_dir/" 2>/dev/null || true
fi

# ── _Sidebar.md ──────────────────────────────────────────────────────────────
{
  echo "# Navigation"
  echo ""
  echo "- [[Home]]"
  echo "- [[TOCTREE]]"
  echo ""
  echo "### Engineering Docs"
  echo ""
  for doc in SRS Architecture QuickStart Configurations CICD-Pipeline RTM CRM; do
    if [[ -f "docbase/docs/${doc}.md" ]]; then
      echo "- [[${doc}]]"
    fi
  done
} > "$wiki_dir/_Sidebar.md"

echo "Wiki content generated at $wiki_dir/"
echo "Staged pages:"
(cd "$wiki_dir" && find . -name '*.md' ! -path './.git/*' | sort)
