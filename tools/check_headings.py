#!/usr/bin/env python3
"""Check a built PDF for headings stranded at the foot of a page.

A heading means any section title, prayer title or rubric line. The rule: a
heading must have at least MIN_LINES lines of text after it on the same page,
unless it is a closing rubric, which has nothing to follow by design.

MIN_LINES is 2 rather than 3 because some prayers are two lines long in their
entirety on an A6 page; a heading over a complete short prayer is not stranded.

usage: tools/check_headings.py build/little-red-prayer-book.pdf [...]
"""

import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MIN_LINES = 2          # body lines required under a heading
MIN_BEFORE = 4         # ignore headings in the first lines of a page
# closing rubrics: nothing follows them, so they may end a page
CLOSING = {
    'andtherestofsmallcompline',
    'whenyouhavereceivedcommunionsay',
}


def headings():
    """Every heading string in the book, normalised to letters and digits."""
    found = set()
    for path in (ROOT / 'sections').glob('*.tex'):
        text = path.read_text()
        for m in re.finditer(r'\\(prayer|instruction|instructionheading|instructionclosing|canonlabel|section)\{([^}]*)\}', text):
            found.add(re.sub(r'[^a-z0-9]', '', m.group(2).lower()))
        if '\\theotokion' in text:
            found.add('theotokion')
    found |= {
        'contents', 'morningprayers', 'smallcompline',
        'preparationforholycommunion', 'thanksgivingafterholycommunion',
    }
    return found


def page_text(pdf, page):
    result = subprocess.run(
        ['gs', '-q', '-sDEVICE=txtwrite', f'-dFirstPage={page}', f'-dLastPage={page}',
         '-o', '-', str(pdf)], capture_output=True, text=True)
    return result.stdout


def page_count(pdf):
    result = subprocess.run(
        ['gs', '-q', '-dNODISPLAY', '-dNOSAFER', '-c',
         f"({pdf}) (r) file runpdfbegin pdfpagecount == quit"], capture_output=True, text=True)
    return int(result.stdout.strip().split()[-1])


def check(pdf):
    known = headings()
    problems = []
    for page in range(1, page_count(pdf) + 1):
        lines = [l.strip() for l in page_text(pdf, page).split('\n') if l.strip()]
        while lines and re.fullmatch(r'\d+', lines[-1]):
            lines.pop()
        norm = [re.sub(r'[^a-z0-9]', '', l.lower()) for l in lines]
        for i, word in enumerate(norm):
            if i < MIN_BEFORE or word not in known or word in CLOSING:
                continue
            after = [l for j, l in enumerate(lines[i + 1:])
                     if norm[i + 1 + j] not in known and not re.fullmatch(r'\d+', l)]
            if len(after) < MIN_LINES:
                problems.append((page, lines[i][:48], len(after)))
    return problems


def main(paths):
    failed = False
    for path in paths:
        pdf = Path(path)
        problems = check(pdf)
        if problems:
            failed = True
            print(f'FAIL {pdf} ({page_count(pdf)} pages)')
            for page, heading, count in problems:
                print(f'  p.{page}: "{heading}" with {count} line(s) under it')
        else:
            print(f'PASS {pdf} ({page_count(pdf)} pages, no stranded headings)')
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:] or ['build/little-red-prayer-book.pdf']))
