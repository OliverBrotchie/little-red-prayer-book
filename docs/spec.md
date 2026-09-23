# Spec: Little Red Prayer Book

An A6 prayer book for St Andrew's Orthodox Community, Edinburgh, printed in one
ink for handing out.

## Status

Built. `./build.sh` writes `build/little-red-prayer-book.pdf`, 56 pages, no
stranded headings.

## Purpose

Give a visitor or a member of the congregation the four services they are most
likely to pray at home, in a form cheap enough to give away.

## Format

- A6, 105 mm by 148 mm, LuaLaTeX.
- 9pt body on a 11pt leading. TeX Gyre Pagella throughout.
- One ink. Rubrics are italic a step smaller than the body, prayer titles bold
  small caps, section titles bold small caps a size up.
- 12 mm inner margin, 8 mm outer, which alternate on facing pages.
- A 10 mm head margin and a 10 mm foot margin, both measured to the running
  header and to the folio rather than to the text block, so the header and the
  page number clear the trim.
- Running header naming the service, and a folio at the foot. Section openings
  and the front matter carry the folio alone.
- Padded to a multiple of four pages, currently 56, so the run folds into whole
  sheets whichever binding is chosen.

## Structure

1. Title page, "Little Red Prayer Book", with a line-and-star flair above the
   subtitle "St Andrew's Orthodox Community Edinburgh".
2. Icon of Saint Andrew the First-Called, full page and greyscale, inside a
   single rule border with a flower at the middle of the top and bottom rules.
3. Contents.
4. Morning Prayers (p. 4).
5. Small Compline (p. 13).
6. Preparation for Holy Communion (p. 26), whose canon of preparation carries
   its ode numbers: Ode 1, 3, 4, 5, 6, Kontakion, 7, 8, 9.
7. Thanksgiving after Holy Communion (p. 47), which closes with the flair where
   the last page has room for it.

## Sources

The four services follow the prayer book of the Archdiocese of Thyateira and
Great Britain, which is based on the translations of Archimandrite Ephrem Lash.
The texts were carried over from the St Kallistos booklet, which used the same
source, and are unchanged apart from the heading reserves that the smaller page
needed and the ode numbers restored to the canon of preparation.

The ode numbers and the Kontakion label were taken from the first committed
version of the text, which carried them as `\instruction` lines with the
heirmos incipits; a later edit dropped them.

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
7. **The canon of preparation carries its ode numbers**, restored from the first
   committed version of the text, which had lost them in a later edit. The
   Kontakion that falls between Ode 6 and Ode 7 is labelled with them, so the
   start of Ode 7 is unambiguous.
8. **Head and foot lengths live in the geometry options**, not in `\setlength`
   calls after the package loads. Geometry places the running header from the
   values it sees when it loads, so a later `\setlength` moves the body up into
   the header and clips it at the trim.
9. **The closing flair is conditional.** It is printed only when the page that
   ends the text has room for it, so the decoration can neither push the run
   onto another page nor sit alone on one.
10. **"Both now and for ever" is capitalised where it stands alone** and lower
   case where it follows Glory to the Father in one sentence. One macro holds
   the words, so the two forms cannot drift apart.
11. **The icon plate is one TikZ picture.** The rule and the flowers share a
   coordinate system, so they line up without an overlay pass. TikZ is the only
   drawing package in the book, and it draws nothing else.

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
