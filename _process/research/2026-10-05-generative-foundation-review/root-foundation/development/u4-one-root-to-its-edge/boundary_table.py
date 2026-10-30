#!/usr/bin/env python3
"""U4, the boundary record (design): where each central declaration stands on the edge of one root.

python3 -B boundary_table.py ROOT [--dump PICKLE] [--json OUT]

ROOT is a checkout whose package sources are in the checker cache. The script runs the master-law measure
(ou3b-master-laws-on-the-grammar/measure_grammar.py, which restores the spine run from the cache; nothing is
compiled), or reads the constants it saved (--dump, from `measure_grammar.py --save`), and joins, for each of the
distinct central declarations of COVERAGE.json:

- the measure's row (dependence, category, the master laws it rests on, the reason EC6 gives it);
- where a balance anchor enters: in its statement (the type and the definitions the type unfolds), or only in its
  proof, and whether the anchor is one of `Flow`'s (`Balances`, `BalancesOn`, `BalancesBetween`) or only the
  prelude's counting law `balance_over_stretch_on`;
- F5's items stating it (master-laws.json, `central_reach.rows`) and their models;
- a proposed standing, by the rules in DESIGN-BOUNDARY.md §2, with HAND giving the rows the rules leave to a
  reading, each with the result that places it.

A measurement of Lean dependency joined to readings; the readings are the design's, for review.
"""
import json, pickle, subprocess, sys, tempfile
from pathlib import Path

DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'
MEASURE = DEV + '/ou3b-master-laws-on-the-grammar/measure_grammar.py'
FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRELUDE = 'Becoming.balance_over_stretch_on'
L2 = 'LEVER-2-AUDIT.md'

# The standings (DESIGN-BOUNDARY.md §1). Three on the edge, two below the grammar, the rest distances.
ON_EDGE = ['derived', 'under a stated hypothesis', 'premise']
BELOW = ['logic', 'counting']
DISTANCES = ['connected', 'balance, represented', 'amounts', 'at a represented model', 'own carrier', 'at its model',
             'free significance']

