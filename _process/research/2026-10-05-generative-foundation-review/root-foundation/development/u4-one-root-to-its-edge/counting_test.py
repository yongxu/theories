#!/usr/bin/env python3
"""U4b: where counting ends, on the constants of one core run.

python3 -B counting_test.py DUMP [--json OUT]

DUMP is the constants dump `measure_grammar.py --save` writes (ou3b-master-laws-on-the-grammar). For each central
declaration the boundary record places at counting or at amounts, the script walks its statement (the constants its
type names, with the definitions those unfold to, never a theorem's proof: boundary_table.py's statement_closure) and
reports what it reaches:

- the dynamics' terms: constants in the namespaces of the dynamics' carriers (DYNAMICS below: a web, its dependences
  and its webs at a time, a flow, a world, a law and its runs, an exchange and an exchange law, the amounts module);
- the dynamics' amounts among them: those carriers' natural-number fields (AMOUNT below: levels, needs, giving and
  taking).

The line it supports (COUNTING-AND-AMOUNTS.md): a row is counting when its statement says nothing of the dynamics (as
a hypothesis, in its conclusion or through a run's states) beyond the arbitrary predicate of a counting law, and holds
for every carrier, listing, map and parameter it quantifies over. A row reaching nothing of the
dynamics is counting; a row reaching the dynamics is not, unless a reading (READ below, with its reason) finds the
dynamics only as a counting law's predicate. This is a name test by namespace, so it supports readings and does not
settle them (BOUNDARY-FIELD.md §3.4): DYNAMICS and AMOUNT are a stated list, the theory's vocabulary for the dynamics
and lever 2's model constants (LEVER-2-AUDIT.md §2), not a measurement.
"""
import json
import pickle
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
DYNAMICS = re.compile(r'Becoming\.(Web|WebAt|Dependence|Flow|World|Law|Run|Exchange|ExchangeLaw|Amounts|Frame)(\.|$)|'
                      r'Generative\.')
AMOUNT = re.compile(r'Becoming\.(Dependence\.(level|need)|Flow\.(give|given|take|taken)|ExchangeLaw\.(give|take|levels)|'
                    r'Amounts\..*)$')
# Rows a reading decides, with its reason: the test reaches the dynamics in each, and the reading says how.
READ = {
    'CensusWebs.keep_pace': ('counting', 'the dynamics only as the predicate CountsAcross.keep_pace is applied to'),
    'RegimeMargin.ends_iff_below': ('amounts', 'Law.run, a law\'s run, whose states are natural numbers'),
    'RegimeMargin.Adjusted.ends_iff_below': ('amounts', 'Law.run, a law\'s run, whose states are pairs of natural numbers'),
}


def closure(C, n):
    seen, stack = set(), list(C[n]['t'])
    while stack:
        x = stack.pop()
        if x in seen or x not in C:
            continue
        seen.add(x)
        stack += list(C[x]['t']) + (list(C[x]['v']) if C[x]['k'] in ('def', 'ind', 'ctor', 'rec') else [])
    return seen


def main():
    C = pickle.load(open(sys.argv[1], 'rb'))
    record = json.loads((ROOT / 'theories/becoming/results/records/one-root-to-its-edge.json').read_text(encoding='utf-8'))
    rows = []
    for e in record['boundary']['standings']:
        if e['standing'] not in ('counting', 'amounts'):
            continue
        n = 'Becoming.' + e['declaration'] if not e['declaration'].startswith('Becoming.') else e['declaration']
        S = closure(C, n)
        dyn = sorted(x.removeprefix('Becoming.') for x in S if DYNAMICS.match(x))
        amt = sorted(x.removeprefix('Becoming.') for x in S if AMOUNT.match(x))
        d = n.removeprefix('Becoming.')
        test = 'the dynamics' if dyn else 'nothing of the dynamics'
        by = READ.get(d)
        rows.append({'declaration': d, 'standing': e['standing'], 'test': test,
                     'reading': ({'standing': by[0], 'reason': by[1]} if by else None),
                     'dynamics_terms': dyn, 'dynamics_amounts': amt})
    for r in rows:
        expected = r['reading']['standing'] if r['reading'] else ('counting' if r['test'] == 'nothing of the dynamics'
                                                                  else 'amounts')
        mark = ('  (reading)' if r['reading'] else '') + ('' if r['standing'] == expected else '  <- differs')
        print(f"{r['standing']:9} {r['test']:23} {r['declaration']:45} {', '.join(r['dynamics_amounts'][:4])}{mark}")
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(rows, indent=1, ensure_ascii=False) + '\n',
                                                                encoding='utf-8')


if __name__ == '__main__':
    main()
