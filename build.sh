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

# The run is padded up to a multiple of PAD pages. A glued or otherwise trimmed
# book only needs the pairs a duplex press produces, so the default is 2 and the
# run carries at most one blank leaf. PAD=4 pads to whole folded sheets, which a
# stapled booklet needs: `PAD=4 ./build.sh`.
PAD=${PAD:-2}

# Two passes settle the contents; then pad, repeating in case the added leaf
# moves a heading and changes the page count again.
echo "pass 1"; pass 0
echo "pass 2"; pass 0
for _ in 1 2 3; do
  n=$(pages)
  pad=$(( (PAD - n % PAD) % PAD ))
  [ "$pad" -eq 0 ] && break
  echo "pad by $pad (from $n pages)"; pass "$pad"
done
n=$(pages)
[ $(( n % PAD )) -eq 0 ] || { echo "error: $n pages is not a multiple of $PAD" >&2; exit 1; }
echo "  build/$JOB.pdf ($n pages)"

if [ "${1:-}" = imposed ]; then
  # A4 landscape sheets, two A6 pages per side, in fold order for a stapled
  # booklet. SIGNATURE sets the pages per signature and defaults to the whole
  # run, which pads nothing; set it lower for thinner signatures, at the cost
  # of blank pages to fill the last one.
  local_sheet=${SHEET:-a4paper}
  sig=${SIGNATURE:-$(pages)}
  cat > "$OUT/impose.tex" <<EOF
\\documentclass[${local_sheet},landscape]{article}
\\usepackage{pdfpages}
\\begin{document}
\\includepdf[pages=-,signature=${sig},nup=2x1,frame=false]{$(pwd)/$OUT/$JOB.pdf}
\\end{document}
EOF
  $LATEX -interaction=nonstopmode -halt-on-error -jobname=$JOB-imposed \
    -output-directory="$OUT" "$OUT/impose.tex" >/dev/null
  rm -f "$OUT/impose.tex" "$OUT/impose.log" "$OUT/impose.aux"
  echo "  build/$JOB-imposed.pdf ($local_sheet sheets, $sig pages per signature)"
fi

# no heading may be left stranded at the foot of a page
python3 tools/check_headings.py "build/$JOB.pdf"
