#!/usr/bin/env python3
"""EL's landing (register_bd3.py's pattern): register the apart roots the connectivity check lists without a reason
that are EL's, each with a category and a reason; stop on any other root, which belongs to its owner, and on any stale
entry, which EL's change (six leaves, no existing module changed) does not explain and is read first.

The categories follow the neighbours' entries: SelectionTerm's, Reproduction's and SelectionLevels' laws of listed
generations are general structure, their constructed families model witnesses; MapRegions' laws of the map are
general structure, its excluded-middle equivalences calibrations. The shift identities are support (SelectionShift's
docstring: an arithmetic identity, not a new law).

Textual edits, the rest of the file byte for byte (register_bd3.py's pattern).
usage (from the checkout root): python3 -B register_el.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale, ("stale entries EL's change does not explain: read them", stale)

GENS = ('a law of any listed generations, each the offspring of the last, with no world; generations of descent in a '
        'flow (SelectionTerm.Flow.Descended) are one case, read on the map by Becoming.LineageRegions (EL1)')
FAMILY = 'a law of any finite family read with weights and amounts, with no world (EL1)'
LINE = ('a law of the map for any relation on occurrences (step, formation) and any listed generations, read on no '
        'world; the lineage continuation on the World\'s webs is its case, with the witnesses Courses and Chain (EL1)')
SHAPED = ('a law of the carrier counts after shaping for any natural factors, a corollary of RuleShaping\'s laws with '
          'the count of steps cancelled, with no world; the pair runs of PairSelection supply its counts (EL4b)')
WIT = 'a fact about one constructed course of generations, not a law of the unfolding (EL1)'
W, R, M, P, S, L, G = ('model-witness', 'general-structure', 'support', 'calibration', 'Becoming.SelectionShift',
                       'Becoming.LineageRegions', 'general-structure')
REASONS = {
    # EL3
    'Becoming.Map.not_not_end_of_ends': ('Becoming.LineDegeneration', G,
        'ending on every branch reaches an end up to double negation: a law of the map for every carrier and pair of '
        'relations, read on no model; the World\'s lines are its case (EL3)'),
    'Becoming.Map.end_of_ends_iff_excluded_middle': ('Becoming.LineDegeneration', P,
        'that every line ending on every branch reaches an end, at every carrier and relation, is exactly excluded '
        'middle; the base form, Map.end_of_gone_iff_excluded_middle, is on the World (EL3)'),
    # EL1, counting
    'Becoming.SelectionShift.concord_shift': (S, M, 'a common shift of the weights leaves concordance unchanged: an '
        'arithmetic identity on lists, through excess_shift (EL1)'),
    'Becoming.SelectionShift.discord_shift': (S, M, 'a common shift of the weights leaves discordance unchanged: an '
        'arithmetic identity on lists, through excess_shift (EL1)'),
    'Becoming.SelectionShift.concord_shift_amount': (S, M, 'a common shift of the amount leaves concordance unchanged: '
        'an arithmetic identity on lists, through excess_shift (EL1)'),
    'Becoming.SelectionShift.discord_shift_amount': (S, M, 'a common shift of the amount leaves discordance unchanged: '
        'an arithmetic identity on lists, through excess_shift (EL1)'),
    'Becoming.SelectionShift.weighted_shift': (S, M, 'a common shift of the weights moves the weighted total by the '
        'shift times the total amount: an arithmetic identity on lists (EL1)'),
    'Becoming.SelectionShift.pos_weight_of_discord': (S, M, 'positive discordance needs a positive weight: a list '
        'lemma, the discordance half of pos_weight_of_varies (EL1)'),
    'Becoming.SelectionShift.Generations.goes_on_iff': (S, R, 'with exact transmission of offspring number at every '
        'step from t, every later generation is nonempty exactly where the one after t is: ' + GENS),
    'Becoming.SelectionShift.Generations.never_empties_while': (S, R, 'from a nonempty first generation, a term positive '
        'at every nonempty generation keeps every generation nonempty: ' + GENS),
    'Becoming.SelectionShift.Horizon.going_goes_on_of_selection': (S, R, 'where the term at the horizon is positive, '
        'the course going on past it is nonempty at every later generation: ' + GENS),
    'Becoming.SelectionShift.Horizon.zero_after_two_fates': (S, R, 'terms zero after the horizon, the next generation '
        'nonempty, are shared by a course that goes on and one that ends: ' + GENS),
    'Becoming.SelectionShift.Horizon.terms_boundary': (S, R, 'the two cases of the terms boundary joined, a '
        'restatement of never_empties_of_unbounded and eventually_zero_two_fates: ' + GENS),
    'Becoming.SelectionShift.Alternating.unbounded_not_every': (S, W, 'a course concordant at every even step and with '
        'no terms at every odd one, two members at every generation: ' + WIT),
    'Becoming.SelectionShift.ExactOnce.exact_once_ends': (S, W, 'exact at step 0 and not at step 1, concordant at step '
        '0, and empty from generation 3 on: ' + WIT),
    'Becoming.SelectionShift.OneLine.goes_on_premises': (S, W, 'one member leaving one like itself beside one leaving '
        'none meets every premise of goes_on: ' + WIT),
    'Becoming.SelectionShift.OneLine.shift_step_premises': (S, W, 'the same family with offspring numbers shifted by '
        'two meets the premises of shift_step: ' + WIT),
    'Becoming.SelectionShift.Shrinking.positive_then_empty': (S, W, 'positive concordance at every step but the last '
        'while the family shrinks to nothing: ' + WIT),
    'Becoming.SelectionShift.ZeroTerm.decides_nothing': (S, W, 'one offspring each and none each, both exact with no '
        'terms, the first going on and the second ending: ' + WIT),
    'Becoming.SelectionShift.Horizon.zero_after_premises': (S, W, 'the steady course gone on past a horizon meets the '
        'premises of zero_after_two_fates: ' + WIT),
    # EL1, on the map
    'Becoming.LineageRegions.degenerates_iff_line_ends': (L, R, 'where every continuation of a member is one of its '
        'listed offspring, a member degenerates exactly where at some depth it has no listed descendant: ' + LINE),
    'Becoming.LineageRegions.generation_degenerates_iff': (L, R, 'where listed offspring continue their parents and the '
        'census holds every continuation, a whole generation degenerates exactly where a later one is empty: ' + LINE),
    'Becoming.LineageRegions.not_all_degenerate_of_positive': (L, R, 'a term positive at every step from t leaves not '
        'every member of generation t degenerating, where listed offspring continue their parents: ' + LINE),
    'Becoming.LineageRegions.not_all_degenerate_while': (L, R, 'from a nonempty generation, a term positive at every '
        'nonempty generation leaves not every member degenerating, where listed offspring continue their parents: '
        + LINE),
    # EL2
    'Becoming.LineageRegimes.MultiplyingTakers.family_two': ('Becoming.LineageRegimes', W, 'generation two of the '
        'multiplying takers lists four takers, by evaluation: a fact about one constructed course, not a law of the '
        'unfolding (EL2)'),
    'Becoming.LineageRegimes.MultiplyingTakers.family_three': ('Becoming.LineageRegimes', W, 'generation three of the '
        'multiplying takers is empty, by evaluation: a fact about one constructed course, not a law of the unfolding '
        '(EL2)'),
    # EL4a
    'Becoming.WindowedWaiting.pairKeepsInclusion_table_iff': ('Becoming.WindowedWaiting', R, 'a decided one-step law '
        'of a pair keeping mutual giving keeps inclusion exactly where it is one of five tables: a law of every '
        'two-input Bool law, with no world (EL4a)'),
    'Becoming.WindowedWaiting.agreement_not_keeps': ('Becoming.WindowedWaiting', W, 'agreement, the one law that '
        'restores and answers, does not keep inclusion: a fact about one law of a pair, not a law of the unfolding '
        '(EL4a)'),
    'Becoming.WindowedWaiting.windowTwo_keeps': ('Becoming.WindowedWaiting', W, 'answering within a window of two '
        'keeps inclusion: a fact about one law of a pair, not a law of the unfolding (EL4a)'),
    'Becoming.WindowedWaiting.erring_keeps': ('Becoming.WindowedWaiting', R, 'each time\'s law of a window under a '
        'supplied error pattern keeps inclusion: a law of every window, error pattern and waiting relation on any '
        'type, with no world (EL4a)'),
    'Becoming.WindowedWaiting.Pair.pairKeepsInclusion_iff_induced': ('Becoming.WindowedWaiting', R, 'a two-input Bool '
        'law keeps inclusion exactly where some Prop-valued law agreeing with it induces one keeping inclusion on the '
        'pair\'s configurations: the bridge between the decided laws and Tolerance\'s, for every two-input law (EL4a)'),
    'Becoming.WindowedWaiting.Pair.induced_partner': ('Becoming.WindowedWaiting', M, 'answering is the law the '
        'partner\'s step induces: a one-line unpacking of the module\'s own definitions (EL4a)'),
    'Becoming.WindowedWaiting.Pair.all_agreeing_keeps_em': ('Becoming.WindowedWaiting', P, 'were every Prop-valued law '
        'agreeing with answering to induce a law keeping inclusion, excluded middle would hold: a lemma of the bridge, '
        'a calibration of the logic (EL4a)'),
    # EL4b
    'Becoming.PairSelection.pairs_rises_iff': ('Becoming.PairSelection', R, 'SelectionLevels.rises_iff_sized with '
        'groups of two, a wrapper: a law of any finite family listed by pairs, read with weights and amounts, with no '
        'world (EL4b)'),
    'Becoming.PairSelection.assorted_disfavours_iff': ('Becoming.PairSelection', R, 'under complete assortment the '
        'carrier is weakly disfavoured exactly where a withheld step weighs at least a received one: ' + SHAPED),
    'Becoming.PairSelection.assorted_neutral': ('Becoming.PairSelection', R, 'with the two factors equal, selection '
        'leaves the share as it is: ' + SHAPED),
    'Becoming.PairSelection.window_echo_favours_iff': ('Becoming.PairSelection', R, 'with one error a pair, window '
        'pairs are weakly favoured over answerer pairs exactly where a received step weighs at least a withheld one, a '
        'wrapper of assorted_favours_iff: ' + SHAPED),
    'Becoming.PairSelection.window_echo_select_iff': ('Becoming.PairSelection', R, 'with one error a pair, selection '
        'raises the window pairs\' share strictly exactly where a received step weighs more, and lowers it strictly '
        'exactly where it weighs less, a wrapper of the assorted laws: ' + SHAPED),
    'Becoming.PairSelection.window_alternator_favours_iff': ('Becoming.PairSelection', R, 'window pairs against '
        'alternator pairs are weakly favoured exactly where a received step weighs at least a withheld one: ' + SHAPED),
    'Becoming.PairSelection.cohort_paired': ('Becoming.PairSelection', W, 'every group of the witness cohort is a pair: '
        'the witness meets the premise of never_rises_in_pairs, a cohort listed as pairs (EL4b)'),
}
others = [n for n in unclassified if n not in REASONS]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    module, cat, reason = REASONS[name]
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "' + module + '",\n   "category": "'
              + cat + '",\n   "reason": ' + json.dumps(reason, ensure_ascii=False) + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
missing = sorted(set(REASONS) - set(unclassified))
print('register: added', len(unclassified), '; listed here but not apart roots now:', missing)
