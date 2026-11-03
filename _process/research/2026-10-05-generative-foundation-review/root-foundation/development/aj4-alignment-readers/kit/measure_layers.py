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


def front(item):
    """A dossier's front: to the end of the part it labels as its ten-minute reading, or else to its
    list of items or its first item."""
    return [(r'^## The dossier in ten minutes$', r'^## '), ('', rf'^(## The items|###? {item})')]


# (layer, path, start, end, budget in words): start and end are patterns, None the file's edge;
# an end (after, pattern) is the pattern's first match after the first match of after, and a list
# of ends is tried in order, the first whose after matches being used.
LAYERS = [
    ("README's first screen, before the opening", 'README.md', None, r'^## ', SCREEN),
    ('the opening, in the first person', 'README.md', r'^## Truth exists', r'^### Notes', None),
    ('one page', 'theories/becoming/ONE-PAGE.md', None, None, TEN),
    ('one page, Chinese', 'theories/becoming/ONE-PAGE.zh.md', None, None, TEN),
    ('overview', 'theories/becoming/THE-THEORY-OF-BECOMING.md', None, None, HOUR),
    ('overview, Chinese', 'theories/becoming/THE-THEORY-OF-BECOMING.zh.md', None, None, HOUR),
    ('packet cover', REVIEW + 'README.md', None, None, TEN),
    ('packet cover, Chinese', REVIEW + 'README.zh.md', None, None, TEN),
    ('front: classical texts', REVIEW + 'CLASSICAL-TEXTS.md', None, front('C-01'), TEN),
    ('front: Buddhist thought', REVIEW + 'BUDDHIST-THOUGHT.md', None, front('B-01'), TEN),
    ('front: logic', REVIEW + 'LOGIC.md', None, front('L-01'), TEN),
    ('front: philosophy', REVIEW + 'PHILOSOPHY.md', None, front('P-01'), TEN),
    ('front: alignment', REVIEW + 'ALIGNMENT.md', None, front('A-01'), TEN),
    ('front: sciences', REVIEW + 'SCIENCES.md', None, front('S-01'), TEN),
    # To the end of its ten-minute section, or else to the end of its table.
    ('failure-mode map, its first part', MAP, None,
     [(r'^## The map in ten minutes$', r'^## '), (r'^## \d+\. The map$', r'^## ')], TEN),
]
WHOLES = ['CLASSICAL-TEXTS.md', 'BUDDHIST-THOUGHT.md', 'LOGIC.md', 'PHILOSOPHY.md', 'ALIGNMENT.md', 'SCIENCES.md']
# A dossier's hour, as its "How long" paragraph names it: its ten minutes and these items. Alignment's hour skips
# the tests' summary after its ten minutes, since A-18 and A-19 give the tests in full.
HOUR_FRONT_END = {'ALIGNMENT.md': r'^## The tests, as they fell$'}
HOUR_PATHS = {'ALIGNMENT.md': ['a-02', 'a-07', 'a-10', 'a-12', 'a-18', 'a-19'],
              'PHILOSOPHY.md': ['p-04', 'p-05', 'p-07', 'p-10', 'p-11', 'p-20'],
              # The reader's field's items, with S-02 but for ecology and renewable resources, the longest field,
              # which is measured: its six fill the hour alone.
              'SCIENCES.md': ['s-11', 's-12', 's-13', 's-14', 's-15', 's-16']}


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
    if isinstance(end, list):
        end = next((e for e in end if re.search(e[0], text[b:], re.M)), None)
    if isinstance(end, tuple):
        after = re.search(end[0], text[b:], re.M)
        b, end = (b + after.end(), end[1]) if after else (b, None)
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
    for name, items in HOUR_PATHS.items():
        text = read(ref, REVIEW + name)
        if not (text and '## The dossier in ten minutes' in text):
            continue
        en, zh = count(part(text, r'^## The dossier in ten minutes',
                            HOUR_FRONT_END.get(name, r'^## (The items|Reading the items)$')))
        for item in items:
            body = count(part(text, f'<a id="{item}"></a>', rf'^(<a id="{item[0]}-|---$|## )'))
            en, zh = en + body[0], zh + body[1]
        within = 'yes' if en + zh / 2 <= HOUR else 'no'
        print(f'| {name[:-3].lower()}: its hour | {en:,} | {zh:,} | {minutes(en, zh)} | {HOUR} | {within} | |')
    text = read(ref, 'README.md')
    # The notes end at the rule after their list, and a note's own number is a note marker, not counted.
    listed = re.split(r'\n---\n', part(text, r'^### Notes', r'^## '))[0]
    notes = [re.sub(r'^\d+\.\s+', '', n) for n in re.split(r'\n(?=\d+\. <a id="note-)', listed) if 'note-' in n]
    sizes = [count(n)[0] for n in notes]
    if sizes:
        print(f'\nThe opening\'s notes: {len(sizes)}, {sum(sizes):,} words; median {statistics.median(sizes):.0f}, '
              f'largest {max(sizes):,}; {sum(s > 300 for s in sizes)} over 300 (three minutes).')


if __name__ == '__main__':
    main(sys.argv[1] if len(sys.argv) > 1 else None)
