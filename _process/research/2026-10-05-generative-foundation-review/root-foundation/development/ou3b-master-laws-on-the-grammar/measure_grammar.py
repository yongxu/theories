#!/usr/bin/env python3
"""OU3b measure: which central declarations reach the grammar, and through which master law.

python3 -B measure_grammar.py [--dump PICKLE] [--save PICKLE] [--json OUT]

Uses EC's measure (../ec-elegant-completion/measure.py) to restore the spine's constants from the
checker cache (nothing is compiled), then, for every declaration COVERAGE.json lists as central,
reports whether its type or proof reaches a grammar constant (a declaration of a module named
Becoming.Grammar*, recognised by its «» name or by the grammar's instance names listed below),
and, for each master law, whether the law's anchors themselves reach the grammar. A measurement of
Lean dependency only: reaching the grammar says a grammar law is among the declaration's reasons.

Each central declaration also gets one category (OU3c, 28 October 2026): `grammar` where it reaches the
grammar; `balance, represented` where it does not and rests on balance, whose grammar form represents
it both ways but which the grammar cannot state without amounts (OU3b's decision F13), so its
consumers are not a gap; `anchor, not reached` where it rests on another master law's anchor and does
not reach the grammar; `no master law` where it rests on none. The headline counts what is a gap:
the last two categories, among distinct declarations (nine stand in two rows of COVERAGE).
"""
import importlib.util, json, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('ec', HERE.parent / 'ec-elegant-completion/measure.py')
ec = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ec)


# Why each central declaration resting on an anchor does not reach the grammar, where it is no case of a
# grammar law (OU3c, 28 October 2026; ../ou3c-anchors-on-the-grammar/AUDIT.md). EC6 takes the widening
# laws' content as input. A declaration in `anchor, not reached` with no reason here is reported.
REASONS = {
    'Becoming.Web.paths_extension_iff_widens': "C's extension on a web's paths: a reindexing of claims (formation, step) "
                                               "to admissions (step, formation), every claim counted; widening enters by "
                                               "its definition, its order laws already from the grammar",
    'Becoming.Direction.extension_iff_widens': "C's extension on paths, on the moves' frame "
                                               "(Web.paths_extension_iff_widens)",
    'Becoming.Web.paths_comparison_widens': "C's extension on paths, one direction, for every reading of living",
    'Becoming.Web.paths_one_object': "the conjunction of C's extension on paths, the continuation condition as living "
                                     "significance, and the reduction of significance under the condition",
    'Becoming.Web.widens_iff_retains_adds': "the reduction of what has significance to what can form under the "
                                            "continuation condition; the free significance is not lifted to the root",
    'Becoming.Weighting.widens_iff_every_positive': "weights: widening is what every positive weighting ranks higher; "
                                                    "the grammar has no weights",
}


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
    categories = {}
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
            category = ('grammar' if g else 'balance, represented' if 'balance' in hit
                        else 'anchor, not reached' if hit else 'no master law')
            categories[dn] = category
            row = {'row': r['id'], 'declaration': dn, 'grammar': g, 'laws': hit, 'category': category}
            if category == 'anchor, not reached':
                row['reason'] = REASONS.get(dn, 'NO REASON GIVEN')
            rows.append(row)
    by_category = {c: sum(1 for v in categories.values() if v == c)
                   for c in ('grammar', 'balance, represented', 'anchor, not reached', 'no master law')}
    report = {'central_declarations': total, 'reaching_the_grammar': len(reach),
              'distinct_central_declarations': len(categories), 'distinct_by_category': by_category,
              'distinct_gaps': by_category['anchor, not reached'] + by_category['no master law'],
              'anchor_not_reached_reasons': {dn: REASONS.get(dn, 'NO REASON GIVEN') for dn, c in categories.items()
                                             if c == 'anchor, not reached'},
              'by_master_law_resting_and_reaching_grammar': by_law, 'anchors_reach_grammar': anchor_reach,
              'rows': rows}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: report[k] for k in ('central_declarations', 'reaching_the_grammar',
                                             'distinct_central_declarations', 'distinct_by_category',
                                             'distinct_gaps', 'anchor_not_reached_reasons',
                                             'by_master_law_resting_and_reaching_grammar',
                                             'anchors_reach_grammar')},
                     ensure_ascii=False))


if __name__ == '__main__':
    main()