# Rows the rules leave to a reading: declaration -> (standing, basis).
HAND = {
    # Lever 2's standing-2 rows: forms in lever-2-scratch whose hypotheses state the gate as grammar inclusions over
    # the model's relations, each witnessed; the statements keep the model's terms, so on the strict reading
    # (DESIGN-BOUNDARY.md §1.2) they are at their model until restated over every relation and amount (§4).
    **{d: ('at its model', f'row {r}: {form}; every hypothesis witnessed ({w}); the statement keeps the model\'s terms, '
                          f'so standing 2 waits for a form over every relation and amount ({L2} {sec})')
       for d, r, form, w, sec in [
           ('Flow.no_new_dependence', 5, '"coming to stand is given to" (no_new_dependence_of_given)', 'Ungiven', '§5'),
           ('SelectionLevels.rises_exact_iff_levels', 13, 'cancellation (rises_cancel_iff_levels)', 'Raised', '§1'),
           ('GroupEnding.Flow.rises_iff_inactive', 14, 'the gate as two inclusions, cancellation and inactivity (rises_iff_inactive_on_root)',
            'Ungated, EndsAmong, Lifted', '§10'),
           ('GroupEnding.Flow.all_end', 17, 'the gate as two inclusions (all_end_on_root, size_zero_of_within)',
            'Ungated, Lifted.inactive_needed', '§10')]},
    # The connected rows read as cases of a grammar law (CONNECTED-ROWS-READING.md): the proof already is the law
    # applied with existing bridges, so the record declares the law and adds no Lean.
    **{d: ('derived', f'a case of {y} at {at}; bridges exist ({why}) (CONNECTED-ROWS-READING.md)')
       for d, y, at, why in [
           ('Flow.beyond_gives_nothing', '«所闭之界»', 'R = L.FedFrom W', 'FedFrom and FedBy unfolded; one prelude step, ¬ 0 < n → n = 0'),
           ('Flow.withinSystem_of_withinInfluence', '«所闭之单调»', 'R = AffectedBy, S = Shares', 'shares_of_affectedBy, an unfolding'),
           ('Law.drawn_iff_not_returns', '«定后有后则入当且仅当不返»', 'R = next x = y',
            'drawn_iff_drawnIn, absorbing_iff_closed, reaches_iff_orbit; the orbit read as «及» by induction'),
           ('Law.lossless_iff_returns', '«有限遍后定后则定前当且仅当皆返»', 'R = next x = y',
            'lossless_iff_fixedBefore, returns_iff_reaches; the orbit read as «及» by induction'),
           ('Learning.goAlike_iff_lumped', '«像定后当且仅当同行»', "the law's step along π", 'goAlikeUnder_iff_alike, lumped_iff_fixed_image'),
           ('Tolerance.answers_restores_iff', '«承之迭»', 'R = up', 'answers is «承» up by definition; chain_iff_steps'),
           ('Withholding.withholding_spreads', '«存承之迭»', 'R = up', 'waitsAll by definition; within_iff_withinSteps'),
           ('WithinMoves.after_course', '«迭内之接»', 'R = Steps P', 'trace_steps, withinMoves_iff_withinSteps')]},
    'Flow.mutuallyDependent_iff_reach': ('connected',
        'exactly WithinClosure.converse, «所闭» («逆» R) f g ↔ «所闭» R g f, grammar-only in content but declared off the '
        'grammar; a case once that law is declared in GrammarLaws (CONNECTED-ROWS-READING.md)'),
    # Lever 2's gate rows: every hypothesis an inclusion on the root and witnessed; the conclusion compares amounts.
    **{d: ('amounts', f'row {r}: the gate as inclusions (gate_iff_occurrences, dependent_iff), every hypothesis witnessed; '
                      f'the conclusion compares amounts ({L2} §4, §10)')
       for d, r in [('Flow.selection_within', 1), ('Flow.transmitted_supported', 2), ('Flow.selected_le', 3),
                    ('SelectionTerm.Flow.support_not_lower', 7), ('SelectionTerm.Flow.support_moved_rises', 8)]},
    'Reproduction.Flow.number_within_take': ('amounts',
        f'row 9: dissipation on a family and an injection from births to given units, a count within a take; '
        f'dissipation is kept as a premise of the account with no proof of independence ({L2} §1)'),
    # Laws of counting (lever 2 §2): lists and maps to Nat; no model constant reached.
    'SelectionTerm.covariation': ('counting', f'row 6: Price\'s covariance ({L2} §2)'),
    'SelectionLevels.levels_sized': ('counting', f'row 12: Price\'s partition ({L2} §2)'),
    'Drift.falls_back': ('counting', f'row 18: courses of n binary draws, weighted; reading them as drift is the model\'s hypothesis ({L2} §2)'),
    'RelativePosition.rise_needs_fall': ('counting', 'a rise and fall count over a list, by commutativity (EC6: law of its model)'),
    # Laws of logic: definitions unpacked; where U2 states them at a model, that statement is noted.
    **{d: ('logic', why) for d, why in [
        ('Web.roles_supported', 'the one-kind reading keeps support (U2 states it at the occurrence model)'),
        ('Web.roles_dependent', 'the one-kind reading keeps dependence (U2, occurrence model)'),
        ('Web.roles_alive', 'the one-kind reading keeps living (U2, occurrence model)'),
        ('Web.renewingAt_iff_over_all', 'a one-line unpacking (U2, occurrence model)'),
        ('Web.transmits_at_iff', f'row 4: (A → B ∧ C) ↔ (A → B) ∧ (A → B → C) (U2, occurrence model; {L2} §1)'),
        ('Ideals.verifiableBy_iff_interior', 'Iff.rfl (U2, own carrier)'),
        ('Valuation.significant_iff_held', 'S0 and N_std unpacked (U2, own carrier)'),
        ('ExchangeLaw.response_not_fixed_by_coupling', 'two laws through one coupling (U2, own carrier)'),
        ('Viability.kernel_and_iff', 'for all reached, and (U2, process model)'),
        ('Dependence.Overdetermined.only_together', 'one line from the definitions (U2, process model)'),
        ('Limit.identifies_iff_tracks', 'Iff.rfl (U2, process model)'),
        ('Web.significance_undetermined', 'a free slot shown free (U2, occurrence model and own carrier)')]},
    # The significance rows (U3): the free predicate stays free in the general statement (07 §1).
    'unrestricted_iff_livingSignificance': ('free significance',
        'row 1: the continuation condition as living significance; root form noOutside_iff_paths_livingSignificance at the '
        'structural reading only; the condition is a premise proved not entailed (ReadsOnlyDynamics.not_entails)'),
    'Web.widens_iff_retains_adds': ('free significance', 'row 8: root form widens_iff_retains_adds_root at the structural reading only (U3)'),
    'Web.paths_one_object': ('free significance', 'row 9: root form paths_one_object_root at the structural reading only (U3)'),
    # Laws of their models with no statement on the root.
    'carried_iff_rising': ('at its model', 'an exchange law carries exactly where the reading rises; support is inside the existential, not kept'),
    'responses_le_missBound': ('amounts', 'a bound of propagation on amounts (EC6: law of its model)'),
    'PartForms.goAlike': ('at its model', 'a law of its model; the image law only reads it (OU3d\'s review)'),
    'Direction.extension_iff_widens': ('at its model', "C's extension on the moves' frame (Web.paths_extension_iff_widens)"),
    # The census rows: counts of arising and ceasing over a listing; lever 1's candidate through «计».
    'Listed.coming_of_ceasing': ('amounts', 'counts of arising and ceasing over a listing; the census pairing with «计» is lever 1\'s candidate'),
    'CensusWebs.keep_pace': ('amounts', 'as Listed.coming_of_ceasing'),
}


