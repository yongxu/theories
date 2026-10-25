#!/usr/bin/env python3
"""OU3b measure: which central declarations reach the grammar, and through which master law.

python3 -B measure_grammar.py [--dump PICKLE] [--save PICKLE] [--json OUT]

Uses EC's measure (../ec-elegant-completion/measure.py) to restore the spine's constants from the
checker cache (nothing is compiled), then, for every declaration COVERAGE.json lists as central,
reports whether its type or proof reaches a grammar constant (a declaration of a module named
Becoming.Grammar*, recognised by its «» name or by the grammar's instance names listed below),
and, for each master law, whether the law's anchors themselves reach the grammar. A measurement of
Lean dependency only: reaching the grammar says a grammar law is among the declaration's reasons.
"""
import importlib.util, json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('ec', HERE.parent / 'ec-elegant-completion/measure.py')
ec = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ec)


def is_grammar(name):
    return '«' in name


def main():
    C = ec.constants()
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}

    def above(n):
        seen, stack = {n}, [n]
        while stack:
            for b in deps.get(stack.pop(), ()):
                if b in C and b not in seen:
                    seen.add(b)
                    stack.append(b)
        return seen
    laws = {k: [a for a in v if a in C] for k, v in ec.LAWS.items()}
    anchor_reach = {k: {a: any(is_grammar(b) for b in above(a)) for a in v} for k, v in laws.items()}
    total, reach, by_law = 0, [], {k: [0, 0] for k in laws}
    rows = []
    for r in json.loads(ec.COVERAGE.read_text())['rows']:
        for dn in r['declarations']:
            A = above(dn) if dn in C else set()
            g = any(is_grammar(b) for b in A)
            hit = [k for k, v in laws.items() if any(a in A for a in v)]
            total += 1
            reach += [dn] if g else []
            for k in hit:
                by_law[k][0] += 1
                by_law[k][1] += 1 if g else 0
            rows.append({'row': r['id'], 'declaration': dn, 'grammar': g, 'laws': hit})
    report = {'central_declarations': total, 'reaching_the_grammar': len(reach),
              'by_master_law_resting_and_reaching_grammar': by_law, 'anchors_reach_grammar': anchor_reach,
              'rows': rows}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: report[k] for k in ('central_declarations', 'reaching_the_grammar',
                                             'by_master_law_resting_and_reaching_grammar', 'anchors_reach_grammar')},
                     ensure_ascii=False))


if __name__ == '__main__':
    main()
