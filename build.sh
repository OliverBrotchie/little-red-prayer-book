#!/usr/bin/env bash
# Build the Little Red Prayer Book.
#
#   ./build.sh              build build/little-red-prayer-book.pdf
#   ./build.sh imposed      build, then impose 2-up on A4 sheets in fold order
#
# Output lands in build/.

set -euo pipefail
cd "$(dirname "$0")"

LATEX=lualatex
JOB=little-red-prayer-book
OUT=build
mkdir -p "$OUT"

# One LaTeX pass. $1 blank pages to append.
pass() {
  $LATEX -interaction=nonstopmode -halt-on-error \
    -jobname="$JOB" -output-directory="$OUT" \
    "\\def\\buildpad{$1}\\input{$JOB.tex}" \
    >/dev/null
}

pages() {
  grep -o 'Output written on [^ ]* (\([0-9]*\) page' "$OUT/$JOB.log" 2>/dev/null |
    sed 's/.*(\([0-9]*\) page/\1/' | tail -1
}

# Two passes settle the contents; then pad to a whole sheet, repeating in case
# the added leaf moves a heading and changes the page count again.
echo "pass 1"; pass 0
echo "pass 2"; pass 0
for _ in 1 2 3; do
  n=$(pages)
  pad=$(( (4 - n % 4) % 4 ))
  [ "$pad" -eq 0 ] && break
  echo "pad by $pad (from $n pages)"; pass "$pad"
done
n=$(pages)
[ $(( n % 4 )) -eq 0 ] || { echo "error: $n pages is not a whole number of sheets" >&2; exit 1; }
echo "  build/$JOB.pdf ($n pages)"

if [ "${1:-}" = imposed ]; then
  # A4 landscape sheets, two A6 pages per side, 16-page signatures, fold order.
  local_sheet=${SHEET:-a4paper}
  cat > "$OUT/impose.tex" <<EOF
\\documentclass[${local_sheet},landscape]{article}
\\usepackage{pdfpages}
\\begin{document}
\\includepdf[pages=-,signature=16,nup=2x1,frame=false]{$(pwd)/$OUT/$JOB.pdf}
\\end{document}
EOF
  $LATEX -interaction=nonstopmode -halt-on-error -jobname=$JOB-imposed \
    -output-directory="$OUT" "$OUT/impose.tex" >/dev/null
  rm -f "$OUT/impose.tex" "$OUT/impose.log" "$OUT/impose.aux"
  echo "  build/$JOB-imposed.pdf ($local_sheet spreads, for a printer who wants sheets)"
fi

# no heading may be left stranded at the foot of a page
python3 tools/check_headings.py "build/$JOB.pdf"
