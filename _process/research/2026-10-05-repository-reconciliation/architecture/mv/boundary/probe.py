#!/usr/bin/env python3
"""MV, the boundary field (design probe): what the checker cache shows about the central declarations.

python3 -B probe.py CONSTANTS.pickle MEASURE.json [--json OUT]

CONSTANTS is `measure_grammar.py --save`'s dump of the spine run's constants; MEASURE its `--json` report.
For each distinct central declaration it reports:
- the grammar theorems its type and proof reach, grammar constants not expanded (U4's point 2);
- where balance enters, in the statement or only in the proof (U4's point 3);
- the case-of test at three strengths (design §2): the Becoming theorems its own proof names, sorted into grammar,
  prelude, theorems proved from definitions alone (level 0), theorems proved from those (level 1) and the rest.
A measurement of Lean dependency for the design, not a result.
"""
import collections, json, pickle, sys

FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRELUDE_LAW = 'Becoming.balance_over_stretch_on'


def main():
    C = pickle.load(open(sys.argv[1], 'rb'))
    measure = json.load(open(sys.argv[2]))
    rows = {}
    for r in measure['rows']:
        rows.setdefault(r['declaration'], r)
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}

    def grammar(n):
        """A grammar constant, or a pure forwarder of a grammar theorem (the dump's `f`): that law at a model's terms."""
        if '«' in n or C[n]['m'].startswith('Becoming.Grammar'):
            return True
        f = C[n].get('f')
        return bool(f) and f in C and ('«' in f or C[f]['m'].startswith('Becoming.Grammar'))

    def grammar_only(n):
        """Whether a theorem's statement names nothing but grammar and prelude constants."""
        return all('«' in x or C[x]['m'].startswith('Becoming.Grammar') or C[x]['m'] == 'Becoming.Prelude'
                   for x in statement_closure(n))

    def prelude(n):
        return C[n]['m'] == 'Becoming.Prelude'

    def becoming_thms(xs):
        return {b for b in xs if b in C and C[b]['k'] == 'thm'}

    level = {}

    def lvl(n):
        """0: the proof names no Becoming theorem but grammar or prelude ones; k: only theorems of level < k."""
        if n in level:
            return level[n]
        level[n] = 99
        inner = [b for b in becoming_thms(C[n]['v']) if not grammar(b) and not prelude(b)]
        level[n] = 0 if not inner else 1 + max(lvl(b) for b in inner)
        return level[n]

    def statement_closure(n):
        seen, stack = set(), list(C[n]['t'])
        while stack:
            x = stack.pop()
            if x in seen or x not in C:
                continue
            seen.add(x)
            stack += list(C[x]['t']) + (list(C[x]['v']) if C[x]['k'] in ('def', 'ind', 'ctor', 'rec') else [])
        return seen

    def proof_closure(n):
        seen, stack = {n}, [n]
        while stack:
            for b in deps.get(stack.pop(), ()):
                if b in C and b not in seen:
                    seen.add(b)
                    stack.append(b)
        return seen

    def grammar_theorems(n):
        seen, stack, thm = {n}, [n], set()
        while stack:
            for b in deps.get(stack.pop(), ()):
                if b in C and b not in seen:
                    seen.add(b)
                    if grammar(b):
                        if C[b]['k'] == 'thm':
                            thm.add(b)
                        continue
                    stack.append(b)
        return thm

    out, tally = [], collections.Counter()
    init_in_level0 = collections.Counter()
    for n, r in sorted(rows.items()):
        S, P = statement_closure(n), proof_closure(n)
        gth = grammar_theorems(n)
        own = becoming_thms(C[n]['v'])
        sort = {'grammar': sorted(b for b in own if grammar(b)), 'prelude': sorted(b for b in own if prelude(b)),
                'level 0': [], 'level 1': [], 'above': []}
        for b in sorted(own):
            if grammar(b) or prelude(b):
                continue
            k = lvl(b)
            sort['level 0' if k == 0 else 'level 1' if k == 1 else 'above'].append(b)
            if k == 0:
                init_in_level0.update(x for x in C[b]['v'] if x not in C)
        laws = [b for b in sort['grammar'] if grammar_only(C[b].get('f') or b)]
        sort['grammar laws, statement grammar-only'] = laws
        sort['forwarded'] = {b: C[b]['f'] for b in sort['grammar'] if C[b].get('f')}
        strength = ('a forwarder of a grammar law' if C[n].get('f') and grammar(n)
                    else 'as is: grammar laws and level-0 lemmas' if laws and not sort['level 1'] and not sort['above']
                    else 'up to level 1' if laws and not sort['above'] else 'no')
        bal = ('statement' if any(a in S for a in FLOW) else 'proof' if any(a in P for a in FLOW)
               else 'prelude law only' if PRELUDE_LAW in P else 'none')
        tally[(r['dependence'], strength)] += 1
        out.append({'declaration': n, 'dependence': r['dependence'], 'grammar_theorems_reached': sorted(gth),
                    'balance': bal, 'own_proof': sort, 'case_of_as_is': strength})
    grammar_rows = [x for x in out if x['dependence'] == 'grammar']
    summary = {
        'distinct': len(out),
        'grammar rows reaching a grammar theorem': sum(bool(x['grammar_theorems_reached']) for x in grammar_rows),
        'grammar rows': len(grammar_rows),
        'balance among balance-represented rows': collections.Counter(
            x['balance'] for x in out if x['dependence'] == 'balance, represented'),
        'balance among grammar rows': collections.Counter(x['balance'] for x in grammar_rows),
        'case-of as is, by dependence': {f'{d} / {s}': c for (d, s), c in sorted(tally.items())},
        'Init constants in level-0 lemmas these proofs name': init_in_level0.most_common(40),
    }
    print(json.dumps(summary, indent=1, ensure_ascii=False, default=dict))
    if '--json' in sys.argv:
        json.dump({'summary': summary, 'rows': out}, open(sys.argv[sys.argv.index('--json') + 1], 'w'),
                  indent=1, ensure_ascii=False, default=dict)


if __name__ == '__main__':
    main()
