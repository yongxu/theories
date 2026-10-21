#!/usr/bin/env python3
"""Write SG10's record others-drawing-first-end-the-base (a theorem), note it in
a-weighting-faster-than-renewal-ends-the-base and optima-rebuild-a-depleted-base (whose laws are now the case of the
laws over every law of what stands), and give the coverage file's alignment and degeneration rows the record and its
laws:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

The laws cite exactly the declarations Becoming.Optimum gained since the previous receipt. Every declaration cited is
resolved against the receipt's audited declarations (a short name must match exactly one declaration of the named
module), and the receipt must bind each cited module's current bytes."""
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
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. Over every law of what stands (SG10)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'others-drawing-first-end-the-base'
SG8 = 'a-weighting-faster-than-renewal-ends-the-base'
SG9 = 'optima-rebuild-a-depleted-base'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SG3 = 'several-optimizers-drain-by-their-joint-capacity'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
NX = 'Optimum.Next.'
WN = 'Web.Next.'
HO = 'Optimum.Holding.'

laws = [
    ('Under any law G of what stands, a level z at the step from t giving G t z: what could be drawn changes from step '
     'to step by what stands at the level left, weighted at the next step, against it held; a course gaining the most '
     'against every open course and leaving nothing is an optimum, every optimum gains what it does, and every optimum '
     'stands below a need above every level of greatest gain.',
     '在任一“所立之律” G 下（水平 z 在自 t 之步给出 G t z）：可抽取者每步按所留水平处所立者（下一步加权）对其被保持（本步加权）而变；对每个开放进程增益最大且最后不留的进程是最优，每个最优增益与它相同，并低于每个最大增益水平之上的需要。',
     [NX + n for n in ['Open', 'weighted', 'drawable', 'weighted_add_left', 'drawable_step', 'drawable_le_of_gains',
                       'drawable_lt_of_gains', 'weighted_of_ends', 'weighted_le_of_gains', 'weighted_lt_of_gains',
                       'GainsMost', 'gainsMost_of_greatest', 'frontier_of_gainsMost', 'frontier_gains_of_most',
                       'frontier_below']] + [WN + 'frontier_broken']),
    ('Holding a level y of greatest weighted gain, where what stands at y is at least y, is an optimum; where the '
     'weighting falls faster than what stands at every positive level rises over it, every optimum ends the base at '
     'once, breaking every dependence on it; where nothing stands at nothing and some level within reach rises faster, '
     'no optimum ends it at once.',
     '在 y 处所立者不少于 y 时，保持最大加权增益的水平 y 是最优；权重下降快于每个正水平处所立者高出水平之速时，每个最优立即终结基础，破坏对它的每个依存；零处无所立且某可及水平升得更快时，没有最优立即终结它。',
     [NX + n for n in ['holding_within', 'holding_open', 'holding_frontier', 'outpaced_greatest', 'outpaced_above',
                       'exhausting_frontier', 'frontier_exhausts', 'ended_outdrawn', 'stays_empty',
                       'frontier_leaves']] + [WN + 'frontier_exhausts', WN + 'frontier_leaves']),
    ('Where what stands rises with the level below y and is at least y at y, nothing open rises faster than the course '
     'rising as fast as what stands allows; where the weighted gain rises up to y and is greatest there, that course is '
     'an optimum; where it rises strictly, every optimum follows it below y, drawing nothing, restoring every dependence '
     'whose need it meets, and stands at y after where y gains the most strictly.',
     '所立者在 y 之下随水平上升且在 y 处不少于 y 时，没有开放进程比按所立尽快上升的进程升得更快；加权增益升至 y 且在那里最大时它是最优；严格上升时，每个最优在 y 之下随它、不抽取，恢复其需要被满足的每个依存，y 增益严格最大时此后处于 y。',
     [NX + n for n in ['rise', 'rebuilding', 'rise_succ', 'rise_le', 'rise_le_top', 'rise_within', 'rise_of_below',
                       'rise_at_top', 'rise_below_before', 'rise_stays', 'le_rise', 'rebuilding_before',
                       'rebuilding_after', 'rebuilding_at', 'rebuilding_within', 'rebuilding_le_cap', 'rebuilding_open',
                       'rebuilding_gainsMost', 'rebuilding_frontier', 'frontier_rebuilds', 'frontier_rebuilt']]
     + [WN + 'frontier_rebuilds']),
    ('Where at each step what stands at a level is at most the level, every optimum of every order whose weighting falls '
     'at every step stands at nothing from the first step; where it is less than every positive level, so under positive '
     'weights rising at no step. Where others first leave K t z of z and that renews by R, what stands is '
     'K t z + R (K t z), and every dependence on the base is broken at the first step.',
     '每步各水平处所立者不超过水平时，权重每步下降之序的每个最优自第一步起处于零；少于每个正水平时，正且不上升的权重下亦然。他者先从 z 中留下 K t z、它按 R 更新时，所立者为 K t z + R (K t z)，对基础的每个依存在第一步被破坏。',
     [NX + n for n in ['leftBy', 'frontier_ends_of_le', 'frontier_ends_of_lt', 'frontier_ends_drawn_first',
                       'frontier_ends_drawn_more']] + [WN + 'frontier_ends_drawn_first', WN + 'frontier_ends_drawn_more']),
    ('Witness: a source doubling up to eight, from two, capacity sixteen, over n + 3 steps: under w (t + 1) ≤ w t < '
     '2 w (t + 1), alone every optimum stands at four, then eight; with others first drawing all but a quarter, every '
     'optimum ends it and breaks the dweller; drawing all but half, every optimum ends it under weights falling at every '
     'step, and at equal weights ending and holding at two are both optima.',
     '见证：源每级翻倍至八，自二、容量十六、n + 3 步：w (t + 1) ≤ w t < 2 w (t + 1) 下，单独时每个最优处于四、再八；他者先抽取到只剩四分之一时，每个最优终结它并破坏居者；只剩一半时，权重每步下降下每个最优终结它，同权时终结与保持在二都是最优。',
     [HO + n for n in ['halved', 'halved_twice', 'halved_left_le', 'halved_lt', 'quartered_left_lt', 'halfLeft',
                       'quarterLeft', 'linear_falls', 'doubling_drawn_first', 'doubling_drawn_first_linear']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
# The renewal forms of lemmas no law reads any more, and the definition `drawable`: their general forms in
# Optimum.Next replace them (rule 9).
GONE = ['weighted_add_left', 'drawable_step', 'drawable_le_of_gains', 'drawable_lt_of_gains', 'weighted_of_ends',
        'weighted_le_of_gains', 'weighted_lt_of_gains', 'outpaced_greatest', 'outpaced_above', 'ended_outdrawn',
        'stays_empty', 'rise_succ', 'rise_le', 'rise_le_top', 'rise_within', 'rise_of_below', 'rise_at_top',
        'rise_below_before', 'le_rise', 'rebuilding_before', 'rebuilding_after', 'rebuilding_at', 'rebuilding_within',
        'rebuilding_le_cap', 'rebuilding_open', 'rebuilding_gainsMost', 'drawable']
REMOVED = {f'Becoming.Optimum.{n}': f'Becoming.Optimum.Next.{n}' for n in GONE}
assert old_names - set(OMfull) == set(REMOVED), (old_names - set(OMfull)) ^ set(REMOVED)
assert set(REMOVED.values()) <= set(OMfull)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.le_dest', 'Becoming.Naturals.add_sub_of_le', 'Becoming.Naturals.add_sub_cancel_left',
                    'Becoming.Naturals.le_of_add_le_add_right'],
        'World': ['Becoming.Web'],
        'Amounts': ['Becoming.Amounts.whole', 'Becoming.Amounts.sum'],
        'Dependence': ['Becoming.Web.Broken'],
        'Restoration': ['Becoming.Web.RestoredWithin'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.OpenCourse', 'Becoming.Optimum.drawnAt', 'Becoming.Optimum.holding',
           'Becoming.Optimum.holding_before', 'Becoming.Optimum.holding_after', 'Becoming.Optimum.add_steps',
           'Becoming.Optimum.holding_gains', 'Becoming.Optimum.sub_le_sub_right_of_le',
           'Becoming.Optimum.weightedOver', 'Becoming.Optimum.GainsMost',
           'Becoming.Optimum.rise', 'Becoming.Optimum.rebuilding', 'Becoming.Optimum.frontier_rebuilds',
           'Becoming.Optimum.frontier_rebuilt', 'Becoming.Optimum.rise_stays', 'Becoming.Optimum.frontier_exhausts',
           'Becoming.Optimum.Holding.doubling', 'Becoming.Optimum.Holding.doubling_low',
           'Becoming.Optimum.Holding.doubling_high', 'Becoming.Optimum.Holding.doubling_grows',
           'Becoming.Optimum.Holding.doubling_rises', 'Becoming.Optimum.Holding.doubling_rises_strictly',
           'Becoming.Optimum.Holding.doubling_top', 'Becoming.Optimum.Holding.doubling_above',
           'Becoming.Optimum.Holding.mul_lt_of_pos', 'Becoming.Optimum.Holding.pos_of_lt_two_mul',
           'Becoming.Optimum.Holding.onSource']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Others drawing first end the base', 'zh': '他者先抽取则终结基础'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'The far-sighted weighted optimum laws hold over any law of what stands; where others first draw from what '
              'an optimizer leaves at least what the remainder renews, every optimum of an order whose weighting falls '
              'at every step ends the base at once.',
        'zh': '远见加权最优之律对任一“所立之律”成立；他者先从优化者所留中抽取不少于剩余之更新时，权重每步下降之序的每个最优都立即终结基础。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts, natural weights. Any law G of what stands; holding or rising '
               'to y needs what stands at y at least y; otherwise the premises of SG8\'s and SG9\'s laws with G t z for '
               'z + R z. For others drawing first: what they leave of every level, with its renewal, at most the level '
               'and a weighting falling at every step, or less and positive weights rising at no step.',
         'zh': '不加公理。离散步、自然数量与自然数权重。任一“所立之律” G；保持或升至 y 需 y 处所立者不少于 y；其余为 SG8、SG9 之律的前提，以 G t z 代 z + R z。他者先抽取：所留连同更新不超过水平且权重每步下降，或少于水平且权重为正不上升。'},
        {'en': 'A capacity covering what stands at the start and at nothing; for the web laws, a dependence met at the '
               'start with a positive need. The others\' draws are a supplied rule reading the level; which formation '
               'optimizes, by which order, weighting, capacity and horizon, and the law of what stands are supplied.',
         'zh': '容量足以承担起点处与零处所立者；对网之律，起始时被满足、需要为正的依存。他者的抽取是读取水平的给定规则；哪个构成优化、按何序、权重、容量与视野，以及所立之律，都是给定的。'}],
    'does_not_show': [
        {'en': 'That the others\' rule is itself a best response: this is one optimizer\'s side of the dynamic commons, '
               'not a mutual best response among several optimizers ranking courses, nor how optimizers come to one.',
         'zh': '他者的规则本身是最优回应：这是动态公地中一个优化者的一侧，不是多个对过程排序的优化者之间的相互最优回应，也不是优化者如何达到它。', 'kind': 'scope'},
        {'en': 'Holding a level where what stands at it falls below it; an order valuing what is left at the horizon; '
               'steps met again after a fall; an overcompensating renewal.',
         'zh': '在其处所立者低于它的水平上保持；对视野末所留赋值之序；跌落后再被满足的步；过度补偿的更新。', 'kind': 'scope'},
        {'en': 'That a base ought to be kept, or that others ought not to draw: no evaluation enters; the laws say what '
               'the optima of an order do.',
         'zh': '基础应当被保持，或他者不应抽取：没有评价进入；这些律只说一个序的最优做什么。', 'kind': 'non-implication'}],
    'counterexamples': [],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed '
              'by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Several optimizers each ranking courses at a mutual best response, and how they come to one; an order '
              'valuing what is left at the horizon; steps met again after a fall; an overcompensating renewal; an '
              'independent review.',
        'zh': '多个各自对过程排序的优化者的相互最优回应及其如何达到；对视野末所留赋值之序；跌落后再被满足的步；过度补偿的更新；独立审查。'},
    'correspondence': {
        'en': 'Open access dissipates the rent of a common stock, what one harvester leaves being taken by another '
              '(Gordon 1954); in the dynamic commons each player\'s far-sight is cut by the others\' draws, the '
              'equilibrium stock falling as players are added (Levhari and Mirman 1980; Clark 1990). On the spine, one '
              'optimizer\'s side, exact for every order rising with the weighted draw: the threshold for ending the base '
              'at once moves from what the base renews to what the others\' leaving renews, and the same order that '
              'rebuilds the base alone ends it among others. The far-sighted laws hold over any law of what stands, '
              'decay and changing renewal among the cases. Reading (the AI\'s): keeping a shared base is not one '
              'optimizer\'s to give; the destruction comes from the relation, not from any change in the optimizer.',
        'zh': '开放进入耗散共有存量的租金，一个收获者所留被另一个拿走（Gordon 1954）；在动态公地中，每个参与者的远见被他者的抽取削减，均衡存量随参与者增加而下降（Levhari 与 Mirman 1980；Clark 1990）。'
              '在脊柱上是一个优化者的一侧，对随加权抽取升高的每个序都精确：立即终结基础的阈值从基础的更新移到他者所留的更新，单独时重建基础的同一序在他者之中终结它。'
              '远见之律对任一所立之律成立，衰减与变化的更新都是其情形。读法（AI 的）：保持共享的基础不是一个优化者所能给予的；破坏来自关系，而非优化者的任何改变。'},
    'canonical_source': src(OM),
    'aliases': ['others drawing first end the base', 'over every law of what stands', 'the dynamic commons',
                'open-access dissipation', '他者先抽取则终结基础', 'Becoming.Optimum.Next.frontier_ends_drawn_first',
                'Becoming.Web.Next.frontier_ends_drawn_first', 'Becoming.Optimum.Next.frontier_exhausts'],
    'dependencies': [
        dep(SG8, 'formal-reuse',
            'Every law of the weighted draw restated over any law of what stands; this record\'s laws are now the case '
            'where what stands is the level with its renewal.',
            '加权抽取的每条规律对任一所立之律重述；该记录之律现为所立者为水平加更新的情形。',
            'The weighted draw, the comparison against a course gaining the most and ending at once.',
            '加权抽取、相对于增益最大进程的比较与立即终结。',
            'The same laws over any law of what stands.', '同样的规律，对任一所立之律。',
            'Natural weights; courses open from a start.', '自然数权重；自起点开放的过程。',
            src(OM)),
        dep(SG9, 'formal-reuse',
            'Rebuilding from below restated over any law of what stands; the witness\'s alone branch uses its laws.',
            '自下重建对任一所立之律重述；见证的单独分支用其规律。',
            'The rising and rebuilding courses and every optimum following them.', '上升与重建的进程，及随之的每个最优。',
            'The same over any law of what stands, with what stands at y at least y.', '对任一所立之律同样成立，y 处所立者不少于 y。',
            'What stands rising with the level below y.', '所立者在 y 之下随水平上升。',
            src(OM)),
        dep(SG5, 'formal-reuse',
            'The holding course, what a step draws (drawnAt) and the open courses, of which the general open courses are '
            'the form over any law.',
            '保持的进程、一步所抽取（drawnAt）与开放的过程，一般的开放过程是其对任一律的形式。',
            'The courses open from a start.', '自起点开放的过程。',
            'The courses open under a law of what stands.', '在所立之律下开放的过程。',
            'Each step leaving at most what stands and drawing at most k.', '每步所留不超过所立者、所抽取至多 k。',
            src(OM)),
        dep(SEEN, 'formal-reuse',
            'The optima are the frontier of an order (Requirement.Frontier); the witness uses the Diversion places and '
            'web, the dweller depending on the source at need two.',
            '最优是一个序的前沿（Requirement.Frontier）；见证用 Diversion 的处所与网，居者在需要二处依存于源。',
            'The frontier of an order rising with what the part gains.', '随部分所得升高之序的前沿。',
            'The frontier over courses ranked by the weighted draw.', '按加权抽取排序的过程上的前沿。',
            'An order rising with the weighted draw across the horizon.', '随视野内加权抽取升高之序。',
            src(OM))],
    'related': [
        {'id': SG3, 'detail': {'en': 'In one step several optimizers at a mutual best response drain as one; over a '
                                     'course, others drawing first end what far-sight alone keeps.',
                               'zh': '一步中多个处于相互最优回应的优化者如一般耗竭；在过程上，他者先抽取则终结远见单独时所保持者。'}},
        {'id': SG9, 'detail': {'en': 'Alone, every optimum rebuilds a depleted base; with others drawing first, the same '
                                     'order ends it.',
                               'zh': '单独时每个最优重建耗竭的基础；他者先抽取时，同一序终结它。'}}],
    'references': [{'path': src(OM), 'role': 'proof', 'declarations': sorted(new + EARLIER), 'sha256': sha(src(OM))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [OM] + [m for m, _ in refs_used]],
    'history': [{
        'en': f'21 October 2026: added (SG10), over every law of what stands: SG8\'s and SG9\'s laws hold over any law '
              f'of what a level gives at a step, the renewal law the case; where others first draw from what an '
              f'optimizer leaves at least what the remainder renews, every optimum of an order whose weighting falls at '
              f'every step ends the base at once; study section {N}.',
        'zh': f'2026年10月21日：新增（SG10），对每一所立之律：SG8 与 SG9 之律对一个水平在一步给出什么的任一律成立，更新之律是其情形；他者先从优化者所留中抽取不少于剩余之更新时，'
              f'权重每步下降之序的每个最优立即终结基础；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500, (
    len(rec['correspondence']['en']), len(rec['correspondence']['zh']))
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, len(new), 'declarations')

# SG8's and SG9's records: a note; the laws still read in the renewal form are unchanged in statement, now the case
# over every law of what stands, and the removed renewal forms are cited by their general forms.


def remap(names):
    out = []
    for n in names:
        n = REMOVED.get(n, n)
        if n not in out:
            out.append(n)
    return out


for rid, which in [(SG8, 'SG8'), (SG9, 'SG9')]:
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    moved = 0
    for law in d['laws']:
        moved += sum(n in REMOVED for n in law['declarations'])
        law['declarations'] = remap(law['declarations'])
    for ref in d['references']:
        if 'declarations' in ref:
            ref['declarations'] = remap(ref['declarations'])
    d['aliases'] = remap(d.get('aliases', []))
    text = json.dumps(d, ensure_ascii=False)
    left = [n for n in GONE if re.search(r'(?<![.\w])(Becoming\.)?Optimum\.' + n + r'(?![\w])', text)]
    assert not left, (rid, left)
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
        'en': 'Over every law of what stands: these laws hold over any law of what a level gives at a step; with others '
              'drawing first, every optimum of a falling weighting ends the base at once.',
        'zh': '对每一所立之律：这些规律对一个水平在一步给出什么的任一律成立；他者先抽取时，权重下降之序的每个最优立即终结基础。'}}]
    d['history'].append({
        'en': f'21 October 2026, SG10: this record\'s laws hold over every law of what stands (Optimum.Next, Web.Next; '
              f'record {RID}, study section {N}), the level with its renewal the case. Those still read in the renewal '
              f'form keep their statements, each proof now one line; the renewal forms no law reads any more were '
              f'removed, and this record cites their general forms ({moved} law citations moved, the proof references with them).',
        'zh': f'2026年10月21日，SG10：本记录之律对每一所立之律成立（Optimum.Next、Web.Next；记录 {RID}，研究第 {N} 节），'
              f'水平加更新是其情形。仍以更新形式被读取者陈述不变，每个证明现为一行；不再被任何规律读取的更新形式已移除，'
              f'本记录改引其一般形式（规律中移动 {moved} 处引用，证明引用随之）。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid in ['alignment', 'degeneration']:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(SG9) + 1, RID)
    row['declarations'].insert(row['declarations'].index('Becoming.Web.frontier_rebuilds') + 1,
                               'Becoming.Web.Next.frontier_ends_drawn_first')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
