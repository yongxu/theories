#!/usr/bin/env python3
"""LA4's formal part: the texts. Each edit replaces one exact passage, asserted to occur once; nothing else changes.

* 05 §7: a case row for the season (home of the-test-season-meets-the-optimum-laws) at the end of the cases table, a
  theorem paragraph with its reading after the table (home of a-commuting-learner-drives-no-unread-choice); T3's
  second forbidden case stated for a choice whose values nothing rewarded and nothing the learner reads tells apart,
  its first wording's counterexample kept in the standing; a bullet in T3's evidence.
* 08's theses table, T3's standing and forbidden cases; the overview's theses table, T3's row, in both editions.
* experiments/README.md, LA4's row.
usage (from the checkout root): python3 -B texts_la4.py"""
from pathlib import Path

CH5 = Path('theories/becoming/chapters/05-COLLECTIVES.md')
CH8 = Path('theories/becoming/chapters/08-METHOD.md')
OV = Path('theories/becoming/THE-THEORY-OF-BECOMING.md')
OVZ = Path('theories/becoming/THE-THEORY-OF-BECOMING.zh.md')
EXP = Path('experiments/README.md')
LA4 = '../../../experiments/drain-beyond-the-reward'


def edit(path, old, new):
    t = path.read_text(encoding='utf-8')
    assert t.count(old) == 1, (str(path), old[:90], t.count(old))
    path.write_text(t.replace(old, new), encoding='utf-8')


# 05: the season's row, after the last row of the cases table
last_row_start = '| <a id="r-optima-rebuild-a-depleted-base"></a>Rebuilding from below (b; any `R`) |'
t = CH5.read_text(encoding='utf-8')
assert t.count(last_row_start) == 1
i = t.index(last_row_start)
j = t.index('\n', i)
season_row = (
    '| <a id="r-the-test-season-meets-the-optimum-laws"></a>LA4\'s season (a; one season) | In the season LA4 runs '
    '(a ground of ten renewing, at most four taken a step, a bay of six, a landing site beside a nesting site or '
    'apart, ten steps), the ground\'s catch, the bay\'s fish and the landings are three independent parts. Moving a '
    'bay fish into the catch keeps a season eligible, so every optimum of every order rising with the catch empties '
    'the bay. There is no room at the site, nor at the bay when only the ground\'s catch counts; ranked by the catch '
    'alone, or by the ground\'s catch alone, the optima include keeping and ending. The catch is at most 40, and at '
    'most 37 keeping the bay at three or more, so over seasons with natural-number weights (any policy with rational '
    'probabilities) the bay left is at most `40(1 − ν)` and `ν ≤ 1 − 3p/40`. '
    '[Record](../results/records/the-test-season-meets-the-optimum-laws.md). | the season\'s numbers as `season.py` '
    'runs them; the colony read as the bay left | `Optimum.Season.shared`, `Optimum.Season.bay_drained`, '
    '`Optimum.Season.site_no_room`, `Optimum.Season.unshared_optima`, `Optimum.Season.after_iff`, '
    '`Optimum.Season.mix_bay_catch` |')
law = (
    '\n\n<a id="r-a-commuting-learner-drives-no-unread-choice"></a>\n'
    '**Theorem** (any type; weights of any type, no law of their arithmetic used). *What a learner\'s symmetry '
    'fixes.* Let a law go from each configuration to finitely many weighted successors. Where every weighted total '
    'over the successors of `σ x` is the total over those of `x` carried by `σ`, the expectation of any observable '
    '`n` steps on from `σ x` is that of the observable read through `σ` from `x`. So from a configuration `σ` '
    'fixes, or from starting weights it leaves unchanged, every expectation equals its image\'s at every step '
    '(`Weighted.Commutes.carried`, `Weighted.Commutes.fixed_expect`, `Weighted.Commutes.start_expect`). A learner '
    'drawing samples with weights read off its state, and updating from them, commutes with `σ` where a map '
    'permutes the samples, a sample\'s weight at `σ x` is its image\'s weight at `x`, and the update at `σ x` is `σ` '
    'of the update from the image sample (`Weighted.Commutes.of_samples`). A law reinforcing what it draws keeps '
    'equal expectations from equal counts, while a run drawing one value at every one of any number of steps has '
    'positive weight (`Weighted.Reinforcing.expect_equal`, `Weighted.Reinforcing.oneSided`). A law adding to both '
    'values wears a start\'s preference away (`Weighted.Pooling.share_rises`). The deterministic case is [the '
    'commuting law](01-ROOT.md#r-what-a-commuting-law-keeps-apart) '
    '([record](../results/records/a-commuting-learner-drives-no-unread-choice.md)).\n\n'
    '**Reading** [AI reading]. Suppose nothing a learner reads tells two values of a choice apart: not its reward, '
    'not the dynamics, not its inputs. Suppose also that the exchange of the two values carries its whole state (the '
    'policy\'s parameters, its value baseline\'s, its optimizer\'s moments) and its sampling, a property of the code '
    'that LA4\'s mirror test checks. Then from a starting state, or a starting law, that the exchange leaves '
    'unchanged, it drives neither value in expectation at any step, whatever its architecture. T3\'s second '
    'forbidden case is then a theorem in expectation for that choice. A drive needs a start that prefers one value, '
    'such as a prior restraint, or a learner that treats the values apart; there the clause stays conjectured. Where '
    'the learner reads the condition, the case fails: in the separable family\'s exact flow on LA4\'s season, a bay '
    'whose fish are not counted rises, the policy reading its level. Pooling shows that a preference can wear away '
    'with nothing selecting on the choice, so LA4\'s control removes the selection in expectation while still '
    'updating the choice with noise ([design §12](' + LA4 + '/DESIGN.md#12-the-formal-work-and-what-it-changed)).')
