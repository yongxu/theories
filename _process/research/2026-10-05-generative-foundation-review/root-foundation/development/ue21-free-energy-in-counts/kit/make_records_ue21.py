#!/usr/bin/env python3
"""UE21 record: write free-energy-bound-in-counts (the core module Becoming.FreeEnergyCounting, homed at 03 §6 after
free-energy-bounds-surprisal), each declaration of the module cited once; relate free-energy-bounds-surprisal and
conditioning-by-restriction to it, each with a related entry and a history note; free-energy-bounds-surprisal's next
step and fourth does-not-show item, and conditioning-by-restriction's correspondence, are brought to UE21, no statement
or declaration of theirs changing. Asserts the receipt's hash and empty axiom reports for the module, and the style
caps and lint on every field written. Mirrors UE19's make_records_ue19.py.
usage (from the checkout root, after texts_ue21.py): python3 -B make_records_ue21.py RECEIPT N
       python3 -B make_records_ue21.py --caps  (the caps, lint and the declaration cover against the kit's scratch
                                                audit; writes nothing)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = ('20261030T000000.000000Z', 456) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/ue21-free-energy-in-counts/'
NOTE, REVIEW, RECHECK = KITD + 'NOTE.md', KITD + 'REVIEW-UE21.md', KITD + 'RECHECK-UE21.md'
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
MODULE = f'{PKG}/Becoming/FreeEnergyCounting.lean'
CW = f'{PKG}/Becoming/ConditionalWeights.lean'
PRELUDE = f'{PKG}/Becoming/Prelude.lean'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'free-energy-bound-in-counts'
RIDFE = 'free-energy-bounds-surprisal'
RIDCOND = 'conditioning-by-restriction'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
COUNT = 65
M = 'Becoming.FreeEnergyCounting'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


if CAPS_ONLY:
    audit = (HERE.parent / 'tree/.build/BecomingFreeEnergyCountingAxiomAudit.lean').read_text(encoding='utf-8')
    names = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256'][M] == sha(MODULE), M
    mod = next(x for x in core['modules'] if x['module'] == M)
    assert not any(mod['axiom_dependencies'].values()), M
    names = {d['name'] for d in mod['declarations']}
assert len(names) == COUNT, len(names)


def C(*short):
    out = [f'{M}.' + s for s in short]
    missing = [n for n in out if n not in names]
    assert not missing, missing
    return out


W = 'Witness.'
groups = [
    ("Arithmetic in counts proved without the prelude's propositional extensionality: powers of a product, a count to "
     "its own power positive, strict cancellation, a power of nothing, strict powers (mul_pow_eq and five more).",
     "不依前奏之命题外延而证之计数算术：积之幂、计数自乘为正、严格消去、幂为零、严格之幂（mul_pow_eq 等六项）。",
     C('mul_pow_eq', 'self_pow_pos', 'lt_cancel_mul_left', 'lt_cancel_mul_right', 'base_zero_of_pow_zero',
       'pow_succ_lt_pow_succ')),
    ("Rearrangement in counts: pairing the larger with the larger gives at least as much, strictly where both pairs "
     "are apart, and two powers rearranged (rearrange, rearrange_strict, powers_rearrange, powers_rearrange_strict).",
     "计数之重排：大者配大者至少同多，两对皆分时严格，及二幂之重排（rearrange、rearrange_strict、powers_rearrange、"
     "powers_rearrange_strict）。",
     C('rearrange', 'rearrange_strict', 'powers_rearrange', 'powers_rearrange_strict')),
    ("A Bernoulli-type inequality: (k + 1) * x * y ^ k ≤ x ^ (k + 1) + k * y ^ (k + 1), strict for distinct x and y "
     "and positive k (bernoulli, bernoulli_strict and three identities).",
     "伯努利型不等式：(k + 1) * x * y ^ k ≤ x ^ (k + 1) + k * y ^ (k + 1)，x 与 y 相异且 k 为正时严格（bernoulli、"
     "bernoulli_strict 及三恒等式）。",
     C('bernoulli', 'bernoulli_strict', 'bernoulli_split', 'bernoulli_regroup', 'bernoulli_close')),
    ("One more term joins a mean: (k + 1) ^ (k + 1) * S ^ k * y ≤ k ^ k * (S + y) ^ (k + 1), strict where k * y ≠ S "
     "and k is positive (mean_step, mean_step_strict and three identities).",
     "多一项入于均值：(k + 1) ^ (k + 1) * S ^ k * y ≤ k ^ k * (S + y) ^ (k + 1)，k * y ≠ S 且 k 为正时严格（mean_step、"
     "mean_step_strict 及三恒等式）。",
     C('mean_step', 'mean_step_strict', 'mean_step_identity', 'mean_step_lhs', 'mean_step_rhs')),
    ("Two values in counts: (n + m) ^ (n + m) * (x ^ n * y ^ m) ≤ (n * x + m * y) ^ (n + m), strict for positive n, "
     "distinct x and y and at least one y (mean_two, mean_two_strict, mean_two_sum, mean_two_ident).",
     "计数之二值：(n + m) ^ (n + m) * (x ^ n * y ^ m) ≤ (n * x + m * y) ^ (n + m)，n 为正、x 与 y 相异且至少一 y 时严格"
     "（mean_two、mean_two_strict、mean_two_sum、mean_two_ident）。",
     C('mean_two', 'mean_two_strict', 'mean_two_sum', 'mean_two_ident')),
    ("Two parts: (n + m) ^ (n + m) * (a ^ n * b ^ m) ≤ (a + b) ^ (n + m) * (n ^ n * m ^ m), strict for positive counts "
     "unless a * m = b * n, reached only where n * b = a * m (two_parts and four more).",
     "二部分：(n + m) ^ (n + m) * (a ^ n * b ^ m) ≤ (a + b) ^ (n + m) * (n ^ n * m ^ m)，计数为正而 a * m ≠ b * n 时严格，"
     "唯于 n * b = a * m 处取等（two_parts 等五项）。",
     C('two_parts', 'two_parts_strict', 'proportional_of_two_parts_eq', 'two_parts_lhs', 'two_parts_rhs')),
    ("The bound: for natural counts n and weights a over any listed hypotheses, N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n, "
     "with no support condition (powerProduct, bound and five more).",
     "界：任意列出之假设上之自然数计数 n 与权重 a，N ^ N * ∏ a ^ n ≤ A ^ N * ∏ n ^ n，无支撑条件（powerProduct、bound 等七项）。",
     C('powerProduct', 'powerProduct_self_pos', 'zero_of_total_zero', 'cons_left', 'cons_mid', 'cons_right', 'bound')),
    ("Equality exactly in proportion: the bound holds with equality exactly where n h * A = a h * N at every listed "
     "hypothesis, and is strict elsewhere (bound_eq_iff, bound_lt_of_not_proportional and four more).",
     "恰于成比例处取等：每一列出之假设 n h * A = a h * N 时恰取等，余处严格（bound_eq_iff、bound_lt_of_not_proportional "
     "等六项）。",
     C('powerProduct_scaled', 'bound_eq_of_proportional', 'proportional_cons', 'proportional_of_bound_eq',
       'bound_eq_iff', 'bound_lt_of_not_proportional')),
    ("The degenerate cases: every weight nothing puts every count belief at the bound; with every count nothing both "
     "sides are one (zero_weights_reach, no_counts_reach).",
     "退化之情形：权重皆零令每一计数信念皆在界上；计数皆零则两边皆为一（zero_weights_reach、no_counts_reach）。",
     C('zero_weights_reach', 'no_counts_reach')),
    ("In a core generative model the total of the joint weights is the record's weight, and the count beliefs at the "
     "bound are exactly those in proportion to the joint weights, the joint weights themselves among them (joint, "
     "record_total, bound_given_record, given_record_eq_iff, posterior_counts_reach).",
     "于核心之生成模型，联合权重之总和即记录之权重，达界之计数信念恰为与联合权重成比例者，联合权重本身在其中（joint、record_total、"
     "bound_given_record、given_record_eq_iff、posterior_counts_reach）。",
     C('joint', 'record_total', 'bound_given_record', 'given_record_eq_iff', 'posterior_counts_reach')),
    ("Where the record weighs nothing every count belief is at the bound, both sides nothing, with no share given the "
     "record to be in proportion to (nothing_record_reach_all).",
     "记录无权重时，每一计数信念皆在界上，两边皆为零，无记录下之份额可与之成比例（nothing_record_reach_all）。",
     C('nothing_record_reach_all')),
    ("With the hypotheses listed once, the count beliefs at the bound are exactly those whose every count over the "
     "total is the same ratio as the hypothesis's share given the record (given_record_eq_iff_share).",
     "假设列而不重时，达界之计数信念恰为每一计数比总数与该假设于记录下之份额同比者（given_record_eq_iff_share）。",
     C('given_record_eq_iff_share')),
    ("Away from proportion the bound is strict and scaled counts reach it: a belief all on one of two hypotheses of "
     "weight one has 1 < 2; two counts on each, 4 ^ 4 = 2 ^ 4 * 2 ^ 2 * 2 ^ 2 (Witness.even and four more).",
     "离比例则界严格，而倍数之计数达界：全置于二权重为一之假设之一，1 < 2；各置二，4 ^ 4 = 2 ^ 4 * 2 ^ 2 * 2 ^ 2"
     "（Witness.even 等五项）。",
     C(W + 'even', W + 'first', W + 'strict_off_proportion', W + 'twoEach', W + 'scaled_reach')),
    ("Off the support the bound still holds: a belief all on a hypothesis of joint weight nothing makes the left side "
     "nothing (Witness.secondOnly, Witness.off_support).",
     "离支撑界仍成立：全置于联合权重为零之假设之信念令左边为零（Witness.secondOnly、Witness.off_support）。",
     C(W + 'secondOnly', W + 'off_support')),
    ("At one total the bound may be unreached: against weights one and two every count belief of total two is "
     "strictly below it (Witness.oneTwo, Witness.split2, Witness.total_two_unreached).",
     "于一总数界或不可达：对权重一与二，总数二之计数信念皆严格居其下（Witness.oneTwo、Witness.split2、"
     "Witness.total_two_unreached）。",
     C(W + 'oneTwo', W + 'split2', W + 'total_two_unreached')),
    ("A record weighing nothing puts every count belief at the bound, and a hypothesis listed twice breaks the join "
     "to the share: count 1 over 3 at the bound, share 2 over 3 (Witness.unitPrior and three more).",
     "记录无权重则每一计数信念皆在界上；假设列二次则断与份额之相接：达界时计数为三分之一，份额为三分之二（Witness.unitPrior "
     "等四项）。",
     C(W + 'unitPrior', W + 'unitLik', W + 'nothing_record_reach', W + 'duplicate_share')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)) == COUNT and set(cited) == names, sorted(names - set(cited))
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

validation = capped('validation_scope', {
    'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): all {COUNT} declarations of '
          f'{M}, each with an empty axiom report. Drafted by an AI agent; an independent read-only review by another AI '
          f'agent (REVIEW-UE21) and a re-check (RECHECK-UE21), study section {N}; not reviewed by a person.',
    'zh': f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：{M} 之全部 {COUNT} 项声明，公理报告皆空。由一 AI 代理起草；另一 AI 代理作独立只读审查'
          f'（REVIEW-UE21）并复查（RECHECK-UE21），见研究第 {N} 节；未经人审。'})
title = capped('title', {'en': 'The free-energy bound in counts', 'zh': '计数之自由能界'})
statement = capped('statement', {
    'en': "For natural counts n and weights a over listed hypotheses, N^N·∏ a^n ≤ A^N·∏ n^n, equal exactly in "
          "proportion; in a core generative model A is the record's weight, and with hypotheses listed once the "
          "beliefs at the bound are those at the shares given the record.",
    'zh': '列出之假设上之自然数计数 n 与权重 a，N^N·∏ a^n ≤ A^N·∏ n^n，恰于成比例处取等；于核心之生成模型 A 为记录之权重，假设列而不重时，达界之信念即记录下份额之信念。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "No axiom. Natural counts and weights over listed hypotheses, the core's total over a listing; for the "
           "join to the shares, hypotheses listed once and their equality decided.",
     'zh': '不加公理。列出之假设上之自然数计数与权重，核心之列表总和；与份额相接需假设列而不重且其相等可判定。'},
    {'en': "Read as the free-energy bound for the belief n / N with a positive total, as UE17's real form on the "
           "support; read as conditioning, where the record weighs something, it states which beliefs reach the bound, "
           "not a minimization at one total.",
     'zh': '于总数为正时读作信念 n / N 之自由能界，于支撑上与 UE17 之实数形式相合；读作条件化需记录有权重，且说何信念达界，非一总数下之最小化。'},
    {'en': "Modelling choices: 0 ^ 0 = 1; the belief read as the shares n / N; the record's weight as the total, where "
           "FreeEnergyReals reads the joint weights as shares of the whole weight, both bounds shifting by its "
           "logarithm.",
     'zh': '建模之选：0 ^ 0 = 1；信念读作份额 n / N；记录之权重为总和，FreeEnergyReals 则读联合权重为整体权重之份额，二界皆以其对数平移。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "A theorem joining it to FreeEnergyReals' bound for count beliefs; off the support the two laws differ, the "
           "real form failing under log 0 = 0.",
     'zh': '与 FreeEnergyReals 之界于计数信念相接之定理；离支撑二律相异，实数形式依 log 0 = 0 不成立。', 'kind': 'scope'},
    {'en': "A minimization at one fixed total: there the bound may be reached by no count belief.",
     'zh': '一固定总数下之最小化：彼处或无计数信念达界。', 'kind': 'non-implication'},
    {'en': "Conditioning where the record weighs nothing: every count belief is then at the bound, for a degenerate "
           "reason.",
     'zh': '记录无权重时之条件化：其时每一计数信念皆在界上，乃退化之故。', 'kind': 'non-implication'},
    {'en': "Beliefs with irrational shares or densities, complexity and accuracy from the core's own shares, or any "
           "process that lowers free energy.",
     'zh': '无理份额或密度之信念、由核心自身份额读出之复杂度与准确度，或降低自由能之任何过程。', 'kind': 'scope'})]
next_delta = capped('next_delta', {
    'en': "The periphery theorem joining it to FreeEnergyReals' bound for count beliefs with a positive total on the "
          "support; complexity and accuracy from the core's own shares; review by a person.",
    'zh': '外围之定理：于总数为正且在支撑上之计数信念，与 FreeEnergyReals 之界相接；由核心自身份额读出之复杂度与准确度；人之审查。'})
correspondence = capped('correspondence', {
    'en': "In counts the bound is Cauchy's arithmetic-geometric mean inequality (Cauchy 1821, Cours d'analyse, note "
          "II) for N terms, a h / n h taken n h times, a count being a repetition, with its case of equality; "
          "equivalently Gibbs' inequality (Gibbs 1902) and the nonnegativity of the divergence (Kullback and Leibler "
          "1951) for rational distributions, the free-energy principle's bound (Friston 2005, 2010) for count "
          "beliefs. Read with a / A as a model and n as observed counts it says the observed frequencies maximize the "
          "multinomial likelihood (the method of types; Cover and Thomas 2006, §11.1). Both readings are classical; "
          "new is that the bound and its equality hold in the pure core. Graded in UE21's NOTE.",
    'zh': '计数之界即 Cauchy 之算术–几何平均不等式（Cauchy 1821，Cours d\'analyse 注 II），N 项中 a h / n h 取 n h 次，计数即重复，及其取等之情形；等价于'
          '有理分布之 Gibbs 不等式（Gibbs 1902）与散度之非负（Kullback、Leibler 1951），即自由能原理之界（Friston 2005、2010）于计数信念。以 a / A 为模型、'
          'n 为观测计数而读，则谓观测频率使多项似然最大（类型之法；Cover、Thomas 2006，§11.1）。二读皆经典；新者为界及其取等于纯核心成立。分级见 UE21 之 NOTE。'})
counterexamples = [
    {'en': "Against weights one and two, every count belief of total two is strictly below the bound, 8 < 9 at best "
           "(Witness.total_two_unreached).",
     'zh': '对权重一与二，总数二之计数信念皆严格居界下，至多 8 < 9（Witness.total_two_unreached）。'},
    {'en': "With a hypothesis listed twice, counts at the bound give it 1 over 3 where its share given the record is "
           "2 over 3 (Witness.duplicate_share).",
     'zh': '一假设列二次时，达界之计数予之三分之一，而其于记录下之份额为三分之二（Witness.duplicate_share）。'}]


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


assert not lint_errors({'schema_version': 2, 'id': RID, 'title': title, 'statement': statement, 'laws': laws,
                        'hypotheses': hypotheses, 'does_not_show': does_not_show,
                        'counterexamples': [{'detail': x} for x in counterexamples],
                        'validation_scope': validation, 'next_delta': next_delta, 'correspondence': correspondence})
if CAPS_ONLY:
    print(f'caps: ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
          len(statement['zh']), '; correspondence', len(correspondence['en']), len(correspondence['zh']),
          '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws))
    raise SystemExit(0)

record = {
    'schema_version': 2, 'id': RID, 'title': title, 'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01',
    'reviewed_at_utc': NOW, 'statement': statement, 'laws': laws, 'hypotheses': hypotheses,
    'does_not_show': does_not_show, 'counterexamples': [{'path': MODULE, 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation, 'next_delta': next_delta, 'correspondence': correspondence,
    'canonical_source': MODULE,
    'aliases': ['The free-energy bound in counts', '计数之自由能界', 'free-energy bound in counting form',
                'arithmetic-geometric mean inequality in counts', 'multinomial likelihood at the observed frequencies', f'{M}.bound', f'{M}.bound_eq_iff',
                f'{M}.given_record_eq_iff_share'],
    'dependencies': [{'id': RIDCOND, 'relation': 'formal-reuse',
                      'detail': {'en': 'evidence, mass_eq_total, posterior_single, Share.Same, share, restrict, pairWeight '
                                       'and openSteps: the record\'s weight as a total, and the share given the record.',
                                 'zh': 'evidence、mass_eq_total、posterior_single、Share.Same、share、restrict、pairWeight 与 '
                                       'openSteps：记录之权重为总和，及记录下之份额。'}}],
    'related': [{'id': RIDFE, 'detail': {'en': 'Variational free energy bounds surprisal: its bound over the reals, for '
                                               'count beliefs with a positive total on the support this one through the '
                                               'logarithm.',
                                         'zh': '变分自由能为惊异之界：其实数上之界，于总数为正且在支撑上之计数信念，即此界取对数。'}}],
    'references': [{'path': MODULE, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(MODULE)},
                   {'path': CW, 'role': 'proof', 'sha256': sha(CW)},
                   {'path': PRELUDE, 'role': 'proof', 'sha256': sha(PRELUDE)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': NOTE, 'role': 'integration', 'sha256': sha(NOTE)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': RECHECK, 'role': 'integration', 'sha256': sha(RECHECK)},
                   {'path': CH3, 'role': 'statement', 'sha256': sha(CH3)}],
    'proof_bindings': [{'source': MODULE, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{M}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'{DATE_EN}: added (UE21), the free-energy bound in counts in the pure core: N^N·∏ a^n ≤ '
                       f'A^N·∏ n^n, equal exactly in proportion, joined to the core\'s generative model and, with the '
                       f'hypotheses listed once, to the shares given the record; after a review and a re-check; study '
                       f'section {N}.',
                 'zh': f'{DATE_ZH}：新增（UE21），纯核心中计数之自由能界：N^N·∏ a^n ≤ A^N·∏ n^n，恰于成比例处取等，与核心之生成模型相接，假设列而不重时与'
                       f'记录下之份额相接；经审查与复查；研究第 {N} 节。'}],
}
for dep in [x['id'] for x in record['dependencies']]:
    assert (RECORDS / f'{dep}.json').exists(), dep
path = RECORDS / f'{RID}.json'
assert not path.exists(), path
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(laws), 'laws')


def load(rid):
    return json.loads((RECORDS / f'{rid}.json').read_text(encoding='utf-8'))


def save(rid, d):
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


# free-energy-bounds-surprisal: the next step and the fourth does-not-show item, asserted to change once
d = load(RIDFE)
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {'en': 'The free-energy bound in counts: the bound and its equality for count '
                                                 'beliefs in the pure core, with no axiom and no support condition.',
                                           'zh': '计数之自由能界：纯核心中计数信念之界及其取等，无公理，无支撑条件。'}})
for lang, old, new in [
        ('en', "A core form of the bound, N^N·∏ a^n ≤ A^N·∏ n^n for beliefs with natural counts, equal, where the record "
               "weighs something, exactly at the share given the record; complexity", "Complexity"),
        ('zh', '界之核心形式：自然数计数之信念 N^N·∏ a^n ≤ A^N·∏ n^n，记录有权重时恰于记录下之份额取等；由核心', '由核心')]:
    assert d['next_delta'][lang].count(old) == 1, (lang, old[:40])
    d['next_delta'][lang] = d['next_delta'][lang].replace(old, new)
x = d['does_not_show'][3]
assert x['en'].startswith("The bound's counting form for beliefs with natural counts")
x['en'], x['zh'] = capped('does_not_show', {
    'en': "Complexity and accuracy read from the core's own prior and likelihood shares; the bound's counting form is "
          "stated in free-energy-bound-in-counts.",
    'zh': '由核心自身之先验与似然份额读出之复杂度与准确度；界之计数形式述于 free-energy-bound-in-counts。'}, item=True).values()
d['history'].append({'en': f'{DATE_EN}, board item UE21 (study section {N}): related to {RID}; the next step drops the '
                           f'core form of the bound, now stated, and the fourth item of what it does not show names the '
                           f'record that states it; no statement or declaration changed.',
                     'zh': f'{DATE_ZH}，工作板条目 UE21（研究第 {N} 节）：与 {RID} 相关联；下一步删去界之核心形式（已述），所不示之第四项指明述之之记录；'
                           f'无一陈述或声明改变。'})
save(RIDFE, d)

# conditioning-by-restriction: its correspondence names the bound in counts in the core
d = load(RIDCOND)
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {'en': 'The free-energy bound in counts: conditioning reached by the bound in '
                                                 'counts, through posterior_single, with the hypotheses listed once.',
                                           'zh': '计数之自由能界：经 posterior_single，假设列而不重时，计数之界所达者即条件化。'}})
for lang, old, new in [
        ('en', "free energy and its bound are stated in the periphery and joined to posterior_single there "
               "(free-energy-bounds-surprisal).",
         "free energy and its bound are stated in the periphery and joined to posterior_single there "
         "(free-energy-bounds-surprisal), and the bound in counts in the core (free-energy-bound-in-counts)."),
        ('zh', '自由能及其界述于外围，并于彼处与 posterior_single 相接（free-energy-bounds-surprisal）。',
         '自由能及其界述于外围，并于彼处与 posterior_single 相接（free-energy-bounds-surprisal），计数之界述于核心（free-energy-bound-in-counts）。')]:
    assert d['correspondence'][lang].count(old) == 1, (lang, old[:40])
    d['correspondence'][lang] = d['correspondence'][lang].replace(old, new)
capped('correspondence', d['correspondence'])
d['history'].append({'en': f'{DATE_EN}, board item UE21 (study section {N}): related to {RID}; the correspondence names '
                           f'the bound in counts in the core; no statement, next step or declaration changed.',
                     'zh': f'{DATE_ZH}，工作板条目 UE21（研究第 {N} 节）：与 {RID} 相关联；对应指明核心中计数之界；无一陈述、下一步或声明改变。'})
save(RIDCOND, d)
print('records related here:', RIDFE, RIDCOND)
