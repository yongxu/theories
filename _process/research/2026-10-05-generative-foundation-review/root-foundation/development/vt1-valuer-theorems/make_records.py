#!/usr/bin/env python3
"""VT1: write the records a-narrowing-above-its-widening and weights-within-a-ratio-agree-past-it, and update the
three records that cite Becoming.Weightings by declaration (widening-as-what-every-weighting-ranks,
what-the-step-across-standpoints-reaches, graded-significance-and-priority): the five declarations that went (the
witness outweighing and its four lemmas) leave their reference lists, widening's laws name the tilted weighting, and
each gets one history note. The module source was read before re-binding: its earlier statements are unchanged.
usage (from the checkout root, after apply_text.py): python3 -B make_records.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
REVIEW = RF + 'BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
STEP = 'theories/becoming/chapters/THE-STEP-OF-INVARIANCE.md'
MODULE = 'Becoming.Weightings'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
assert f'## {N}. The valuer tests as theorems (VT1)' in (ROOT / STUDY).read_text()
assert '<a id="valuer-theorems-check"></a>' in (ROOT / REVIEW).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '22 October 2026'
GONE = ['Becoming.Weighting.outweighing', 'Becoming.Weighting.cond_pos', 'Becoming.Weighting.outweighing_positive',
        'Becoming.Weighting.outweighing_term_le_one', 'Becoming.Weighting.outweighing_term_at']


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


found = [m for m in R['modules'] if m['module'] == MODULE]
assert len(found) == 1
assert not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert R['source_sha256'][MODULE] == sha(SOURCE)
for g in GONE:
    assert g not in HAVE, g


def need(names):
    for n in names:
        assert n in HAVE, n
    return names


def t(en, zh):
    return {'en': en, 'zh': zh}


W, FR, IN = 'Becoming.Weighting.', 'Becoming.Framed.', 'Becoming.Interacting.'
BEYOND = need([W + n for n in ['beyond', 'size', 'term_split', 'and_swap', 'weighed_split', 'weighed_shared',
                               'weighed_split_right', 'add_lt_add_iff', 'add_le_add_iff', 'weighed_lt_iff_beyond',
                               'weighed_le_iff_beyond', 'beyond_term_zero', 'weighed_beyond_of_includes']])
NET = need([W + n for n in ['ranksNet', 'ranksNet_iff_beyond', 'not_of_neg', 'beyond_lt', 'ranksNet_lt_of_widens',
                            'cond_zero', 'weighed_zero', 'weighed_lt_of_widens']])
BY = need([W + n for n in ['WidensBy', 'widensOn_of_widensBy', 'weighed_widensBy', 'size_widensBy_pos', 'mul_lt_mul_iff',
                           'ranksNet_widensBy', 'ranksNet_ties']])
INC = need([W + n for n in ['IncreasingAt', 'ranksNet_increasingAt', 'IncrementIs', 'increment_transfer',
                            'ranksNet_increment_alike']])
PRES = need([W + n for n in ['ReadsSetsOn', 'ReadsSets', 'reads_increasingAt', 'narrower_above_net', 'reads_ranksNet',
                             'reads_ranksNet_widens', 'reads_increment_of', 'reads_increment']])
TERMS = need([W + n for n in ['term_le_of', 'term_lt_of', 'term_eq_at', 'cond_one_pos', 'and_parts', 'and_of_parts']])
FRAMED = need([FR + n for n in ['kept', 'ranks', 'increasing', 'widensBy', 'framing_alone']])
INTER = need([IN + n for n in ['score', 'order', 'items', 'neither', 'onlyTrue', 'onlyFalse', 'both',
                               'eq_true_of_not_false', 'alone', 'jointly', 'increment_differs', 'not_net']])
BOUND = need([W + n for n in ['RatioWithin', 'cond_scale', 'weighed_scale', 'mul_swap_right', 'beyond_within']])
PAST = need([W + n for n in ['pos_of_lt_mul', 'cond_pos_of', 'weighed_pos_of_size', 'weighed_zero_of_size',
                             'ranks_past_ratio', 'ranks_le_past_ratio']])
TILT = need([W + n for n in ['tilted', 'cond_between', 'tilted_positive', 'tilted_within', 'tilt_beyond', 'tilt_toward',
                             'weighed_tilted_beyond', 'weighed_tilted_toward', 'tilted_lt_iff', 'tilted_gt_iff',
                             'tilted_ties']])
CLASS = need([W + n for n in ['every_within_iff', 'some_within_reverses_iff', 'opposite_within_iff']])
EQUAL = need([W + n for n in ['const_lt_iff_beyond', 'size_le_length', 'size_pos_of_exceeds', 'outweighs',
                              'neutral_ranks_by_number']])
BOUNDARIES = ['no-ethical-premise', 'no-evaluation', 'decidability', 'no-definition-by-verdict', 'names-provisional',
              'formal-not-empirical']
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check before the '
    f'Lean is the significance review\'s valuer-theorems check. Author review in study section {N}; not independently '
    'reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。动手写 '
    f'Lean 之前的文献核查是显著性审查中的“评价者定理”核查。作者审查见研究第 {N} 节；未经独立审查。')


def references(declarations):
    return [
        {'path': SOURCE, 'role': 'proof', 'declarations': sorted(declarations), 'sha256': sha(SOURCE)},
        {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
        {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
        {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
        {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
        {'path': STEP, 'role': 'statement', 'sha256': sha(STEP)},
    ]


BINDING = {'source': SOURCE, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{MODULE}',
           'success_pointer': '/status', 'success_value': 'passed'}
REUSE = {'id': 'widening-as-what-every-weighting-ranks', 'relation': 'formal-reuse',
         'detail': t('Reuses the weighted count and the comparisons on listed items (Weighting.weighed, IncludesOn, '
                     'ExceedsOn, WidensOn, total_lt); the widening law there is now this record\'s case.',
                     '复用所列项上的加权计数与比较（Weighting.weighed、IncludesOn、ExceedsOn、WidensOn、total_lt）；那里的扩大之律现为'
                     '此处的情形。'),
         'interface': {'output': t('A course and its weighted count over a finite listing.', '有限列举上的进程及其加权计数。'),
                       'input': t('Courses compared by what each admits beyond the other.', '按各自超出对方者比较的进程。'),
                       'conditions': t('Finite listing, two-valued admission.', '有限列举，二值接纳。'),
                       'evidence': SOURCE}}

narrowing = {
    'schema_version': 2,
    'id': 'a-narrowing-above-its-widening',
    'title': t('A narrowing above its widening', '缩小排在其扩大之上'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': t('A ranking of presentations puts a narrowing above its widening by one item only where it ranks that '
                   'pair otherwise than its order on the kept sets does, or the item weighs at zero or below; read right, '
                   'exactly where the item weighs below zero, and zero ties.',
                   '对表述的排序把缩小排在其仅多一项的扩大之上，只在它不按其对所保集合的次序排这一对处，或该项权重为零或以下处；读对时'
                   '恰在该项权重低于零处，为零则持平。'),
    'laws': [
        {**t('Under any weights two courses compare as what each admits beyond the other. A net weighting counts each listed '
             'item for a course that admits it and against it; it ranks a widening higher where every added item weighs '
             'above zero, a positive weighting being its case with nothing against.',
             '任何权重下，两条进程按各自超出对方者比较。净加权对接纳某项的进程计入该项的正与负两份；凡所加的每项权重都高于零，它就把扩大'
             '排得更高；正的加权是其中无负份的情形。'), 'declarations': BEYOND + NET},
        {**t('A net weighting ranks a widening by one item alone as that item weighs, whatever else either course keeps: '
             'above where it weighs above zero, below where below zero, neither where at zero; so its increment at an item '
             'has the same sign in every context.',
             '净加权按该项的权重来排仅多一项的扩大，不论两条进程另外保住什么：高于零则在上，低于零则在下，为零则都不在上；所以它在一项处的'
             '增量在每个语境中正负号相同。'), 'declarations': BY + INC},
        {**t('A ranking of presentations, plans with their wording and order, reads the sets on a pair where it ranks the '
             'two as an order on courses ranks what they keep. Read right, an order increasing at the added item never '
             'ranks the narrowing above; under a net weighting a narrowing above its widening by one item is a pair not '
             'read right or an item at zero or below, and read right it is an item below zero.',
             '对表述（带着措辞与次序的方案）的排序在一对上按集合读，指它按对进程的次序排这两者所保住者。读对时，在所加项处递增的次序从不把'
             '缩小排在上面；净加权下，缩小排在其仅多一项的扩大之上，是这一对没读对或该项为零或以下，读对时则是该项低于零。'),
         'declarations': PRES[:6]},
        {**t('Read right, the sign of the order\'s increment from the narrower course to the wider fixes the verdict: a sign '
             'measured apart predicts the ranking exactly where it is that increment\'s sign in the pair\'s context.',
             '读对时，次序从较窄进程到较宽进程的增量的正负号决定裁定：分开测得的正负号恰在它是这一对语境中该增量的正负号时预测排序。'),
         'declarations': PRES[6:]},
    ],
    'hypotheses': [t(
        'No axiom. A finite listing of items; two-valued admission; natural weights, a net weighting as two per item, for and '
        'against; a presentation reduced to the course it keeps, its wording and order entering only through the ranking; '
        'for the one-item laws, the wider course widening the narrower by that item alone; for a sign measured apart, the '
        'premise that it is the sign of the order\'s increment in the pair\'s context.',
        '不加公理。项的有限列举；二值接纳；自然数权重，净加权为每项正负两份；表述归结为它所保住的进程，其措辞与次序只经由排序进入；'
        '单项诸律中，较宽进程仅以该项扩大较窄者；对分开测得的正负号，设它是这一对语境中次序增量的正负号。')],
    'does_not_show': [
        {**t('That a ranking not reading the sets violates: a misread or a framing may favour the wider plan as well.',
             '不按集合读的排序就会违反：误读或框定同样可能偏向较宽方案。'), 'kind': 'converse'},
        {**t('That a valuer reads the sets of a case, or that its sign measured apart is the sign of its joint increment: '
             'both are premises to measure, and for an interacting order the second fails.',
             '评价者按集合读一个情形，或其分开测得的正负号是其联合增量的正负号：两者都是要测量的前提；对相互作用的次序，后者不成立。'),
         'kind': 'scope', 'witness': IN + 'not_net'},
        {**t('That an order increasing at each item ranks a widening by several items higher where it is neither additive '
             'nor transitive.', '在每项处递增、但既不可加也不传递的次序，把多项的扩大排得更高。'), 'kind': 'scope'},
        {**t('That an AI persona\'s or a person\'s judgment is a ranking of presentations in this sense, or its stated sign a '
             'measurement of its order\'s increment.', 'AI 角色或人的判断是这一意义上对表述的排序，或其所述正负号是其次序增量的测量。'),
         'kind': 'correspondence'},
        {**t('That a weight below zero is wrong, or that widening is better: calling widening better is C, a premise.',
             '低于零的权重是错的，或扩大更好：称扩大更好是 C，是前提。'), 'kind': 'non-implication'},
    ],
    'counterexamples': [
        {'path': SOURCE, 'detail': t(
            'Framed: one item weighing one for and nothing against; a framed presentation keeping nothing is ranked above an '
            'unframed one keeping the item, so the ranking does not read the sets on that pair (Framed.framing_alone).',
            'Framed：一项，正份为一、负份为零；不保住任何东西的被框定表述排在保住该项的未框定表述之上，故这一排序在这一对上不按集合读'
            '（Framed.framing_alone）。')},
        {'path': SOURCE, 'detail': t(
            'Interacting: adding one item raises a course keeping nothing and lowers one keeping the other item, so its sign '
            'measured alone is not its sign jointly, and no net weighting gives that order (Interacting.increment_differs, '
            'Interacting.not_net).',
            'Interacting：加上一项抬高什么也不保住的进程，却降低保住另一项的进程，故其单独测得的正负号不是联合时的正负号，且没有净加权'
            '给出这一次序（Interacting.increment_differs、Interacting.not_net）。')},
    ],
    'standard_boundaries': BOUNDARIES,
    'validation_scope': SCOPE,
    'next_delta': t('The premises measured on human valuers: presentation invariance by rewording and reordering one pair, '
                    'the link by ranking the one-item pair beside the sign measured apart; several added items for orders '
                    'neither additive nor transitive; an independent review.',
                    '在人类评价者上测这些前提：改写措辞与次序测表述不变，把仅差一项的一对与分开测得的正负号并列来测联系；既不可加也不传递的'
                    '次序上的多项扩大；独立审查。'),
    'correspondence': t(
        'Invariance of description and dominance (Tversky and Kahneman 1986): dominance is obeyed where transparent and '
        'violated where masked; here a dominance violation is exactly a failure of invariance on the pair or an item at zero '
        'or below. Preferential independence (Debreu 1960; Keeney and Raiffa 1976): for two-valued attributes a net '
        'weighting\'s increment at an item is context-free, and Interacting is an order where it is not. Separate and joint '
        'evaluation (Hsee 1996): the sign measured apart predicts the joint ranking exactly under the link premise. Reading '
        '(the AI\'s): the three causes thesis T5 names, a misread, a framing and a weight below zero, are the only ones; '
        'VD2\'s X1s and X2 measured the link holding where the sign was strongly positive, and X3 its failure for gains.',
        '描述的不变与占优（Tversky 与 Kahneman 1986）：占优在透明时被遵守、在掩蔽时被违反；此处占优的违反恰是这一对上不变的失败，或某项'
        '为零或以下。偏好独立（Debreu 1960；Keeney 与 Raiffa 1976）：对二值属性，净加权在一项处的增量与语境无关，Interacting 是它不如此的'
        '次序。分开与联合的评价（Hsee 1996）：分开测得的正负号恰在联系前提下预测联合排序。解读（AI 的）：论题 T5 所说的三个原因，误读、'
        '框定与低于零的权重，是仅有的原因；VD2 的 X1s 与 X2 测得联系在正负号强为正处成立，X3 测得它对收益不成立。'),
    'canonical_source': SOURCE,
    'aliases': ['a narrowing above its widening', '缩小排在其扩大之上', W + 'narrower_above_net', W + 'reads_ranksNet',
                W + 'reads_increment'],
    'dependencies': [REUSE],
    'related': [
        {'id': 'weights-within-a-ratio-agree-past-it', 'detail': t(
            'The other half of the valuer tests as theorems: where the exception bounds a widening, the ratio law bounds a '
            'mixed comparison.', '评价者检验成为定理的另一半：例外界定扩大，比值之律界定混合的比较。')},
        {'id': 'graded-significance-and-priority', 'detail': t(
            'There status zero is a scope denial that ties; here a weight at zero ties and a weight below zero reverses.',
            '那里“算多少”为零是持平的范围否认；此处权重为零持平，低于零则逆转。')},
    ],
    'references': references(BEYOND + NET + BY + INC + PRES + TERMS + FRAMED + INTER),
    'proof_bindings': [BINDING],
    'history': [t(f'{DATE}: added (VT1): what VD1 and VD2 tested of T5\'s exception, stated as theorems with presentation '
                  f'invariance and the link of a sign measured apart as named premises, after a literature check (significance '
                  f'review, valuer-theorems check); weighed_lt_of_widens derived as the case with nothing against; study '
                  f'section {N}.',
                  f'2026年10月22日：新增（VT1）：VD1 与 VD2 就 T5 的例外所检验者，陈述为定理，以表述不变与分开测得的正负号的联系为指名的'
                  f'前提，此前做了文献核查（显著性审查“评价者定理”核查）；weighed_lt_of_widens 作为无负份的情形导出；研究第 {N} 节。')],
}

ratio = {
    'schema_version': 2,
    'id': 'weights-within-a-ratio-agree-past-it',
    'title': t('Weights within a ratio agree past it', '比值之内的权重越过它即一致'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F07',
    'reviewed_at_utc': NOW,
    'statement': t('Every positive weighting whose weights stand within n/d of each other ranks the course keeping p items '
                   'the other does not above the one keeping q exactly where n q < d p; two such weightings rank a pair '
                   'opposite ways exactly where n/d exceeds both p/q and q/p.',
                   '权重彼此在 n/d 之内的每个正加权，恰在 n q < d p 时把保住对方所无的 p 项的进程排在保住 q 项者之上；两个这样的加权把一对'
                   '排成相反方向，恰当 n/d 同时超过 p/q 与 q/p。'),
    'laws': [
        {**t('Where every two listed weights stand within n/d, what each course alone admits bounds what it weighs: d times '
             'what the second alone admits weighs, once per item the first alone admits, is at most n times the number the '
             'second alone admits, times what the first alone admits weighs.',
             '所列的每两个权重都在 n/d 之内时，各进程独有者界定其所重：第二条独有者之重的 d 倍，按第一条独有的每项计一次，至多是第二条独有'
             '项数的 n 倍乘以第一条独有者之重。'), 'declarations': BOUND},
        {**t('Every positive weighting within n/d ranks a above b where n q < d p, and weighs a at least as much where '
             'n q ≤ d p, p and q the numbers of items a and b alone admit.',
             '比值 n/d 之内的每个正加权，在 n q < d p 时把 a 排在 b 之上，在 n q ≤ d p 时给 a 的重量不少于 b，p 与 q 是 a 与 b 各自独有的'
             '项数。'), 'declarations': PAST},
        {**t('The weighting tilted toward b, n on what b alone admits and d elsewhere, is positive and within n/d for '
             '0 < d ≤ n; it ranks a above b exactly where n q < d p and ties them on the boundary n q = d p.',
             '偏向 b 的加权，在 b 独有者上为 n、其余为 d，当 0 < d ≤ n 时为正且在 n/d 之内；它恰在 n q < d p 时把 a 排在 b 之上，并在边界 '
             'n q = d p 上使两者持平。'), 'declarations': TILT},
        {**t('For 0 < d ≤ n: every positive weighting within n/d ranks a above b exactly where n q < d p; some ranks b above '
             'a exactly where d p < n q; two rank them opposite ways exactly where d q < n p and d p < n q.',
             '对 0 < d ≤ n：比值 n/d 之内的每个正加权恰在 n q < d p 时把 a 排在 b 之上；某个把 b 排在 a 之上，恰当 d p < n q；两个把它们'
             '排成相反方向，恰当 d q < n p 且 d p < n q。'), 'declarations': CLASS},
        {**t('Equal weights are the ratio one: under one positive weight a course weighs more exactly where it admits more '
             'beyond the other than the other beyond it, so it ranks by number; the weighting tilted toward a course admitting '
             'an item the other does not, with weight one more than the listing\'s length, ranks it higher.',
             '等权重是比值一：在同一正权重下，一条进程恰在其超出对方者多于对方超出它者时更重，故按数目排；偏向一条接纳了对方所不接纳之项的'
             '进程、权重比列举长度多一的加权，把它排得更高。'), 'declarations': EQUAL},
    ],
    'hypotheses': [t(
        'No axiom. A finite listing of items; two-valued admission; natural weights positive on every listed item; the ratio '
        'n/d with 0 < d ≤ n for the exact forms (0 < n for the weak one); p and q counted with the listing\'s repetitions.',
        '不加公理。项的有限列举；二值接纳；在每个所列项上为正的自然数权重；精确形式需比值 n/d 满足 0 < d ≤ n（弱形式需 0 < n）；p 与 q '
        '按列举中的重复计数。')],
    'does_not_show': [
        {**t('How dispersed actual valuers\' weights are, or that their valuations are additive: dispersion is a premise to '
             'measure.', '实际评价者的权重分散到什么程度，或其评价可加：分散是要测量的前提。'), 'kind': 'scope'},
        {**t('How many valuers disagree: the laws say which weightings can rank a pair opposite ways, not their share; no '
             'probability over weights is stated.', '有多少评价者有分歧：这些规律说明哪些加权能把一对排成相反方向，不说其比例；没有陈述'
             '权重上的概率。'), 'kind': 'scope'},
        {**t('The threshold for orders that are not additive: an order increasing in admission but not additive need not '
             'follow it.', '不可加的次序的阈值：随接纳递增但不可加的次序不必遵循它。'), 'kind': 'scope'},
        {**t('That the larger side is better: counting is a further premise, and C ranks neither side of a mixed pair.',
             '较大的一方更好：计数是又一个前提，C 不把混合的一对中任何一方排得更高。'), 'kind': 'non-implication'},
    ],
    'counterexamples': [{'path': SOURCE, 'detail': t(
        'On the boundary n q = d p the tilted weighting ties the two courses (Weighting.tilted_ties), and short of it, '
        'd p < n q, it ranks the smaller side higher (Weighting.tilted_gt_iff): the threshold is exact.',
        '在边界 n q = d p 上偏向的加权使两条进程持平（Weighting.tilted_ties），未达边界即 d p < n q 时，它把较小的一方排得更高'
        '（Weighting.tilted_gt_iff）：阈值是精确的。')}],
    'standard_boundaries': BOUNDARIES,
    'validation_scope': SCOPE,
    'next_delta': t('A probabilistic form over exchangeable weights, the share of valuers who disagree as a function of '
                    'dispersion, in the periphery with its axioms reported; the threshold for orders that are not additive; '
                    'dispersion measured on human valuers; an independent review.',
                    '可交换权重上的概率形式，即分歧的评价者所占比例与分散程度的关系，放在外围并报告其公理；不可加次序的阈值；在人类评价者上测'
                    '分散；独立审查。'),
    'correspondence': t(
        'Equal weights and improper linear models (Einhorn and Hogarth 1975; Dawes 1979; Wilks 1938): equal weights '
        'approximate estimated ones; here the exact ordinal form for two-valued courses. Dominance under partial information '
        'on weights (Kirkwood and Sarin 1985; imprecise ratio statements, Salo and Hämäläinen 1992): the tilted weighting is '
        'the extreme point that decides. Robust ordinal regression (Greco, Mousseau and Słowiński 2008): under the ratio '
        'bound the necessary relation is n q < d p and a possible reversal d p < n q. Reading (the AI\'s): "valuers count" '
        '(VD1) is weights mostly dispersed less than the pairs\' ratios; VD1\'s mixed pairs kept 2 : 1, 3 : 1 and 1 : 1, '
        'so disagreement among valuers whose weights stand within twofold falls only on the last, where it was highest.',
        '等权重与非正规线性模型（Einhorn 与 Hogarth 1975；Dawes 1979；Wilks 1938）：等权重近似估计的权重；此处是二值进程上的精确序数'
        '形式。权重部分信息下的占优（Kirkwood 与 Sarin 1985；不精确的比值陈述，Salo 与 Hämäläinen 1992）：偏向的加权是作出裁定的极点。'
        '稳健序数回归（Greco、Mousseau 与 Słowiński 2008）：在比值界下，必然关系是 n q < d p，可能的逆转是 d p < n q。解读（AI 的）：'
        '“评价者计数”（VD1）是权重大多分散不到各对的比值；VD1 的混合对为 2 : 1、3 : 1 与 1 : 1，所以权重在两倍之内的评价者的分歧只落在'
        '最后一种上，那里分歧最高。'),
    'canonical_source': SOURCE,
    'aliases': ['weights within a ratio agree past it', '比值之内的权重越过它即一致', W + 'every_within_iff',
                W + 'opposite_within_iff', W + 'tilted_ties'],
    'dependencies': [REUSE],
    'related': [
        {'id': 'a-narrowing-above-its-widening', 'detail': t(
            'The other half of the valuer tests as theorems: the exception bounds a widening, this law a mixed comparison.',
            '评价者检验成为定理的另一半：例外界定扩大，此律界定混合的比较。')},
    ],
    'references': references(BOUND + PAST + TILT + CLASS + EQUAL + BEYOND[:2]),
    'proof_bindings': [BINDING],
    'history': [t(f'{DATE}: added (VT1): the locus VD1 tested, stated as a theorem conditional on how dispersed the weights '
                  f'are, with the exact threshold and the tilted weighting tying at the boundary; outweighs and '
                  f'neutral_ranks_by_number derived as its cases; study section {N}.',
                  f'2026年10月22日：新增（VT1）：VD1 所检验的落点，陈述为以权重分散程度为条件的定理，给出精确阈值，偏向的加权在边界上持平；'
                  f'outweighs 与 neutral_ranks_by_number 作为其情形导出；研究第 {N} 节。')],
}

for record in (narrowing, ratio):
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n')
    print('wrote', record['id'])


def rebind(d):
    """Drop the declarations that went, refresh the module's hash and point its proof binding at the receipt."""
    for ref in d['references']:
        if ref['path'] == SOURCE:
            ref['declarations'] = [n for n in ref['declarations'] if n not in GONE]
            for n in ref['declarations']:
                assert n in HAVE, n
            ref['sha256'] = sha(SOURCE)
    for b in d['proof_bindings']:
        if b['source'] == SOURCE:
            b['receipt'] = RECEIPT
    if not any(r['path'] == RECEIPT for r in d['references']):
        d['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
    d['reviewed_at_utc'] = NOW


path = RECORDS / 'widening-as-what-every-weighting-ranks.json'
d = json.loads(path.read_text())
law = next(x for x in d['laws'] if W + 'outweighing' in x['declarations'])
law['en'] = ('Where one course admits a listed item the other does not, the weighting tilted toward it, one more than the '
             'listing\'s length on what it alone admits and one elsewhere, ranks it higher; so a mixed comparison is decided '
             'both ways by positive weightings.')
law['zh'] = ('一条进程接纳另一条不接纳的某个所列项时，偏向它的加权（在它独有者上比列举长度多一，其余为一）把它排得更高；所以混合的比较由正的'
             '加权两个方向都能决定。')
law['declarations'] = [W + 'tilted' if n == W + 'outweighing' else n for n in law['declarations']]
assert W + 'tilted' not in d['references'][0]['declarations']
d['references'][0]['declarations'] = sorted(d['references'][0]['declarations'] + [W + 'tilted'])
cx = d['counterexamples'][0]['detail']
assert '(Weighting.outweighing)' in cx['en'] and '（Weighting.outweighing）' in cx['zh']
cx['en'] = cx['en'].replace('(Weighting.outweighing)', '(Weighting.tilted)')
cx['zh'] = cx['zh'].replace('（Weighting.outweighing）', '（Weighting.tilted）')
rebind(d)
for rid, detail in ((narrowing['id'], t('weighed_lt_of_widens is its case with nothing against.',
                                        'weighed_lt_of_widens 是其无负份的情形。')),
                    (ratio['id'], t('outweighs and neutral_ranks_by_number are its cases, the ratio past the pair\'s and the '
                                    'ratio one.', 'outweighs 与 neutral_ranks_by_number 是其情形：比值越过这一对的比值，以及比值一。'))):
    d.setdefault('related', []).append({'id': rid, 'detail': detail})
d['history'].append(t(
    f'{DATE}, VT1: the widening law, outweighs and neutral_ranks_by_number keep their statements and are derived from the '
    f'net weightings and the weights within a ratio (records {narrowing["id"]} and {ratio["id"]}); the witness outweighing '
    f'gave way to the tilted weighting, and the second law and the counterexample name it; study section {N}.',
    f'2026年10月22日，VT1：扩大之律、outweighs 与 neutral_ranks_by_number 陈述不变，由净加权与比值之内的权重导出（记录 '
    f'{narrowing["id"]} 与 {ratio["id"]}）；见证 outweighing 让位于偏向的加权，第二条定律与反例改称之；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('updated', d['id'])

for rid in ('what-the-step-across-standpoints-reaches', 'graded-significance-and-priority'):
    path = RECORDS / f'{rid}.json'
    d = json.loads(path.read_text())
    rebind(d)
    d['history'].append(t(
        f'{DATE}, VT1: Becoming.Weightings grew (net weightings, rankings of presentations, weights within a ratio); the '
        f'five declarations that went (outweighing and its four lemmas) leave the reference list; this record\'s laws are '
        f'unchanged; study section {N}.',
        f'2026年10月22日，VT1：Becoming.Weightings 扩充（净加权、对表述的排序、比值之内的权重）；被去掉的五项声明（outweighing 及其四条'
        f'引理）移出引用列表；本记录的规律不变；研究第 {N} 节。'))
    path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('updated', rid)
