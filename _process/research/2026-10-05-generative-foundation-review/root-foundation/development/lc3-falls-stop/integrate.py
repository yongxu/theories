#!/usr/bin/env python3
"""Join LC3 to the core package: copy Becoming.LeastLoss and Becoming.InAmounts in, restate their root doc
bullets, checker scope texts and README rows. usage (from the checkout root): python3 -B integrate.py"""
import shutil
from pathlib import Path
HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'

def edit(path, pairs):
    text = path.read_text(encoding='utf-8')
    for old, new in pairs:
        assert text.count(old) == 1, ('edit does not match once', path.name, old[:90], text.count(old))
        text = text.replace(old, new)
    path.write_text(text, encoding='utf-8')
    print('edited', path.name, len(pairs))

for mod in ('LeastLoss', 'InAmounts'):
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{mod}.lean', PKG / 'Becoming' / f'{mod}.lean')
    print('copied', mod)

edit(PKG / 'Becoming.lean', [
('''  loss there, and with every premise read as far as can be refuted its falls stop, unrefuted; and under a law that merges nothing a part's narrowing is kept by the rest, the''',
'''  loss there, and with every premise read as far as can be refuted its falls stop, unrefuted. That
  the strict falls stop is the one premise both routes give: a least fall in Archimedean amounts
  leaves no amount falling without end, as in whole numbers, while dyadic amounts (no least fall)
  and layered amounts (not Archimedean) fall without end; and under a law that merges nothing a part's narrowing is kept by the rest, the'''),
('''* `Becoming.InAmounts` (L1): the rest theorem over any amounts, read finitely. A world's
  standings, takes and gives read in any amounts, its activity and what takes part its own: a
  family balanced (no amount made) and dissipated on (whatever gives back all it takes takes
  nothing) has a total that does not rise and falls strictly at every change of a member's
  level, with no least loss. Where that total, or the census's, is read off configurations a
  list holds, the world rests from some step on, unrefuted, enclosed at each step or covered by
  one family; whole-number worlds are the instance, and a standing halving as it passes between
  two relata arises and ceases without end, its levels held by no list.
''',
'''* `Becoming.InAmounts` (L1): the rest theorem over any amounts. A world's standings, takes and
  gives read in any amounts, its activity and what takes part its own: a family balanced (no
  amount made) and dissipated on (whatever gives back all it takes takes nothing) has a total
  that does not rise and falls strictly at every change of a member's level, with no least loss,
  so it stops changing exactly where its total stops falling. Where the census's total stops
  falling, the world rests from some step on, unrefuted, enclosed at each step or covered by one
  family; a finite reading gives that premise, and so do amounts with no endless fall, where
  every such world rests, whole-number worlds with their own premises the instance. Along any
  amount falling at every step a standing passing between two relata meets every other premise
  and arises and ceases without end, its levels held by no list.
'''),
])

edit(PKG / 'check_becoming.py', [
('''    "not refuted that they stop cannot be refuted, along a run of every process too, and the "
    "halving stock's values are no list's; under''',
'''    "not refuted that they stop cannot be refuted, along a run of every process too, and the "
    "halving stock's values are no list's; where every strict fall is by at least an amount above "
    "nothing and the amounts are Archimedean, every amount not rising stops falling, as in whole "
    "numbers, while dyadic amounts have no least fall and layered amounts are not Archimedean, and in "
    "both some amount falls strictly at every step; under'''),
('''    "that falls strictly at every rise or fall of a member's level; where that total is read off "
    "configurations a list holds its changes stop, unrefuted, and a world whose active relata lie in the "
    "family and whose arising is embodied rests from some step on, unrefuted, as does a world with a census, "
    "every relatum embodied, balanced, dissipative and enclosed from some step on whose census total is "
    "read off configurations a list holds, the enclosing family widened as far as can be refuted; every "
    "world is a world in whole-number amounts with its own premises; in HalvingPass a standing halving as "
    "it passes between two relata meets every other premise and arises and ceases at every step, and no "
    "list holds its levels. "''',
'''    "that falls strictly at every rise or fall of a member's level, so its changes stop, as far as can be "
    "refuted, exactly where its total's strict falls stop; a world whose active relata lie in the family, "
    "whose arising is embodied and whose family total stops falling rests from some step on, unrefuted, as "
    "does a world with a census, every relatum embodied, balanced, dissipative and enclosed from some step "
    "on whose census total stops falling, the enclosing family widened as far as can be refuted; a total "
    "read off configurations a list holds stops falling, and in amounts with no endless fall every such "
    "world rests; every world is a world in whole-number amounts with its own premises, and rests with the "
    "premises of the whole-number rest theorems and nothing more; along any amount falling strictly at "
    "every step a standing passing between two relata meets every other premise and arises and ceases at "
    "every step, and no list holds its levels, so where every world in some amounts rests none falls at "
    "every step, and in dyadic and in layered amounts some world never rests. "'''),
])

