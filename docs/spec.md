# Spec: Little Red Prayer Book

An A6 prayer book for St Andrew's Orthodox Community, Edinburgh, printed in one
ink for handing out.

## Status

Built. `./build.sh` writes `build/little-red-prayer-book.pdf`, 52 pages, no
stranded headings.

## Purpose

Give a visitor or a member of the congregation the four services they are most
likely to pray at home, in a form cheap enough to give away.

## Format

- A6, 105 mm by 148 mm, LuaLaTeX.
- 9pt body on a 11pt leading. TeX Gyre Pagella throughout.
- One ink. Rubrics are italic a step smaller than the body, prayer titles bold
  small caps, section titles bold small caps a size up.
- 12 mm inner margin, 8 mm outer, 11 mm head, 13 mm foot.
- Running header naming the service, and a folio at the foot. Section openings
  and the front matter carry the folio alone.
- Padded to a multiple of four pages, currently exactly 52, so the run folds
  into whole sheets whichever binding is chosen.

## Structure

1. Title page, "Little Red Prayer Book", with the subtitle "St Andrew's
   Orthodox Community Edinburgh".
2. Icon of Saint Andrew the First-Called, full page, greyscale.
3. Contents.
4. Morning Prayers (p. 4).
5. Small Compline (p. 13).
6. Preparation for Holy Communion (p. 25).
7. Thanksgiving after Holy Communion (p. 46).

## Sources

The four services follow the prayer book of the Archdiocese of Thyateira and
Great Britain, which is based on the translations of Archimandrite Ephrem Lash.
The texts were carried over from the St Kallistos booklet, which used the same
source, and are unchanged apart from the heading reserves that the smaller page
needed.

The icon of Saint Andrew the First-Called came from the parish's own artwork,
held in `edinburgh-orthodox.org.uk`, and is converted to greyscale here.

## Decisions

1. **A6**, 105 mm by 148 mm, down from the A5 of the St Kallistos booklet.
2. **One ink.** No red. See `docs/adr/0002-one-ink-interior.md`.
3. **A 12 mm inner margin**, which suits a glued spine and costs a stapled
   booklet nothing. See `docs/adr/0001-a6-page-with-a-binders-gutter.md`.
4. **Four services only.** No Psalter, no preparation canons beyond what
   Preparation for Holy Communion already carries, no calendar, no calendar of
   saints.
5. **Heading reserves are tuned per macro.** A rubric that introduces a prayer
   title uses `\instructionheading`, which reserves room for the title as well,
   so the two are never split.
6. **The heading check runs on every build** and fails it, rather than printing
   a warning, because a stranded heading is invisible until the book is printed.

## Build

```bash
./build.sh              # build/little-red-prayer-book.pdf
./build.sh imposed      # then A4 sheets in fold order
```

Two passes settle the contents, then the run is padded to a whole number of
sheets, then `tools/check_headings.py` reads the PDF back and fails on any
heading left with fewer than two lines under it at the foot of a page.

## Non-goals

- No cover artwork. The title page is the cover, and any card cover is the
  printer's to add.
- No services beyond the four, and no Psalter.
- Not for sale.
