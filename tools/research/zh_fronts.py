#!/usr/bin/env python3
"""The Chinese fronts and their one navigation line (RW, 8 November 2026).

Every Chinese front opens with the same line: its English edition, then the Chinese ways in in one order, the page
itself in bold and not linked. The line is built here, so the hand-written pages, the generated lineage (lineage.py
is to call `nav_line`, and its test to check it) and the check agree. Chapter 6 is written in Chinese and is linked,
but it is a chapter, not a front, and carries no such line.

usage: python3 -B tools/research/zh_fronts.py   (prints each front whose line differs, exits 1 if any)
"""
from __future__ import annotations

from pathlib import Path
import posixpath
import sys

ROOT = Path(__file__).resolve().parents[2]

# The ways in, in the line's order: (label, repository path).
WAYS = (('首页', 'README.zh.md'),
        ('一页', 'theories/becoming/ONE-PAGE.zh.md'),
        ('用途', 'theories/becoming/USES.zh.md'),
        ('实例', 'theories/becoming/USES-EXAMPLES.zh.md'),
        ('总览', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md'),
        ('第六章', 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md'),
        ('怎样长成', 'theories/LINEAGE.zh.md'),
        ('术语表', 'GLOSSARY.zh.md'),
        ('审查包', 'theories/becoming/review/README.zh.md'))
# The fronts that carry the line, each with its English edition.
FRONTS = {'README.zh.md': 'README.md',
          'theories/becoming/ONE-PAGE.zh.md': 'theories/becoming/ONE-PAGE.md',
          'theories/becoming/USES.zh.md': 'theories/becoming/USES.md',
          'theories/becoming/USES-EXAMPLES.zh.md': 'theories/becoming/USES-EXAMPLES.md',
          'theories/becoming/THE-THEORY-OF-BECOMING.zh.md': 'theories/becoming/THE-THEORY-OF-BECOMING.md',
          'theories/LINEAGE.zh.md': 'theories/LINEAGE.md',
          'GLOSSARY.zh.md': 'GLOSSARY.md',
          'theories/becoming/review/README.zh.md': 'theories/becoming/review/README.md'}
# Written by hand; the lineage is generated and its generator emits the line.
HAND_WRITTEN = tuple(p for p in FRONTS if p != 'theories/LINEAGE.zh.md')


def _link(label: str, target: str, page: str) -> str:
    return f'[{label}]({posixpath.relpath(target, posixpath.dirname(page) or ".")})'


def nav_line(page: str) -> str:
    """The line for a front: [English] · then each way in, the page itself bold and not linked."""
    if page not in FRONTS:
        raise KeyError(f'not a Chinese front: {page}')
    items = [_link('English', FRONTS[page], page)]
    items += [f'**{label}**' if target == page else _link(label, target, page) for label, target in WAYS]
    return ' · '.join(items)


OPENING = 12  # the line stands among a front's opening lines, under its title


def current(page: str, root: Path = ROOT) -> str | None:
    """The page's navigation line as it stands: the first of its opening lines that opens with its English link, or
    None where it has none or the page is missing."""
    path = root / page
    if not path.is_file():
        return None
    lines = path.read_text(encoding='utf-8').split('\n')[:OPENING]
    return next((line for line in lines if line.startswith('[English](')), None)


def problems(pages=HAND_WRITTEN, root: Path = ROOT) -> list[str]:
    """Each front whose line is missing or differs from `nav_line`."""
    return [f'{page}: its navigation line is not the Chinese fronts\' line' for page in pages if current(page, root) != nav_line(page)]


if __name__ == '__main__':
    found = problems()
    print('\n'.join(found) or 'every Chinese front carries the line')
    sys.exit(1 if found else 0)
