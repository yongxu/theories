#!/usr/bin/env python3
"""U4, lever 1: which balance anchor each "balance, represented" row of the grammar measure rests on.

python3 -B anchor_recount.py ROOT [--json OUT]

ROOT is a checkout whose package sources are in the checker cache (run check_becoming.py there first).
Restores the spine run through THEOREM-CONNECTIVITY.py's dump, as the EC measure does (nothing is
compiled), takes the rows whose category is "balance, represented" from
gw-generation-and-widening/measure-grammar-after.json, and reports, for each, which of the measure's
four balance anchors its type and proof reach. A measurement of Lean dependency only.
"""
import importlib.util, json, os, sys
from pathlib import Path

ANCHORS = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween',
           'Becoming.balance_over_stretch_on']
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation'


def main():
    root = Path(sys.argv[1]).resolve()
    measure = json.loads((root / DEV / 'development/gw-generation-and-widening/measure-grammar-after.json')
                         .read_text())
    rows = [r for r in measure['rows'] if r['category'] == 'balance, represented']
    spec = importlib.util.spec_from_file_location('tc', root / DEV / 'THEOREM-CONNECTIVITY.py')
    tc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tc)
    os.chdir(root)
    C = tc.dump_constants()[0]
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}

    def above(n):
        seen, stack = {n}, [n]
        while stack:
            for b in deps.get(stack.pop(), ()):
                if b in C and b not in seen:
                    seen.add(b)
                    stack.append(b)
        return seen

    out = []
    for r in rows:
        A = above(r['declaration'])
        out.append({'row': r['row'], 'declaration': r['declaration'],
                    'anchors': [a.removeprefix('Becoming.') for a in ANCHORS if a in A],
                    'states': [a.removeprefix('Becoming.') for a in ANCHORS
                               if a in set(C.get(r['declaration'], {}).get('t', ()))]})
    tally = {}
    for x in out:
        key = ' + '.join(x['anchors']) or 'none'
        tally[key] = tally.get(key, 0) + 1
    report = {'rows': len(out), 'by_anchors': tally, 'declarations': out}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({'rows': len(out), 'by_anchors': tally}, ensure_ascii=False))


if __name__ == '__main__':
    main()
