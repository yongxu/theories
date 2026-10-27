#!/usr/bin/env python3
"""UE13: register the module's sixteen apart roots in THEOREM-CONNECTIVITY-APART.json, each with the category and
reason the connectivity check asks for: the laws on links and on causal sets name no process (general structure or
support), the witnesses are facts about one constructed order or relation (model witness), and the one calibration
on configurations is excluded middle, whose course form `reach_links_courses_iff_em` is on the base. No entry retires.
Run after the checker and before the connectivity check; each entry is asserted new.
usage (from the checkout root of the landing worktree): python3 -B <kit>/apart_ue13.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
REGISTER = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
M = 'Becoming.CausalGrowth'
WITNESS = f'a witness of {M} (UE13)'


def entry(category, reason):
    return {'module': M, 'category': category, 'reason': reason}


NEW = {
    f'{M}.links_le': entry(
        'support', "a link of a relation is a pair of it: a one-line unpacking of the module's definition of links, "
                   'on any carrier'),
    f'{M}.links_least': entry(
        'general-structure', 'every net whose reach is a relation contains that relation\'s links: a law of every '
                             'relation on any carrier; the base supplies no reading of links, which UE13 reads on the '
                             'configurations of causal-set growth'),
    f'{M}.nat_reach_links': entry(
        'model-witness', 'on all the numbers in their order every pair is reached by links: a fact about one '
                         'infinite naturally labelled order, the limit of the chain, showing that reaching by links '
                         f'needs no finiteness; {WITNESS}'),
    f'{M}.path_not_reach_of_links': entry(
        'model-witness', 'on the path 0 to 1 to 2 the links reach the pair (0, 2), which the path does not relate: a '
                         'fact about one constructed relation, showing that without transitivity only one inclusion '
                         f'holds; {WITNESS}'),
    f'{M}.OmegaPlusOne.prec_irrefl': entry(
        'model-witness', 'the order of ω + 1 is irreflexive: a fact about one constructed order, the witness of '
                         'OmegaPlusOne.not_reach_top'),
    f'{M}.OmegaPlusOne.prec_trans': entry(
        'model-witness', 'the order of ω + 1 is transitive: a fact about one constructed order, the witness of '
                         'OmegaPlusOne.not_reach_top'),
    f'{M}.OmegaPlusOne.between': entry(
        'model-witness', 'every positive number lies between 0 and the top of ω + 1, so the interval is infinite: a '
                         'fact about one constructed order, the witness of OmegaPlusOne.not_reach_top'),
    f'{M}.OmegaPlusOne.not_reach_top': entry(
        'model-witness', 'on ω + 1, 0 precedes the top and the links never reach it: a fact about one constructed '
                         'order, naming no process, showing that precedence need not be the reach of its links where '
                         f'an interval is infinite; {WITNESS}'),
    f'{M}.Causet.Ordered.acyclic': entry(
        'support', "a causal set's precedence has no cycle (the root's «无环»), by its natural labelling "
                   "(labelled_of_reach): an unpacking of the module's definition of a causal set, whose reach is "
                   'then a strict order by the root\'s «无环则及为序»; every configuration the growth reaches from a '
                   'causal set is one (birth_ordered)'),
    f'{M}.ordered_reach_links_iff': entry(
        'general-structure', 'on every causal set with decided precedence, precedence is the reach of its links: '
                             'reach_links_iff, a law of every transitive naturally labelled relation on the numbers, '
                             "read on the module's causal sets; the statement concerns one configuration and names no "
                             'process, and the course form is reach_links_courses_iff_em'),
    f'{M}.reach_links_all_iff_em': entry(
        'calibration', 'that every pair of every causal set is reached by links is exactly excluded middle (the '
                       'witness Undecided.third): telling a link, a direct condition, from a longer chain is deciding '
                       'whether anything lies between; the base asserts no decided precedence, so this is a lemma of '
                       "UE13's law on links, whose course form is reach_links_courses_iff_em"),
    f'{M}.birth_maximal': entry(
        'support', "a birth's new element precedes nothing: a one-line unpacking of the module's definition of a "
                   'birth, the move of the growth'),
    f'{M}.not_stem_all_birth': entry(
        'support', 'all the elements after a birth are not a stem before it, since the new element is not yet there: '
                   "a one-line unpacking of the module's definitions of a stem and a birth"),
    f'{M}.ordered_not_renews': entry(
        'general-structure', "no causal set's precedence, nor its links, renews without end (the root's «生生») in "
                             'any class: a law of every naturally labelled order on the numbers, through the root\'s '
                             'renewal, on one configuration and naming no process; every configuration the growth '
                             'reaches from a causal set is one (birth_ordered)'),
    f'{M}.Halves.pairs_class': entry(
        'model-witness', 'the relation pairing 2m with 2m + 1 is a class: a fact about one constructed relation, the '
                         "class in which the chain's limit renews without end (chainLimit_renews)"),
    f'{M}.Finer.classOf_class': entry(
        'model-witness', 'the relation telling 1 from the other elements is a class: a fact about one constructed '
                         'relation, the class on which widening gains continuation read on links (Finer.widens, '
                         'Finer.continues, Finer.not_continues) and loses it (Finer.loses)'),
}
raw = REGISTER.read_text(encoding='utf-8')
register = json.loads(raw)
assert json.dumps(register, ensure_ascii=False, indent=1) + '\n' == raw, 'the register is not in its usual format'
for name in NEW:
    assert name not in register['roots'], name
    assert NEW[name]['category'] in register['categories'], NEW[name]['category']
register['roots'].update(NEW)
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('apart register: added', len(NEW), 'roots of', M)
