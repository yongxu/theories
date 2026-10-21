#!/usr/bin/env python3
"""Write SG7's record a-step-coupling-keeps-at-every-horizon (a theorem), note it in
keeping-forgoes-the-renewal-at-the-need (whose keeps_or_drops is now the case of keeps_or_falls), and give the coverage
file's alignment and degeneration rows the record and its law:
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
HEAD = f"## {N}. A coupling added for each step a dependence is kept (SG7)"
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


RID = 'a-step-coupling-keeps-at-every-horizon'
SG6 = 'keeping-forgoes-the-renewal-at-the-need'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
HO = 'Optimum.Holding.'

laws = [
    ('A course from a start meeting m either keeps it through the n + 1 steps of a horizon or falls below m, at some '
     'step to the n-th, after standing at m or above at every step to it; that it falls from a level meeting m is the '
     'case.',
     '自满足 m 的起点出发的过程，或在视野的 n + 1 步中一直保持 m，或在到第 n 步的某步、在此前每步都在 m 或之上之后落到 m 之下；它自满足 m 的水平落下是其情形。',
     ['Optimum.keeps_or_falls']),
    ('Where what is given at each of the first j of n steps is at most q, j r is at most what is given falls short of '
     'r across the n steps with j q; so with R ≤ r, and ≤ q at or above m, a course at m or above at every step to the '
     'j-th, j ≤ n, draws across n + 1 steps, with j r, at most the start with what is given there, r n and j q; under '
     'balance, what is taken likewise.',
     '前 n 步中前 j 步每步所给至多 q 时，j r 至多是 n 步中所给不足 r 之和加 j q；故 R ≤ r、在不低于 m 处 ≤ q 时，到第 j 步（j ≤ n）每步都在 m 或之上的过程，n + 1 步所汲取加 j r 至多是起点加那里所给、r n 与 j q；平衡时所取亦然。',
     ['Optimum.le_sub_add_of_le', 'Optimum.shortfall_ge', 'Optimum.met_drawn_le', 'Flow.Balances.met_taken_le']),
    ('For a worth adding at least c a step to a keeping course and at most c for each step met to a course falling '
     'below m, with q at a reachable y and the keeping course ending at e from m to y: where r ≤ q + c and e < c, every '
     'optimum of every order rising with it keeps m through the horizon, whatever n, a dependence at need m kept; with '
     'm < c the continued keeping course is one.',
     '对保持的过程每步至少加 c、对落到 m 之下的过程每满足一步至多加 c 的值，q 在可及的 y 处、保持的过程终于 m 到 y 之间的 e：r ≤ q + c 且 e < c 时，随此值升高之序的每个最优都在视野内保持 m，无论 n，需要 m 处的依存被保持；m < c 时延续的保持过程是其一。',
     ['Optimum.stepwise_arith', 'Optimum.lt_of_stepwise', 'Optimum.frontier_keeps_stepwise',
      'Optimum.continued_stepwise_frontier', 'Web.frontier_keeps_stepwise']),
    ('For a worth adding at most c for each step met to a course falling below m and at least c for each of the first n '
     'steps to one meeting m at each: where r < q + c and y + q ≤ k, every optimum stands at m or above at every step to '
     'the n-th, a dependence at need m met there.',
     '对落到 m 之下的过程每满足一步至多加 c、对前 n 步每步都满足 m 的过程每步至少加 c 的值：r < q + c 且 y + q ≤ k 时，每个最优到第 n 步每步都在 m 或之上，需要 m 处的依存在那里被满足。',
     ['Optimum.stepwise_arith_lt', 'Optimum.lt_of_stepwise_end', 'Optimum.frontier_met_before_end',
      'Web.frontier_met_before_end']),
    ('The holding course stands at m or above to the n-th step. For a worth adding at most c a step to a keeping course '
     'and at least c for each of the first n steps to a course meeting m at each: where c + e < m, e the end the '
     'capacity reaches, no optimum keeps m and the dependence breaks within the horizon; where also r < q + c and c < m, '
     'at the n-th step alone.',
     '保持的过程到第 n 步都在 m 或之上。对保持的过程每步至多加 c、对前 n 步每步都满足 m 的过程每步至少加 c 的值：c + e < m（e 为容量可及的终点）时没有最优保持 m，依存在视野内被打破；再有 r < q + c 且 c < m 时只在第 n 步。',
     ['Optimum.holdingTo_met', 'Optimum.frontier_breaks_at_end', 'Web.frontier_breaks_at_end',
      'Web.frontier_breaks_last']),
    ('For a worth adding exactly c for each step met, where r ≤ q + c and c ≤ m, the continued course meeting m to the '
     'n-th step and ending at nothing is an optimum.',
     '对每满足一步恰加 c 的值，r ≤ q + c 且 c ≤ m 时，到第 n 步满足 m、终于零的延续过程是最优。',
     ['Optimum.stepwise_arith_le', 'Optimum.le_of_stepwise_end', 'Optimum.continued_ending_stepwise_frontier']),
    ('Where q + c < r, a coupling of at most c a step with c + e < n + m falls below what keeping forgoes, so every '
     'optimum breaks the dependence within the horizon; where q + c ≤ r and c ≤ m the continued course holding where R '
     'gives r is an optimum.',
     'q + c < r 时，每步至多 c 且 c + e < n + m 的耦合低于保持所放弃者，故每个最优都在视野内打破依存；q + c ≤ r 且 c ≤ m 时，保持在 R 给 r 处的延续过程是最优。',
     ['Optimum.outweighed_stepwise', 'Web.frontier_breaks_stepwise_long', 'Optimum.continued_holding_stepwise_frontier']),
    ('Witness: under the logistic law, from the dweller\'s need two with capacity two, the taker\'s draw with c added '
     'for each step the source stays at two or above from the start, over n + 2 steps: where 3 ≤ c every optimum keeps '
     'the dweller, where 2 ≤ c every optimum meets it to the last step, where 1 ≤ c ≤ 2 the course ending at nothing '
     'there is an optimum, where c ≤ 1 every optimum breaks it.',
     '见证：逻辑斯谛律下，自居者的需要二、容量二出发，取者的汲取在源自起点起每保持在二或之上一步时加 c，n + 2 步：3 ≤ c 时每个最优都保持居者，2 ≤ c 时每个最优保持到最后一步，1 ≤ c ≤ 2 时在那里终于零的过程是最优，c ≤ 1 时每个最优都打破它。',
     [HO + n for n in ['metRun', 'metRun_of_met', 'metRun_of_falls', 'metRun_ge', 'stepwiseDraw',
                       'stepwiseDraw_of_keeps', 'stepwiseDraw_of_falls', 'stepwiseDraw_ge', 'logistic_stepwise']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.le_dest', 'Becoming.Naturals.sub_add_cancel',
                    'Becoming.Naturals.le_of_add_le_add_right'],
        'World': ['Becoming.Flow', 'Becoming.Web'],
        'Flow': ['Becoming.Flow.Balances', 'Becoming.Flow.given', 'Becoming.Flow.taken'],
        'Amounts': ['Becoming.Amounts.whole', 'Becoming.Amounts.sum'],
        'Dependence': ['Becoming.Web.Broken'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.Keeps', 'Becoming.Optimum.OpenCourse', 'Becoming.Optimum.drawnOver',
           'Becoming.Optimum.drawn_add_shortfall_after', 'Becoming.Optimum.le_or_eq_succ',
           'Becoming.Optimum.keeps_or_drops', 'Becoming.Optimum.drops_of_not_keeps', 'Becoming.Optimum.keeping_drawn_le',
           'Becoming.Optimum.holding', 'Becoming.Optimum.holding_most', 'Becoming.Optimum.holdingTo',
           'Becoming.Optimum.holdingTo_before', 'Becoming.Optimum.holdingTo_keeps', 'Becoming.Optimum.holdingTo_most',
           'Becoming.Optimum.holdingTo_steps', 'Becoming.Optimum.continued', 'Becoming.Optimum.continued_drawn',
           'Becoming.Optimum.continued_keeping_frontier', 'Becoming.Optimum.continued_keeps',
           'Becoming.Optimum.continued_le', 'Becoming.Optimum.continued_open', 'Becoming.Optimum.sum_eq_of_eq',
           'Becoming.Web.frontier_breaks_below', 'Becoming.Flow.Balances.drawnAt_eq', 'Becoming.Flow.Balances.within',
           'Becoming.Optimum.Holding.logistic', 'Becoming.Optimum.Holding.logistic_above',
           'Becoming.Optimum.Holding.logistic_le', 'Becoming.Optimum.Holding.metThrough',
           'Becoming.Optimum.Holding.metThrough_of_below', 'Becoming.Optimum.Holding.metThrough_of_keeps',
           'Becoming.Optimum.Holding.onSource']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'A coupling a step keeps a dependence at every horizon', 'zh': '每步的耦合在每个视野都保持依存'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'A coupling added for each step a dependence stays met keeps it at every horizon where it covers the '
              'renewal forgone a step and exceeds the end; below the need the horizon\'s end breaks it, at the last '
              'step alone above that rate; below the rate a long horizon outweighs it.',
        'zh': '每当依存被满足一步就加入的耦合，覆盖每步放弃的更新且超过终点时在每个视野都保持它；低于所需时视野之末打破它，高于该率时只在最后一步；低于该率时长视野压过它。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts. Courses open from s; a renewal law R ≤ r, and ≤ q at or '
               'above a need m, q at some y ≥ m (r at some y for the holding optimum) within s + R s; n + 1 steps, '
               '0 < n; capacity for the first step down to y and for y with its renewal down to the end; an order by a '
               'worth bounded by the draw and c for each step m stays met from the start.',
         'zh': '不加公理。离散步与自然数量。自 s 开放的过程；水平之律 R 的更新，处处至多 r、在不低于需要 m 处至多 q，q 在 s 加 R s 之内某个 y ≥ m 处取得（保持最大更新的最优则 r 在某个 y 处）；'
               'n + 1 步的视野且 0 < n；容量足以在第一步降到 y 并承担 y 加其更新降到终点；按以汲取与 m 自起点起每被满足一步的 c 为界的值之序。'},
        {'en': 'For the web laws, a dependence at need m at every step, met at the start. Which formation optimizes, by '
               'which order, capacity and horizon, the renewal law and the coupling are supplied; the core asserts no '
               'course of any actual optimizer.',
         'zh': '对网之律：每步需要 m 处的依存，起始时被满足。哪个构成优化、按何序、容量与视野，更新之律与耦合，都是给定的；核心不对任何实际优化者的过程作断言。'}],
    'does_not_show': [
        {'en': 'Steps met again after a fall, which the coupling does not count; the keeping course as an optimum at '
               'c = m, where it ties with the course ending at nothing.',
         'zh': '跌落后再被满足的步（耦合不计）；c = m 时保持的过程作为最优（它与终于零的过程相持）。', 'kind': 'scope'},
        {'en': 'An order with a terminal value or a discount; the optimum rebuilding from below; several optimizers '
               'ranking courses.',
         'zh': '带终值或折现的序；自下重建的最优；多个对过程排序的优化者。', 'kind': 'scope'},
        {'en': 'That the dependence ought to be kept or a coupling set: no evaluation enters; the laws say which optima '
               'a coupling leaves.',
         'zh': '依存应当被保持或应设耦合：没有评价进入；这些律只说一个耦合留下哪些最优。', 'kind': 'non-implication'}],
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
        'en': 'Steps met again after a fall; an order with a terminal value or a discount; the optimum rebuilding from '
              'below; several optimizers ranking courses; an independent review.',
        'zh': '跌落后再被满足的步；带终值或折现的序；自下重建的最优；多个对过程排序的优化者；独立审查。'},
    'correspondence': {
        'en': 'The end of a finite horizon: in finitely repeated play cooperation sustained by later play fails at the '
              'last period and unravels by backward induction (Luce and Raiffa 1957; Selten 1978); an owner with a '
              'finite horizon depletes the stock at the end (Clark 1976); impact penalties applied at each step '
              '(Krakovna and others 2019; Turner, Hadfield-Menell and Tadepalli 2020). On the spine the rate a coupling '
              'a step needs is exact and free of the horizon, r − q, for every renewal law bounded by r and by q at or '
              'above the need; the thresholds cover every order rising with the worth and have optima in every case; the '
              'end effect stays at the last step above that rate, since each met step\'s coupling is direct. Reading '
              '(the AI\'s): a coupling sized to a horizon is outrun by a longer one (SG6); a coupling sized to a step is '
              'not.',
        'zh': '有限视野之末：有限重复博弈中由后来的博弈维持的合作在最后一期失败并经逆向归纳瓦解（Luce 与 Raiffa 1957；Selten 1978）；有限视野的所有者在末期耗尽存量'
              '（Clark 1976）；每步施加的影响惩罚（Krakovna 等 2019；Turner、Hadfield-Menell 与 Tadepalli 2020）。在脊柱上，每步耦合所需之率精确且与视野无关，'
              '为 r − q，对每个以 r 为界、在所需之上以 q 为界的更新之律都成立；阈值覆盖每个随该值升高之序，每种情形都有最优；高于该率时终局效应只在最后一步，'
              '因为每个被满足之步的耦合是直接的。读法（AI 的）：按视野定的耦合被更长的视野超过（SG6）；按步定的耦合则不。'},
    'canonical_source': src(OM),
    'aliases': ['a coupling a step keeps a dependence at every horizon', 'a coupling added for each step a dependence is kept',
                'the rate a step coupling needs', 'the end of the horizon breaks at the last step',
                '每步的耦合在每个视野都保持依存', 'Becoming.Optimum.frontier_keeps_stepwise',
                'Becoming.Optimum.frontier_met_before_end', 'Becoming.Web.frontier_breaks_last'],
    'dependencies': [
        dep(SG6, 'formal-reuse',
            'The course holding a level and ending at any level at most it, the continued courses, Keeps and what a '
            'keeping course draws; keeps_or_drops, now the case of keeps_or_falls (rule 9: generalized below); '
            'Web.frontier_breaks_below, through which a long horizon outweighs a coupling a step below the rate.',
            '保持在某一水平、终于不超过它的任意水平的过程，延续的过程，Keeps 与保持的过程所汲取；keeps_or_drops，现为 keeps_or_falls 的情形（规则 9：向下推广）；'
            'Web.frontier_breaks_below，长视野经由它压过低于该率的每步耦合。',
            'What keeping a need through a horizon forgoes, and the courses attaining it.', '在视野内保持需要所放弃者，以及取得它的过程。',
            'What a course met through some steps draws, and the thresholds of a coupling a step.',
            '在若干步中被满足的过程所汲取，以及每步耦合的阈值。',
            'Each step leaving at most the level with what is given; a renewal law bounded by r and by q at or above m.',
            '每步所留不超过水平加所给；以 r 为界、在不低于 m 处以 q 为界的更新之律。',
            src(OM)),
        dep(SG5, 'formal-reuse',
            'The identity of what a course draws, leaves and forgoes after the first step (drawn_add_shortfall_after); '
            'the open courses and the draw; the logistic law of the witness.',
            '过程自第一步后所汲取、所留与所放弃的恒等式（drawn_add_shortfall_after）；开放的过程与汲取；见证的逻辑斯谛律。',
            'What a course draws over a horizon.', '过程在视野上所汲取。',
            'What a course met through j steps draws.', '被满足 j 步的过程所汲取。',
            'A renewal law bounded by r.', '以 r 为界的更新之律。',
            src(OM)),
        dep(SEEN, 'formal-reuse',
            'The optima are the frontier of an order (Requirement.Frontier); the witness uses the Diversion places and '
            'web, the dweller depending on the source at need two.',
            '最优是一个序的前沿（Requirement.Frontier）；见证用 Diversion 的处所与网，居者在需要二处依存于源。',
            'The frontier of an order rising with what the part gains.', '随部分所得升高之序的前沿。',
            'The frontier over courses ranked by a worth with a coupling a step.', '按带每步耦合之值排序的过程上的前沿。',
            'An order rising with the worth across the horizon.', '随视野内该值升高之序。',
            src(OM))],
    'related': [
        {'id': SG6, 'detail': {'en': 'A coupling of the whole keeping is outweighed by far-sight; here a coupling a step '
                                     'that no horizon outweighs.',
                               'zh': '对整个保持的耦合被远见压过；此处为不被任何视野压过的每步耦合。'}},
        {'id': SG5, 'detail': {'en': 'Far-sight keeps the optimizer\'s own resource base; here what keeps anything else '
                                     'at every horizon.',
                               'zh': '远见保住优化者自身的资源基础；此处为在每个视野保持其他任何者的东西。'}}],
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
        'en': f'21 October 2026: added (SG7), a coupling added for each step a dependence is kept: it keeps the '
              f'dependence at every horizon where it covers the renewal forgone a step and exceeds the end; below the '
              f'need the horizon\'s end breaks it, at the last step alone above that rate; below the rate a long horizon '
              f'outweighs it; optima in every case; study section {N}.',
        'zh': f'2026年10月21日：新增（SG7），每当依存被满足一步就加入的耦合：覆盖每步放弃的更新且超过终点时在每个视野都保持依存；低于所需时视野之末打破它，'
              f'高于该率时只在最后一步；低于该率时长视野压过它；每种情形都有最优；研究第 {N} 节。'}],
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

# SG6's record: a note; its laws are unchanged in statement (keeps_or_drops is now the case of keeps_or_falls).
p = RECORDS / f'{SG6}.json'
d = json.loads(p.read_text())
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'A coupling added for each step the dependence is kept, which no horizon outweighs where it covers the '
          'renewal forgone a step and exceeds the end.',
    'zh': '每保持依存一步就加入的耦合；它覆盖每步放弃的更新且超过终点时不被任何视野压过。'}}]
d['history'].append({
    'en': f'21 October 2026, SG7: a coupling added for each step the dependence is kept keeps it at every horizon where '
          f'it covers the renewal forgone a step and exceeds the end (record {RID}, study section {N}); keeps_or_drops '
          'is now the case of keeps_or_falls; this record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月21日，SG7：每保持依存一步就加入的耦合，覆盖每步放弃的更新且超过终点时在每个视野都保持它（记录 {RID}，研究第 {N} 节）；'
          'keeps_or_drops 现为 keeps_or_falls 的情形；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', SG6)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid in ['alignment', 'degeneration']:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(SG6) + 1, RID)
    row['declarations'].insert(row['declarations'].index('Becoming.Web.frontier_breaks_below') + 1,
                               'Becoming.Web.frontier_keeps_stepwise')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
