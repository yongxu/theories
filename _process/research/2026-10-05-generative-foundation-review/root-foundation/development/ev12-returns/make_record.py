#!/usr/bin/env python3
"""Write EV12's record, note it in the record it continues (groups-formed-by-descent), and give the coverage file's
evolution row its record:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.SelectionLevels (a short
name must match exactly one declaration, an exact name first), and the receipt must bind the module's current bytes."""
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
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f'## {N}. Groups founded mixed, and the rule of returns to groupmates (EV12)'
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
    full = [d['name'] for d in decls('SelectionLevels')['declarations']]
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.SelectionLevels.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'selection-with-returns-to-groupmates'
DESC = 'groups-formed-by-descent'
LEVELS = 'selection-within-and-among-groups'
ADD = 'additive-part-of-offspring-variance'
STG = 'selection-term-over-generations'
USED = {'SelectionTerm': ['Becoming.SelectionTerm.covariation', 'Becoming.SelectionTerm.lt_iff_of_balance',
                          'Becoming.SelectionTerm.concord_uniform', 'Becoming.SelectionTerm.discord_uniform',
                          'Becoming.SelectionTerm.Exact', 'Becoming.SelectionTerm.Generations.raises_exact_iff'],
        'Reproduction': ['Becoming.Reproduction.variation', 'Becoming.Reproduction.discord_self']}
