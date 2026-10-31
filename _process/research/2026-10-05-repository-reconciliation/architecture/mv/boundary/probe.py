#!/usr/bin/env python3
"""MV, the boundary field (design probe, draft 3): what the checker cache shows for BOUNDARY-FIELD.md's terms.

python3 -B probe.py CONSTANTS.pickle MEASURE.json MASTER_LAWS.json [--equivalences CHECK.json] [--json OUT]

CONSTANTS is `measure_grammar.py --save`'s dump of the spine run's constants, MEASURE its `--json` report, and
MASTER_LAWS the run's master-laws.json (F5's verified items, for the rule's third clause). CHECK is the output of
tools/research/boundary_check.lean with the eight derived rows' closed sets queried as `equivalences`: where given,
each closed set splits into bridges (equivalences) and support.

It computes the spec's terms (§3.0: generated auxiliaries, reaching, root constants by content, grammar laws,
forwarders, balance anchors) and applies them:
- the grammar laws and their forwarders, with what the predicate leaves out;
- for each distinct central declaration: the grammar laws its statement and proof reach by the measure's walk, where
  balance enters (an anchor in its statement, balance written out, or only in its proof), and the rule's label;
- for U4's eight derived readings: D1 to D5 with the closed set, against the lemmas U4 names;
- D1 to D5 run on every row reaching the grammar without balance in its statement, its whole closed set declared, to
  show how far the mechanical checks tell a case from steps.
A measurement of Lean dependency for the design, not a result.
"""
import collections, json, pickle, re, sys

TERM = 'Becoming.«际»'
WRITTEN_OUT = {'Becoming.Dependence.level', 'Becoming.Flow.taken', 'Becoming.Flow.given'}
FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
# Lean's generated auxiliaries, by their last name component (spec §3.0).
AUX = re.compile(r'^(match_\d+(_\d+)*|_proof_\d+|proof_\d+|eq_\d+|eq_def|sizeOf_spec|_sizeOf_\d+|_sizeOf_inst|injEq|inj|'
                 r'brecOn|below|binductionOn|casesOn|recOn|rec|noConfusion|noConfusionType|ctorIdx|toCtorIdx|'
                 r'ctorElim|ctorElimType|splitter|_unsafe_rec|_sunfold|_flat_ctor|_aux_\d+|_default|elim)$')
# U4's eight derived readings (DESIGN-BOUNDARY.md §3 on branch u4-edge, fe2a1942b): row -> (law, the lemmas U4 names).
EIGHT = {
    'Becoming.Flow.beyond_gives_nothing': ('Becoming.«所闭之界»', ['Becoming.eq_zero_of_not_pos']),
    'Becoming.Flow.withinSystem_of_withinInfluence': ('Becoming.«所闭之单调»', ['Becoming.Flow.shares_of_affectedBy']),
    'Becoming.Law.drawn_iff_not_returns': ('Becoming.«定后有后则入当且仅当不返»',
                                          ['Becoming.Law.drawn_iff_drawnIn', 'Becoming.Law.absorbing_iff_closed',
                                           'Becoming.Law.reaches_iff_orbit', 'Becoming.Law.returns_iff_reaches']),
    'Becoming.Law.lossless_iff_returns': ('Becoming.«有限遍后定后则定前当且仅当皆返»',
                                         ['Becoming.Law.lossless_iff_fixedBefore', 'Becoming.Law.returns_iff_reaches']),
    'Becoming.Learning.goAlike_iff_lumped': ('Becoming.«像定后当且仅当同行»',
                                             ['Becoming.goAlikeUnder_iff_alike', 'Becoming.Learning.lumped_iff_fixed_image']),
    'Becoming.Tolerance.answers_restores_iff': ('Becoming.«承之迭»', ['Becoming.Withholding.chain_iff_steps']),
    'Becoming.Withholding.withholding_spreads': ('Becoming.«存承之迭»', ['Becoming.Withholding.within_iff_withinSteps',
                                                                     'Becoming.Withholding.chain_iff_steps']),
    'Becoming.WithinMoves.after_course': ('Becoming.«迭内之接»', ['Becoming.trace_steps', 'Becoming.trace_iff_steps',
                                                                'Becoming.withinMoves_iff_withinSteps']),
}


def arg(flag):
    return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else None


