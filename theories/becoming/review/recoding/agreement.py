#!/usr/bin/env python3
"""Agreement between human coders and the AI's classification of the corpus sample.

usage: python3 agreement.py CODER_SHEET.tsv [CODER_SHEET.tsv ...] [--key KEY.tsv] [--out REPORT.md]

Each coder sheet is a filled copy of SHEET.tsv (column `class` filled with one of the codebook's codes; a blank
`class` means the coder left the unit, and the unit is left out of that coder's figures). The key holds the AI's
class and each unit's inclusion probability; by default it is read from the study folder.

Reports, for each coder against the AI: units coded, observed agreement, Cohen's kappa, agreement weighted back to
the whole corpus (each unit weighted by one over its inclusion probability), agreement within each AI class, and the
confusion matrix. With two or more coders: Krippendorff's alpha (nominal) over all coders, and the same with the AI
as one more coder. Standard library only.
"""
import argparse
import csv
import re
import xml.etree.ElementTree as ET
import zipfile
from collections import Counter, defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
KEY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/review-packet/recoding-key.tsv'
CODES = ['甲', '乙', '丙一', '丁', '戊', '己', '庚', '未读出']  # the classes of the AI's brief (classify/BRIEF.md)

QUOTED = HERE / 'QUOTED.txt'


def natural(unit):
    """Order unit ids as their parts read: MJ-S-068.5 before MJ-S-068.10, LZ-56-003 before LZ-56-005."""
    return [(0, int(t), '') if t.isdigit() else (1, 0, t) for t in re.split(r'(\d+)', unit)]


def stem(unit):
    """The id without its last number: units of one range share it."""
    return re.sub(r'\d+$', '', unit)


def quoted_in_dossiers(units):
    """Every sampled unit a dossier quotes: single ids (〔ID〕, Source [ID]) and every unit inside a range
    (〔A–B〕, Source [A–B]), a range taken in the natural order of ids that share its first id's stem."""
    found = set()
    for d in sorted(HERE.parent.glob('*.md')):
        text = d.read_text(encoding='utf-8')
        for a, b in re.findall(r'(?:〔|Source \[)([A-Z0-9][A-Z0-9.-]*?)(?:\s*[–—~]\s*([A-Z0-9][A-Z0-9.-]*?))?(?:〕|\])', text):
            found.add(a)
            if b:
                lo, hi = natural(a), natural(b)
                found |= {u for u in units if stem(u) == stem(a) and lo <= natural(u) <= hi}
    return found & units


def read(path):
    """Rows of a sheet: a UTF-8 tab-separated file, or the .xlsx a coder returns (first worksheet, first row the
    header), read with the standard library."""
    if str(path).endswith('.xlsx'):
        return read_xlsx(path)
    with open(path, encoding='utf-8', newline='') as f:
        return list(csv.DictReader(f, delimiter='\t'))


def read_xlsx(path):
    ns = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
    with zipfile.ZipFile(path) as z:
        shared = []
        if 'xl/sharedStrings.xml' in z.namelist():
            for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('m:si', ns):
                shared.append(''.join(t.text or '' for t in si.iter('{%s}t' % ns['m'])))
        sheets = sorted(n for n in z.namelist() if n.startswith('xl/worksheets/sheet') and n.endswith('.xml'))
        root = ET.fromstring(z.read(sheets[0]))
    table = []
    for row in root.find('m:sheetData', ns).findall('m:row', ns):
        values = {}
        for c in row.findall('m:c', ns):
            ref, kind = c.get('r'), c.get('t')
            column = 0
            for ch in re.match(r'[A-Z]+', ref).group(0):
                column = column * 26 + ord(ch) - 64
            if kind == 'inlineStr':
                text = ''.join(t.text or '' for t in c.iter('{%s}t' % ns['m']))
            else:
                v = c.find('m:v', ns)
                text = '' if v is None else (shared[int(v.text)] if kind == 's' else v.text or '')
            values[column - 1] = text
        table.append([values.get(i, '') for i in range(max(values) + 1)] if values else [])
    header = table[0]
    return [dict(zip(header, r + [''] * (len(header) - len(r)))) for r in table[1:] if any(x.strip() for x in r)]


def kappa(pairs):
    n = len(pairs)
    if not n:
        return None
    po = sum(a == b for a, b in pairs) / n
    ca, cb = Counter(a for a, _ in pairs), Counter(b for _, b in pairs)
    pe = sum(ca[c] * cb[c] for c in set(ca) | set(cb)) / (n * n)
    return None if pe == 1 else (po - pe) / (1 - pe)


