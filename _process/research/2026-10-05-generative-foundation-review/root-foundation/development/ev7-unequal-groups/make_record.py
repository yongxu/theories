#!/usr/bin/env python3
"""Write EV7's record and note it in the records it continues (selection-within-and-among-groups,
selection-among-groups-by-ending): python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after
apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.SelectionLevels and
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
HEAD = f'## {N}. Groups of any sizes, and regrouping (EV7)'
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)
MODS = ('SelectionLevels', 'GroupEnding')


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
    full = [d['name'] for mod in MODS for d in decls(mod)['declarations']]
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


RID = 'selection-within-and-among-groups-of-any-sizes'
EV4 = 'selection-within-and-among-groups'
EV5 = 'selection-among-groups-by-ending'
EV6 = 'groups-whose-conditions-are-coupled'
S = 'SelectionLevels.'
G = 'GroupEnding.'
laws = [
    ('For groups of any sizes, with n a common multiple of the sizes and each group\'s own term by n over its size, n '
     'squared times the whole\'s term balances n times the whole\'s size times the groups\' own terms with the term of '
     'the groups\' means read member by member: the law of total covariance with size weights.',
     '各组大小任意：取各组大小的公倍数 n，各组自身之项乘以 n 除以其大小，n 的平方乘整体之项，与 n 乘整体大小乘各组自身之项、以及逐成员读出的组均值之项相平衡：以大小加权的总协方差律。',
     [S + 'context', S + 'context_total', S + 'context_length', S + 'mem_of_mem_context', S + 'concordWithinBy',
      S + 'discordWithinBy', S + 'concordMeans', S + 'discordMeans', S + 'shuffle_left', S + 'shuffle_right',
      S + 'meet', S + 'square_split', S + 'levels_sized']),
    ('The division for k groups of equal size is its case with every factor one: the family read as its groups counts '
     'each pair of groups m times m times.',
     'k 个大小相等之组的划分是每个因子为一的情形：读作其组的族把每对组计 m 乘 m 次。',
     [S + 'pairs_context', S + 'within_by_one', S + 'among_by_one', S + 'nil_of_length_zero',
      S + 'whole_nil', S + 'levels']),
    ('So the whole selects for the amount exactly where the means\' concordance with the scaled within-group '
     'concordances exceeds the same for the discordances, and nothing exactly where they balance.',
     '故整体恰在均值之一致度加上缩放后的组内一致度超过相应的不一致度时选择该量，恰在两者平衡时不作选择。',
     [S + 'square_lt_iff', S + 'square_eq_iff', S + 'rises_iff_sized', S + 'none_iff_sized']),
    ('Where the groups\' means are alike, nothing is selected among them; a generation listed as groups alike in mean, '
     'with exact transmission, raises its mean exactly as selection within them goes. How the next generation is '
     'listed does not enter a step, but fixes the next step\'s among-group part.',
     '各组均值相同时组间无选择；传递精确、列为均值相同之组的一代，其均值恰按组内选择变化。下一代如何列出不进入这一步，却决定下一步的组间部分。',
     [S + 'means_none_of_alike', S + 'rises_iff_within_of_alike', S + 'rises_exact_iff_sized',
      S + 'rises_exact_iff_within_of_alike']),
    ('Ending for any sizes: where every group with a lower mean leaves no offspring, nothing is discordant among the '
     'means; on the base, where those groups\' members are not active, the mean rises exactly as the scaled division '
     'with no among-group part against it goes.',
     '各组大小任意时的终止：每个均值较低的组都不留后代时，均值之间无不一致；在流上，这些组的成员不活跃时，均值恰按不含逆向组间部分的缩放划分变化。',
     [G + 'EndedBy', G + 'means_not_against', G + 'rises_iff_ended_sized', G + 'Flow.endedBy_of_inactive',
      G + 'Flow.rises_iff_inactive_sized']),
    ('Witness: groups of one and of three, alike in their totals of holding back (one each) but not in their means: '
     'the reading by totals sees nothing among them, while the whole\'s selection for holding back is all among the '
     'means.',
     '见证：一人之组与三人之组，保留的总量相同（各为一）而均值不同：按总量读看不出组间选择，而整体对保留的选择全在均值之间。',
     [S + 'ByMeans.unequal', S + 'ByMeans.holding', S + 'ByMeans.offspring', S + 'ByMeans.factor', S + 'ByMeans.common',
      S + 'ByMeans.by_means']),
    ('Witness: two keeping groups beside a group leaving nothing; holding back rises by selection among groups, the '
     'offspring of each keeping group form groups alike in it, and at the next step it falls below where it started.',
     '见证：两个保留之组旁有一个不留后代之组；保留经由组间选择上升，各保留之组的后代组成的组在保留上相同，下一步保留降到起点以下。',
     [G + 'Exhausted.firstKids', G + 'Exhausted.laterKids', G + 'Exhausted.kids', G + 'Exhausted.holding',
      G + 'Exhausted.G', G + 'Exhausted.first', G + 'Exhausted.next', G + 'Exhausted.first_listed',
      G + 'Exhausted.next_listed', G + 'Exhausted.first_step', G + 'Exhausted.alike', G + 'Exhausted.next_step']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

EV4_DEP = dep(EV4, 'formal-reuse',
              'Generalizes Becoming.SelectionLevels\' division (levels) from groups of equal size to groups of any '
              'sizes; levels is now derived from levels_sized, its statement unchanged.',
              '将 Becoming.SelectionLevels 的划分（levels）从大小相等的组推广到大小任意的组；levels 现由 levels_sized 推出，陈述不变。',
              'The division for groups of equal size.', '大小相等之组的划分。',
              'The division for groups of any sizes, its among-group part read by means.', '大小任意之组的划分，组间部分以均值读出。',
              'A common multiple of the sizes.', '各组大小的公倍数。', src('SelectionLevels'))
EV5_DEP = dep(EV5, 'formal-reuse',
              'Reuses Becoming.GroupEnding\'s base laws of descent (group_childless, mem_whole) and SelectionTerm\'s '
              'discord_zero_of_below.',
              '复用 Becoming.GroupEnding 关于世系的流上定律（group_childless、mem_whole）以及 SelectionTerm 的 discord_zero_of_below。',
              'Groups whose members are not active leave no offspring.', '成员不活跃的组不留后代。',
              'Ending fixes the among-group part for groups of any sizes.', '终止决定大小任意之组的组间部分。',
              'Only active formations give; descent.', '只有活跃的形成给予；世系。', src('GroupEnding'))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Selection within and among groups of any sizes', 'zh': '大小任意之组的组内与组间选择'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'For groups of any sizes the selection term divides into the groups\' own terms and the term of their '
              'means; groups alike in mean leave selection within alone, so the next generation\'s listing fixes the '
              'next step\'s among-group part, which ending can use up.',
        'zh': '对大小任意的组，选择项分为各组自身之项与其均值之项；各组均值相同时只剩组内选择，故下一代的列法决定下一步的组间部分，而终止可能将其耗尽。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. A common multiple of the groups\' sizes, positive for the verdicts; a family with members where '
              'the groups are alike in mean; over generations, exact transmission and the generation listed as the '
              'groups; for ending, the groups with a lower mean leaving nothing, on the base their members not active, '
              'only active formations giving and descent.',
        'zh': '不加公理。各组大小的公倍数，作判断时为正；各组均值相同时族有成员；世代：传递精确、该代列为这些组；终止：均值较低之组不留后代，在流上其成员不活跃、只有活跃的形成给予、世系。'}],
    'does_not_show': [
        {'en': 'Another weighting of the groups: the among-group part is the covariance of means with each member counted '
               'once (size weights); with each group counted once the decomposition differs and is not stated.',
         'zh': '对组的另一种加权：组间部分是每个成员计一次（以大小加权）的均值协方差；每组计一次时分解不同，未陈述。', 'kind': 'scope'},
        {'en': 'Mixing beyond the listing of the next generation: transmission that is not exact across groups, and how '
               'groups form and keep their differences (assortment), are not stated.',
         'zh': '下一代列法之外的混合：跨组不精确的传递，以及组如何形成并保持其差异（同类聚合），未陈述。', 'kind': 'scope'},
        {'en': 'That ending among groups in general leaves the surviving groups alike: shown in one witness only; '
               'surviving groups can differ in their within-group composition.',
         'zh': '组间终止一般会使幸存之组相同：只在一个见证中显示；幸存之组可能在组内构成上不同。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('SelectionLevels'), 'detail': {
        'en': 'The equal-size reading by totals does not carry to unequal sizes: in ByMeans the groups\' totals of holding '
              'back are alike, so concordAmong and discordAmong are zero, while the means\' concordance carries all the '
              'whole\'s selection for it (ByMeans.by_means).',
        'zh': '按总量读的等大小读法不能推到大小不等的组：ByMeans 中各组保留的总量相同，故 concordAmong 与 discordAmong 为零，而均值之一致度承载整体对保留的全部选择（ByMeans.by_means）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.SelectionLevels and Becoming.GroupEnding has an empty axiom report; the checker verifies core '
              f'purity. Built and reviewed in one session, with no separate reviewer; author review in study section {N}; '
              'not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.SelectionLevels 与 Becoming.GroupEnding 的每项声明公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'How groups form and keep their differences (assortment); transmission that is not exact across groups; '
              'the additive part of Fisher\'s theorem; an independent review.',
        'zh': '组如何形成并保持其差异（同类聚合）；跨组不精确的传递；Fisher 定理的加性部分；独立审查。'},
    'correspondence': {
        'en': 'The multilevel Price equation with unequal group sizes (Price 1972; Hamilton 1975; Okasha 2006, MLS1): '
              'the whole\'s covariance is the size-weighted mean within-group covariance plus the covariance of group '
              'means; contextual analysis reads each member by its group\'s mean (Heisler and Damuth 1987). Selection '
              'among groups needs variance among groups, which group formation must regenerate (the haystack model, '
              'Maynard Smith 1964; trait groups, Wilson 1975). Readings (the AI\'s): what among-group selection acts on '
              'is used up by it unless descent keeps groups apart.',
        'zh': '组大小不等的多层 Price 方程（Price 1972；Hamilton 1975；Okasha 2006，MLS1）：整体协方差是以大小加权的组内协方差均值加上组均值的协方差；情境分析以组均值读每个成员（Heisler 与 Damuth 1987）。组间选择需要组间差异，须由组的形成重新产生（干草堆模型，Maynard Smith 1964；性状组，Wilson 1975）。读法（AI 的）：组间选择所作用的差异会被它耗尽，除非世系使各组保持分开。'},
    'canonical_source': src('SelectionLevels'),
    'aliases': ['selection within and among groups of any sizes', '大小任意之组的组内与组间选择',
                'multilevel Price equation with unequal group sizes', 'contextual reading',
                'Becoming.SelectionLevels.levels_sized', 'Becoming.SelectionLevels.rises_exact_iff_within_of_alike',
                'Becoming.GroupEnding.Flow.rises_iff_inactive_sized', 'Becoming.GroupEnding.Exhausted.next_step'],
    'dependencies': [EV4_DEP, EV5_DEP],
    'related': [
        {'id': EV4, 'detail': {'en': 'Its division, now the case of equal sizes.', 'zh': '其划分，现为大小相等的情形。'}},
        {'id': EV5, 'detail': {'en': 'Ending among groups, here for any sizes and over two generations.',
                               'zh': '组间终止，此处对任意大小并跨两代。'}},
        {'id': EV6, 'detail': {'en': 'Groups on coupled conditions end together; here groups alike in mean are not '
                                     'selected among.',
                               'zh': '依存于耦合条件的组一同终结；此处均值相同的组之间无选择。'}}],
    'references': [{'path': src(mod), 'role': 'proof', 'declarations': sorted(d['name'] for d in decls(mod)['declarations']),
                    'sha256': sha(src(mod))} for mod in MODS] + [
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'} for mod in MODS],
    'history': [{
        'en': f'20 October 2026: added (EV7), selection within and among groups of any sizes, groups alike in mean, and '
              f'ending for any sizes with a two-generation witness; study section {N}.',
        'zh': f'2026年10月20日：新增（EV7），大小任意之组的组内与组间选择、均值相同的组，以及任意大小的终止与跨两代的见证；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

# EV4's record: its division is now the case of equal sizes; the old proof's helpers are gone.
p = RECORDS / f'{EV4}.json'
d = json.loads(p.read_text())
law = next(l for l in d['laws'] if 'Becoming.SelectionLevels.levels' in l['declarations'])
law['declarations'] = resolve([S + 'levels', S + 'levels_sized', S + 'pairs_context', S + 'within_by_one',
                               S + 'among_by_one'])
ref = next(r for r in d['references'] if r['path'] == src('SelectionLevels'))
ref['declarations'] = sorted(x['name'] for x in decls('SelectionLevels')['declarations'])
item = d['does_not_show'][0]
assert item['en'].startswith('Groups of unequal size'), item
item['en'] = (f'Groups of unequal size here: they are stated in record {RID}, of which this division is the case of equal '
              'sizes, the among-group part read there by the groups\' means.')
item['zh'] = f'此处不含大小不等的组：它们陈述于记录 {RID}，本划分是其大小相等的情形，组间部分在那里以各组均值读出。'
nd = d['next_delta']
assert nd['en'].startswith('Groups of unequal size; '), nd
nd['en'] = nd['en'].replace('Groups of unequal size; groups read', 'Groups read')
nd['zh'] = nd['zh'].replace('大小不等的组；', '')
d['related'].append({'id': RID, 'detail': {'en': 'The division for groups of any sizes, of which this is the case of '
                                                 'equal sizes.',
                                           'zh': '大小任意之组的划分，本记录是其大小相等的情形。'}})
d['history'].append({
    'en': f'20 October 2026, EV7: the division is stated for groups of any sizes (SelectionLevels.levels_sized; record {RID}, '
          f'study section {N}), and levels is now derived from it as the case of equal sizes, its statement unchanged; the '
          'old proof\'s helpers lhs_shape and rhs_shape are gone, so the law\'s declarations name the derivation instead. '
          'The claim is unchanged; its open item on groups of unequal size is answered there.',
    'zh': f'2026年10月20日，EV7：划分陈述于大小任意的组（SelectionLevels.levels_sized；记录 {RID}，研究第 {N} 节），levels 现作为大小相等的情形由其推出，陈述不变；'
          '旧证明的辅助引理 lhs_shape 与 rhs_shape 已删，故该定律的声明改列推导所用者。论断不变；其关于大小不等之组的开放项在那里回答。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', EV4)

p = RECORDS / f'{EV5}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'Ending for groups of any sizes, and a witness of ending using up the '
                                                 'differences among groups it acts on.',
                                           'zh': '任意大小之组的终止，以及终止耗尽其所作用的组间差异的见证。'}})
d['history'].append({
    'en': f'20 October 2026, EV7: Becoming.GroupEnding gains ending for groups of any sizes (EndedBy, means_not_against, '
          f'Flow.rises_iff_inactive_sized) and the two-generation witness Exhausted (record {RID}, study section {N}); this '
          'record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月20日，EV7：Becoming.GroupEnding 增加任意大小之组的终止（EndedBy、means_not_against、Flow.rises_iff_inactive_sized）'
          f'与跨两代的见证 Exhausted（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', EV5)
