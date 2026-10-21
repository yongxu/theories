#!/usr/bin/env python3
"""Write SG6's record keeping-forgoes-the-renewal-at-the-need (a theorem), note it in
horizon-optima-hold-the-greatest-renewal (whose identity is now read on the steps counted and whose holding course is
now the case ending at nothing), and give the coverage file's alignment and degeneration rows the record and its law:
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
HEAD = f"## {N}. What keeping a dependence forgoes over a horizon (SG6)"
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


RID = 'keeping-forgoes-the-renewal-at-the-need'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SG4 = 're-optimizing-above-a-renewal-ends-it'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
HO = 'Optimum.Holding.'

laws = [
    ('With at most r given at each of the steps counted, what is given with what it falls short of r is r a step, read '
     'off the law for a bound at every step with nothing given after; so what a course draws, leaves and forgoes adds '
     'to the start with r a step, and across n + 1 steps, counting after the first, to the start with what is given '
     'there and r a step after.',
     '所计的每步至多给予 r 时，所给加其不足 r 者为每步 r，由每步皆有界之律读出（其后所给为零）；故过程所汲取、所留与所放弃之和为起始加每步 r，n + 1 步中自第一步后计，为起始加那里所给与其后每步 r。',
     ['Optimum.sum_add_shortfall_up_to', 'Optimum.drawn_add_shortfall_up_to',
      'Optimum.drawn_add_shortfall_after_up_to']),
    ('The course from s holding y to the n-th step and ending at e ≤ y leaves at most the level with what is given '
     'where y ≤ s + R s; with 0 < n, s + R s ≤ y + k and y + R y ≤ e + k its steps to the n-th draw at most k, and with '
     'R e ≤ k it is open; where R y = r it draws across n + 1 steps, with e, the start with what is given there and r '
     'a step; it keeps a need m that s, y and e meet.',
     '自 s 出发、保持在 y 到第 n 步、终于 e ≤ y 的过程，y ≤ s + R s 时每步所留不超过水平加所给；0 < n、s + R s ≤ y + k、y + R y ≤ e + k 时到第 n 步每步汲取至多 k，再有 R e ≤ k 则开放；R y = r 时其 n + 1 步所汲取加 e 为起始加那里所给与每步 r；它保持 s、y、e 都满足的需要 m。',
     ['Optimum.holdingTo', 'Optimum.holdingTo_before', 'Optimum.holdingTo_after', 'Optimum.holdingTo_ge',
      'Optimum.holdingTo_within', 'Optimum.drawnAt_le_of', 'Optimum.holdingTo_steps', 'Optimum.holdingTo_open',
      'Optimum.holdingTo_most', 'Optimum.holdingTo_keeps']),
    ('A course keeps a need m through n + 1 steps where it stands at m or above at each. Where R gives at most q at '
     'every level at or above m, what a keeping course draws, with what it leaves, is at most its start with what is '
     'given there and q a step after; under balance, what is taken there with m is at most the starting level with '
     'what is given there and q a step after.',
     '过程在 n + 1 步中每步都在 m 或之上时保持需要 m。R 在不低于 m 的每个水平至多给 q 时，保持的过程所汲取加所留至多是起始加那里所给与其后每步 q；平衡时，那里所取加 m 至多是起始水平加那里所给与其后每步 q。',
     ['Optimum.Keeps', 'Optimum.le_or_eq_succ', 'Optimum.keeping_le_most', 'Optimum.keeping_drawn_le',
      'Flow.Balances.keeping_taken_le']),
    ('The course continued after the horizon by drawing nothing stands where the course does through the horizon; a '
     'course from s whose steps to the n-th leave at most the level with what is given and draw at most k continues '
     'openly, drawing across the horizon what it draws and keeping a need where it keeps it.',
     '视野之后不再汲取而延续的过程在视野内与原过程处处相同；自 s 出发、到第 n 步每步所留不超过水平加所给且汲取至多 k 的过程开放地延续，在视野内汲取原过程所汲取者，并在原过程保持需要处保持它。',
     ['Optimum.continued', 'Optimum.continued_le', 'Optimum.continued_after', 'Optimum.continued_open',
      'Optimum.continued_drawn', 'Optimum.continued_keeps']),
    ('With R at most q at or above m and q at some y ≥ m with y ≤ s + R s, from s ≥ m over at least two steps with '
     's + R s ≤ y + k and y + q ≤ m + k: every optimum among the open keeping courses of every order rising with the '
     'draw leaves exactly m, a formation\'s need there, and stands where R gives q to the n-th step; the continued '
     'course holding y and ending at m is one.',
     'R 在不低于 m 处至多为 q、在某个 y ≥ m 且 y ≤ s + R s 处为 q，自 s ≥ m 出发、视野至少两步、s + R s ≤ y + k 且 y + q ≤ m + k：保持的开放过程中随汲取升高之序的每个最优都恰留 m（构成在那里的需要），并在到第 n 步处处于 R 给 q 处；保持在 y、终于 m 的延续过程是其一。',
     ['Optimum.frontier_keeps', 'Optimum.continued_keeping_frontier', 'Web.frontier_keeps']),
    ('For a worth at least the draw and at most w more for a keeping course, with r at a reachable y and the '
     'capacity reaching an end e ≤ y, where w + q n + e < r n + m, every optimum falls below m within the horizon, '
     'breaking a dependence at need m; for one adding at least w to a keeping course and nothing to one below m, '
     'R ≤ r, the keeping course ending at e from m to y, where r n + e < w + q n, every optimum keeps it.',
     '对至少为汲取、对保持的过程至多多 w 的值，r 在某个 y ≤ s + R s 处、容量可及终点 e ≤ y，w + q n + e < r n + m 时每个最优都在视野内落到 m 之下，打破需要 m 处的依存；对保持的过程至少加 w、对落到 m 之下者不加的值，R ≤ r、保持的过程终于 m 到 y 之间的 e，r n + e < w + q n 时每个最优都保持它。',
     ['Optimum.lt_of_forgone_below', 'Optimum.lt_of_forgone_beyond', 'Optimum.keeps_or_drops',
      'Optimum.drops_of_not_keeps', 'Optimum.keeps_or_below', 'Optimum.frontier_breaks_below',
      'Optimum.frontier_keeps_above', 'Web.frontier_breaks_below', 'Web.frontier_keeps_above']),
    ('Neither threshold is vacuous. With R ≤ r, for a worth at least the draw, at most w more for a keeping course and '
     'no more than the draw for a course below m, where w + q n < r n + m and y + r ≤ k, the continued course holding '
     'y where R gives r and ending at nothing is an optimum; for a worth adding exactly w to a keeping course, where '
     'r n + m < w + q n, the one holding where R gives q and ending at m is.',
     '两个阈值都不空。R ≤ r 时，对至少为汲取、对保持的过程至多多 w、对落到 m 之下的过程不超过汲取的值，w + q n < r n + m 且 y + r ≤ k 时，保持在 R 给 r 的 y、终于零的延续过程是最优；对保持的过程恰加 w 的值，r n + m < w + q n 时，保持在 R 给 q 处、终于 m 者是最优。',
     ['Optimum.continued_breaking_frontier', 'Optimum.continued_kept_frontier']),
    ('Where q < r, every coupling w with w + e < n + m has w + q n + e < r n + m, so under the premises above every '
     'optimum breaks the dependence within the horizon: what keeping forgoes, (r − q) n + m against the course ending '
     'at nothing, grows with the horizon.',
     'q < r 时，每个满足 w + e < n + m 的耦合 w 都有 w + q n + e < r n + m，故在上述前提下每个最优都在视野内打破依存：保持所放弃者（相对于终于零的过程为 (r − q) n + m）随视野增长。',
     ['Optimum.forgone_grows', 'Web.frontier_breaks_long']),
    ('Witness: under the logistic law s (2 − s), renewing nothing at two or above, from the dweller\'s need two with '
     'capacity two, the taker\'s draw with w added where the source stays at two or above through n + 2 steps has '
     'optima, all breaking the dweller within the horizon where w < n + 3 and all keeping it met where n + 3 < w.',
     '见证：在逻辑斯谛律 s (2 − s) 下（在二或之上不更新），自居者的需要二出发、容量为二，取者的汲取在源于 n + 2 步中保持在二或之上时加 w，此序有最优；w < n + 3 时它们都在视野内打破居者，n + 3 < w 时都使其保持被满足。',
     [HO + n for n in ['metThrough', 'metThrough_of_keeps', 'metThrough_of_below', 'coupledDraw',
                       'coupledDraw_of_keeps', 'coupledDraw_of_below', 'onSource', 'logistic_above',
                       'logistic_coupled']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.le_dest', 'Becoming.Naturals.add_sub_cancel_left', 'Becoming.Naturals.add_sub_of_le',
                    'Becoming.Naturals.le_of_add_le_add_left', 'Becoming.Naturals.le_of_add_le_add_right'],
        'World': ['Becoming.Flow', 'Becoming.Web'],
        'Flow': ['Becoming.Flow.Balances', 'Becoming.Flow.given', 'Becoming.Flow.taken'],
        'Amounts': ['Becoming.Amounts.whole', 'Becoming.Amounts.sum'],
        'Dependence': ['Becoming.Web.Broken'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.drawnAt', 'Becoming.Optimum.drawnOver', 'Becoming.Optimum.OpenCourse',
           'Becoming.Optimum.byDrawn', 'Becoming.Optimum.sum_add_shortfall', 'Becoming.Optimum.sum_eq_of_eq',
           'Becoming.Optimum.sum_eq_zero_iff', 'Becoming.Optimum.le_of_sub_zero', 'Becoming.Optimum.add_four',
           'Becoming.Optimum.sum_succ_first', 'Becoming.Optimum.level_add_drawn_of_within',
           'Becoming.Optimum.sub_le_sub_right_of_le', 'Becoming.Optimum.open_le_most', 'Becoming.Optimum.holding',
           'Becoming.Optimum.holding_most', 'Becoming.Flow.Balances.drawnAt_eq', 'Becoming.Flow.Balances.within',
           'Becoming.Optimum.Holding.logistic', 'Becoming.Optimum.Holding.logistic_beyond',
           'Becoming.Optimum.Holding.logistic_le']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Keeping a dependence forgoes the renewal at its need', 'zh': '保持依存放弃其所需处的更新'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Keeping a dependence at its need over a horizon forgoes exactly the renewal given up each step and '
              'the need left at the end; a coupling below that leaves only optima breaking it, one beyond it only '
              'optima keeping it; the amount grows with the horizon where the need lies above the greatest renewal.',
        'zh': '在视野上，把依存保持在其所需处恰放弃那里每步放弃的更新与终了所留的所需；低于此量的耦合只留下打破它的最优，高于此量的只留下保持它的最优；所需高于最大更新的水平时此量随视野增长。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts. Courses open from s (each step leaving at most the level with '
               'what is given, drawing at most k); a renewal law R ≤ r, and ≤ q at or above a need m, '
               'r and q taken within s + R s; n + 1 steps, 0 < n; capacity for the first step down to the level held '
               'and for it with its renewal down to the end; an order by the draw, or by a worth bounded by it and a '
               'coupling w of keeping m.',
         'zh': '不加公理。离散步与自然数量。自 s 开放的过程（每步所留不超过水平加所给、汲取至多 k）；水平之律 R 的更新，处处至多 r、在不低于需要 m 处至多 q，'
               'r 与 q 在 s 加 R s 之内的水平处取得；n + 1 步的视野且 0 < n；容量足以在第一步降到所保持的水平并承担它加其更新降到终点；'
               '随汲取升高之序，或随以汲取与保持 m 的耦合 w 为界的值升高之序。'},
        {'en': 'For the web laws, a dependence at need m at every step, met at the start. Which formation optimizes, by '
               'which order, capacity and horizon, the renewal law and the coupling are supplied; the core asserts no '
               'course of any actual optimizer.',
         'zh': '对网之律：每步需要 m 处的依存，起始时被满足。哪个构成优化、按何序、容量与视野，更新之律与耦合，都是给定的；核心不对任何实际优化者的过程作断言。'}],
    'does_not_show': [
        {'en': 'A coupling added step by step, which gives a course breaking late part of the coupling; the tie at exactly '
               'the amount forgone, where both kinds of optimum stand.',
         'zh': '按步加入的耦合（它给迟些打破的过程部分的值）；恰在所放弃之量处两种最优并存的情形。', 'kind': 'scope'},
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
        'en': 'A coupling added step by step; an order with a terminal value or a discount; the optimum rebuilding from '
              'below; several optimizers ranking courses; an independent review.',
        'zh': '按步加入的耦合；带终值或折现的序；自下重建的最优；多个对过程排序的优化者；独立审查。'},
    'correspondence': {
        'en': 'The exact penalty: a penalty beyond the value of a constraint makes the constrained optimum an '
              'unconstrained one (Zangwill 1967), here a lump-sum coupling whose threshold is the value gap itself; the '
              'yield given up by managing a prey for its predators\' needs (May and others 1979; Pikitch and others '
              '2012); impact penalties, whose coefficient trades task reward against side effects (Krakovna and others '
              '2019; Turner, Hadfield-Menell and Tadepalli 2020). On the spine the gap is exact for every renewal law '
              'bounded by r and by q at or above the need, the thresholds cover every order rising with the worth and '
              'are attained on both sides, and the break is a law of the dependence web. Reading (the AI\'s): what '
              'keeping forgoes is no fixed sum; where the need lies above every level of greatest renewal it grows with '
              'the horizon, so far-sight outweighs every coupling fixed in total.',
        'zh': '精确罚函数：超过约束之值的罚使受约束的最优成为无约束的最优（Zangwill 1967），此处为整体耦合，其阈值即值差本身；为捕食者的需要管理猎物所放弃的产量'
              '（May 等 1979；Pikitch 等 2012）；影响惩罚，其系数在任务回报与副作用之间权衡（Krakovna 等 2019；Turner、Hadfield-Menell 与 Tadepalli 2020）。'
              '在脊柱上，值差对每个以 r 为界、在所需之上以 q 为界的更新之律都精确，阈值覆盖每个随该值升高之序并在两侧都取得，打破是依存网的律。'
              '读法（AI 的）：保持所放弃者不是固定之数；所需高于每个最大更新的水平时它随视野增长，故远见胜过每个总量固定的耦合。'},
    'canonical_source': src(OM),
    'aliases': ['keeping forgoes the renewal at the need', 'what keeping a dependence forgoes over a horizon',
                'the coupling needed to keep a dependence', 'far-sight outweighs a fixed coupling',
                '保持依存放弃其所需处的更新', 'Becoming.Optimum.frontier_breaks_below',
                'Becoming.Optimum.frontier_keeps_above', 'Becoming.Web.frontier_breaks_long'],
    'dependencies': [
        dep(SG5, 'formal-reuse',
            'The identity of what a course draws, leaves and forgoes, now read on the steps counted, and the holding '
            'course, now the case of holdingTo ending at nothing (rule 9: generalized below); the open courses, the '
            'draw and its bound open_le_most; the logistic law of the witnesses.',
            '过程所汲取、所留与所放弃的恒等式，现于所计的步上读出；保持的过程，现为 holdingTo 终于零的情形（规则 9：向下推广）；开放的过程、汲取及其界 open_le_most；见证的逻辑斯谛律。',
            'What a course draws over a horizon and its bound by the greatest renewal.',
            '过程在视野上所汲取及其以最大更新为界。',
            'What a course keeping a need draws, and the thresholds of a coupling.', '保持需要的过程所汲取，以及耦合的阈值。',
            'Each step leaving at most the level with what is given; a renewal law bounded by r.',
            '每步所留不超过水平加所给；以 r 为界的更新之律。',
            src(OM)),
        dep(SEEN, 'formal-reuse',
            'The optima are the frontier of an order (Requirement.Frontier); the witness uses the Diversion places and '
            'web, the dweller depending on the source at need two.',
            '最优是一个序的前沿（Requirement.Frontier）；见证用 Diversion 的处所与网，居者在需要二处依存于源。',
            'The frontier of an order rising with what the part gains.', '随部分所得升高之序的前沿。',
            'The frontier over courses ranked by a worth with a coupling of keeping.', '按带保持耦合之值排序的过程上的前沿。',
            'An order rising with the worth across the horizon.', '随视野内该值升高之序。',
            src(OM))],
    'related': [
        {'id': SG5, 'detail': {'en': 'Far-sight keeps the optimizer\'s own resource base; here what keeping anything '
                                     'else forgoes, and the coupling that keeps it.',
                               'zh': '远见保住优化者自身的资源基础；此处为保持其他任何者所放弃的，以及保持它的耦合。'}},
        {'id': SG4, 'detail': {'en': 'An optimizer ranking each step loses a dependence where its draw exceeds the '
                                     'renewal; here an order ranking courses with a coupling.',
                               'zh': '对每一步排序的优化者在其汲取超过更新处丧失依存；此处为带耦合、对过程排序之序。'}}],
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
        'en': f'21 October 2026: added (SG6), what keeping a dependence forgoes over a horizon: the renewal given up at '
              f'the need for each step and the need left at the end; a coupling below that leaves only optima breaking '
              f'the dependence within the horizon, one beyond it only optima keeping it, both attained; where the need '
              f'lies above every level of greatest renewal the amount grows with the horizon; study section {N}.',
        'zh': f'2026年10月21日：新增（SG6），在视野上保持依存所放弃者：所需处每步放弃的更新与终了所留的所需；低于此量的耦合只留下在视野内打破依存的最优，'
              f'高于此量的只留下保持它的最优，两者都取得；所需高于每个最大更新的水平时此量随视野增长；研究第 {N} 节。'}],
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

# SG5's record: a note; its laws are unchanged in statement (sum_add_shortfall keeps its proof, drawn_add_shortfall and
# drawn_add_shortfall_after are now cases of the laws on the steps counted, holding the case of holdingTo).
p = RECORDS / f'{SG5}.json'
d = json.loads(p.read_text())
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'What keeping a dependence above the levels of greatest renewal forgoes, and the coupling that keeps it.',
    'zh': '保持高于最大更新水平的依存所放弃者，以及保持它的耦合。'}}]
d['history'].append({
    'en': f'21 October 2026, SG6: keeping a dependence at its need forgoes the renewal given up there each step and the '
          f'need left at the end, and a coupling keeps it exactly beyond that (record {RID}, study section {N}); '
          'drawn_add_shortfall and drawn_add_shortfall_after are now cases of the laws on the steps counted, the '
          'holding course the case of holdingTo ending at nothing; this record\'s laws and their statements are '
          'unchanged.',
    'zh': f'2026年10月21日，SG6：把依存保持在其所需处放弃那里每步放弃的更新与终了所留的所需，耦合恰在超过此量时保持它（记录 {RID}，研究第 {N} 节）；'
          'drawn_add_shortfall 与 drawn_add_shortfall_after 现为所计步上之律的情形，保持的过程为 holdingTo 终于零的情形；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', SG5)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid in ['alignment', 'degeneration']:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(SG5) + 1, RID)
    row['declarations'].insert(row['declarations'].index('Becoming.Web.frontier_broken') + 1,
                               'Becoming.Web.frontier_breaks_below')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
