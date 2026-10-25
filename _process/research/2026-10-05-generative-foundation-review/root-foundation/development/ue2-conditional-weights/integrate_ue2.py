#!/usr/bin/env python3
"""UE2: join Becoming.ConditionalWeights to the core and land the change to Becoming.Typicality below `typical`.

Board rule 9 asks that Kolmogorov's maximal inequality (`typical_throughout`) land below `typical`, with `typical` its
corollary. Typicality's owner (P116) is inactive and no definition changes, so the lander decides it (LANDING.md §0).

This script copies ConditionalWeights into the package. It replaces Becoming/Typicality.lean with the kit's copy only
after asserting that the landed file is still the one LANDING.md records. It imports ConditionalWeights in the root
module after Becoming.Typicality, with an L1 bullet, and extends Typicality's bullet. It adds the module to the checker's
core list and scope text, extending Typicality's scope sentence, and adds its README rows (EN, ZH), extending
Typicality's. Every edit asserts that it applies exactly once. Mirrors UE1's integrate_ue1.py.
usage (from the checkout root of the landing worktree): python3 -B <kit>/integrate_ue2.py"""
import hashlib
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
# The landed Typicality.lean the change is made over (LANDING.md §0), and the kit's reviewed sources.
LANDED_TYPICALITY = '904976890149379d5d5e061cebf97235035ed94091985003ff51801b52e1d8a3'
KIT_TYPICALITY = '9eacd128aa74fe2651784e16421008e5f1447b9f9351be5bd2ab51cb0de6bc98'
KIT_CONDITIONAL = '479c8401487664728e63fd6d247dcfb89b2fd578185097251bcf2055cac0361f'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# The sources
kit_typicality = HERE / 'tree/Becoming/Typicality.lean'
kit_conditional = HERE / 'tree/Becoming/ConditionalWeights.lean'
assert sha(kit_typicality) == KIT_TYPICALITY, 'the kit Typicality.lean is not the reviewed one'
assert sha(kit_conditional) == KIT_CONDITIONAL, 'the kit ConditionalWeights.lean is not the reviewed one'
landed = PKG / 'Becoming/Typicality.lean'
assert sha(landed) == LANDED_TYPICALITY, ('the landed Typicality.lean changed since LANDING.md; rebase the change first',
                                          sha(landed))
target = PKG / 'Becoming/ConditionalWeights.lean'
assert not target.exists()
shutil.copyfile(kit_conditional, target)
shutil.copyfile(kit_typicality, landed)

# The root module: the import and the bullets
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Typicality\n', 'import Becoming.Typicality\nimport Becoming.ConditionalWeights\n')
edit(root, """  every u ≥ v, the courses with at least k ones weigh, times u^k·v^n, at most (p·u + q·v)^n·v^k.
* `Becoming.Situations` (L1):""", """  every u ≥ v, the courses with at least k ones weigh, times u^k·v^n, at most (p·u + q·v)^n·v^k.
  The deviation stays within the bound at every step: the courses whose squared deviation reaches d
  at some step weigh, times d, at most n·p·q·(p + q)^n (`typical_throughout`, Kolmogorov's maximal
  inequality), and `typical` is its last step; 2·x·y ≤ x·x + y·y is the margin square at margin
  zero (`margin_square`) (board item UE2).
* `Becoming.ConditionalWeights` (L1): conditional weights, shares and the exit from a margin on the
  counting layer, with no premise beyond the weighting each statement names. The weighting
  restricted to a record gives an event the weight of the courses meeting it and the record, its
  whole the record's weight (`restrict`, `mass_restrict`, `whole_restrict`); shares compared by
  cross-multiplication obey Bayes's rule as a ratio identity (`restrict_two_ways`); a generative
  model's posterior share is the prior weight times the likelihood weight over their sum
  (`posterior_single`), a prior weight being the prior share where the likelihood totals agree
  (`prior_share`); shares of independent parts and of step events over independent steps multiply
  (`share_product`, `share_meetsEach`). These are identities of counting, near-definitional. On
  Typicality's courses a balanced level standing m above a need reaches it within n steps on at
  most n·p·q/m² of the weight (`fallsWithin_share`, by `Typicality.typical_throughout`), a break
  being reaching it from m + 1 (`fallsTo_succ`); given a record of the course so far showing the
  margin m', on at most n·p·q/m'² (`record_bound`). A leaf (board item UE2).
* `Becoming.Situations` (L1):""")

# The checker: the core list and the scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Typicality", "Becoming.Situations", ',
     '"Becoming.Typicality", "Becoming.ConditionalWeights", "Becoming.Situations", ')
edit(checker, """    "times u^k * v^n, at most (p*u + q*v)^n * v^k, and with p = q = 1 they number, times 3^k, at "
    "most 4^n. "
    "Situations: with each step of a law taken in as many situations as its natural weight, the \"""",
     """    "times u^k * v^n, at most (p*u + q*v)^n * v^k, and with p = q = 1 they number, times 3^k, at "
    "most 4^n; the courses whose squared deviation reaches d at some step weigh, times d, at most "
    "n*p*q*(p + q)^n, the bound at the horizon being its last step, and x + m <= y gives "
    "m*m + 2*x*y <= x*x + y*y. "
    "ConditionalWeights: on a listed domain with a natural weighting, the weighting restricted to a "
    "record gives an event the weight of the courses meeting it and the record, its whole the record's "
    "weight, and two records in turn are their conjunction in either order; shares compared by "
    "cross-multiplication obey Bayes's rule as a ratio identity; a generative model's posterior share is "
    "the prior weight times the likelihood weight over their sum, a prior weight being the prior share "
    "where every hypothesis's likelihood weights have one total; shares of independent parts and of step "
    "events over courses of independent steps multiply; on Typicality's courses a level standing m above "
    "a need, raised q by a one and lowered p by a zero, reaches the need at some step within n steps on "
    "courses weighing, times m*m, at most n*p*q*(p + q)^n, and given a record of the earliest k steps "
    "leaving it m' above the need without having reached it, on a share at most n*p*q over m'*m'. "
    "Situations: with each step of a law taken in as many situations as its natural weight, the \"""")

