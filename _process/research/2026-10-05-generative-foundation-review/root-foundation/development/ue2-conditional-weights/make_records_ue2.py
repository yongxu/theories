#!/usr/bin/env python3
"""UE2 records: write conditioning-by-restriction (a) and exit-from-a-margin (b). Each cites exactly its declarations of
Becoming.ConditionalWeights; together they cover every declaration, once (asserted, as UE1's make_records_ue1.py does
for its one record). The claims and non-claims follow REVIEW-UE2.md's re-check, "What the records should and should not
claim"; N3: drift-offspring-sampled and margin-of-a-regime are related, not dependencies, and the mass laws come from
fulfillment-chance-floor. Mirrors UE1's make_records_ue1.py.
usage (from the checkout root, after texts_ue2.py): python3 -B <kit>/make_records_ue2.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
NOTE = RF + 'development/ue2-conditional-weights/NOTE.md'
CH2 = 'theories/becoming/chapters/02-MAP.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
MOD = f'{PKG}/Becoming/ConditionalWeights.lean'
TYP = f'{PKG}/Becoming/Typicality.lean'
WEIGHTED = f'{PKG}/Becoming/Weighted.lean'
RECORDS = ROOT / 'theories/becoming/results/records'
RA = 'conditioning-by-restriction'
RB = 'exit-from-a-margin'
P = 'Becoming.ConditionalWeights.'
MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November',
          'December']


def receipt_day(receipt_id):
    """The receipt's day in local time, as the repository dates its history notes and board rows."""
    utc = datetime.datetime.strptime(receipt_id, '%Y%m%dT%H%M%S.%fZ').replace(tzinfo=datetime.timezone.utc)
    day = utc.astimezone().date()
    return f'{day.day} {MONTHS[day.month - 1]} {day.year}', f'{day.year}年{day.month}月{day.day}日'

