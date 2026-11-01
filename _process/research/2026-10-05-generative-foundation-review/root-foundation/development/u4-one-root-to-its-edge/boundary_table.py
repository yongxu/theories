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
  prelude's counting law `balance_over_stretch_on`; and whether the statement writes balance out as an equation
  (its type names `Dependence.level`, `Flow.taken` and `Flow.given` directly);
- the grammar laws it reaches, by MV's walk (shared_laws.py): through every constant, stopping only at «» names; a
  law is a «» theorem of a `Becoming.Grammar*` module, and a «» name declared elsewhere is listed apart;
- F5's items stating it (shared-laws.json, `central_reach.rows`) and their models, and the row's class in F5's four
  counts, which the report prints beside the standings and checks against the published counts;
- EC6's definitional rows, flagged (they keep the standing F5's items give them);
- a proposed standing, by the rules in DESIGN-BOUNDARY.md §2, with HAND giving the rows the rules leave to a
  reading, each with the result that places it.

A measurement of Lean dependency joined to readings; the readings are the design's, for review.
"""
import json, pickle, re, subprocess, sys, tempfile
from pathlib import Path

DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development'
MEASURE = DEV + '/ou3b-master-laws-on-the-grammar/measure_grammar.py'
FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRELUDE = 'Becoming.balance_over_stretch_on'
L2 = 'LEVER-2-AUDIT.md'

# The standings (DESIGN-BOUNDARY.md §1). Three on the edge, one below the grammar, the rest distances; a row no rule
# or reading places is "unplaced", which the record may not keep.
ON_EDGE = ['derived', 'under a stated hypothesis', 'premise']
BELOW = ['counting']
DISTANCES = ['connected', 'witnessed at its model', 'balance in its statement', 'amounts', 'at a represented model',
             'own carrier', 'at its model', 'free significance']
UNPLACED = ['unplaced']
# Lean's generated auxiliaries, matched on the last name component: MV's pattern (BOUNDARY-FIELD.md §3.0, probe.py's
# AUX), which is normative. Every walk goes through them; none is a law.
AUX = re.compile(r'^(match_\d+(_\d+)*|_proof_\d+|proof_\d+|eq_\d+|eq_def|sizeOf_spec|_sizeOf_\d+|_sizeOf_inst|injEq|inj|'
                 r'brecOn|below|binductionOn|casesOn|recOn|rec|noConfusion|noConfusionType|ctorIdx|toCtorIdx|'
                 r'ctorElim|ctorElimType|splitter|_unsafe_rec|_sunfold|_flat_ctor|_aux_\d+|_default|elim)$')
# Balance written out as an equation: a statement naming all three directly.
WRITTEN = ['Becoming.Dependence.level', 'Becoming.Flow.taken', 'Becoming.Flow.given']

# Rows the rules leave to a reading: declaration -> (standing, basis).
HAND = {
    # Lever 2's row 5: a reading equal to the rule's label (MV's field allows it), naming its relational part.
    'Flow.no_new_dependence': ('balance in its statement',
        'writes balance out in its statement, as an equation; row 5: its relational part is the strict root form '
        'descent_forms_no_dependence (boundary-scratch), with lever 2\'s form no_new_dependence_of_given and its '
        'witnesses Ungiven, Uninherited, Held, Standing; the recovery meets "given to" from the balance only through '
        'Flow.descends_of_comes, amount reasoning, so it fails the discharge condition '
        f'(DESIGN-BOUNDARY.md §1.2; {L2} §5, §10)'),
    # Lever 2's row 17: its strict root form, outside_leaves_no_offspring (boundary-scratch), passes the Lean check,
    # its recovery meeting the discharge condition; standing 2 when the leaf lands (DESIGN-BOUNDARY.md §1.2, §4).
    'GroupEnding.Flow.all_end': ('witnessed at its model',
        'row 17: the gate and descent as two inclusions at one step, and a generation wholly inactive '
        '(all_end_on_root, size_zero_of_within); witnesses Ungated (gate), Ungated.silent (descent), '
        'Lifted.inactive_needed (inactivity); the conclusion is a count; strict form outside_leaves_no_offspring in '
        'boundary-scratch, its recovery all_end_at_model meeting the discharge condition by definitions alone '
        f'(check-run.log); standing 2 when the leaf lands ({L2} §10)'),
    # Lever 2's rows 13 and 14: their forms are witnessed, but a hypothesis constrains amounts.
    'SelectionLevels.rises_exact_iff_levels': ('amounts',
        f'row 13: cancellation, G.raisedAt t = G.loweredAt t, constrains amounts (rises_cancel_iff_levels); witness '
        f'Raised; the list facts are counting and not witnessed ({L2} §1)'),
    'GroupEnding.Flow.rises_iff_inactive': ('amounts',
        'row 14: the gate and descent as two inclusions (rises_iff_inactive_on_root), but cancellation and inactivity, '
        'which compares sums of the trait, constrain amounts; witnesses EndsAmong (gate, inactivity), EndsAmong.silent '
        f'(descent), Lifted (cancellation); the list facts are counting and not witnessed ({L2} §10)'),
    # The connected rows read as cases of a grammar law (CONNECTED-ROWS-READING.md, with its correction): the proof is
    # the law at the model's relation, through bridge equivalences that hold at every instance of the model's
    # parameters and add no hypothesis, each named. The record declares the law and the bridges; no Lean is added.
    **{d: ('derived', f'a case of {y} at {at}; bridges: {why} (CONNECTED-ROWS-READING.md)')
       for d, y, at, why in [
           ('Flow.beyond_gives_nothing', '«所闭之界»', 'R = L.FedFrom W',
            'FedFrom and FedBy unfolded, and one prelude step, ¬ 0 < n → n = 0'),
           ('Flow.withinSystem_of_withinInfluence', '«所闭之单调»', 'R = AffectedBy, S = Shares',
            'shares_of_affectedBy, an unfolding'),
           ('Law.drawn_iff_not_returns', '«定后有后则入当且仅当不返»', 'R = next x = y',
            'drawn_iff_drawnIn, absorbing_iff_closed, reaches_iff_orbit and returns_iff_reaches (the orbit read as «及», '
            'by recursion)'),
           ('Law.lossless_iff_returns', '«有限遍后定后则定前当且仅当皆返»', 'R = next x = y',
            'lossless_iff_fixedBefore, an unfolding, and returns_iff_reaches (by recursion)'),
           ('Learning.goAlike_iff_lumped', '«像定后当且仅当同行»', "the law's step, along π",
            'goAlikeUnder_iff_alike and lumped_iff_fixed_image, unfoldings'),
           ('Tolerance.answers_restores_iff', '«承之迭»', 'R = up',
            'answers is «承» up by definition; chain_iff_steps (the model\'s Chain as «迭», by recursion through «迭之末步»); '
            'the start instantiated at allWithheld'),
           ('Withholding.withholding_spreads', '«存承之迭»', 'R = up',
            'waitsAll by definition; within_iff_withinSteps through chain_iff_steps (by recursion)'),
           ('WithinMoves.after_course', '«迭内之接»', 'R = Steps P',
            'trace_steps and trace_iff_steps (by recursion), withinMoves_iff_withinSteps')]},
    # Grammar-only content declared off the grammar: cases once the laws are in GrammarLaws (HE2's list).
    'Flow.mutuallyDependent_iff_reach': ('connected',
        'exactly WithinClosure.converse, «所闭» («逆» R) f g ↔ «所闭» R g f, grammar-only in content but declared off the '
        'grammar; a case once «所闭之逆» is declared in GrammarLaws and WithinClosure.converse is re-proved through it '
        '(HE2; CONNECTED-ROWS-READING.md)'),
    'Flow.withinCoupling_reads_iff': ('connected',
        'its two halves are WithinClosure.of_reads and WithinClosureOf.to_reads, grammar-only in content but declared '
        'off the grammar, with their hypotheses met by case splits on the model; on HE2\'s list beside «所闭之逆» '
        '(CONNECTED-ROWS-READING.md, with its correction)'),
    # Lever 2's gate rows: every hypothesis that is not counting is relational and witnessed; the statement compares
    # amounts.
    **{d: ('amounts', f'row {r}: the gate as inclusions (gate_iff_occurrences, dependent_iff), every hypothesis that is '
                      f'not counting witnessed; the conclusion compares sums of amounts over generations ({L2} §4, §10)')
       for d, r in [('Flow.selection_within', 1), ('Flow.transmitted_supported', 2), ('Flow.selected_le', 3),
                    ('SelectionTerm.Flow.support_not_lower', 7), ('SelectionTerm.Flow.support_moved_rises', 8)]},
    'Reproduction.Flow.number_within_take': ('amounts',
        f'row 9: dissipation on a family and an injection from births to given units, a count within a take; '
        f'dissipation is kept as a premise of the account with no proof of independence ({L2} §1)'),
    # Laws of counting (lever 2 §2): lists and maps to Nat, any carrier; no model constant reached.
    'SelectionTerm.covariation': ('counting', f'row 6: Price\'s covariance ({L2} §2)'),
    'SelectionLevels.levels_sized': ('counting', f'row 12: Price\'s partition ({L2} §2)'),
    'Drift.falls_back': ('counting', f'row 18: courses of n binary draws, weighted; reading them as drift is the model\'s hypothesis ({L2} §2)'),
    'RelativePosition.rise_needs_fall': ('counting', 'a rise and fall count over a list, by commutativity (EC6: law of its model)'),
    'Listed.coming_of_ceasing': ('counting',
        'for any carrier, predicate and exact listing, ceasing without end needs coming to be without end; the statement '
        'unfolds to the prelude\'s Distinct and Init and names no amount'),
    'CensusWebs.keep_pace': ('counting',
        'the counting law CountsAcross.keep_pace, for any predicate, at a web\'s arising and ceasing over a listing'),
    # The significance rows (U3): the free predicate stays free in the general statement (07 §1).
    'unrestricted_iff_livingSignificance': ('free significance',
        'row 1: the continuation condition as living significance; root form noOutside_iff_paths_livingSignificance at the '
        'structural reading only; the condition is a premise proved not entailed (ReadsOnlyDynamics.not_entails)'),
    'Web.widens_iff_retains_adds': ('free significance', 'row 8: root form widens_iff_retains_adds_root at the structural reading only (U3)'),
    'Web.paths_one_object': ('free significance', 'row 9: root form paths_one_object_root at the structural reading only (U3)'),
    # Laws of their models with no statement on the root.
    'carried_iff_rising': ('at its model', 'an exchange law carries exactly where the reading rises; support is inside the existential, not kept'),
    'PartForms.goAlike': ('at its model', 'a law of its model; the image law only reads it (OU3d\'s review)'),
    'Direction.extension_iff_widens': ('at its model', "C's extension on the moves' frame (Web.paths_extension_iff_widens)"),
    # Rows whose statements compare amounts (the reading, by the statement; the proof reaches only the prelude's
    # counting law, or Flow's balance).
    'responses_le_missBound': ('amounts', 'a bound of propagation on amounts (EC6: law of its model)'),
    **{d: ('amounts', why) for d, why in [
        ('RegimeMargin.ends_iff_below', 'a run of Nat margins ends exactly below H + y'),
        ('RegimeMargin.Adjusted.ends_iff_below', 'as RegimeMargin.ends_iff_below, with recent giving adjusted'),
        ('Web.frontier_broken', 'optima of orders on Nat levels and weighted draws break a dependence'),
        ('Web.frontier_breaks_below', 'a coupling below what keeping forgoes, in Nat worths and draws, breaks a dependence'),
        ('Web.frontier_exhausts', 'a weighting falling faster than levels rise leaves the level at nothing'),
        ('Web.frontier_rebuilds', 'a level rising faster than the weighting falls is rebuilt, in Nat levels and weights'),
        ('Web.frontier_keeps_stepwise', 'optima keep a level stepwise, in Nat levels and weighted sums'),
        ('Web.Next.frontier_ends_drawn_first', 'optima end the condition drawn first, in Nat levels and weighted sums'),
        ('Flow.new_beyond_every', 'endless novelty concludes that a family gives more than it takes or is open, an '
                                  'imbalance; balance enters only the proof')]},
}

# Rows EC6 calls definitional or representational: they keep the standing F5's items give them (U2), flagged.
# A reading's relational part (MV's optional key): a strict root form recorded in the row's basis, placing nothing.
RELATIONAL = {'Flow.no_new_dependence': 'Becoming.U4Boundary.descent_forms_no_dependence'}

DEFINITIONAL = {
    'Web.roles_supported': 'a representation lemma of the one-kind construction roles',
    'Web.roles_dependent': 'a representation lemma of the one-kind construction roles',
    'Web.roles_alive': 'a representation lemma of the one-kind construction roles',
    'Web.renewingAt_iff_over_all': 'a one-line unpacking',
    'Web.transmits_at_iff': f'row 4: (A → B ∧ C) ↔ (A → B) ∧ (A → B → C) ({L2} §1)',
    'Ideals.verifiableBy_iff_interior': 'Iff.rfl',
    'Valuation.significant_iff_held': 'S0 and N_std unpacked',
    'ExchangeLaw.response_not_fixed_by_coupling': 'two exchange laws, ofClass and zero, through one coupling',
    'Viability.kernel_and_iff': 'for all reached, and',
    'Dependence.Overdetermined.only_together': 'one line from the definitions',
    'Limit.identifies_iff_tracks': 'Iff.rfl',
    'Web.significance_undetermined': 'a not-entailment by two constant significances',
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
    """MV's walk (shared_laws.py): from a declaration through the constants its type and proof use, every constant
    expanded except a «» name, where the walk stops; Lean's generated auxiliaries (AUX, such as `«及».brecOn`) are walked
    through, never stopped at or counted. A grammar law is a «» theorem of a Becoming.Grammar* module; a
    grammar term, any other «» constant of one; a «» name declared elsewhere is listed apart, not counted. A Grammar*
    constant without a «» name (GrammarLaws' list and number helpers, kept_onward) is walked through, so what it
    reaches counts."""
    seen, stack, laws, terms, off = {n}, [n], set(), set(), set()
    while stack:
        for b in deps.get(stack.pop(), ()):
            if b in C and b not in seen:
                seen.add(b)
                if '«' in b and not AUX.match(b.rsplit('.', 1)[-1]):
                    if not C[b]['m'].startswith('Becoming.Grammar'):
                        off.add(b)
                    else:
                        (laws if C[b]['k'] == 'thm' else terms).add(b)
                    continue
                stack.append(b)
    return [sorted(x.removeprefix('Becoming.') for x in v) for v in (laws, terms, off)]


def standing(row, bal, items):
    """The rules of DESIGN-BOUNDARY.md §2, before HAND. Every rule reads the statement, or a fact recorded apart: the
    measure's dependence, and F5's verified items. Where only the proof reaches balance or the prelude's counting
    law, no rule places the row; a reading of its statement does."""
    models = {m for it in items for m in it['models']}
    if bal['flow_statement'] or bal['written_out']:
        return ('balance in its statement', ('takes Flow\'s balance in its statement' if bal['flow_statement']
                                             else 'writes balance out in its statement, as an equation')
                + ('; reaches grammar laws among its reasons' if row['dependence'] == 'grammar' else ''))
    if row['dependence'] == 'grammar':
        return ('connected', 'reaches grammar laws among its reasons; derived only where it is a case of a declared law '
                             '(DESIGN-BOUNDARY.md §1.1)'
                + ('; Flow\'s balance only in its proof' if bal['flow_proof'] else '')
                + ('; the prelude\'s counting law in its proof' if bal['prelude_only'] else ''))
    if models & {'occurrence', 'process'}:
        return ('at a represented model', 'F5: ' + ', '.join(sorted(models)))
    if models:
        return ('own carrier', 'F5: stated in grammar terms on its own carrier')
    return ('unplaced', 'no rule reads its statement' + ('; Flow\'s balance only in its proof' if bal['flow_proof'] else '')
            + ('; the prelude\'s counting law in its proof' if bal['prelude_only'] else ''))


def f5_class(row, items):
    """F5's four counts (shared_laws.py, central_reach): the measure's reach first, then the verified items."""
    models = {m for it in items for m in it['models']}
    if row['dependence'] == 'grammar':
        return 'reaches the grammar'
    if models & {'occurrence', 'process'}:
        return 'at a represented model'
    return 'own carrier' if models else 'the rest'


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
    reach = json.loads((root / 'theories/becoming/results/data/shared-laws.json').read_text())['central_reach']['rows']
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
               'prelude_only': PRELUDE in P and not any(a in P for a in FLOW),
               'written_out': all(a in C[n]['t'] for a in WRITTEN)}
        items = reach.get(n, [])
        short = n.removeprefix('Becoming.')
        rule = standing(r, bal, items)
        st, basis = HAND.get(short, rule)
        if short in DEFINITIONAL:
            basis += f'; definitional ({DEFINITIONAL[short]})'
        gthm, gdef, goff = grammar_reach(C, deps, n)
        table.append({'declaration': short, 'rows': r['rows'], 'dependence': r['dependence'], 'category': r['category'],
                      'reason': r.get('reason', ''), 'laws': r['laws'], 'balance': bal,
                      'grammar_laws': gthm, 'grammar_terms': gdef, 'named_off_the_grammar': goff,
                      'f5': [{'item': it['declaration'].removeprefix('Becoming.'), 'models': it['models'], 'record': it['record']}
                             for it in items],
                      'standing': st, 'basis': basis, 'relational_part': RELATIONAL.get(short), 'definitional': short in DEFINITIONAL, 'f5_class': f5_class(r, items), 'reading': read.get(short), 'by': 'reading' if short in HAND else 'rule',
                      'rule_would_give': rule[0] if short in HAND and rule[0] != st else None})
    order = ON_EDGE + BELOW + DISTANCES + UNPLACED
    unknown = sorted({x['standing'] for x in table} - set(order))
    if unknown:
        sys.exit(f'standings outside the design: {unknown}')
    counts = {s: sum(x['standing'] == s for x in table) for s in order}
    stale = sorted((set(HAND) | set(DEFINITIONAL)) - {x['declaration'] for x in table})
    f5_order = ['reaches the grammar', 'at a represented model', 'own carrier', 'the rest']
    f5 = {c: sum(x['f5_class'] == c for x in table) for c in f5_order}
    against = {s: {c: n for c in f5_order if (n := sum(x['standing'] == s and x['f5_class'] == c for x in table))}
               for s in order if counts[s]}
    published = json.loads((root / 'theories/becoming/results/data/shared-laws.json').read_text())['central_reach']['counts']
    report = {'distinct_central_declarations': len(table), 'counts': counts,
              'on_the_edge': sum(counts[s] for s in ON_EDGE), 'below_the_grammar': sum(counts[s] for s in BELOW),
              'distances': sum(counts[s] for s in DISTANCES), 'unplaced': [x['declaration'] for x in table
                                                                          if x['standing'] == 'unplaced'],
              'definitional': sum(x['definitional'] for x in table),
              'reaching_a_grammar_law': sum(bool(x['grammar_laws']) for x in table),
              'f5_counts': f5, 'f5_counts_published': published, 'standing_against_f5': against,
              'hand_rows_not_central': stale, 'rows': table}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: v for k, v in report.items() if k != 'rows'}, ensure_ascii=False))


if __name__ == '__main__':
    main()
