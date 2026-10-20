#!/usr/bin/env python3
"""Write EV8's record and note it in the records it continues (typicality-by-counting, selection-term-over-generations,
selection-among-groups-by-ending), and give the coverage file's evolution row its record and central law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.Drift (a short name must
match exactly one declaration by suffix), and the receipt must bind the module's current bytes."""
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
HEAD = f'## {N}. Drift: offspring sampled rather than listed (EV8)'
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


def resolve(names):
    full = [d['name'] for d in decls('Drift')['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.Drift.' + n or f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'drift-offspring-sampled'
TYP = 'typicality-by-counting'
STG = 'selection-term-over-generations'
EV5 = 'selection-among-groups-by-ending'
laws = [
    ('Sampling is unbiased: drawn n times from p listed offspring of one kind and q of another, each sampling weighed by '
     'the ways of drawing it, p + q times the weighted count of the first kind is n p (p + q)^n, so on average the '
     'sampled share is the listed share.',
     '抽样无偏：从一类 p 个、另一类 q 个的所列后代中抽取 n 次，每种抽样以抽出它的方式数为权重，p + q 乘第一类的加权计数等于 n p (p + q)^n，故平均而言抽样份额即所列份额。',
     ['step_ones', 'step_zeros', 'weighted_ones_step', 'weighted_zeros_step', 'step_expected', 'expected_ones',
      'expected_zeros', 'Generations.expected_sampled']),
    ('Drift can undo selection with a weight falling as 1/n: where (p + q) h + g = N p, the samplings with at most h/N '
     'of the first kind weigh, times n^2 g^2, at most N^2 n p q (p + q)^n (each far back by the gap, summed against '
     'the spread).',
     '漂变能撤销选择，其权重按 1/n 下降：(p + q) h + g = N p 时，第一类至多占 h/N 的抽样之权重乘以 n^2 g^2 至多为 N^2 n p q (p + q)^n（每种都因差距而远离，对离散度求和）。',
     ['fallsBack', 'gap_le', 'square_mul', 'far_back', 'falls_back_le', 'falls_back']),
    ('Never ruled out: the samplings with no draw of the first kind weigh exactly q^n, and each falls back, so the '
     'samplings undoing the step weigh at least q^n at every sample size.',
     '从不被排除：没有抽到第一类的抽样之权重恰为 q^n，且每种都退回，故撤销这一步的抽样在任何样本大小下权重至少为 q^n。',
     ['lost', 'lost_true', 'lost_false', 'lost_weight', 'lost_le', 'falls_back_ge']),
    ('Over listed generations a step raising the mean of an amount held or not has a positive gap with that bound; on '
     'the base, where the step is ending among groups (the groups with less of the amount not active), both bounds '
     'hold.',
     '在所列世代上，使持有与否之量的均值上升的一步有正的差距并满足该界；在流上，这一步是组间终止（持有较少之组不活跃）时，两个界都成立。',
     ['Generations.raised_falls_back', 'Flow.ended_falls_back']),
    ('Witness: one draw from three and two after a step raising the share from a half; the draw of the second kind falls '
     'back, weighing two of the five ways.',
     '见证：一步把份额从一半升高后，从三与二中抽一次；抽到第二类即退回，在五种方式中权重为二。',
     ['OneDraw.falls_back']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Drift: offspring sampled rather than listed', 'zh': '漂变：从后代中抽样而非列出'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'A next generation sampled from listed offspring keeps the listed share on average with an exact spread; '
              'the samplings undoing a step\'s selection, ending among groups included, weigh at most a share falling '
              'as 1/n and at least q^n.',
        'zh': '从所列后代中抽样的下一代平均保持所列份额，离散度精确；撤销一步之选择（包括组间终止）的抽样之权重至多为随 1/n 下降的份额，至少为 q^n。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Two kinds; n draws with replacement from the listed offspring, each listed offspring drawn alike '
              '(the Wright-Fisher sampling), counted by Typicality\'s courses; natural-number counts; the gap equation '
              '(p + q) h + g = N p; over listed generations the next generation\'s listed size its holders with q others, '
              'and Raises; on the base the hypotheses of GroupEnding.Flow.raises_of_inactive.',
        'zh': '不加公理。两类；从所列后代中有放回地抽取 n 次，每个所列后代被抽到的方式相同（Wright-Fisher 抽样），以 Typicality 的进程计数；自然数计数；差距等式 (p + q) h + g = N p；所列世代上下一代的所列大小为持有者加 q 个其他，以及 Raises；在流上为 GroupEnding.Flow.raises_of_inactive 的假设。'}],
    'does_not_show': [
        {'en': 'Which sampling happens: counting weighs the samplings and supposes no chance of the unfolding.',
         'zh': '哪一种抽样发生：计数为各抽样加权，不设想展开中的机会。', 'kind': 'scope'},
        {'en': 'Fixation and loss over many sampled generations (a course of samplings each drawn from the last), drift '
               'and selection in one draw, more than two kinds, and mutation are not stated.',
         'zh': '多代抽样中的固定与丢失（每次从上一次抽出的样本中抽取的进程）、同一次抽取中的漂变与选择、多于两类，以及突变，未陈述。', 'kind': 'scope'},
        {'en': 'An exponential bound on falling back: the bound is Chebyshev\'s, falling as 1/n; Typicality.concentrated '
               'gives the exponential one for the deviation, its form for falling back is not stated.',
         'zh': '退回的指数界：本界是 Chebyshev 型，按 1/n 下降；Typicality.concentrated 给出偏差的指数界，其退回形式未陈述。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Drift'), 'detail': {
        'en': 'A raised share is not kept by every sampling: in OneDraw one draw of the second kind falls back below the '
              'step\'s start, weighing two of the five ways (OneDraw.falls_back), the lower bound q^n attained.',
        'zh': '上升的份额并非每种抽样都保持：OneDraw 中抽到第二类的一次退回到这一步的起点以下，在五种方式中权重为二（OneDraw.falls_back），恰达下界 q^n。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.Drift has an empty axiom report; the checker verifies core purity. Built and reviewed in one '
              f'session, with no separate reviewer; author review in study section {N}; not independently reviewed by a '
              'person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Drift 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Fixation and loss over many sampled generations; drift with selection in one draw; mutation (transmission '
              'not exact); an independent review.',
        'zh': '多代抽样中的固定与丢失；同一次抽取中的漂变与选择；突变（不精确的传递）；独立审查。'},
    'correspondence': {
        'en': 'Wright-Fisher sampling (Fisher 1930; Wright 1931): binomial sampling of a two-allele population, unbiased '
              'with variance p q/((p + q)^2 n) of the share; the bound is Chebyshev\'s inequality for the sampled share '
              'falling back by delta = p/(p + q) - h/N, p q/((p + q)^2 delta^2 n). Selection is effective where the '
              'population size times the selection differential is large (Kimura): here n delta^2 against p q/(p + q)^2. '
              'Readings (the AI\'s): a rise by ending among groups is subject to the same drift as any other.',
        'zh': 'Wright-Fisher 抽样（Fisher 1930；Wright 1931）：两等位基因群体的二项抽样，无偏，份额方差 p q/((p + q)^2 n)；本界是抽样份额退回 delta = p/(p + q) - h/N 的 Chebyshev 不等式，p q/((p + q)^2 delta^2 n)。种群大小乘选择差大时选择有效（Kimura）：此处为 n delta^2 对 p q/(p + q)^2。读法（AI 的）：组间终止带来的上升与其他上升一样受漂变影响。'},
    'canonical_source': src('Drift'),
    'aliases': ['drift', 'genetic drift', 'Wright-Fisher sampling', '漂变', 'offspring sampled rather than listed',
                'Becoming.Drift.falls_back', 'Becoming.Drift.expected_ones', 'Becoming.Drift.falls_back_ge',
                'Becoming.Drift.Flow.ended_falls_back'],
    'dependencies': [
        dep(TYP, 'formal-reuse',
            'Samplings are Becoming.Typicality\'s courses weighed by Typicality.weight; the bound sums against '
            'Typicality.spread, and lost_weight and the first moment go through Typicality.total_extend.',
            '抽样即 Becoming.Typicality 以 Typicality.weight 加权的进程；界对 Typicality.spread 求和，lost_weight 与一阶矩经由 Typicality.total_extend。',
            'The courses of n steps, their weights and the exact spread.', 'n 步的进程、其权重与精确的离散度。',
            'The first moment and the bound on falling back.', '一阶矩与退回之界。',
            'Natural weights p and q.', '自然数权重 p 与 q。', src('Typicality')),
        dep(STG, 'formal-reuse',
            'A step raising the mean (Generations.Raises) is read through rises_step_iff as the gap equation.',
            '使均值上升的一步（Generations.Raises）经由 rises_step_iff 读作差距等式。',
            'Raises t as size (t+1) times sum t below size t times sum (t+1).', 'Raises t 即 size (t+1) 乘 sum t 小于 size t 乘 sum (t+1)。',
            'A positive gap for the bound.', '界所需的正差距。',
            'The amount read as held or not.', '该量读作持有或不持有。', src('SelectionTerm')),
        dep(EV5, 'formal-reuse',
            'GroupEnding.Flow.raises_of_inactive supplies the rise on the base.',
            'GroupEnding.Flow.raises_of_inactive 在流上给出上升。',
            'Ending among groups raises the mean.', '组间终止使均值上升。',
            'The rise a sampled generation can undo.', '抽样的一代可能撤销的上升。',
            'Descent, exact transmission, groups of equal size uniform in the amount, the groups with less not active.',
            '世系、精确传递、在该量上均匀的等大小之组、持有较少之组不活跃。', src('GroupEnding'))],
    'related': [
        {'id': TYP, 'detail': {'en': 'Its courses and spread, read as samplings of a next generation.',
                               'zh': '其进程与离散度，读作下一代的抽样。'}},
        {'id': STG, 'detail': {'en': 'The step of selection a sampled generation can undo.',
                               'zh': '抽样的一代可能撤销的选择之步。'}},
        {'id': EV5, 'detail': {'en': 'A rise by ending among groups, subject to drift.',
                               'zh': '组间终止带来的上升，受漂变影响。'}}],
    'references': [{'path': src('Drift'), 'role': 'proof',
                    'declarations': sorted(d['name'] for d in decls('Drift')['declarations']), 'sha256': sha(src('Drift'))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src('Drift'), 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Drift',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'20 October 2026: added (EV8), one generation of offspring sampled rather than listed: unbiased, the spread '
              f'exact, falling back bounded above and below, over listed generations and on the base; study section {N}.',
        'zh': f'2026年10月20日：新增（EV8），从后代中抽样而非列出的一代：无偏、离散度精确、退回有上下界，在所列世代上与流上；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

notes = {
    TYP: ('Its courses read as samplings of a next generation: drift (Becoming.Drift).',
          '其进程读作下一代的抽样：漂变（Becoming.Drift）。',
          'Becoming.Drift reads its courses as samplings of a next generation and sums its spread into a bound on undoing '
          'selection',
          'Becoming.Drift 把其进程读作下一代的抽样，并对其离散度求和得到撤销选择的界'),
    STG: ('Drift: a sampled next generation undoes a step that Raises with a bounded weight.',
          '漂变：抽样的下一代以有界的权重撤销一步 Raises。',
          'Becoming.Drift bounds the samplings undoing a step that Raises',
          'Becoming.Drift 为撤销一步 Raises 的抽样给出界'),
    EV5: ('A rise by ending among groups, undone by a sampled generation with a bounded weight (Drift.Flow.ended_falls_back).',
          '组间终止带来的上升，被抽样的一代以有界的权重撤销（Drift.Flow.ended_falls_back）。',
          'Becoming.Drift states that a rise by ending among groups (raises_of_inactive) is undone by a sampled generation '
          'with a weight between q^n and a share falling as 1/n',
          'Becoming.Drift 陈述组间终止带来的上升（raises_of_inactive）被抽样的一代撤销，其权重介于 q^n 与随 1/n 下降的份额之间'),
}
for rid, (ren, rzh, hen, hzh) in notes.items():
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    d['related'].append({'id': RID, 'detail': {'en': ren, 'zh': rzh}})
    d['history'].append({'en': f'20 October 2026, EV8: {hen} (record {RID}, study section {N}); this record\'s laws and '
                               'their statements are unchanged.',
                         'zh': f'2026年10月20日，EV8：{hzh}（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

# Coverage: the evolution row reads the new record; its central law, falls_back, has the base instance.
cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index('selection-within-and-among-groups-of-any-sizes') + 1, RID)
row['declarations'].append('Becoming.Drift.falls_back')
row['instances']['Becoming.Drift.falls_back'] = ['Becoming.Drift.Flow.ended_falls_back']
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
