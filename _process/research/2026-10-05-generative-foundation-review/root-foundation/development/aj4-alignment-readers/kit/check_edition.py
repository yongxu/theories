#!/usr/bin/env python3
"""Check parts of the review packet's reader edition as tools/publishing/build_review_packet.py builds them: every
in-document link resolves, and none of the markup check_dossiers.py reads is left. The builder gives a heading an id
only from an anchor on the line before it, so a link relying on GitHub's own heading slug fails here.

    python3 tools/publishing/build_review_packet.py ALIGNMENT.md   # from the repository's root
    python3 -B check_edition.py [PART ...]                          # by default, ALIGNMENT
"""
import html
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(subprocess.run(['git', 'rev-parse', '--show-toplevel'], cwd=Path(__file__).resolve().parent,
                           capture_output=True, text=True, check=True).stdout.strip())
BUILD = ROOT / 'tmp' / 'pdfs' / 'review-packet'
MARKUP = r'(Quote|Source)\s*\[[^\]]*\]\s*:|引〔[^〕]*〕|原文〔[^〕]*〕'


def check(part):
    page = BUILD / f'{part}.html'
    if not page.exists():
        return [f'{part}: not built ({page.relative_to(ROOT)})']
    t = page.read_text()
    ids = set(re.findall(r'\bid="([^"]+)"', t))
    links = re.findall(r'href="#([^"]+)"', t)
    problems = [f'{part}: link to #{h} unresolved' for h in sorted({h for h in links if h not in ids})]
    text = html.unescape(re.sub(r'<[^>]+>', ' ', t))
    problems += [f'{part}: markup left: {m.group(0)}' for m in re.finditer(MARKUP, text)]
    print(f'{part}: {len(links)} in-document links, {len(problems)} problem(s)')
    return problems


if __name__ == '__main__':
    found = [p for part in (sys.argv[1:] or ['ALIGNMENT']) for p in check(part.removesuffix('.md'))]
    print('\n'.join(found) or '0 problem(s)')
    sys.exit(1 if found else 0)
