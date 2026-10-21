#!/usr/bin/env python3
"""Write SG8's record a-weighting-faster-than-renewal-ends-the-base (a theorem), note it in
horizon-optima-hold-the-greatest-renewal (whose far-sight it bounds), and give the coverage file's alignment and
degeneration rows the record and its law:
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
HEAD = f"## {N}. An order weighting later draws less (SG8)"
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


RID = 'a-weighting-faster-than-renewal-ends-the-base'
SG7 = 'a-step-coupling-keeps-at-every-horizon'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
HO = 'Optimum.Holding.'

laws = [
    ('With the draw of the step from t weighted by w t, any weighting: where each step leaves at most the level with '
     'what is given, what a course draws across n + 1 steps, weighted, with what it leaves weighted at the last, is '
     'what it could draw at the n-th with what it drew before; one step changes that by w (t + 1) on the level left with '
     'its renewal against w t on it held.',
     '以 w t 加权自 t 起一步的抽取（任意权重）：每步所留不超过水平加所给时，进程 n + 1 步的加权抽取加最后所留之加权，是它在第 n 步可抽取的连同之前所抽取的；一步使之变化 w (t + 1) 乘所留水平加其更新，对 w t 乘该水平。',
     ['Optimum.weightedOver', 'Optimum.drawable', 'Optimum.weighted_add_left', 'Optimum.drawable_step',
      'Optimum.add_steps']),
    ('Of two courses from one start, where the first\'s level gains at each step to the n-th at most what the second\'s '
     'does, the first could draw at most the second at every step, and less from a step where it gains less; with the '
     'second leaving nothing at the last step, the first draws at most the second, weighted, and less where it gains '
     'less at some step or leaves something weighted.',
     '同一起点的两个进程，前者的水平到第 n 步每步增益至多后者时，前者每步可抽取的至多后者，自增益较少之步起更少；后者最后不留时，前者加权抽取至多后者，在某步增益较少或留下加权之物时更少。',
     ['Optimum.drawable_le_of_gains', 'Optimum.drawable_lt_of_gains', 'Optimum.weighted_of_ends',
      'Optimum.weighted_le_of_gains', 'Optimum.weighted_lt_of_gains']),
    ('An open course leaving nothing whose level gains at each step at least what any level does is an optimum of the '
     'weighted draw; every optimum of every order rising with it leaves nothing weighted and gains at each step what '
     'that course\'s level gains, so stands below a need above which every level gains less, a dependence at that need, '
     'met at the start, broken at the first step.',
     '开放、最后不留、每步水平增益不少于任何水平的进程是加权抽取的最优；随它升高之序的每个最优最后不留加权之物，每步增益等于该进程水平的增益，故低于其上每个水平增益都较少的需要，起始时被满足的该处依存在第一步被打破。',
     ['Optimum.weighted_frontier', 'Optimum.frontier_gains_weighted', 'Optimum.frontier_below_weighted',
      'Web.frontier_broken_weighted']),
    ('The course holding y and leaving nothing is open over at least two steps, with a capacity covering the first '
     'step\'s draw down to y, y with its renewal and what is given at nothing; where y gains at each step at least what '
     'any level does, it is an optimum: the case of a reference course constant at every step.',
     '保持 y、最后不留的进程在至少两步上开放，若容量足以在第一步降到 y、承担 y 加其更新与零处所给；y 每步增益不少于任何水平时它是最优：每步不变的参照进程的情形。',
     ['Optimum.holding_open_at', 'Optimum.holding_gains', 'Optimum.weighted_holding_frontier']),
    ('Where w (t + 1) (z + R z) ≤ w t z for every positive z, nothing gains the most and the course ending the base at '
     'the first step is an optimum; where <, every optimum of every order rising with the weighted draw stands at '
     'nothing at every step to the n-th, breaking every dependence on the base with a positive need, met at the start.',
     '每个正的 z 都有 w (t + 1) (z + R z) ≤ w t z 时，零增益最大，在第一步终结基础的进程是最优；为 < 时，随加权抽取升高之序的每个最优到第 n 步每步都在零处，打破每个对基础、所需为正、起始时被满足的依存。',
     ['Optimum.outpaced_greatest', 'Optimum.outpaced_above', 'Optimum.exhausting_frontier',
      'Optimum.frontier_exhausts', 'Web.frontier_exhausts']),
    ('Where R 0 = 0 a course at nothing stays there. Where some y within reach gains more than nothing does at each '
     'step, the course holding y outdraws every course at nothing from the first step; so where R 0 = 0 and '
     'w t y < w (t + 1) (y + R y) at each step, with a capacity drawing down to y and holding it, no optimum stands at '
     'nothing at the first step.',
     'R 0 = 0 时在零处的进程留在零处。可及的某个 y 每步增益多于零时，保持 y 的进程比自第一步起在零处的每个进程抽取更多；故 R 0 = 0 且每步 w t y < w (t + 1) (y + R y)、容量足以降到 y 并保持时，没有最优在第一步处于零。',
     ['Optimum.stays_empty', 'Optimum.ended_outdrawn', 'Optimum.frontier_leaves', 'Web.frontier_leaves']),
    ('Witness: under the logistic law, from a source at two with capacity two, over n + 2 steps: where 2 w (t + 1) < w t '
     'every optimum ends the source at once and breaks the dweller; where w t = 2 w (t + 1) ending and holding at one '
     'are both optima; where w (t + 1) ≤ w t < 2 w (t + 1) every optimum holds it at one and breaks the dweller.',
     '见证：逻辑斯谛律下，自源二、容量二出发，n + 2 步：2 w (t + 1) < w t 时每个最优立即终结源并打破居者；w t = 2 w (t + 1) 时终结与保持在一都是最优；w (t + 1) ≤ w t < 2 w (t + 1) 时每个最优保持在一并打破居者。',
     [HO + n for n in ['logistic_le_self', 'logistic_outpaced_le', 'logistic_outpaced', 'logistic_beyond_gain',
                       'logistic_gain_le', 'logistic_gain_lt', 'logistic_gain_zero', 'pos_of_lt_two_mul',
                       'logistic_weighted']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.le_dest', 'Becoming.Naturals.add_sub_of_le',
                    'Becoming.Naturals.le_of_add_le_add_right', 'Becoming.mul_assoc_nat'],
        'World': ['Becoming.Web'],
        'Amounts': ['Becoming.Amounts.whole', 'Becoming.Amounts.sum'],
        'Dependence': ['Becoming.Web.Broken'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.OpenCourse', 'Becoming.Optimum.drawnAt', 'Becoming.Optimum.holding',
           'Becoming.Optimum.holding_before', 'Becoming.Optimum.holding_after', 'Becoming.Optimum.holding_within',
           'Becoming.Optimum.holdingTo_open', 'Becoming.Optimum.Holding.logistic',
           'Becoming.Optimum.Holding.logistic_beyond', 'Becoming.Optimum.Holding.onSource']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'A weighting falling faster than renewal ends the base', 'zh': '权重下降快于更新时终结基础'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Under an order weighting later draws less, every optimum gains at each step what a course of greatest '
              'weighted gain does; where the weighting falls faster than every positive level renews, every optimum '
              'ends its own base at the first step; where a level within reach renews faster, none does.',
        'zh': '在后来的汲取权重更小之序下，每个最优每步的增益等于最大加权增益进程的增益；权重下降快于每个正水平的更新时，每个最优在第一步终结自己的基础；可及的某水平更新更快时，没有最优这样做。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts, natural weights. Courses open from s; a renewal law R; n + 1 '
               'steps, 0 < n; a reference course open from s, leaving nothing at the last step, whose level gains at '
               'each step at least what any level does; capacities covering the first step\'s draw down and, for '
               'leaving, a level held with its renewal; R 0 = 0 for leaving.',
         'zh': '不加公理。离散步、自然数量与自然数权重。自 s 开放的过程；更新之律 R；n + 1 步且 0 < n；自 s 开放、最后不留、每步水平增益不少于任何水平的参照进程；容量足以在第一步降下，'
               '对不终结之律还须承担所保持的水平加其更新；不终结之律另需 R 0 = 0。'},
        {'en': 'For the web laws, a dependence met at the start, with a positive need or a need above every level of '
               'greatest weighted gain. Which formation optimizes, by which order, weighting, capacity and horizon, and '
               'the renewal law are supplied; the core asserts no course of any actual optimizer.',
         'zh': '对网之律：起始时被满足的依存，所需为正或高于每个最大加权增益水平。哪个构成优化、按何序、权重、容量与视野，以及更新之律，都是给定的；核心不对任何实际优化者的过程作断言。'}],
    'does_not_show': [
        {'en': 'The optimum where no course whose level gains the most at each step is open; whether an optimum ends '
               'the base after the first step where some level renews faster at the first steps.',
         'zh': '没有每步水平增益最大的开放进程时的最优；某水平只在开头几步更新更快时，最优是否在第一步之后终结基础。', 'kind': 'scope'},
        {'en': 'An order valuing what is left at the horizon; steps met again after a fall; rebuilding from below; '
               'several optimizers ranking courses; SG5\'s laws re-derived as the case of every weight one.',
         'zh': '对视野末所留赋值之序；跌落后再被满足的步；自下重建；多个对过程排序的优化者；把 SG5 的律作为权重皆为一的情形重新导出。', 'kind': 'scope'},
        {'en': 'That a weighting ought to be flatter or a base kept: no evaluation enters; the laws say which optima a '
               'weighting leaves.',
         'zh': '权重应当更平或基础应被保持：没有评价进入；这些律只说一个权重留下哪些最优。', 'kind': 'non-implication'}],
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
        'en': 'The optimum where no reference course is open; ending after the first step; an order valuing what is '
              'left at the horizon; rebuilding from below; several optimizers ranking courses; an independent review.',
        'zh': '没有开放参照进程时的最优；第一步之后的终结；对视野末所留赋值之序；自下重建；多个对过程排序的优化者；独立审查。'},
    'correspondence': {
        'en': 'Discounting (Ramsey 1928; Koopmans 1960); at a constant rate δ a level\'s weighted gain is w (t + 1) '
              '(R z − δ z), so the level held is the modified golden rule\'s, where the marginal renewal equals the rate '
              '(Clark and Munro 1975); a sole owner finding extinction optimal where the rate exceeds the greatest rate '
              'of renewal (Clark 1973); the discount factor of reinforcement learning (Sutton and Barto 1998); a rate '
              'changing with delay (Ainslie 1975). On the spine the laws cover every order rising with the weighted '
              'draw and any weighting, through a reference course whose level gains the most at each step; the '
              'threshold is exact, the tie admitting both ending and holding; the break is a law of the dependence '
              'web. Reading (the AI\'s): far-sight keeps the optimizer\'s own base only where its weighting falls '
              'slower than the base renews.',
        'zh': '折现（Ramsey 1928；Koopmans 1960）；常率 δ 下水平的加权增益为 w (t + 1) (R z − δ z)，故所保持的是修正黄金律的水平，边际更新等于该率（Clark 与 Munro 1975）；'
              '率超过最大更新率时独占者认为灭绝最优（Clark 1973）；强化学习的折扣因子（Sutton 与 Barto 1998）；随延迟变化的率（Ainslie 1975）。在脊柱上，这些律覆盖每个随加权抽取升高之序'
              '与任意权重，经由每步水平增益最大的参照进程；阈值精确，相持处终结与保持都是最优；打破是依存网之律。读法（AI 的）：远见只在权重下降慢于基础更新时才保住优化者自身的基础。'},
    'canonical_source': src(OM),
    'aliases': ['a weighting falling faster than renewal ends the base', 'an order weighting later draws less',
                'discounting ends the base', 'the modified golden rule on the spine', '权重下降快于更新时终结基础',
                'Becoming.Optimum.frontier_gains_weighted', 'Becoming.Optimum.frontier_exhausts',
                'Becoming.Web.frontier_exhausts'],
    'dependencies': [
        dep(SG5, 'formal-reuse',
            'The open courses and what a course draws at a step (drawnAt); the course holding a level and leaving '
            'nothing, its steps and its openness; the logistic law of the witness. SG5\'s order counts every step '
            'alike; this record weights them.',
            '开放的过程与进程在一步所抽取（drawnAt）；保持某一水平、最后不留的进程，其各步与开放性；见证的逻辑斯谛律。SG5 的序同等计每一步；本记录对它们加权。',
            'What a course draws over a horizon, and the course holding a level.', '进程在视野上所抽取，以及保持某一水平的进程。',
            'What a course draws over a horizon, weighted, and the reference course of greatest weighted gain.',
            '进程在视野上的加权抽取，以及最大加权增益的参照进程。',
            'Each step leaving at most the level with what is given.', '每步所留不超过水平加所给。',
            src(OM)),
        dep(SG7, 'formal-reuse',
            'holdingTo_open, the openness of a course holding a level and ending lower, through which the holding '
            'course is shown open.',
            'holdingTo_open，保持某一水平、终于较低处的进程的开放性，保持的进程经由它被证明开放。',
            'The openness of a holding course.', '保持的进程的开放性。',
            'The openness of the reference course in the holding case.', '保持情形中参照进程的开放性。',
            'Capacities covering the first step and the level held.', '容量足以承担第一步与所保持的水平。',
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
        {'id': SG5, 'detail': {'en': 'Far-sight keeps the optimizer\'s own base; here only where the weighting falls '
                                     'slower than the base renews.',
                               'zh': '远见保住优化者自身的基础；此处只在权重下降慢于基础更新时。'}},
        {'id': SG7, 'detail': {'en': 'A coupling a step keeps a dependence at every horizon; here what a weighting does '
                                     'to the optimizer\'s own base.',
                               'zh': '每步的耦合在每个视野都保持依存；此处为权重对优化者自身基础的作用。'}}],
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
        'en': f'21 October 2026: added (SG8), an order weighting later draws less: every optimum gains at each step what '
              f'a course of greatest weighted gain does; where the weighting falls faster than every positive level '
              f'renews every optimum ends its own base at the first step; where a level within reach renews faster none '
              f'does; at the tie both are optima in the witness; study section {N}.',
        'zh': f'2026年10月21日：新增（SG8），后来的汲取权重更小之序：每个最优每步的增益等于最大加权增益进程的增益；权重下降快于每个正水平的更新时，每个最优在第一步终结自己的基础；'
              f'可及的某水平更新更快时没有最优这样做；见证中相持处两者都是最优；研究第 {N} 节。'}],
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

# SG5's record: a note; its laws are unchanged.
p = RECORDS / f'{SG5}.json'
d = json.loads(p.read_text())
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'An order weighting later draws less: far-sight keeps the own base only where the weighting falls slower than '
          'the base renews; falling faster than every positive level renews, every optimum ends it at the first step.',
    'zh': '后来的汲取权重更小之序：远见只在权重下降慢于基础更新时保住自身的基础；下降快于每个正水平的更新时，每个最优在第一步终结它。'}}]
d['history'].append({
    'en': f'21 October 2026, SG8: under an order weighting later draws less, every optimum gains at each step what a '
          f'course of greatest weighted gain does, and ends its own base at the first step where the weighting falls '
          f'faster than every positive level renews (record {RID}, study section {N}); this record\'s laws and their '
          'statements are unchanged.',
    'zh': f'2026年10月21日，SG8：在后来的汲取权重更小之序下，每个最优每步的增益等于最大加权增益进程的增益，权重下降快于每个正水平的更新时在第一步终结自己的基础（记录 {RID}，研究第 {N} 节）；'
          '本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', SG5)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid in ['alignment', 'degeneration']:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(SG7) + 1, RID)
    row['declarations'].insert(row['declarations'].index('Becoming.Web.frontier_keeps_stepwise') + 1,
                               'Becoming.Web.frontier_exhausts')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
