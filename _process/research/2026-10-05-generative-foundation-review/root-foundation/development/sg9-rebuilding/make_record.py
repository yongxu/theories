#!/usr/bin/env python3
"""Write SG9's record optima-rebuild-a-depleted-base (a theorem), note it in
a-weighting-faster-than-renewal-ends-the-base (whose weighted_frontier and frontier_gains_weighted are now the case of
GainsMost), and give the coverage file's alignment and degeneration rows the record and its law:
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
HEAD = f"## {N}. Rebuilding from below (SG9)"
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


RID = 'optima-rebuild-a-depleted-base'
SG8 = 'a-weighting-faster-than-renewal-ends-the-base'
SG5 = 'horizon-optima-hold-the-greatest-renewal'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
HO = 'Optimum.Holding.'

laws = [
    ('A course gains the most where at each step to the n-th its level gains, weighted, at least what the level of '
     'any course open from s does; open and leaving nothing, it is an optimum of the weighted draw, and every optimum '
     'of every order rising with it leaves nothing weighted and gains what it does; a course of greatest weighted gain '
     'is the case.',
     '进程每步到第 n 步的水平加权增益不少于自 s 开放的任一进程的水平时，它增益最大；开放且最后不留时它是加权抽取的最优，随之升高之序的每个最优最后不留加权之物、增益与它相同；最大加权增益的进程是其情形。',
     ['Optimum.GainsMost', 'Optimum.gainsMost_of_greatest', 'Optimum.frontier_of_gainsMost',
      'Optimum.frontier_gains_of_most']),
    ('The rising course from s rises as fast as what is given allows up to y: it stands at most at y, stays there once '
     'there, and draws nothing at a step after which it is below y; the rebuilding course stands there to the n-th step '
     'and at nothing after, and from s at most y, where z + R z rises with z below y, it is open with a capacity '
     'covering y + R y and R 0.',
     '自 s 上升的进程按所给尽快升至 y：至多在 y，到 y 后留在那里，之后仍低于 y 的步不抽取；重建的进程到第 n 步在那里、此后为零，自不超过 y 的 s 出发、z + R z 在 y 之下随 z 上升时，容量足以承担 y + R y 与 R 0 则它开放。',
     ['Optimum.rise', 'Optimum.rebuilding', 'Optimum.rise_succ', 'Optimum.rise_le', 'Optimum.rise_le_top',
      'Optimum.rise_within', 'Optimum.rise_of_below', 'Optimum.rise_at_top', 'Optimum.rise_below_before',
      'Optimum.rise_stays', 'Optimum.rebuilding_before', 'Optimum.rebuilding_after', 'Optimum.rebuilding_at',
      'Optimum.rebuilding_within', 'Optimum.rebuilding_le_cap', 'Optimum.rebuilding_open']),
    ('Where z + R z rises with z below y, every course from s at most y whose steps leave at most the level with what '
     'is given stands at each step at or below the rising course, or that course stands at y; so where the weighted '
     'gain rises with the level up to y and is greatest at y, the rebuilding course gains the most and is an optimum.',
     'z + R z 在 y 之下随 z 上升时，自不超过 y 的 s 出发、每步所留不超过水平加所给的每个进程，每步都在上升进程处或其下，或上升进程在 y；故加权增益随水平升至 y 且在 y 最大时，重建的进程增益最大，是最优。',
     ['Optimum.le_rise', 'Optimum.rebuilding_gainsMost', 'Optimum.rebuilding_frontier']),
    ('Where the gain rises strictly below y, every optimum stands at the rising course\'s level, drawing nothing at the '
     'step before, at every step to the n-th where that level is below y, and restores within those steps every '
     'dependence, as it stands at the start, whose need that level meets; where y gains more than every other level, '
     'every optimum stands at y where the rising course does.',
     '增益在 y 之下严格上升时，每个最优在到第 n 步、上升进程水平低于 y 的每步都处于该水平，前一步不抽取，并在这些步内恢复起始时其需要为该水平所满足的每个依存；y 的增益多于其他每个水平时，每个最优在上升进程处于 y 处都处于 y。',
     ['Optimum.frontier_rebuilds', 'Optimum.frontier_rebuilt', 'Web.frontier_rebuilds']),
    ('Witness: a source doubling up to eight, from one, capacity sixteen, over n + 3 steps: where w (t + 1) ≤ w t < '
     '2 w (t + 1) every optimum draws nothing at the first two steps, stands at two, four, then eight, and restores the '
     'dweller at the first step; where w t = 2 w (t + 1) ending at once is an optimum too; where 2 w (t + 1) < w t '
     'every optimum ends it.',
     '见证：源每级翻倍至八，自一、容量十六、n + 3 步：w (t + 1) ≤ w t < 2 w (t + 1) 时每个最优在前两步不抽取，处于二、四、再八，并在第一步恢复居者；w t = 2 w (t + 1) 时立即终结也是最优；2 w (t + 1) < w t 时每个最优都终结它。',
     [HO + n for n in ['doubling', 'twice_mul', 'doubling_gain_le', 'doubling_gain_lt', 'doubling_low',
                       'doubling_high', 'doubling_grows', 'doubling_rises', 'doubling_rises_strictly', 'doubling_top',
                       'doubling_outpaced', 'doubling_outpaced_le', 'mul_lt_of_pos', 'doubling_above',
                       'doubling_rebuilds']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.le_dest', 'Becoming.mul_assoc_nat'],
        'World': ['Becoming.Web'],
        'Restoration': ['Becoming.Web.RestoredWithin'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.OpenCourse', 'Becoming.Optimum.drawnAt', 'Becoming.Optimum.weightedOver',
           'Becoming.Optimum.weighted_le_of_gains', 'Becoming.Optimum.weighted_lt_of_gains',
           'Becoming.Optimum.weighted_frontier', 'Becoming.Optimum.frontier_gains_weighted',
           'Becoming.Optimum.exhausting_frontier', 'Becoming.Optimum.frontier_exhausts', 'Becoming.Optimum.holding',
           'Becoming.Optimum.Holding.onSource']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Every optimum rebuilds a depleted base', 'zh': '每个最优都重建耗竭的基础'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Below a level out of one step\'s reach, where the next level and the weighted gain rise with the level, '
              'every optimum of a far-sighted order rebuilds the base as fast as it renews, drawing nothing, and '
              'restores every dependence whose need the rising level meets.',
        'zh': '在一步不可及的水平之下，下一水平与加权增益都随水平上升时，远见之序的每个最优都按更新尽快重建基础、不抽取，并恢复其需要为上升水平所满足的每个依存。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts, natural weights. Courses open from s at most y; a renewal '
               'law R with z + R z rising with z below y; n + 1 steps; the weighted gain rising with the level up to y '
               '(strictly, for every optimum) and greatest at y (more than every other level, for standing at y); a '
               'capacity covering y + R y and R 0.',
         'zh': '不加公理。离散步、自然数量与自然数权重。自不超过 y 的 s 开放的过程；更新之律 R，z + R z 在 y 之下随 z 上升；n + 1 步；加权增益随水平升至 y（对每个最优须严格）且在 y 最大（对处于 y 须多于其他每个水平）；容量足以承担 y + R y 与 R 0。'},
        {'en': 'For the web law, a dependence on the condition as it stands at the start. Which formation optimizes, by '
               'which order, weighting, capacity and horizon, and the renewal law are supplied; the core asserts no '
               'course of any actual optimizer.',
         'zh': '对网之律：起始时的依存。哪个构成优化、按何序、权重、容量与视野，以及更新之律，都是给定的；核心不对任何实际优化者的过程作断言。'}],
    'does_not_show': [
        {'en': 'The optimum where the next level does not rise with the level below y (an overcompensating renewal) or '
               'the gain has several peaks; that the rising course is then not an optimum.',
         'zh': '下一水平在 y 之下不随水平上升（过度补偿的更新）或增益有多个峰时的最优；那时上升进程不是最优。', 'kind': 'scope'},
        {'en': 'A dependence needing more than y restored; an order valuing what is left at the horizon; steps met '
               'again after a fall; several optimizers ranking courses.',
         'zh': '需要多于 y 的依存被恢复；对视野末所留赋值之序；跌落后再被满足的步；多个对过程排序的优化者。', 'kind': 'scope'},
        {'en': 'That a base ought to be rebuilt: no evaluation enters; the laws say what the optima of an order do.',
         'zh': '基础应当被重建：没有评价进入；这些律只说一个序的最优做什么。', 'kind': 'non-implication'}],
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
        'en': 'An overcompensating renewal or a gain with several peaks; an order valuing what is left at the horizon; '
              'steps met again after a fall; several optimizers ranking courses; an independent review.',
        'zh': '过度补偿的更新或多峰的增益；对视野末所留赋值之序；跌落后再被满足的步；多个对过程排序的优化者；独立审查。'},
    'correspondence': {
        'en': 'The most rapid approach path: with a linear objective, the optimal path from a stock below its optimal '
              'level harvests nothing until the level is reached, then holds it (Spence and Starrett 1975; Clark 1976). '
              'On the spine every optimum of every order rising with the weighted draw rebuilds, under any weighting '
              'whose gain rises with the level; the reference is any course gaining the most against every open course, '
              'the earlier holding laws its case; the restoration of what depends on the base is a law of the dependence '
              'web; the witness shows the strict premise needed. Reading (the AI\'s): far-sight repairs damage to its '
              'own base where its weighting falls slower than the base renews, up to the level its order favours.',
        'zh': '最快趋近路径：目标对收获为线性时，自低于最优水平的存量出发，最优路径在达到该水平前不收获，之后保持（Spence 与 Starrett 1975；Clark 1976）。'
              '在脊柱上，随加权抽取升高之序的每个最优都在增益随水平上升的任一权重下重建；参照是对每个开放进程增益最大的任一进程，先前的保持之律是其情形；'
              '依存于基础者的恢复是依存网之律；见证表明严格前提必要。读法（AI 的）：远见在权重下降慢于基础更新时修复对自身基础的损伤，直至其序所偏好的水平。'},
    'canonical_source': src(OM),
    'aliases': ['every optimum rebuilds a depleted base', 'rebuilding from below', 'the most rapid approach path',
                'a course gaining the most against every open course', '每个最优都重建耗竭的基础',
                'Becoming.Optimum.frontier_rebuilds', 'Becoming.Optimum.rebuilding_frontier',
                'Becoming.Web.frontier_rebuilds'],
    'dependencies': [
        dep(SG8, 'formal-reuse',
            'The weighted draw and the comparison against a course of greater gain (weighted_le_of_gains, '
            'weighted_lt_of_gains), generalized here to a course gaining the most against every open course; '
            'weighted_frontier and frontier_gains_weighted now its case; frontier_exhausts and exhausting_frontier for '
            'the witness\'s steep and tie branches.',
            '加权抽取与相对于增益更大之进程的比较（weighted_le_of_gains、weighted_lt_of_gains），此处推广为对每个开放进程增益最大的进程；'
            'weighted_frontier 与 frontier_gains_weighted 现为其情形；见证的陡与相持分支用 frontier_exhausts 与 exhausting_frontier。',
            'The order by the weighted draw and its optima.', '按加权抽取之序及其最优。',
            'A reference course gaining the most among reachable levels.', '在可及水平中增益最大的参照进程。',
            'Courses open from a start; natural weights.', '自起点开放的过程；自然数权重。',
            src(OM)),
        dep(SG5, 'formal-reuse',
            'The open courses, what a step draws (drawnAt) and the holding course of the witness\'s tie branch.',
            '开放的过程、一步所抽取（drawnAt）与见证相持分支中的保持进程。',
            'The courses open from a start.', '自起点开放的过程。',
            'The rising and rebuilding courses, open.', '上升与重建的进程，开放。',
            'Each step leaving at most the level with what is given and drawing at most k.', '每步所留不超过水平加所给、所抽取至多 k。',
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
        {'id': SG8, 'detail': {'en': 'A weighting falling faster than renewal ends the base; here, falling slower, every '
                                     'optimum rebuilds it from below.',
                               'zh': '权重下降快于更新时终结基础；此处下降较慢时，每个最优自下重建它。'}},
        {'id': SG5, 'detail': {'en': 'Every optimum holds a level of greatest renewal within one step\'s reach; here one '
                                     'out of reach is rebuilt to.',
                               'zh': '每个最优保持一步可及的最大更新水平；此处一步不可及者被重建达到。'}}],
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
        'en': f'21 October 2026: added (SG9), rebuilding from below: a course gaining the most against every open course '
              f'is an optimum and every optimum gains what it does; below a level out of one step\'s reach, where the '
              f'next level and the weighted gain rise with the level, every optimum rebuilds as fast as the base renews, '
              f'drawing nothing, restoring what the rising level meets; study section {N}.',
        'zh': f'2026年10月21日：新增（SG9），自下重建：对每个开放进程增益最大的进程是最优，每个最优的增益与它相同；在一步不可及的水平之下，下一水平与加权增益随水平上升时，'
              f'每个最优都按基础的更新尽快重建、不抽取，恢复上升水平所满足者；研究第 {N} 节。'}],
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

# SG8's record: a note; its laws are unchanged in statement (two of them now the case of GainsMost).
p = RECORDS / f'{SG8}.json'
d = json.loads(p.read_text())
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Rebuilding from below: where the weighting falls slower than the base renews, every optimum rebuilds a base '
          'below a level out of one step\'s reach.',
    'zh': '自下重建：权重下降慢于基础更新时，每个最优重建低于一步不可及水平的基础。'}}]
d['history'].append({
    'en': f'21 October 2026, SG9: weighted_frontier and frontier_gains_weighted are now the case of '
          f'frontier_of_gainsMost and frontier_gains_of_most, a course gaining the most against every open course '
          f'(record {RID}, study section {N}); this record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月21日，SG9：weighted_frontier 与 frontier_gains_weighted 现为 frontier_of_gainsMost 与 frontier_gains_of_most（对每个开放进程增益最大的进程）的情形'
          f'（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', SG8)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid in ['alignment', 'degeneration']:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(SG8) + 1, RID)
    row['declarations'].insert(row['declarations'].index('Becoming.Web.frontier_exhausts') + 1,
                               'Becoming.Web.frontier_rebuilds')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
