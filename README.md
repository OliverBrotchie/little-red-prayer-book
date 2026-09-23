# Little Red Prayer Book

An A6 prayer book, 105 mm by 148 mm, for St Andrew's Orthodox Community in
Edinburgh. It holds Morning Prayers, Small Compline, Preparation for Holy
Communion and Thanksgiving after Holy Communion, behind a title page, an icon
of Saint Andrew and a contents page. The interior prints in one ink on white
paper, so a print shop can run it as a plain black-and-white job.

## Build

LuaLaTeX with TeX Live, plus `gs` and Python 3 for the heading check.

```bash
./build.sh              # build/little-red-prayer-book.pdf
./build.sh imposed      # then A4 sheets in fold order
```

The finished PDF lands in `build/`. The book is 52 pages, which is thirteen
sheets folded, so the run needs no blank filler:

```bash
gs -o - -sDEVICE=inkcov build/little-red-prayer-book.pdf | sort -u   # one ink
python3 tools/check_headings.py build/little-red-prayer-book.pdf     # no stranded headings
```

## Contents

1. Title page
2. Icon of Saint Andrew the First-Called
3. Contents
4. Morning Prayers
5. Small Compline
6. Preparation for Holy Communion
7. Thanksgiving after Holy Communion

Every service begins on a fresh page. The icon page carries no heading and no
entry in the contents.

## Layout

- `little-red-prayer-book.tex` is the root document, and holds the page
  geometry, the fonts and the blank-page padding.
- `commands/formatting.tex` defines the heading macros and the space each
  heading reserves.
- `commands/prayers.tex` holds the prayers that more than one service uses.
- `sections/` holds one file per section, in reading order.
- `assets/icon.jpg` is the greyscale icon plate.
- `docs/spec.md` holds the spec and the sources; `CONTEXT.md` holds the
  vocabulary.
- `build.sh` builds the PDF; `tools/check_headings.py` fails the build if a
  heading is left stranded at the foot of a page.

## One ink

The book uses black only, which is why rubrics are italic rather than red and
why heading levels are told apart by weight and small caps. Any replacement
icon has to be greyscale for the same reason.

## Sources

The services follow the prayer book of the Archdiocese of Thyateira and Great
Britain, itself based on the translations of Archimandrite Ephrem Lash. The
texts were taken from the St Kallistos booklet; see `docs/spec.md` for the
full list.
