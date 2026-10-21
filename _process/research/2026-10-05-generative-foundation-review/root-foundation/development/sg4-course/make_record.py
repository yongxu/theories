#!/usr/bin/env python3
"""Write SG4's record re-optimizing-above-a-renewal-ends-it (a theorem), note it in room-read-off-the-exchange,
several-optimizers-drain-by-their-joint-capacity (whose laws are one step) and own-count-misses-joint-excess (whose
joint excess is supplied), and give the coverage file's alignment and degeneration rows the record and its law:
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
HEAD = f"## {N}. A course of re-optimizing steps against a renewal (SG4)"
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


RID = 're-optimizing-above-a-renewal-ends-it'
SG2 = 'room-read-off-the-exchange'
SG3 = 'several-optimizers-drain-by-their-joint-capacity'
OWN = 'own-count-misses-joint-excess'
SEEN = 'what-an-optimum-does-beyond-what-couples-in'
OM = 'Optimum'
RN = 'Optimum.Renewing.'

laws = [
    ('Along a level given at most r a step, however low it stands, and drawn above r at every step, the level never '
     'rises, falls by at least one a step while positive, stands below any positive need at every step past its '
     'starting excess over it, and once below stays below for good.',
     '水平每步至多被给予 r（无论多低）、每步被汲取多于 r 时，水平从不升高，为正时每步至少降一，在超过其起始超出需要之量的每一步都低于任何正的需要，一旦低于便永远低于。',
     ['Optimum.sub_le_sub_right_of_le', 'Optimum.sub_le_sub_left_of_le', 'Optimum.never_rises',
      'Optimum.level_stays_below', 'Optimum.level_le_start', 'Optimum.falls_over', 'Optimum.ends_within']),
    ('Given exactly r a step at or above the need, a level starting at the need and drawn at most r a step never falls; '
     'with at most r given below the need and k drawn at every step, it stays at the need exactly where k ≤ r.',
     '在需要处或其上每步恰被给予 r 时，自需要处开始、每步至多被汲取 r 的水平从不降低；需要之下至多给予 r、每步汲取 k 时，恰在 k ≤ r 时留在需要处。',
     ['Optimum.kept_at_need', 'Optimum.kept_iff_within']),
    ('What stands with everything drawn is the start with everything given, so where the level ends no higher than it '
     'started, everything given was drawn. Over n steps at most the start with r a step is drawn; within the renewal, '
     'k a step.',
     '所存加全部所汲取等于起始加全部所给；故水平终了不高于起始时，所给的全被汲取。n 步中至多汲取起始加每步 r；在更新之内每步 k。',
     ['Optimum.drawnAt', 'Optimum.level_add_drawn', 'Optimum.given_le_drawn', 'Optimum.sum_le_mul',
      'Optimum.mul_le_sum', 'Optimum.drawn_within', 'Optimum.sub_sub_of_le', 'Optimum.kept_drawn']),
    ('Gated, with nothing given below the need, a draw above the renewal draws at most the start with r for each of '
     'its units, however long; so a positive draw is bounded exactly where r < k, and over a long course keeping '
     'draws more.',
     '有闸门、需要之下不给予时，超出更新的汲取无论多久至多为起始加其每个单位 r；故正的汲取恰在 r < k 时有界，长过程中保持者汲取更多。',
     ['Optimum.renews_of', 'Optimum.sum_le_mul_until', 'Optimum.ended_drawn_le', 'Optimum.keeping_draws_more',
      'Optimum.drawn_bounded_iff']),
    ('Ungated, with at least a and at most r given at every step however low the level, a draw above r draws at least '
     'a a step, without bound for a positive a: with a = r, as much as keeping draws.',
     '无闸门、无论水平多低每步至少给予 a、至多 r 时，超出 r 的汲取每步至少为 a，a 为正时无界：a = r 时与保持者所汲取一样多。',
     ['Optimum.drawn_at_least', 'Optimum.drawn_unbounded']),
    ('In a course of re-optimizing steps, each an optimum of the part\'s order among the outcomes open to it, the rest '
     'exchanging as it does, each step\'s level at a condition beyond is the level before with what the rest gives, '
     'less what it takes and the part\'s capacity, or nothing; at mutual best responses along a balanced course, less '
     'the optimizers\' joint capacity.',
     '在重新优化的过程中，每步是部分在其可达结果中其序的最优、其余者照常交换，之外条件上每步的水平为前一步水平加其余者所给、减其所取与部分的容量，或为零；在平衡过程每步的相互最优回应中，减去优化者的合计容量。',
     ['Optimum.Reoptimizes', 'Optimum.course_beyond', 'Optimum.mutual_course_beyond']),
    ('Where the rest renews a condition beyond by exactly r a step at a positive need and by at most r below, and takes '
     'there with the capacity k a step, a dependence at that need, met at the start, is lost exactly where r < k, and '
     'the condition stays at the need exactly where k ≤ r; several optimizers jointly above the renewal lose it, '
     'however small each one\'s capacity.',
     '其余者在正的需要处每步恰更新之外的条件 r、其下至多 r，并连同容量每步取 k 时，该需要处起始时被满足的依存恰在 r < k 时丧失，条件恰在 k ≤ r 时留在需要处；合计超出更新的多个优化者使其丧失，无论各自容量多小。',
     ['Optimum.last_before', 'Web.lost_over', 'Web.lost_iff', 'Web.course_lost_iff', 'Web.course_kept_iff',
      'Web.mutual_course_lost']),
    ('Over such a course nothing is drawn beyond the start with r a step. Gated, as where the givers are supported and '
     'depend on the condition at the need, a course above the renewal draws a bounded amount; ungated, with at least a '
     'given every step, the dependence is lost while at least a a step is drawn, without bound.',
     '这样的过程中所汲取不超过起始加每步 r。有闸门时（如给予者受支持且在该需要处依存于条件），超出更新的过程所汲取有界；无闸门、每步至少给予 a 时，依存丧失，而每步至少汲取 a，无界。',
     ['Flow.restGiven_unsupported', 'Web.course_drawn_within', 'Web.course_ended_drawn',
      'Web.course_drawn_unbounded']),
    ('Witness: a taker of capacity k drawing the store\'s optimum at every step from a source renewed by r at its need '
     'of two, nothing below: the dweller\'s dependence is lost exactly where r < k; with a positive capacity the store '
     'is bounded exactly there, gains k a step within it, and with r < k holds less after a long course than a taker '
     'of capacity r.',
     '见证：容量 k 的取者每步取库的最优，源在其需要二处被更新 r、其下为零：居者的依存恰在 r < k 时丧失；容量为正时库恰在那时有界，在其内每步增 k，r < k 时长过程后所存少于容量 r 的取者。',
     [RN + n for n in ['renewal', 'source', 'renewed', 'draw', 'store', 'level', 'course', 'source_within',
                       'renewed_at', 'renewed_below', 'renewal_le', 'draw_le', 'le_draw', 'course_balances',
                       'course_within', 'course_optimum', 'course_reoptimizes', 'source_beyond', 'restGiven_source',
                       'draws_source', 'renewing_source', 'unsupported_source', 'lost_iff', 'store_eq_sum',
                       'store_bounded', 'store_kept', 'keeping_holds_more', 'store_bounded_iff']]),
    ('Two takers of capacity one, each ordering by the store, at mutual best responses at every step, lose a source '
     'renewed by r < 2, though alone a taker of capacity one keeps a source renewed by one; a restrained course, none '
     'of whose steps is a mutual best response, holds more in the store after a long course.',
     '两个容量为一、各按库排序的取者，每步处于相互最优回应，使更新 r < 2 的源丧失，虽然单独一个容量为一的取者保住更新为一的源；节制的过程没有一步是相互最优回应，长过程后库中所存更多。',
     [RN + n for n in ['takeOne', 'takeOne_le_one', 'sub_takeOne', 'takeOne_split', 'le_takeOne', 'jointSource',
                       'avail', 'first', 'second', 'jointStore', 'jointLevel', 'jointCourse', 'jointWeb',
                       'joint_split', 'joint_course_balances', 'joint_course_within', 'first_optimum',
                       'second_optimum', 'joint_course_best', 'joint_restGiven', 'joint_course_lost', 'alone_kept',
                       'joint_store_eq_sum', 'joint_store_bounded', 'restrainedCourse', 'restrainedLevel',
                       'restrained_course_balances', 'restrained_course_not_best', 'restraint_holds_more']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Prelude': ['Becoming.Distinct', 'Becoming.total', 'Becoming.le_dest', 'Becoming.sub_eq_zero_of_le',
                    'Becoming.succ_sub_self', 'Becoming.Naturals.add_sub_cancel',
                    'Becoming.Naturals.add_sub_cancel_left', 'Becoming.Naturals.add_sub_of_le',
                    'Becoming.Naturals.le_of_add_le_add_left', 'Becoming.Naturals.le_of_add_le_add_right',
                    'Becoming.Naturals.le_sub_of_add_le', 'Becoming.Naturals.sub_add_cancel',
                    'Becoming.Naturals.sub_sub'],
        'World': ['Becoming.Flow', 'Becoming.Web'],
        'Flow': ['Becoming.Flow.Balances', 'Becoming.Flow.GiversSupported', 'Becoming.total_zero'],
        'Population': ['Becoming.total_congr_on'],
        'Amounts': ['Becoming.Amounts.whole', 'Becoming.Amounts.sum'],
        'Dependence': ['Becoming.Web.Lost'],
        'DrawnBeyond': ['Becoming.DrawnBeyond.source_apart'],
        'Selection': ['Becoming.Diversion.Formation', 'Becoming.Diversion.Place', 'Becoming.Diversion.web'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Flow.ActsWithin', 'Becoming.Flow.Outcome', 'Becoming.Flow.capacity', 'Becoming.Flow.restGiven',
           'Becoming.Flow.restTaken', 'Becoming.Optimum.Rising', 'Becoming.Optimum.optimum_beyond',
           'Becoming.Optimum.alone', 'Becoming.Optimum.alone_self', 'Becoming.Optimum.MutualBest',
           'Becoming.Optimum.MutualBest.full', 'Becoming.Optimum.mutual_beyond',
           'Becoming.Optimum.Drain.formations_distinct', 'Becoming.Optimum.Drain.storeOrder',
           'Becoming.Optimum.Drain.storeOrder_rising', 'Becoming.Optimum.Drain.store_source_distinct',
           'Becoming.Optimum.Drain.takerCap', 'Becoming.Optimum.Drain.takerPart',
           'Becoming.Optimum.TwoTakers.Member', 'Becoming.Optimum.TwoTakers.takers',
           'Becoming.Optimum.TwoTakers.capOf', 'Becoming.Optimum.TwoTakers.members_distinct',
           'Becoming.Optimum.TwoTakers.lists']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Re-optimizing above a renewal ends it', 'zh': '在更新之上重新优化将其终结'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Over a course in which a part re-optimizes at every step, a dependence on a condition beyond, renewed by r '
              'at its need and at most r below, is lost exactly where the draw exceeds r, for good; the '
              'renewal below the need decides only the drawers\' take; several optimizers jointly above r lose it.',
        'zh': '部分每步重新优化的过程中，对之外条件的依存（在其需要处每步更新 r、其下至多 r）恰在那里的汲取超出 r 时永久丧失；需要之下的更新只决定汲取者所取；合计超出 r 的多个优化者使其丧失。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Discrete steps, natural amounts. A course of re-optimizing steps (each an optimum of the '
               'part\'s rising order among the outcomes open to it, the rest exchanging as it does) or a balanced course '
               'of mutual best responses; the condition beyond; the rest giving it exactly r at or above a positive need, '
               'at most r below; its take with the capacity k a step; a dependence at that need met at the start.',
         'zh': '不加公理。离散步与自然数量；重新优化的过程（每步是部分升高之序在可达结果中的最优，其余者照常交换），或相互最优回应的平衡过程；'
               '条件在之外；其余者在正的需要处或其上恰给予 r、其下至多 r；其所取连同容量每步为 k；该需要处起始时被满足的依存。'},
        {'en': 'For the draw, the renewal below the need: nothing there (gated) or at least a at every step (ungated). Which '
               'formations optimize, by which order and capacity, and the renewal, are supplied; the core asserts no '
               'course of any actual optimizer.',
         'zh': '对汲取而言，需要之下的更新：为零（有闸门）或每步至少 a（无闸门）。哪些构成优化、按何序与容量，以及更新，都是给定的；核心不对任何实际优化者的过程作断言。'}],
    'does_not_show': [
        {'en': 'A renewal varying with the level at or above the need (logistic growth, with an interior sustained '
               'yield): the renewal here is exactly r there.',
         'zh': '在需要处或其上随水平变化的更新（逻辑斯谛增长，有内部的可持续产量）：此处那里的更新恰为 r。', 'kind': 'scope'},
        {'en': 'An optimizer ranking courses rather than steps (a sole owner), an equilibrium of the course rather than '
               'mutual best responses step by step, and how optimizers come to them.',
         'zh': '对过程而非对步排序的优化者（唯一所有者）、过程的均衡而非逐步的相互最优回应，以及优化者如何达到它们。', 'kind': 'scope'},
        {'en': 'A witness course of the ungated draw: its laws are general, the witness is gated.',
         'zh': '无闸门汲取的见证过程：其律是一般的，见证有闸门。', 'kind': 'scope'},
        {'en': 'That the loss is a harm, or that a capacity within the renewal or a coupling is better: no evaluation '
               'enters; less in the store is by the optimizer\'s own order.',
         'zh': '丧失是伤害、更新之内的容量或耦合更好：没有评价进入；库中较少是按优化者自己的序。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src(OM), 'detail': {
        'en': 'restrainedCourse: one taker draws a unit a step and the other nothing, the source kept at its start; no '
              'step of it is a mutual best response (Optimum.Renewing.restrained_course_not_best), and after a long '
              'course it holds more in the store (Optimum.Renewing.restraint_holds_more).',
        'zh': 'restrainedCourse：一个取者每步取一个单位，另一个不取，源留在起始处；它没有一步是相互最优回应（Optimum.Renewing.restrained_course_not_best），'
              '长过程后库中所存更多（Optimum.Renewing.restraint_holds_more）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed '
              'by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'A renewal growing with the level; an optimizer ranking courses; conditions within some optimizer\'s family; '
              'existence of a mutual best response; an independent review.',
        'zh': '随水平增长的更新；对过程排序的优化者；在某个优化者族内的条件；相互最优回应的存在；独立审查。'},
    'correspondence': {
        'en': 'Open-access depletion (Gordon 1954) and its dynamics with critical depensation (Clark, Mathematical '
              'Bioeconomics, 1976): lost exactly where the draw exceeds the renewal, for good, whatever the renewal below '
              'the need. Pumping above an inflow independent of the store, as groundwater recharge (Theis 1940), is the '
              'ungated case: the store empties and the take goes on at the inflow. The maximum sustainable yield '
              '(Schaefer 1954) is the largest draw kept; the sole owner ranking the course (Scott 1955) is not stated; '
              'the dynamic commons (Levhari and Mirman 1980) is read step by step. On the spine, T1\'s joint excess '
              '(Flow.joint_excess_ends) follows for optimizers. Reading (the AI\'s): raising the capacity of optimizers '
              'blind to a renewing dependence is safe exactly up to the renewal, the threshold set by their joint '
              'capacity; whether their own returns fall when it is lost turns on whether the renewal depends on what is '
              'drained, so those returns are no signal of the loss.',
        'zh': '开放进入的耗竭（Gordon 1954）及其在临界负补偿下的动态（Clark，《数理生物经济学》，1976）：恰在汲取超出更新时永久丧失，无论需要之下的更新如何。'
              '超出与存量无关的补给的抽取，如地下水补给（Theis 1940），是无闸门的情形：存量被抽空，所取按补给继续。最大可持续产量（Schaefer 1954）'
              '是保住的最大汲取；对过程排序的唯一所有者（Scott 1955）未陈述；动态公地（Levhari 与 Mirman 1980）逐步读出。在脊柱上，T1 的联合超出'
              '（Flow.joint_excess_ends）对优化者得出。读法（AI 的）：提高不见某个更新依存的优化者的容量，恰在更新之内是安全的，阈值由合计容量定；'
              '丧失时其自身所得是否下降取决于更新是否依赖被抽干者，故其所得不是丧失的信号。'},
    'canonical_source': src(OM),
    'aliases': ['re-optimizing above a renewal ends it', 'a course of re-optimizing steps',
                'open access over a renewing condition', 'the gate decides the draw', '在更新之上重新优化将其终结', 'Becoming.Optimum.Reoptimizes',
                'Becoming.Optimum.course_beyond', 'Becoming.Web.course_lost_iff'],
    'dependencies': [
        dep(SG2, 'formal-reuse',
            'course_beyond is optimum_beyond at each step; the totals reuse restTaken, restGiven and capacity.',
            'course_beyond 即每步的 optimum_beyond；合计复用 restTaken、restGiven 与 capacity。',
            'An optimum\'s level beyond at one step.', '最优在一步之外的水平。',
            'Each step\'s level beyond along a course.', '过程中每步之外的水平。',
            'The part\'s lists apart without repetition, its family holding a condition, at every step.',
            '部分的列表在每步分开且无重复，其族含一个条件。',
            src(OM)),
        dep(SG3, 'formal-reuse',
            'mutual_course_beyond is mutual_beyond at each step; the pair witness reuses the TwoTakers members, '
            'capacities and listings, and MutualBest.full for the restrained course.',
            'mutual_course_beyond 即每步的 mutual_beyond；成对见证复用 TwoTakers 的成员、容量与列表，并对节制的过程用 MutualBest.full。',
            'The level beyond every family at a mutual best response.', '相互最优回应中每个族之外的水平。',
            'The loss along a course of mutual best responses.', '相互最优回应过程中的丧失。',
            'A balanced course, a mutual best response at every step.', '平衡的过程，每步相互最优回应。',
            src(OM)),
        dep(SEEN, 'formal-reuse',
            'The witnesses order by the store (Drain.storeOrder, rising with it) on Diversion\'s places, the store apart '
            'from the source.',
            '见证在 Diversion 的处所上按库排序（Drain.storeOrder，随库升高），库与源分开。',
            'The store order and the Diversion places.', '库序与 Diversion 的处所。',
            'Optima of the store order along a course.', '过程中库序的最优。',
            'The store order rising with the store.', '库序随库升高。',
            src(OM))],
    'related': [
        {'id': SG2, 'detail': {'en': 'Room read off one step; this record reads a course of such steps.',
                               'zh': '从一步读出余地；本记录读出这样的步组成的过程。'}},
        {'id': SG3, 'detail': {'en': 'Several optimizers at one mutual best response; here at every step of a course.',
                               'zh': '多个优化者在一次相互最优回应中；此处在过程的每一步。'}},
        {'id': OWN, 'detail': {'en': 'The joint excess T1\'s laws take as given, and the constructed gap between each '
                                     'drawer\'s own count and the joint draw, derived here for optimizers.',
                               'zh': 'T1 之律所给定的联合超出，以及每个汲取者自身计数与联合汲取之间构造的差距，此处对优化者导出。'}}],
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
        'en': f'21 October 2026: added (SG4), a course of re-optimizing steps against a renewal: a dependence beyond is '
              f'lost exactly where the draw exceeds the renewal, for good, and kept within it, with no gate; the renewal '
              f'below the need decides only the drawers\' take, bounded where it stops and at least the renewal a step '
              f'where it does not; several optimizers jointly above it lose it; study section {N}.',
        'zh': f'2026年10月21日：新增（SG4），对更新的重新优化过程：之外的依存恰在汲取超出更新时永久丧失，在其内保持，不需闸门；需要之下的更新'
              f'只决定汲取者所取，停止时有界，不停止时每步至少为更新；合计超出更新的多个优化者使其丧失；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500
for h in rec['hypotheses']:
    assert len(h['en']) <= 420, len(h['en'])
for h in rec['does_not_show']:
    assert len(h['en']) <= 240, len(h['en'])
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, len(new), 'declarations')

# The room, mutual and own-count records: notes; their laws are unchanged.
for rid, en_detail, zh_detail, en_hist, zh_hist in [
        (SG2, 'A course of such steps against a renewal.', '对更新的这样的步组成的过程。',
         'a course of re-optimizing steps against a renewal, each step read off by this record\'s law',
         '对更新的重新优化过程，每步由本记录之律读出'),
        (SG3, 'Mutual best responses at every step of a course against a renewal.', '对更新的过程中每步的相互最优回应。',
         'mutual best responses at every step of a course: jointly above the renewal, the optimizers lose it',
         '过程中每步的相互最优回应：合计超出更新时，优化者使其丧失'),
        (OWN, 'The joint excess and the gap between own and joint draw, derived for optimizers along a course.',
         '联合超出以及自身与联合汲取之间的差距，对过程中的优化者导出。',
         'the joint excess these laws take as given, derived for optimizers re-optimizing along a course, the loss '
         'exactly where the draw exceeds the renewal and, for a draw the same at every step, without the premise that '
         'renewal stops below the need',
         '这些律所给定的联合超出，对沿过程重新优化的优化者导出，恰在汲取超出更新时丧失，每步汲取相同时不需要更新在需要之下停止这一前提')]:
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {'en': en_detail, 'zh': zh_detail}}]
    d['history'].append({
        'en': f'21 October 2026, SG4: {en_hist} (record {RID}, study section {N}); this record\'s laws and their '
              'statements are unchanged.',
        'zh': f'2026年10月21日，SG4：{zh_hist}（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
for rowid, after_rec, after_decl in [('alignment', SG3, 'Becoming.Optimum.mutual_beyond'),
                                     ('degeneration', 'margin-of-a-regime', 'Becoming.RegimeMargin.ends_iff_below')]:
    row = next(r for r in cov['rows'] if r['id'] == rowid)
    assert RID not in row['records']
    row['records'].insert(row['records'].index(after_rec) + 1, RID)
    row['declarations'].insert(row['declarations'].index(after_decl) + 1, 'Becoming.Web.course_lost_iff')
    print('coverage row', rowid)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
