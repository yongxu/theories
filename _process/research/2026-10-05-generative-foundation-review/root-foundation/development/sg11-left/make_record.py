#!/usr/bin/env python3
"""Write SG11's record valuing-what-is-left-at-the-horizon (a theorem) and note it in the six horizon records whose open
item it narrows (an order valuing what is left at the horizon):
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT FIRST_RECEIPT   (from the checkout root, after apply_text.py)

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
core_id, N, previous, first = sys.argv[1], int(sys.argv[2]), sys.argv[3], sys.argv[4]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. Valuing what is left at the horizon (SG11)"
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
RID = 'valuing-what-is-left-at-the-horizon'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SG6 = 'keeping-forgoes-the-renewal-at-the-need'
laws = [
    ('What a course draws across n + 1 steps with what it leaves after them is at most the start with what is given '
     'there and r for each step after, exactly where r is given at every step after the first, whatever is left; so for '
     'every course open from the start.',
     '过程在 n + 1 步中所抽取与其后所留之和至多是起始加所给再加之后每步 r，恰在第一步之后每步都给出 r 时取等，不论所留多少；自起点开放的每个过程皆然。',
     ['Optimum.drawn_add_left_le_most', 'Optimum.most_left_iff', 'Optimum.open_left_le_most']),
    ('The order by what is drawn and what is left after the horizon, valued alike. The course standing at a level y of '
     'greatest renewal at every step after the start draws and leaves the most and is open over any horizon where the '
     'capacity covers what the first step draws down to y and r, so it is an optimum; the course draining y at the end '
     'is one too.',
     '按所抽取与视野之后所留（同等计值）的序。起点之后每步都处于最大更新水平 y 的进程所抽取与所留最多，容量足以承担第一步降到 y 的抽取与 r 时在任何视野上开放，故是最优；终了抽干 y 的进程亦是。',
     ['Optimum.byDrawnLeft', 'Optimum.holdingTo_same', 'Optimum.keeping_left_most', 'Optimum.keeping_open',
      'Optimum.keeping_frontier_left', 'Optimum.holding_frontier_left']),
    ('Every optimum of every order rising with what is drawn and left stands at a level of greatest renewal at every '
     'step to the horizon, and the optima of the order by what is drawn and left are exactly the open courses doing so; '
     'where y is positive, the course keeping it is no optimum of the order by the draw alone.',
     '随所抽取与所留升高之序的每个最优在视野内每步都处于最大更新的水平，按所抽取与所留之序的最优恰是如此的开放进程；y 为正时，保持它的进程不是只按汲取之序的最优。',
     ['Optimum.frontier_holds_left', 'Optimum.frontier_left_iff', 'Optimum.keeping_not_frontier']),
    ('On a web, from a start s, a dependence every level of greatest renewal meets stands through the horizon under every '
     'such optimum, and one above every such level is broken at the first step and unmet through the horizon.',
     '在网上，自起点 s，被每个最大更新水平满足的依存在每个这样的最优下于视野内被保持，高于每个这样水平的依存在第一步被打破并在视野内不被满足。',
     ['Web.frontier_kept_left', 'Web.frontier_broken_left']),
    ("Witnesses: under a gate, from the dweller's need with capacity three, keeping the source at the need through and "
     'past the horizon is an optimum keeping the dweller at every step, draining at the end is one too, the optima are '
     'exactly the courses standing where the gate renews, and keeping is no optimum by the draw alone; under the logistic '
     'law every such optimum breaks the dweller at the first step.',
     '见证：门控下自居者所需处、容量为三，把源保持在所需处直到视野之后是最优并在每步保持居者，终了抽干亦是最优，最优恰是处于门控更新处的进程，只按汲取时保持者不是最优；逻辑斯谛律下每个这样的最优在第一步打破居者。',
     ['Optimum.Holding.gated_left', 'Optimum.Holding.logistic_left']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.drawn_add_shortfall_after', 'Optimum.holdingTo', 'Optimum.holding', 'Optimum.OpenCourse',
                   'Optimum.drawnOver', 'Optimum.byDrawn', 'Optimum.holdingTo_within', 'Optimum.holding_open',
                   'Optimum.holding_most', 'Optimum.frontier_holds', 'Web.frontier_kept', 'Web.frontier_broken',
                   'Optimum.Holding.gate', 'Optimum.Holding.logistic', 'Optimum.Holding.onSource'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Valuing what is left at the horizon', 'zh': '对视野末所留的计值'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'With what is left after the horizon valued as much as what is drawn, every optimum holds a level of '
              'greatest renewal to the horizon and the drain at the end is no longer forced; a dependence above every '
              'such level is still broken at the first step.',
        'zh': '视野之后所留与所抽取同等计值时，每个最优都在视野内保持在最大更新的水平，终了的抽干不再被迫；高于每个这样水平的依存仍在第一步被打破。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. A renewal law R of the level, at most r at every level and r at some y with y ≤ s + R s; a '
               'capacity k with s + R s ≤ y + k and r ≤ k, any horizon (the course draining at the end also y + r ≤ k '
               'and at least two steps; the broken law at least two steps); what is left valued one for one with what '
               'is drawn; natural amounts, discrete steps.',
         'zh': '不加公理。水平的更新之律 R，各水平至多 r，在某个 y ≤ s + R s 处为 r；容量 k 满足 s + R s ≤ y + k 与 r ≤ k，任何视野（终了抽干的进程另需 '
               'y + r ≤ k 且视野至少两步；打破之律视野至少两步）；所留与所抽取一比一计值；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'An order valuing what is left at another worth than what is drawn.', 'zh': '以不同于所汲取之价值对所留计值的序。',
         'kind': 'scope'},
        {'en': 'That valuing what is left keeps what depends on the levels passed through: a dependence above every level '
               'of greatest renewal is still broken at the first step.',
         'zh': '对所留计值保持依存于所经水平者：高于每个最大更新水平的依存仍在第一步被打破。', 'kind': 'non-implication'},
        {'en': 'Which optimum is taken: the last step\'s draw is left free, keeping and draining both optima.',
         'zh': '取哪个最优：最后一步的抽取是自由的，保持与抽干都是最优。', 'kind': 'non-implication'},
        {'en': 'Several optimizers ranking courses; steps met again after a fall.', 'zh': '多个对过程排序的优化者；跌落后再被满足的步。',
         'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}; the first receipt {first} '
              f'passed but left four of the laws apart and is superseded): the {n_new} declarations Becoming.Optimum '
              f'gained have empty axiom reports; the checker verifies core purity. Built and reviewed in one session; '
              f'author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}；第一次回执 {first} 通过但留下四条游离之律，已被取代）：Becoming.Optimum 新增的 '
              f'{n_new} 项声明公理报告为空；检查器并核对核心纯净。在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A terminal value at another worth than the draw; what keeping a dependence forgoes under the order by what '
              'is drawn and left; several optimizers ranking courses; an independent review.',
        'zh': '与汲取不同价值的终值；在按所抽取与所留之序下保持依存所放弃者；多个对过程排序的优化者；独立审查。'},
    'correspondence': {
        'en': 'A terminal or salvage value in a finite-horizon problem: the payoff counts the stock left at the end. '
              'Without it a finite-horizon harvest ends by drawing everything (Clark 1976); valued one for one, the end '
              'drain disappears and the steady yield at a level of greatest renewal is an optimum to the end and after.',
        'zh': '有限视野问题中的终值（残值）：收益计入终了所留存量。无此值时有限视野收获以抽尽告终（Clark 1976）；一比一计值时终了的抽干消失，'
              '最大更新水平上的稳定产出直到终了及其后都是最优。'},
    'canonical_source': SRC,
    'aliases': ['valuing what is left at the horizon', 'a terminal value at the worth of the draw', '对视野末所留的计值',
                'Becoming.Optimum.frontier_holds_left', 'Becoming.Optimum.frontier_left_iff'],
    'dependencies': [
        {'id': SG5, 'relation': 'formal-reuse',
         'detail': {'en': "The conservation identity over a horizon, the holding courses and SG5's optima are reused; the "
                          'open item its boundary names is answered for a one-for-one value.',
                    'zh': '沿用视野上的守恒恒等式、保持进程与 SG5 的最优；就一比一计值回答了其边界所列的开放项。'},
         'interface': {
             'output': {'en': 'drawn_add_shortfall_after, holdingTo, holding_open, frontier_holds.',
                        'zh': 'drawn_add_shortfall_after、holdingTo、holding_open、frontier_holds。'},
             'input': {'en': 'The optima of every order rising with what is drawn and left.',
                       'zh': '随所抽取与所留升高之每个序的最优。'},
             'conditions': {'en': 'What is left valued one for one with what is drawn.', 'zh': '所留与所抽取一比一计值。'},
             'evidence': SRC}},
        {'id': SG6, 'relation': 'formal-reuse',
         'detail': {'en': "The web laws take SG6's form, from a start s, and the witness reads the web of any course.",
                    'zh': '网之律取 SG6 的形式（自起点 s），见证读任一进程的网。'},
         'interface': {
             'output': {'en': 'onSource, the web laws with a start s.', 'zh': 'onSource、自起点 s 的网之律。'},
             'input': {'en': 'Web.frontier_kept_left, Web.frontier_broken_left, Holding.logistic_left.',
                       'zh': 'Web.frontier_kept_left、Web.frontier_broken_left、Holding.logistic_left。'},
             'conditions': {'en': 'A dependence met at the start.', 'zh': '起始时被满足的依存。'},
             'evidence': SRC}}],
    'related': [{'id': rid, 'detail': {
        'en': 'Its open item, an order valuing what is left at the horizon, is answered here for a one-for-one value.',
        'zh': '其开放项（对视野末所留赋值之序）在此就一比一计值得到回答。'}}
        for rid in ['a-step-coupling-keeps-at-every-horizon', 'a-weighting-faster-than-renewal-ends-the-base',
                    'optima-rebuild-a-depleted-base', 'others-drawing-first-end-the-base']],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (SG11), valuing what is left at the horizon: with what is left valued one for one '
              f'with what is drawn, every optimum holds a level of greatest renewal to the horizon, the drain at the end no '
              f'longer forced; a dependence above every such level is still broken; study section {N}.',
        'zh': f'2026年10月22日：新增（SG11），对视野末所留的计值：所留与所抽取一比一计值时，每个最优在视野内保持在最大更新的水平，终了的抽干不再被迫；'
              f'高于每个这样水平的依存仍被打破；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
EN_SUBS = [('An order valuing what is left at the horizon or discounting later draws (a terminal value or a discount)',
            'An order valuing what is left at the horizon at another worth than what is drawn, or discounting later draws'),
           ('terminal value or a discount', 'terminal value at another worth than the draw, or a discount'),
           ('rder valuing what is left at the horizon;', 'rder valuing what is left at the horizon at another worth than what is drawn;')]
ZH_SUBS = [('对视野末所留赋值或对后来汲取折现之序（终值或折现）', '以不同于所汲取之价值对视野末所留赋值或对后来汲取折现之序'),
           ('带终值或折现的序', '带与汲取不同价值之终值或折现的序'),
           ('对视野末所留赋值之序', '以不同于所汲取之价值对视野末所留赋值之序')]
loaded = {}
for rid in [SG5, SG6, 'a-step-coupling-keeps-at-every-horizon', 'a-weighting-faster-than-renewal-ends-the-base',
            'optima-rebuild-a-depleted-base', 'others-drawing-first-end-the-base']:
    d = json.loads((RECORDS / f'{rid}.json').read_text())
    hits = {'en': 0, 'zh': 0}
    for lang, subs in (('en', EN_SUBS), ('zh', ZH_SUBS)):
        fields = [x for x in d['does_not_show']] + [d['next_delta']]
        for x in fields:
            for old, new_ in subs:
                if old in x[lang]:
                    hits[lang] += x[lang].count(old)
                    x[lang] = x[lang].replace(old, new_)
                    break
    assert hits['en'] == 2 and hits['zh'] == 2, (rid, hits)
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
        'en': 'With what is left at the horizon valued one for one with what is drawn, every optimum holds a level of '
              'greatest renewal to the horizon, the drain at the end no longer forced; a dependence above every such '
              'level is still broken.',
        'zh': '视野末所留与所抽取一比一计值时，每个最优在视野内保持在最大更新的水平，终了的抽干不再被迫；高于每个这样水平的依存仍被打破。'}}]
    d['history'].append({
        'en': f'22 October 2026, SG11: an order valuing what is left at the horizon is answered for a one-for-one value '
              f'(record {RID}, study section {N}); the open item now names another worth. Its laws are unchanged.',
        'zh': f'2026年10月22日，SG11：对视野末所留赋值之序已就一比一计值回答（记录 {RID}，研究第 {N} 节）；开放项改为另一价值。其规律不变。'})
    loaded[rid] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
