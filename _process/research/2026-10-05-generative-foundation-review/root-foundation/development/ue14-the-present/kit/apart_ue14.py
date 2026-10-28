#!/usr/bin/env python3
"""UE14: register the module's twenty-three apart roots in THEOREM-CONNECTIVITY-APART.json, each with the category
and reason the connectivity check asks for, and retire one entry. The main laws are stated on the courses of the
growth (the course forms, `Run process` from the empty set), so the laws on natural labellings they use connect to the
base; what stays apart: the witnesses are facts about one constructed causal set or relation (model witness), the
calibrations are the exact principle of logic each law on courses needs (calibration, each with its course form on the
base), two laws on natural labellings and one of order theory name no course (general structure), one restates the
present at a stage on the grammar (restates), and two unpack definitions (support). UE13's
`CausalGrowth.ordered_reach_links_iff` is now used by an apart theorem, `least_iff_only_link`, so it is no longer an
apart root and its entry retires; its reason is carried by `least_iff_only_link`'s. Run after the checker and before
the connectivity check; each new entry is asserted new.
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue14.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
REGISTER = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
M = 'Becoming.Presence'
WITNESS = f'a witness of {M} (UE14)'
RETIRED = ['Becoming.CausalGrowth.ordered_reach_links_iff']


def entry(category, reason):
    return {'module': M, 'category': category, 'reason': reason}


NEW = {
    # witnesses
    f'{M}.Vee.link': entry(
        'model-witness', 'on the vee, 0 below 1 and 2, 0 is a link below 2, by its presence at 2\'s birth on one '
                         f'course: a fact about one constructed causal set; {WITNESS}'),
    f'{M}.Vee.not_least': entry(
        'model-witness', 'on the vee, 2 is not the least element above 0: were it, 0 would be present at 2\'s birth '
                         'on every course (present_every_iff), and on the labels as they are it is not; a fact about '
                         'one constructed causal set, showing that presence on some course does not give presence on '
                         f'every course; {WITNESS}'),
    f'{M}.Vee.maximal_after_two_identity': entry(
        'model-witness', 'on the vee, the present after two births on the labels as they are is exactly 1: a fact '
                         'about one constructed causal set and one of its natural labellings, the witness that the '
                         f'present at a stage is a choice of course; {WITNESS}'),
    f'{M}.Vee.maximal_after_two_swap': entry(
        'model-witness', 'on the vee, with the births of 1 and 2 exchanged, the present after two births is exactly 2: '
                         'a fact about one constructed causal set and one of its natural labellings, the witness that '
                         f'the present at a stage is a choice of course; {WITNESS}'),
    f'{M}.Diamond.pastOrPair_refl': entry(
        'model-witness', "Wüthrich and Callender's relation on their four elements is reflexive: a fact about one "
                         "constructed relation, one of the conditions of Stein's theorem it meets"),
    f'{M}.Diamond.pastOrPair_trans': entry(
        'model-witness', "Wüthrich and Callender's relation on their four elements is transitive: a fact about one "
                         "constructed relation, by cases on the elements, one of the conditions of Stein's theorem it "
                         'meets'),
    f'{M}.Diamond.courses_disagree': entry(
        'model-witness', 'on the diamond, exchanging the births of 1 and 2 is a natural labelling bearing 2 before 1: '
                         'a fact about one constructed causal set, the witness that the courses disagree on the order '
                         f'of births of that pair; {WITNESS}'),
    f'{M}.Diamond.kept_not_agreed': entry(
        'model-witness', "on the diamond, Wüthrich and Callender's relation is kept by every automorphism and is not "
                         'what every course has born by a birth: a fact about one constructed causal set and relation, '
                         'showing that invariance under automorphisms admits a relation beyond the past; '
                         f'{WITNESS}'),
    f'{M}.Diamond.pastOrTogether_iff': entry(
        'model-witness', 'on the diamond, the past joined with being present together on every course is exactly '
                         "Wüthrich and Callender's relation: a fact about one constructed causal set, by "
                         f'pastOrPair_iff_together; {WITNESS}'),
    f'{M}.SameFuture.together_different_pasts': entry(
        'model-witness', 'on four elements, 0 below 1 and 3, 1 and 2 below 3, the elements 1 and 2 are present '
                         'together on every course with different pasts: a fact about one constructed causal set, '
                         f'showing that being present together on every course needs only the same future; {WITNESS}'),
    f'{M}.SameFuture.pastOrTogether_not_trans': entry(
        'model-witness', 'on the same four elements, the past joined with being present together on every course is '
                         "not transitive: a fact about one constructed causal set, showing that off Wüthrich and "
                         f"Callender's four elements the join need not be their relation; {WITNESS}"),
    # calibrations
    f'{M}.past_every_iff_em': entry(
        'calibration', 'that what is born no later than an element in every natural labelling is its past, asked of '
                       'every causal set, is exactly excluded middle: agreement across all courses settles precedence '
                       'only up to double negation, and asserting it is deciding; the base asserts no decided '
                       "precedence, so this is a lemma of UE14's law, whose course form past_every_course is on the "
                       'base'),
    f'{M}.together_every_iff_em': entry(
        'calibration', 'that two elements present together in every natural labelling share their future, asked of '
                       'every causal set, is exactly excluded middle; a lemma of UE14\'s law, whose course form '
                       'together_every_course is on the base'),
    f'{M}.only_link_least_iff_em': entry(
        'calibration', 'that the one link of a condition is the least element above it, asked of every causal set, is '
                       'exactly excluded middle: settling everything a condition precedes from its links alone is '
                       "deciding; a lemma of UE14's law on presence on every course, whose course form "
                       'present_every_course_only_link needs no decision and is on the base'),
    f'{M}.before_some_iff_weakly': entry(
        'calibration', 'that two different elements, the second not preceding the first, are born in that order in '
                       'some natural labelling, asked of every causal set, is exactly weak excluded middle: finding the '
                       'course is deciding only whether a precedence fails; a lemma of UE14\'s law, whose course form '
                       'before_some_course is on the base'),
    f'{M}.antichain_present_iff_weakly': entry(
        'calibration', 'that every antichain given by a test is the present of some natural labelling at some stage, '
                       'asked of every causal set, is exactly weak excluded middle; a lemma of UE14\'s law, whose '
                       'course form antichain_present_course is on the base'),
    f'{M}.present_some_iff_weakly': entry(
        'calibration', 'that every link is present at the birth of what it conditions in some natural labelling, '
                       'asked of every causal set, is exactly weak excluded middle; a lemma of UE14\'s law, whose '
                       'course form present_some_course is on the base'),
    # laws naming no course
    f'{M}.every_congr': entry(
        'general-structure', 'whatever holds in every natural labelling of a causal set depends only on its size and '
                             'precedence: a law of the linear extensions of every finite order, naming no process; '
                             'the courses read it through every_course_iff'),
    f'{M}.some_congr': entry(
        'general-structure', 'whatever holds in some natural labelling of a causal set depends only on its size and '
                             'precedence: a law of the linear extensions of every finite order, naming no process; '
                             'the courses read it through some_course_iff'),
    f'{M}.least_iff_only_link': entry(
        'general-structure', 'with precedence decided, the least element above a condition is exactly the one element '
                             'it is linked to: a law of every transitive naturally labelled relation on the numbers, '
                             "by UE13's ordered_reach_links_iff (precedence the reach of its links, with "
                             'reach_links_courses_iff_em its calibration on courses), on one configuration and naming '
                             'no process'),
    f'{M}.maximalBorn_iff_ends': entry(
        'restates', 'MaximalBorn read on the grammar: an element is in the present at a stage exactly where the '
                    "grammar's ending, «亡» under the one class «一», holds on what has been born"),
    f'{M}.present_iff_maximalBorn': entry(
        'support', 'in a natural labelling, presence at a birth is precedence with being maximal among what is born by '
                   "that birth's stage: an unpacking of the definitions of PresentAt and MaximalBorn"),
    f'{M}.born_stem': entry(
        'support', 'what a natural labelling has born by a stage is a stem: an unpacking of the definitions of a stem '
                   'and of a natural labelling (born_closed); its course reading, every stem with decided '
                   'membership born first, is stem_born_first_course, on the base'),
}
assert len(NEW) == 23, len(NEW)
raw = REGISTER.read_text(encoding='utf-8')
register = json.loads(raw)
assert json.dumps(register, ensure_ascii=False, indent=1) + '\n' == raw, 'the register is not in its usual format'
for name in RETIRED:
    assert name in register['roots'], name
    del register['roots'][name]
for name in NEW:
    assert name not in register['roots'], name
    assert NEW[name]['category'] in register['categories'], NEW[name]['category']
register['roots'].update(NEW)
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('apart register: added', len(NEW), 'roots of', M, '; retired', RETIRED)
