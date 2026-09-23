# AGENTS.md

An A6 prayer book for St Andrew's Orthodox Community, Edinburgh: Morning
Prayers, Small Compline, Preparation for Holy Communion and Thanksgiving after
Holy Communion, behind a title page, an icon of Saint Andrew, and a contents
page that carries an introduction on prayer. Printed in one ink on white paper.

## Build

```bash
./build.sh              # build/little-red-prayer-book.pdf
PAD=4 ./build.sh        # pad to whole folded sheets rather than page pairs
./build.sh imposed      # then A4 sheets in fold order
```

LuaLaTeX with TeX Live, plus `gs` and Python 3 for `tools/check_headings.py`.
`build.sh` compiles twice to settle the contents, pads the run to a multiple of
`PAD` pages, then fails if any heading is left stranded at the foot of a page.
XeLaTeX will not work: it does not find TeX Gyre Pagella on a stock TeX Live
install.

## Layout

- `little-red-prayer-book.tex` is the root document. Page geometry, fonts and
  the `\buildpad` blank-page count live there.
- `commands/formatting.tex` holds the heading macros, the space each heading
  reserves, and the ornaments.
- `commands/prayers.tex` holds the prayers that more than one service uses.
- `sections/` holds one file per section, in reading order.
- `assets/icon.jpg` is greyscale. Keep any replacement greyscale too, or the
  book stops being a one-ink print job.

## Never

- Never introduce a colour. The interior prints in black only, so
  `gs -o - -sDEVICE=inkcov build/little-red-prayer-book.pdf` must report zero
  cyan, magenta and yellow on every page.
- Never leave the page count off a multiple of `PAD`. Two pages is what a
  trimmed or glued book needs; four is what folding needs, and a half sheet is
  wasted either way.
- Never set `\headheight` or `\headsep` after `geometry` has loaded. Geometry
  places the running header from the values it sees at load time, so a later
  `\setlength` moves the body up into the header and clips it at the trim. Those
  lengths belong in the package options, with `includehead` and `includefoot`.
- Never tune a `\needspace` reserve to make one page look right. The reserves
  keep headings with the lines under them, and any text edit moves the breaks, so
  rebuild and read `tools/check_headings.py` instead of reasoning about it.

## Agent skills

### Issue tracker

Issues and specs live as GitHub issues in this repo, driven through the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles map 1:1 to their label names. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` + `docs/adr/` at the repo root. See `docs/agents/domain.md`.
