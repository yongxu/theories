#!/usr/bin/env python3
"""Write OB1's record what-dependence-alone-carries-of-a-level (a theorem), note it in where-a-level-couples and
observation-is-a-route (whose kept conjecture it settles at the step of the exchange), and give the coverage file's
knowing row the record and its law:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION PREVIOUS_RECEIPT   (from the checkout root, after apply_text.py)

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
core_id, N, previous = sys.argv[1], int(sys.argv[2]), sys.argv[3]
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. What dependence alone carries of a level (OB1)"
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


RID = 'what-dependence-alone-carries-of-a-level'
LEVEL = 'where-a-level-couples'
ROUTE = 'observation-is-a-route'
LC = 'LevelCoupling'

laws = [
    ('Read activity needing support off a law at a step: a formation the levels there do not admit exchanges nothing '
     'across it. Under a law reading through dependence alone, such a formation outside the part takes and gives no '
     'less where the levels at the step stand no lower, the history before alike.',
     '把活动需要支持读于律的一步：该步水平不容许的形成跨该步不交换。单凭依存而读的律之下，部分之外这样的形成，在该步水平不更低、此前历史相同处，取与给都不更少。',
     ['ExchangeLaw.NeedsSupportAt', 'NoLowerAt', 'ExchangeLaw.Through.rises_at_step']),
    ('A response of giving carried by a family of such formations rises with the levels at the step, and gives less '
     'under one history than under another alike before the step only where some level at the step stands lower.',
     '这样的形成之族所承载的给予之回应，随该步水平升高；在此前相同的两段历史中，一段下给得更少，只在其某个该步水平更低处。',
     ['ExchangeLaw.CarriesGiving', 'ExchangeLaw.Through.carried_rises', 'ExchangeLaw.Through.carried_fall_needs_fall']),
    ('A response rising with one level up to a bound is carried by units at thresholds: unit j + 1 depends on the level '
     'at need j + 1 and gives the rise there, unit 0 gives the response at nothing; the units read through dependence '
     'alone and exchange only where supported.',
     '随一个水平升高到某界的回应，由各阈上的单元承载：单元 j + 1 以所需 j + 1 依存于该水平，给出那里的升幅，单元 0 给出水平为零时的回应；单元单凭依存而读，只在被支持处交换。',
     ['Layers.web', 'Layers.law', 'Layers.admits_iff', 'Layers.law_through', 'Layers.law_needsSupport',
      'Layers.dependsOn', 'Layers.rises_add', 'Layers.rises_stop', 'Layers.carry']),
    ('A response giving a condition an amount fixed by one level at the step, up to a bound, is carried by some family '
     'of formations each exchanging only where supported, under a law reading through dependence alone, exactly where '
     'it rises with that level up to the bound.',
     '给一个条件的量由该步一个水平决定的回应（到某界），恰在随该水平升高到该界之处，由单凭依存而读的律之下、各自只在被支持处交换的某个形成之族承载。',
     ['onlyAt', 'onlyAt_self', 'onlyAt_noLower', 'carried_iff_rising']),
    ('Where the level of d and of a condition e stand at the step at a fixed total N, unit j depending on d at need j and '
     'on e at need N - j is admitted exactly where d stands at j, so the units, one for each level up to N, carry every '
     'response to the level of d; they read through dependence alone and exchange only where supported.',
     'd 与条件 e 在该步的水平总量固定为 N 时，以所需 j 依存于 d、以所需 N - j 依存于 e 的单元 j，恰在 d 立于 j 时被容许，所以到 N 为止每个水平一个单元，承载对 d 水平的每个回应；单元单凭依存而读，只在被支持处交换。',
     ['eq_of_true_iff', 'ble_and_iff', 'total_steps_nothing', 'total_steps_only', 'Complement.web', 'Complement.law',
      'Complement.admits_iff', 'Complement.law_through', 'Complement.law_needsSupport', 'Complement.dependsOn',
      'Complement.admitted_iff', 'Complement.carry']),
    ('Supplying what a level lacks of a positive amount passes by level, under a law reading through a coupling by '
     'level; it is carried by no family through dependence alone over the levels up to a positive bound, and with a '
     'complement at a fixed total it is carried by the complement units.',
     '补足一个水平对某正量所缺者，在经水平耦合而读的律之下经水平通过；在直到某正界的水平上，没有单凭依存的族承载它；有总量固定的补时，由补的单元承载。',
     ['supplyLaw', 'supplyLaw_through', 'supply_not_carried', 'supply_carried_by_complement']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
P = json.loads(Path(previous).read_text())
old = {d['name'] for d in next(m for m in P['modules'] if m['module'] == f'Becoming.{LC}')['declarations']}
new = [d for d in decls(LC) if d not in old]
cited = sorted(d for _, _, names in laws for d in resolve(LC, names))
assert sorted(cited) == sorted(new), (set(new) - set(cited), set(cited) - set(new))
USED = {LC: ['Becoming.Web.alikeThrough_of_levels', 'Becoming.ble_eq_of_iff'],
        'Testing': ['Becoming.thresholdOnly', 'Becoming.Web.AlikeThrough', 'Becoming.Web.AlikeThroughUpTo'],
        'Admission': ['Becoming.Web.Admits', 'Becoming.Web.Admits.mono'],
        'Counterfactual': ['Becoming.ExchangeLaw', 'Becoming.ExchangeLaw.Through', 'Becoming.ExchangeLaw.GivesAlike'],
        'Feedback': ['Becoming.Web.DependsOn'],
        'Prelude': ['Becoming.total', 'Becoming.steps', 'Becoming.total_steps_add', 'Becoming.total_steps_succ',
                    'Becoming.Naturals.add_sub_of_le', 'Becoming.Naturals.add_sub_cancel_left'],
        'Flow': ['Becoming.total_le']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    assert set(names) <= have, (mod, set(names) - have)
    refs_used.append((mod, sorted(names)))
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'What dependence alone carries of a level', 'zh': '单凭依存承载一个水平的什么'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'At the step of the exchange, dependence alone, with activity needing support, carries of a level exactly '
              'the responses rising with it, and a fall only where some level falls; with a complement at a fixed '
              'total it carries every response.',
        'zh': '在交换之步，单凭依存（活动需要支持）承载一个水平，恰是随它升高的回应，下降只在某水平下降处；有总量固定的补时，承载每个回应。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(LC, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. Activity needing support read off the law at the step (NeedsSupportAt), as reading '
               'requirement as response gives it; a law reading through dependence alone (thresholdOnly, no level '
               'coupled by level), for the formations outside the part; for the units, a bound on the level; for the '
               'complement, the two levels at a fixed total at the step, with the complement a different condition.',
         'zh': '不加公理。活动需要支持读于律的该步（NeedsSupportAt），如把所需读为回应所给出；单凭依存而读的律（thresholdOnly，没有水平经水平耦合），'
               '对部分之外的形成；单元需水平有界；补需两个水平在该步总量固定，且补是另一个条件。'}],
    'does_not_show': [
        {'en': 'Which responses to levels at earlier steps dependence alone carries: a law may read whether a need was '
               'met at an earlier step, and through that a fall can pass (a crossing passes); the statement is at the '
               'step of the exchange.',
         'zh': '单凭依存承载对较早之步水平的哪些回应：律可以读较早之步所需是否被满足，下降可经此通过（跨越通过）；陈述在交换之步。', 'kind': 'scope'},
        {'en': 'A complement where the total is not fixed, by loss or by exchange beyond the pair; responses to several '
               'levels at once.',
         'zh': '总量不固定（因损失或与对之外交换）时的补；同时对几个水平的回应。', 'kind': 'scope'},
        {'en': 'That a given formation reads only its dependences, or that a condition has a complement in a given '
               'world: both are supplied where a law applies.',
         'zh': '某个形成只读其依存，或某个世界中某条件有补：两者都在律适用处给出。', 'kind': 'non-implication'},
        {'en': 'Without a complement the derivation fails: supplying a deficit is carried by no family through '
               'dependence alone (supply_not_carried), though it passes by level (supplyLaw_through).',
         'zh': '没有补，推导不成立：没有单凭依存的族承载补足亏欠（supply_not_carried），虽然它经水平通过（supplyLaw_through）。',
         'kind': 'converse'}],
    'counterexamples': [{'path': src(LC), 'detail': {
        'en': 'supplyLaw: giving what the level of d lacks of k > 0, carried by no family through dependence alone over '
              'the levels up to a positive bound (supply_not_carried), and carried with a complement at a fixed total '
              '(supply_carried_by_complement).',
        'zh': 'supplyLaw：给出 d 的水平对 k > 0 所缺者；在直到某正界的水平上没有单凭依存的族承载它（supply_not_carried），有总量固定的补时被承载'
              '（supply_carried_by_complement）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {len(new)} declarations '
              f'added to Becoming.LevelCoupling have empty axiom reports; the checker verifies core purity. Built and '
              f'reviewed in one session, with no separate reviewer; author review in study section {N}; not '
              'independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.LevelCoupling 新增的 {len(new)} 项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Responses to levels at earlier steps by dependence alone; several levels with their complements; a '
              'complement whose total changes with loss; an independent review.',
        'zh': '单凭依存对较早之步水平的回应；几个水平连同其补；总量随损失而变的补；独立审查。'},
    'correspondence': {
        'en': 'Settles, at the step of the exchange, the conjecture observation-is-a-route kept: that observation is no '
              'second relation beside dependence, obs derivable from dependence. Known mathematics read on the spine\'s '
              'relations: the layer cake; stack filters and threshold decomposition (Wendt, Coyle and Gallagher 1986); '
              'monotone Boolean functions and negation normal form; dual-rail logic (Qian and Winfree 2011). Reading '
              '(the AI\'s): observing a level is depending on it and on where its amount goes; conservation supplies '
              'the second rail in a closed pair at a fixed total.',
        'zh': '在交换之步解决 observation-is-a-route 保留的猜想：观察不是依存之外的第二种关系，obs 可由依存推出。读于脊柱诸关系的已知数学：层饼表示；'
              '堆栈滤波与阈分解（Wendt、Coyle 与 Gallagher 1986）；单调布尔函数与否定范式；双轨逻辑（Qian 与 Winfree 2011）。读法（AI 的）：'
              '观察一个水平，就是依存于它及其量之所去；总量固定的闭合一对中，守恒供给第二条轨。'},
    'canonical_source': src(LC),
    'aliases': ['what dependence alone carries of a level', 'observation from dependence', 'the complement',
                '单凭依存承载一个水平的什么', 'Becoming.carried_iff_rising', 'Becoming.Complement.carry',
                'Becoming.ExchangeLaw.Through.rises_at_step'],
    'dependencies': [
        dep(LEVEL, 'formal-reuse',
            'The laws read through the couplings (ExchangeLaw.Through) with coupling by threshold alone (thresholdOnly), '
            'and reuse Web.alikeThrough_of_levels and ble_eq_of_iff.',
            '诸律经耦合而读（ExchangeLaw.Through），只经阈耦合（thresholdOnly），复用 Web.alikeThrough_of_levels 与 ble_eq_of_iff。',
            'Where a level couples into a formation: by threshold only a crossing passes, by level the level passes.',
            '水平在何处耦合入形成：经阈只有跨越通过，经水平则水平通过。',
            'What dependence alone carries of a level at the step.', '单凭依存在该步承载一个水平的什么。',
            'A law reading through the couplings; the part\'s formations excepted.', '经耦合而读的律；部分的形成除外。',
            src(LC))],
    'related': [
        {'id': ROUTE, 'detail': {'en': 'Kept the conjecture that obs could be derived from dependence; this record '
                                       'settles it at the step of the exchange.',
                                 'zh': '保留了 obs 可由依存推出的猜想；本记录在交换之步解决它。'}},
        {'id': LEVEL, 'detail': {'en': 'Coupling by level is exactly where a level can couple in within its need; this '
                                       'record says which such couplings dependence alone carries.',
                                 'zh': '经水平耦合恰是水平能在所需之内耦合入之处；本记录说明单凭依存承载其中哪些。'}}],
    'references': [{'path': src(LC), 'role': 'proof', 'declarations': sorted(new + USED[LC]), 'sha256': sha(src(LC))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used if mod != LC]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod, _ in refs_used],
    'history': [{
        'en': f'21 October 2026: added (OB1), what dependence alone carries of a level: rising responses exactly, a '
              f'fall only where some level falls, everything with a complement at a fixed total; the conjecture of '
              f'{ROUTE} settled at the step of the exchange; study section {N}.',
        'zh': f'2026年10月21日：新增（OB1），单凭依存承载一个水平的什么：恰是升高的回应，下降只在某水平下降处，有总量固定的补时承载一切；'
              f'{ROUTE} 的猜想在交换之步解决；研究第 {N} 节。'}],
}
path = RECORDS / f'{RID}.json'
assert not path.exists(), 'record exists'
assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, (len(rec['statement']['en']), len(rec['statement']['zh']))
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

# observation-is-a-route: the conjecture leaves the next delta; the reading notes where it is settled.
p = RECORDS / f'{ROUTE}.json'
d = json.loads(p.read_text())
old_en, old_zh = d['next_delta']['en'], d['next_delta']['zh']
d['next_delta']['en'] = old_en.replace('the conjecture that obs could be derived from dependence; ', '')
d['next_delta']['zh'] = old_zh.replace('obs 能由依赖推出这一猜想；', '')
assert d['next_delta']['en'] != old_en and d['next_delta']['zh'] != old_zh
k_en = 'it is kept as a conjecture, not a reading.'
k_zh = '它作为猜想保留，不是读法。'
assert d['correspondence']['en'].count(k_en) == 1 and d['correspondence']['zh'].count(k_zh) == 1
d['correspondence']['en'] = d['correspondence']['en'].replace(k_en, k_en + (
    f' Since OB1 it is settled at the step of the exchange ({RID}).'))
d['correspondence']['zh'] = d['correspondence']['zh'].replace(k_zh, k_zh + (
    f'自 OB1 起，它在交换之步已定（{RID}）。'))
d['related'].append({'id': RID, 'detail': {'en': 'Settles the conjecture this record kept, at the step of the exchange.',
                                           'zh': '在交换之步解决本记录保留的猜想。'}})
d['history'].append({
    'en': f'21 October 2026, OB1: the conjecture that obs could be derived from dependence is settled at the step of the '
          f'exchange (record {RID}, study section {N}); it leaves the next delta, and the reading notes where it is '
          'settled; this record\'s laws are unchanged.',
    'zh': f'2026年10月21日，OB1：obs 可由依赖推出这一猜想在交换之步已定（记录 {RID}，研究第 {N} 节）；它离开下一步，读法注明其解决之处；本记录的定律不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', ROUTE)

# where-a-level-couples: the conjecture it left is settled; its laws are unchanged.
p = RECORDS / f'{LEVEL}.json'
d = json.loads(p.read_text())
k_en = 'whether obs could be derived from dependence stays a conjecture there.'
assert d['correspondence']['en'].count(k_en) == 1
d['correspondence']['en'] = d['correspondence']['en'].replace(k_en, (
    f'whether obs could be derived from dependence stayed a conjecture there, settled at the step of the exchange by {RID}.'))
k_zh = 'obs 能否由依赖推出，在那里仍是猜想'
if d['correspondence']['zh'].count(k_zh) == 1:
    d['correspondence']['zh'] = d['correspondence']['zh'].replace(k_zh, (
        f'obs 能否由依赖推出，在那里曾是猜想，由 {RID} 在交换之步解决'))
else:
    d['correspondence']['zh'] = d['correspondence']['zh'].rstrip() + (
        f' obs 能否由依赖推出，由 {RID}（OB1）在交换之步解决：恰在回应随水平升高或该水平有总量固定的补之处。')
d['related'] = d.get('related', []) + [{'id': RID, 'detail': {
    'en': 'Which couplings by level dependence alone carries, at the step of the exchange.',
    'zh': '在交换之步，单凭依存承载哪些经水平的耦合。'}}]
d['history'].append({
    'en': f'21 October 2026, OB1: new laws in Becoming.LevelCoupling (record {RID}, study section {N}) settle the '
          'conjecture this record left open; this record\'s laws and declarations are unchanged.',
    'zh': f'2026年10月21日，OB1：Becoming.LevelCoupling 中的新定律（记录 {RID}，研究第 {N} 节）解决本记录留下的猜想；本记录的定律与声明不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', LEVEL)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'knowing')
assert RID not in row['records']
row['records'].insert(row['records'].index(ROUTE) + 1, RID)
row['declarations'].insert(row['declarations'].index('Becoming.apart_only_downstream') + 1,
                           'Becoming.carried_iff_rising')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row knowing')
