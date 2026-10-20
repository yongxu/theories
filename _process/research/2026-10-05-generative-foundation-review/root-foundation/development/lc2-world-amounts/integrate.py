#!/usr/bin/env python3
"""Join LC2 to the core package: copy Becoming.LeastLoss (its finite-reading law generalized to the unrefuted form, the
list held from T on) and the new Becoming.InAmounts in, import InAmounts after LeastLoss, add its root doc bullet and
CORE entry and scope text after LeastLoss's, restate LeastLoss's bullet, scope text and README row, and add the README
row for InAmounts.
usage (from the checkout root to edit): python3 -B integrate.py   (each edit must match exactly once)"""
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

DOC_LL_OLD = ('  (`Becoming.Recurrence`). Read off configurations a list holds, an amount that does not rise\n'
              '  falls strictly at most as often as the list is long, over any amounts, so rest needs no least\n'
              '  loss there;')
DOC_LL_NEW = ('  (`Becoming.Recurrence`). Read off configurations a list holds, an amount that does not rise\n'
              '  falls strictly at most as often as the list is long, over any amounts, so rest needs no least\n'
              '  loss there, and with every premise read as far as can be refuted its falls stop, unrefuted;')
DOC_IN_ANCHOR = '* `Becoming.Entropy` (L1): what becoming leaves, and what holding it costs.'
DOC_IN = (
    '* `Becoming.InAmounts` (L1): the rest theorem over any amounts, read finitely. A world\'s\n'
    '  standings, takes and gives read in any amounts, its activity and what takes part its own: a\n'
    '  family balanced (no amount made) and dissipated on (whatever gives back all it takes takes\n'
    '  nothing) has a total that does not rise and falls strictly at every change of a member\'s\n'
    '  level, with no least loss. Where that total, or the census\'s, is read off configurations a\n'
    '  list holds, the world rests from some step on, unrefuted, enclosed at each step or covered by\n'
    '  one family; whole-number worlds are the instance, and a standing halving as it passes between\n'
    '  two relata arises and ceases without end, its levels held by no list.\n')

edit(PKG / 'Becoming.lean', [
    ('import Becoming.LeastLoss\n', 'import Becoming.LeastLoss\nimport Becoming.InAmounts\n'),
    (DOC_LL_OLD, DOC_LL_NEW),
    (DOC_IN_ANCHOR, DOC_IN + DOC_IN_ANCHOR)])

SCOPE_LL_OLD = ('    "amounts, so its falls do not recur with no least loss, along a run of every process too, and the "\n')
SCOPE_LL_NEW = ('    "amounts, so its falls do not recur with no least loss, and with its not rising and its falls only "\n'
                '    "not refuted that they stop cannot be refuted, along a run of every process too, and the "\n')
SCOPE_IN_ANCHOR = '    "Units: at a unit splitting into r t finer units across each step, arising needing an active "\n'
SCOPE_IN = (
    '    "InAmounts: totals over any amounts keep the order, split over addition and exchange two lists, and "\n'
    '    "where each member\'s amount is at least another\'s and the totals are the other way each member\'s is; "\n'
    '    "a world\'s standings, takes and gives read in any amounts, a family balanced with no amount made and "\n'
    '    "dissipated on, whatever gives back all it takes taking nothing, has a total that does not rise and "\n'
    '    "that falls strictly at every rise or fall of a member\'s level; where that total is read off "\n'
    '    "configurations a list holds its changes stop, unrefuted, and a world whose active relata lie in the "\n'
    '    "family and whose arising is embodied rests from some step on, unrefuted, as does a world with a census, "\n'
    '    "every relatum embodied, balanced, dissipative and enclosed from some step on whose census total is "\n'
    '    "read off configurations a list holds, the enclosing family widened as far as can be refuted; every "\n'
    '    "world is a world in whole-number amounts with its own premises; in HalvingPass a standing halving as "\n'
    '    "it passes between two relata meets every other premise and arises and ceases at every step, and no "\n'
    '    "list holds its levels. "\n')
CORE_OLD = '"Becoming.Amounts", "Becoming.LeastLoss", '
CORE_NEW = '"Becoming.Amounts", "Becoming.LeastLoss", "Becoming.InAmounts", '
edit(PKG / 'check_becoming.py', [(SCOPE_LL_OLD, SCOPE_LL_NEW), (SCOPE_IN_ANCHOR, SCOPE_IN + SCOPE_IN_ANCHOR),
                                 (CORE_OLD, CORE_NEW)])

README_LL_OLD = ('over any amounts (Amounts.falls_within_reading, Amounts.rests_of_finite_reading, along a run '
                 'Branching.rests_along_run)')
README_LL_NEW = ('over any amounts (Amounts.falls_within_reading, Amounts.rests_of_finite_reading, with every premise '
                 'read as far as can be refuted Amounts.rests_unrefuted_of_finite_reading, along a run '
                 'Branching.rests_along_run)')
README_ROW = (
    '| L1 | [`Becoming.InAmounts`](Becoming/InAmounts.lean) | the rest theorem over any amounts, read finitely (no premise '
    'beyond what each theorem names; the finite reading, the census, enclosure or covering, balance, dissipation and '
    'embodiment are hypotheses where they enter): totals over any amounts (Amounts.totalOf, Amounts.totalOf_swap, '
    'Amounts.le_of_totalOf_le, Amounts.totalOf_support); a world\'s standings and exchanges in amounts '
    '(World.InAmounts); balanced and dissipated on, a family\'s total does not rise (World.InAmounts.stock_still) and '
    'falls strictly at every change of a member\'s level (World.InAmounts.steady_of_stock_le, '
    'World.InAmounts.change_lowers); read off configurations a list holds, change stops, unrefuted '
    '(World.InAmounts.change_stops_unrefuted), and the world rests, unrefuted, enclosed '
    '(World.InAmounts.rests_unrefuted_enclosed), covered by one family (World.InAmounts.rests_unrefuted_covering, '
    'World.InAmounts.rests_unrefuted_reading) and finite (World.InAmounts.rests_unrefuted); whole-number worlds are the '
    'instance (World.wholeAmounts, World.rests_unrefuted_enclosed_read, World.rests_unrefuted_listed); a standing '
    'halving as it passes between two relata meets every other premise and never rests, its levels held by no list '
    '(HalvingPass.never_rests, HalvingPass.levels_unlisted) |')
rd = PKG / 'README.md'
text = rd.read_text(encoding='utf-8')
assert text.count(README_LL_OLD) == 1, 'README LeastLoss row'
text = text.replace(README_LL_OLD, README_LL_NEW)
lines = text.split('\n')
idx = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.LeastLoss`](Becoming/LeastLoss.lean) |')]
assert len(idx) == 1, idx
lines[idx[0] + 1:idx[0] + 1] = [README_ROW]
rd.write_text('\n'.join(lines), encoding='utf-8')
print('edited README.md')
print('integrated')
