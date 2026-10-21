#!/usr/bin/env python3
"""Write SG13's record steps-met-again-after-a-fall (a theorem) and note it in SG7's record and the records whose
open item, steps met again after a fall, it answers:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.Optimum gained since the previous receipt; every cited declaration is
resolved against the receipt's audited declarations, and the receipt must bind the module's current bytes. Every edit
is checked before anything is written."""
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
HEAD = f"## {N}. Steps met again after a fall (SG13)"
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
RID = 'steps-met-again-after-a-fall'
SG7 = 'a-step-coupling-keeps-at-every-horizon'
SG6 = 'keeping-forgoes-the-renewal-at-the-need'
laws = [
    ('The steps among the first n at which a Boolean reading holds, counted: at most every step, all where it holds '
     'throughout, fewer where it fails at some step, and the steps before j number j.',
     '前 n 步中某个布尔读数成立的步数：至多每一步，处处成立时为全部，某步不成立时更少；j 之前的步恰为 j 个。',
     ['Optimum.countUpTo', 'Optimum.counted_le_one', 'Optimum.countUpTo_le', 'Optimum.countUpTo_all',
      'Optimum.countUpTo_lt', 'Optimum.countUpTo_below']),
    ('Where what is given at each counted step is at most q, r for each counted step is at most everything given falls '
     'short of r, with q for each counted step, wherever they lie (the count from the start its case); so what a '
     'course draws with what it leaves and r for each step met is at most the start with what is given there, r a '
     'step after and q for each step met.',
     '每个被计的步所给至多为 q 时，每个被计的步的 r 至多是所给不足 r 之和再加每个被计的步的 q，不论其位置（自起点计数是其情形）；故进程所抽取加所留再加每个被满足的步的 r，'
     '至多是起始加所给、此后每步 r 再加每个被满足的步的 q。',
     ['Optimum.counted_step', 'Optimum.shortfall_count_ge', 'Optimum.metCount', 'Optimum.metCount_of_met',
      'Optimum.met_count_drawn_le']),
    ('A course below the need at some step, counted at every step met, is worth at most the keeping course ending at '
     'e, less d, where r ≤ q + c, r + e + d ≤ q + c + m and e + d ≤ c: a fall met again loses the coupling only at '
     'the steps below.',
     '某步低于所需的进程，按每个被满足的步计数，价值至多是终于 e 的保持进程减 d，条件为 r ≤ q + c、r + e + d ≤ q + c + m 与 e + d ≤ c：跌落后再被满足只在其下各步失去耦合。',
     ['Optimum.le_of_met_count', 'Optimum.mul_le_of_rate', 'Optimum.met_key_end', 'Optimum.met_key_drop',
      'Optimum.falls_met_le']),
    ('Every optimum of every order rising with a worth adding at least c a step to a keeping course and at most c for '
     'each step met, wherever, keeps the need through the horizon where r + e < q + c + m and e < c; the keeping '
     'course ending at m is an optimum where r ≤ q + c and m ≤ c.',
     '随一个价值升高之每个序的每个最优（对保持的进程每步至少加 c，对每个被满足的步不论位置至多加 c），在 r + e < q + c + m 且 e < c 时在视野内保持所需；'
     '在 r ≤ q + c 且 m ≤ c 时终于 m 的保持进程是最优。',
     ['Optimum.frontier_keeps_met', 'Optimum.continued_met_frontier']),
    ('On a web, under those conditions, every such optimum meets the dependence at every step through the horizon.',
     '在网上，在这些条件下，每个这样的最优在视野内每步都满足依存。',
     ['Web.frontier_met_kept']),
    ("Witness: under a burst renewing four at one, from the dweller's need two with capacity three, a coupling of four "
     'a step keeps the dweller under every optimum counting from the start, while counting every step met the course '
     'falling once and met again is an optimum beside the keeping course; five a step keeps it under every optimum.',
     '见证：在一处更新四的爆发之下，自居者所需二出发、容量为三，每步四在自起点计数时使每个最优保持居者，而按每个被满足的步计数时跌落一次再被满足的进程与保持进程同为最优；每步五则使每个最优保持它。',
     ['Optimum.Holding.burst', 'Optimum.Holding.burst_le', 'Optimum.Holding.burst_above', 'Optimum.Holding.fallOnce',
      'Optimum.Holding.fallOnce_open', 'Optimum.Holding.fallOnce_drawn', 'Optimum.Holding.fallOnce_met',
      'Optimum.Holding.metDraw', 'Optimum.Holding.metDraw_of_keeps', 'Optimum.Holding.burst_met']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.shortfall_ge', 'Optimum.met_drawn_le', 'Optimum.frontier_keeps_stepwise',
                   'Optimum.Keeps', 'Optimum.keeps_or_falls', 'Optimum.continued', 'Optimum.continued_open',
                   'Optimum.continued_keeping_frontier', 'Optimum.holdingTo_most', 'Optimum.holdingTo_steps',
                   'Optimum.Holding.stepwiseDraw', 'Optimum.Holding.onSource', 'Web.frontier_keeps_stepwise'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Steps met again after a fall', 'zh': '跌落后再被满足的步'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Counted at every step met, wherever, a coupling a step keeps a need under every optimum exactly where '
              'r + e < q + c + m and e < c, strictly above the count from the start: a fall met again loses the '
              'coupling only at the steps below.',
        'zh': '按每个被满足的步计数（不论位置）时，每步的耦合恰在 r + e < q + c + m 且 e < c 时使每个最优保持所需，严格高于自起点计数的门槛：跌落后再被满足只在其下各步失去耦合。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. A renewal law R of the level, at most r at every level, at most q at or above a need m and q '
               'at some y with y ≤ s + R s; a start meeting m; a capacity covering what the first step draws down to y '
               'and y with q down to some e between m and y; a horizon of at least two steps; a worth adding at least c '
               'a step to a keeping course and at most c for each step met, wherever; natural amounts, discrete steps.',
         'zh': '不加公理。水平的更新之律 R，各水平至多 r，所需 m 及以上至多 q，在某个 y ≤ s + R s 处为 q；起点满足 m；容量足以承担第一步降到 y 的抽取与 y 加 q 降到 m 与 y 之间某个 e；'
               '视野至少两步；一个价值对保持的进程每步至少加 c，对每个被满足的步不论位置至多加 c；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'A weighting of the steps met, or a coupling depending on how long the need stays met.',
         'zh': '对被满足之步的加权，或依赖所需被满足多久的耦合。', 'kind': 'scope'},
        {'en': 'That every optimum keeps the need at r + e = q + c + m: there a fall met again can tie (the witness).',
         'zh': '在 r + e = q + c + m 时每个最优保持所需：那里跌落后再被满足可以相持（见证）。', 'kind': 'non-implication'},
        {'en': 'Several optimizers ranking courses.', 'zh': '多个对过程排序的优化者。', 'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A weighting of the steps met; several optimizers ranking courses at a mutual best response; an independent '
              'review.',
        'zh': '对被满足之步的加权；多个对过程排序的优化者的相互最优回应；独立审查。'},
    'correspondence': {
        'en': 'A reward for each step a constraint holds, with no memory of a breach, as in constrained Markov decision '
              'processes (Altman 1999); against a breach forfeiting what follows, the threshold rises by the gain a step '
              'below and the end left above the need.',
        'zh': '约束成立的每一步给予回报而不记违约，如约束马尔可夫决策过程（Altman 1999）；相对于违约即丧失其后各步者，门槛升高了其下每步之所得与终了高于所需之量。'},
    'canonical_source': SRC,
    'aliases': ['steps met again after a fall', 'a coupling for every step met', '跌落后再被满足的步',
                'Becoming.Optimum.frontier_keeps_met', 'Becoming.Optimum.shortfall_count_ge'],
    'dependencies': [
        {'id': SG7, 'relation': 'formal-reuse',
         'detail': {'en': 'Its shortfall law for the steps from the start is now the case of the law over any counted '
                          'steps; its threshold is the contrast.',
                    'zh': '其自起点各步的不足之律现为任意被计之步之律的情形；其门槛为对照。'},
         'interface': {
             'output': {'en': 'shortfall_ge, stepwiseDraw, frontier_keeps_stepwise.',
                        'zh': 'shortfall_ge、stepwiseDraw、frontier_keeps_stepwise。'},
             'input': {'en': 'The coupling counted at every step met.', 'zh': '按每个被满足的步计数的耦合。'},
             'conditions': {'en': 'A start meeting the need.', 'zh': '起点满足所需。'},
             'evidence': SRC}},
        {'id': SG6, 'relation': 'formal-reuse',
         'detail': {'en': "SG6's keeping courses, continued courses and their optimum among keeping courses are reused.",
                    'zh': '沿用 SG6 的保持进程、延续进程及其在保持进程中的最优。'},
         'interface': {
             'output': {'en': 'Keeps, keeps_or_falls, continued, continued_keeping_frontier, holdingTo_most.',
                        'zh': 'Keeps、keeps_or_falls、continued、continued_keeping_frontier、holdingTo_most。'},
             'input': {'en': 'The keeping course as the comparison.', 'zh': '以保持进程为比较。'},
             'conditions': {'en': 'At most q given at or above the need.', 'zh': '所需及以上至多给出 q。'},
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
        'en': f'22 October 2026: added (SG13), steps met again after a fall: counted at every step met, a coupling a step '
              f'keeps the need under every optimum where r + e < q + c + m and e < c, strictly above the count from the '
              f'start; study section {N}.',
        'zh': f'2026年10月22日：新增（SG13），跌落后再被满足的步：按每个被满足的步计数时，每步的耦合在 r + e < q + c + m 且 e < c 时使每个最优保持所需，'
              f'严格高于自起点计数的门槛；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
NOTES = {
    SG7: ([('Steps met again after a fall, which the coupling does not count;',
            'Steps met again after a fall, which this coupling does not count (counted, see ' + RID + ');'),
           ('跌落后再被满足的步（耦合不计）；', '跌落后再被满足的步（此耦合不计；计入它们见 ' + RID + '）；')],
          [('Steps met again after a fall; ', ''), ('跌落后再被满足的步；', '')]),
    'a-weighting-faster-than-renewal-ends-the-base': ([('; steps met again after a fall;', ';'), ('；跌落后再被满足的步；', '；')], []),
    'optima-rebuild-a-depleted-base': ([('; steps met again after a fall;', ';'), ('；跌落后再被满足的步；', '；')],
                                       [('; steps met again after a fall;', ';'), ('；跌落后再被满足的步；', '；')]),
    'others-drawing-first-end-the-base': ([('; steps met again after a fall;', ';'), ('；跌落后再被满足的步；', '；')],
                                          [('; steps met again after a fall;', ';'), ('；跌落后再被满足的步；', '；')]),
    'valuing-what-is-left-at-any-worth': ([('Several optimizers ranking courses; steps met again after a fall.',
                                            'Several optimizers ranking courses.'),
                                           ('多个对过程排序的优化者；跌落后再被满足的步。', '多个对过程排序的优化者。')], []),
    'valuing-what-is-left-at-the-horizon': ([('Several optimizers ranking courses; steps met again after a fall.',
                                              'Several optimizers ranking courses.'),
                                             ('多个对过程排序的优化者；跌落后再被满足的步。', '多个对过程排序的优化者。')], []),
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
        'en': 'Counted at every step met, wherever, a coupling a step keeps a need under every optimum where '
              'r + e < q + c + m and e < c, strictly above the count from the start.',
        'zh': '按每个被满足的步计数（不论位置）时，每步的耦合在 r + e < q + c + m 且 e < c 时使每个最优保持所需，严格高于自起点计数的门槛。'}}]
    d['history'].append({
        'en': f'22 October 2026, SG13: steps met again after a fall are answered (record {RID}, study section {N}); '
              f'its open item says so. Its laws are unchanged.',
        'zh': f'2026年10月22日，SG13：跌落后再被满足的步已回答（记录 {RID}，研究第 {N} 节）；其开放项如此说明。其规律不变。'})
    loaded[rid] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