def reading(path):
    """The reader's table: declaration -> (verdict, root form possible?)."""
    out = {}
    if not path.is_file():
        return out
    for line in path.read_text().splitlines():
        cells = [c.strip() for c in line.strip().strip('|').split('|')]
        if len(cells) >= 7 and cells[0].startswith('`') and cells[0].endswith('`'):
            out[cells[0].strip('`')] = {'verdict': cells[1].replace('**', ''), 'root_form': cells[5]}
    return out


def statement_closure(C, n):
    """The constants a declaration's statement names, with the definitions those unfold to (not theorems' proofs)."""
    seen, stack = set(), list(C[n]['t'])
    while stack:
        x = stack.pop()
        if x in seen or x not in C:
            continue
        seen.add(x)
        stack += list(C[x]['t']) + (list(C[x]['v']) if C[x]['k'] in ('def', 'ind', 'ctor', 'rec') else [])
    return seen


def proof_closure(C, deps, n):
    seen, stack = {n}, [n]
    while stack:
        for b in deps.get(stack.pop(), ()):
            if b in C and b not in seen:
                seen.add(b)
                stack.append(b)
    return seen


def grammar_reach(C, deps, n):
    """The grammar laws and other grammar constants a declaration's type and proof reach, grammar constants not
    expanded. A grammar constant is a «» name or a constant of a Becoming.Grammar* module; a grammar law is a theorem
    whose own name is a «» name. Lean's generated auxiliaries (`«及».brecOn`) and GrammarLaws' list and number helpers,
    which its own text says are not statements of the grammar, are counted with the definitions (the reading,
    CONNECTED-ROWS-READING.md)."""
    seen, stack, thm, dfn = {n}, [n], set(), set()
    while stack:
        for b in deps.get(stack.pop(), ()):
            if b in C and b not in seen:
                seen.add(b)
                if '«' in b or C[b]['m'].startswith('Becoming.Grammar'):
                    (thm if C[b]['k'] == 'thm' and '«' in b.rsplit('.', 1)[-1] else dfn).add(b)
                    continue
                stack.append(b)
    return sorted(x.removeprefix('Becoming.') for x in thm), sorted(x.removeprefix('Becoming.') for x in dfn)


