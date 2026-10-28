#!/usr/bin/env python3
"""EC6 audit helper: for each named declaration, its module, its source block, its direct spine dependencies
(type and value), and the spine definitions its closure rests on.

usage (from the checkout root): python3 -B inspect_decl.py PICKLE NAME [NAME ...] [--closure]"""
import pickle
import re
import sys
from pathlib import Path

PKG = Path('experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
args = [a for a in sys.argv[1:] if not a.startswith('--')]
C = pickle.load(open(args[0], 'rb'))
show_closure = '--closure' in sys.argv


def source_block(name, module):
    f = PKG / (module.replace('.', '/') + '.lean')
    if not f.is_file():
        return f'(no source file {f})'
    lines = f.read_text(encoding='utf-8').split('\n')
    short = name.split('.')[-1]
    pat = re.compile(r'^\s*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(theorem|def|lemma|abbrev|structure|inductive|instance)\s+(?:[\w.«»]+\.)?' + re.escape(short) + r'\b')
    hits = [i for i, l in enumerate(lines) if pat.search(l)]
    out = []
    for i in hits[:3]:
        j = i
        # include a preceding doc comment
        k = i - 1
        while k >= 0 and lines[k].strip() and not lines[k].lstrip().startswith(('theorem', 'def ', 'lemma')):
            k -= 1
            if i - k > 25:
                break
        start = k + 1
        j = i + 1
        while j < len(lines) and not re.match(r'^\s*(?:@\[|/--|theorem |def |lemma |abbrev |structure |inductive |namespace |end |section )', lines[j]):
            j += 1
            if j - i > 60:
                break
        out.append(f'--- {f}:{start + 1}-{j}\n' + '\n'.join(lines[start:j]))
    return '\n'.join(out) if out else f'(not found in {f})'


def closure(n):
    seen, stack = {n}, [n]
    while stack:
        x = C.get(stack.pop())
        if not x:
            continue
        for b in set(x['t']) | set(x['v']):
            if b in C and b not in seen and b.startswith('Becoming'):
                seen.add(b)
                stack.append(b)
    return seen


for n in args[1:]:
    x = C.get(n)
    if not x:
        print(f'== {n}: NOT IN DUMP')
        continue
    print(f'== {n}  [{x["k"]}, {x["m"]}]')
    print(source_block(n, x['m']))
    direct = sorted({b for b in set(x['t']) | set(x['v']) if b.startswith('Becoming') and b in C} - {n})
    print('direct:', ', '.join(f'{b} ({C[b]["k"]}, {C[b]["m"].replace("Becoming.", "")})' for b in direct))
    if show_closure:
        cl = closure(n) - {n}
        defs = sorted(b for b in cl if C[b]['k'] not in ('thm',))
        mods = sorted({C[b]['m'] for b in cl})
        print(f'closure: {len(cl)} constants in {len(mods)} modules; modules: {", ".join(m.replace("Becoming.", "") for m in mods)}')
        print('definitions in closure:', ', '.join(defs[:80]), '...' if len(defs) > 80 else '')
    print()
