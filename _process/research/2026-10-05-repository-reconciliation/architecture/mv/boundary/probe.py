#!/usr/bin/env python3
"""MV, the boundary field (design probe, draft 2): what the checker cache shows for BOUNDARY-FIELD.md's tests.

python3 -B probe.py CONSTANTS.pickle MEASURE.json [--json OUT]

CONSTANTS is `measure_grammar.py --save`'s dump of the spine run's constants; MEASURE its `--json` report.
It computes the spec's terms (§3: generated auxiliaries, root constants, the name test, grammar laws, forwarders,
the theorems a proof names) and applies them:
- the grammar laws and their forwarders, with what the predicate leaves out;
- for each distinct central declaration: the grammar laws its statement and proof reach through its model's content
  (U4's point 2), where balance enters (statement or only proof), and whether its statement passes the name test;
- for U4's eight derived readings: the closed set of bridges the row's proof needs, against the bridges U4 names.
A measurement of Lean dependency for the design, not a result.
"""
import collections, json, pickle, re, sys

FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRELUDE_LAW = 'Becoming.balance_over_stretch_on'
TERM = 'Becoming.«际»'
# Lean's generated auxiliaries, by their last name component (spec §3).
AUX = re.compile(r'^(match_\d+(_\d+)*|_proof_\d+|proof_\d+|eq_\d+|eq_def|sizeOf_spec|_sizeOf_\d+|_sizeOf_inst|injEq|inj|'
                 r'brecOn|below|binductionOn|casesOn|recOn|rec|noConfusion|noConfusionType|ctorIdx|toCtorIdx|'
                 r'_unsafe_rec|_sunfold|_flat_ctor|_aux_\d+|_default|elim)$')
# U4's eight derived readings (DESIGN-BOUNDARY.md §3 on branch u4-edge, 2cc1bac0b): row -> (law, bridges U4 names).
EIGHT = {
    'Becoming.Flow.beyond_gives_nothing': ('Becoming.«所闭之界»', ['eq_zero_of_not_pos']),
    'Becoming.Flow.withinSystem_of_withinInfluence': ('Becoming.«所闭之单调»', ['shares_of_affectedBy']),
    'Becoming.Law.drawn_iff_not_returns': ('Becoming.«定后有后则入当且仅当不返»',
                                          ['drawn_iff_drawnIn', 'absorbing_iff_closed', 'reaches_iff_orbit',
                                           'returns_iff_reaches']),
    'Becoming.Law.lossless_iff_returns': ('Becoming.«有限遍后定后则定前当且仅当皆返»',
                                         ['lossless_iff_fixedBefore', 'returns_iff_reaches']),
    'Becoming.Learning.goAlike_iff_lumped': ('Becoming.«像定后当且仅当同行»',
                                             ['goAlikeUnder_iff_alike', 'lumped_iff_fixed_image']),
    'Becoming.Tolerance.answers_restores_iff': ('Becoming.«承之迭»', ['chain_iff_steps']),
    'Becoming.Withholding.withholding_spreads': ('Becoming.«存承之迭»', ['within_iff_withinSteps', 'chain_iff_steps']),
    'Becoming.WithinMoves.after_course': ('Becoming.«迭内之接»',
                                         ['trace_steps', 'trace_iff_steps', 'withinMoves_iff_withinSteps']),
}


