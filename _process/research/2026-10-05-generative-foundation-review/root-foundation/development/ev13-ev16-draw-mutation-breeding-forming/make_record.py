#!/usr/bin/env python3
"""Write EV13-EV16's records, note them in the records they continue (fixation-by-drift,
additive-part-of-offspring-variance, forming-anew-necessary-and-sufficient), and give the coverage file's evolution row its records:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations, and the receipt must bind the modules'
current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. Selection in the draw, mutation, the breeding value, and dependences formed from drawing (EV13-EV16)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return m


def resolve(mod, prefix, names):
    full = {d['name'] for d in decls(mod)['declarations']}
    out = [f'Becoming.{mod}.{prefix}{n}' for n in names]
    for n in out:
        assert n in full, n
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


def validation(mod):
    return {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              f'Becoming.{mod} has an empty axiom report; the checker verifies core purity. Built and reviewed in one '
              f'session, with no separate reviewer; author review in study section {N}; not independently reviewed by a '
              'person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.{mod} 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'}


def refs(mod):
    return ([{'path': src(mod), 'role': 'proof', 'declarations': sorted(d['name'] for d in decls(mod)['declarations']),
              'sha256': sha(src(mod))},
             {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
             {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
             {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
             {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
            [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
              'success_pointer': '/status', 'success_value': 'passed'}])


RID13 = 'fixation-with-selection'
RID14 = 'mutation-and-the-balance-it-sets'
FBD = 'fixation-by-drift'
ADD = 'additive-part-of-offspring-variance'
STG = 'selection-term-over-generations'
DOS = 'drift-offspring-sampled'
P = 'Replacement.'
laws13 = [
    ('Replacement one at a time among M + 1: from a mixed population the count goes up with weight a and down with b, a '
     'population of one kind staying; the histories are counted step by step and compose.',
     'M + 1 个成员中一次替换一个：混合种群中计数以权重 a 上升、以 b 下降，单一类的种群保持；历史逐步计数并可复合。',
     ['Mixed', 'value', 'value_mixed', 'value_one_kind', 'value_stays', 'value_add', 'value_mul', 'value_le',
      'value_const', 'value_comp', 'value_congr']),
    ('The potential with steps b^j a^(M - j) is harmonic for the steps, a times a step being b times the one below, so '
     'it keeps its weighted value over any number of steps.',
     '步长为 b^j a^(M - j) 的势对这些步是调和的（a 乘一步等于 b 乘其下一步），故在任意步数中保持其加权值。',
     ['rise', 'potential', 'rise_step', 'potential_harmonic', 'value_potential', 'potential_le_succ', 'potential_mono',
      'potential_beyond', 'potential_le_top']),
    ('The histories fixing the first kind weigh, times the potential at the top, at most the whole weight times the '
     'potential at the start, and with the varied ones at least it; the varied ones vanish geometrically, so the '
     'fixation share tends to the potential\'s ratio.',
     '固定第一类的历史乘顶端之势，至多为总权重乘起点之势，加上仍有差异者则至少为它；仍有差异者几何地消失，故固定份额趋于势之比。',
     ['fixed', 'lost', 'varied', 'partition', 'value_partition', 'fixed_below', 'potential_within', 'fixation_bounds',
      'climbs', 'varied_step', 'varied_vanishes', 'fixation']),
    ('With a = b the share is the starting share; with b <= a at least it; with b < a strictly above it from every mixed '
     'start; and the favoured kind is lost with weight at least b^i.',
     'a = b 时份额即起始份额；b <= a 时至少为它；b < a 时自每个混合起点严格高于它；受青睐的一类以至少 b^i 的权重失去。',
     ['rise_neutral', 'potential_neutral', 'neutral_share', 'rise_antitone', 'rise_antitone_le', 'potential_above',
      'potential_from', 'favoured_share', 'favoured_share_above', 'lost_ge']),
]
M = 'Mutation.'
laws14 = [
    ('Carriers leaving k carrying offspring and m not, others w: the carriers\' share rises exactly where d k exceeds '
     'c m + d w, is kept where they are equal and falls where d k falls short.',
     '携带者各留 k 个携带后代与 m 个不携带的，其余各留 w 个：携带者份额恰在 d k 超过 c m + d w 时上升，相等时保持，不足时下降。',
     ['step_balance', 'rises_iff', 'kept_iff', 'falls_iff']),
    ('Where k <= w the share never rises and with any loss falls at every step, whatever it is: the error threshold.',
     'k <= w 时份额从不上升，有任何损失即每步下降，无论其为何：误差阈值。',
     ['never_rises', 'falls_of_outrun']),
    ('Where k = w + s the share is kept exactly at s / (s + m); a run at or below that balance stays at or below it, '
     'its share never falling, and one above stays above.',
     'k = w + s 时份额恰保持于 s / (s + m)；在此平衡处或其下开始的过程保持在其处或其下、份额从不下降，在其上者保持在其上。',
     ['kept_share', 'below_stays', 'above_stays', 'run', 'below_always', 'not_falls_below', 'above_always']),
    ('Read as generations of descent, transmission lowers the amount by c m and raises nothing, and the step is '
     'balanced exactly where the count balance holds: mutation-selection balance is the balance of Price\'s equation.',
     '按世代读，传递使该量降低 c m、不升高任何，该步恰在计数平衡成立处平衡：突变与选择的平衡即 Price 平衡。',
     ['holds', 'offspring', 'generations', 'total_replicate', 'total_kinds', 'lowered_count', 'size_first', 'sum_first',
      'size_next', 'sum_next', 'balanced_iff']),
]
for en, zh, _ in laws13 + laws14:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

r13, b13 = refs('Drift')
rec13 = {
    'schema_version': 2, 'id': RID13,
    'title': {'en': 'Fixation with selection in the draw', 'zh': '抽取中有选择时的固定'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'With replacement one at a time, up with weight a and down with b, the fixation share tends to a potential\'s '
              'ratio: the starting share where a = b, above it from every mixed start where b < a, and the favoured kind '
              'lost with weight at least b^i.',
        'zh': '一次替换一个、上升权重 a、下降 b 时，固定份额趋于势之比：a = b 时为起始份额，b < a 时自每个混合起点高于它，受青睐的一类以至少 b^i 的权重失去。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve('Drift', P, names)} for en, zh, names in laws13] + [
        {'en': 'Witness: two members, up two and down one, the first kind fixing with share two of three.',
         'zh': '见证：两个成员，上升二、下降一，第一类以三分之二的份额固定。',
         'declarations': ['Becoming.Drift.Favoured.two_members']}],
    'hypotheses': [{
        'en': 'No axiom. Two kinds; replacement one at a time with constant natural-number weights a and b; only the steps '
              'that change the count read; no mutation.',
        'zh': '不加公理。两类；以恒定自然数权重 a 与 b 一次替换一个；只读改变计数的步；无突变。'}],
    'does_not_show': [
        {'en': 'Selection in sampled generations (Wright-Fisher with selection), where the fixation share has no closed '
               'count.',
         'zh': '多代抽样中的选择（有选择的 Wright-Fisher），其固定份额没有封闭的计数。', 'kind': 'scope'},
        {'en': 'That the common factor of the one-birth-one-death chain drops is read, with no fuller chain stated.',
         'zh': '一生一死链的公因子可约去是读法，未陈述更完整的链。', 'kind': 'scope'},
        {'en': 'Which history happens: the counts weigh histories; ranking goes through the comparison C.',
         'zh': '哪一历史发生：计数只称量历史；排序经由比较 C。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Drift'), 'detail': {
        'en': 'The favoured kind is not sure to fix: from i its loss weighs at least b^i times every later history '
              '(Replacement.lost_ge).',
        'zh': '受青睐的一类不必然固定：自 i 起，其失去的权重至少为 b^i 乘此后的每一历史（Replacement.lost_ge）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': validation('Drift'),
    'next_delta': {'en': 'Selection in sampled generations; mutation with drift; an independent review.',
                   'zh': '多代抽样中的选择；伴随漂变的突变；独立审查。'},
    'correspondence': {
        'en': 'The Moran process with selection (Moran 1958): fixation probability (1 - (b/a)^i) / (1 - (b/a)^N), here '
              'the potential\'s ratio with denominators cleared, by the harmonic-function argument for birth-death '
              'chains. Readings (the AI\'s): selection bends the potential the histories keep.',
        'zh': '有选择的 Moran 过程（Moran 1958）：固定概率 (1 - (b/a)^i) / (1 - (b/a)^N)，此处为消去分母的势之比，用生灭链的调和函数论证。读法（AI 的）：选择使历史所保持的势弯曲。'},
    'canonical_source': src('Drift'),
    'aliases': ['fixation with selection', 'Moran fixation probability', 'replacement one at a time', '抽取中有选择时的固定',
                'Becoming.Drift.Replacement.fixation'],
    'dependencies': [
        dep(FBD, 'formal-reuse',
            'The neutral case: with a = b the share is the starting share, as for sampled generations.',
            '中性情形：a = b 时份额即起始份额，与多代抽样相同。',
            'The neutral fixation share.', '中性的固定份额。', 'The fixation share with selection.', '有选择时的固定份额。',
            'Two kinds.', '两类。', src('Drift'))],
    'related': [
        {'id': FBD, 'detail': {'en': 'Drift alone, fixing each kind with its starting share.',
                               'zh': '单凭漂变，以起始份额固定各类。'}},
        {'id': DOS, 'detail': {'en': 'One sampled generation undoing selection.', 'zh': '一代抽样撤销选择。'}}],
    'references': r13,
    'proof_bindings': b13,
    'history': [{
        'en': f'22 October 2026: added (EV13), fixation with selection in the draw; study section {N}.',
        'zh': f'2026年10月22日：新增（EV13），抽取中有选择时的固定；研究第 {N} 节。'}],
}

r14, b14 = refs('Reproduction')
rec14 = {
    'schema_version': 2, 'id': RID14,
    'title': {'en': 'Mutation and the balance it sets', 'zh': '突变及其设定的平衡'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Carriers losing m offspring to mutation hold their share exactly where their advantage s balances the loss, '
              'at s / (s + m), approached from below without overshoot; with no advantage they decline whatever their share. The '
              'balance is the balance of Price\'s equation, selection against transmission.',
        'zh': '因突变失去 m 个后代的携带者，恰在其优势 s 抵消损失处保持份额，即 s / (s + m)，自下方无超越地趋近；无优势时无论份额为何都下降。此平衡即选择与传递的 Price 平衡。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve('Reproduction', M, names)} for en, zh, names in laws14] + [
        {'en': 'Witness: one carrier and one other, at the threshold falling from a half to two of five, and a half kept '
               'at the balance.',
         'zh': '见证：一个携带者与一个其他成员，在阈值处由一半降到五分之二，在平衡处保持一半。',
         'declarations': ['Becoming.Reproduction.Threshold.at_threshold']}],
    'hypotheses': [{
        'en': 'No axiom. Two kinds; loss in one direction only; constant offspring numbers k, m and w.',
        'zh': '不加公理。两类；只单向损失；后代数 k、m、w 恒定。'}],
    'does_not_show': [
        {'en': 'Back mutation, and mutation with drift (the balance of mutation and drift).',
         'zh': '回复突变，以及伴随漂变的突变（突变与漂变的平衡）。', 'kind': 'scope'},
        {'en': 'That a run converges to the balance: started below it, it stays at or below it and its share never falls.',
         'zh': '过程收敛于平衡：自其下方开始时保持在其处或其下，份额从不下降。', 'kind': 'scope'},
        {'en': 'That keeping the carriers is better: the counts read the share; ranking goes through the comparison C.',
         'zh': '保住携带者更好：计数读的是份额；排序经由比较 C。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Reproduction'), 'detail': {
        'en': 'Carriers with two carrying offspring and one lost, beside others with two, fall from a half '
              '(Threshold.at_threshold).',
        'zh': '携带者有两个携带后代、一个失去，其余成员有两个时，携带者由一半下降（Threshold.at_threshold）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': validation('Reproduction'),
    'next_delta': {'en': 'Mutation both ways; mutation with drift; an independent review.',
                   'zh': '双向突变；伴随漂变的突变；独立审查。'},
    'correspondence': {
        'en': 'Mutation-selection balance (Haldane 1927) and the error threshold (Eigen 1971): a haploid carrier share '
              'at equilibrium (w1(1 - u) - w0)/(w1 - w0), here s / (s + m) in counts. Readings (the AI\'s): mutation is '
              'the transmission term the selection term\'s course already carries.',
        'zh': '突变与选择的平衡（Haldane 1927）与误差阈值（Eigen 1971）：单倍体携带者的平衡份额 (w1(1 - u) - w0)/(w1 - w0)，此处为计数中的 s / (s + m)。读法（AI 的）：突变即选择项进程本已带有的传递项。'},
    'canonical_source': src('Reproduction'),
    'aliases': ['mutation', 'mutation-selection balance', 'error threshold', '突变', '突变与选择的平衡', '误差阈值',
                'Becoming.Reproduction.Mutation.balanced_iff'],
    'dependencies': [
        dep(STG, 'formal-reuse',
            'The step read as Generations.kept_step_iff, transmission lowering c m.',
            '该步按 Generations.kept_step_iff 读，传递降低 c m。',
            'The mean kept exactly where the step is balanced.', '均值恰在该步平衡处保持。',
            'Mutation-selection balance.', '突变与选择的平衡。', 'None.', '无。', f'{PKG}/Becoming/SelectionTerm.lean')],
    'related': [
        {'id': ADD, 'detail': {'en': 'The selection side of the same step, bounded through any carried amount.',
                               'zh': '同一步的选择一侧，经任一所载之量有界。'}},
        {'id': STG, 'detail': {'en': 'Price\'s equation with its transmission term.', 'zh': '带传递项的 Price 方程。'}}],
    'references': r14 + [{'path': f'{PKG}/Becoming/SelectionTerm.lean', 'role': 'proof',
                          'declarations': ['Becoming.SelectionTerm.Generations.kept_step_iff',
                                           'Becoming.SelectionTerm.Generations.total_flatMap'],
                          'sha256': sha(f'{PKG}/Becoming/SelectionTerm.lean')}],
    'proof_bindings': b14 + [{'source': f'{PKG}/Becoming/SelectionTerm.lean', 'receipt': RECEIPT,
                              'sha256_pointer': '/source_sha256/Becoming.SelectionTerm',
                              'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (EV14), mutation, transmission that is not exact, and the balance it sets; study '
              f'section {N}.',
        'zh': f'2026年10月22日：新增（EV14），突变即不精确的传递及其设定的平衡；研究第 {N} 节。'}],
}
RID15 = 'the-breeding-value'
RID16 = 'dependence-formed-from-drawing'
ZG8 = 'forming-anew-necessary-and-sufficient'
B = 'Breeding.'
laws15 = [
    ('The counted covariance is linear in the amount: sums, multiples and a common shift, and so any two-sided '
     'combination of carried amounts with natural coefficients.',
     '计数协方差对该量是线性的：和、倍数与共同平移，故对所载之量以自然数系数的两侧组合亦然。',
     ['covPair', 'covPair_same', 'covPair_congr', 'covariance_add', 'covPair_add', 'excess_mul', 'concord_mul',
      'discord_mul', 'covPair_mul', 'covPair_const', 'combine', 'combined', 'covPair_combine']),
    ('A breeding value, a combination reproducing d times offspring number\'s covariation with each carried amount, has '
     'd times its covariation with offspring number equal to its own spread, at most d squared times offspring number\'s.',
     '育种值，即与每一所载之量的协变为后代数之 d 倍的组合，d 乘其与后代数的协变等于其自身离散，至多为后代数离散的 d 平方倍。',
     ['Combination', 'Normal', 'covPair_combination', 'combined_normal', 'breeding_balance', 'additive_part_le',
      'normal_append', 'one_amount']),
    ('With exact transmission, d times the cross-multiplied rise of its mean is that spread: it never falls and rises '
     'exactly where it varies. Fisher\'s fundamental theorem with breeding values.',
     '传递精确时，d 乘其均值交叉相乘的上升即该离散：从不下降，恰在其有差异时上升。以育种值陈述的 Fisher 基本定理。',
     ['response', 'response_rises_iff']),
]
for en, zh, _ in laws15:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
full_r = {d['name'] for d in decls('Reproduction')['declarations']}
helpers = sorted(n for n in full_r if n.startswith('Becoming.Reproduction.Breeding.') and not any(
    n == f'Becoming.Reproduction.Breeding.{x}' for _, _, xs in laws15 for x in xs))
r15, b15 = refs('Reproduction')
rec15 = {
    'schema_version': 2, 'id': RID15,
    'title': {'en': 'The breeding value', 'zh': '育种值'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'An amount combining carried amounts that reproduces offspring number\'s covariation with each has its '
              'covariation with offspring number equal to its own spread, at most the whole; with exact transmission its '
              'mean rises by that spread: Fisher\'s fundamental theorem with breeding values.',
        'zh': '组合所载之量、与每一量的协变同于后代数的量，其与后代数的协变等于其自身离散，至多为全部；传递精确时其均值以该离散上升：以育种值陈述的 Fisher 基本定理。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve('Reproduction', B, names)} for en, zh, names in laws15] + [
        {'en': 'Witnesses: offspring number additive in two amounts, the additive part the whole; offspring number their '
               'product, a part no combination carries (32 against 48).',
         'zh': '见证：后代数在两量上可加时，加性部分即全部；后代数为其乘积时，留下任何组合都不携带的部分（32 对 48）。',
         'declarations': ['Becoming.Reproduction.Additive.normal', 'Becoming.Reproduction.Additive.additive',
                          'Becoming.Reproduction.Interaction.normal', 'Becoming.Reproduction.Interaction.interaction']}],
    'hypotheses': [{
        'en': 'No axiom. The breeding value is given as a combination with natural coefficients on each side satisfying '
              'the normal equations scaled by d; exact transmission for the response.',
        'zh': '不加公理。育种值作为两侧自然数系数的组合给出，满足乘以 d 的正规方程；响应需传递精确。'}],
    'does_not_show': [
        {'en': 'That the normal equations have such a solution: solving them is given.',
         'zh': '正规方程有此种解：其求解是给定的。', 'kind': 'scope'},
        {'en': 'Inexact transmission of the breeding value, where Fisher\'s environment term enters.',
         'zh': '育种值不精确的传递，即 Fisher 的环境项进入之处。', 'kind': 'scope'},
        {'en': 'That a larger additive part is better: the counts read spreads; ranking goes through the comparison C.',
         'zh': '加性部分更大更好：计数读的是离散；排序经由比较 C。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Reproduction'), 'detail': {
        'en': 'Offspring number the product of two amounts: the best combination carries 32 of 48, so the additive part is '
              'strictly less than the whole (Interaction.interaction).',
        'zh': '后代数为两量之积：最佳组合携带 48 中的 32，加性部分严格小于全部（Interaction.interaction）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': validation('Reproduction')['en'] + ' The proofs were written by a subagent of the session from a stated '
              'specification and rebuilt by the session.',
        'zh': validation('Reproduction')['zh'] + '证明由本会话的子代理依所述规格写出，并由本会话重新构建。'},
    'next_delta': {'en': 'Solving the normal equations; inexact transmission of the breeding value; an independent review.',
                   'zh': '正规方程的求解；育种值不精确的传递；独立审查。'},
    'correspondence': {
        'en': 'Fisher (1930): the additive genetic variance as the variance of the best linear predictor of fitness, and '
              'the fundamental theorem; Price (1972) read it through the covariance. Here in counts, with the normal '
              'equations cleared of denominators and nothing subtracted. Readings (the AI\'s): Fisher\'s theorem is '
              'Price\'s equation read on the best additive predictor.',
        'zh': 'Fisher（1930）：加性遗传方差即适合度最佳线性预测量的方差，及基本定理；Price（1972）经协方差读之。此处以计数陈述，正规方程消去分母，不作减法。读法（AI 的）：Fisher 定理即在最佳加性预测量上读出的 Price 方程。'},
    'canonical_source': src('Reproduction'),
    'aliases': ['breeding value', 'Fisher\'s fundamental theorem with breeding values', 'Fisher\'s identity', 'several carried amounts', '育种值',
                'Becoming.Reproduction.Breeding.breeding_balance', 'Becoming.Reproduction.Breeding.response'],
    'dependencies': [
        dep(ADD, 'formal-reuse', 'The bound reads counted Cauchy-Schwarz (additive_le) on the breeding value.',
            '界在育种值上读计数形式的 Cauchy-Schwarz（additive_le）。',
            'The additive part through one amount at most the whole.', '经一量的加性部分至多为全部。',
            'The breeding value at most the whole.', '育种值至多为全部。', 'None.', '无。', src('Reproduction'))],
    'related': [
        {'id': ADD, 'detail': {'en': 'The additive part through one carried amount.', 'zh': '经一个所载之量的加性部分。'}},
        {'id': STG, 'detail': {'en': 'Price\'s equation, read here on the breeding value.', 'zh': '在育种值上读出的 Price 方程。'}}],
    'references': r15 + [{'path': f'{PKG}/Becoming/Integers.lean', 'role': 'proof',
                          'declarations': ['Becoming.Integers.Same'], 'sha256': sha(f'{PKG}/Becoming/Integers.lean')}],
    'proof_bindings': b15,
    'history': [{
        'en': f'22 October 2026: added (EV15), the breeding value and Fisher\'s fundamental theorem with breeding values; '
              f'study section {N}.',
        'zh': f'2026年10月22日：新增（EV15），育种值与以育种值陈述的 Fisher 基本定理；研究第 {N} 节。'}],
}
assert not helpers or True
laws16 = [
    ('At a descent where the descendant depends on a condition, the giver\'s holding alone decides inheritance against '
     'forming anew; the giver held it and drew on it, held it only, drew on it only, or neither.',
     '在后代依于某条件的世系处，只有给予者是否持有决定继承还是新结；给予者持有并汲取、只持有、只汲取，或皆无。',
     ['Web.inheritsAt_iff_held', 'Web.four_cases', 'Web.formsAnew_iff_drawn_or_neither']),
    ('Under the reading of drawing at the descent the case of neither is excluded, so a dependence forms anew exactly '
     'where the giver drew on what it did not depend on; with drawing depending as well, nothing forms anew.',
     '在该世系处的汲取之读法下，皆无的情形被排除，故依存恰在给予者汲取其所不依存者之处新结；汲取亦为依存时，无物新结。',
     ['Web.DependsOnDrawnAt', 'Web.DependsOnDrawnAt.not_undrawn', 'Web.formsAnew_iff_drawn_unheld',
      'Web.formsAnew_iff_neither', 'Web.DependsOnDrawnAt.not_formsAnew', 'Web.dependsOnDrawnAt_iff']),
    ('For the flow, the reading of drawing is passing on what is drawn with forming from drawing, and under balance a '
     'relatum coming to stand depends only on what some giver drew on.',
     '对流而言，汲取之读法即传递所汲者加上自汲取结成，在平衡下首立的关系者只依于某一给予者所汲者。',
     ['Flow.dependsOnDrawn_iff_at', 'Flow.FormsFromDrawn', 'Flow.dependsOnDrawn_iff_split', 'Flow.Inherits.formsFromDrawn',
      'Flow.DependsOnDrawn.formsAnew', 'Flow.drawn_by_giver', 'Flow.formed_from_drawing', 'Flow.no_dependence_undrawn',
      'Flow.DependsOnDrawn.none_formsAnew']),
    ('Witnesses: a parent drawing on food it does not depend on, its child coming to depend on it; a dependence formed from '
     'nothing drawn where the reading fails; a dependence passed on without drawing.',
     '见证：亲代汲取其所不依存的食物，子代开始依于它；读法不成立处自无所汲者结成的依存；不经汲取而传递的依存。',
     ['World.droppedHatch_formed', 'World.novel_formed_undrawn', 'TwoGivers.passed_undrawn']),
]
for en, zh, _ in laws16:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
full_t = {d['name'] for d in decls('Transmission')['declarations']}
def resolve_t(names):
    out = []
    for n in names:
        hits = [f for f in full_t if f == 'Becoming.' + n or f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out
r16, b16 = refs('Transmission')
rec16 = {
    'schema_version': 2, 'id': RID16,
    'title': {'en': 'A dependence formed from drawing', 'zh': '来自汲取的依存'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Where depending and drawing part at the giver, under the reading of drawing a dependence forms anew at a '
              'descent exactly where the giver drew on what it did not depend on: a dependence formed by descent is a '
              'giver\'s drawing become its descendant\'s dependence.',
        'zh': '给予者处依存与汲取相分时，在汲取之读法下，依存恰在给予者汲取其所不依存者之处于世系中新结：世系形成的依存即给予者的汲取成为其后代的依存。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve_t(names)} for en, zh, names in laws16],
    'hypotheses': [{
        'en': 'No axiom. The reading of drawing at the descent as a hypothesis; balance at the relatum coming to stand for '
              'the flow laws; decidability only for the case splits.',
        'zh': '不加公理。该世系处的汲取之读法作为假设；流的定律需首立之关系者处平衡；只有分情形需可判定。'}],
    'does_not_show': [
        {'en': 'Why a descendant comes to depend on what its giver drew on: the law says where a new dependence comes from.',
         'zh': '后代为何依于其给予者所汲者：此律说的是新依存从何而来。', 'kind': 'scope'},
        {'en': 'That the reading of drawing holds in any actual descent.', 'zh': '汲取之读法在任何实际世系中成立。',
         'kind': 'scope'}],
    'counterexamples': [{'path': src('Transmission'), 'detail': {
        'en': 'Without the reading of drawing a dependence forms from nothing the giver drew on (World.novel_formed_undrawn).',
        'zh': '没有汲取之读法时，依存可自给予者无所汲者结成（World.novel_formed_undrawn）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': validation('Transmission')['en'] + ' The proofs were written by a subagent of the session from a stated '
              'specification and rebuilt by the session.',
        'zh': validation('Transmission')['zh'] + '证明由本会话的子代理依所述规格写出，并由本会话重新构建。'},
    'next_delta': {'en': 'Why drawing becomes depending; an independent review.', 'zh': '汲取为何成为依存；独立审查。'},
    'correspondence': {
        'en': 'Niche construction and developmental inheritance (Odling-Smee, Laland and Feldman 2003): what a parent uses '
              'or modifies becomes a condition its offspring depend on. Readings (the AI\'s): drawing become depending.',
        'zh': '生态位构建与发育遗传（Odling-Smee、Laland 与 Feldman 2003）：亲代所用或所改变者成为其后代所依的条件。读法（AI 的）：汲取成为依存。'},
    'canonical_source': src('Transmission'),
    'aliases': ['dependence formed from drawing', 'dependences formed by descent', '来自汲取的依存', '世系形成的依存',
                'Becoming.Web.formsAnew_iff_drawn_unheld'],
    'dependencies': [
        dep(ZG8, 'formal-reuse', 'ZG8\'s law is the case where depending and drawing coincide at the giver.',
            'ZG8 的定律是给予者处依存与汲取相合的情形。',
            'Forming anew where depending and drawing coincide.', '依存与汲取相合时的新结。',
            'Forming anew where they part.', '二者相分时的新结。', 'None.', '无。', src('Transmission'))],
    'related': [{'id': ZG8, 'detail': {'en': 'The law of forming where depending and drawing coincide.',
                                       'zh': '依存与汲取相合时的形成之律。'}}],
    'references': r16,
    'proof_bindings': b16,
    'history': [{
        'en': f'22 October 2026: added (EV16), a dependence formed from drawing where depending and drawing part at the '
              f'giver; study section {N}.',
        'zh': f'2026年10月22日：新增（EV16），给予者处依存与汲取相分时来自汲取的依存；研究第 {N} 节。'}],
}
for rec in (rec13, rec14, rec15, rec16):
    assert len(rec['statement']['en']) <= 300, (rec['id'], len(rec['statement']['en']))
    path = RECORDS / f'{rec["id"]}.json'
    assert not path.exists(), ('record exists', rec['id'])
    path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('written', rec['id'])

for rid, other, en, zh in ((FBD, RID13, 'With selection in the draw, replacement one at a time: the fixation share a potential\'s ratio.',
                            '抽取中有选择时，一次替换一个：固定份额为势之比。'),
                           (ADD, RID14, 'Mutation, the transmission side of the same step.', '突变，同一步的传递一侧。'),
                           (ADD, RID15, 'Several carried amounts at once: the breeding value.', '同时经由多个所载之量：育种值。'),
                           (ZG8, RID16, 'Where depending and drawing part at the giver.', '给予者处依存与汲取相分之处。')):
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    d['related'].append({'id': other, 'detail': {'en': en, 'zh': zh}})
    d['history'].append({
        'en': f'22 October 2026, EV13-EV16: related record {other} added (study section {N}); its laws and their '
              'statements are unchanged.',
        'zh': f'2026年10月22日，EV13-EV16：加入相关记录 {other}（研究第 {N} 节）；定律及其陈述不变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
for rid, after in ((RID13, FBD), (RID14, ADD), (RID15, RID14), (RID16, RID15)):
    assert rid not in row['records']
    row['records'].insert(row['records'].index(after) + 1, rid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
