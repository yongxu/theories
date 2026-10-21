#!/usr/bin/env python3
"""Write SG14's record drawers-in-turn-draw-everything (a theorem) and note it in SG10's record, whose open item it
answers, and SG3's (related):
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
HEAD = f"## {N}. Drawers in turn, each ranking courses (SG14)"
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
RID = 'drawers-in-turn-draw-everything'
SG10 = 'others-drawing-first-end-the-base'
SG3 = 'several-optimizers-drain-by-their-joint-capacity'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
laws = [
    ('Two drawers in turn at each step, the first leaving part of the level and the second part of that, what remains '
     'standing at the next step by a law G; what each draws over the steps that remain, defined back from the horizon; '
     'a profile perfect where each leaves at most what it is given and the two are at a mutual best response at every '
     'step from every level.',
     '每步两个抽取者轮流，第一个留下水平的一部分，第二个留下其中一部分，所余按律 G 立于下一步；各自在其后各步所抽取者，自视野回溯定义；'
     '每者所留至多为所给且每步、从每个水平都处于相互最优回应的组合为完美。',
     ['Optimum.InTurn.next', 'Optimum.InTurn.levels', 'Optimum.InTurn.firstDrawn', 'Optimum.InTurn.secondDrawn',
      'Optimum.InTurn.BestAt', 'Optimum.InTurn.Perfect']),
    ('Backward from the horizon: where the second draws nothing over the rest, a mutual best response has both leave '
     'nothing, whatever the first leaves the second drawing and whatever the second leaves the first drawing at its next '
     'move; so every perfect profile has both leave nothing at every step, whatever stands at nothing, and the base '
     'stands from the first step at what stands at nothing.',
     '自视野回溯：第二个在其余各步不抽取时，相互最优回应使两者都不留，第一个所留第二个抽取，第二个所留第一个在下一次抽取；'
     '故每个完美组合每步都使两者不留，不论零处所立为何，自第一步起基础立于零处所立者。',
     ['Optimum.InTurn.zero_of_le_sub', 'Optimum.InTurn.step_ends', 'Optimum.InTurn.ends_at',
      'Optimum.InTurn.perfect_ends', 'Optimum.InTurn.perfect_levels']),
    ('Drawing everything is perfect over every horizon.', '全部抽取在每个视野上都是完美的。',
     ['Optimum.InTurn.zero_secondDrawn', 'Optimum.InTurn.perfect_of_zero']),
    ('On a web, along every perfect profile a dependence on the base whose need, met at the start, is above what stands '
     'at nothing is broken at the first step.',
     '在网上，沿每个完美组合，起始时被满足、所需高于零处所立者的对基础的依存在第一步被打破。',
     ['Web.perfect_broken']),
    ("Witness: under a gate from the dweller's need two, alone the course holding the source at two is an optimum "
     'keeping the dweller through the horizon; in turn, drawing everything is perfect and every perfect profile breaks '
     'the dweller at the first step.',
     '见证：门控下自居者所需二出发，单独时把源保持在二的进程是最优，在视野内保持居者；轮流时全部抽取是完美的，每个完美组合在第一步打破居者。',
     ['Optimum.Holding.gated_in_turn']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.Next.leftBy', 'Optimum.Next.frontier_ends_drawn_first', 'Optimum.Holding.gated_alike',
                   'Optimum.Holding.gate', 'Optimum.Holding.onSource', 'Optimum.byDrawn', 'Optimum.OpenCourse'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Drawers in turn draw everything', 'zh': '轮流的抽取者全部抽取'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'With two drawers in turn, each ranking what it draws over the steps that remain, every profile at a mutual '
              'best response at every step from every level draws everything: the base stands from the first step at '
              'what stands at nothing.',
        'zh': '两个抽取者轮流、各自按其后各步所抽取排序时，每步、从每个水平都处于相互最优回应的每个组合都全部抽取：自第一步起基础立于零处所立者。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Any law G of what stands; two drawers in turn at each step, the first moving first, no capacity '
               'limiting a draw; each ranking the plain sum of its draws over the steps that remain; rules reading the '
               'step and the level; natural amounts, discrete steps.',
         'zh': '不加公理。任一所立之律 G；每步两个抽取者轮流，第一个先抽，无容量限制抽取；各自按其后各步所抽取之和排序；规则读取步与水平；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'Drawers whose capacities limit a draw, more than two drawers, or drawing at once with a rule of sharing.',
         'zh': '抽取受容量限制的抽取者、多于两个抽取者，或按分享规则同时抽取。', 'kind': 'scope'},
        {'en': 'How drawers come to a mutual best response; rules reading more than the step and the level.',
         'zh': '抽取者如何达到相互最优回应；读取多于步与水平的规则。', 'kind': 'scope'},
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
    'next_delta': {
        'en': 'Capacities limiting a draw; more than two drawers or drawing at once; how drawers come to a mutual best '
              'response; an independent review.',
        'zh': '容量限制抽取；多于两个抽取者或同时抽取；抽取者如何达到相互最优回应；独立审查。'},
    'correspondence': {
        'en': 'The dynamic commons with linear payoffs (Levhari and Mirman 1980): with no limit on a draw the '
              'subgame-perfect outcome is immediate exhaustion, here for every perfect profile of drawers in turn, by '
              'backward induction (Kuhn 1953; Selten 1965).',
        'zh': '线性收益的动态公地（Levhari 与 Mirman 1980）：抽取无限制时子博弈完美的结果是立即耗尽，此处对轮流抽取者的每个完美组合成立，由逆向归纳（Kuhn 1953；Selten 1965）。'},
    'canonical_source': SRC,
    'aliases': ['drawers in turn draw everything', 'the others\' rule derived', '轮流的抽取者全部抽取',
                'Becoming.Optimum.InTurn.perfect_ends', 'Becoming.Web.perfect_broken'],
    'dependencies': [
        {'id': SG10, 'relation': 'formal-reuse',
         'detail': {'en': 'The law of what stands and the others drawing first are reused; the rule supplied there is derived '
                          'for two drawers in turn.',
                    'zh': '沿用所立之律与他者先抽取；该处给出的规则在两个轮流抽取者的情形被导出。'},
         'interface': {
             'output': {'en': 'leftBy, frontier_ends_drawn_first.', 'zh': 'leftBy、frontier_ends_drawn_first。'},
             'input': {'en': 'The others\' rule as a best response.', 'zh': '作为最优回应的他者规则。'},
             'conditions': {'en': 'No capacity limiting a draw.', 'zh': '无容量限制抽取。'},
             'evidence': SRC}},
        {'id': SG5, 'relation': 'formal-reuse',
         'detail': {'en': 'The optimum alone under the gate, keeping the dweller, is the contrast.',
                    'zh': '门控下单独的最优（保持居者）为对照。'},
         'interface': {
             'output': {'en': 'gated_alike.', 'zh': 'gated_alike。'},
             'input': {'en': 'The witness in turn.', 'zh': '轮流的见证。'},
             'conditions': {'en': 'The gate from the dweller\'s need.', 'zh': '自居者所需出发的门控。'},
             'evidence': SRC}}],
    'related': [{'id': SG3, 'detail': {
        'en': 'At one step several optimizers at a mutual best response drain by their joint capacity; here over courses.',
        'zh': '在一步中处于相互最优回应的多个优化者以合计容量抽干；此处在过程上。'}}],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (SG14), drawers in turn, each ranking courses: every perfect profile draws '
              f'everything, the base standing from the first step at what stands at nothing; study section {N}.',
        'zh': f'2026年10月22日：新增（SG14），轮流的抽取者各自按过程排序：每个完美组合都全部抽取，自第一步起基础立于零处所立者；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
NOTES = {
    SG10: ([("That the others' rule is itself a best response: this is one optimizer's side of the dynamic commons, not a "
             "mutual best response among several optimizers ranking courses, nor how optimizers come to one.",
             "That the others' rule is a best response where capacities limit a draw, with more than two drawers or "
             "drawing at once: for two drawers in turn without a limit it is (" + RID + "); nor how optimizers come to one."),
            ('他者的规则本身是最优回应：这是动态公地中一个优化者的一侧，不是多个对过程排序的优化者之间的相互最优回应，也不是优化者如何达到它。',
             '他者的规则在容量限制抽取、多于两个抽取者或同时抽取时是最优回应：两个轮流且无限制时它是（' + RID + '）；也不是优化者如何达到它。')],
           [('Several optimizers each ranking courses at a mutual best response, and how they come to one;',
             'Several optimizers ranking courses whose capacities limit a draw, or drawing at once, and how they come to a '
             'mutual best response;'),
            ('多个各自对过程排序的优化者的相互最优回应及其如何达到；', '受容量限制或同时抽取的多个对过程排序的优化者，及其如何达到相互最优回应；')]),
    SG3: ([], []),
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
        'en': 'With two drawers in turn, each ranking courses, every perfect profile draws everything, the base standing '
              'from the first step at what stands at nothing.',
        'zh': '两个抽取者轮流、各自按过程排序时，每个完美组合都全部抽取，自第一步起基础立于零处所立者。'}}]
    d['history'].append({
        'en': f'22 October 2026, SG14: with two drawers in turn, each ranking courses, every perfect profile draws '
              f'everything (record {RID}, study section {N}). Its laws are unchanged.',
        'zh': f'2026年10月22日，SG14：两个抽取者轮流、各自按过程排序时，每个完美组合都全部抽取（记录 {RID}，研究第 {N} 节）。其规律不变。'})
    loaded[rid] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