rd = PKG / 'README.md'
text = rd.read_text(encoding='utf-8')
lines = text.split('\n')
i = [k for k, l in enumerate(lines) if l.startswith('| L1 | [`Becoming.InAmounts`](Becoming/InAmounts.lean) |')]
assert len(i) == 1
lines[i[0]] = (
    '| L1 | [`Becoming.InAmounts`](Becoming/InAmounts.lean) | the rest theorem over any amounts (no premise beyond what '
    'each theorem names; that the total stops falling, the census, enclosure or covering, balance, dissipation and '
    'embodiment are hypotheses where they enter): totals over any amounts (Amounts.totalOf, Amounts.totalOf_swap, '
    'Amounts.le_of_totalOf_le, Amounts.not_not_totalOf_le, Amounts.totalOf_support); a world\'s standings and exchanges '
    'in amounts (World.InAmounts); balanced and dissipated on, a family\'s total does not rise '
    '(World.InAmounts.stock_still) and falls strictly at every change of a member\'s level '
    '(World.InAmounts.change_lowers), so the family stops changing exactly where its total stops falling '
    '(World.InAmounts.change_stops_iff); where that total, or the census\'s, stops falling the world rests, unrefuted '
    '(World.InAmounts.rests_unrefuted_of_stops, World.InAmounts.rests_unrefuted_enclosed_of_stops), read finitely '
    '(World.InAmounts.rests_unrefuted_enclosed, World.InAmounts.rests_unrefuted_covering, World.InAmounts.rests_unrefuted) '
    'and in amounts with no endless fall (World.InAmounts.rests_unrefuted_enclosed_of_noEndlessFall); whole-number '
    'worlds the instance with their own premises (World.wholeAmounts, World.rests_unrefuted_whole, '
    'World.rests_unrefuted_enclosed_whole); along any amount falling at every step a standing passing between two '
    'relata never rests, its levels held by no list (Pass.endless_keeps_from_rest, Pass.levels_unlisted); rest over '
    'every world in given amounts lies between no endless fall and none at every step (Amounts.WorldsRest, '
    'Amounts.worldsRest_of_noEndlessFall, Amounts.not_endlessFall_of_worldsRest; dyadic and layered amounts '
    'Halving.worlds_need_not_rest, Layered.worlds_need_not_rest) |')
OLD = ('with every premise read as far as can be refuted Amounts.rests_unrefuted_of_finite_reading, along a run '
       'Branching.rests_along_run)')
assert text.count(OLD) == 1
NEW = ('with every premise read as far as can be refuted Amounts.rests_unrefuted_of_finite_reading, along a run '
       'Branching.rests_along_run); the one premise both routes give, that the strict falls stop (Amounts.FallsStop), '
       'given by a least fall in Archimedean amounts (Amounts.noEndlessFall_of_fallsAtLeast, '
       'Amounts.whole_noEndlessFall), with dyadic and layered amounts falling without end (Halving.endless, '
       'Halving.no_least_fall, Layered.endless, Layered.fallsAtLeast)')
text = '\n'.join(lines).replace(OLD, NEW)
rd.write_text(text, encoding='utf-8')
print('edited README.md')
