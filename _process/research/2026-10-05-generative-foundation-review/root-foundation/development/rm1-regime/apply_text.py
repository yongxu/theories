#!/usr/bin/env python3
"""RM1's chapter text: a bullet in section 2.3 after joint excess (EN) and its names in the ZH theorem sentence; a
sentence in the relation-to-known-results paragraph on results outside the ten (EN, ZH); a bullet in section 8.7 on
the margin measured (EN) and a clause in ZH 8.7.
usage: python3 -B apply_text.py   (from the checkout root; each edit must match exactly once)"""
from pathlib import Path

EN = Path('theories/becoming/chapters/THE-THEORY-OF-BECOMING.md')
ZH = Path('theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md')
SA = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/'
      'BECOMING-RENEWAL-READING.md#253-the-margin-as-a-measured-quantity-mq1')
SB = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/'
      'BECOMING-RENEWAL-READING.md#266-the-margins-equation-of-state-against-held-out-regimes-mq2')


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


en = EN.read_text()
assert 'RegimeMargin' not in en, 'already applied'
J = ('Own draws within what is given can jointly exceed it (`Pair.own_not_joint`, `Exceeding.own_not_joint`). '
     'Used in §4.3 (relative position does not protect).\n')
BULLET = (
    '- `RegimeMargin.ends_iff_below`: the margin of a regime. The margin law (§6.1) compares levels with the rest\'s '
    'exchanges held as they were, and on measured data that comparison holds as an identity '
    f'([MQ1, study §253]({SA})); what a measurement tests is the margin with the condition\'s own giving responding to '
    'its level. With giving read off what a standing draw `H` leaves (`RegimeMargin.step`), a level below `H + y`, '
    'where giving falls short of the draw below `y`, is gone within as many steps as it stood '
    '(`RegimeMargin.ends_below`), and from `H + y` up to a top the step keeps, the level holds (`RegimeMargin.holds`): '
    'the point of no return is exact. Where giving stops below a need, that point lies at least the draw above the '
    'need, and more exactly where giving at the need falls short of the draw (`RegimeMargin.beyond_draw_iff`), and it '
    'rises with the draw where giving does not rise (`RegimeMargin.rises_by_draw`): the need is the regime\'s, as MQ1 '
    'measured in the simulated yeast (1.4–4.1 times the draw above the need). On real yeast the giving law is itself '
    f'the regime\'s: at equal density giving falls as the dilution rises ([MQ2, study §266]({SB}), post hoc), and giving '
    'lowered by the regime raises the need beyond what removal alone gives, strictly exactly where the lowered giving '
    'falls short of the draw at the old need (`RegimeMargin.lowered_raises_strictly`). Draws add, harms do not: where '
    'giving under the joint draw is subadditive above the need and no greater than under either draw, the rise of the '
    'point of no return under two draws together is at least the sum of the rises under each, less one whole unit '
    '(`RegimeMargin.harms_superadditive`), and two draws the condition holds under alone can '
    'together end it from every level (`RegimeMargin.Peaked.together_ends`). The time to break lies between '
    '`RegimeMargin.not_before` and `RegimeMargin.falls_within`, MQ1\'s band. Harvesting theory states the same '
    'structure over the reals (depensation and the fold of the harvested equilibrium: Clark 1976; May 1977); the '
    'module states it in whole numbers ([margin of a regime](../results/records/margin-of-a-regime.md)).\n')
en = once(en, J, J + BULLET)
OUT = ('slack the case with no slack and Pareto improvement from slack its analogue in welfare economics;')
OUT_OLD = ('slack. The levels without the part')  # guard: the §7.2 paragraph is not the target
assert en.count('Pareto improvement from slack its analogue in welfare economics;') == 1
en = once(en, 'Pareto improvement from slack its analogue in welfare economics;',
          'Pareto improvement from slack its analogue in welfare economics; the margin of a regime (§2.3) is harvesting '
          'under depensation and the fold of the harvested equilibrium (Clark 1976; May 1977) in whole numbers, with '
          'harms of joint draws super-additive where renewal is concave, the convexity of the inverse of a concave '
          'renewal;')
E87 = '- One standard formalism defined outside the theory meets the premises by its own definitions:'
en = once(en, E87, (
    '- The margin measured (MQ1, `experiments/margin-measured`, predictions frozen before any run): the margin law\'s '
    'frozen-rest accounting holds as an identity on measured data, so its test lies in the margin of a regime '
    '(§2.3). Measured by intervention in a simulated Allee yeast, the margin with the largest sustained draw bounds the '
    'time to break whatever the history; the point of no return rises with the standing draw by more than the draw; '
    'harms of two harvesters are super-additive. On Dai et al.\'s (2012) published yeast densities, the present '
    'density carries the history to within 10% (passed); the frozen test of a sharp need failed on the instrument\'s '
    'floor and holds only with a floor read after the run. On held-out regimes (MQ2, frozen before the held-out '
    'values were read), one growth map fitted on four dilution factors predicted the need and the fates it separates '
    '(passed, 93–100% each side, where a no-need null classifies 68–81%) and failed on the level near the fold and on '
    'survival after a salt shock; at equal density giving falls with the dilution (post hoc), so the equation of '
    'state is the regime\'s, not the level\'s alone.\n'
    + E87))
EN.write_text(en)

zh = ZH.read_text()
assert 'RegimeMargin' not in zh, 'already applied'
Z23 = '`Flow.outrun_below`、`Flow.seeking_ends`；完整陈述见[英文版 §2.3]'
zh = once(zh, Z23, '`Flow.outrun_below`、`Flow.seeking_ends`，以及一个体制的余量：在常设汲取下所给读自水平时，不可回返点是确切的'
          '（`RegimeMargin.ends_iff_below`），它高出需求至少一份汲取、恰在需求处所给不足汲取时更多（`RegimeMargin.beyond_draw_iff`），'
          '体制降低所给即抬高需求（`RegimeMargin.lowered_raises_strictly`），联合汲取下的所给次可加且不大于各自汲取下的所给时损害在一单位之内超可加'
          '（`RegimeMargin.harms_superadditive`）；完整陈述见[英文版 §2.3]')
Z10 = '常和博弈中的权力稀缺（Turner and Stavrianos 2021）是没有余量的情形，福利经济学中有余量才有帕累托改进是其类比；'
zh = once(zh, Z10, Z10 + '一个体制的余量（§2.3）是以整数陈述的、减损性下的收获与被收获平衡的折叠（Clark 1976；May 1977），'
          '更新为凹时联合汲取的损害超可加，即凹更新之逆的凸性；')
Z87 = '位置／变迁网按其自身定义满足前提；'
zh = once(zh, Z87, Z87 + '余量已被测量（MQ1，预测在运行前冻结）：余量之律的冻结其余的核算在测量数据上是恒等式，其检验在于一个体制的余量（§2.3）；'
          '在 Dai 等（2012）的酵母数据上，当前密度携带历史在 10% 之内（通过），尖锐需求的冻结检验因仪器下限而失败；'
          '在留出的体制上（MQ2），以四个稀释因子拟合的生长映射预测了需求及其所分的命运（通过），在折叠附近的水平与盐冲击后的存活上失败；'
          '同等密度下所给随稀释下降（事后），故状态方程属于体制，不只属于水平；')
ZH.write_text(zh)
print('applied')