laws = [
    ('Returns to a reading: where each member\'s weight with k per unit of its own amount is a base with b per unit of '
     'a reading, the weight\'s concordance with the amount, with k times its spread and b times the reading\'s '
     'discordance with it, is the weight\'s discordance with b times the reading\'s concordance: the whole selects for '
     'the amount where b times their covariation exceeds k times the spread.',
     '对某读数的回报：成员的权重加每单位自身之量 k，等于基数加该读数每单位 b 时，权重与该量的一致加 k 乘该量的离散、加 b 乘读数与它的不一致，'
     '等于权重的不一致加 b 乘读数的一致；故整体恰在 b 乘读数与该量的协变超过 k 乘其离散时选择该量。',
     ['balance_add', 'balance_mul', 'returns_total', 'returns_weighted', 'returns_balance', 'rises_iff_reading']),
    ('Within groups where each unit a member keeps gives b to every member of its group, own included, and takes c from '
     'the keeper, the offspring number goes against the amount by b + c times the groups\' own spreads, so selection '
     'within goes against keeping wherever a group varies in it; the whole\'s spread is k times the groups\' own spreads '
     'with the spread among them.',
     '成员每保留一单位给其组每个成员（含自身）b、从保留者取走 c 时，组内后代数以 b + c 乘各组自身离散不利于该量，故凡组内有差异处组内选择不利于保留；'
     '整体离散为 k 乘各组自身离散加组间离散。',
     ['spread_levels', 'within_returns', 'within_against']),
    ('Among the groups, read by their totals, selection goes for keeping exactly where b + c falls short of m times b '
     'times the spread among them.',
     '组间按总量读时，选择恰在 b + c 乘组间离散小于 m 乘 b 乘它时有利于保留。',
     ['among_returns', 'among_for_iff']),
    ('The whole selects for keeping exactly where b + c times its spread falls short of m b times the spread among '
     'groups: with the assortment the share of the spread among groups, Hamilton\'s rule. Groups uniform in the amount '
     'select for it exactly where b (m - 1) exceeds c; groups alike in total never do; over generations with exact '
     'transmission the mean rises across a step exactly so.',
     '整体恰在 b + c 乘其离散小于 m b 乘组间离散时选择保留：以组间离散所占份额为同类聚合，即 Hamilton 规则。在该量上均匀之组恰在 b (m - 1) 超过 c 时选择它；'
     '总量相同之组从不选择它；传递精确时，均值跨一步恰如此上升。',
     ['rises_iff_returns', 'rises_iff_returns_of_uniform', 'not_rises_of_alike', 'rises_exact_iff_returns']),
    ('Witnesses: with the same returns, keepers together are selected for and keepers apart against; with two thirds '
     'of the spread among pairs, returns meeting the rule at assortment one still lose.',
     '见证：回报相同，保留者聚在一起时被选择、分开时被淘汰；组间离散占三分之二时，在聚合为一时满足规则的回报仍落败。',
     ['Founding.keeps', 'Founding.assorted', 'Founding.mixed', 'Founding.assorted_returns', 'Founding.mixed_returns',
      'Founding.either_verdict', 'Partly.groups', 'Partly.offspring', 'Partly.returns', 'Partly.below_one']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Selection with returns to groupmates', 'zh': '组员间回报下的选择'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Where each unit kept gives b to every member of the keeper\'s group and takes c from the keeper, the whole '
              'selects for keeping exactly where b + c times the spread falls short of m b times the spread among groups: '
              'Hamilton\'s rule, with the assortment that share.',
        'zh': '每保留一单位给保留者之组每个成员 b、从保留者取走 c 时，整体恰在 b + c 乘离散小于 m b 乘组间离散时选择保留：即以该份额为同类聚合的 Hamilton 规则。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Offspring numbers depend on own and groupmates\' amounts additively, each unit kept giving b to '
              'every member of the keeper\'s group, own included, and taking c from the keeper; groups of equal size; '
              'for the step law, exact transmission.',
        'zh': '不加公理。后代数可加地依赖自身与组员之量：每保留一单位给保留者之组每个成员（含自身）b、从保留者取走 c；各组大小相等；跨一步的定律需传递精确。'}],
    'does_not_show': [
        {'en': 'Returns with synergy (depending on the product of own and groupmates\' amounts) and groups of unequal size '
               'are not stated.',
         'zh': '有协同的回报（依赖自身与组员之量的乘积）与大小不等的组未陈述。', 'kind': 'scope'},
        {'en': 'How the groups are founded, and how the share of the spread among them changes over generations, enter '
               'as given: the rule reads them at the step.',
         'zh': '组如何建立、组间离散所占份额在世代中如何变化，作为给定进入：规则在该步读出它们。', 'kind': 'scope'},
        {'en': 'That keeping is better where it is selected for: the rule reads the counts; ranking goes through the '
               'comparison C.',
         'zh': '被选择之处保留更好：规则读的是计数；排序经由比较 C。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('SelectionLevels'), 'detail': {
        'en': 'Returns that meet the rule at assortment one need not win: with two thirds of the spread among pairs, b = 3 '
              'and c = 2 the whole selects against keeping (Partly.below_one), and with the keepers apart the same '
              'returns that select for keeping with them together select against it (Founding.either_verdict).',
        'zh': '在聚合为一时满足规则的回报不必胜出：组间离散占三分之二、b = 3、c = 2 时整体淘汰保留（Partly.below_one）；保留者分开时，与聚在一起时选择保留的同一回报淘汰它（Founding.either_verdict）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.SelectionLevels has an empty axiom report; the checker verifies core purity. Built and reviewed in '
              f'one session, with no separate reviewer; author review in study section {N}; not independently reviewed by '
              'a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.SelectionLevels 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Returns with synergy; groups of unequal size; how assortment changes over generations; an independent '
              'review.',
        'zh': '有协同的回报；大小不等的组；聚合在世代中如何变化；独立审查。'},
    'correspondence': {
        'en': 'Hamilton (1964) for kin and Hamilton (1975) reading the Price equation\'s among-group share through '
              'relatedness within groups; the equivalence of multilevel and inclusive-fitness accounts for additive '
              'returns (Queller 1992; Okasha 2006). Here in counts, nothing subtracted and no regression coefficient formed. '
              'Readings (the AI\'s): the verdict turns on how the groups whose members give to each other are founded.',
        'zh': 'Hamilton（1964）论亲缘，Hamilton（1975）以组内亲缘读 Price 方程的组间份额；可加回报下多层选择与广义适合度两种说明等价（Queller 1992；Okasha 2006）。'
              '此处以计数陈述，不作减法，不形成回归系数。读法（AI 的）：判定取决于彼此给予的成员所在之组如何建立。'},
    'canonical_source': src('SelectionLevels'),
    'aliases': ['returns to groupmates', 'Hamilton\'s rule', 'assortment below one', 'groups founded mixed', '组员间回报',
                'Hamilton 规则', 'Becoming.SelectionLevels.rises_iff_returns', 'Becoming.SelectionLevels.returns_balance'],
    'dependencies': [
        dep(LEVELS, 'formal-reuse',
            'The whole law is the division of Becoming.SelectionLevels (levels) with the within and among parts read by '
            'the returns.',
            '整体定律即 Becoming.SelectionLevels 的划分（levels），组内与组间两部分按回报读出。',
            'Selection within groups and among them.', '组内与组间选择。',
            'The rule of returns to groupmates.', '组员间回报的规则。',
            'Groups of equal size.', '各组大小相等。', src('SelectionLevels')),
        dep(ADD, 'formal-reuse',
            'The amount\'s spread is Reproduction.variation, with nothing discordant on the amount itself.',
            '该量的离散即 Reproduction.variation，该量对自身无不一致。',
            'The spread of an amount.', '某量的离散。',
            'The balance of returns.', '回报的平衡。',
            'None.', '无。', src('Reproduction')),
        dep(DESC, 'formal-reuse',
            'Groups formed by descent from uniform groups are the assortment-one case: nothing within, and the rule '
            'b (m - 1) > c among.',
            '由均匀之组的世系形成的组是聚合为一的情形：组内无选择，组间规则为 b (m - 1) > c。',
            'Groups uniform in an amount.', '在某量上均匀的组。',
            'The rule at assortment one.', '聚合为一时的规则。',
            'Exact transmission.', '传递精确。', src('SelectionLevels'))],
    'related': [
        {'id': DESC, 'detail': {'en': 'The complete-assortment end, which this record extends to every assortment.',
                                'zh': '完全聚合的一端，本记录将其推广到任意聚合。'}},
        {'id': LEVELS, 'detail': {'en': 'The division whose parts the returns read.', 'zh': '回报所读出其各部分的划分。'}},
        {'id': STG, 'detail': {'en': 'The step law read through raises_exact_iff.', 'zh': '经 raises_exact_iff 读出的跨步定律。'}}],
    'references': [{'path': src('SelectionLevels'), 'role': 'proof',
                    'declarations': sorted(d['name'] for d in decls('SelectionLevels')['declarations']),
                    'sha256': sha(src('SelectionLevels'))}
                   ] + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                        for mod, names in USED.items()] + [
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in ['SelectionLevels'] + list(USED)],
    'history': [{
        'en': f'22 October 2026: added (EV12), selection with returns to groupmates: within against keeping, among for it '
              f'exactly where b + c falls short of m b, the whole by Hamilton\'s rule with the assortment the share of the '
              f'spread among groups; study section {N}.',
        'zh': f'2026年10月22日：新增（EV12），组员间回报下的选择：组内不利于保留，组间恰在 b + c 小于 m b 时有利于它，整体按以组间离散份额为同类聚合的 Hamilton 规则；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
for mod, names in USED.items():
    have = {d['name'] for d in decls(mod)['declarations']}
    assert set(names) <= have, (mod, set(names) - have)
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

p = RECORDS / f'{DESC}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'Every assortment between none and one: Hamilton\'s rule for returns to '
                                                 'groupmates, of which this record is the assortment-one end.',
                                           'zh': '聚合由零到一之间的每一情形：组员间回报的 Hamilton 规则，本记录是其聚合为一的一端。'}})