def main():
    C = pickle.load(open(sys.argv[1], 'rb'))
    measure = json.load(open(sys.argv[2]))
    f5 = json.load(open(sys.argv[3]))['central_reach']['rows']
    equivalence = json.load(open(arg('--equivalences')))['equivalence'] if arg('--equivalences') else None
    rows = {}
    for r in measure['rows']:
        rows.setdefault(r['declaration'], r)
    short = lambda n: n.removeprefix('Becoming.')

    def aux(n):
        return bool(AUX.match(n.rsplit('.', 1)[-1]))

    def deps(n):
        return [b for b in list(C[n]['t']) + list(C[n]['v']) if b in C]

    def located(n):
        m = C[n]['m']
        return m == 'Becoming.Prelude' or m.startswith('Becoming.Grammar')

    def closure(names):
        """Everything the constants reach through types and values, all the way down (Init is not in the dump)."""
        seen, stack = set(), [b for b in names if b in C]
        while stack:
            b = stack.pop()
            if b not in seen:
                seen.add(b)
                stack += deps(b)
        return seen

    # Root constants, by content: located in the prelude or a grammar module, with everything their type and value
    # reach (a theorem's proof included) located there too.
    nonroot = {n for n in C if not located(n)}
    users = collections.defaultdict(set)
    for n in C:
        for b in deps(n):
            users[b].add(n)
    stack = list(nonroot)
    while stack:
        for u in users[stack.pop()]:
            if u not in nonroot:
                nonroot.add(u)
                stack.append(u)
    root = {n for n in C if n not in nonroot}
    # The same by statement alone (a theorem's type; anything else's type and value), draft 2's notion.
    stated = lambda n: list(C[n]['t']) if C[n]['k'] == 'thm' else deps(n)
    nonroot_s = {n for n in C if not located(n)}
    users_s = collections.defaultdict(set)
    for n in C:
        for b in stated(n):
            if b in C:
                users_s[b].add(n)
    stack = list(nonroot_s)
    while stack:
        for u in users_s[stack.pop()]:
            if u not in nonroot_s:
                nonroot_s.add(u)
                stack.append(u)
    proved_off_root = sorted(n for n in C if n not in nonroot_s and n in nonroot)

    def grammar_law(n):
        """OU's location rule with the content tests: a theorem of a grammar module, not an auxiliary, stated and
        proved on the root, whose statement names «际» or another «» term and no closed value."""
        x = C[n]
        if x['k'] != 'thm' or not x['m'].startswith('Becoming.Grammar') or aux(n) or n not in root:
            return False
        cl = closure(x['t'])
        return any('«' in b for b in cl) and not any(C[b].get('cv') for b in cl)

    laws = {n for n in C if grammar_law(n)}

    def walk(n):
        """The run's theorems a proof names: its value walked through definitions and generated auxiliaries,
        stopping at theorems (collected)."""
        out, seen, stack = set(), {n}, list(C[n]['v'])
        while stack:
            b = stack.pop()
            if b not in C or b in seen:
                continue
            seen.add(b)
            if C[b]['k'] == 'thm' and not aux(b):
                out.add(b)
            else:
                stack += deps(b)
        return out

    fw, fk = {}, {}

    def forwarder(n):
        if n in fw:
            return fw[n]
        fw[n] = None
        g = C[n].get('f')
        if g and g in C and walk(n) <= {g}:
            fw[n] = g if g in laws else forwarder(g)
            fk[n] = C[n].get('fk')
        return fw[n]

    for n in C:
        if C[n]['k'] == 'thm':
            forwarder(n)
    forwarders = {n: g for n, g in fw.items() if g and n not in laws}

    def law_of(n):
        return n if n in laws else forwarders.get(n)

    def reach(n):
        """The measure's walk: from the declaration through every constant its type and proof use, stopping only at
        «» names; the grammar laws among them, and those forwarded to."""
        out, seen, stack = set(), {n}, deps(n)
        while stack:
            b = stack.pop()
            if b in seen:
                continue
            seen.add(b)
            if law_of(b):
                out.add(law_of(b))
            if '«' in b:
                continue
            stack += deps(b)
        return out

    anchors = {a for a in measure.get('anchors_reach_grammar', {}).get('balance', {}) if '«' not in a} or set(FLOW)

    def closed_set(row):
        """Spec §3.1 D2: the lemmas the row's proof needs declared, the laws it uses, the root theorems it names
        (entered, so a law a helper applies is seen) and whether its closure holds a balance anchor (D5)."""
        need, used, helpers, seen, stack = set(), set(), set(), {row}, [row]
        while stack:
            for b in walk(stack.pop()):
                if b in seen:
                    continue
                seen.add(b)
                if law_of(b):
                    used.add(law_of(b))
                elif b in root:
                    helpers.add(b)
                    stack.append(b)
                else:
                    need.add(b)
                    stack.append(b)
        balance = sorted(closure([row]) & anchors)
        return need, used, helpers, balance

    grammar_named = [n for n in C if C[n]['k'] == 'thm' and '«' in n.rsplit('.', 1)[-1]]
    left_out = collections.Counter()
    examples = collections.defaultdict(list)
    for n in grammar_named:
        if n in laws:
            continue
        why = ('generated auxiliary' if aux(n) else 'declared off the grammar modules' if not C[n]['m'].startswith('Becoming.Grammar')
               else 'proved or stated off the root' if n not in root
               else 'names a closed value' if any(C[b].get('cv') for b in closure(C[n]['t']))
               else 'names no «» term')
        left_out[why] += 1
        if len(examples[why]) < 8:
            examples[why].append(short(n))
    added = sorted(short(n) for n in laws if '«' not in n.rsplit('.', 1)[-1])
    off_grammar_modules = collections.Counter(C[n]['m'] for n in grammar_named if not C[n]['m'].startswith('Becoming.Grammar'))

    def rule(n, reached, written_out, in_statement):
        if in_statement or written_out:
            return 'balance in its statement'
        if rows[n]['dependence'] == 'grammar':
            return 'connected'
        items = f5.get(n, [])
        if any(set(i['models']) & {'occurrence', 'process'} for i in items):
            return 'at a represented model'
        if items:
            return 'own carrier'
        return 'unplaced'

    table = []
    for n, r in sorted(rows.items()):
        S = closure(C[n]['t'])
        D = closure([n])
        in_statement = [short(a) for a in FLOW if a in S]
        written_out = WRITTEN_OUT <= set(C[n]['t'])
        reached = reach(n)
        row = {'declaration': short(n), 'dependence': r['dependence'], 'category': r['category'],
               'grammar_laws_reached': sorted(map(short, reached)),
               'balance': {'anchor_in_statement': in_statement, 'written_out': written_out,
                           'proof_only': sorted(short(a) for a in anchors if a in D and a not in S)},
               'forwarder': [short(forwarders[n]), fk.get(n)] if n in forwarders else None}
        row['rule'] = rule(n, reached, written_out, in_statement)
        if r['dependence'] == 'grammar' and row['rule'] == 'connected':
            need, used, helpers, balance = closed_set(n)
            row['closed_set'] = {'lemmas': sorted(map(short, need)), 'laws_used': sorted(map(short, used)),
                                 'root_theorems_named': sorted(map(short, helpers)),
                                 'balance_anchors_in_closure': sorted(map(short, balance))}
        if n in EIGHT:
            y, named = EIGHT[n]
            need, used, helpers, balance = closed_set(n)
            e = {'law': short(y), 'D1_law_is_grammar_law': y in laws, 'D3_law_reached': y in used,
                 'D5_no_balance_anchor': not balance, 'laws_used': sorted(map(short, used)),
                 'closed_set': sorted(map(short, need)), 'u4_names': sorted(map(short, named)),
                 'in_closed_set_not_named': sorted(short(b) for b in need if b not in named),
                 'named_not_in_closed_set': sorted(short(b) for b in named if b not in need),
                 'root_theorems_named': sorted(map(short, helpers))}
            if equivalence is not None:
                e['bridges'] = sorted(short(b) for b in need if equivalence.get(b))
                e['support'] = sorted(short(b) for b in need if not equivalence.get(b))
            row['eight'] = e
        table.append(row)
    grammar_rows = [x for x in table if x['dependence'] == 'grammar']
    # D1 to D5 with each row's whole closed set declared, Y any law it uses.
    steps_pass = [x['declaration'] for x in table if 'closed_set' in x and x['closed_set']['laws_used']
                  and not x['closed_set']['balance_anchors_in_closure']]
    summary = {
        'run': sys.argv[sys.argv.index('--run') + 1] if '--run' in sys.argv else None,
        'constants': len(C), 'root_constants': len(root),
        'root_by_statement_but_proved_off_the_root': [short(n) for n in proved_off_root],
        'located_in_grammar_or_prelude_but_off_the_root': sum(located(n) and n not in root for n in C),
        'theorems_with_a_grammar_name': len(grammar_named), 'grammar_laws': len(laws),
        'grammar_laws_without_a_grammar_name': added,
        'grammar_named_left_out': dict(left_out), 'left_out_examples': dict(examples),
        'grammar_named_off_the_grammar_modules': dict(off_grammar_modules),
        'forwarders_of_grammar_laws': sorted(f'{short(n)} -> {short(g)} ({fk.get(n)})' for n, g in forwarders.items()),
        'balance_anchors': sorted(map(short, anchors)),
        'central_declarations': len(table),
        'grammar_rows': len(grammar_rows),
        'grammar_rows_reaching_a_grammar_law': sum(bool(x['grammar_laws_reached']) for x in grammar_rows),
        'grammar_rows_reaching_none': [x['declaration'] for x in grammar_rows if not x['grammar_laws_reached']],
        'rows_that_are_forwarders': [x['declaration'] for x in table if x['forwarder']],
        'rule': dict(collections.Counter(x['rule'] for x in table)),
        'balance_in_statement': {'anchor': sum(bool(x['balance']['anchor_in_statement']) for x in table),
                                 'written_out_only': [x['declaration'] for x in table if x['balance']['written_out']
                                                      and not x['balance']['anchor_in_statement']]},
        'connected_rows_passing_D1_to_D5_with_their_whole_closed_set': [len(steps_pass), sum('closed_set' in x for x in table)],
        'eight': {x['declaration']: x['eight'] for x in table if 'eight' in x},
    }
    out = {'summary': summary, 'rows': table}
    if '--json' in sys.argv:
        open(arg('--json'), 'w').write(json.dumps(out, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: v for k, v in summary.items() if k != 'eight'}, indent=1, ensure_ascii=False))
    for d, e in summary['eight'].items():
        print(d, json.dumps(e, ensure_ascii=False))


if __name__ == '__main__':
    main()
