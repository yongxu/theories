#!/usr/bin/env python3
"""Write EV9's record, note it in the record it continues (drift-offspring-sampled), and give the coverage file's
evolution row its record:
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
HEAD = f'## {N}. Fixation by drift (EV9)'
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
        hits = [f for f in full if f == 'Becoming.Drift.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'fixation-by-drift'
EV8 = 'drift-offspring-sampled'
TYP = 'typicality-by-counting'
USED = {'Typicality': ['Becoming.Typicality.courses', 'Becoming.Typicality.weight', 'Becoming.Typicality.total_extend',
                       'Becoming.Typicality.total_weight', 'Becoming.Typicality.total_congr_mem']}
laws = [
    ('Sampled generations: a population of N, h of the first kind, each next generation N draws from the last weighted '
     'by its counts; over the histories of k generations, each weighed by its ways of drawing, the total of a reading '
     'of the final count is linear and monotone in the reading, and the histories weigh (N^N)^k together.',
     '抽样的世代：N 个成员、第一类 h 个，每个下一代从上一代按其计数加权抽取 N 次；在 k 代的各历史上（各以其抽法数为权重），最终计数之读数的总和对读数线性且单调，各历史共重 (N^N)^k。',
     ['sampled', 'sampled_succ', 'ones_le', 'sampled_le', 'sampled_add', 'sampled_mul', 'sampled_one']),
    ('No direction without selection: summed over the histories the final count is h (N^N)^k, its start times the '
     'whole weight.',
     '无选择即无方向：各历史的最终计数之和为 h (N^N)^k，即起点乘总权重。',
     ['weighted_ones', 'sampled_count']),
    ('The ends absorb: from none or from all of the first kind every history stays there.',
     '两端吸收：从第一类为零或为全部出发，每个历史都停在那里。',
     ['from_none', 'from_all', 'sub_self_zero', 'sampled_none', 'sampled_all']),
    ('Drift ends variation: from a varied population the samplings fixing and losing the first kind weigh at least one '
     'each, so the histories still varied after k generations weigh at most r^k with r + 2 = N^N.',
     '漂变终结差异：从有差异的种群出发，固定与失去第一类的抽样各至少重一，故 k 代后仍有差异的历史之权重至多为 r^k，其中 r + 2 = N^N。',
     ['whole', 'whole_true', 'whole_false', 'whole_weight', 'varied', 'varied_zero', 'varied_self', 'varied_step',
      'one_le_pow', 'varied_vanishes']),
    ('Fixation: N times the histories fixing the first kind is at most h (N^N)^k and with N r^k at least it, so the '
     'fixing share tends to h/N, the neutral fixation probability.',
     '固定：N 乘固定第一类的历史至多为 h (N^N)^k，加上 N r^k 则至少为它，故固定的份额趋于 h/N，即中性固定概率。',
     ['fixed', 'count_le', 'fixed_le', 'fixation']),
    ('Witness: two members, one of each kind, one generation: of the four histories one fixes, one loses and two stay '
     'varied.',
     '见证：两个成员、各属一类、一代：四个历史中一个固定、一个失去、两个仍有差异。',
     ['TwoMembers.one_generation']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Fixation by drift', 'zh': '漂变导致的固定'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Sampled generation after generation with no selection, a population keeps each count on average, its '
              'still-varied histories vanish geometrically, and each kind is fixed with exactly its starting share in '
              'the limit.',
        'zh': '无选择地逐代抽样，种群平均保持每个计数，仍有差异的历史按几何速率消失，各类在极限中恰以其起始份额被固定。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Two kinds; a constant population of N; each generation N draws with replacement from the last, '
              'weighted by its counts, with no selection or mutation in the draw (the neutral Wright-Fisher course); '
              'natural-number counts; discrete generations; for the rate, r + 2 = N^N (N at least two).',
        'zh': '不加公理。两类；种群大小 N 不变；每代从上一代按其计数有放回地抽取 N 次，抽取中无选择与突变（中性 Wright-Fisher 进程）；自然数计数；离散世代；速率需 r + 2 = N^N（N 至少为二）。'}],
    'does_not_show': [
        {'en': 'Which history happens: counting weighs histories and supposes no chance of the unfolding.',
         'zh': '哪一个历史发生：计数为各历史加权，不设想展开中的机会。', 'kind': 'scope'},
        {'en': 'The time to fixation: the rate r/N^N is crude (it uses only the samplings of one kind alone), so the time '
               'is bounded, not stated.',
         'zh': '固定所需的时间：速率 r/N^N 很粗（只用了全为一类的抽样），故时间只有上界，未陈述。', 'kind': 'non-implication'},
        {'en': 'Selection or mutation in the draw, more than two kinds, and a changing population size are not stated; '
               'with selection the fixing share is not the starting share.',
         'zh': '抽取中的选择或突变、多于两类、种群大小变化，未陈述；有选择时固定份额不等于起始份额。', 'kind': 'scope'}],
    'counterexamples': [{'path': src('Drift'), 'detail': {
        'en': 'Drift does not keep variation: in TwoMembers, from one of each kind, half the histories after one '
              'generation have lost or fixed the first kind (TwoMembers.one_generation).',
        'zh': '漂变不保持差异：TwoMembers 中，从各类一个出发，一代后一半历史已失去或固定第一类（TwoMembers.one_generation）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.Drift has an empty axiom report; the checker verifies core purity. Built and reviewed in one '
              f'session, with no separate reviewer; author review in study section {N}; not independently reviewed by a '
              'person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Drift 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Drift with selection in one draw (the fixing share with selection); mutation (transmission not exact); the '
              'time to fixation; an independent review.',
        'zh': '同一次抽取中的漂变与选择（有选择时的固定份额）；突变（不精确的传递）；固定所需时间；独立审查。'},
    'correspondence': {
        'en': 'The neutral fixation probability of the Wright-Fisher model (Kimura 1962; Moran 1958 for the overlapping '
              'case): the allele count is a martingale, the ends absorb, so the probability of fixation is the starting '
              'frequency; heterozygosity decays geometrically (Wright 1931). Readings (the AI\'s): drift gives no direction '
              'and ends variation, as ending among groups uses up the differences it acts on; variation is kept only '
              'where something renews it.',
        'zh': 'Wright-Fisher 模型的中性固定概率（Kimura 1962；重叠世代见 Moran 1958）：等位基因计数是鞅，两端吸收，故固定概率等于起始频率；杂合度按几何速率衰减（Wright 1931）。读法（AI 的）：漂变不给方向而终结差异，正如组间终止耗尽它所作用的差异；差异只在有所更新之处得以保持。'},
    'canonical_source': src('Drift'),
    'aliases': ['fixation by drift', 'neutral fixation probability', '漂变导致的固定', 'genetic drift over generations',
                'Becoming.Drift.fixation', 'Becoming.Drift.sampled_count', 'Becoming.Drift.varied_vanishes'],
    'dependencies': [
        dep(EV8, 'formal-reuse',
            'Each generation is Becoming.Drift\'s one generation of sampling: its first moment (expected_ones) gives the '
            'count kept, and its lost_weight one end of the samplings of one kind alone.',
            '每一代都是 Becoming.Drift 的一代抽样：其一阶矩（expected_ones）给出计数保持，其 lost_weight 给出全为一类之抽样的一端。',
            'One generation sampled from listed offspring, unbiased.', '从所列后代中抽样的一代，无偏。',
            'The count kept over many generations, and the varied histories bounded.', '多代中计数保持，以及仍有差异的历史之界。',
            'Two kinds, draws with replacement.', '两类，有放回地抽取。', src('Drift')),
        dep(TYP, 'formal-reuse',
            'The histories are built from Becoming.Typicality\'s courses and weights.',
            '各历史由 Becoming.Typicality 的进程与权重构成。',
            'The courses of n steps and their total weight.', 'n 步的进程及其总权重。',
            'The histories of k sampled generations.', 'k 代抽样的各历史。',
            'Natural weights.', '自然数权重。', src('Typicality'))],
    'related': [
        {'id': EV8, 'detail': {'en': 'One generation of sampling, here iterated.', 'zh': '一代抽样，此处迭代。'}},
        {'id': 'selection-within-and-among-groups-of-any-sizes',
         'detail': {'en': 'Ending among groups uses up the differences it acts on; drift uses up variation too.',
                    'zh': '组间终止耗尽其所作用的差异；漂变同样耗尽差异。'}}],
    'references': [{'path': src('Drift'), 'role': 'proof',
                    'declarations': sorted(d['name'] for d in decls('Drift')['declarations']), 'sha256': sha(src('Drift'))},
                  ] + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                       for mod, names in USED.items()] + [
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in ['Drift'] + list(USED)],
    'history': [{
        'en': f'20 October 2026: added (EV9), fixation by drift over many sampled generations: the count kept, the ends '
              f'absorbing, variation ending geometrically, the fixing share h/N; study section {N}.',
        'zh': f'2026年10月20日：新增（EV9），多代抽样中漂变导致的固定：计数保持、两端吸收、差异按几何速率终结、固定份额 h/N；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
for mod, names in USED.items():
    have = {d['name'] for d in decls(mod)['declarations']}
    assert set(names) <= have, (mod, set(names) - have)
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

p = RECORDS / f'{EV8}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'Many generations of sampling: the count kept, variation ending, each kind '
                                                 'fixed with its starting share.',
                                           'zh': '多代抽样：计数保持、差异终结、各类以其起始份额被固定。'}})
nd = d['next_delta']
assert nd['en'].startswith('Fixation and loss over many sampled generations; '), nd
nd['en'] = nd['en'].replace('Fixation and loss over many sampled generations; ', '')
nd['zh'] = nd['zh'].replace('多代抽样中的固定与丢失；', '')
d['history'].append({
    'en': f'20 October 2026, EV9: Becoming.Drift gains many sampled generations (record {RID}, study section {N}): fixation '
          'and loss over many generations, this record\'s first open item, is stated there in the neutral case; this '
          'record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月20日，EV9：Becoming.Drift 增加多代抽样（记录 {RID}，研究第 {N} 节）：本记录的第一个开放项——多代中的固定与丢失——在那里以中性情形陈述；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', EV8)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(EV8) + 1, RID)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
