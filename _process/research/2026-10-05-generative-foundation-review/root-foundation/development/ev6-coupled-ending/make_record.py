#!/usr/bin/env python3
"""Write EV6's record and note it in the records it continues (own-count-misses-joint-excess,
selection-among-groups-by-ending): python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after
apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.Continuation and
Becoming.GroupEnding (a short name must match exactly one declaration by suffix), and the receipt must bind the modules'
current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
EVO = 'theories/becoming/chapters/THE-THEORY-OF-EVOLUTION.md'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. Groups whose conditions are coupled (EV6)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return m


def resolve(names):
    full = [d['name'] for mod in ('Continuation', 'GroupEnding') for d in decls(mod)['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n or f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'groups-whose-conditions-are-coupled'
OWN = 'own-count-misses-joint-excess'
EV5 = 'selection-among-groups-by-ending'
F = 'Flow.'
G = 'GroupEnding.Flow.'
C = 'Coupled.'
laws = [
    ('Read as one, a family of conditions balanced across a step at which its uptake exceeds its replenishment loses at '
     'least one from its stock; n such steps lower it by at least n.',
     '读作一体的条件族，在其取用超过补充且平衡的一步中，存量至少下降一；n 步这样的过度至少使其下降 n。',
     [F + 'family_excess_lowers_at', F + 'family_excess_bounded_at', F + 'family_excess_bounded']),
    ('The coupled gate: where whatever gives to a member depends on some member at a need of at least m, a stock below m '
     'stays below m, and a formation depending on any member at such a need is not active; so n steps of family excess '
     'from a stock below n + m end every such formation from then on.',
     '耦合门控：给予某成员的都以至少 m 的需要依存于某个成员时，低于 m 的存量保持低于 m，以这样的需要依存于任一成员的形成不活跃；故自低于 n + m 的存量起 n 步族过度，此后终结每个这样的形成。',
     [F + 'family_stays_below_at', F + 'family_ends_below_at', F + 'family_excess_ends_at', F + 'family_excess_ends']),
    ('The laws of one condition are the family of that condition alone: a gate on one condition is the coupled gate on '
     'its family of one, and joint excess ends gated renewal through the family law.',
     '单个条件的定律即只含该条件之族的情形：一个条件上的门控就是其单元族上的耦合门控，共同过度经由族定律终结门控更新。',
     [F + 'of_single', F + 'gate_single', F + 'excess_lowers_at', F + 'excess_bounded_at', F + 'stays_below_at',
      F + 'ends_below_at', F + 'joint_excess_ends_at']),
    ('Witness: a taker on a patch renewed by a formation drawing on a neighbour. Read alone, the patch shows no joint '
     'excess while renewed and its renewal is not gated on it; read as one with the neighbour, the renewal is gated, '
     'the uptake exceeds the replenishment at every step, and both formations end.',
     '见证：地块上的取用者，由一个汲取邻居的形成补充该地块。单独读出时，地块在被补充期间无联合超出，其更新也不以它为门控；与邻居读作一体时，更新以族为门控，取用每步都超过补充，两个形成都终结。',
     [C + 'Condition', C + 'Formation', C + 'pair', C + 'present', C + 'flow', C + 'web', C + 'balances', C + 'acting',
      C + 'dependent', C + 'alone_within', C + 'alone_ungated', C + 'gated', C + 'excess', C + 'all_end']),
    ('A member depending on any condition of such a family leaves no descendant after the family\'s excess; groups whose '
     'members depend on one such family end together, each leaving no offspring and nothing selected among them, for '
     'any amount.',
     '依存于这样的族任一条件的成员，在族的过度之后不留后代；成员依存于同一个这样的族的各组一同终结，各不留后代，对任何量组间都无选择。',
     [G + 'family_childless', G + 'excess_childless', G + 'coupled_end_together']),
    ('So ending selects among groups only between families: where the groups with less of an amount depend on a family '
     'that ran into excess, they leave nothing.',
     '故终止只在族与族之间选择组：某量较少的组依存于遭遇过度的族时，它们不留任何后代。',
     [G + 'ended_of_family']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

OWN_DEP = dep(OWN, 'formal-reuse',
              'Generalizes Becoming.Continuation\'s joint count and gated ending (excess_bounded, stays_below, '
              'joint_excess_ends) from one condition to a family read as one; the one-condition laws are now derived '
              'from the family laws.',
              '将 Becoming.Continuation 的联合计入与门控终结（excess_bounded、stays_below、joint_excess_ends）从单个条件推广到读作一体的条件族；单个条件的定律现由族定律推出。',
              'Joint excess and gated renewal for one condition.', '单个条件的共同过度与门控更新。',
              'The same over a family, the coupled gate.', '对条件族的同一定律，耦合门控。',
              'Balance on the family, the coupled gate, family excess.', '族上的平衡、耦合门控、族过度。', src('Continuation'))
EV5_DEP = dep(EV5, 'formal-reuse',
              'Reuses Becoming.GroupEnding\'s base laws of descent (inactive_childless, group_childless, '
              'ended_of_inactive) and SelectionTerm\'s concord_uniform and discord_uniform.',
              '复用 Becoming.GroupEnding 关于世系的流上定律（inactive_childless、group_childless、ended_of_inactive）以及 SelectionTerm 的 concord_uniform、discord_uniform。',
              'Inactive members leave no descendants; groups of them no offspring.', '不活跃的成员不留后代；由其组成的组不留后代。',
              'Groups on one coupled family end together.', '依存于同一耦合族的组一同终结。',
              'Only active formations give; descent.', '只有活跃的形成给予；世系。', src('GroupEnding'))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Groups whose conditions are coupled', 'zh': '条件相互耦合的组'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Joint excess and gated ending hold of a family of conditions read as one; a patch a neighbour renews shows '
              'no excess alone yet ends with the pair. Groups depending on one such family end together, unselected '
              'among; ending selects only between families.',
        'zh': '共同过度与门控终结对读作一体的条件族成立；由邻居补充的地块单独读出时无过度，却与该对一同终结。依存于同一个这样的族的各组一同终结，组间无选择；终止只在族与族之间选择。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Balance on the family across the steps used; the coupled gate (whatever gives to a member depends '
              'on some member at a need of at least m), givers supported, or globally only active formations giving and '
              'activity needing support; n steps of family excess from a stock below n + m; members depending on some '
              'condition of the family at such a need; over generations, descent and the generation\'s members in the '
              'groups listed.',
        'zh': '不加公理。所用各步上族的平衡；耦合门控（给予某成员的都以至少 m 的需要依存于某个成员）、给予者得到支持，或全局地只有活跃的形成给予且活动需要支持；自低于 n + m 的存量起 n 步族过度；成员以这样的需要依存于族的某个条件；世代：世系，且该代成员在所列的组中。'}],
    'does_not_show': [
        {'en': 'That the family law is tight: its start counts the whole stock, so a family whose members are drawn down in '
               'turn ends only after as many steps of excess as its stock holds.',
         'zh': '族定律是紧的：其起点计入整个存量，故成员依次被耗尽的族，只有在过度步数与其存量相当之后才终结。', 'kind': 'scope'},
        {'en': 'Which conditions are coupled into a family, or why the excess comes: hypotheses wherever they enter. '
               'Mixing between groups and how groups and their couplings form are not stated.',
         'zh': '哪些条件耦合为一族，或过度为何到来：凡出现处都是假设。组间混合以及组与其耦合如何形成未陈述。', 'kind': 'scope'},
        {'en': 'That learners in a commons run into family excess: the commons test measured it; here it is supposed.',
         'zh': '公地中的学习者会遭遇族过度：公地检验测得了它；此处是假设。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('Continuation'), 'detail': {
        'en': 'Read on one condition, the gated law can fail to apply where it applies to the family: in Coupled the '
              'patch shows no joint excess at the first two steps and its giver does not depend on it '
              '(Coupled.alone_within, Coupled.alone_ungated), while the pair ends both formations (Coupled.all_end).',
        'zh': '在单个条件上读，门控定律可能在族上适用之处不适用：Coupled 中地块前两步无联合超出，其给予者也不依存于它（Coupled.alone_within、Coupled.alone_ungated），而该对终结两个形成（Coupled.all_end）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.Continuation and Becoming.GroupEnding has an empty axiom report; the checker verifies core '
              f'purity. Built and reviewed in one session, with no separate reviewer; author review in study section {N}; '
              'not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Continuation 与 Becoming.GroupEnding 的每项声明公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Mixing between groups; how groups and their couplings form; a tighter family law where members are drawn '
              'down in turn; an independent review.',
        'zh': '组间混合；组与其耦合如何形成；成员依次被耗尽时更紧的族定律；独立审查。'},
    'correspondence': {
        'en': 'Metapopulation dynamics (Levins 1969; Hanski 1998): patches linked by recolonization persist or go extinct '
              'together, and a patch read alone can look sustained while the network is in deficit; group selection '
              'requires groups that differ in their fate (Wilson and Sober 1994), which coupled groups do not. Readings '
              '(the AI\'s): coupling, not sharing one condition, is what makes groups end together; a commons is a family, '
              'not a single pool.',
        'zh': '集合种群动态（Levins 1969；Hanski 1998）：由再定殖相连的斑块一同存续或一同灭绝，单独读出的斑块可能看似可持续，而网络整体处于亏空；组选择需要命运不同的组（Wilson 与 Sober 1994），耦合的组则不然。读法（AI 的）：使各组一同终结的是耦合，而非共享一个条件；公地是一个族，而非单一池。'},
    'canonical_source': src('Continuation'),
    'aliases': ['groups whose conditions are coupled', '条件相互耦合的组', 'coupled gate', 'family excess',
                'Becoming.Flow.family_excess_ends', 'Becoming.Flow.family_excess_bounded', 'Becoming.Coupled.all_end',
                'Becoming.GroupEnding.Flow.coupled_end_together', 'Becoming.GroupEnding.Flow.ended_of_family'],
    'dependencies': [OWN_DEP, EV5_DEP],
    'related': [
        {'id': OWN, 'detail': {'en': 'Its one-condition laws, now the family of one.', 'zh': '其单个条件的定律，现为单元族的情形。'}},
        {'id': EV5, 'detail': {'en': 'Groups on conditions of their own; here groups on coupled conditions.',
                               'zh': '依存于自身条件的组；此处为依存于耦合条件的组。'}}],
    'references': [{'path': src('Continuation'), 'role': 'proof', 'sha256': sha(src('Continuation'))},
                   {'path': src('GroupEnding'), 'role': 'proof', 'sha256': sha(src('GroupEnding'))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in ('Continuation', 'GroupEnding')],
    'history': [{
        'en': f'20 October 2026: added (EV6), the joint count and gated ending over a family of conditions read as one, '
              f'and groups whose conditions are coupled; study section {N}.',
        'zh': f'2026年10月20日：新增（EV6），读作一体的条件族上的联合计入与门控终结，以及条件相互耦合的组；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

NOTES = {
    OWN: ({'en': 'The same laws over a family of conditions read as one, from which these are now derived.',
           'zh': '对读作一体的条件族的同一定律，现由其推出本记录的定律。'},
          f'20 October 2026, EV6: the joint count and the gated ending are stated over a family of conditions read as one '
          f'(Flow.family_excess_bounded, Flow.family_excess_ends; record {RID}, study section {N}); excess_lowers_at, '
          'excess_bounded_at, stays_below_at, ends_below_at and joint_excess_ends_at are now derived as the family of one '
          'condition, their statements unchanged. The claim is unchanged.',
          f'2026年10月20日，EV6：联合计入与门控终结陈述于读作一体的条件族（Flow.family_excess_bounded、Flow.family_excess_ends；记录 {RID}，研究第 {N} 节）；'
          'excess_lowers_at、excess_bounded_at、stays_below_at、ends_below_at、joint_excess_ends_at 现作为单元族的情形推出，陈述不变。论断不变。'),
    EV5: ({'en': 'Groups whose conditions are coupled end together; excess_childless is now the family of one.',
           'zh': '条件相互耦合的组一同终结；excess_childless 现为单元族的情形。'},
          f'20 October 2026, EV6: groups whose conditions are coupled are stated in Becoming.GroupEnding '
          f'(Flow.family_childless, Flow.coupled_end_together, Flow.ended_of_family; record {RID}, study section {N}); '
          'Flow.excess_childless is now derived from Flow.family_childless, its statement unchanged. The claim is unchanged; '
          'its open item on coupled groups is answered there.',
          f'2026年10月20日，EV6：条件相互耦合的组陈述于 Becoming.GroupEnding（Flow.family_childless、Flow.coupled_end_together、Flow.ended_of_family；记录 {RID}，研究第 {N} 节）；'
          'Flow.excess_childless 现由 Flow.family_childless 推出，陈述不变。论断不变；其关于耦合之组的开放项在那里回答。'),
}
for rid, (related, en, zh) in NOTES.items():
    p = RECORDS / f'{rid}.json'
    d = json.loads(p.read_text())
    d['related'].append({'id': RID, 'detail': related})
    d['history'].append({'en': en, 'zh': zh})
    if rid == EV5:
        item = d['does_not_show'][1]
        assert 'groups whose conditions are coupled are not stated' in item['en'], item
        item['en'] = item['en'].replace('mixing between groups and groups whose conditions are coupled are not stated.',
                                        'mixing between groups is not stated (groups whose conditions are coupled: record '
                                        f'{RID}).')
        item['zh'] = item['zh'].replace('组间混合与条件相互耦合的组未陈述。', f'组间混合未陈述（条件相互耦合的组：记录 {RID}）。')
        assert RID in item['en'] and RID in item['zh'], item
        nd = d['next_delta']
        nd['en'] = nd['en'].replace('Groups whose conditions are coupled (a neighbour reseeding); mixing', 'Mixing')
        nd['zh'] = nd['zh'].replace('条件相互耦合的组（邻居补种）；组间混合', '组间混合')
        assert 'coupled' not in nd['en'] and '耦合' not in nd['zh'], nd
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print('noted', rid)
