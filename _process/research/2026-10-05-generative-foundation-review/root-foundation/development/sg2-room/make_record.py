#!/usr/bin/env python3
"""Write SG2's record room-read-off-the-exchange (a theorem), note it in what-an-optimum-does-beyond-what-couples-in
(whose open premise it derives for one step), and give the coverage file's alignment row the record and its law:
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
HEAD = f"## {N}. Room read off the exchange (SG2)"
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


RID = 'room-read-off-the-exchange'
SG1 = 'what-an-optimum-does-beyond-what-couples-in'
RISE = 'what-a-rise-draws-from-beyond'
OM = 'Optimum'

laws = [
    ('The outcomes open to a part across one step are the levels after every balanced step in which the formations '
     'outside the part exchange as they do and each member takes from each condition at most its capacity, gives only to '
     'the listed conditions and gives them no more than it takes from them; the step that happened is one, and what such '
     'a step takes from a condition is what the rest takes with at most the capacity.',
     '部分跨一步可达的结果：凡部分之外的构成照常交换、每个成员从每个条件至多取其容量、只给所列条件且所给不多于所取的平衡步之后的水平；'
     '发生的那一步即其一；这样的步从一个条件所取，是其余者所取加至多容量。',
     ['Flow.restTaken', 'Flow.restGiven', 'Flow.capacity', 'Flow.ActsWithin', 'Flow.Outcome', 'Flow.Outcome.of_balances',
      'Flow.capacity_eq_zero', 'Flow.ActsWithin.taken_eq', 'Flow.ActsWithin.given_eq', 'Flow.ActsWithin.part_taken_le',
      'Flow.other_of_out', 'total_split']),
    ('A member with capacity to spare at a condition can take one more unit there and give it to a condition of the '
     'family, and a member giving a unit at a condition can give it to the family instead; either step stays within the '
     'part\'s capacity and balances into the transfer of one unit from that condition into the family.',
     '在某条件上容量有余的成员可在那里多取一个单位并给予族中某个条件；在某条件上给出一个单位的成员可改给族；'
     '两种步都在部分的容量之内，并平衡成把一个单位从该条件移入族。',
     ['total_raise_at', 'Flow.moveUnit', 'Flow.redirect', 'Flow.moveUnit_take', 'Flow.moveUnit_give',
      'Flow.redirect_give', 'Flow.moveUnit_taken_at', 'Flow.moveUnit_taken_off', 'Flow.moveUnit_given_at',
      'Flow.moveUnit_given_off', 'Flow.redirect_given_at', 'Flow.redirect_given_to', 'Flow.redirect_given_off',
      'Flow.moveUnit_balances', 'Flow.redirect_balances', 'Flow.ActsWithin.moveUnit', 'Flow.ActsWithin.redirect']),
    ('Among the outcomes open to a part above any floors beyond, an outcome above another at a condition beyond is '
     'exceeded on the family by an outcome open to the part: under the other step some member takes more there or gives '
     'less there, and this step can move or redirect a unit into the family. Room holds with no premise beyond listings '
     'without repetition.',
     '在部分可达、之外不低于任何底线的结果中，在之外某条件上高于另一结果者，在族上被一个部分可达的结果超过：'
     '另一步中某成员在那里取得更多或给得更少，本步即可把一个单位移入或改给族。余地成立，除列表无重复外不加前提。',
     ['Optimum.Above', 'Optimum.transfer_above', 'Optimum.Above.transfer', 'Optimum.member_below', 'Optimum.Above.room']),
    ('Above its floor, at every step to an optimum of every order rising with the family, each member takes its '
     'whole capacity at a condition beyond and gives nothing there, so the optimum stands at its floor or at what the '
     'rest leaves less the capacity; with no floor, every optimum stands at each condition beyond at the level before '
     'with what the rest gives, less what it takes, less the part\'s capacity, or at nothing.',
     '在底线之上，达到每个随族升高之序的最优的每一步，每个成员在之外条件上取其全部容量且不给予，故最优立于其底线，或立于其余者所留减去容量处；'
     '无底线时，每个最优在之外每个条件上立于先前水平加其余者所给、减其所取、减部分的容量处，或为零。',
     ['Optimum.Above.full', 'Optimum.Above.floor_or_full', 'Optimum.above_nothing', 'Optimum.optimum_beyond']),
    ('Where no member may take from a condition beyond, every optimum leaves it where the rest leaves it; an optimum '
     'lowers it below that exactly where the part has some capacity there and the rest leaves something there; on a web, '
     'a dependence beyond met at the step is broken exactly where its need exceeds what the rest leaves less the '
     'capacity.',
     '没有成员可从之外某条件取时，每个最优把它留在其余者所留之处；最优使它低于此处，恰当部分在那里有容量且其余者在那里留有东西；'
     '在依存网上，该步被满足的之外依存被打断，恰当其需要超过其余者所留减去容量。',
     ['Optimum.optimum_untouched', 'Optimum.optimum_lowers_iff', 'sub_lt_self_iff', 'Web.optimum_broken_iff_capacity']),
    ('Witness on Diversion: a taker with capacity k at the source and none at the store draws k from the source into the '
     'store; for k at most two this is an optimum of the store\'s order among the outcomes open to it, and the dweller\'s '
     'dependence on the source at need two breaks exactly where k is positive.',
     'Diversion 上的见证：在源有容量 k、在库无容量的取者，把 k 从源取入库；k 至多为二时，这是库的序在其可达结果中的最优，'
     '居住者以需要二对源的依存恰在 k 为正时被打断。',
     ['Optimum.Drain.takerPart', 'Optimum.Drain.takerCap', 'Optimum.Drain.drawing', 'Optimum.Drain.before',
      'Optimum.Drain.drawnTo', 'Optimum.Drain.drawnLevel', 'Optimum.Drain.formations_distinct',
      'Optimum.Drain.store_source_distinct', 'Optimum.Drain.drawing_within', 'Optimum.Drain.drawing_optimum',
      'Optimum.Drain.drawing_broken_iff']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old_names = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{OM}')['declarations']}
OMfull = decls(OM)
new = sorted(d for d in OMfull if d not in old_names)
cited = sorted(d for _, _, names in laws for d in resolve(OM, names))
assert cited == new, (set(new) - set(cited), set(cited) - set(new))
USED = {'Flow': ['Becoming.Flow.taken', 'Becoming.Flow.given', 'Becoming.total_congr', 'Becoming.total_add',
                 'Becoming.total_zero'],
        'World': ['Becoming.Flow'],
        'Prelude': ['Becoming.Distinct', 'Becoming.total', 'Becoming.sub_eq_zero_of_le'],
        'Locality': ['Becoming.exists_lt_of_total_lt'],
        'Population': ['Becoming.total_congr_on'],
        'Dependence': ['Becoming.Web.Broken'],
        'DrawnBeyond': ['Becoming.Web.MetOn', 'Becoming.DrawnBeyond.dwellerOn', 'Becoming.DrawnBeyond.met_source',
                        'Becoming.DrawnBeyond.source_apart'],
        'Selection': ['Becoming.Diversion.web', 'Becoming.Diversion.Formation', 'Becoming.Diversion.Place'],
        'Frontier': ['Becoming.Requirement.Frontier']}
SG1_USED = ['Becoming.Optimum.Exceeds', 'Becoming.Optimum.Rising', 'Becoming.Optimum.Room', 'Becoming.Optimum.transfer',
            'Becoming.Optimum.transfer_exceeds', 'Becoming.Optimum.Drain.storeOrder',
            'Becoming.Optimum.Drain.storeOrder_rising']
assert set(SG1_USED) <= old_names, set(SG1_USED) - old_names
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Room read off the exchange', 'zh': '从交换读出的余地'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Over one step of exchange, where a part\'s members take at most their capacity and give at most what they '
              'take, room holds; every optimum of every order rising with what couples in stands beyond at what the rest '
              'leaves less the part\'s capacity, lowering a condition just where the part has capacity.',
        'zh': '一步交换中，部分的成员至多取其容量、所给不多于所取时，余地成立；每个随耦合入者升高的序的最优，在之外立于其余者所留减去容量处，部分无可取处不动。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(OM, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. One step; the part (a Boolean on formations) and its members\' capacities; the family and the '
               'beyond listed apart without repetition, the family holding a condition; the formations taking part '
               'listed without repetition, those outside the part exchanging as they do; a member may give what it takes '
               'to any listed condition; for breaks, each condition beyond met at its need at the step; decidable '
               'equality.',
         'zh': '不加公理。一步；部分（构成上的布尔值）与每个成员在每个条件上的容量；族与之外分开列出且无重复，族含一个条件；参与的构成列出无重复；'
               '部分之外的构成照常交换；成员可把所取给予任何所列条件；打断需之外每个条件在该步被以其满足的需要依存；构成与条件的相等可判定。'},
        {'en': 'That a given optimizer\'s order rises with just the couplings listed, and that its part\'s capacities are '
               'these, are supplied; the core asserts them of no actual optimizer.',
         'zh': '某个优化者的序恰随所列耦合升高、其部分的容量即此，是给定的；核心不对任何实际的优化者断言它们。'}],
    'does_not_show': [
        {'en': 'A course of steps: an optimizer choosing again at each step, the levels before moving with it, and a rest '
               'responding to the part (the pool laws) are not stated.',
         'zh': '一个过程：优化者每步重新选择、先前水平随之变动、其余者回应部分（池的规律），均未陈述。', 'kind': 'scope'},
        {'en': 'Capacities enter as supplied amounts, as the levels before do; a member giving only to some listed '
               'conditions lies outside the outcomes stated.',
         'zh': '构成有何容量是给定的，不由构成之律导出；只能给予部分所列条件的成员不在其内。', 'kind': 'scope'},
        {'en': 'That the drain is a harm, or that a smaller capacity is better: no evaluation enters.',
         'zh': '抽干是伤害、容量更小更好：没有评价进入。', 'kind': 'non-implication'},
        {'en': 'Where the eligible outcomes are supplied otherwise, room can fail and the drive with it '
               '(Optimum.Drain.room_needed).',
         'zh': '可选结果另行给定时，余地可以不成立，压低随之不成立（Optimum.Drain.room_needed）。', 'kind': 'converse'}],
    'counterexamples': [{'path': src(OM), 'detail': {
        'en': 'drawing 0: a taker with no capacity at the source; the store\'s optimum leaves the source at two and the '
              'dweller\'s dependence unbroken (Optimum.Drain.drawing_broken_iff at k = 0): no drive where no units are '
              'shared.',
        'zh': 'drawing 0：在源无容量的取者；库的最优把源留在二，居住者的依存不被打断（Optimum.Drain.drawing_broken_iff 于 k = 0）：不共享单位处没有压低。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'Becoming.Optimum gained have empty axiom reports; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed '
              'by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Optimum 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Optima over a course of steps, the optimizer choosing again at each, with the rest responding and the beyond '
              'renewing; capacities from a law of the formations; an independent review.',
        'zh': '一个过程上的最优：优化者每步重新选择，其余者回应，之外更新；由构成之律得出容量；独立审查。'},
    'correspondence': {
        'en': 'Zhuang and Hadfield-Menell (NeurIPS 2020) assume, for their Theorem 1, a resource constraint strictly '
              'increasing in each attribute: room, supplied. Here it is read off conservation per member with capacity, '
              'the rest exchanging as it does. Saturation at an optimum is the saturated cut of a maximum flow (Ford and '
              'Fulkerson 1956) and the binding constraints of a corner solution. Reading (the AI\'s): at an optimum the '
              'drain at a condition beyond is the part\'s capacity there or all that stands, whichever is less; what the '
              'order registers of the beyond does not enter, what the part can take does.',
        'zh': 'Zhuang 与 Hadfield-Menell（NeurIPS 2020）的定理 1 假设资源约束在每个属性上严格递增：即给定的余地。此处它从每个成员的守恒与容量读出，'
              '其余者照常交换。最优处的饱和即最大流的饱和割（Ford 与 Fulkerson 1956）与角点解的紧约束。读法（AI 的）：最优处之外某条件的抽干，'
              '是部分在那里的容量与那里所有者中较小者；序对之外记录什么不进入，部分能取什么进入。'},
    'canonical_source': src(OM),
    'aliases': ['room read off the exchange', 'room from conservation with capacity', 'the drain where units are shared',
                '从交换读出的余地', 'Becoming.Optimum.Above.room', 'Becoming.Optimum.optimum_beyond',
                'Becoming.Web.optimum_broken_iff_capacity'],
    'dependencies': [
        dep(SG1, 'formal-reuse',
            'Room is SG1\'s Optimum.Room, derived here; the transfer of one unit and transfer_exceeds give the beating '
            'outcome; the orders are SG1\'s rising orders; the witness reuses its store\'s order.',
            '余地即 SG1 的 Optimum.Room，此处导出；一个单位的转移与 transfer_exceeds 给出胜过者；序为 SG1 的升高之序；见证复用其库的序。',
            'Rising orders, room, the transfer of a unit, the frontier of optima.', '升高之序、余地、单位的转移、最优的前沿。',
            'Room among the outcomes open to a part, and the optimum\'s level beyond.', '部分可达结果中的余地，以及最优在之外的水平。',
            'The family apart from the beyond and holding a condition.', '族与之外分开且含一个条件。',
            src(OM)),
        dep(RISE, 'formal-reuse',
            'The breaks use Web.MetOn; the witness reuses Diversion\'s dweller, its dependence on the source and the source '
            'apart from the store.',
            '打断用 Web.MetOn；见证复用 Diversion 的居住者、其对源的依存，以及源与库分开。',
            'Dependences met beyond; the Diversion witnesses.', '之外被满足的依存；Diversion 的见证。',
            'The break exactly where the need exceeds what the rest leaves less the capacity.', '恰在需要超过其余者所留减去容量处打断。',
            'Each condition beyond depended on at a need it meets at the step.', '之外每个条件在该步被以其满足的需要依存。',
            src('DrawnBeyond'))],
    'related': [
        {'id': SG1, 'detail': {'en': 'What an optimum does beyond what couples in, with room supplied; this record derives '
                                     'room for one step of exchange.',
                               'zh': '最优对耦合入者之外做什么（余地给定）；本记录对一步交换导出余地。'}},
        {'id': RISE, 'detail': {'en': 'What a rise draws from beyond; here the optimum\'s draw is exact, by capacity.',
                                'zh': '上升从其外汲取什么；此处最优的汲取按容量恰定。'}}],
    'references': [{'path': src(OM), 'role': 'proof', 'declarations': sorted(new + SG1_USED), 'sha256': sha(src(OM))}]
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
        'en': f'21 October 2026: added (SG2), room read off one step of exchange: room among the outcomes open to a part '
              f'within its capacity, every optimum beyond exactly at what the rest leaves less the capacity, untouched '
              f'where no units are shared; study section {N}.',
        'zh': f'2026年10月21日：新增（SG2），从一步交换读出的余地：部分在其容量内可达的结果中有余地，每个最优在之外恰立于其余者所留减去容量处，'
              f'不共享单位处不动；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
assert len(rec['correspondence']['en']) <= 1200 and len(rec['correspondence']['zh']) <= 500
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID, len(new), 'declarations')

# The optimum record: its open premise is derived for one step; its laws are unchanged.
p = RECORDS / f'{SG1}.json'
d = json.loads(p.read_text())
k_en = 'is not stated; room is a hypothesis.'
k_zh = '未陈述；余地是假设。'
first = d['does_not_show'][0]
assert first['en'].count(k_en) == 1 and first['zh'].count(k_zh) == 1
first['en'] = first['en'].replace(k_en, f'is not stated here; room is a hypothesis (derived for one step in {RID}, SG2).')
first['zh'] = first['zh'].replace(k_zh, f'此处未陈述；余地是假设。对其余者照常交换的一步，{RID} 导出它（SG2）。')
old_en, old_zh = d['next_delta']['en'], d['next_delta']['zh']
d['next_delta']['en'] = old_en.replace('Room derived from a law of exchange, the actor\'s takes and gives with the rest '
                                       'responding;', 'Room over a course of steps, the actor choosing again at each with '
                                       f'the rest responding (one step: {RID});')
d['next_delta']['zh'] = old_zh.replace('由交换之律导出余地，即行动者的取与给及其余者的回应；',
                                       f'一个过程中的余地，行动者每步重新选择、其余者回应（一步的情形：{RID}）；')
assert d['next_delta']['en'] != old_en and d['next_delta']['zh'] != old_zh
d['related'].append({'id': RID, 'detail': {'en': 'Derives the room this record supplies, for one step of exchange.',
                                           'zh': '对一步交换导出本记录所给定的余地。'}})
d['history'].append({
    'en': f'21 October 2026, SG2: room derived for one step of exchange (record {RID}, study section {N}); the scope '
          'note and the next delta say so; this record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月21日，SG2：对一步交换导出余地（记录 {RID}，研究第 {N} 节）；范围说明与下一步注明此事；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', SG1)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'alignment')
assert RID not in row['records']
row['records'].insert(row['records'].index(SG1) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.Web.optimum_broken_iff') + 1,
                           'Becoming.Optimum.optimum_beyond')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row alignment')
