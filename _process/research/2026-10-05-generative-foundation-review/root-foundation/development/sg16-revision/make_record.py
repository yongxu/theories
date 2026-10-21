#!/usr/bin/env python3
"""Write SG16's record revision-comes-to-drawing-everything (a theorem) and note it in SG14's record, whose open item it
answers:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
REVIEW = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-SIGNIFICANCE-REVIEW.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. How drawers in turn come to a mutual best response (SG16)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)
MOD = 'Optimum'
SRC = f'{PKG}/Becoming/{MOD}.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


m = next(m for m in core['modules'] if m['module'] == f'Becoming.{MOD}')
assert core['source_sha256'][f'Becoming.{MOD}'] == sha(SRC), 'receipt does not bind'
assert not any(m['axiom_dependencies'].values())
full = [d['name'] for d in m['declarations']]


def resolve(names):
    out = []
    for n in names:
        assert full.count('Becoming.' + n) == 1, n
        out.append('Becoming.' + n)
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']
RID = 'revision-comes-to-drawing-everything'
SG14 = 'drawers-in-turn-draw-everything'
laws = [
    ('A profile revises another where each new rule, at every step from every level, is a best response to the old '
     'profile; the first of finitely many amounts drawing the most always gives one, so revisions exist from any profile.',
     '一个组合修订另一个，若每条新规则在每步、从每个水平都是对旧组合的最优回应；有限多个量中抽取最多的第一个总给出一个，故修订自任一组合都存在。',
     ['Optimum.InTurn.Revises', 'Optimum.InTurn.bestUpTo', 'Optimum.InTurn.bestUpTo_le', 'Optimum.InTurn.bestUpTo_max',
      'Optimum.InTurn.reviseFirst', 'Optimum.InTurn.reviseSecond', 'Optimum.InTurn.revise_revises',
      'Optimum.InTurn.revised']),
    ('Along every sequence of revisions over N steps, from any profile, both leave nothing at every step of the last k '
     'from round 2 k on; so from round 2 N on the profile draws everything and the base stands from the first step at '
     'what stands at nothing.',
     '沿 N 步上的每个修订序列，自任一组合出发，自第 2 k 轮起两者在最后 k 步每步不留；故自第 2 N 轮起组合全部抽取，自第一步起基础立于零处所立者。',
     ['Optimum.InTurn.levels_of_zero', 'Optimum.InTurn.secondDrawn_of_zero', 'Optimum.InTurn.revisions_end',
      'Optimum.InTurn.revised_draw_all']),
    ('On a web, from round 2 N on, a dependence above what stands at nothing, met at the start, is broken at the first step.',
     '在网上，自第 2 N 轮起，起始时被满足、高于零处所立者的依存在第一步被打破。',
     ['Web.revised_broken']),
    ('Witness: under the gate, two drawers who both start by leaving everything keep the dweller; revised from round '
     '2 (n + 2) on they break it.',
     '见证：门控下，两个开始都留下一切的抽取者保持居者；自第 2 (n + 2) 轮起修订后它们打破它。',
     ['Optimum.Holding.gated_restraint_keeps', 'Optimum.Holding.gated_revised']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.InTurn.Perfect', 'Optimum.InTurn.BestAt', 'Optimum.InTurn.perfect_of_zero',
                   'Optimum.InTurn.perfect_levels', 'Optimum.InTurn.zero_of_le_sub', 'Optimum.InTurn.firstDrawn',
                   'Optimum.InTurn.secondDrawn', 'Optimum.InTurn.levels', 'Optimum.Holding.gate'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Revision comes to drawing everything', 'zh': '修订达到全部抽取'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Drawers in turn revising toward best responses, from any profile, both leave nothing at every step from '
              'round 2N on: they come to the perfect profile within twice the horizon, mutual restraint included.',
        'zh': '轮流的抽取者向最优回应修订，自任一组合出发，自第 2N 轮起两者每步不留：在视野的两倍之内达到完美组合，相互克制亦然。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. SG14\'s model: any law G of what stands; two drawers in turn, no capacity limit; plain sums over the '
               'steps that remain; rules reading the step and the level; revision simultaneous, each new rule a best response '
               'against the old profile at every step from every level; natural amounts, discrete steps.',
         'zh': '不加公理。SG14 的模型：任一所立之律 G；两个轮流的抽取者，无容量限制；其后各步之和；规则读取步与水平；修订同时进行，每条新规则在每步、'
               '从每个水平都是对旧组合的最优回应；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'Revision that is not a best response: noisy, partial or local learning.', 'zh': '非最优回应的修订：有噪声、部分或局部的学习。',
         'kind': 'scope'},
        {'en': 'Drawers whose capacities limit a draw, more than two, or drawing at once.', 'zh': '受容量限制、多于两个或同时抽取的抽取者。',
         'kind': 'scope'},
        {'en': 'That the bound 2N is tight in general: it is the induction\'s.', 'zh': '界 2N 一般是紧的：它是归纳给出的界。',
         'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {'en': 'Noisy or partial revision; capacities limiting a draw; more drawers; an independent review.',
                   'zh': '有噪声或部分的修订；容量限制抽取；更多抽取者；独立审查。'},
    'correspondence': {
        'en': 'Best-response dynamics settles on the backward-induction outcome in finite games of perfect information '
              '(Fudenberg and Levine 1998); cooperation unravels from the last period (Selten 1978).',
        'zh': '在有限完美信息博弈中，最优回应动态落在逆向归纳的结果上（Fudenberg 与 Levine 1998）；合作自最后一期瓦解（Selten 1978）。'},
    'canonical_source': SRC,
    'aliases': ['revision comes to drawing everything', 'how drawers come to a mutual best response', '修订达到全部抽取',
                'Becoming.Optimum.InTurn.revised_draw_all', 'Becoming.Optimum.InTurn.revisions_end'],
    'dependencies': [
        {'id': SG14, 'relation': 'formal-reuse',
         'detail': {'en': 'The profile, its draws, perfect profiles and drawing everything are reused; its open item is answered.',
                    'zh': '沿用组合、其所抽取、完美组合与全部抽取；回答其开放项。'},
         'interface': {
             'output': {'en': 'Perfect, perfect_of_zero, zero_of_le_sub.', 'zh': 'Perfect、perfect_of_zero、zero_of_le_sub。'},
             'input': {'en': 'How drawers come to the perfect profile.', 'zh': '抽取者如何达到完美组合。'},
             'conditions': {'en': 'Best-response revision.', 'zh': '最优回应修订。'},
             'evidence': SRC}}],
    'related': [],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (SG16), revision toward best responses comes to drawing everything within 2N rounds; '
              f'study section {N}.',
        'zh': f'2026年10月22日：新增（SG16），向最优回应的修订在 2N 轮之内达到全部抽取；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
NOTES = {
    SG14: ([('How drawers come to a mutual best response; rules reading more than the step and the level.',
             'How drawers come to a mutual best response other than by best-response revision (' + RID + '); rules '
             'reading more than the step and the level.'),
            ('抽取者如何达到相互最优回应；读取多于步与水平的规则。',
             '抽取者以最优回应修订之外的方式如何达到相互最优回应（' + RID + '）；读取多于步与水平的规则。')],
           [('how drawers come to a mutual best response;', 'noisy or partial revision;'),
            ('抽取者如何达到相互最优回应；', '有噪声或部分的修订；')]),
}
loaded = {}
for rid, (dns_pairs, nd_pairs) in NOTES.items():
    d = json.loads((RECORDS / f'{rid}.json').read_text())
    for old, new_ in dns_pairs:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        hits = [x for x in d['does_not_show'] if old in x[lang]]
        assert len(hits) == 1, (rid, old)
        hits[0][lang] = hits[0][lang].replace(old, new_)
    for old, new_ in nd_pairs:
        lang = 'zh' if re.search('[一-鿿]', old) else 'en'
        assert d['next_delta'][lang].count(old) == 1, (rid, lang, old)
        d['next_delta'][lang] = d['next_delta'][lang].replace(old, new_)
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
        'en': 'Revising toward best responses, from any profile, drawers in turn come to drawing everything within 2N rounds.',
        'zh': '向最优回应修订，自任一组合出发，轮流的抽取者在 2N 轮之内达到全部抽取。'
}}]
    d['history'].append({
        'en': f'22 October 2026, SG16: how drawers come to a mutual best response is answered for best-response revision '
              f'(record {RID}, study section {N}). Its laws are unchanged.',
        'zh': f'2026年10月22日，SG16：抽取者如何达到相互最优回应已就最优回应修订回答（记录 {RID}，研究第 {N} 节）。其规律不变。'
})
    loaded[rid] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