# Each record's laws: (en, zh, short declaration names). The two lists partition the module.
LAWS_A = [
    ("A mass is the sum of counting over its entries, so it adds over joined listings, reads mapped and nested "
     "listings and scales with its weighting, by the sum laws of the sum over histories; masses agreeing entry by "
     "entry agree, the event holding nowhere weighs nothing, and a conjunction weighs the same in either order.",
     '质量是对其各项之计数之和，故于并列之列举相加，读映射与嵌套之列举，随其权重缩放，皆由历史之和之和律；逐项相同之质量相同，'
     '处处不成立之事件无重，合取两序之重相同。',
     ['entry_and', 'entry_swap', 'entry_split', 'entry_test_le', 'entry_mul_left', 'entry_and_true', 'entry_and_comm',
      'entry_restrict_le', 'mass_eq_sum', 'mass_congr_mem', 'mass_congr', 'mass_le_of_entries', 'mass_none',
      'mass_append', 'mass_map', 'mass_joinMap', 'mass_mul_left', 'mass_mul_right', 'whole_of_entries',
      'mass_eq_total', 'mass_and_comm', 'mass_and_true']),
    ("Restricting a weighting to a record keeps the weight of each course agreeing with it and gives every other "
     "course nothing; under it an event weighs what the courses meeting the event and the record weigh, and its "
     "whole is the record's weight. An event weighs its courses agreeing with a record plus those disagreeing; a "
     "record raises no weight; two records in turn are their conjunction, in either order.",
     '限于一记录之权重，保留与之相合之各历程之重，余者皆为零；其下一事件之重为兼合该事件与该记录之历程之重，其总为记录之重。'
     '一事件之重为其与记录相合者与不合者之和；记录不增任何重；先后两记录即其合取，两序皆然。',
     ['restrict', 'mass_restrict', 'whole_restrict', 'mass_split', 'restrict_le', 'mass_restrict_le',
      'restrict_restrict', 'restrict_comm']),
    ("A share is a part of a whole compared by cross-multiplication, a preorder on shares with a positive whole, and "
     "one share is at most another exactly where the other's reciprocal is at most its own. ⟨0, 0⟩, the share of an "
     "event whose whole is nothing, compares either way with every share and the order is not transitive through "
     "it; a positive part over nothing does not compare so. A wider event has no smaller share.",
     '份额为部分比整体，以交叉相乘比较，于整体为正之份额上为预序；一份额不大于另一份额，恰当另一份额之倒数不大于其倒数。'
     '⟨0, 0⟩ 即整体为零之事件之份额，与每一份额两向皆可比，序经之不传递；部分为正而整体为零者不然。更宽之事件份额不更小。',
     ['Share', 'Share.le', 'Share.Same', 'Share.mul', 'Share.one', 'Share.reciprocal', 'Share.le_refl',
      'Share.le_trans', 'Share.zero_whole', 'Share.le_iff_reciprocal', 'Share.mul_le_mul', 'Share.mul_le_left',
      'share', 'share_le_of_included', 'share_within', 'share_zero_whole', 'Witness.le_not_transitive',
      'Witness.positive_part_zero_whole']),
    ("Bayes's rule as a ratio identity: a hypothesis's share under the weighting restricted to a record, taken with "
     "the record's share, is the record's share under the weighting restricted to the hypothesis, taken with the "
     "hypothesis's share, since both count the courses meeting the two; where the record weighs nothing the identity "
     "says nothing.",
     '贝叶斯法则为比之恒等：限于记录之权重下假设之份额乘记录之份额，即限于假设之权重下记录之份额乘假设之份额，'
     '二者所计皆兼合二者之历程；记录无重之处，此恒等无所言。',
     ['restrict_two_ways']),
    ("In a generative model a course pairs a listed hypothesis and record and weighs the prior weight "
     "times the record's weight under it. The pair weight factors; the courses agreeing with a record weigh the sum "
     "of these products; a hypothesis listed once has its product over that sum as its share given the record; and "
     "after a record of positive weight hypotheses compare as their products, which can reverse their order.",
     '生成模型中，历程为所列假设与所列记录之对，其重为假设之先验权重乘记录于其下之重：对之重可分解；与记录相合之历程之重为诸积之和；'
     '列一次之假设，给定记录之份额为其积比此和。记录之重为正时，假设之比较即先验权重乘似然权重之比较，记录可翻转其序。',
     ['pairWeight', 'mass_pairs', 'mass_pairWeight', 'evidence', 'posterior_single', 'posterior_le_iff',
      'posterior_le_iff_single', 'mass_absent', 'mass_single', 'Witness.prior', 'Witness.lik',
      'Witness.record_reverses']),
    ("A prior weight is the hypothesis's share before any record where every listed hypothesis's likelihood weights "
     "have one total; in general a hypothesis's share is its prior weight times its own likelihood total, over the "
     "whole, and equal prior weights with totals 1 and 3 weigh 1 and 3.",
     '诸假设之似然权重总和相同时，先验权重即假设于任何记录之前之份额；一般而言，假设之份额为其先验权重乘其自身似然之总，比整体；'
     '先验权重相等而总为 1 与 3 者，重为 1 与 3。',
     ['prior_share', 'Witness.likUneven', 'Witness.prior_not_share']),
    ("Over the pairs of two listed domains weighted by products, two independent events weigh the product of their "
     "masses and take the product of their shares, the joint share at most either share, and a record of one part "
     "leaves the share of an event of the other the same ratio. Over courses of independent steps, the share of a "
     "conjunction of step events, one at each step, is the product of their shares.",
     '以积加权之两列举之对上，两独立事件之重为其质量之积，份额为其份额之积，合份额不大于任一份额，一部分之记录使另一部分事件之份额比不变。'
     '于独立步之历程，每步一事件之合取之份额为诸步份额之积。',
     ['mass_scaled_event', 'mass_product', 'share_product', 'share_product_le', 'share_product_le_right', 'mass_first',
      'restrict_independent', 'independentWeight', 'meetsEach', 'mass_meetsEach', 'whole_courses', 'foldr_whole',
      'foldr_part', 'share_meetsEach']),
]
LAWS_B = [
    ("The deviation bound at the horizon: the courses of n steps whose deviation at the horizon reaches m either way "
     "weigh, times m·m, at most n·p·q·(p + q)ⁿ, the weighted squared spread; Chebyshev's bound read at a margin, an "
     "instance of typical.",
     '终点之偏差界：终点偏差两向达到 m 之 n 步历程之重乘 m·m 至多 n·p·q·(p + q)ⁿ，即加权之平方离散；于边距读之 Chebyshev 界，'
     'typical 之实例。',
     ['deviates', 'deviates_offBy', 'whole_typical', 'deviates_bound']),
    ("A level standing m above a need, raised q by each one and lowered p by each zero, reaches the need or falls "
     "below it at some step on courses weighing, times m·m, at most n·p·q·(p + q)ⁿ, from the bound at every step; "
     "those ending there are among them; as shares, at most n·p·q over m·m, with the reciprocal at least m·m over "
     "n·p·q.",
     '高于需要 m 之水平，每个一升 q、每个零降 p，于某步达到或低于需要之历程之重乘 m·m 至多 n·p·q·(p + q)ⁿ，由每步之界；'
     '终于其处者在其中；以份额言，至多 n·p·q 比 m·m，其倒数至少 m·m 比 n·p·q。',
     ['fallsTo', 'fallsWithin', 'fallsWithin_of_end', 'fallsWithin_reachesBy', 'fallsWithin_entry',
      'fallsWithin_bound', 'fallsTo_bound', 'fallsWithin_share', 'fallsWithin_reciprocal']),
    ("Standing at the need is supported, so a break is reaching it from m + 1, the level below the need, on a share "
     "at most n·p·q over (m + 1)·(m + 1). A course can fall and recover: over two steps with p = q = 1 and m = 1, "
     "two courses reach the need within the horizon and one ends below it.",
     '立于需要处为受支撑，故断裂即自 m + 1 达到之，水平低于需要，其份额至多 n·p·q 比 (m + 1)·(m + 1)。历程可降而复升：'
     'p = q = 1、m = 1 之两步中，两历程于其内达到需要，一历程终于其下。',
     ['fallsTo_succ', 'Witness.within_exceeds_end']),
    ("A course of k + n steps is n later steps after k earlier ones. For a record of the earliest k steps every "
     "agreeing course of which leaves the level m′ above the need without having reached it, the agreeing courses "
     "reaching it within the horizon weigh the record's weight times what the n-step courses reaching it from m′ "
     "weigh; given the record their share is that share, at most n·p·q over m′·m′.",
     'k + n 步之历程为 k 步之后之 n 步。早 k 步之记录，问于 k 步之历程，其每一相合之历程使水平高于需要 m′ 且未达之，'
     '则相合而于其内达到需要之历程之重为记录之重乘自 m′ 达到之 n 步历程之重；给定记录，其份额即该份额，至多 n·p·q 比 m′·m′。',
     ['courses_add', 'mass_record', 'margin_shift', 'fallsTo_append', 'fallsWithin_append', 'record_fallsWithin',
      'record_share', 'record_bound', 'joinMap_congr', 'joinMap_single', 'extend_append', 'extend_joinMap',
      'extend_map_append', 'drop_append_length', 'weight_append', 'ones_append', 'zeros_append']),
]


