# Little Red Prayer Book

An A6 prayer book for St Andrew's Orthodox Community in Edinburgh, printed in
one ink and handed out rather than sold.

## Language

**Little Red Prayer Book**:
This book. Four services behind a title page, an icon and a contents page.
_Avoid_: booklet, pamphlet, handout, the red book

**St Andrew's Orthodox Community**:
The parish the book is for, in the Archdiocese of Thyateira and Great Britain.
The subtitle on the title page reads "St Andrew's Orthodox Community Edinburgh".
_Avoid_: St Andrew's Church, the Edinburgh parish

**Service**:
One of the four ordered texts: Morning Prayers, Small Compline, Preparation for
Holy Communion, Thanksgiving after Holy Communion. Each starts on a fresh page.
_Avoid_: section, chapter, office

**Section**:
A LaTeX division, one per service, which is what the contents page lists. Use
"service" when meaning the text a reader prays and "section" only when meaning
the markup.
_Avoid_: using the two interchangeably

**Rubric**:
An instruction to the reader, set in italic a step smaller than the body and not
itself prayed.
_Avoid_: instruction, note, direction

**Prayer title**:
The centred small-caps line naming the prayer that follows, for example
"Heavenly King". Carries no number and no contents entry.
_Avoid_: heading, subheading

**Reserve**:
The space a heading asks for before it is set, so it is never left at the foot
of a page with nothing under it. Held in `commands/formatting.tex` as
`\needspace` values, one for rubrics, one for rubrics that introduce a prayer
title, one for prayer titles.
_Avoid_: keep-with-next, widow control

**One ink**:
Black only, no colour on any page. What the book is printed with, and the reason
the heading levels differ by weight rather than colour.
_Avoid_: monochrome, greyscale (the icon is greyscale, the book is one ink)

**Flair**:
The ornament of a line, a star and a line that marks the title page and closes
the book. Held in `commands/formatting.tex` as `\ornarule`, whose optional
argument sets how much of the text width each line takes, and as
`\ornaruleiffits`, which prints it only where the page has room.
_Avoid_: rule, divider, ornament, dingbat

**Division label**:
The centred label that marks an ode, or the Kontakion, inside the canon of
preparation. Set as a heading so it is not read as prayer text.
_Avoid_: ode heading, subheading

**Sheet**:
Four A6 pages, two on each side of one A4 sheet folded once. The page count is
kept on a multiple of four so a folded run has no half sheet.
_Avoid_: signature

**Icon plate**:
The full-page greyscale icon of Saint Andrew the First-Called after the title
page, between a top rule carrying a plume over a small circle on a stem, with a
leaf to either side, and a plain bottom rule. It carries no heading and no
contents entry.
_Avoid_: frontispiece, image, illustration