item = d['does_not_show'][0]
assert item['en'].startswith('Groups founded mixed (assortment below one'), item
item['en'] = ('Migration between lineages and inexact transmission are not stated, nor how assortment changes over '
              f'generations; groups founded mixed, with additive returns to groupmates, are stated in record {RID}.')
item['zh'] = f'世系间迁移与不精确的传递未陈述，聚合在世代中如何变化亦未陈述；混合建立的组在可加的组员间回报下见记录 {RID}。'
nd = d['next_delta']
assert nd['en'].startswith('Groups founded mixed (assortment below one); '), nd
nd['en'] = nd['en'].replace('Groups founded mixed (assortment below one); ', 'How assortment changes over generations; ')
nd['zh'] = nd['zh'].replace('混合建立的组（聚合低于一）；', '聚合在世代中如何变化；')
d['history'].append({
    'en': f'22 October 2026, EV12: groups founded mixed, with returns to groupmates, stated (record {RID}, study section '
          f'{N}); this record\'s does-not-show item on assortment and next delta updated; its laws and their statements '
          'are unchanged.',
    'zh': f'2026年10月22日，EV12：混合建立的组在组员间回报下已陈述（记录 {RID}，研究第 {N} 节）；本记录关于聚合的“未表明”项与下一步已更新；定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', DESC)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(DESC) + 1, RID)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