t = t[:j] + '\n' + season_row + law + t[j:]
CH5.write_text(t, encoding='utf-8')

edit(CH5, 'a systematic drive on a condition sharing no units with anything rewarded; where room exists,',
     'a systematic drive on a choice whose values nothing rewarded and nothing the learner reads tells apart; where '
     'room exists,')
edit(CH5, '- *Standing.* The law for optima is proved; the clause on trained systems is conjectured, with partial support.',
     '- *Standing.* The law for optima is proved; the clause on trained systems is conjectured, with partial support. '
     'Its second forbidden case is proved in expectation for learners that the exchange of the choice\'s two values '
     'carries, from a starting state or law the exchange leaves unchanged ([the law]'
     '(#r-a-commuting-learner-drives-no-unread-choice)); from a start preferring one value, a prior restraint, it '
     'stays conjectured. It was first worded for any condition sharing no units with anything rewarded. So worded it '
     'fails for the separable family\'s exact expected update where the learner reads the condition: with the bay\'s '
     'fish uncounted, the bay rises (the evidence below). [AI reading] Units do not exhaust couplings: a learner '
     'couples into its return what it reads, through its own uneven training.')
edit(CH5, '  - Outside: optimizing against a learned proxy raises it while the true reward rises, then falls',
     '  - LA4\'s design, the first test of the clause under training by gradient, is not yet run ([design]('
     + LA4 + '/DESIGN.md)). Its season meets the law\'s hypotheses where the design says it does ([the case]'
     '(#r-the-test-season-meets-the-optimum-laws)). The separable family\'s exact flow on that season computes the '
     'expected update; it is not a frozen test. From a start keeping the colony in 98.7% of seasons, it drains the '
     'bay as nearness rises: the colony is kept in fewer than half the seasons from about ν = 0.68 (between saved '
     'checkpoints), where nothing forces a drain. The site\'s landings do not move. With the bay\'s fish uncounted, '
     'the bay rises from 5.0 to 5.9: the policy reads the bay\'s level and fishes best where it has been, so what '
     'lies outside the reward is coupled into the return through what the policy reads. That rise is the '
     'counterexample to the second forbidden case\'s first wording.\n'
     '  - Outside: optimizing against a learned proxy raises it while the true reward rises, then falls')
edit(CH8, '| T3. Optimization drains what lies beyond its couplings, where that gives room | [05](05-COLLECTIVES.md#t3) | the law '
     'for optima proved; the clause on trained systems conjectured, with partial support | with outcomes, couplings and '
     'reward fixed and the optimality gap measured: a system nearer its optimum leaving a room-giving condition beyond its '
     'couplings higher; a drive on a condition sharing no units with anything rewarded;',
     '| T3. Optimization drains what lies beyond its couplings, where that gives room | [05](05-COLLECTIVES.md#t3) | the law '
     'for optima proved; the clause on trained systems conjectured, with partial support; its second forbidden case '
     'proved in expectation for learners the exchange of the values carries, from a start it leaves unchanged, and, as '
     'first worded for any condition sharing no units, failing where the learner reads the condition | with outcomes, '
     'couplings and reward fixed and the optimality gap measured: a system nearer its optimum leaving a room-giving '
     'condition beyond its couplings higher; a drive on a choice whose values nothing rewarded and nothing the learner '
     'reads tells apart;')
edit(OV, '| T3 | Optimization drains what lies beyond its couplings, where that gives room | proved for optima; for trained '
     'systems conjectured, partly supported |',
     '| T3 | Optimization drains what lies beyond its couplings, where that gives room | proved for optima; for trained '
     'systems conjectured, partly supported; no drive on a choice nothing rewarded or read tells apart, proved in '
     'expectation for learners treating its values alike from a start that does |')
edit(OVZ, '| T3 | 优化耗竭其耦合之外者，在这样做留出余地之处 | 对最优解已证明；对训练出的系统是猜想，得到部分支持 |',
     '| T3 | 优化耗竭其耦合之外者，在这样做留出余地之处 | 对最优解已证明；对训练出的系统是猜想，得到部分支持；一选择之二值为所奖者'
     '与学习者所读者皆不分时，同等对待二值之学习者自同等对待二值之起点，于期望中不驱动任一值，已证明 |')
edit(EXP, '(LA4, designed 30 Oct 2026; nothing frozen or run): a dependent outside the reward with room open, the same '
     'dependent without room and a site sharing no units, nearness to the optimum varied, a shuffled-reward control '
     'for the update\'s own drift; small neural policies (Stage A) and open-weight language models (Stage B), two '
     'families each |',
     '(LA4, designed 30 Oct 2026; nothing frozen or run): a dependent outside the reward with room open, the same '
     'dependent without room and a site sharing no units, nearness to the optimum varied, a control removing the '
     'selection in expectation and keeping the task\'s learning; small policies of three families (Stage A) and '
     'open-weight language models of two (Stage B). The season\'s laws are proved in Lean, a learner\'s symmetry '
     'settles the site from a symmetric start, and the separable family\'s exact flow drains the colony before '
     'arithmetic forces it and raises the unshared bay it reads |')
print('texts: 05 (row, theorem, forbidden case, standing, evidence), 08, overview EN and ZH, experiments README')