def records(receipt_id, n, names, sha, now):
    """The two records, from the receipt's declaration names of Becoming.ConditionalWeights and a hash function."""
    def full(laws):
        out = [(en, zh, [P + s for s in short]) for en, zh, short in laws]
        missing = [d for _, _, ds in out for d in ds if d not in names]
        assert not missing, missing
        return out
    laws_a, laws_b = full(LAWS_A), full(LAWS_B)
    cited_a = [d for _, _, ds in laws_a for d in ds]
    cited_b = [d for _, _, ds in laws_b for d in ds]
    assert len(cited_a) == len(set(cited_a)) and len(cited_b) == len(set(cited_b))
    assert not set(cited_a) & set(cited_b), sorted(set(cited_a) & set(cited_b))
    assert set(cited_a) | set(cited_b) == names, sorted(names - set(cited_a) - set(cited_b))
    receipt = f'{PKG}/becoming-checks/{receipt_id}/verification.json'
    day_en, day_zh = receipt_day(receipt_id)
    total = len(names)
    boundaries = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical',
                  'names-provisional', 'omission-not-refutation']
    review_en = (f'Built in one session; an independent read-only review by a separate AI agent with a Lean rebuild, '
                 f'its findings taken and the revision re-checked, in study section {n}; not reviewed by a person.')
    review_zh = f'于一会话中构建；另一 AI 代理作独立只读审查并重建 Lean，其所见皆采，修订经复查，见研究第 {n} 节；未经人审。'

    def binding(source, module):
        return {'source': source, 'receipt': receipt, 'sha256_pointer': f'/source_sha256/{module}',
                'success_pointer': '/status', 'success_value': 'passed'}

    a = {
        'schema_version': 2,
        'id': RA,
        'title': {'en': "Conditioning by restriction, shares and a generative model's posterior",
                  'zh': '以限制为条件、份额与生成模型之后验'},
        'kind': 'theorem',
        'status': 'recorded-checked',
        'family': 'F01',
        'reviewed_at_utc': now,
        'statement': {
            'en': "On a natural weighting of listed courses, restricting to a record is conditioning: an event weighs "
                  "what the courses meeting it and the record weigh. Shares compared by cross-multiplication obey "
                  "Bayes's rule, give a generative model's posterior and multiply under independence.",
            'zh': '于所列历程之自然数权重，限于一记录即条件化：一事件之重为兼合该事件与该记录之历程之重。'
                  '以交叉相乘比较之份额合贝叶斯法则，给生成模型之后验，独立时相乘，皆为计数之恒等。'},
        'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in laws_a],
        'hypotheses': [{
            'en': "No axiom and no premise beyond each law's own: a listed domain of any type, an entry listed twice "
                  "counting twice, a natural weighting, Boolean events and records; for the generative model, listed "
                  "hypotheses and records with natural prior and likelihood weights, and for the single-hypothesis "
                  "laws decidable equality and a hypothesis listed once; for independence, product weights.",
            'zh': '不加公理，除各律所带者外不加前提：任意类型之所列域（列两次者计两次）、自然数权重、布尔之事件与记录；'
                  '于生成模型，所列之假设与记录及其自然数先验与似然权重，于单一假设之律，可判定之相等与列一次之假设；于独立，积权重。'}],
        'does_not_show': [
            {'en': 'Conditioning beyond natural weightings: for possibility, restriction is conditioning without '
                   'shares; signed counts cancel, so a restricted signed weighting has no share.',
             'zh': '自然数权重之外的条件化：于可能性，限制即无份额之条件化；带符号之计数相消，限制后之带符号权重无份额。',
             'kind': 'scope'},
            {'en': "The prior and likelihood readings without one likelihood total: otherwise a hypothesis's share "
                   'before any record is its prior weight times its own likelihood total, over the whole.',
             'zh': '无共同似然之总时之先验与似然读法：否则假设于记录前之份额为其先验权重乘其自身似然之总，比整体。',
             'kind': 'correspondence'},
            {'en': 'Surprisal, entropy or free energy as numbers: the reciprocal share orders as pointwise surprisal '
                   'does and multiplies where it adds, but averages of logarithms have no reciprocal-share form.',
             'zh': '作为数之惊异、熵或自由能：倒数份额之序同于逐点之惊异，惊异相加处其相乘，而对数之平均无倒数份额之形式。',
             'kind': 'correspondence'},
            {'en': "Graded evidence on a general domain: records are Boolean, and a likelihood weighting multiplying a "
                   "prior appears only as the generative model's pair weight.",
             'zh': '一般域上之分级证据：记录为布尔，似然权重乘先验仅见于生成模型之对之重。',
             'kind': 'scope'},
            {'en': 'That these identities are substantive results of a containment of the free-energy principle: they '
                   'are identities of counting, near-definitional.',
             'zh': '此诸恒等为包含自由能原理之实质结果：其为计数之恒等，近乎定义。',
             'kind': 'non-implication'},
            {'en': 'That whole_courses is a new law: it generalizes Typicality.transfer_weight, the two-valued case, '
                   'and lands above it; transfer_weight keeps its own proof until the general law moves into '
                   'Becoming.Weighted.',
             'zh': 'whole_courses 为新律：其推广二值之 Typicality.transfer_weight，而立于其上；transfer_weight '
                   '保留自身之证明，直至通律移入 Becoming.Weighted。',
             'kind': 'non-implication'},
            {'en': 'Which weighting an actual unfolding has: a share counts situations of a kind and fixes no course '
                   'that happens.',
             'zh': '实有之展开具何权重：份额计同类之情境，不定发生之历程。',
             'kind': 'correspondence'}],
        'counterexamples': [
            {'path': MOD, 'detail': {
                'en': 'A record can turn the order of two hypotheses: prior weights 3 and 1 with likelihood totals 5 '
                      'and 5 give courses weighing 15 and 5, and 3 and 5 given the record (Witness.record_reverses).',
                'zh': '记录可翻转两假设之序：先验权重 3 与 1、似然之总皆为 5，历程之重为 15 与 5，给定记录则为 3 与 5'
                      '（Witness.record_reverses）。'}},
            {'path': MOD, 'detail': {
                'en': 'Where the likelihood totals differ a prior weight is not the prior share: equal prior weights '
                      'with totals 1 and 3 weigh 1 and 3 (Witness.prior_not_share).',
                'zh': '似然之总不同时先验权重非先验份额：先验权重相等而总为 1 与 3 者，重为 1 与 3（Witness.prior_not_share）。'}},
            {'path': MOD, 'detail': {
                'en': 'The share order is not transitive through ⟨0, 0⟩, and a positive part over nothing does not '
                      'compare either way (Witness.le_not_transitive, Witness.positive_part_zero_whole).',
                'zh': '份额之序经 ⟨0, 0⟩ 不传递，部分为正而整体为零者不两向可比（Witness.le_not_transitive、'
                      'Witness.positive_part_zero_whole）。'}}],
        'standard_boundaries': boundaries,
        'validation_scope': {
            'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt_id}): '
                  f'Becoming.ConditionalWeights, {total} declarations, every one with an empty axiom report; this '
                  f'record cites {len(cited_a)} of them and exit-from-a-margin the other {len(cited_b)}. ' + review_en,
            'zh': f'Lean 4.29.1 合并检查器实查（回执 {receipt_id}）：Becoming.ConditionalWeights，{total} 项声明，公理报告皆空；'
                  f'本记录引其 {len(cited_a)} 项，exit-from-a-margin 引其余 {len(cited_b)} 项。' + review_zh},
        'next_delta': {
            'en': "Restriction stated once for every weighting, with possibility's support commuting with it; graded "
                  "records on a general domain; the join to the periphery's variational bound once it has a receipt; "
                  "review by a person.",
            'zh': '对每种权重陈述一次限制，可能性之支撑与之交换；一般域上之分级记录；外围变分界有回执后与之相接；人之审查。'},
        'correspondence': {
            'en': "Read a share as a probability, a number of situations of a kind (weights-count-situations): "
                  "restriction is conditioning, restrict_two_ways is Bayes's theorem P(h | o) P(o) = P(o | h) P(h) "
                  "(Bayes 1763; Laplace 1774), the share of evidence in the whole is a generative model's marginal "
                  "likelihood and posterior_single its posterior, these readings of the prior and the likelihood "
                  "holding where every listed hypothesis's likelihood weights have one total (prior_share). The "
                  "reciprocal share is a counting form of pointwise surprisal, log (1 / P): it reverses the order of "
                  "shares and its products are surprisal's sums. Entropy and free energy, averages of logarithms, have "
                  "no such form; free energy and its bound are drafted for the periphery with no receipt. The readings "
                  "are the AI's, stated in development/ue2-conditional-weights/NOTE.md, with the review in "
                  "REVIEW-UE2.md.",
            'zh': '份额读作概率，即同类情境之数（weights-count-situations）：限制即条件化，restrict_two_ways 即贝叶斯定理 '
                  'P(h | o) P(o) = P(o | h) P(h)（Bayes 1763；Laplace 1774），evidence 于整体之份额为生成模型之边缘似然，'
                  'posterior_single 为其后验；先验与似然之此读法，于诸假设似然权重之总相同时成立（prior_share）。'
                  '倒数份额为逐点惊异 log (1 / P) 之计数形式：反份额之序，其积为惊异之和。熵与自由能为对数之平均，无此形式；'
                  '自由能及其界拟于外围，无回执。读法皆 AI 之读，载于 development/ue2-conditional-weights/NOTE.md，审查见 REVIEW-UE2.md。'},
        'canonical_source': MOD,
        'aliases': ["Conditioning by restriction, shares and a generative model's posterior", '以限制为条件、份额与生成模型之后验',
                    'conditioning by restriction', "Bayes's rule in counting form",
                    'Becoming.ConditionalWeights.restrict_two_ways', 'Becoming.ConditionalWeights.posterior_single'],
        'dependencies': [
            {'id': 'fulfillment-chance-floor', 'relation': 'formal-reuse',
             'detail': {'en': 'mass, mass_mono and IncludedOn: the mass of an event on a listed domain and its '
                              'monotonicity.',
                        'zh': 'mass、mass_mono 与 IncludedOn：所列域上事件之质量及其单调。'}},
            {'id': 'sum-over-histories-exact', 'relation': 'formal-reuse',
             'detail': {'en': 'counting, openSteps, courses, joinMap and Weights.along; Weights.sum_congr, sum_append, '
                              'sum_map, sum_joinMap and mul_sum, from which the mass laws are read through mass_eq_sum.',
                        'zh': 'counting、openSteps、courses、joinMap 与 Weights.along；Weights.sum_congr、sum_append、sum_map、'
                              'sum_joinMap 与 mul_sum，质量之律经 mass_eq_sum 由之读出。'}}],
        'related': [
            {'id': 'weights-count-situations',
             'detail': {'en': 'Shares read as numbers of situations of a kind, a reading.',
                        'zh': '份额读作同类情境之数，为一读法。'}}],
        'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(cited_a), 'sha256': sha(MOD)},
                       {'path': WEIGHTED, 'role': 'proof', 'sha256': sha(WEIGHTED)},
                       {'path': receipt, 'role': 'receipt', 'sha256': sha(receipt)},
                       {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                       {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                       {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)}],
        'proof_bindings': [binding(MOD, 'Becoming.ConditionalWeights')],
        'history': [{'en': f'{day_en}: added (UE2), conditioning on the counting layer, identities of counting; '
                           f'study section {n}.',
                     'zh': f'{day_zh}：新增（UE2），计数层上之条件化，计数之恒等；研究第 {n} 节。'}],
    }
    b = {
        'schema_version': 2,
        'id': RB,
        'title': {'en': 'The exit from a margin, and what a record of the course says of it',
                  'zh': '离开边距，及历程之记录对其所言'},
        'kind': 'theorem',
        'status': 'recorded-checked',
        'family': 'F01',
        'reviewed_at_utc': now,
        'statement': {
            'en': "A balanced level standing m above a need reaches it within n steps on at most n·p·q/m² of the "
                  "weight, by Kolmogorov's maximal inequality in counting form; a break is reaching it from m + 1. "
                  "Given a record leaving the level m′ above the need, the share is the share from m′.",
            'zh': '高于需要 m 之平衡水平，于 n 步内达到需要者至多占 n·p·q/m² 之重，即计数形式之 Kolmogorov 极大不等式；'
                  '断裂即自 m + 1 达到之。给定使水平高于需要 m′ 之记录，其份额即自 m′ 之份额。'},
        'laws': [{'en': en, 'zh': zh, 'declarations': ds} for en, zh, ds in laws_b],
        'hypotheses': [{
            'en': "No axiom and no premise beyond each law's own: Typicality's courses on two values with natural "
                  "weights p and q; one level raised q by each one and lowered p by each zero, balanced by "
                  "construction; independent steps; for the record laws, a record asked of the courses of k steps, "
                  "with the margin m′ it shows.",
            'zh': '不加公理，除各律所带者外不加前提：Typicality 二值之历程与自然数权重 p、q；一水平每个一升 q、每个零降 p，'
                  '依构造平衡；独立之步；于记录之律，问于 k 步历程之记录及其所显之边距 m′。'}],
        'does_not_show': [
            {'en': "That the exit bound is the free-energy principle's quantity: it is the unregulated case a reading "
                   'of persisting is measured against, void from n = m·m/(p·q), and gives that principle\'s containment '
                   'no third part.',
             'zh': '离开之界为自由能原理之量：其为不受调节之情形，持续之读法以之为衡，自 n = m·m/(p·q) 起无效，且不给该原理之包含第三部分。',
             'kind': 'non-implication'},
            {'en': 'That a level leaves every margin in time: a balanced walk recurs, which is not proved here.',
             'zh': '水平终将离开每一边距：平衡之游走复返，此处未证。',
             'kind': 'correspondence'},
            {'en': 'A level whose rises and falls do not balance, more than two values, or steps that are not '
                   'independent.',
             'zh': '升降不平衡之水平、多于二值，或不独立之步。',
             'kind': 'scope'},
            {'en': 'Exponential exit bounds: one on ending fallen follows from concentrated; one within the horizon '
                   'needs its maximal form.',
             'zh': '指数之离开界：终于降者由 concentrated 得之；其内者须其极大形式。',
             'kind': 'scope'},
            {'en': 'The surprisal bound where m·m ≤ n·p·q, where it says nothing.',
             'zh': 'm·m ≤ n·p·q 处之惊异界，其处无所言。',
             'kind': 'scope'},
            {'en': 'A break at margin m: standing at the need is supported, and a break is reaching it from m + 1.',
             'zh': '边距 m 处之断裂：立于需要处受支撑，断裂即自 m + 1 达到之。',
             'kind': 'non-implication'},
            {'en': "T6's invisible half: that a record not holding the level bounds nothing.",
             'zh': 'T6 之不可见之半：不含水平之记录无所界。',
             'kind': 'scope'}],
        'counterexamples': [
            {'path': MOD, 'detail': {
                'en': 'Counting the courses that reach the need at some step can count more than counting those that '
                      'end there or below: over two steps with p = q = 1 and m = 1, two against one '
                      '(Witness.within_exceeds_end).',
                'zh': '计于某步达到需要之历程，可多于计终于其处或其下者：p = q = 1、m = 1 之两步中，二对一'
                      '（Witness.within_exceeds_end）。'}}],
        'standard_boundaries': boundaries,
        'validation_scope': {
            'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt_id}): '
                  f'Becoming.ConditionalWeights, {total} declarations, every one with an empty axiom report; this '
                  f'record cites {len(cited_b)} of them and conditioning-by-restriction the other {len(cited_a)}; '
                  f'Typicality.typical_throughout in the same receipt. ' + review_en,
            'zh': f'Lean 4.29.1 合并检查器实查（回执 {receipt_id}）：Becoming.ConditionalWeights，{total} 项声明，公理报告皆空；'
                  f'本记录引其 {len(cited_b)} 项，conditioning-by-restriction 引其余 {len(cited_a)} 项；'
                  f'Typicality.typical_throughout 在同一回执。' + review_zh},
        'next_delta': {
            'en': 'The one-sided (Cantelli) form of the bound, never above one; exits for a level whose rises and falls '
                  "do not balance; an exponential bound within the horizon; T6's invisible half in counting form; "
                  'review by a person.',
            'zh': '界之单边（Cantelli）形式，永不过一；升降不平衡之水平之离开；其内之指数界；计数形式之 T6 不可见之半；人之审查。'},
        'correspondence': {
            'en': "Kolmogorov's maximal inequality (1928), restated in counting form for a balanced walk on two values, "
                  "with Chebyshev's bound (1867) its last step. Read with the free-energy principle, the bound is the "
                  'unregulated case its reading of persisting is measured against: a balanced level that nothing reads '
                  'leaves a margin m within n steps on at most n·p·q/m² of the weight, so leaving has surprisal at '
                  'least log (m·m / (n·p·q)) where m·m exceeds n·p·q, and persisting longer needs a giving that reads '
                  'the level. The record law is the independence of the steps given the weighting, read as the seen '
                  'half of T6 with the weighting as its independently warranted model. The readings are the AI\'s, '
                  'stated in development/ue2-conditional-weights/NOTE.md, with the review in REVIEW-UE2.md.',
            'zh': 'Kolmogorov 极大不等式（1928），为二值平衡游走以计数形式重述，Chebyshev 界（1867）为其最后一步。'
                  '与自由能原理并读，此界为不受调节之情形，其持续之读法以之为衡：无物读之之平衡水平，于 n 步内离开边距 m 者至多占 '
                  'n·p·q/m² 之重，故 m·m 大于 n·p·q 处离开之惊异至少为 log (m·m / (n·p·q))，更久之持续须一读其水平之给予。'
                  '记录之律为给定权重时诸步之独立，读作 T6 可见之半，权重为其独立所据之模型。读法皆 AI 之读，'
                  '载于 development/ue2-conditional-weights/NOTE.md，审查见 REVIEW-UE2.md。'},
        'canonical_source': MOD,
        'aliases': ['The exit from a margin, and what a record of the course says of it', '离开边距，及历程之记录对其所言',
                    'the exit from a margin', 'Becoming.ConditionalWeights.fallsWithin_share',
                    'Becoming.ConditionalWeights.record_share'],
        'dependencies': [
            {'id': 'typicality-by-counting', 'relation': 'formal-reuse',
             'detail': {'en': 'typical, typical_throughout, margin_square, offBy, offByWithin, reachesBy, the total '
                              'lemmas, weight, courses, ahead, behind, extend, ones, zeros and mem_courses_iff.',
                        'zh': 'typical、typical_throughout、margin_square、offBy、offByWithin、reachesBy、诸 total 引理、weight、'
                              'courses、ahead、behind、extend、ones、zeros 与 mem_courses_iff。'}},
            {'id': 'fulfillment-chance-floor', 'relation': 'formal-reuse',
             'detail': {'en': 'mass and mass_mono.', 'zh': 'mass 与 mass_mono。'}},
            {'id': RA, 'relation': 'formal-reuse',
             'detail': {'en': 'restrict, share, Share with its order and reciprocal, and the mass laws.',
                        'zh': 'restrict、share、Share 及其序与倒数，与质量之律。'}}],
        'related': [
            {'id': 'drift-offspring-sampled',
             'detail': {'en': "The binomial means, from which the level's balance is arithmetic; not an inference edge.",
                        'zh': '二项之均值，水平之平衡由之算出；非推理之边。'}},
            {'id': 'margin-of-a-regime',
             'detail': {'en': "The margin vocabulary; the regime's point of no return, where giving reads the level, is "
                              'a different distance.',
                        'zh': '边距之词汇；体制之不归点，于其处给予读其水平，为另一距离。'}},
            {'id': 'slowing-down-before-an-own-end',
             'detail': {'en': "T6's seen half for a condition's own end, in the periphery; here, a dependent's need, "
                              'given the weighting.',
                        'zh': 'T6 可见之半于条件自身之终，在外围；此处为依赖者之需要，给定权重。'}}],
        'references': [{'path': MOD, 'role': 'proof', 'declarations': sorted(cited_b), 'sha256': sha(MOD)},
                       {'path': TYP, 'role': 'proof', 'sha256': sha(TYP)},
                       {'path': WEIGHTED, 'role': 'proof', 'sha256': sha(WEIGHTED)},
                       {'path': receipt, 'role': 'receipt', 'sha256': sha(receipt)},
                       {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                       {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                       {'path': CH2, 'role': 'statement', 'sha256': sha(CH2)},
                       {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)}],
        'proof_bindings': [binding(MOD, 'Becoming.ConditionalWeights'), binding(TYP, 'Becoming.Typicality')],
        'history': [{'en': f'{day_en}: added (UE2), the exit from a margin and the record law; study section {n}.',
                     'zh': f'{day_zh}：新增（UE2），离开边距与记录之律；研究第 {n} 节。'}],
    }
    return a, b


def main():
    receipt_id, n = sys.argv[1], int(sys.argv[2])
    receipt = f'{PKG}/becoming-checks/{receipt_id}/verification.json'

    def sha(path):
        return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()

    core = json.loads((ROOT / receipt).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.ConditionalWeights'] == sha(MOD)
    assert core['source_sha256']['Becoming.Typicality'] == sha(TYP)
    mod = next(m for m in core['modules'] if m['module'] == 'Becoming.ConditionalWeights')
    assert not any(mod['axiom_dependencies'].values())
    names = {d['name'] for d in mod['declarations']}
    now = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
    a, b = records(receipt_id, n, names, sha, now)
    for rid in ('fulfillment-chance-floor', 'sum-over-histories-exact', 'weights-count-situations',
                'typicality-by-counting', 'drift-offspring-sampled', 'margin-of-a-regime',
                'slowing-down-before-an-own-end'):
        assert (RECORDS / f'{rid}.json').exists(), rid
    for record in (a, b):
        path = RECORDS / f'{record["id"]}.json'
        assert not path.exists(), path
    for record in (a, b):
        (RECORDS / f'{record["id"]}.json').write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n',
                                                      encoding='utf-8')
    print('records:', RA, len(a['references'][0]['declarations']), 'declarations;', RB,
          len(b['references'][0]['declarations']), 'declarations; together', len(names))


if __name__ == '__main__':
    main()
