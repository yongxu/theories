#!/usr/bin/env python3
"""LA4's formal part: register the apart roots the connectivity check lists without a reason that are LA4's, with a
category and a reason; stop on any other root, which belongs to its owner, and on a stale entry, which LA4 does not
expect.

* Becoming.OptimumSeason states one constructed season and the optimum laws it meets: its roots are facts about that
  season (model-witness).
* Becoming.WeightedCommuting states laws of every weighted law on any type (general-structure: the base states no
  weighted law, so nothing on it uses them) and two witnesses, Reinforcing and Pooling (model-witness).

A reason is given for every theorem that can be a root; only those the check lists are written. Textual edits, the
rest of the file byte for byte (register_u3.py's pattern).
usage (from the checkout root): python3 -B register_la4.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale_names = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale_names, ('stale entries: LA4 retires none; their owners do', stale_names)

SEASON, WEIGHTED = 'Becoming.OptimumSeason', 'Becoming.WeightedCommuting'
S, W = 'Becoming.Optimum.Season.', 'Becoming.Weighted.'
ONE = "LA4's season as season.py runs it, one constructed set of outcomes: "
season = {
    'bay_drained': "with the catch sharing units with the bay, every optimum of every order rising with the catch "
                   "empties the bay, the shared case of Optimum.least_of_shared",
    'site_optima': "among the optima of the order by the catch are a season landing beside the nests never and one "
                   "landing there at every step",
    'site_no_room': "there is no room at the landing site for the order by the catch, so Optimum.least_of_room does "
                    "not apply there",
    'site_not_least': "an optimum of the order by the catch need not stand at the site's least level",
    'ground_rising': "the order by the ground's catch rises with the ground's catch",
    'unshared_optima': "among the optima of the order by the ground's catch are a season keeping the bay at six and "
                       "one emptying it",
    'unshared_no_room': "ranked by the ground's catch alone there is no room at the bay, which shares no units with "
                        "what is ranked",
    'after_drained': "the optima of seven times the catch plus the bay left empty the bay: counting the bay after "
                     "the catch changes nothing",
    'plateau_not_rising': "valuing the catch only up to 26 does not rise with the catch",
    'plateau_optima': "among the optima of the plateau order are a season keeping the bay at six and one emptying it",
    'mix_bay_catch': "over weighted seasons the weighted bay left plus the weighted catch is at most 40 times the "
                     "total weight",
    'mix_kept': "over weighted seasons the weighted catch plus three times the weight keeping the bay at three or "
                "more is at most 40 times the total weight",
    'top_frontier': "a season catching 40 is an optimum of the order by the catch",
    'ground_frontier': "a season whose ground catch is 34 is an optimum of the order by the ground's catch",
    'plateau_frontier': "a season catching at least 26 is an optimum of the plateau order",
    'top_caught': "one season's takes reach the ground's best catch of 34",
    'best_ten': "the ground's best catch over ten steps from ten is 34, by evaluation",
    'renew_le': "the renewal keeps every level up to ten within ten, by evaluation",
}
general = ("a law of every weighted law on any type commuting with any map, the weights of any type; the base states "
           "no weighted law, so nothing on it uses this law")
weighted = {
    'Commutes.carried': (general, 'general-structure'),
    'Commutes.fixed_expect': (general, 'general-structure'),
    'Commutes.start_expect': (general, 'general-structure'),
    'Commutes.of_samples': ("when a law drawing weighted samples and moving by an update commutes with a map, over "
                            "any type; the base states no sampling law, so nothing on it uses this law",
                            'general-structure'),
    'law_commutes': ("a determined law commuting with a map is a weighted law with one successor of weight one "
                     "commuting with it, over any type; the base states no weighted law", 'general-structure'),
    'Reinforcing.commutes': ("Reinforcing, drawing a value in proportion to its count and adding one to it, commutes "
                             "with the exchange: a fact about one constructed law", 'model-witness'),
    'Reinforcing.expect_equal': ("in Reinforcing, from equal counts the expected counts stay equal at every step: a "
                                 "fact about one constructed law", 'model-witness'),
    'Reinforcing.oneSided': ("in Reinforcing a run drawing one value at every one of any number of steps has "
                             "positive weight: a fact about one constructed law, the witness that equal expectations "
                             "allow arbitrarily long one-sided runs", 'model-witness'),
    'Pooling.commutes': ("Pooling, adding one to both values, commutes with the exchange: a fact about one constructed "
                         "law", 'model-witness'),
    'Pooling.run_counts': ("Pooling's run from counts of three and one: a fact about one constructed law",
                           'model-witness'),
    'Pooling.share_rises': ("in Pooling from three and one the less-drawn value's share rises at every step: a fact "
                            "about one constructed law, the witness that a commuting law can wear a start's "
                            "preference away", 'model-witness'),
    'Pooling.share_below_half': ("in Pooling from three and one the less-drawn value's share stays below one half: a "
                                 "fact about one constructed law", 'model-witness'),
}
reasons = {S + k: (SEASON, 'model-witness', ONE + v + ' (LA4)') for k, v in season.items()}
reasons.update({W + k: (WEIGHTED, c, v + ' (LA4)') for k, (v, c) in weighted.items()})

mine = [n for n in unclassified if n.startswith((S, W))]
others = [n for n in unclassified if n not in mine]
assert not others, ("apart roots not LA4's: read them; another session's belong to their owners", others)
missing = [n for n in mine if n not in reasons]
assert not missing, ('LA4 roots with no reason here: add one', missing)
t = F.read_text(encoding='utf-8')
block = ''
for name in mine:
    module, category, reason = reasons[name]
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": ' + json.dumps(module) + ',\n'
              '   "category": ' + json.dumps(category) + ',\n   "reason": ' + json.dumps(reason, ensure_ascii=False)
              + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(mine), mine)
