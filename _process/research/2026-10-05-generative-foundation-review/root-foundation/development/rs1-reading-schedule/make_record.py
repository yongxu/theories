#!/usr/bin/env python3
"""Write RS1's record (one-reader-several-conditions):
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.ReadingSchedule (a short
name must match exactly one declaration by suffix), and the receipt must bind the module's current bytes."""
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
MOD = 'ReadingSchedule'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = (f'## {N}. One reader, several conditions: keeping is reading within the window, and what one reader can keep '
        '(RS1)')
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    return m


def resolve(mod, names):
    full = [d['name'] for d in decls(mod)['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n or f.endswith('.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


m = decls(MOD)
assert not any(m['axiom_dependencies'].values())
n_decl, n_thm = len(m['declarations']), sum(1 for d in m['declarations'] if d.get('kind') == 'theorem')

BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'one-reader-several-conditions'
R = 'ReadingSchedule.'
B = 'Flow.Balances.'
laws = [
    ('A schedule keeps a condition within the margin m, against every balanced flow\'s draws on it of at most d a step '
     'withdrawn l steps after a reading, exactly where it reads the condition within every a steps, for '
     '(a + l) d <= m < (a + 1 + l) d: sufficiency is the margin law, necessity a witness drawer.',
     '日程恰在每 a 步内读到一个条件时，才使它在余量 m 之内，抵御每个平衡流中每步至多 d、读到后 l 步撤回的汲取，'
     '其中 (a + l) d <= m < (a + 1 + l) d：充分性是余量定律，必要性由一个见证汲取者给出。',
     [R + 'Keeps', R + 'keeps_iff_within', R + 'keeps_of_within', R + 'within_of_keeps', 'Flow.taken_of_read',
      B + 'retains_of_read', R + 'within_iff', R + 'read_or_unread']),
    ('In a given balanced flow, a stretch of k steps left unread lets a drawer giving nothing take (k + 1 + l) d, and a '
     'formation needing more than the level without it then holds is lost.',
     '在给定的平衡流中，未被读到的 k 步让一个不给予的汲取者取走 (k + 1 + l) d，所需超过其后无该汲取者时水平的构成即失去。',
     [B + 'loses_of_unread']),
    ('Counting: a schedule reading conditions distinct by name within windows a c gives counts q c with q c a c <= P '
     'totalling at most P; readers naming k a step carry P k. In rates, the windows\' reciprocals sum to at most one '
     '(k for a pool).',
     '计数：日程在窗口 a c 内读到按名相异的诸条件时，满足 q c a c <= P 的读数 q c 之和至多为 P；每步读 k 个的读者承载 P k。'
     '以速率言，窗口倒数之和至多为一（池为 k）。',
     [R + 'PoolWithin', R + 'pool_density', R + 'density', R + 'Within.pool', R + 'keeps_density']),
    ('Spare capacity is not enough: no schedule reads three conditions within every 2, 3 and M steps, for any M, though '
     'for M >= 7 the counts over 6 M steps total 5 M + 6, the reader idle a share 1/6 - 1/M.',
     '空闲不足以保持：没有日程能在每 2、3 与 M 步内分别读到三个条件，无论 M 为何；而当 M >= 7 时，6 M 步内的读数共 5 M + 6，'
     '读者有 1/6 - 1/M 的份额空闲。',
     [R + 'no_two_three', R + 'two_three_room', R + 'spare_not_enough']),
    ('Half a reader suffices: two schedules interleaved read within twice their windows; a binary code reads a '
     'condition at depth k within 2^k; under Kraft\'s inequality one code reads every item; so windows with reciprocals '
     'summing to at most one half are read by one schedule and kept.',
     '半个读者即足够：两个交织的日程在两倍窗口内读到；二进码在 2^k 步内读到深度 k 的条件；满足 Kraft 不等式时一个码读到每一项；'
     '所以窗口倒数之和至多为二分之一时，一个日程读到并保持全部。',
     [R + 'weave', R + 'weave_left', R + 'weave_right', R + 'Code.At.reads', R + 'build_length', R + 'build_holds',
      R + 'kraft_reads', R + 'lg_spec', R + 'half_suffices', R + 'keeps_of_half']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

MARGIN_DEP = dep('significance-retained-within-margin', 'formal-reuse',
                 'Reuses Becoming.Retaining\'s margin law (Flow.Balances.retains_iff_within_margin, '
                 'Flow.Balances.loses_iff_beyond_margin): retention exactly where a part\'s net draw stays within the '
                 'margin.',
                 '复用 Becoming.Retaining 的余量定律（Flow.Balances.retains_iff_within_margin、Flow.Balances.loses_iff_beyond_margin）：'
                 '恰在部分的净汲取不超出余量处保留。',
                 'Retention exactly within the margin, under balance.', '平衡下恰在余量之内保留。',
                 'The window a reader must keep: the draw a withdrawal allows within the margin.',
                 '读者须保持的窗口：撤回所允许的、在余量之内的汲取。',
                 'Balance.', '平衡。', src('Retaining'))
LATE_DEP = dep('two-sided-regulation-and-late-reading', 'formal-reuse',
               'Reuses Becoming.Regulation\'s totals over stretches of steps (total_steps_le, total_steps_congr, '
               'total_steps_const); extends its one condition read at a time to one reader for several, its lateness '
               'shortening every window by one.',
               '复用 Becoming.Regulation 中步段上的总和（total_steps_le、total_steps_congr、total_steps_const）；把其一次读一个条件推广为'
               '一个读者读多个，其延迟使每个窗口缩短一步。',
               'A rule reading l late keeps no band narrower than 2 (l + 1) d.', '迟读 l 步的规则保持不了窄于 2 (l + 1) d 的带。',
               'The lateness l of a withdrawal after a reading.', '读到后撤回的延迟 l。',
               'Discrete steps, whole-number amounts.', '离散步、整数量。', src('Regulation'))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'One reader, several conditions', 'zh': '一个读者，多个条件'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'A schedule keeps a condition within its margin exactly where it reads it within its window; one reader '
              'carries windows whose reciprocals sum to at most one; below one need not suffice (windows 2, 3, M); '
              'one half suffices, by a dyadic code.',
        'zh': '日程恰在窗口内读到一个条件时才使它保持在余量之内；一个读者承载的窗口倒数之和至多为一；低于一未必足够（窗口 2、3、M）；'
              '二分之一足够，由二进码构成。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(MOD, names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Balance; a part drawing on one condition at most d a step, from a start until l steps after a '
              'step at or after the start at which the schedule reads that condition (several conditions at once for '
              'retains_of_read); the levels without the part exceeding the need by the margin. For counting, '
              'conditions distinct by their names; for the half theorem, positive windows and whole weights '
              '2^(D+1) <= q c a c totalling at most 2^D.',
        'zh': '不加公理。平衡；部分每步至多从一个条件汲取 d，从起点直到日程在起点或之后读到该条件之步后的 l 步（retains_of_read 可同时多个条件）；'
              '无该部分时的水平超出需求达余量。计数需诸条件按名相异；半数定理需窗口为正，且整数权重 2^(D+1) <= q c a c 之和至多为 2^D。'}],
    'does_not_show': [
        {'en': 'The density threshold: every set of windows whose reciprocals sum to at most five sixths can be read '
               '(Kawamura 2024, by computer search over finitely many cases) is cited, not proved; between one half '
               'and five sixths this record proves nothing.',
         'zh': '密度阈值：窗口倒数之和至多为六分之五的每组窗口都可读到（Kawamura 2024，经对有限多情形的计算机搜索）只是引用，未证明；'
               '在二分之一与六分之五之间本记录不证明任何东西。',
         'kind': 'scope'},
        {'en': 'Concentrated acts, caught only if that very act is read, and random auditing against them, as in AI '
               'control: the draw here is diffuse, a bounded amount a step caught by any reading within the window.',
         'zh': '集中的单次行为（只有恰好读到该行为才能发现）及针对它的随机审查，如 AI 控制中所做：这里的汲取是分散的，每步有界，'
               '窗口内任何一次读到都能发现。',
         'kind': 'scope'},
        {'en': 'That an actual overseer\'s conditions have known margins and draw bounds, or that its reading is one '
               'condition a step: the windows are derived from these premises, which are not measured here.',
         'zh': '实际监督者的条件有已知余量与汲取上界，或其读取为每步一个条件：窗口由这些前提导出，这里未加测量。',
         'kind': 'scope'},
        {'en': 'That a condition beyond the margin ought to be kept: the laws say what a reader can keep, not what it '
               'should.',
         'zh': '超出余量的条件应当被保持：这些规律说的是读者能保持什么，不是应当保持什么。',
         'kind': 'non-implication'}],
    'counterexamples': [{'path': src(MOD), 'detail': {
        'en': 'Windows 2, 3 and M for three conditions distinct by name: the counts fit with room for M >= 7, and no '
              'schedule reads the three (no_two_three, two_three_room): the counting bound is necessary, not '
              'sufficient. The witness drawer (Drawer.flow, Drawer.web): a stretch of a steps left unread loses the '
              'formation needing the condition, so a schedule that reads less than the window does not keep it.',
        'zh': '按名相异的三个条件，窗口 2、3 与 M：M >= 7 时读数有余裕，却没有日程能读到这三个（no_two_three、two_three_room）：'
              '计数界是必要的，不是充分的。见证汲取者（Drawer.flow、Drawer.web）：未被读到的 a 步使需要该条件的构成失去，'
              '所以读得少于窗口的日程不保持它。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_decl} declarations of '
              f'Becoming.{MOD}, {n_thm} of them theorems, have empty axiom reports; the checker verifies core purity. '
              f'Built and reviewed in one session, with no separate reviewer; author review in study section {N}; prior '
              'art in the significance review (reading-schedule-check); not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.{MOD} 的 {n_decl} 项声明（{n_thm} 项定理）公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；先行文献见重要性审查'
              '（reading-schedule-check）；未经人的独立审查。'},
    'next_delta': {
        'en': 'The density threshold between one half and five sixths on the spine; drawers whose draw a step varies '
              'with the level; concentrated acts and randomized reading; measured margins and draw bounds for an '
              'actual overseer; an independent review.',
        'zh': '在脊柱上证明二分之一与六分之五之间的密度阈值；每步汲取随水平变化的汲取者；集中的单次行为与随机读取；实际监督者的余量与'
              '汲取上界的测量；独立审查。'},
    'correspondence': {
        'en': 'Pinwheel scheduling (Holte, Mok, Rosier, Tulchinsky and Varvel 1989), motivated by a ground station reading '
              'satellites one at a time: the counting bound, the instance 2, 3, M and the one-half theorem are known '
              'there, and the five-sixths threshold is Kawamura\'s (2024). Deterministic patrolling with penetration '
              'times is the same window condition with travel. Keeping as reading within the window is delay '
              'observability (Park and Cho 2007) for one counter with a threshold. Reading (the AI\'s): oversight '
              'capacity is a pinwheel density, and spare attention does not show that a set of conditions can be kept.',
        'zh': '轮转调度（Holte、Mok、Rosier、Tulchinsky 与 Varvel 1989），源自一个地面站一次读一颗卫星：计数界、2、3、M 的情形与'
              '二分之一定理在那里已知，六分之五的阈值属于 Kawamura（2024）。带渗透时间的确定性巡逻是同一窗口条件加上移动。'
              '保持即在窗口内读到，是一个带阈值的计数器上的延迟可观测性（Park 与 Cho 2007）。读法（AI 的）：监督能力是轮转调度的密度，'
              '空闲的注意力不能表明一组条件可以被保持。'},
    'canonical_source': src(MOD),
    'aliases': ['one reader, several conditions', '一个读者，多个条件', 'pinwheel scheduling as oversight',
                'keeping is reading within the window', 'Becoming.ReadingSchedule.keeps_iff_within',
                'Becoming.ReadingSchedule.spare_not_enough', 'Becoming.ReadingSchedule.keeps_of_half'],
    'dependencies': [MARGIN_DEP, LATE_DEP],
    'related': [
        {'id': 'two-sided-regulation-and-late-reading', 'detail': {
            'en': 'Regulation reads one condition at a time; here one reader reads several, one a step.',
            'zh': '调节一次读一个条件；这里一个读者每步读一个，读多个。'}},
        {'id': 'what-pooled-coupling-reaches', 'detail': {
            'en': 'A pool reaches the union of its members\' closures; here a pool naming k conditions a step carries '
                  'k times what one reader carries.',
            'zh': '池触及其成员闭包的并；这里每步读 k 个条件的池承载一个读者的 k 倍。'}}],
    'references': [{'path': src(MOD), 'role': 'proof', 'declarations': sorted(d['name'] for d in m['declarations']),
                    'sha256': sha(src(MOD))},
                   {'path': src('Retaining'), 'role': 'proof', 'sha256': sha(src('Retaining'))},
                   {'path': src('Regulation'), 'role': 'proof', 'sha256': sha(src('Regulation'))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': REVIEW, 'role': 'review', 'sha256': sha(REVIEW)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(MOD), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'21 October 2026: added (RS1), after the oversight check left the reader\'s capacity open: keeping is '
              f'reading within the window, and what one reader can keep; study section {N}.',
        'zh': f'2026年10月21日：新增（RS1），监督检查留下读者容量的问题之后：保持即在窗口内读到，以及一个读者能保持什么；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, n_thm, n_decl)
