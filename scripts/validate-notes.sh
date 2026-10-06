#!/usr/bin/env bash
# Validate study-notes content conventions in codebase/.
#
# Checks:
#   1. Chapter filenames: session-{NN}-video-{NNN}-to-{NNN}_{description}.md
#   2. Intermediate filenames: lowercase kebab-case [a-z0-9][a-z0-9-]*.(md|svg)
#   3. No plural directory names (notes/, chapters/, tips/, etc.)
#   4. Mermaid code fences balanced in every .md
#   5. No UTF-8 BOM in any .md
#
# Exits 1 on any violation. Intended for CI fast_checks gate.

set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

errors=0
add_error() { echo "::error::$1" >&2; errors=$((errors + 1)); }
add_warning() { echo "::warning::$1" >&2; }

# ── 1. Chapter filenames ────────────────────────────────────────────────────
chapter_re='^session-[0-9]{2}-video-[0-9]{3}-to-[0-9]{3}_[a-z0-9_'"'"']+\.md$'

while IFS= read -r -d '' f; do
  base="$(basename "$f")"
  if [[ ! "$base" =~ $chapter_re ]]; then
    add_error "Chapter filename mismatch: $f
  Expected: session-{NN}-video-{NNN}-to-{NNN}_{description}.md
  Got:      $base"
  fi
done < <(find codebase -path '*/note/chapter/*.md' ! -path '*/intermediate/*' -print0)

# ── 2. Intermediate filenames ───────────────────────────────────────────────
intermediate_re='^[a-z0-9][a-z0-9-]*\.(md|svg)$'

while IFS= read -r -d '' f; do
  base="$(basename "$f")"
  if [[ ! "$base" =~ $intermediate_re ]]; then
    add_error "Intermediate filename mismatch: $f
  Expected: [a-z0-9][a-z0-9-]*.(md|svg)
  Got:      $base"
  fi
done < <(find codebase -path '*/note/chapter/intermediate/*' \( -name '*.md' -o -name '*.svg' \) -print0)

# ── 3. No plural directory names ─────────────────────────────────────────────
for plural in notes chapters tips intermediates results question-banks; do
  while IFS= read -r -d '' d; do
    add_error "Plural directory name found: $d (use singular form)"
  done < <(find codebase -type d -name "$plural" -print0)
done

# ── 4. Mermaid code-fence balance ───────────────────────────────────────────
while IFS= read -r -d '' f; do
  fence_count=$(grep -c '```' "$f" || true)
  if [[ $((fence_count % 2)) -ne 0 ]]; then
    add_error "Unclosed code fence in: $f (found $fence_count fence markers — must be even)"
  fi
done < <(find codebase -name '*.md' -print0)

# ── 5. No UTF-8 BOM ──────────────────────────────────────────────────────────
while IFS= read -r -d '' f; do
  bom=$(head -c 3 "$f" | od -An -tx1 | tr -d ' \n')
  if [[ "$bom" == "efbbbf" ]]; then
    add_error "UTF-8 BOM detected in: $f (remove it — re-save as UTF-8 without BOM)"
  fi
done < <(find codebase -name '*.md' -print0)

# ── Summary ──────────────────────────────────────────────────────────────────
if [[ $errors -gt 0 ]]; then
  echo ""
  echo "Validation FAILED with $errors error(s)."
  exit 1
fi

echo "All note validations passed."