def main():
    C = pickle.load(open(sys.argv[1], 'rb'))
    measure = json.load(open(sys.argv[2]))
    rows = {}
    for r in measure['rows']:
        rows.setdefault(r['declaration'], r)

    def aux(n):
        return bool(AUX.match(n.rsplit('.', 1)[-1]))

    def located(n):
        """A constant of the grammar's modules or the prelude."""
        m = C[n]['m']
        return m == 'Becoming.Prelude' or m.startswith('Becoming.Grammar')

    def own(n):
        """What a constant's statement consists of: a theorem's type; anything else's type and value."""
        x = C[n]
        return list(x['t']) if x['k'] == 'thm' else list(x['t']) + list(x['v'])

    # Root constants: located in the grammar's modules or the prelude, with every constant their statements reach
    # (entering definitions' values and theorems' types, all the way down) located there too.
    nonroot = {n for n in C if not located(n)}
    users = collections.defaultdict(set)
    for n in C:
        for b in own(n):
            if b in C:
                users[b].add(n)
    stack = list(nonroot)
    while stack:
        for u in users[stack.pop()]:
            if u not in nonroot:
                nonroot.add(u)
                stack.append(u)
    root = {n for n in C if n not in nonroot}

    def direct(n):
        """The constants an item's statement names directly, its own generated auxiliaries walked through."""
        out, seen, stack = set(), {n}, own(n)
        while stack:
            b = stack.pop()
            if b not in C or b in seen:
                continue
            seen.add(b)
            if aux(b) and b.startswith(n + '.'):
                stack += own(b)
            else:
                out.add(b)
        return out

    def closure(names):
        seen, stack = set(), list(names)
        while stack:
            b = stack.pop()
            if b in C and b not in seen:
                seen.add(b)
                stack += own(b)
        return seen

    def term(n):
        return '«' in n and n != TERM

    def name_test(n, allowed=()):
        """Spec §3: every constant named directly is a root constant or an allowed declared definition."""
        bad = sorted(b for b in direct(n) if b not in root and b not in allowed)
        return bad

    def grammar_law(n):
        x = C[n]
        if x['k'] != 'thm' or '«' not in n.rsplit('.', 1)[-1] or aux(n):
            return False
        if name_test(n):
            return False
        cl = closure(x['t'])
        return any(term(b) for b in cl) and not any(C[b].get('cv') for b in cl)

    laws = {n for n in C if grammar_law(n)}

    def walk(n):
        """The run's theorems a proof names: its value walked through definitions and generated auxiliaries,
        stopping at theorems (collected) and at root constants that are not theorems."""
        out, seen, stack = set(), {n}, list(C[n]['v'])
        while stack:
            b = stack.pop()
            if b not in C or b in seen:
                continue
            seen.add(b)
            if C[b]['k'] == 'thm' and not aux(b):
                out.add(b)
            elif b in root:
                continue
            else:
                stack += list(C[b]['t']) + list(C[b]['v'])
        return out

    fw = {}

    def forwarder(n):
        """The grammar law a theorem forwards to (the dump's `f`, followed through chains), its proof naming no other
        theorem of the run."""
        if n in fw:
            return fw[n]
        fw[n] = None
        g = C[n].get('f')
        if g and g in C and walk(n) <= {g}:
            fw[n] = g if g in laws else forwarder(g)
        return fw[n]

    for n in C:
        if C[n]['k'] == 'thm':
            forwarder(n)
    forwarders = {n: g for n, g in fw.items() if g and n not in laws}

    def law_of(n):
        return n if n in laws else forwarders.get(n)

    anchors = set(FLOW) | {PRELUDE_LAW}
    reaches_anchor = {}

    def counting(n):
        """Whether a theorem is a balance anchor or its proof reaches one."""
        if n not in reaches_anchor:
            reaches_anchor[n] = n in anchors or bool(closure([n]) & anchors) or any(
                counting(b) for b in walk(n) if b in root)
        return reaches_anchor[n]

    def closed_set(row):
        """Spec §3.1: the theorems that must be declared bridges for the row's proof to be closed, the laws used,
        the root theorems named, and the counting laws reached."""
        need, used, helpers, count, seen, stack = set(), set(), set(), set(), {row}, [row]
        while stack:
            for b in walk(stack.pop()):
                if b in seen:
                    continue
                seen.add(b)
                if law_of(b):
                    used.add(law_of(b))
                elif b in anchors or (b in root and counting(b)):
                    count.add(b)
                elif b in root:
                    helpers.add(b)
                else:
                    need.add(b)
                    stack.append(b)
        return need, used, helpers, count

    def reach(n):
        """Grammar laws a declaration's type and proof reach through its model's content (root constants and laws
        not entered)."""
        out, seen, stack = set(), {n}, list(C[n]['t']) + list(C[n]['v'])
        while stack:
            b = stack.pop()
            if b not in C or b in seen:
                continue
            seen.add(b)
            if law_of(b):
                out.add(law_of(b))
            elif b not in root:
                stack += list(C[b]['t']) + list(C[b]['v'])
        return out

    short = lambda n: n.removeprefix('Becoming.')
    grammar_named = [n for n in C if C[n]['k'] == 'thm' and '«' in n.rsplit('.', 1)[-1]]
    left_out = collections.Counter()
    examples = collections.defaultdict(list)
    for n in grammar_named:
        if n in laws:
            continue
        why = ('generated auxiliary' if aux(n) else 'names a constant off the root' if name_test(n)
               else 'names a closed value' if any(C[b].get('cv') for b in closure(C[n]['t']))
               else 'names no grammar term other than «际»')
        left_out[why] += 1
        if len(examples[why]) < 6:
            examples[why].append(short(n))
    located_nonroot = sorted(n for n in C if located(n) and n not in root)

    table = []
    for n, r in sorted(rows.items()):
        S = closure(C[n]['t'])
        # The proof's dependency closure (types and values, all the way down), as the measure walks it.
        deps_seen, st = {n}, [n]
        while st:
            x = st.pop()
            for b in list(C[x]['t']) + list(C[x]['v']):
                if b in C and b not in deps_seen:
                    deps_seen.add(b)
                    st.append(b)
        row = {'declaration': short(n), 'dependence': r['dependence'], 'category': r['category'],
               'name_test_on_row': not name_test(n),
               'grammar_laws_reached': sorted(map(short, reach(n))),
               'balance': {'flow_statement': [a.split('.')[-1] for a in FLOW if a in S],
                           'flow_proof_only': [a.split('.')[-1] for a in FLOW if a in deps_seen and a not in S],
                           'prelude_law_only': PRELUDE_LAW in deps_seen and not any(a in deps_seen for a in FLOW)},
               'forwarder': short(forwarders[n]) if n in forwarders else None}
        if n in EIGHT:
            y, named = EIGHT[n]
            need, used, helpers, count = closed_set(n)
            row['eight'] = {'law': short(y), 'law_is_grammar_law': y in laws, 'law_reached': y in used,
                            'laws_used': sorted(map(short, used)),
                            'bridges_needed': sorted(map(short, need)),
                            'bridges_u4_names': named,
                            'needed_not_named': sorted(short(b) for b in need
                                                       if b.rsplit('.', 1)[-1] not in named),
                            'named_not_needed': sorted(x for x in named
                                                       if not any(b.rsplit('.', 1)[-1] == x for b in need)),
                            'root_theorems_named': sorted(map(short, helpers)),
                            'counting_laws_reached': sorted(map(short, count))}
        table.append(row)
    grammar_rows = [x for x in table if x['dependence'] == 'grammar']
    summary = {
        'run': 'core run 20261030T131028.245732Z; main 4ac8cf27e',
        'constants': len(C), 'root_constants': len(root),
        'located_in_grammar_or_prelude_but_off_the_root': len(located_nonroot),
        'off_root_examples': [short(n) for n in located_nonroot[:12]],
        'theorems_with_a_grammar_name': len(grammar_named), 'grammar_laws': len(laws),
        'grammar_named_left_out': dict(left_out), 'left_out_examples': dict(examples),
        'forwarders_of_grammar_laws': sorted(f'{short(n)} -> {short(g)}' for n, g in forwarders.items()),
        'central_declarations': len(table),
        'rows_passing_the_name_test': [x['declaration'] for x in table if x['name_test_on_row']],
        'grammar_rows': len(grammar_rows),
        'grammar_rows_reaching_a_grammar_law': sum(bool(x['grammar_laws_reached']) for x in grammar_rows),
        'grammar_rows_reaching_none': [x['declaration'] for x in grammar_rows if not x['grammar_laws_reached']],
        'rows_that_are_forwarders': [x['declaration'] for x in table if x['forwarder']],
        'balance_in_statement': {'grammar': sum(bool(x['balance']['flow_statement']) for x in grammar_rows),
                                 'other': sum(bool(x['balance']['flow_statement']) for x in table
                                              if x['dependence'] != 'grammar')},
        'eight': {x['declaration']: {k: v for k, v in x['eight'].items()} for x in table if 'eight' in x},
    }
    out = {'summary': summary, 'rows': table}
    if '--json' in sys.argv:
        open(sys.argv[sys.argv.index('--json') + 1], 'w').write(json.dumps(out, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: v for k, v in summary.items() if k != 'eight'}, indent=1, ensure_ascii=False))
    for d, e in summary['eight'].items():
        print(d, json.dumps(e, ensure_ascii=False))


if __name__ == '__main__':
    main()
