#!/usr/bin/env python3
"""Check the review packet's dossiers: every quotation is the text it claims to be, every Lean name exists, every
Lean statement copied into a fenced block is still the source's.

usage: python3 -B check_dossiers.py [DOSSIER.md ...]   (default: theories/becoming/review/*.md)

Quotation forms (in any dossier):
  原文〔ID〕：「TEXT」          ID a corpus unit id (e.g. MJ-S-089); TEXT must be the unit's text
  原文〔ID1–ID2〕：「TEXT」     consecutive units of one file; TEXT their texts joined
  引〔PATH〕：「TEXT」           PATH a repository file; TEXT must occur in it
  Source [ID]: "TEXT" / Quote [PATH]: "TEXT"   the same, in English dossiers
In TEXT, an ellipsis (…… or ...) marks an omission: each part must occur, in order, and an omission of one or two
characters is reported (it can reverse a sense, as dropping 無 does). Whitespace and Wikisource markup are ignored.

Lean names: every backticked token of the form `«…»` or `A.b` / `a_b` that names a declaration is looked up in the
core package (Becoming/*.lean) and the periphery directories the dossiers cite (physics, warning); a token not found is
reported.

Lean blocks: each declaration in a ```lean block, whitespace and comments aside, must occur in those sources, the older
modules or the review scripts the dossiers name: a definition whole, to its last line, and a theorem whole or up to its
proof. A name that still exists can have a statement that changed; this is what catches it.
"""
import csv, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[6]
OUR = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/one-unfolding-root/corpus'
LEAN_DIRS = [ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming',
             ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/physics',
             ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/warning']
QUOTE = re.compile(r'(原文|引|Source|Quote)\s*[〔\[]([^〕\]]+)[〕\]]\s*[：:]\s*[「"“]([^」"”]+)[」"”]')
TOKEN = re.compile(r'`([^`\s]+)`')
BLOCK_DIRS = LEAN_DIRS + [ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/deeper',
                          OUR.parent / 'review-checks']
DECL = r'(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+|partial\s+|unsafe\s+)*(?:theorem|lemma|def|abbrev|structure|inductive|class|instance|axiom|opaque|example)\s'


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


MARGIN = '\x00'


def uncommented(text):
    text = re.sub(r'/-.*?-/', '', text, flags=re.S)
    return '\n'.join(re.sub(r'(^|\s)--\s.*$', '', line) for line in text.split('\n'))


def marked(text):
    """Squashed, with a mark before each line that starts at the margin, so that a declaration's end can be seen."""
    return squash(re.sub(r'\n(?=\S)', MARGIN, text))


def lean_sources():
    return marked('\n'.join(uncommented(p.read_text(encoding='utf-8', errors='replace'))
                            for d in BLOCK_DIRS for p in d.rglob('*.lean')) + '\nend')


def block_declarations(block):
    """A fenced block's declarations, its comments taken out."""
    block = uncommented(block)
    starts = [m.start() for m in re.finditer(r'^\s*' + DECL, block, re.M)]
    return [block[a:b].strip() for a, b in zip(starts, starts[1:] + [len(block)])]


def stated_to_its_proof(decl, sources):
    """A statement left whole and followed in the source by its proof, not a prefix of it. It may hold a `:=` of its own
    (`let x := …`), so the text is not cut there."""
    stated = decl.rstrip().removesuffix(':=').rstrip()
    closed = all(stated.count(a) == stated.count(b) for a, b in ('()', '{}', '[]', '⟨⟩'))
    return (closed and not re.search(r'\blet\s+\S+$', stated)
            and any(marked(stated) + end in sources for end in (':=', '|', 'where')))


def main(paths):
    text, order = units()
    decls = declarations()
    sources = lean_sources()
    problems = 0
    for path in paths:
        body = Path(path).read_text(encoding='utf-8')
        for m in re.finditer(r'```lean4?\n(.*?)```', body, re.S):
            found = block_declarations(m.group(1))
            if not found:
                print(f'{path}: Lean block with no declaration: {m.group(1)[:50]!r}'); problems += 1
            for decl in found:
                head = re.search(DECL + r'\s*([^\s(:{\[]+)', decl)
                holds = marked(decl) + MARGIN in sources  # whole, to its last line
                if not holds and re.search(DECL, decl).group(0).split()[-1] in ('theorem', 'lemma'):
                    holds = stated_to_its_proof(decl, sources)
                if not holds:
                    print(f'{path}: Lean block differs from the sources: {head.group(1) if head else decl[:50]}'); problems += 1
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
            if '/' in t or t.endswith(('.md', '.lean', '.py', '.json', '.tsv', '.xlsx')):
                continue
            last = t.split('.')[-1]
            if t not in decls and last not in decls:
                print(f'{path}: Lean name not found: {t}'); problems += 1
    print(f'{problems} problem(s)')
    return 1 if problems else 0


if __name__ == '__main__':
    review = ROOT / 'theories/becoming/review'
    args = sys.argv[1:] or [str(p) for p in sorted(review.glob('*.md')) + [review / 'recoding/CODEBOOK.md']]
    sys.exit(main(args))
