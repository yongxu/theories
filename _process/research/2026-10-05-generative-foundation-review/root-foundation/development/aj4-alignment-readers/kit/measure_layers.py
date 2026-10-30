#!/usr/bin/env python3
"""Reading times of the layers a person is given, against their budgets (../READING-BUDGETS.md).

Counts visible prose. Code and Lean blocks, comments, link targets, anchors, note markers and the
`Quote [path]:` prefixes the dossier checker reads are not counted. English is counted in words,
Chinese in characters, and a time is given at 100 to 130 words, or 200 to 260 characters, a minute.
A budget is in words, a Chinese character counting half a word: ten minutes is 1,100 words, 8.5 to
11 minutes at those rates. Lines of code and Lean in a whole dossier are reported, not timed.

    python3 -B measure_layers.py [REF]    # REF: a commit; by default, the working tree
"""
import re
import statistics
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(subprocess.run(['git', 'rev-parse', '--show-toplevel'], cwd=HERE,
                           capture_output=True, text=True, check=True).stdout.strip())
REVIEW = 'theories/becoming/review/'
MAP = str((HERE.parent / 'FAILURE-MODE-MAP.md').relative_to(ROOT))
SCREEN, TEN, HOUR = 150, 1100, 6000

# (layer, path, start, end, budget in words): start and end are patterns, None the file's edge.
LAYERS = [
    ("README's first screen, before the opening", 'README.md', None, r'^## ', SCREEN),
    ('the opening, in the first person', 'README.md', r'^## Truth exists', r'^### Notes', None),
    ('one page', 'theories/becoming/ONE-PAGE.md', None, None, TEN),
    ('one page, Chinese', 'theories/becoming/ONE-PAGE.zh.md', None, None, TEN),
    ('overview', 'theories/becoming/THE-THEORY-OF-BECOMING.md', None, None, HOUR),
    ('overview, Chinese', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md', None, None, HOUR),
    ('packet cover', REVIEW + 'README.md', None, None, TEN),
    ('packet cover, Chinese', REVIEW + 'README.zh.md', None, None, TEN),
    ('front: classical texts', REVIEW + 'CLASSICAL-TEXTS.md', None, r'^###? C-01', TEN),
    ('front: Buddhist thought', REVIEW + 'BUDDHIST-THOUGHT.md', None, r'^###? B-01', TEN),
    ('front: logic', REVIEW + 'LOGIC.md', None, r'^###? L-01', TEN),
    ('front: philosophy', REVIEW + 'PHILOSOPHY.md', None, r'^###? P-01', TEN),
    # To the end of the part the dossier labels as its ten-minute reading, or to its first item.
    ('front: alignment', REVIEW + 'ALIGNMENT.md', None, r'^(## The items|###? A-01)', TEN),
    ('failure-mode map, before its rows', MAP, None, r'^## \d+\. The rows', TEN),
]
WHOLES = ['CLASSICAL-TEXTS.md', 'BUDDHIST-THOUGHT.md', 'LOGIC.md', 'PHILOSOPHY.md', 'ALIGNMENT.md']
# The alignment dossier's hour, as its "How long" paragraph names it: its ten minutes and these.
HOUR_PATH = ['a-02', 'a-07', 'a-10', 'a-12', 'a-14', 'a-18', 'a-19']


def visible(s):
    s = re.sub(r'```.*?```', '', s, flags=re.S)
    s = re.sub(r'<!--.*?-->', '', s, flags=re.S)
    s = re.sub(r'\]\([^)]*\)', ']', s)
    s = re.sub(r'<a id="[^"]*"></a>|<sup>.*?</sup>', '', s)
    return re.sub(r'(Quote|Source)\s*\[[^\]]*\]\s*:\s*', '', s)


def count(s):
    v = visible(s)
    return len(re.findall(r"[A-Za-z0-9][A-Za-z0-9'’\-.]*", v)), len(re.findall(r'[一-鿿]', v))


def minutes(en, zh):
    return f'{en / 130 + zh / 260:.1f}–{en / 100 + zh / 200:.1f}'


def read(ref, path):
    if ref is None:
        p = ROOT / path
        return p.read_text() if p.exists() else None
    r = subprocess.run(['git', '-C', str(ROOT), 'show', f'{ref}:{path}'], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


def part(text, start, end):
    m = re.search(start, text, re.M) if start else None
    a, b = (m.start(), m.end()) if m else (0, 0)
    n = re.search(end, text[b:], re.M) if end else None
    return text[a:b + n.start()] if n else text[a:]


def states_time(s):
    """Whether a reading time is stated where the part begins: in its first 150 words, or 300
    characters of Chinese."""
    v = visible(s)
    head = ' '.join(re.findall(r"\S+", v)[:150])
    return bool(re.search(r'\b(minutes?|hours?)\b', head) or re.search(r'分钟|小时', v[:600]))


def main(ref=None):
    print('| Layer | Words | Characters | Minutes | Budget (words) | Within | Time stated |')
    print('|---|---:|---:|---:|---:|---|---|')
    for name, path, start, end, budget in LAYERS:
        text = read(ref, path)
        if text is None:
            print(f'| {name} | missing: {path} | | | | | |')
            continue
        body = part(text, start, end)
        en, zh = count(body)
        within = '' if budget is None else ('yes' if en + zh / 2 <= budget else 'no')
        stated = '' if budget is None else ('yes' if states_time(body) else 'no')
        print(f'| {name} | {en:,} | {zh:,} | {minutes(en, zh)} | {budget or ""} | {within} | {stated} |')
    for name in WHOLES:
        text = read(ref, REVIEW + name)
        if text is not None:
            en, zh = count(text)
            code = sum(b.count('\n') - 1 for b in re.findall(r'```.*?```', text, flags=re.S))
            print(f'| whole: {name}, and {code:,} lines of code | {en:,} | {zh:,} | {minutes(en, zh)} | | | |')
    text = read(ref, REVIEW + 'ALIGNMENT.md')
    if text and '## The dossier in ten minutes' in text:
        en = count(part(text, r'^## The dossier in ten minutes', r'^## The items'))[0]
        for item in HOUR_PATH:
            body = part(text, f'<a id="{item}"></a>', r'^(<a id="a-|---$|## )')
            en += count(body)[0]
        print(f'| alignment: its hour | {en:,} | 0 | {minutes(en, 0)} | {HOUR} | {"yes" if en <= HOUR else "no"} | |')
    text = read(ref, 'README.md')
    notes = [n for n in re.split(r'\n(?=\d+\. <a id="note-)', part(text, r'^### Notes', r'^## ')) if 'note-' in n]
    sizes = [count(n)[0] for n in notes]
    if sizes:
        print(f'\nThe opening\'s notes: {len(sizes)}, {sum(sizes):,} words; median {statistics.median(sizes):.0f}, '
              f'largest {max(sizes):,}; {sum(s > 300 for s in sizes)} over 300 (three minutes).')


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else None)
