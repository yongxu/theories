#!/usr/bin/env python3
"""Write SG17's record revision-comes-to-drawing-everything (a theorem) and note it in SG14's record, whose open item it
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
HEAD = f"## {N}. Any number of drawers in turn (SG17)"
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
RID = 'any-number-of-drawers-in-turn'
SG14 = 'drawers-in-turn-draw-everything'
M = 'Optimum.InTurn.Many.'
laws = [
    ('At each step k drawers draw in turn, each leaving part of what it is given to the next; a profile is perfect where '
     'each leaves at most what it is given and every drawer, of whatever it is given, leaves what draws it the most.',
     '每步 k 个抽取者轮流抽取，各自把所给的一部分留给下一者；若各自至多留所给，且每者对所给都留下使自己抽取最多者，组合即完美。',
     [M + n for n in ['pass', 'next', 'drawn', 'BestAt', 'Perfect', 'levels']]),
    ('With at least two drawers, backward from the horizon every drawer after the first draws nothing later and leaves '
     'nothing, and then so does the first: every perfect profile has every drawer leave nothing at every step, the base '
     'standing at what stands at nothing.',
     '两个及以上抽取者时，自视野逆推，第一者之后的每者此后不抽而全不留，于是第一者亦然：每个完美组合中每者每步都不留，基底立于零处所立者。',
     [M + n for n in ['pass_zero', 'pass_of_first', 'step_ends', 'ends_at', 'perfect_ends', 'perfect_levels']]),
    ('Drawing everything is perfect for every number of drawers from two.',
     '全部抽取对两个及以上任意多个抽取者都是完美的。',
     [M + n for n in ['zero_drawn', 'perfect_of_zero']]),
    ('Two drawers are the case k = 2: their draws, levels and perfect profiles are those of drawers 0 and 1, and their '
     'laws are derived from these.',
     '两个抽取者是 k = 2 的情形：其所抽、水平与完美组合即抽取者 0 与 1 的，其律由此导出。',
     [M + n for n in ['pair', 'drawn_first', 'drawn_second', 'levels_pair', 'perfect_pair']]),
    ('On a web, along every perfect profile of two or more drawers a dependence above what stands at nothing is broken at '
     'the first step; under the gate, every perfect profile of any number from two breaks the dweller.',
     '在网上，沿两个及以上抽取者的每个完美组合，高于零处所立者的依存在第一步被打破；门控下，两个及以上任意多个的每个完美组合都打破居者。',
     ['Web.turns_broken', 'Optimum.Holding.gated_turns']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
GONE = {f'Becoming.Optimum.InTurn.{n}' for n in ['step_ends', 'ends_at', 'perfect_ends', 'perfect_levels']}
assert old_names - set(full) == GONE, (old_names - set(full)) ^ GONE
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.InTurn.Perfect', 'Optimum.InTurn.BestAt',
                   'Optimum.InTurn.zero_of_le_sub', 'Optimum.InTurn.firstDrawn', 'Optimum.InTurn.secondDrawn',
                   'Optimum.InTurn.levels', 'Web.perfect_broken', 'Optimum.Holding.gate', 'Optimum.Holding.gated_in_turn'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Any number of drawers in turn', 'zh': '任意多个轮流的抽取者'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'With any number of drawers in turn from two, each ranking courses, every profile at a mutual best response '
              'at every step from every level has every drawer leave nothing, so the base stands at once at what stands '
              'at nothing; two drawers are the case.',
        'zh': '两个及以上任意多个各自对过程排序的轮流抽取者，每步、每个水平都处于相互最优回应的每个组合中每者都不留，故基底立即立于零处所立者；两个抽取者是其情形。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. SG14\'s model: any law G of what stands; k drawers in turn at each step, k at least two; plain sums '
               'over the steps that remain; rules reading the drawer, the step and the level; each leaving at most what it '
               'is given, with no capacity limit; natural amounts, discrete steps.',
         'zh': '不加公理。SG14 的模型：任一所立之律 G；每步 k 个轮流的抽取者，k 至少为二；其后各步之和；规则读取抽取者、步与水平；各自至多留所给，无容量限制；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'Drawers drawing at once with a rule of sharing; capacities limiting the draws of more than two drawers.',
         'zh': '按分享规则同时抽取的抽取者；限制多于两个抽取者之抽取的容量。', 'kind': 'scope'},
        {'en': 'One drawer: with k = 1 an optimum may keep the base (Holding.gated_in_turn).',
         'zh': '一个抽取者：k = 1 时最优可保持基底（Holding.gated_in_turn）。', 'kind': 'scope'},
        {'en': 'That the drain is a harm or restraint better: no evaluation enters; the laws say what perfect profiles do.',
         'zh': '抽干是伤害或克制更好：没有评价进入；这些律只说完美组合做什么。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {'en': 'Drawing at once with a rule of sharing; capacities for more drawers; an independent review.',
                   'zh': '按分享规则同时抽取；更多抽取者的容量；独立审查。'},
    'correspondence': {
        'en': 'In the n-player dynamic commons the equilibrium stock falls as players are added (Levhari and Mirman 1980); '
              'backward induction in finite games of perfect information (Selten 1965).',
        'zh': '在 n 人动态公地中，均衡存量随参与者增加而下降（Levhari 与 Mirman 1980）；有限完美信息博弈中的逆向归纳（Selten 1965）。'},
    'canonical_source': SRC,
    'aliases': ['any number of drawers in turn', 'many drawers in turn', '任意多个轮流的抽取者',
                'Becoming.Optimum.InTurn.Many.perfect_ends', 'Becoming.Web.turns_broken'],
    'dependencies': [
        {'id': SG14, 'relation': 'formal-reuse',
         'detail': {'en': 'Its two drawers are the case k = 2; its web law is derived from these, its step laws, perfect_ends '
                          'and perfect_levels removed; its open item on more than two drawers is answered.',
                    'zh': '其两个抽取者是 k = 2 的情形；其网律由此导出，其步律、perfect_ends 与 perfect_levels 被移除；回答其关于多于两个抽取者的开放项。'},
         'interface': {
             'output': {'en': 'Perfect, BestAt, firstDrawn, secondDrawn, levels, zero_of_le_sub.',
                        'zh': 'Perfect、BestAt、firstDrawn、secondDrawn、levels、zero_of_le_sub。'},
             'input': {'en': 'Any number of drawers in turn.', 'zh': '任意多个轮流的抽取者。'},
             'conditions': {'en': 'At least two drawers.', 'zh': '至少两个抽取者。'},
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
        'en': f'22 October 2026: added (SG17), any number of drawers in turn; SG14\'s two drawers the case k = 2, its '
              f'step_ends, ends_at, perfect_ends and perfect_levels removed; study section {N}.',
        'zh': f'2026年10月22日：新增（SG17），任意多个轮流的抽取者；SG14 的两个抽取者是 k = 2 的情形，其 step_ends、ends_at、perfect_ends 与 perfect_levels 被移除；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
REMAP = {f'Becoming.Optimum.InTurn.{n}': f'Becoming.Optimum.InTurn.Many.{n}'
         for n in ['step_ends', 'ends_at', 'perfect_ends', 'perfect_levels']}
for target in REMAP.values():
    assert target in full, target
loaded = {}
d = json.loads((RECORDS / f'{SG14}.json').read_text())
hits = 0
for law in d['laws']:
    for k, name in enumerate(law['declarations']):
        if name in REMAP:
            law['declarations'][k] = REMAP[name]
            hits += 1
assert hits >= 3, hits
for ref in d['references']:
    if ref.get('declarations'):
        ref['declarations'] = sorted({REMAP.get(n, n) for n in ref['declarations']})
# The records citing the removed laws elsewhere re-cite their general forms.
for other in ('drawers-in-turn-within-capacities', 'revision-comes-to-drawing-everything'):
    o = json.loads((RECORDS / f'{other}.json').read_text())
    n_hit = 0
    for law in o['laws']:
        for k, name in enumerate(law['declarations']):
            if name in REMAP:
                law['declarations'][k] = REMAP[name]
                n_hit += 1
    for ref in o['references']:
        if ref.get('declarations'):
            before = set(ref['declarations'])
            ref['declarations'] = sorted({REMAP.get(n, n) for n in ref['declarations']})
            n_hit += len(before & set(REMAP))
    assert n_hit >= 1, other
    o['history'].append({
        'en': f'22 October 2026, SG17: the two drawers\' perfect_ends and perfect_levels, removed as the case k = 2 of the '
              f'general laws, are cited as Many.perfect_ends and Many.perfect_levels (record {RID}); its laws are unchanged.',
        'zh': f'2026年10月22日，SG17：两个抽取者的 perfect_ends 与 perfect_levels 作为一般之律 k = 2 的情形被移除，今以 Many.perfect_ends 与 '
              f'Many.perfect_levels 引用（记录 {RID}）；其律不变。'})
    loaded[other] = o
x = [y for y in d['does_not_show'] if y['en'].startswith('More than two drawers, or drawing at once with a rule of sharing;')]
assert len(x) == 1
x[0]['en'] = x[0]['en'].replace('More than two drawers, or drawing at once with a rule of sharing;',
                                'Drawing at once with a rule of sharing (more than two drawers in turn: record ' + RID + ');')
x[0]['zh'] = ('按分享规则同时抽取（多于两个轮流者见记录 ' + RID + '）；受容量限制时，最后一步之外何种组合完美（记录 '
             'drawers-in-turn-within-capacities）。')
assert RID in x[0]['zh'], x[0]['zh']
for lang, old_, new_ in (('en', 'More than two drawers or drawing at once;', 'Drawing at once;'),
                         ('zh', '多于两个抽取者或同时抽取；', '同时抽取；')):
    assert d['next_delta'][lang].count(old_) == 1, (SG14, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, new_)
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'With any number of drawers in turn from two every perfect profile draws everything; these two drawers are the case k = 2.',
    'zh': '两个及以上任意多个轮流的抽取者，每个完美组合都全部抽取；这两个抽取者是 k = 2 的情形。'}}]
d['history'].append({
    'en': f'22 October 2026, SG17: more than two drawers in turn stated (record {RID}, study section {N}); step_ends, '
          f'ends_at, perfect_ends and perfect_levels now cited in their general form, the Many laws of which these two drawers '
          f'are the case; the statements of its laws are unchanged.',
    'zh': f'2026年10月22日，SG17：多于两个轮流的抽取者已陈述（记录 {RID}，研究第 {N} 节）；step_ends、ends_at、perfect_ends 与 perfect_levels '
          f'今以其一般形式（这两个抽取者是其情形的 Many 之律）引用；其律的陈述不变。'})
loaded[SG14] = d
for o in loaded.values():
    o['aliases'] = [a for a in o.get('aliases', []) if a not in REMAP]
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
