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
not reach the grammar; `no master law` where it rests on none. That four-way split is kept as each
row's `dependence`.

Each row's `category` says what it follows from (EC6, 28 October 2026; the coordinating note's
decisions, ../ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md, "After EC6's audit"): `master law`
where it reaches the grammar, or rests on another master law's anchor with a reason it does not reach
it (`REASONS`); `balance, represented`; and, for a declaration on no master law, the reason EC6's audit
gives it (`NO_LAW`, ../ec6-no-master-law/AUDIT.md): `premise of the account` (support, dissipation),
`counting identity` (Price's), `law of its model`, `single application` or `definitional or
representational`, none a gap; or `derivation pending`, a case of a master law whose derivation is a
named item (EC6b, EC6c, OU3d). The headline counts what is a gap, among distinct declarations (nine
stand in two rows of COVERAGE): `derivation pending`, and any declaration with no reason given. A
pending derivation that lands moves its row to `master law` with no change here.
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


# Why each central declaration on no master law rests on none, or which item derives it (EC6's audit,
# reviewed twice). An entry is read only where the declaration's dependence is `no master law`.
PENDING = 'derivation pending'
NO_LAW = {
    'Becoming.RuleCapture.favouring_locks': (PENDING, 'closure, invariance along a run (EC6b)'),
    'Becoming.RuleCapture.uniform_locks': (PENDING, 'closure, invariance along a run (EC6b)'),
    'Becoming.ClosedCapture.lock_outlives_loss': (PENDING, 'closure, invariance along a run (EC6b)'),
    'Becoming.Pace.rule_until_reading': (PENDING, 'closure, invariance along a run (EC6b)'),
    'Becoming.RegimeMargin.Drawn.run_shape': (PENDING, 'closure, invariance along a run, by Lasting.orbit_mono (EC6b)'),
    'Becoming.RegimeMargin.Coupled.Indexed.ends_downstream': (PENDING, 'closure along a chain of dependence (EC6b)'),
    'Becoming.onLoop_of_closing': (PENDING, 'closure, the transitivity of reaching by couplings (EC6b)'),
    'Becoming.CensusWebs.keep_pace': (PENDING, "balance, the census's stretch balance (EC6b)"),
    'Becoming.Optimum.optimum_beyond': (PENDING, "balance, Outcome's clause named once (EC6c)"),
    'Becoming.Optimum.mutual_beyond': (PENDING, "balance, Outcome's clause named once (EC6c)"),
    'Becoming.Withholding.withholding_spreads': (PENDING, 'reaching within n steps, stated on the grammar (OU3d)'),
    'Becoming.Tolerance.answers_restores_iff': (PENDING, 'reaching in n steps, stated on the grammar (OU3d)'),
    'Becoming.WithinMoves.after_course': (PENDING, 'reaching within n steps, stated on the grammar (OU3d)'),
    'Becoming.Flow.selected_le': ('premise of the account', 'support: only the active give, the active are supported'),
    'Becoming.Flow.selection_within': ('premise of the account', 'support, with the counting form of Price'),
    'Becoming.Flow.transmitted_supported': ('premise of the account', 'support, with inheritance within the bound'),
    'Becoming.SelectionTerm.Flow.support_not_lower': ('premise of the account', "support, with Price's identity"),
    'Becoming.SelectionTerm.Flow.support_moved_rises': ('premise of the account', "support, with Price's identity"),
    'Becoming.GroupEnding.Flow.rises_iff_inactive': ('premise of the account', 'only the active give, with the partition'),
    'Becoming.GroupEnding.Flow.all_end': ('premise of the account', 'only the active give'),
    'Becoming.carried_iff_rising': ('premise of the account', 'support, as NeedsSupportAt'),
    'Becoming.Reproduction.Flow.number_within_take': ('premise of the account', 'dissipation'),
    'Becoming.SelectionTerm.covariation': ('counting identity', "Price's covariance, with no premise"),
    'Becoming.SelectionLevels.levels_sized': ('counting identity', "Price's partition among groups"),
    'Becoming.SelectionLevels.rises_exact_iff_levels': ('counting identity', "Price's partition, read for a rise"),
    'Becoming.Dependence.differenceOnlyTogether_iff': ('law of its model', 'the dichotomy of a determined process'),
    'Becoming.Run.not_fixes_of_untaken': ('law of its model', 'an untaken move retargeted'),
    'Becoming.SharedCodes.run_agrees_every_start_iff': ('law of its model', 'copying from an origin'),
    'Becoming.responses_le_missBound': ('law of its model', 'a bound of propagation'),
    'Becoming.Drift.falls_back': ('law of its model', 'a second-moment bound on samplings'),
    'Becoming.RelativePosition.rise_needs_fall': ('law of its model', 'a zero-sum count, by commutativity'),
    'Becoming.Web.optimum_broken_iff': ('law of its model', 'the drive to the least level'),
    'Becoming.Web.living_on_reaches': ('single application', "N_rel once; its closure form is Valuation.reaches"),
    'Becoming.Flow.descent_reaches': ('single application', "N_rel once; its closure form is Valuation.reaches"),
    'Becoming.Learning.Training.unselected_beyond_data': ('single application', 'a selection through the data, used once'),
    'Becoming.Renewable.no_exact_finite_reading': ('single application', 'a prefix reading used once; the open continuation'),
    'Becoming.Limit.identifies_iff_tracks': ('definitional or representational', 'Iff.rfl'),
    'Becoming.Ideals.verifiableBy_iff_interior': ('definitional or representational', 'Iff.rfl'),
    'Becoming.Web.renewingAt_iff_over_all': ('definitional or representational', 'a one-line unpacking'),
    'Becoming.unrestricted_iff_livingSignificance': ('definitional or representational', 'two definitions unpacked'),
    'Becoming.Valuation.significant_iff_held': ('definitional or representational', 'S0 and N_std unpacked'),
    'Becoming.Web.transmits_at_iff': ('definitional or representational', 'transmission unpacked'),
    'Becoming.Dependence.Overdetermined.only_together': ('definitional or representational', 'one line from the definitions'),
    'Becoming.Viability.kernel_and_iff': ('definitional or representational', 'logic: for all reached, and'),
    'Becoming.partForms_iff': ('definitional or representational', "a lumped map's factorization; the law is PartForms.goAlike"),
    'Becoming.Web.roles_supported': ('definitional or representational', 'the one-kind reading keeps support'),
    'Becoming.Web.roles_dependent': ('definitional or representational', 'the one-kind reading keeps dependence'),
    'Becoming.Web.roles_alive': ('definitional or representational', 'the one-kind reading keeps living'),
    'Becoming.Web.significance_undetermined': ('definitional or representational', 'a free slot shown free'),
    'Becoming.ExchangeLaw.response_not_fixed_by_coupling': ('definitional or representational', 'two laws through one coupling'),
}
NO_REASON = 'no reason given'
CATEGORIES = ('master law', 'balance, represented', 'premise of the account', 'counting identity', 'law of its model',
              'single application', 'definitional or representational', PENDING, NO_REASON)


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
    categories, dependences = {}, {}
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
            dependence = ('grammar' if g else 'balance, represented' if 'balance' in hit
                          else 'anchor, not reached' if hit else 'no master law')
            dependences[dn] = dependence
            row = {'row': r['id'], 'declaration': dn, 'grammar': g, 'laws': hit, 'dependence': dependence}
            if dependence == 'grammar':
                category = 'master law'
            elif dependence == 'balance, represented':
                category = 'balance, represented'
            elif dependence == 'anchor, not reached':
                category = 'master law' if dn in REASONS else NO_REASON
                row['reason'] = REASONS.get(dn, 'NO REASON GIVEN')
            else:
                category, reason = NO_LAW.get(dn, (NO_REASON, 'NO REASON GIVEN'))
                row['reason'] = reason
            categories[dn] = category
            row['category'] = category
            rows.append(row)
    by_dependence = {c: sum(1 for v in dependences.values() if v == c)
                     for c in ('grammar', 'balance, represented', 'anchor, not reached', 'no master law')}
    by_category = {c: sum(1 for v in categories.values() if v == c) for c in CATEGORIES}
    pending = {dn: NO_LAW[dn][1] for dn, c in categories.items() if c == PENDING}
    report = {'central_declarations': total, 'reaching_the_grammar': len(reach),
              'distinct_central_declarations': len(categories), 'distinct_by_dependence': by_dependence,
              'distinct_by_category': by_category,
              'distinct_gaps': by_category[PENDING] + by_category[NO_REASON],
              'pending_derivations': pending,
              'anchor_not_reached_reasons': {dn: REASONS.get(dn, 'NO REASON GIVEN') for dn, c in categories.items()
                                             if c == 'anchor, not reached'},
              'by_master_law_resting_and_reaching_grammar': by_law, 'anchors_reach_grammar': anchor_reach,
              'rows': rows}
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')
    print(json.dumps({k: report[k] for k in ('central_declarations', 'reaching_the_grammar',
                                             'distinct_central_declarations', 'distinct_by_dependence',
                                             'distinct_by_category', 'distinct_gaps', 'pending_derivations',
                                             'anchor_not_reached_reasons',
                                             'by_master_law_resting_and_reaching_grammar',
                                             'anchors_reach_grammar')},
                     ensure_ascii=False))


if __name__ == '__main__':
    main()
