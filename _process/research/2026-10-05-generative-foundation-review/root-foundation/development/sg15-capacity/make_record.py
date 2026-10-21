#!/usr/bin/env python3
"""Write SG15's record revision-comes-to-drawing-everything (a theorem) and note it in SG14's record, whose open item it
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
HEAD = f"## {N}. Drawers in turn whose capacity limits a draw (SG15)"
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
RID = 'drawers-in-turn-within-capacities'
SG14 = 'drawers-in-turn-draw-everything'
laws = [
    ('Where leaving the floor draws no less than what was left, what was left is the floor; leaving nothing where '
     'nothing draws less is its case.',
     '留下下限所抽不少于所留时，所留即是下限；不留而所抽不少时，是其情形。',
     ['Optimum.InTurn.eq_of_sub_le_sub']),
    ('Perfect within capacities: each leaves at least its floor and at most what it is given, and at every step from '
     'every level each leaves what draws it the most among what it may leave; with no floor this is perfect.',
     '容量内完美：各自至少留其下限、至多留所给，且在每步、从每个水平各自在可留者中留下使自己抽取最多者；无下限时即完美。',
     ['Optimum.InTurn.BestWithin', 'Optimum.InTurn.PerfectWithin', 'Optimum.InTurn.within_zero_iff']),
    ('Each draws to capacity at the last step; the second wherever it draws nothing after, the first wherever what it '
     'draws after does not depend on what it leaves.',
     '各自在最后一步抽到容量；第二者在其此后不抽之处，第一者在其此后所抽不依赖所留之处。',
     ['Optimum.InTurn.second_at_floor', 'Optimum.InTurn.first_at_floor', 'Optimum.InTurn.last_at_floor']),
    ('Witness: doubling over two steps, the second able to take one unit a step; a profile perfect within the capacities '
     'exists, in every one the first leaves everything at the first step from three and the dweller is kept, while with '
     'neither draw limited every perfect profile breaks it.',
     '见证：两步倍增，第二者每步至多取一单位；容量内完美的组合存在，每个中第一者自三在第一步全留，居者得以保持；两者都不受限时每个完美组合都打断它。',
     ['Optimum.Holding.keepsFirst', 'Optimum.Holding.keepsFirst_le', 'Optimum.Holding.twice_sum',
      'Optimum.Holding.keepsFirst_best', 'Optimum.Holding.only_three', 'Optimum.Holding.doubling_capacity']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.InTurn.Perfect', 'Optimum.InTurn.BestAt', 'Optimum.InTurn.perfect_ends',
                   'Optimum.InTurn.zero_of_le_sub', 'Optimum.InTurn.firstDrawn', 'Optimum.InTurn.secondDrawn',
                   'Optimum.InTurn.levels', 'Optimum.sub_le_sub_left_of_le', 'Web.perfect_broken'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Drawers in turn within capacities', 'zh': '容量内的轮流抽取者'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Drawers in turn whose capacity limits a draw draw to capacity at the last step and wherever the other\'s '
              'later draw is fixed, and unlimited are SG14\'s perfect profiles; a limit on the other\'s draw can make '
              'restraint the best response and keep the base.',
        'zh': '抽取受容量限制的轮流抽取者在最后一步、以及在对方此后所抽固定之处抽到容量，无限制时即 SG14 的完美组合；对方抽取受限可使克制成为最优回应并保持基底。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. SG14\'s model: any law G of what stands; two drawers in turn; plain sums over the steps that '
               'remain; rules reading the step and the level; each leaving at least a floor at each step and level (a '
               'capacity c is the floor z - c); natural amounts, discrete steps.',
         'zh': '不加公理。SG14 的模型：任一所立之律 G；两个轮流的抽取者；其后各步之和；规则读取步与水平；各自在每步、每个水平至少留一下限（容量 c 即下限 z - c）；'
               '自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'Which profiles are perfect within capacities away from the last step and the steps where the other\'s later '
               'draw is fixed.', 'zh': '在最后一步与对方此后所抽固定之步之外，容量内何种组合完美。', 'kind': 'scope'},
        {'en': 'More than two drawers, drawing at once, or capacities that vary with the base.',
         'zh': '多于两个抽取者、同时抽取，或随基底变化的容量。', 'kind': 'scope'},
        {'en': 'That a limit always keeps the base: the witness shows that one can; the general law leaves it open.',
         'zh': '限制总保持基底：见证表明可以；一般律未定。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {'en': 'Profiles perfect within capacities away from the last step; more drawers; an independent review.',
                   'zh': '最后一步之外容量内的完美组合；更多抽取者；独立审查。'},
    'correspondence': {
        'en': 'The alternating-move dynamic commons depletes the stock at its subgame-perfect outcome (Levhari and Mirman '
              '1980); a bound on extraction can make conservation an equilibrium.',
        'zh': '交替行动的动态公地在其子博弈完美结果中耗尽存量（Levhari 与 Mirman 1980）；抽取之界可使保存成为均衡。'},
    'canonical_source': SRC,
    'aliases': ['drawers in turn within capacities', 'capacity limits a draw', '容量内的轮流抽取者',
                'Becoming.Optimum.InTurn.last_at_floor', 'Becoming.Optimum.Holding.doubling_capacity'],
    'dependencies': [
        {'id': SG14, 'relation': 'formal-reuse',
         'detail': {'en': 'The profile, its draws and perfect profiles are reused; perfect within capacities with no floor is '
                          'its perfect, and its open item on capacities is answered in part.',
                    'zh': '沿用组合、其所抽取与完美组合；无下限的容量内完美即其完美，部分回答其关于容量的开放项。'},
         'interface': {
             'output': {'en': 'Perfect, BestAt, perfect_ends, zero_of_le_sub, Web.perfect_broken.',
                        'zh': 'Perfect、BestAt、perfect_ends、zero_of_le_sub、Web.perfect_broken。'},
             'input': {'en': 'Drawers whose capacity limits a draw.', 'zh': '抽取受容量限制的抽取者。'},
             'conditions': {'en': 'Floors at each step and level.', 'zh': '每步每个水平的下限。'},
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
        'en': f'22 October 2026: added (SG15), drawers in turn whose capacity limits a draw; zero_of_le_sub now the case of '
              f'eq_of_sub_le_sub; study section {N}.',
        'zh': f'2026年10月22日：新增（SG15），抽取受容量限制的轮流抽取者；zero_of_le_sub 今为 eq_of_sub_le_sub 的情形；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
loaded = {}
d = json.loads((RECORDS / f'{SG14}.json').read_text())
hits = [x for x in d['does_not_show']
        if x['en'] == 'Drawers whose capacities limit a draw, more than two drawers, or drawing at once with a rule of sharing.']
assert len(hits) == 1
hits[0]['en'] = ('More than two drawers, or drawing at once with a rule of sharing; with capacities limiting a draw, which '
                 'profiles are perfect away from the last step (record ' + RID + ').')
hits[0]['zh'] = '多于两个抽取者，或按分享规则同时抽取；抽取受容量限制时，最后一步之外何种组合完美（记录 ' + RID + '）。'
for lang, old_ in (('en', 'Capacities limiting a draw; '), ('zh', '容量限制抽取；')):
    assert d['next_delta'][lang].count(old_) == 1, (SG14, lang)
    d['next_delta'][lang] = d['next_delta'][lang].replace(old_, '')
d['next_delta']['en'] = d['next_delta']['en'][0].upper() + d['next_delta']['en'][1:]
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'With capacities limiting a draw, each draws to capacity at the last step, and a limit on the other\'s draw can '
          'make restraint the best response.',
    'zh': '抽取受容量限制时，各自在最后一步抽到容量；对方抽取受限可使克制成为最优回应。'}}]
d['history'].append({
    'en': f'22 October 2026, SG15: capacities limiting a draw are stated in part (record {RID}, study section {N}); '
          f'zero_of_le_sub now reads eq_of_sub_le_sub. Its laws are unchanged.',
    'zh': f'2026年10月22日，SG15：容量限制抽取已部分陈述（记录 {RID}，研究第 {N} 节）；zero_of_le_sub 今读取 eq_of_sub_le_sub。其规律不变。'})
loaded[SG14] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
