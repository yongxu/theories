#!/usr/bin/env python3
"""Check the review packet's dossiers: every quotation is the text it claims to be, every Lean name exists.

usage: python3 -B check_dossiers.py [DOSSIER.md ...]   (default: theories/becoming/review/*.md)

Quotation forms (in any dossier):
  原文〔ID〕：「TEXT」          ID a corpus unit id (e.g. MJ-S-089); TEXT must be the unit's text
  原文〔ID1–ID2〕：「TEXT」     consecutive units of one file; TEXT their texts joined
  引〔PATH〕：「TEXT」           PATH a repository file; TEXT must occur in it
  Source [ID]: "TEXT" / Quote [PATH]: "TEXT"   the same, in English dossiers
In TEXT, an ellipsis (…… or ...) marks an omission: each part must occur, in order, and an omission of one or two
characters is reported (it can reverse a sense, as dropping 無 does). Whitespace and Wikisource markup are ignored.

Lean names: every backticked token of the form `«…»` or `A.b` / `a_b` that names a declaration is looked up in the
core package (Becoming/*.lean) and the periphery directories; a token not found is reported.
"""
import csv, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
OUR = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/corpus'
LEAN_DIRS = [ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming',
             ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/physics']
QUOTE = re.compile(r'(原文|引|Source|Quote)\s*[〔\[]([^〕\]]+)[〕\]]\s*[：:]\s*[「"“]([^」"”]+)[」"”]')
TOKEN = re.compile(r'`([^`\s]+)`')


def units():
    out, order = {}, {}
    for p in sorted(OUR.glob('*.tsv')):
        with open(p, encoding='utf-8', newline='') as f:
            rows = list(csv.DictReader(f, delimiter='\t'))
        for k, r in enumerate(rows):
            out[r['id']] = r['text']
            order[r['id']] = (p.stem, k, rows)
    return out, order


def squash(s):
    return re.sub(r'\s+', '', s)


def plain(s):
    """Source text with Wikisource markup taken out: -{X}- (language conversion) becomes X, [[a|b]] becomes b and
    [[a]] becomes a, so a quotation is matched against what a reader of the page sees."""
    s = re.sub(r'-\{([^{}]*)\}-', r'\1', s)
    s = re.sub(r'\[\[(?:[^\]|]*\|)?([^\]]*)\]\]', r'\1', s)
    return s


def occurs(parts, hay):
    """Where the parts occur in order: the list of the gaps between them (None if they do not occur)."""
    pos, gaps, prev_end = 0, [], None
    for part in parts:
        i = hay.find(part, pos)
        if i < 0:
            return None
        if prev_end is not None:
            gaps.append(i - prev_end)
        pos = prev_end = i + len(part)
    return gaps


def declarations():
    names = set()
    for d in LEAN_DIRS:
        for p in d.rglob('*.lean'):
            for m in re.finditer(r'^\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(?:theorem|lemma|def|abbrev|structure|inductive|class|instance|axiom|opaque)\s+([^\s(:{\[]+)', p.read_text(encoding='utf-8'), re.M):
                n = m.group(1)
                names.add(n)
                names.add(n.split('.')[-1])
            for m in re.finditer(r'^\s*\|\s*([A-Za-z_][\w\']*)', p.read_text(encoding='utf-8'), re.M):
                names.add(m.group(1))
    return names


def main(paths):
    text, order = units()
    decls = declarations()
    problems = 0
    for path in paths:
        body = Path(path).read_text(encoding='utf-8')
        for m in QUOTE.finditer(body):
            kind, ref, quote = m.groups()
            parts = [squash(x) for x in re.split(r'……|\.\.\.|…', quote) if squash(x)]
            ref = ref.strip()
            if kind in ('原文', 'Source'):
                ids = [x.strip() for x in re.split(r'[–—~]', ref)]
                if not all(i in text for i in ids):
                    print(f'{path}: unknown unit {ref}'); problems += 1; continue
                f0, k0, rows = order[ids[0]]
                f1, k1, _ = order[ids[-1]]
                if f0 != f1 or k1 < k0:
                    print(f'{path}: range {ref} not consecutive in one file'); problems += 1; continue
                hay = squash(plain(''.join(r['text'] for r in rows[k0:k1 + 1])))
            else:
                p = ROOT / ref.split('#')[0]
                if not p.is_file():
                    print(f'{path}: no file {ref}'); problems += 1; continue
                hay = squash(plain(p.read_text(encoding='utf-8', errors='replace')))
            gaps = occurs(parts, hay)
            if gaps is None:
                print(f'{path}: quotation not found in {ref}: 「{quote[:60]}」'); problems += 1
            elif any(g <= 2 for g in gaps):
                print(f'{path}: an ellipsis in a quotation from {ref} hides only {min(gaps)} character(s), which can change the sense: 「{quote[:60]}」'); problems += 1
        for m in TOKEN.finditer(body):
            t = m.group(1).strip('.,;:()')
            if not ('«' in t or re.fullmatch(r'[A-Za-z][\w\']*(\.[\w\'«»]+)+', t) or re.fullmatch(r'[a-z]+(_[a-z0-9]+)+', t)):
                continue
            if '/' in t or t.endswith(('.md', '.lean', '.py', '.json', '.tsv')):
                continue
            last = t.split('.')[-1]
            if t not in decls and last not in decls:
                print(f'{path}: Lean name not found: {t}'); problems += 1
    print(f'{problems} problem(s)')
    return 1 if problems else 0


if __name__ == '__main__':
    args = sys.argv[1:] or [str(p) for p in sorted((ROOT / 'theories/becoming/review').glob('*.md'))]
    sys.exit(main(args))
