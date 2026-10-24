#!/usr/bin/env python3
"""IV3: register the apart roots the route through dependence adds in Becoming.Weightings. The laws over any relation,
any standpoints, any possible courses and any finite listing hold with no world: general structure. The base instances
(Flow.centersWithin_*_of_common, Flow.ownClosure_*_invariant_of_common) are statements on the base and need no entry;
Copies is a constructed witness.
`forced_iff_within` and `selfAscribed_iff_withinSome` are no longer apart roots (forced_needs_iff and
selfAscribed_iff_withinSome_iff_centersWithin use them); their entries leave the register, their bytes kept in this kit's
apart-retired.json.
usage (from the checkout root): python3 -B apart.py NAME ...   (the names THEOREM-CONNECTIVITY.py --check reports)"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text(encoding='utf-8'))
M, G = 'Becoming.Weightings', 'general-structure'
B, W = 'Becoming.', 'Becoming.Weighting.'
ANY = 'a law of any relation and any assignment of centers, with no world'
COURSES = 'a law of any formations and any predicate of possible courses, with no world'
LISTING = 'a law of any finite listing and any order on courses, with no world'
REASONS = {
    B + 'withinClosure_iff_of_centersWithin': (G, 'centers within one another\'s closures have one closure: ' + ANY),
    B + 'ownClosure_standpointInvariant_iff_centersWithin': (G, 'held de se, the presupposition is standpoint-invariant '
                                                                'exactly where the centers lie within one another\'s '
                                                                'closures: ' + ANY),
    B + 'selfAscribed_iff_withinSome_iff_centersWithin': (G, 'the de se and de dicto readings agree exactly where the '
                                                             'centers lie within one another\'s closures: ' + ANY),
    B + 'Needs.refl': ('support', 'a continuation needs itself: a one-line unpacking of the module\'s own definition'),
    B + 'Needs.trans': ('support', 'need composes: a one-line unpacking of the module\'s own definition'),
    B + 'withinClosure_needs_iff': (G, 'need is its own closure: ' + COURSES),
    B + 'forced_needs_iff': (G, 'drawn along need, a standpoint\'s presupposition reaches exactly what is needed: '
                                + COURSES),
    B + 'needs_iff_only': (G, 'a member of a class of alternatives each carrying a continuation alone is needed exactly '
                              'where it is the only member: ' + COURSES),
    B + 'forced_member_iff_only': (G, 'drawn along need, the presupposition reaches a member of a class of alternatives '
                                      'exactly where it is the only member: ' + COURSES),
    B + 'Copies.two_copies': ('model-witness', 'two copies, each carrying the user alone, so the user needs some copy and '
                                               'neither: a fact about one constructed set of courses, not a law of the '
                                               'unfolding'),
    B + 'Copies.user_not_copy': ('model-witness', 'the user of the Copies witness is no copy: a fact about one '
                                                  'constructed type'),
    B + 'Copies.needsSome': ('model-witness', 'the user of the Copies witness needs some copy: a fact about one '
                                              'constructed set of courses'),
    B + 'Copies.carriesAlone': ('model-witness', 'each copy of the Copies witness carries the user alone: a fact about '
                                                 'one constructed set of courses'),
    W + 'increasingInOwn_of_increasing': (G, 'an order increasing in admission is increasing in its own continuation: '
                                             + LISTING),
    W + 'increasingInOwn_iff_increasing': (G, 'where its own continuation marks every listed item, an order is increasing '
                                              'in it exactly when it is increasing in admission: ' + LISTING),
    W + 'widensOwn_iff_every_increasingInOwn': (G, 'what every order increasing in its own continuation ranks higher is '
                                                   'exactly a widening adding to it: ' + LISTING),
    W + 'every_increasingInOwn_iff_includes': (G, 'where a course adds to its own continuation, every such order ranks it '
                                                  'above another exactly where the other keeps nothing beyond it: '
                                                  + LISTING),
    W + 'some_increasingInOwn_reverses': (G, 'where the other course keeps an item beyond, some positive weighting ranks '
                                             'it higher: ' + LISTING),
    W + 'includes_of_ended': ('support', 'a course admitting nothing from an ending on and agreeing before is included: '
                                         'an unpacking of inclusion on listed items'),
    W + 'ended_below': (G, 'the ending of what everything needs is ranked below from every standpoint whose own '
                           'continuation the other course adds to: ' + LISTING),
}
RETIRE = ['Becoming.forced_iff_within', 'Becoming.selfAscribed_iff_withinSome']
retired = {'about': 'Apart-register entries retired by IV3 (23 October 2026): each theorem is now used by a theorem IV3 '
                    'added, so it is no longer an apart root. Bytes as they stood in THEOREM-CONNECTIVITY-APART.json.',
           'roots': {}}
for name in RETIRE:
    assert register['roots'][name]['module'] == M, name
    retired['roots'][name] = register['roots'].pop(name)
(HERE / 'apart-retired.json').write_text(json.dumps(retired, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
names = sys.argv[1:]
assert names, __doc__
for name in names:
    assert name in REASONS, ('no reason prepared for', name)
    assert name not in register['roots'], name
    category, reason = REASONS[name]
    register['roots'][name] = {'module': M, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('registered', len(names))