# The package README, EN: Typicality's row extended, the new row after it
readme = PKG / 'README.md'
edit(readme, "so the courses deviating by at least d weigh, times d, at most that (`typical`): the counting form of "
             "the law of large numbers; 2·x·y ≤ x·x + y·y on the way (`two_mul_le`);",
     "so the courses deviating by at least d weigh, times d, at most that (`typical`): the counting form of "
     "the law of large numbers; the deviation stays within the bound at every step, the courses whose squared "
     "deviation reaches d at some step weighing, times d, at most the same (`typical_throughout`, Kolmogorov's "
     "maximal inequality), `typical` its last step; 2·x·y ≤ x·x + y·y on the way (`two_mul_le`), the margin "
     "square m·m + 2·x·y ≤ x·x + y·y for x + m ≤ y at m = 0 (`margin_square`);")
text = readme.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.Typicality`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.ConditionalWeights`](Becoming/ConditionalWeights.lean) | conditional weights, '
             'shares and the exit from a margin (no premise beyond the weighting each statement names): the weighting '
             'restricted to a record gives an event the weight of the courses meeting it and the record '
             '(`ConditionalWeights.mass_restrict`), its whole the record\'s weight (`ConditionalWeights.whole_restrict`); '
             'Bayes\'s rule as a ratio identity of shares (`ConditionalWeights.restrict_two_ways`) and a generative model\'s '
             'posterior share (`ConditionalWeights.posterior_single`), a prior weight being the prior share where the '
             'likelihood totals agree (`ConditionalWeights.prior_share`); shares of independent parts and steps multiply '
             '(`ConditionalWeights.share_product`, `ConditionalWeights.share_meetsEach`); identities of counting, '
             'near-definitional; on Typicality\'s courses a balanced level m above a need reaches it within n steps on '
             'at most n·p·q/m² of the weight (`ConditionalWeights.fallsWithin_share`), a break being reaching it from '
             'm + 1 (`ConditionalWeights.fallsTo_succ`), and given a record showing the margin m′ on at most n·p·q/m′² '
             '(`ConditionalWeights.record_bound`) |')
readme.write_text('\n'.join(lines), encoding='utf-8')

# The package README, ZH
readme_zh = PKG / 'README.zh.md'
edit(readme_zh, '所以偏差至少为 d 的历程之重乘 d 至多是它（`typical`）：大数定律的计数形式；途中证明 2·x·y ≤ x·x + y·y（`two_mul_le`）；',
     '所以偏差至少为 d 的历程之重乘 d 至多是它（`typical`）：大数定律的计数形式；偏差在每一步都守于此界：某一步平方偏差达到 d '
     '的历程之重乘 d 至多亦是它（`typical_throughout`，Kolmogorov 极大不等式），`typical` 是其最后一步；途中证明 '
     '2·x·y ≤ x·x + y·y（`two_mul_le`），即 x + m ≤ y 时 m·m + 2·x·y ≤ x·x + y·y 之边距平方（`margin_square`）于 m = 0 之情形；')
text = readme_zh.read_text(encoding='utf-8')
lines = text.split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| L1 | [`Becoming.Typicality`]')]
assert len(at) == 1, at
lines.insert(at[0] + 1, '| L1 | [`Becoming.ConditionalWeights`](Becoming/ConditionalWeights.lean) | 条件权重、份额与离开边距'
             '（除各陈述所名之权重外不加前提）：限于一记录之权重，给一事件以兼合该事件与该记录之历程之重'
             '（`ConditionalWeights.mass_restrict`），其总为记录之重（`ConditionalWeights.whole_restrict`）；份额以交叉相乘比较，'
             '贝叶斯法则为比之恒等（`ConditionalWeights.restrict_two_ways`），生成模型之后验份额为先验权重乘似然权重比其和'
             '（`ConditionalWeights.posterior_single`），似然之总相同时先验权重即先验份额（`ConditionalWeights.prior_share`）；'
             '独立部分与独立步之份额相乘（`ConditionalWeights.share_product`、`ConditionalWeights.share_meetsEach`）；皆计数之恒等，'
             '近乎定义；于 Typicality 之历程，高于需要 m 之平衡水平于 n 步内达到需要者至多占 n·p·q/m² 之重'
             '（`ConditionalWeights.fallsWithin_share`），断裂即自 m + 1 达到之（`ConditionalWeights.fallsTo_succ`），'
             '给定显示边距 m′ 之记录，至多 n·p·q/m′²（`ConditionalWeights.record_bound`） |')
readme_zh.write_text('\n'.join(lines), encoding='utf-8')
print('integrated: Becoming.ConditionalWeights joined and Becoming.Typicality changed below typical '
      '(root import and bullets, checker core list and scope, README rows EN and ZH)')
