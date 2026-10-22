#!/usr/bin/env python3
"""VT1: register the apart roots of the net weightings, the rankings of presentations and the weights within a ratio
in Becoming.Weightings. The laws hold over any finite listing, any weights and any ranking of any presentations, with no
world: general structure; Framed and Interacting are constructed witnesses; widensOn_of_widensBy unpacks a definition.

usage: python3 -B apart.py   (once, from the checkout root)"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
REGISTER = HERE.parents[1] / 'THEOREM-CONNECTIVITY-APART.json'
register = json.loads(REGISTER.read_text())
M, G = 'Becoming.Weightings', 'general-structure'
W = 'Becoming.Weighting.'
NEW = {
    W + 'narrower_above_net': (M, G,
        'a ranking of presentations putting a narrowing above its widening by one item does not read the pair as a net '
        'weighting ranks the sets, or the item weighs at zero or below: a law of any finite listing, any net weighting and '
        'any ranking of any presentations, with no world'),
    W + 'reads_ranksNet': (M, G,
        'read right, a net weighting puts a narrowing above its widening by one item exactly where the item weighs below '
        'zero: a law of any finite listing, any net weighting and any ranking of any presentations, with no world'),
    W + 'reads_ranksNet_widens': (M, G,
        'read right on every pair, a net weighting with every item above zero never ranks a widening below: a law of any '
        'finite listing, any net weighting and any ranking of any presentations, with no world'),
    W + 'reads_increment': (M, G,
        'read right, a sign measured apart fixes the verdict exactly where it is the sign of the increment in the pair\'s '
        'context: a law of any order on courses, any ranking of any presentations and any sign, with no world'),
    W + 'ranksNet_ties': (M, G,
        'a net weighting ranks a widening by one item weighing zero neither above nor below: a law of any finite listing '
        'and any net weighting, with no world'),
    W + 'every_within_iff': (M, G,
        'every positive weighting within n / d ranks a above b exactly where n q < d p: a law of any finite listing and any '
        'ratio bound, with no world'),
    W + 'opposite_within_iff': (M, G,
        'two positive weightings within n / d rank a pair opposite ways exactly where d q < n p and d p < n q: a law of any '
        'finite listing and any ratio bound, with no world'),
    W + 'tilted_ties': (M, G,
        'on the boundary n q = d p the weighting tilted toward the smaller side ties the two courses: a law of any finite '
        'listing and any ratio, with no world'),
    W + 'widensOn_of_widensBy': (M, 'support',
        'a widening by one item alone is a widening: a one-line unpacking of the module\'s own definitions'),
    'Becoming.Framed.framing_alone': (M, 'model-witness',
        'one item weighing one for and nothing against, where a framed presentation keeping nothing is ranked above an '
        'unframed one keeping the item; a fact about one constructed ranking, not a law of the unfolding'),
    'Becoming.Interacting.not_net': (M, 'model-witness',
        'two items, adding one raising a course keeping nothing and lowering one keeping the other, an order no net '
        'weighting gives; a fact about one constructed order, not a law of the unfolding'),
}
for name, (module, category, reason) in NEW.items():
    assert name not in register['roots'], name
    register['roots'][name] = {'module': module, 'category': category, 'reason': reason}
REGISTER.write_text(json.dumps(register, ensure_ascii=False, indent=1) + '\n')
print('registered', len(NEW))
