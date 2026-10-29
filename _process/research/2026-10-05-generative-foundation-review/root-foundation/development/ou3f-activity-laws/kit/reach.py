#!/usr/bin/env python3
"""OU3f: for each theorem reading only `active` (data/active-only.json), which grammar theorems (constants named with
«», of kind thm) its proof reaches, directly (in its value) and transitively (through any constants), and whether its
statement names a grammar term. Reads the dependency audit's dump.jsonl (dump.py's output); writes data/reach.json.
usage (from the checkout root): python3 -B <kit>/reach.py DUMPDIR"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
dump = Path(sys.argv[1]) / 'dump.jsonl'
deps, kind, module = {}, {}, {}
with dump.open(encoding='utf-8') as f:
    for line in f:
        x = json.loads(line)
        if 'n' not in x:
            continue
        deps[x['n']] = (set(x.get('t', [])), set(x.get('v', [])))
        kind[x['n']] = x.get('k')
        module[x['n']] = x.get('m')
A = json.loads((HERE.parent / 'data/active-only.json').read_text(encoding='utf-8'))


def grammar_thm(n):
    return '«' in n and kind.get(n) == 'thm'


memo = {}


def closure(n):
    if n in memo:
        return memo[n]
    seen, stack = set(), [n]
    while stack:
        c = stack.pop()
        if c in seen:
            continue
        seen.add(c)
        t, v = deps.get(c, (set(), set()))
        stack.extend(t | v)
    memo[n] = seen
    return seen


out = {}
for n in A:
    t, v = deps.get(n, (set(), set()))
    direct = sorted(c for c in v if grammar_thm(c))
    trans = set()
    for c in v:
        trans |= {d for d in closure(c) if grammar_thm(d)}
    out[n] = {'statement_names_grammar': any('«' in c for c in t), 'direct': direct,
              'transitive_count': len(trans), 'transitive': sorted(trans)[:12]}
(HERE.parent / 'data/reach.json').write_text(json.dumps(out, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
reach = sum(1 for o in out.values() if o['transitive_count'])
print('theorems', len(out), '; proof reaches a grammar theorem:', reach, '; directly:', sum(1 for o in out.values() if o['direct']),
      '; statement names a grammar term:', sum(1 for o in out.values() if o['statement_names_grammar']))