def standing(row, bal, items):
    """The rules of DESIGN-BOUNDARY.md §2, before HAND."""
    models = {m for it in items for m in it['models']}
    if row['dependence'] == 'grammar':
        return ('balance, represented', 'reaches the grammar through another law, and takes balance in its statement'
                if bal['flow_statement'] else 'reaches the grammar through another law; balance only in its proof') \
            if bal['flow_statement'] or bal['flow_proof'] else \
            ('connected', 'reaches grammar theorems among its reasons; derived only once a grammar law it is a case of is declared '
                          '(DESIGN-BOUNDARY.md §1)' + ('; counting by the prelude\'s law' if bal['prelude_only'] else ''))
    if bal['flow_statement']:
        return ('balance, represented', 'takes balance in its statement')
    if models & {'occurrence', 'process'}:
        return ('at a represented model', 'F5: ' + ', '.join(sorted(models)))
    if models:
        return ('own carrier', 'F5: stated in grammar terms on its own carrier')
    if bal['prelude_only']:
        return ('amounts', 'the prelude\'s counting law in its proof; its statement is on its model\'s amounts')
    if bal['flow_proof']:
        return ('amounts', 'balance only in its proof; its statement is on its model\'s amounts')
    return ('at its model', row.get('reason', ''))


def main():
    root = Path(sys.argv[1]).resolve()
    with tempfile.TemporaryDirectory(prefix='boundary-') as tmp:
        dump = Path(sys.argv[sys.argv.index('--dump') + 1]) if '--dump' in sys.argv else Path(tmp) / 'c.pickle'
        out = Path(tmp) / 'measure.json'
        args = ['--dump', str(dump)] if '--dump' in sys.argv else ['--save', str(dump)]
        subprocess.run([sys.executable, '-B', str(root / MEASURE), *args, '--json', str(out)], cwd=root, check=True,
                       stdout=subprocess.DEVNULL)
        C = pickle.load(open(dump, 'rb'))
        measure = json.loads(out.read_text())
    reach = json.loads((root / 'theories/becoming/results/data/master-laws.json').read_text())['central_reach']['rows']
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}
    read = reading(Path(__file__).resolve().with_name('CONNECTED-ROWS-READING.md'))
    rows = {}
    for r in measure['rows']:
        rows.setdefault(r['declaration'], {**r, 'rows': []})['rows'].append(r['row'])
    table = []
    for n, r in sorted(rows.items()):
        S, P = statement_closure(C, n), proof_closure(C, deps, n)
        bal = {'flow_statement': [a.split('.')[-1] for a in FLOW if a in S],
               'flow_proof': [a.split('.')[-1] for a in FLOW if a in P and a not in S],
               'prelude_only': PRELUDE in P and not any(a in P for a in FLOW)}
        items = reach.get(n, [])
        short = n.removeprefix('Becoming.')
        rule = standing(r, bal, items)
        st, basis = HAND.get(short, rule)
        gthm, gdef = grammar_reach(C, deps, n)
        table.append({'declaration': short, 'rows': r['rows'], 'dependence': r['dependence'], 'category': r['category'],
                      'reason': r.get('reason', ''), 'laws': r['laws'], 'balance': bal,
                      'grammar_theorems': gthm, 'grammar_definitions': gdef,
                      'f5': [{'item': it['declaration'].removeprefix('Becoming.'), 'models': it['models'], 'record': it['record']}
                             for it in items],
                      'standing': st, 'basis': basis, 'reading': read.get(short), 'by': 'reading' if short in HAND else 'rule',
                      'rule_would_give': rule[0] if short in HAND and rule[0] != st else None})
    order = ON_EDGE + BELOW + DISTANCES
    unknown = sorted({x['standing'] for x in table} - set(order))
    if unknown:
        sys.exit(f'standings outside the design: {unknown}')
    counts = {s: sum(x['standing'] == s for x in table) for s in order}
    stale = sorted(set(HAND) - {x['declaration'] for x in table})
    report = {'distinct_central_declarations': len(table), 'counts': counts,
              'on_the_edge': sum(counts[s] for s in ON_EDGE), 'below_the_grammar': sum(counts[s] for s in BELOW),
              'distances': sum(counts[s] for s in DISTANCES), 'hand_rows_not_central': stale, 'rows': table}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: v for k, v in report.items() if k != 'rows'}, ensure_ascii=False))


if __name__ == '__main__':
    main()
