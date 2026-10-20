#!/usr/bin/env python3
"""Write SG3's record several-optimizers-drain-by-their-joint-capacity (a theorem), note it in
room-read-off-the-exchange and in what-a-rise-draws-from-beyond (whose joint-draw laws take the flows as supplied), and
give the coverage file's alignment row the record and its law:
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
HEAD = f"## {N}. Several optimizers at a mutual best response (SG3)"
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


RID = 'several-optimizers-drain-by-their-joint-capacity'
SG2 = 'room-read-off-the-exchange'
RISE = 'what-a-rise-draws-from-beyond'
OM = 'Optimum'
TT = 'Optimum.TwoTakers.'

laws = [
    ('A formation alone is a part. A step is a mutual best response where each optimizer taking part acts within its '
     'capacity in it and the levels after are an optimum of its own order among the outcomes open to it alone, the '
     'others exchanging as they do. Where something then stands beyond an optimizer\'s family, that optimizer takes '
     'its whole capacity there and gives nothing: restraint is no mutual best response.',
     '一个构成独自即一个部分。一步是相互最优回应，当每个参与的优化者在其中不超出容量，且步后水平是它独自可达结果中其自身之序的最优，其余者照常交换。'
     '此时某优化者的族之外的条件上若有所存，该优化者在那里取其全部容量且不给予：节制不是相互最优回应。',
     ['Optimum.alone', 'Optimum.alone_self', 'Optimum.MutualBest', 'Optimum.MutualBest.full']),
    ('At a condition beyond every optimizer\'s family, the levels after a mutual best response stand at the level '
     'before, with what the formations outside every optimizer give, less what they take, less the optimizers\' joint '
     'capacity, or at nothing; every optimum of one part made of all the optimizers, by any order rising with any family '
     'apart from the condition, leaves it there too.',
     '在每个优化者的族之外的条件上，相互最优回应之后的水平立于先前水平加所有优化者之外的构成所给、减其所取、减优化者的合计容量处，或为零；'
     '由全体优化者组成的一个部分，按随任何与该条件分开的族升高的任何序，其每个最优也把它留在那里。',
     ['Optimum.mutual_beyond', 'Optimum.mutual_as_one']),
    ('There the condition is lowered below where the formations outside every optimizer leave it exactly where the '
     'optimizers have some capacity there and something is left; on a web, a dependence on it met at the step breaks '
     'exactly where its need exceeds that level.',
     '那里的条件被降到所有优化者之外的构成所留之下，恰当优化者在那里有容量且仍有所留；在依存网上，该步被满足的对它的依存，恰在其需要超过此水平时被打断。',
     ['Optimum.mutual_lowers_iff', 'Web.mutual_broken_iff_capacity']),
    ('Witness: two takers, each of capacity one at a source standing at two and each ordering by the store; both drawing '
     'is a mutual best response, and the source falls by their joint capacity of two to nothing, each take within the '
     'slack of a need of one; the step where one restrains and a unit stands is no mutual best response.',
     '见证：两个取者，在立于二的源上容量各为一，各按库排序；两者都汲取是相互最优回应，源降低它们的合计容量二至零，每一取都在需要一的余量之内；'
     '一者节制而留下一个单位的步不是相互最优回应。',
     [TT + n for n in ['Member', 'takers', 'capOf', 'giveOf', 'joint', 'restrained', 'drained', 'kept',
                       'members_distinct', 'joint_within', 'joint_balances', 'gives_at_most_one', 'joint_optimum',
                       'joint_best', 'lists', 'joint_drains', 'within_slack_jointly_below', 'restrained_balances',
                       'restrained_not_mutual']]),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Flow': ['Becoming.Flow.taken', 'Becoming.Flow.given', 'Becoming.total_le', 'Becoming.total_zero'],
        'World': ['Becoming.Flow'],
        'Prelude': ['Becoming.Distinct', 'Becoming.total', 'Becoming.sub_eq_zero_of_le', 'Becoming.Naturals.sub_sub',
                    'Becoming.Naturals.add_sub_cancel'],
        'Population': ['Becoming.total_congr_on'],
        'Dependence': ['Becoming.Web.Broken'],
        'DrawnBeyond': ['Becoming.DrawnBeyond.source_apart'],
        'Selection': ['Becoming.Diversion.Place'],
        'Frontier': ['Becoming.Requirement.Frontier']}
EARLIER = ['Becoming.Optimum.Rising', 'Becoming.Optimum.Above.full', 'Becoming.Optimum.above_nothing',
           'Becoming.Optimum.optimum_beyond', 'Becoming.sub_lt_self_iff', 'Becoming.total_split',
           'Becoming.Flow.restTaken', 'Becoming.Flow.restGiven', 'Becoming.Flow.capacity', 'Becoming.Flow.ActsWithin',
           'Becoming.Flow.Outcome', 'Becoming.Optimum.Drain.before', 'Becoming.Optimum.Drain.storeOrder',
           'Becoming.Optimum.Drain.storeOrder_rising', 'Becoming.Optimum.Drain.store_source_distinct']
assert set(EARLIER) <= old_names, set(EARLIER) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Several optimizers drain by their joint capacity', 'zh': '多个优化者以合计容量抽干'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'At a mutual best response of several optimizers, each optimizing alone by its own order, a condition beyond '
              'every one\'s family falls by their joint capacity, as under one optimizer of that capacity; each takes its '
              'whole capacity wherever something stands.',
        'zh': '多个优化者各自按其序独自优化而处于相互最优回应时，每个族之外的条件降低它们的合计容量，与一个具有该容量的优化者相同；有所存处各取其全部容量。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. One step; the optimizers, each with its own family and beyond listed apart without repetition, '
               'its family holding a condition, its order rising with its family, and its capacity; the formations taking '
               'part listed without repetition; a mutual best response, the step balancing into the levels after; the '
               'condition beyond every optimizer\'s family; for breaks, a dependence met at the step.',
         'zh': '不加公理。一步；优化者各有其族与之外，分开列出且无重复，族含一个条件，其序随族升高，并有其容量；参与的构成列出无重复；相互最优回应，'
               '该步平衡成步后水平；条件在每个优化者的族之外；打断需该步被满足的依存。'},
        {'en': 'Which formations optimize, by which order and with which capacity, is supplied; the core asserts a mutual '
               'best response of no actual group of optimizers.',
         'zh': '哪些构成优化、按何序、有何容量，是给定的；核心不对任何实际的优化者群体断言相互最优回应。'}],
    'does_not_show': [
        {'en': 'That a mutual best response exists in general: the witness has one; where the outcomes open to each depend '
               'on the others, a step may have none.',
         'zh': '相互最优回应一般存在：见证中有一个；每者可达结果依赖于其他者时，一步可以没有。', 'kind': 'scope'},
        {'en': 'A condition within some optimizer\'s family, where its order registers the condition and the classical '
               'commons with a share borne lies; a course of steps and how learners come near a mutual best response.',
         'zh': '在某个优化者族内的条件，其序记录该条件，承担一份的经典公地在此；一个过程，以及学习者如何接近相互最优回应。', 'kind': 'scope'},
        {'en': 'That the drain is a harm, or that coupling or a lower capacity is better: no evaluation enters.',
         'zh': '抽干是伤害、耦合或较低容量更好：没有评价进入。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src(OM), 'detail': {
        'en': 'restrained: the first taker takes nothing and the second draws, leaving a unit at the source; it is no '
              'mutual best response, whatever the listings (Optimum.TwoTakers.restrained_not_mutual).',
        'zh': 'restrained：第一个取者不取，第二个汲取，源留一个单位；无论列表如何，它都不是相互最优回应（Optimum.TwoTakers.restrained_not_mutual）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed '
              'by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Conditions within some optimizer\'s family, where each bears a share; existence of a mutual best response; '
              'a course of steps with renewal; an independent review.',
        'zh': '在某个优化者族内、各承担一份的条件；相互最优回应的存在；带更新的一个过程；独立审查。'},
    'correspondence': {
        'en': 'The tragedy of the commons (Hardin 1968), open access (Gordon 1954) and the overappropriation of '
              'common-pool resource games (Ostrom, Gardner and Walker 1994), in the limit where no optimizer registers the '
              'condition: the drain is the whole joint capacity. Reading (the AI\'s): a commons none of its users couples '
              'into is drained by the sum of their capacities, whether they act each alone or together; what keeps it is a '
              'coupling into it or a lowered capacity, the means Ostrom (1990) found communities use.',
        'zh': '公地悲剧（Hardin 1968）、开放进入（Gordon 1954）与公共池塘资源博弈的过度占用（Ostrom、Gardner 与 Walker 1994），'
              '在没有优化者记录该条件的极限：抽干是全部合计容量。读法（AI 的）：其使用者都不耦合入的公地，被它们的容量之和抽干，'
              '不论各自独行还是一起；保住它的是耦合入它或降低容量，即 Ostrom（1990）发现社群所用的手段。'},
    'canonical_source': src(OM),
    'aliases': ['several optimizers drain by their joint capacity', 'a mutual best response beyond', 'the blind commons',
                '多个优化者以合计容量抽干', 'Becoming.Optimum.MutualBest', 'Becoming.Optimum.mutual_beyond',
                'Becoming.Optimum.mutual_as_one'],
    'dependencies': [
        dep(SG2, 'formal-reuse',
            'Each optimizer alone is SG2\'s part; MutualBest.full is Above.full with the floor nothing; mutual_as_one '
            'compares with optimum_beyond; the joint totals reuse restTaken, restGiven, capacity and total_split.',
            '每个优化者独自即 SG2 的部分；MutualBest.full 即底线为零的 Above.full；mutual_as_one 与 optimum_beyond 相比；合计复用 restTaken、restGiven、capacity 与 total_split。',
            'The outcomes open to a part, and an optimum\'s level beyond.', '部分可达的结果，以及最优在之外的水平。',
            'The level beyond at a mutual best response.', '相互最优回应在之外的水平。',
            'Each optimizer\'s lists apart without repetition, its family holding a condition.', '每个优化者的列表分开且无重复，其族含一个条件。',
            src(OM)),
        dep(RISE, 'formal-reuse',
            'The breaks use Web.Broken; the witness reuses Diversion\'s places and the source apart from the store.',
            '打断用 Web.Broken；见证复用 Diversion 的处所，以及源与库分开。',
            'Dependences met at a step; the Diversion places.', '一步中被满足的依存；Diversion 的处所。',
            'The break exactly where the need exceeds what the rest leaves less the joint capacity.', '恰在需要超过其余者所留减去合计容量处打断。',
            'A dependence met at the step.', '该步被满足的依存。',
            src('DrawnBeyond'))],
    'related': [
        {'id': SG2, 'detail': {'en': 'Room read off one step for one optimizing part; this record states several at once.',
                               'zh': '对一个优化的部分从一步读出余地；本记录陈述多个同时。'}},
        {'id': RISE, 'detail': {'en': 'Which dependence a joint draw breaks, with the flows supplied; here the draws of '
                                      'optimizers at a mutual best response are derived.',
                                'zh': '联合汲取打断哪个依存（流给定）；此处导出处于相互最优回应的优化者的汲取。'}}],
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
        'en': f'21 October 2026: added (SG3), several optimizers at a mutual best response: a condition beyond every '
              f'family falls by their joint capacity, as under one optimizer of that capacity, and restraint is no mutual '
              f'best response; study section {N}.',
        'zh': f'2026年10月21日：新增（SG3），处于相互最优回应的多个优化者：每个族之外的条件降低它们的合计容量，与一个具有该容量的优化者相同，'
              f'节制不是相互最优回应；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, len(new), 'declarations')

# The room record and the rise record: notes; their laws are unchanged.
for rid, en_detail, zh_detail, en_hist, zh_hist in [
        (SG2, 'Several optimizers at a mutual best response, each a part alone.', '处于相互最优回应的多个优化者，各自独为一个部分。',
         'several optimizers at a mutual best response, each a part alone', '处于相互最优回应的多个优化者，各自独为一个部分'),
        (RISE, 'How much each formation takes when several draw, derived for optimizers at a mutual best response.',
         '多个构成汲取时各取多少，对处于相互最优回应的优化者导出。',
         'how much each formation takes when several draw, which the joint-draw laws take as supplied, derived for '
         'optimizers at a mutual best response', '联合汲取之律所给定的多个构成各取多少，对处于相互最优回应的优化者导出')]:
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    d['related'] = d.get('related', []) + [{'id': RID, 'detail': {'en': en_detail, 'zh': zh_detail}}]
    d['history'].append({
        'en': f'21 October 2026, SG3: {en_hist} (record {RID}, study section {N}); this record\'s laws and their '
              'statements are unchanged.',
        'zh': f'2026年10月21日，SG3：{zh_hist}（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'alignment')
assert RID not in row['records']
row['records'].insert(row['records'].index(SG2) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.Optimum.optimum_beyond') + 1,
                           'Becoming.Optimum.mutual_beyond')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row alignment')
