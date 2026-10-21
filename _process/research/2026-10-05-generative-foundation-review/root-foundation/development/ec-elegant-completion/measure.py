#!/usr/bin/env python3
"""EC measure: which of the master laws each central declaration of the coverage rests on in Lean.

python3 -B measure.py [--dump PICKLE] [--save PICKLE] [--json OUT]

Restores the spine run from the checker cache through THEOREM-CONNECTIVITY.py's dump (nothing is compiled;
run check_becoming.py first), then, for every declaration COVERAGE.json lists as central, follows the
constants its type and proof use and reports which master law's anchors it reaches:
closure (one closure of a relation), balance (a level changes by what is given and taken), return
(within finitely many configurations a law returns or is drawn), order (widening), lumping (a part read
alone carries a law exactly where the rest makes no difference to its next value; proposed by line A, LU1). A measurement of Lean
dependency only: reaching an anchor says the law is a reason the declaration holds, not that the
declaration says nothing else; reaching none says no master law is among its reasons.
"""
import importlib.util, json, os, pickle, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
COVERAGE = ROOT / 'theories/becoming/results/completion/COVERAGE.json'
LAWS = {
    'closure': ['Becoming.WithinClosure'],
    'balance': ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.balance_over_stretch_on'],
    'return': ['Becoming.Branching.Returns', 'Becoming.Branching.Lossless', 'Becoming.revisits_within',
               'Becoming.Amounts.rests', 'Becoming.Amounts.FallsStop'],
    'order': ['Becoming.Web.Widens', 'Becoming.Weighting.WidensOn'],
    'lumping': ['Becoming.GoAlikeUnder'],
}


def constants():
    args = sys.argv[1:]
    if '--dump' in args:
        return pickle.load(open(args[args.index('--dump') + 1], 'rb'))
    p = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY.py'
    spec = importlib.util.spec_from_file_location('tc', p)
    tc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(tc)
    os.chdir(ROOT)
    C = tc.dump_constants()[0]
    if '--save' in args:
        pickle.dump(C, open(args[args.index('--save') + 1], 'wb'))
    return C


def main():
    C = constants()
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}
    laws = {k: [a for a in v if a in C] for k, v in LAWS.items()}

    def above(n):
        seen, stack = {n}, [n]
        while stack:
            for b in deps.get(stack.pop(), ()):
                if b in C and b not in seen:
                    seen.add(b)
                    stack.append(b)
        return seen
    rows, none, total = [], [], 0
    for r in json.loads(COVERAGE.read_text())['rows']:
        out = []
        for dn in r['declarations']:
            A = above(dn) if dn in C else set()
            hit = [k for k, v in laws.items() if any(a in A for a in v)]
            out.append({'declaration': dn, 'laws': hit})
            total += 1
            if not hit:
                none.append(dn)
        rows.append({'row': r['id'], 'declarations': out})
    vocab = set()
    for r in rows:
        for x in r['declarations']:
            n = x['declaration']
            if n in C:
                vocab |= {t for t in C[n]['t'] if t in C and C[t]['k'] in ('def', 'ind')}
    report = {'anchors': laws, 'central_declarations': total, 'resting_on_no_master_law': len(none),
              'none': none, 'defined_notions_in_central_statements': len(vocab), 'rows': rows}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: report[k] for k in ('central_declarations', 'resting_on_no_master_law',
                                             'defined_notions_in_central_statements')}))


if __name__ == '__main__':
    main()