def alpha(units):
    """Krippendorff's alpha, nominal, for units given as lists of the values coders gave (blanks left out)."""
    pairable = [vs for vs in units if len(vs) >= 2]
    o = Counter()
    for vs in pairable:
        m = len(vs)
        for i, a in enumerate(vs):
            for j, b in enumerate(vs):
                if i != j:
                    o[(a, b)] += 1 / (m - 1)
    n_c = Counter()
    for (a, _), v in o.items():
        n_c[a] += v
    n = sum(n_c.values())
    if n <= 1:
        return None
    d_o = sum(v for (a, b), v in o.items() if a != b) / n
    d_e = sum(n_c[a] * n_c[b] for a in n_c for b in n_c if a != b) / (n * (n - 1))
    return None if d_e == 0 else 1 - d_o / d_e


def fmt(x):
    return '—' if x is None else f'{x:.3f}'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('sheets', nargs='+')
    ap.add_argument('--key', default=str(KEY))
    ap.add_argument('--out')
    ap.add_argument('--write-quoted', action='store_true',
                    help='freeze the sampled units the dossiers quote into QUOTED.txt and stop')
    args = ap.parse_args()
    key = {r['n']: r for r in read(args.key)}
    if args.write_quoted:
        ids = quoted_in_dossiers({r['id'] for r in key.values()})
        QUOTED.write_text(''.join(i + '\n' for i in sorted(ids, key=natural)), encoding='utf-8')
        print(f'{len(ids)} sampled units quoted in the dossiers, written to {QUOTED.name}')
        return
    # Sampled units the dossiers quote (with the AI's class beside them): a coder who read a dossier first may have
    # seen them, so every figure is also given without them. The list is frozen in QUOTED.txt when the packet is
    # sent (--write-quoted); without that file the dossiers are scanned as they now stand.
    quoted = (set(QUOTED.read_text(encoding='utf-8').split()) if QUOTED.is_file()
              else quoted_in_dossiers({r['id'] for r in key.values()}))
    seen = {n for n, r in key.items() if r['id'] in quoted}
    coders = {}
    for s in args.sheets:
        rows = read(s)
        bad = [r['n'] for r in rows if r['class'].strip() and r['class'].strip() not in CODES]
        if bad:
            raise SystemExit(f'{s}: codes not in the codebook at rows {bad[:10]}')
        coders[Path(s).stem] = {r['n']: r['class'].strip() for r in rows if r['class'].strip()}
    out = ['# Re-coding agreement', '', f'Key: `{args.key}`; {len(key)} units; coders: {", ".join(coders)}. '
           f'{len(seen)} sampled units are quoted in the dossiers; each coder\'s figures are also given without them.', '']
    for name, codes in coders.items():
        rest = [(codes[n], key[n]['ai_class']) for n in codes if n in key and n not in seen]
        pairs = [(codes[n], key[n]['ai_class']) for n in codes if n in key]
        w = [(1 / float(key[n]['inclusion_probability']), codes[n] == key[n]['ai_class']) for n in codes if n in key]
        weighted = sum(x for x, ok in w if ok) / sum(x for x, _ in w) if w else None
        out += [f'## {name} against the AI', '',
                f'Units coded: {len(pairs)}. Observed agreement: {fmt(sum(a == b for a, b in pairs) / len(pairs) if pairs else None)}. '
                f"Cohen's kappa: {fmt(kappa(pairs))}. Agreement weighted to the corpus: {fmt(weighted)}. "
                f"Without the units the dossiers quote: {len(rest)} units, kappa {fmt(kappa(rest))}.", '',
                '| AI class | units | coder agrees |', '|---|---:|---:|']
        by = defaultdict(list)
        for a, b in pairs:
            by[b].append(a == b)
        for c in CODES:
            if by.get(c):
                out.append(f'| {c} | {len(by[c])} | {sum(by[c])} |')
        out += ['', 'Confusion (rows: the AI; columns: the coder):', '', '| | ' + ' | '.join(CODES) + ' |', '|---|' + '---:|' * len(CODES)]
        cm = Counter((b, a) for a, b in pairs)
        for r in CODES:
            if any(cm[(r, c)] for c in CODES):
                out.append(f'| {r} | ' + ' | '.join(str(cm[(r, c)]) for c in CODES) + ' |')
        out.append('')
    if len(coders) >= 2:
        units = [[codes[n] for codes in coders.values() if n in codes] for n in key]
        with_ai = [vs + [key[n]['ai_class']] for vs, n in zip(units, key)]
        out += ['## Among the coders', '', f"Krippendorff's alpha (nominal), coders only: {fmt(alpha(units))}; with the AI as one more coder: {fmt(alpha(with_ai))}.", '']
    text = '\n'.join(out) + '\n'
    if args.out:
        Path(args.out).write_text(text, encoding='utf-8')
    print(text)


if __name__ == '__main__':
    main()
