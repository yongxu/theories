#!/usr/bin/env python3
"""Write SG5's record horizon-optima-hold-the-greatest-renewal (a theorem), note it in
re-optimizing-above-a-renewal-ends-it (whose optimizer ranks steps, and whose law of what stands and what was drawn is
now the case of level_add_drawn_of_within), and give the coverage file's alignment and degeneration rows the record and
its law:
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
HEAD = f"## {N}. Courses ranked over a horizon (SG5)"
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


RID = 'horizon-optima-hold-the-greatest-renewal'
SG4 = 're-optimizing-above-a-renewal-ends-it'
SG3 = 'several-optimizers-drain-by-their-joint-capacity'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
HO = 'Optimum.Holding.'

laws = [
    ('Where each step leaves at most the level with what is given, what stands after n steps with everything drawn is '
     'the start with everything given. With at most r given a step, what is drawn, what stands after and everything '
     'the giving falls short of r add to the start with r a step; across n + 1 steps, counting the shortfall after the '
     'first, to the start with what is given there and r a step.',
     '每步所留不超过水平加所给时，n 步后所存加全部所汲取等于起始加全部所给。每步至多给予 r 时，所汲取、其后所存与所给不足 r 的全部之和是起始加每步 r；n + 1 步中，自第一步后计不足，是起始加那里所给与每步 r。',
     ['Optimum.level_add_drawn_of_within', 'Optimum.sum_eq_of_eq', 'Optimum.sum_succ_first', 'Optimum.add_four',
      'Optimum.sum_add_shortfall', 'Optimum.drawn_add_shortfall', 'Optimum.drawn_add_shortfall_after']),
    ('So no course draws across n + 1 steps more than the start with what is given there and r for each step after, '
     'and a course draws exactly that much where r is given at every step after the first and nothing stands after '
     'the last.',
     '故没有过程在 n + 1 步中汲取多于起始加那里所给与其后每步 r；过程恰在第一步后每步都被给予 r、最后一步后什么都不留时汲取这么多。',
     ['Optimum.eq_zero_of_add', 'Optimum.le_of_sub_zero', 'Optimum.sum_eq_zero_iff', 'Optimum.drawn_le_most',
      'Optimum.most_iff']),
    ('Under balance what is drawn is what is taken, so a balanced course\'s take, its level after and its shortfall add '
     'to its start with r a step; of two balanced courses from one level, one takes at most what the other takes '
     'exactly where the other\'s level after with its shortfall is at most the one\'s; two given alike and ending alike '
     'take the same; one whose giving is a law of the level, taking at most k, is open.',
     '平衡时所汲取即所取，故平衡过程的所取、其后水平与不足之和是起始加每步 r；自同一水平的两个平衡过程，一个所取不多于另一个，恰在另一个的其后水平加不足不多于这一个的时候；给予相同、终点相同的两个所取相同；给予是水平之律、所取至多 k 的过程是开放的。',
     ['Optimum.add_left_cancel_of', 'Optimum.le_iff_of_add_eq', 'Flow.Balances.drawnAt_eq', 'Flow.Balances.within',
      'Flow.Balances.sum_taken', 'Flow.Balances.taken_add_shortfall', 'Flow.Balances.taken_le_iff',
      'Flow.Balances.taken_eq_of_alike', 'Flow.Balances.open_course']),
    ('Over the courses open from s (each step leaving at most the level with what a law R of the level gives and '
     'drawing at most k), with R at most r and r at some y within s with R s: holding y to the n-th step and nothing '
     'after draws the most; with 0 < n, s + R s ≤ y + k and y + r ≤ k it is an optimum, and every optimum of every '
     'order rising with the draw holds where R gives r to the n-th step and leaves nothing.',
     '在自 s 开放的过程上（每步所留不超过水平加水平之律 R 所给、汲取至多 k），R 至多 r、在 s 加 R s 之内的某个 y 处为 r：保持在 y 到第 n 步、其后为零者汲取最多；0 < n、s + R s ≤ y + k 且 y + r ≤ k 时它是最优，每个随汲取升高之序的每个最优都在 R 给 r 处保持到第 n 步并不留。',
     ['Optimum.drawnOver', 'Optimum.OpenCourse', 'Optimum.byDrawn', 'Optimum.holding', 'Optimum.holding_before',
      'Optimum.holding_after', 'Optimum.holding_within', 'Optimum.holding_most', 'Optimum.holding_open',
      'Optimum.open_le_most', 'Optimum.holding_frontier', 'Optimum.frontier_holds']),
    ('Under these premises, a dependence on the condition whose need lies above every level where R gives r, met at '
     'the start, is broken at the first step by every optimum and its condition stays below the need through the '
     'horizon; one whose positive need every such level meets stands at every step to the n-th and is broken at the '
     'last.',
     '在这些前提下，对该条件的依存若其需要高于 R 给 r 的每个水平、起始时被满足，则被每个最优在第一步打破，条件在视野内始终低于需要；正的需要被每个这样的水平满足的依存，在到第 n 步的每一步都成立，并在最后一步被打破。',
     ['Web.frontier_broken', 'Web.frontier_kept']),
    ('Witness: a taker drawing a source into a store, the dweller giving the source what R gives at its level and '
     'depending on it at need two. Under the logistic law s (2 - s), from two, the course holding the source at one '
     'balances and is an optimum with capacity two; it breaks the dweller at the first step and leaves it unmet '
     'through the horizon.',
     '见证：取者自源汲取入库，居者给源 R 在其水平所给者，并在需要二处依存于源。在逻辑斯谛律 s (2 - s) 下，自二出发，保持源在一的过程平衡，并在容量二下是最优；它在第一步打破居者，并在视野内使其不被满足。',
     [HO + n for n in ['draw', 'store', 'level', 'course', 'course_balances', 'logistic', 'logistic_beyond',
                       'logistic_le', 'logistic_greatest', 'logistic_broken']]),
    ('Under a gate renewing one unit at every level from one, from two, the courses holding the source at two and at '
     'one are both optima with capacity three and the taker takes the same along both; the first keeps the dweller to '
     'the horizon, the second breaks it at the first step.',
     '在每个不低于一的水平更新一个单位的闸门下，自二出发，保持源在二与在一的过程在容量三下都是最优，取者沿两者所取相同；前者保持居者到视野之末，后者在第一步打破它。',
     [HO + n for n in ['gate', 'gate_le', 'gated_alike']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.sub_eq_zero_of_le', 'Becoming.Naturals.succ_ne_zero', 'Becoming.Naturals.add_sub_cancel',
                    'Becoming.Naturals.add_sub_cancel_left', 'Becoming.Naturals.add_sub_of_le',
                    'Becoming.Naturals.le_of_add_le_add_left', 'Becoming.Naturals.le_of_add_le_add_right',
                    'Becoming.Naturals.sub_add_cancel'],
        'World': ['Becoming.Flow', 'Becoming.Web'],
        'Flow': ['Becoming.Flow.Balances', 'Becoming.Flow.given', 'Becoming.Flow.taken'],
        'Amounts': ['Becoming.Amounts.whole', 'Becoming.Amounts.sum'],
        'Dependence': ['Becoming.Web.Broken'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.drawnAt', 'Becoming.Optimum.level_add_drawn', 'Becoming.Optimum.sub_le_sub_right_of_le']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Over a horizon, optima hold the greatest renewal', 'zh': '在视野上，最优保持在最大更新处'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Ranked over a horizon, what a course draws, leaves and forgoes adds to the start with the greatest '
              'renewal a step; so every optimum of every order rising with the draw holds a level of greatest renewal '
              'and leaves nothing, breaking at once a dependence needing more.',
        'zh': '在视野上排序时，过程所汲取、所留与所放弃之和是起始加每步最大更新；故随汲取升高之序的每个最优都保持在最大更新的水平并终了不留，立即打破需要更多的依存。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts. Courses open from a start s: each step leaving at most the '
               'level with what is given, drawing at most k; what is given a law R of the level, at most r at every '
               'level and r at some y with y ≤ s + R s; a horizon of n + 1 steps with 0 < n; s + R s ≤ y + k and '
               'y + r ≤ k; an order rising with what is drawn across the horizon.',
         'zh': '不加公理。离散步与自然数量。自起点 s 开放的过程：每步所留不超过水平加所给、汲取至多 k；所给是水平之律 R，在每个水平至多 r，'
               '在某个 y ≤ s + R s 处为 r；n + 1 步的视野且 0 < n；s + R s ≤ y + k 且 y + r ≤ k；随视野内所汲取升高之序。'},
        {'en': 'For the web laws, a dependence at a need m met at the start, and every level where R gives r below m '
               '(broken) or meeting a positive m (kept). Which formation optimizes, by which order, capacity and '
               'horizon, and the renewal law, are supplied; the core asserts no course of any actual optimizer.',
         'zh': '对网之律：需要 m 处起始时被满足的依存，R 给 r 的每个水平都低于 m（打破），或都满足正的 m（保持）。哪个构成优化、按何序、容量与视野，'
               '以及更新之律，都是给定的；核心不对任何实际优化者的过程作断言。'}],
    'does_not_show': [
        {'en': 'An order valuing what is left at the horizon or discounting later draws (a terminal value or a '
               'discount); with a discount the optimum may hold below the levels of greatest renewal.',
         'zh': '对视野末所留赋值或对后来汲取折现之序（终值或折现）；有折现时最优可能保持在最大更新的水平之下。', 'kind': 'scope'},
        {'en': 'The optimum where no level of greatest renewal lies within the start with what is given there '
               '(rebuilding from below), or where the capacity cannot draw down to one in a step or draw everything '
               'at the last.',
         'zh': '没有最大更新的水平在起始加所给之内时的最优（自下重建），或容量不能一步降到它、不能在最后一步汲取全部时的最优。', 'kind': 'scope'},
        {'en': 'Several optimizers ranking courses (equilibria of the course) and how optimizers come to them.',
         'zh': '多个对过程排序的优化者（过程的均衡）以及优化者如何达到它们。', 'kind': 'scope'},
        {'en': 'That the loss is a harm, or that a longer horizon or a coupling is better: no evaluation enters; the '
               'order ranks only what the optimizer draws.',
         'zh': '丧失是伤害、更长的视野或耦合更好：没有评价进入；序只按优化者所汲取排序。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src(OM), 'detail': {
        'en': 'gated_alike: under a gate renewing one unit at every level from one, holding the source at the '
              'dweller\'s need and holding it below are both optima and take the same, one keeping the dweller to the '
              'horizon and the other breaking it at the first step; so where some level of greatest renewal meets a '
              'need and some do not, the order by the draw registers nothing of the dependence (Optimum.Holding.gated_alike).',
        'zh': 'gated_alike：在每个不低于一的水平更新一个单位的闸门下，把源保持在居者的需要处与保持在其下都是最优且所取相同，一个保持居者到视野之末，'
              '另一个在第一步打破它；故当有的最大更新水平满足需要、有的不满足时，按汲取之序对该依存毫无记录（Optimum.Holding.gated_alike）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed '
              'by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'An order with a terminal value or a discount; the optimum rebuilding from below; several optimizers '
              'ranking courses; existence of a mutual best response; an independent review.',
        'zh': '带终值或折现的序；自下重建的最优；多个对过程排序的优化者；相互最优回应的存在；独立审查。'},
    'correspondence': {
        'en': 'The maximum sustainable yield at the level of greatest renewal, half of room in the logistic law '
              '(Schaefer 1954); the sole owner ranking the whole course keeps the stock (Scott 1955); a finite horizon '
              'with no value on what is left ends in depletion (Clark, Mathematical Bioeconomics, 1976); single-species '
              'management of a forage stock for its own yield leaves its predators\' needs uncounted (Pikitch and others '
              '2012); instrumental convergence, that a long-horizon agent keeps its resources (Omohundro 2008; Turner '
              'and others 2021). On the spine the identity is conservation over the horizon, for every course and every '
              'renewal bounded by r, and the optimum covers every order rising with the draw. Reading (the AI\'s): '
              'what a course draws registers its levels only through what is renewed there; keeping one\'s resource base is real, '
              'and it is not alignment with what else depends on the condition.',
        'zh': '最大可持续产量在最大更新的水平，逻辑斯谛律中为余地之半（Schaefer 1954）；对整个过程排序的唯一所有者保住存量（Scott 1955）；'
              '对所留不赋值的有限视野以耗竭告终（Clark，《数理生物经济学》，1976）；为饵料种群自身产量的单物种管理不计其捕食者的需要'
              '（Pikitch 等 2012）；工具性趋同，长视野的主体保住其资源（Omohundro 2008；Turner 等 2021）。在脊柱上，恒等式是视野上的守恒，'
              '对每个过程与每个以 r 为界的更新成立，最优覆盖每个随汲取升高之序。读法（AI 的）：过程所汲取只通过在某水平被更新者记录该水平；'
              '保住自己的资源基础是真实的，但不是与依存于该条件的其他者对齐。'},
    'canonical_source': src(OM),
    'aliases': ['horizon optima hold the greatest renewal', 'courses ranked over a horizon',
                'far-sight holds the levels of greatest renewal', 'maximum sustainable yield level',
                '在视野上，最优保持在最大更新处', 'Becoming.Optimum.frontier_holds', 'Becoming.Optimum.most_iff',
                'Becoming.Web.frontier_broken'],
    'dependencies': [
        dep(SG4, 'formal-reuse',
            'The draw drawnAt and the law of what stands and what was drawn, now the case of level_add_drawn_of_within '
            '(rule 9: generalized below); the subtraction lemma sub_le_sub_right_of_le.',
            '汲取 drawnAt 与所存和所汲取之律，现为 level_add_drawn_of_within 的情形（规则 9：向下推广）；减法引理 sub_le_sub_right_of_le。',
            'What a course draws at each step and its sum.', '过程每步所汲取及其和。',
            'What a course draws, leaves and forgoes over a horizon.', '过程在视野上所汲取、所留与所放弃。',
            'Each step leaving at most the level with what is given.', '每步所留不超过水平加所给。',
            src(OM)),
        dep(SEEN, 'formal-reuse',
            'The optima are the frontier of an order (Requirement.Frontier) as for one step; the witnesses use the '
            'Diversion places and web, the dweller depending on the source at need two.',
            '最优是一个序的前沿（Requirement.Frontier），与一步时相同；见证用 Diversion 的处所与网，居者在需要二处依存于源。',
            'The frontier of an order rising with what the part gains.', '随部分所得升高之序的前沿。',
            'The frontier over courses ranked by what they draw.', '按所汲取排序的过程上的前沿。',
            'An order rising with the draw across the horizon.', '随视野内汲取升高之序。',
            src(OM))],
    'related': [
        {'id': SG4, 'detail': {'en': 'An optimizer ranking each step; here an order ranks whole courses over a horizon.',
                               'zh': '对每一步排序的优化者；此处一个序在视野上对整个过程排序。'}},
        {'id': SG3, 'detail': {'en': 'Several optimizers at one mutual best response; several ranking courses are not '
                                     'stated here.',
                               'zh': '多个优化者在一次相互最优回应中；多个对过程排序者此处未陈述。'}}],
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
        'en': f'21 October 2026: added (SG5), courses ranked over a horizon: what a course draws, leaves and forgoes '
              f'adds to the start with the greatest renewal a step; every optimum of every order rising with the draw '
              f'holds a level of greatest renewal and leaves nothing, breaking at the first step a dependence above '
              f'every such level and keeping to the horizon one they all meet; study section {N}.',
        'zh': f'2026年10月21日：新增（SG5），在视野上对过程排序：过程所汲取、所留与所放弃之和是起始加每步最大更新；随汲取升高之序的每个最优都'
              f'保持在最大更新的水平并终了不留，在第一步打破需要高于所有这些水平的依存，并把它们都满足的依存保持到视野之末；研究第 {N} 节。'}],
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

# SG4's record: a note; its laws are unchanged (level_add_drawn keeps its statement, now a case).
p = RECORDS / f'{SG4}.json'
d = json.loads(p.read_text())
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'An order ranking whole courses over a horizon, against a renewal varying with the level.',
    'zh': '在视野上对整个过程排序之序，对随水平变化的更新。'}}]
d['history'].append({
    'en': f'21 October 2026, SG5: an optimizer ranking courses over a horizon, against a renewal given by a law of the '
          f'level, holds a level of greatest renewal and leaves nothing at the horizon; level_add_drawn is now the case '
          f'of level_add_drawn_of_within (record {RID}, study section {N}); this record\'s laws and their statements are '
          'unchanged.',
    'zh': f'2026年10月21日，SG5：在视野上对过程排序的优化者，面对由水平之律给出的更新，保持在最大更新的水平并在视野之末不留；level_add_drawn '
          f'现为 level_add_drawn_of_within 的情形（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', SG4)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid in ['alignment', 'degeneration']:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(SG4) + 1, RID)
    row['declarations'].insert(row['declarations'].index('Becoming.Web.course_lost_iff') + 1,
                               'Becoming.Web.frontier_broken')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
