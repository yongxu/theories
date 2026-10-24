#!/usr/bin/env python3
"""Join EV13-EV16 to the core package: copy Drift, Reproduction and Transmission in, extend the root doc, the checker scope and the
README rows (EN, ZH).
usage: python3 -B integrate.py   (from the checkout root; each edit must match exactly once)"""
import shutil
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path.cwd()
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


for mod, mark in (('Drift', 'namespace Replacement'), ('Reproduction', 'namespace Mutation'),
                  ('Transmission', 'def DependsOnDrawnAt')):
    p = PKG / 'Becoming' / f'{mod}.lean'
    assert mark not in p.read_text(), ('already integrated', mod)
    shutil.copyfile(HERE / 'tree' / 'Becoming' / f'{mod}.lean', p)
edits = {
    'Becoming.lean': [
        ('drift ends variation and fixes each kind with its starting share h/N.\n'
         '  Witnesses: one draw falling back with weight two of five; two members over one generation.\n',
         'drift ends variation and fixes each kind with its starting share h/N. With selection in the\n'
         '  draw, replacement one at a time (up with weight a, down with b): the potential with steps\n'
         '  b^j · a^(M − j) keeps its weighted value, so the fixation share tends to its value at the start\n'
         '  over its value at the top, the starting share where a = b and above it where b < a; the\n'
         '  favoured kind is lost with weight at least b^i. Witnesses: one draw falling back with weight two\n'
         '  of five; two members over one generation; two members fixing the favoured kind two of three.\n'),
        ('  most the whole, all of it where the amount is offspring number itself); with exact\n'
         '  transmission the rise of the amount\'s mean, cross-multiplied and squared, is at most that.\n',
         '  most the whole, all of it where the amount is offspring number itself); with exact\n'
         '  transmission the rise of the amount\'s mean, cross-multiplied and squared, is at most that.\n'
         '  Mutation: carriers leaving k carrying offspring and m not, others w: the carriers\' share rises\n'
         '  exactly where d · k exceeds c · m + d · w, never where k ≤ w (the error threshold), is kept at\n'
         '  s / (s + m) where k = w + s and is approached without overshoot; read as generations, the step\n'
         '  is balanced exactly there, transmission lowering c · m. The breeding value: an amount combining\n'
         '  carried amounts that reproduces, d times, offspring number\'s covariation with each (the normal\n'
         '  equations cleared of denominators) has d times its covariation with offspring number equal to\n'
         '  its own spread, at most d² times offspring number\'s (the additive part at most the whole), and\n'
         '  with exact transmission the cross-multiplied rise of its mean, d times, is that spread: Fisher\'s\n'
         '  fundamental theorem with breeding values, one carried amount its case.\n'),
        ('  the reading of drawing is inheritance with the givers drawing what they pass on.\n',
         '  the reading of drawing is inheritance with the givers drawing what they pass on. Where depending\n'
         '  and drawing part at the giver, its holding alone decides inheritance against forming anew, and\n'
         '  under the reading of drawing a dependence forms anew exactly where the giver drew on what it did\n'
         '  not depend on: a dependence formed by descent is a giver\'s drawing become its descendant\'s\n'
         '  dependence; in a balanced flow nothing comes to depend on what no participant drew on.\n')],
    'check_becoming.py': [
        ('''    "first kind lies within N r^k below h (N^N)^k and at most it; witnesses one draw from three and two, "\n'''
         '''    "and two members over one generation. "\n''',
         '''    "first kind lies within N r^k below h (N^N)^k and at most it; with selection in the draw, "\n'''
         '''    "replacement one at a time up with weight a and down with b among M + 1, the potential with steps "\n'''
         '''    "b^j a^(M - j) keeps its weighted value over any number of steps, the histories fixing the first "\n'''
         '''    "kind times the potential at the top lie within the potential at the top times r^m below "\n'''
         '''    "(a + b)^((M + 1) m) times the potential at the start, with r + a^(M + 1) = (a + b)^(M + 1), the "\n'''
         '''    "share at least the starting share where b <= a, above it where b < a and equal where a = b, and "\n'''
         '''    "the favoured kind lost with weight at least b^i; witnesses one draw from three and two, two "\n'''
         '''    "members over one generation, and two members fixing the favoured kind two of three. "\n'''),
        ('''    "cross-multiplied rise or fall of the amount's mean, squared, is at most that; witness an amount "\n'''
         '''    "with no covariance beside varying offspring numbers. "\n''',
         '''    "cross-multiplied rise or fall of the amount's mean, squared, is at most that; with carriers "\n'''
         '''    "leaving k carrying offspring and m not and others w, the carriers' share rises exactly where "\n'''
         '''    "d k exceeds c m + d w, never where k <= w, is kept at s / (s + m) where k = w + s, stays on its "\n'''
         '''    "side of that balance, and read as generations the step is balanced exactly there with "\n'''
         '''    "transmission lowering c m; witnesses an amount with no covariance beside varying offspring "\n'''
         '''    "numbers, and carriers at the threshold and at the balance; the breeding value, an amount "\n'''
         '''    "combining carried amounts whose covariation with each is d times offspring number's, has d "\n'''
         '''    "times its covariation with offspring number equal to its own spread, at most d^2 times offspring "\n'''
         '''    "number's, and with exact transmission d times the cross-multiplied rise of its mean is that "\n'''
         '''    "spread; witnesses an additive and an interacting offspring number. "\n'''),
        ('''    "A dependence forms anew exactly where the descendant depends on what its giver did not draw on; the reading of drawing is inheritance with the givers drawing what they pass on. "\n''',
         '''    "A dependence forms anew exactly where the descendant depends on what its giver did not draw on; the reading of drawing is inheritance with the givers drawing what they pass on. "\n'''
         '''    "Where depending and drawing part at the giver, its holding alone decides inheritance against "\n'''
         '''    "forming anew; under the reading of drawing a dependence forms anew exactly where the giver drew "\n'''
         '''    "on what it did not depend on, and in a balanced flow nothing comes to depend on what no "\n'''
         '''    "participant drew on. "\n''')],
    'README.md': [
        ('drift ends variation and fixes each kind with its starting share; witnesses `Drift.OneDraw.falls_back`, '
         '`Drift.TwoMembers.one_generation` |',
         'drift ends variation and fixes each kind with its starting share; with selection in the draw (replacement one at '
         'a time, up `a`, down `b`) the potential keeps its weighted value (`Drift.Replacement.value_potential`), the '
         'fixation share tends to its value at the start over its value at the top (`Drift.Replacement.fixation`), the '
         'starting share where `a = b` (`Drift.Replacement.neutral_share`) and above it where `b < a` '
         '(`Drift.Replacement.favoured_share_above`), the favoured kind lost with weight at least `b^i` '
         '(`Drift.Replacement.lost_ge`); witnesses `Drift.OneDraw.falls_back`, `Drift.TwoMembers.one_generation`, '
         '`Drift.Favoured.two_members` |'),
        ('and with exact transmission the rise of the amount\'s mean bounded so (`Reproduction.Generations.response_sq_le`); '
         'witness `Reproduction.Unrelated.unrelated` |',
         'and with exact transmission the rise of the amount\'s mean bounded so (`Reproduction.Generations.response_sq_le`); '
         'mutation: the carriers\' share rises exactly where `d·k` exceeds `c·m + d·w` (`Reproduction.Mutation.rises_iff`), '
         'never where `k ≤ w` (`Reproduction.Mutation.never_rises`), is kept at `s/(s+m)` (`Reproduction.Mutation.kept_share`) '
         'and approached without overshoot (`Reproduction.Mutation.below_always`), the step balanced exactly there with '
         'transmission lowering `c·m` (`Reproduction.Mutation.balanced_iff`); witnesses `Reproduction.Unrelated.unrelated`, '
         '`Reproduction.Threshold.at_threshold`; the breeding value: `d` times its covariation with offspring number is its '
         'own spread (`Reproduction.Breeding.breeding_balance`), at most `d²` times offspring number\'s '
         '(`Reproduction.Breeding.additive_part_le`), and with exact transmission `d` times the rise of its mean is that '
         'spread (`Reproduction.Breeding.response`), one amount its case (`Reproduction.Breeding.one_amount`); witnesses '
         '`Reproduction.Additive.additive`, `Reproduction.Interaction.interaction` |'),
        ('`Flow.dependsOnDrawn_iff`, `Flow.inherits_iff_none_undrawn`) |',
         '`Flow.dependsOnDrawn_iff`, `Flow.inherits_iff_none_undrawn`); where depending and drawing part at the giver '
         '(`Web.four_cases`, `Web.inheritsAt_iff_held`), forming anew from the giver\'s drawing '
         '(`Web.formsAnew_iff_drawn_unheld`, `Flow.dependsOnDrawn_iff_split`, `Flow.formed_from_drawing`, '
         '`Flow.no_dependence_undrawn`); witnesses `World.droppedHatch_formed`, `World.novel_formed_undrawn`, '
         '`TwoGivers.passed_undrawn` |')],
    'README.zh.md': [
        ('漂变终结差异，并以起始份额固定各类；见证 `Drift.OneDraw.falls_back`、`Drift.TwoMembers.one_generation` |',
         '漂变终结差异，并以起始份额固定各类；抽取中有选择时（一次替换一个，上升权重 `a`、下降 `b`），势在加权下保持其值'
         '（`Drift.Replacement.value_potential`），固定份额趋于起点之势比顶端之势（`Drift.Replacement.fixation`），`a = b` 时即起始份额'
         '（`Drift.Replacement.neutral_share`），`b < a` 时高于它（`Drift.Replacement.favoured_share_above`），受青睐的一类以至少 `b^i` 的权重失去'
         '（`Drift.Replacement.lost_ge`）；见证 `Drift.OneDraw.falls_back`、`Drift.TwoMembers.one_generation`、`Drift.Favoured.two_members` |'),
        ('传递精确时该量均值的升降亦受此界（`Reproduction.Generations.response_sq_le`）；见证 `Reproduction.Unrelated.unrelated` |',
         '传递精确时该量均值的升降亦受此界（`Reproduction.Generations.response_sq_le`）；突变：携带者份额恰在 `d·k` 超过 `c·m + d·w` 时上升'
         '（`Reproduction.Mutation.rises_iff`），`k ≤ w` 时从不上升（`Reproduction.Mutation.never_rises`），保持于 `s/(s+m)`'
         '（`Reproduction.Mutation.kept_share`）并无超越地趋近（`Reproduction.Mutation.below_always`），该步恰在此处平衡、传递降低 `c·m`'
         '（`Reproduction.Mutation.balanced_iff`）；见证 `Reproduction.Unrelated.unrelated`、`Reproduction.Threshold.at_threshold`；'
         '育种值：`d` 乘其与后代数的协变等于其自身离散（`Reproduction.Breeding.breeding_balance`），至多为后代数离散的 `d²` 倍'
         '（`Reproduction.Breeding.additive_part_le`），传递精确时 `d` 乘其均值的上升即该离散（`Reproduction.Breeding.response`），'
         '单一所载之量为其情形（`Reproduction.Breeding.one_amount`）；见证 `Reproduction.Additive.additive`、`Reproduction.Interaction.interaction` |'),
        ('`Flow.dependsOnDrawn_iff`、`Flow.inherits_iff_none_undrawn`） |',
         '`Flow.dependsOnDrawn_iff`、`Flow.inherits_iff_none_undrawn`）；给予者处依存与汲取相分时（`Web.four_cases`、'
         '`Web.inheritsAt_iff_held`），新结之依存来自给予者的汲取（`Web.formsAnew_iff_drawn_unheld`、`Flow.dependsOnDrawn_iff_split`、'
         '`Flow.formed_from_drawing`、`Flow.no_dependence_undrawn`）；见证 `World.droppedHatch_formed`、`World.novel_formed_undrawn`、'
         '`TwoGivers.passed_undrawn` |')],
}
for name, pairs in edits.items():
    p = PKG / name
    t = p.read_text()
    for old, new in pairs:
        t = once(t, old, new)
    p.write_text(t)
print('integrated')
