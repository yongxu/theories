#!/usr/bin/env python3
"""Write SG12's record valuing-what-is-left-at-any-worth (a theorem) and note it in SG11's record and the six horizon
records whose open item it narrows (a worth on what is left other than one for one):
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
HEAD = f"## {N}. Valuing what is left at any worth (SG12)"
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
RID = 'valuing-what-is-left-at-any-worth'
SG11 = 'valuing-what-is-left-at-the-horizon'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SG6 = 'keeping-forgoes-the-renewal-at-the-need'
laws = [
    ('At a worth v of at least one, what is drawn with v times what is left is what is drawn with what is left and '
     'v - 1 times what is left; so an open course leaving at most e draws with v times what it leaves at most the start '
     'with what is given there, r a step after and v - 1 times e, and where v > 1 reaches it exactly where it holds a '
     'level of greatest renewal at every step to the horizon and leaves e.',
     '价值 v 至少为一时，所抽取加 v 倍所留等于所抽取加所留再加 v - 1 倍所留；故留下至多 e 的开放进程所抽取加 v 倍所留至多是起始加所给、此后每步 r 再加 v - 1 倍 e，'
     'v 大于一时恰在它于视野内每步保持在最大更新的水平并留下 e 时取等。',
     ['Optimum.valued_eq', 'Optimum.eq_of_add_eq_of_le', 'Optimum.mul_left_cancel_of_pos',
      'Optimum.open_valued_le_most', 'Optimum.valued_of_most', 'Optimum.valued_most_iff']),
    ('The order by what is drawn with v for each unit left. The steps of a course holding y and ending at any e within '
     'y with r, those ending at most at y their case; the course holding y and regrowing to y + r at the last step, '
     'drawing nothing after, is open and reaches the bound, and where no open course leaves more than y + r it is an '
     'optimum at every worth of at least one.',
     '按所抽取与每单位所留价值 v 的序。保持在 y、终于 y 加 r 以内任一 e 的进程的各步，终于至多 y 者是其情形；保持在 y、最后一步再生到 y + r、此后不再抽取的进程开放并达到此界，'
     '没有开放进程留下多于 y + r 时，它在每个至少为一的价值下都是最优。',
     ['Optimum.byDrawnLeftAt', 'Optimum.holdingTo_steps_of', 'Optimum.regrowing_valued',
      'Optimum.regrowing_frontier']),
    ('Where v > 1, every optimum of every order rising with that worth holds a level of greatest renewal at every step '
     'to the horizon and leaves y + r, regrown at the last step, and these are exactly the optima of the order by it.',
     'v 大于一时，随此价值升高之每个序的每个最优都在视野内每步保持在最大更新的水平并留下最后一步再生的 y + r，这些恰是按此价值之序的最优。',
     ['Optimum.frontier_holds_valued', 'Optimum.frontier_valued_iff']),
    ('At every worth of at least one, a coupling w of keeping a need at or above which at most q is given leaves only '
     'optima falling below the need within the horizon where w + q n < r n: keeping forgoes (r - q) n against the course '
     'regrowing at the end, whatever the worth.',
     '在每个至少为一的价值下，对保持所需（所需及以上至多给出 q）的耦合 w 在 w + q n < r n 时只留下在视野内跌到所需以下的最优：无论此值如何，相对于终了再生的进程保持放弃 (r - q) n。',
     ['Optimum.lt_of_valued_below', 'Optimum.frontier_breaks_valued']),
    ('On a web: above one, a dependence above every level of greatest renewal is broken at the first step, unmet through '
     'the horizon and met again only at its end; at every worth of at least one, a coupling short of (r - q) n leaves it '
     'broken within the horizon.',
     '在网上：价值大于一时，高于每个最大更新水平的依存在第一步被打破，在视野内不被满足，只在终了再被满足；在每个至少为一的价值下，不及 (r - q) n 的耦合使它在视野内被打破。',
     ['Web.frontier_rebuilt_valued', 'Web.frontier_breaks_valued']),
    ("Witness: under the logistic law from the dweller's need two, no open course stands above two; at every worth the "
     'course drawing the source to one and regrowing it to two at the last step is an optimum, above one the only kind, '
     'the dweller broken at the first step and restored at the end; a coupling below the horizon is outweighed.',
     '见证：逻辑斯谛律下自居者所需二出发，没有开放进程高于二；在每个价值下，把源抽到一并在最后一步再生到二的进程是最优，大于一时唯有此类，居者在第一步被打破、在终了恢复；不及视野的耦合被胜过。',
     ['Optimum.Holding.logistic_within', 'Optimum.Holding.logistic_open_le', 'Optimum.Holding.logistic_valued']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(x for x in P['modules'] if x['module'] == f'Becoming.{MOD}')['declarations']}
assert old_names <= set(full), old_names - set(full)
new = sorted(d for d in full if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
EARLIER = resolve(['Optimum.holdingTo', 'Optimum.holdingTo_steps', 'Optimum.OpenCourse', 'Optimum.drawnOver',
                   'Optimum.most_left_iff', 'Optimum.open_left_le_most', 'Optimum.Keeps', 'Optimum.keeping_le_most',
                   'Optimum.continued', 'Optimum.continued_open', 'Optimum.drops_of_not_keeps',
                   'Optimum.frontier_holds', 'Optimum.frontier_holds_left', 'Optimum.Holding.logistic',
                   'Optimum.Holding.onSource', 'Optimum.Holding.coupledDraw'])
n_new = len(new)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Valuing what is left at any worth', 'zh': '以任一价值对所留计值'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'At any worth above one for what is left, every optimum holds a level of greatest renewal through the '
              'horizon and regrows only at the last step, so a dependence above it is broken at once and restored at '
              'the end; a coupling of keeping is outweighed as without the value.',
        'zh': '对所留以大于一的任一价值计值时，每个最优都在视野内保持在最大更新的水平，只在最后一步再生，故高于它的依存立即被打破、在终了恢复；对保持的耦合如无此值时一样被胜过。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. A renewal law R of the level, at most r at every level and r at some y with y ≤ s + R s; a '
               'capacity k with s + R s ≤ y + k and r ≤ k; a horizon of at least two steps; no open course leaving more '
               'than y + r after it; a worth v of at least one (above one for the optima\'s characterization); for the '
               'coupling law, at most q given at or above the need; natural amounts, discrete steps.',
         'zh': '不加公理。水平的更新之律 R，各水平至多 r，在某个 y ≤ s + R s 处为 r；容量 k 满足 s + R s ≤ y + k 与 r ≤ k；视野至少两步；没有开放进程在视野之后留下多于 '
               'y + r；价值 v 至少为一（刻画最优时大于一）；对耦合之律，所需及以上至多给出 q；自然数量，离散步。'}],
    'does_not_show': [
        {'en': 'A worth on what is left where the most a course can leave is not regrown in one step from a level of '
               'greatest renewal.', 'zh': '最多所留不能在一步内从最大更新水平再生时对所留计值。', 'kind': 'scope'},
        {'en': 'That any terminal value keeps what depends on the levels passed through: a dependence above every level '
               'of greatest renewal is broken at the first step at every worth.',
         'zh': '任一终值保持依存于所经水平者：在每个价值下高于每个最大更新水平的依存都在第一步被打破。', 'kind': 'non-implication'},
        {'en': 'Several optimizers ranking courses; steps met again after a fall.', 'zh': '多个对过程排序的优化者；跌落后再被满足的步。',
         'kind': 'scope'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_new} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session; author review in study section {N}; not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {n_new} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A most left not regrown in one step; several optimizers ranking courses at a mutual best response; an '
              'independent review.',
        'zh': '最多所留不能一步再生的情形；多个对过程排序的优化者的相互最优回应；独立审查。'},
    'correspondence': {
        'en': 'The turnpike: a finite-horizon optimum stays on the path of greatest yield and departs from it only at the '
              'end (Dorfman, Samuelson and Solow 1958), the departure set by the terminal value; a quantity measured only '
              'at the end is managed for the measurement (Goodhart 1975).',
        'zh': '大道定理：有限视野的最优沿最大产出之路而行，只在终了离开（Dorfman、Samuelson 与 Solow 1958），离开的方式由终值决定；只在终了被度量的量为度量而被经营（Goodhart 1975）。'},
    'canonical_source': SRC,
    'aliases': ['valuing what is left at any worth', 'a terminal value above the worth of the draw', '以任一价值对所留计值',
                'Becoming.Optimum.frontier_holds_valued', 'Becoming.Web.frontier_rebuilt_valued'],
    'dependencies': [
        {'id': SG11, 'relation': 'formal-reuse',
         'detail': {'en': 'The bound on what is drawn and left is reused; the worth one for one is generalized to any worth '
                          'of at least one.',
                    'zh': '沿用所抽取与所留之界；一比一的价值推广到至少为一的任一价值。'},
         'interface': {
             'output': {'en': 'most_left_iff, open_left_le_most.', 'zh': 'most_left_iff、open_left_le_most。'},
             'input': {'en': 'The optima at any worth.', 'zh': '任一价值下的最优。'},
             'conditions': {'en': 'No open course leaving more than one step\'s regrowth.', 'zh': '没有开放进程留下多于一步再生者。'},
             'evidence': SRC}},
        {'id': SG6, 'relation': 'formal-reuse',
         'detail': {'en': "SG6's bound for keeping courses, its continued courses and its web form are reused.",
                    'zh': '沿用 SG6 对保持进程之界、其延续进程与其网之形式。'},
         'interface': {
             'output': {'en': 'keeping_le_most, continued, drops_of_not_keeps, coupledDraw.',
                        'zh': 'keeping_le_most、continued、drops_of_not_keeps、coupledDraw。'},
             'input': {'en': 'The coupling law at any worth.', 'zh': '任一价值下的耦合之律。'},
             'conditions': {'en': 'At most q given at or above the need.', 'zh': '所需及以上至多给出 q。'},
             'evidence': SRC}}],
    'related': [{'id': SG5, 'detail': {
        'en': 'Its holding steps are generalized below (holdingTo_steps_of); at worth nothing its optima drain at the end.',
        'zh': '其保持之步在下方推广（holdingTo_steps_of）；价值为零时其最优在终了抽干。'}}],
    'references': [{'path': SRC, 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(SRC)},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': SRC, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (SG12), valuing what is left at any worth: above one, every optimum holds a level of '
              f'greatest renewal and regrows only at the last step; a coupling of keeping is outweighed as without the '
              f'value; study section {N}.',
        'zh': f'2026年10月22日：新增（SG12），以任一价值对所留计值：价值大于一时，每个最优都保持在最大更新的水平，只在最后一步再生；对保持的耦合如无此值时一样被胜过；'
              f'研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
EN_SUBS = [('at another worth than what is drawn', 'at a worth whose most left is not regrown in one step'),
           ('at another worth than the draw', 'whose most left is not regrown in one step')]
ZH_SUBS = [('以不同于所汲取之价值', '以最多所留不能一步再生的价值'), ('与汲取不同价值之终值', '最多所留不能一步再生的终值'),
           ('与汲取不同价值的终值', '最多所留不能一步再生的终值')]
loaded = {}
for rid in [SG11, SG5, SG6, 'a-step-coupling-keeps-at-every-horizon', 'a-weighting-faster-than-renewal-ends-the-base',
            'optima-rebuild-a-depleted-base', 'others-drawing-first-end-the-base']:
    d = json.loads((RECORDS / f'{rid}.json').read_text())
    hits = {'en': 0, 'zh': 0}
    for lang, subs in (('en', EN_SUBS), ('zh', ZH_SUBS)):
        for x in list(d['does_not_show']) + [d['next_delta']]:
            for old, new_ in subs:
                if old in x[lang]:
                    hits[lang] += x[lang].count(old)
                    x[lang] = x[lang].replace(old, new_)
                    break
    assert hits['en'] == 2 and hits['zh'] == 2, (rid, hits)
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
        'en': 'At any worth above one for what is left, every optimum holds a level of greatest renewal and regrows only '
              'at the last step; a coupling of keeping is outweighed as without the value.',
        'zh': '对所留以大于一的任一价值计值时，每个最优都保持在最大更新的水平，只在最后一步再生；对保持的耦合如无此值时一样被胜过。'}}]
    d['history'].append({
        'en': f'22 October 2026, SG12: a worth on what is left other than one for one is answered where the most a course '
              f'can leave is regrown in one step (record {RID}, study section {N}); the open item now names the rest. Its '
              f'laws are unchanged.',
        'zh': f'2026年10月22日，SG12：最多所留能一步再生时，对所留以一比一之外的价值计值已回答（记录 {RID}，研究第 {N} 节）；开放项改为其余情形。其规律不变。'})
    loaded[rid] = d
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_new, 'declarations')
for rid, d in loaded.items():
    (RECORDS / f'{rid}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
