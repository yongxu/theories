#!/usr/bin/env python3
"""Write SG1's record what-an-optimum-does-beyond-what-couples-in (a theorem), note it in what-a-rise-draws-from-beyond,
and give the coverage file's alignment row the record and its law on webs:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations (a short name must match exactly one
declaration of the named module), and the receipt must bind each cited module's current bytes."""
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
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. What optimizing through couplings does beyond them (SG1)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)
SLUG = f'{N}-what-optimizing-through-couplings-does-beyond-them-sg1'


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


RID = 'what-an-optimum-does-beyond-what-couples-in'
RISE = 'what-a-rise-draws-from-beyond'
RAISE = 'raising-what-couples-in-draws-from-beyond'
SEL = 'selection-through-couplings'
OM = 'Optimum'

laws = [
    ('Over any set of outcomes, every order rising with the levels of a family (ranking above every outcome that exceeds '
     'another on the family, whatever either holds beyond) has its optima at the least level beyond, condition by '
     'condition, exactly where every eligible outcome standing above another beyond is not unbeaten on the family.',
     '在任何结果集上，每个随一族水平升高的序（凡在族上超过另一结果者都排得更高，不论二者在之外如何），其最优逐条件地在之外最低的水平，'
     '当且仅当每个在之外某条件上高于另一结果的可选结果都并非在族上不被胜过。',
     ['Optimum.Exceeds', 'Optimum.Rising', 'Optimum.Least', 'Optimum.least_iff']),
    ('With room (an eligible outcome standing above another beyond is exceeded on the family by an eligible one), every '
     'optimum is there; shared units, the outcomes closed under moving a unit beyond into the family, give room.',
     '有余地时（在之外高于另一结果的可选结果，在族上被某个可选结果超过），每个最优都在那里；共享的单位，即结果集对把之外一个单位移入族封闭，给出余地。',
     ['Optimum.Room', 'Optimum.least_of_room', 'Optimum.transfer', 'Optimum.Shared', 'Optimum.transfer_exceeds',
      'Optimum.Shared.room', 'Optimum.least_of_shared']),
    ('The family\'s stock is a rising order, and an order ranking above wherever a rising order does is rising: a '
     'lexicographic order with the family first, whatever it counts after, drives the beyond all the same.',
     '族的存量是升高的序；凡在一个升高的序排得更高处都排得更高的序也是升高的：族在先的词典序，不论其后计入什么，同样压低之外。',
     ['Optimum.Exceeds.total_lt', 'Optimum.rising_total', 'Optimum.Rising.mono']),
    ('On a web whose levels after a step are such an optimum, with each condition beyond depended on at a need it meets, '
     'a dependence beyond is broken exactly where some eligible outcome leaves its condition below the need; where '
     'activity needs support and the dependence is as it was, its formation is not active after the step, is no member '
     'of a group coupled only into the family, and no member couples into its condition.',
     '在步后水平为这样一个最优的依存网上，若之外每个条件都被以其满足的需要依存，则之外的依存被打断，恰当某个可选结果使其条件低于需要；'
     '活动需要支持且依存照旧时，其构成在步后不活跃，不是只耦合入族的群体的成员，且没有成员耦合入其条件。',
     ['Web.optimum_broken_iff', 'Web.optimum_ends_beyond']),
    ('Of two balanced steps from equal totals, each gaining nothing on the whole, one leaves the family at most where the '
     'other does exactly where it leaves the beyond with the loss at least where the other does; among such moves the '
     'highest family stock is the least beyond with the loss.',
     '两个从相等总量出发、整体都无所增益的平衡步中，一个使族不高于另一个，恰当它使之外加损失不低于另一个；这样的动作中，族存量最高者恰是之外加损失最低者。',
     ['Flow.Balances.family_le_iff', 'Flow.top_iff_least']),
    ('Restricted to outcomes keeping every dependence beyond at its need, a rising order with room among them, each need '
     'attained by one of them, has its optimum break nothing, and in a balanced step gaining nothing on the whole the '
     'family rises, with the loss, by exactly the slack.',
     '限于使之外每个依存保持在其需要的结果，若其中有余地且每个需要都被其中某个达到，则一个升高的序的最优不打断任何依存；在整体无所增益的平衡步中，族连同损失恰升高余量之多。',
     ['Flow.keeping_optimum_takes_slack']),
    ('Witnesses on Diversion (three units between the source and the store, the dweller needing two): the store\'s optimum '
     'drains the source and the dweller ends; counting the source after the store drains it; without room keeping is an '
     'optimum not at the least level; a satisficing order is not rising and has both the keeping and the draining outcome '
     'among its optima; the keeping optimum takes the slack of one.',
     'Diversion 上的见证（源与库之间三个单位，居住者需要源有二）：库的最优抽干源，居住者终止；先库后源的计数照样抽干；没有余地时保持是最优而不在最低水平；'
     '满足式的序不是升高的，保持与抽干两个结果都在其最优之中；保持的最优恰取一个单位的余量。',
     ['Optimum.Drain.Split', 'Optimum.Drain.storeOrder', 'Optimum.Drain.drainedLevel', 'Optimum.Drain.storeOrder_rising',
      'Optimum.Drain.split_shared', 'Optimum.Drain.drained_optimum', 'Optimum.Drain.taker_couples_store',
      'Optimum.Drain.drained_ends', 'Optimum.Drain.countedAfter', 'Optimum.Drain.counted_after_drains',
      'Optimum.Drain.keptLevel', 'Optimum.Drain.low', 'Optimum.Drain.high', 'Optimum.Drain.satisficing',
      'Optimum.Drain.satisficing_either', 'Optimum.Drain.Spilling', 'Optimum.Drain.room_needed',
      'Optimum.Drain.Keeping', 'Optimum.Drain.keeping_room', 'Optimum.Drain.kept_takes_slack']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
OMfull = decls(OM)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert sorted(cited) == sorted(OMfull), (set(OMfull) - set(cited), set(cited) - set(OMfull))
USED = {'DrawnBeyond': ['Becoming.Flow.Balances.beyond_falls_exactly', 'Becoming.Web.MetOn.stock_eq', 'Becoming.Web.MetOn',
                        'Becoming.Web.slack', 'Becoming.DrawnBeyond.WithinSlack.level',
                        'Becoming.DrawnBeyond.WithinSlack.balances', 'Becoming.DrawnBeyond.dwellerOn',
                        'Becoming.DrawnBeyond.met_source', 'Becoming.DrawnBeyond.fixed_source',
                        'Becoming.DrawnBeyond.source_apart', 'Becoming.DrawnBeyond.whole_gainless'],
        'Frontier': ['Becoming.Requirement.Frontier']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'What an optimum does beyond what couples in', 'zh': '最优对耦合入者之外做什么'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Every order rising with what couples in has its optima at the least level beyond exactly where lowering it '
              'leaves room; an optimum breaks exactly the dependences beyond some outcome breaks; raising the family is '
              'lowering the beyond with the loss; keeping each dependence takes the slack.',
        'zh': '每个随耦合入者升高的序，其最优恰在降低之外留有余地时处于之外最低水平；最优恰好打断某个结果所打断的之外依存；升高族即降低之外加损失；保持每个依存恰取余量。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. The eligible outcomes, any set of level functions after a step; room among them, or shared units '
               'with the family apart from the beyond and holding a condition; for breaks, each condition beyond depended '
               'on at a need it meets at the step; for endings, that activity needs support (Dependent) and the '
               'dependence is as it was after the step; for the identity and the slack, balance and the whole gaining '
               'nothing across the step.',
         'zh': '不加公理。可选结果为步后水平函数的任意集合；其中的余地，或族与之外分开且含一个条件时的共享单位；打断需之外每个条件在该步被以其满足的需要依存；'
               '终止需活动需要支持（Dependent）且依存在步后照旧；等式与余量需平衡且整体在该步无所增益。'},
        {'en': 'That a given optimizer\'s order rises with just the couplings listed, and what it holds eligible, are '
               'supplied, as in the selection laws; the core asserts them of no actual optimizer.',
         'zh': '某个优化者的序恰随所列耦合升高、它以何者为可选，是给定的，与选择之律相同；核心不对任何实际的优化者断言它们。'}],
    'does_not_show': [
        {'en': 'Room derived from a law of exchange: which outcomes an actor\'s takes and gives make eligible, with the rest '
               'responding, is not stated; room is a hypothesis.',
         'zh': '由交换之律导出余地：行动者的取与给、其余者的回应使哪些结果可选，未陈述；余地是假设。', 'kind': 'scope'},
        {'en': 'Zhuang and Hadfield-Menell\'s continuous setting, their compactness characterization of guaranteed '
               'overoptimization, and their improvement by a proxy updated over time are not reached.',
         'zh': 'Zhuang 与 Hadfield-Menell 的连续情形、其对必然过度优化的紧性刻画，以及随时间更新代理的改进，均未达到。', 'kind': 'scope'},
        {'en': 'That the beyond\'s fall is a harm, or that keeping is better: no evaluation enters; that a widening move is '
               'chosen is the direction\'s (chapter 7.5), under C and the continuation condition.',
         'zh': '之外的降低是伤害、保持更好：没有评价进入；选择扩大的动作属于方向（第 7.5 节），在 C 与延续条件之下。', 'kind': 'non-implication'},
        {'en': 'Without room the drive fails: keeping can be an optimum (Optimum.Drain.room_needed); and an order rising only '
               'to a target need not drive or keep (Optimum.Drain.satisficing_either).',
         'zh': '没有余地，压低不成立：保持可以是最优（Optimum.Drain.room_needed）；只升到目标的序既不必压低也不必保持（Optimum.Drain.satisficing_either）。',
         'kind': 'converse'}],
    'counterexamples': [{'path': src(OM), 'detail': {
        'en': 'Spilling: two outcomes, the source kept or spilled with the store empty in both; under the store\'s order '
              'keeping is an optimum and is not at the least level beyond (Optimum.Drain.room_needed).',
        'zh': 'Spilling：两个结果，源被保留或泼掉，库在两者中都空；在库的序下，保持是最优且不在之外最低水平（Optimum.Drain.room_needed）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the '
              f'{len(OMfull)} declarations of Becoming.Optimum have empty axiom reports; the checker verifies core purity. '
              f'Built and reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              'independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 的 {len(OMfull)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Room derived from a law of exchange, the actor\'s takes and gives with the rest responding; optima over a '
              'run, where the beyond renews from its own level; an independent review.',
        'zh': '由交换之律导出余地，即行动者的取与给及其余者的回应；一段运行上的最优，其中之外依其自身水平更新；独立审查。'},
    'correspondence': {
        'en': 'Zhuang and Hadfield-Menell (NeurIPS 2020), Theorem 1: optimizing a proxy that references only some '
              'attributes drives the others to their lower bounds; here in discrete, conserved form over every order '
              'rising with what couples in, exact on any set of outcomes, with the degradation read as dependences '
              'broken. Mild optimization (Taylor 2016) is the satisficing witness: it neither drives nor protects. '
              'Reading (the AI\'s): blindness alone leaves the beyond unselected; with competition for the same units '
              'an optimum takes it to the floor.',
        'zh': 'Zhuang 与 Hadfield-Menell（NeurIPS 2020）定理 1：优化只涉及部分属性的代理把其余属性压到下界；此处为离散、守恒的形式，'
              '对每个随耦合入者升高的序，在任何结果集上恰当成立，退化读作被打断的依存。温和优化（Taylor 2016）即满足式的见证：既不压低也不保护。'
              '读法（AI 的）：单是不见只让之外不被选择；与同一些单位相竞争时，最优把它压到底。'},
    'canonical_source': src(OM),
    'aliases': ['what an optimum does beyond what couples in', 'the drive to the least level', 'optimizing a proxy',
                '最优对耦合入者之外做什么', 'Becoming.Optimum.least_iff', 'Becoming.Web.optimum_broken_iff',
                'Becoming.Flow.keeping_optimum_takes_slack'],
    'dependencies': [
        dep(RISE, 'formal-reuse',
            'The conservation identity and the slack law reuse Flow.Balances.beyond_falls_exactly and Web.MetOn.stock_eq; '
            'the breaks use Web.MetOn; the witnesses reuse Diversion\'s dweller and WithinSlack\'s world.',
            '守恒等式与余量之律复用 Flow.Balances.beyond_falls_exactly 与 Web.MetOn.stock_eq；打断用 Web.MetOn；见证复用 Diversion 的居住者与 WithinSlack 的世界。',
            'The beyond falls by the rise and the loss exactly; the stock of met dependences is the needs with the slack.',
            '之外恰降低上升之量加损失；被满足的依存之存量是需要加余量。',
            'The optimum\'s identity and its slack.', '最优的等式及其余量。',
            'Balance; the whole gaining nothing; dependences met beyond.', '平衡；整体无所增益；之外的依存被满足。',
            src('DrawnBeyond')),
        dep(SEL, 'formal-reuse',
            'The formations ended are coupled into by no member of a group coupled only into the family, through '
            'Web.CoupledInto, as in Flow.favours_breaking_beyond.',
            '被终止的构成，没有只耦合入族的群体成员耦合入它，经 Web.CoupledInto，与 Flow.favours_breaking_beyond 同。',
            'Coupling into a condition by dependence or by level.', '经依存或水平耦合入条件。',
            'That no member couples into what the optimum breaks.', '没有成员耦合入最优所打断者。',
            'Every condition a member couples into in the family; the beyond apart.', '成员所耦合入的每个条件都在族中；之外与之分开。',
            src(OM))],
    'related': [
        {'id': RISE, 'detail': {'en': 'What a rise draws from beyond; this record states what an optimum does there.',
                                'zh': '上升从其外汲取什么；本记录陈述最优在那里做什么。'}},
        {'id': RAISE, 'detail': {'en': 'Raising what couples in is paid from beyond; an optimum takes the beyond to the '
                                       'least level where that leaves room.',
                                 'zh': '升高耦合入者由之外支付；最优在留有余地时把之外压到最低水平。'}}],
    'references': [{'path': src(OM), 'role': 'proof', 'declarations': sorted(OMfull), 'sha256': sha(src(OM))}]
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
        'en': f'21 October 2026: added (SG1), what an optimum does beyond what couples in: the drive to the least level '
              f'exactly where there is room, the breaks exactly those some outcome makes, the conservation identity and '
              f'the slack under keeping; study section {N}.',
        'zh': f'2026年10月21日：新增（SG1），最优对耦合入者之外做什么：恰在有余地时压到最低水平，打断恰为某个结果所打断者，守恒等式与保持下的余量；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

# The rise record notes the optimum.
p = RECORDS / f'{RISE}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'What an optimum, not a rise, does beyond what couples in.',
                                           'zh': '最优（而非上升）对耦合入者之外做什么。'}})
d['history'].append({
    'en': f'21 October 2026, SG1: what an optimum does beyond what couples in (record {RID}, study section {N}); this '
          'record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月21日，SG1：最优对耦合入者之外做什么（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', RISE)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'alignment')
assert RID not in row['records']
row['records'].insert(row['records'].index(SEL) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.Flow.unselected_beyond_coupling') + 1,
                           'Becoming.Web.optimum_broken_iff')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row alignment')
