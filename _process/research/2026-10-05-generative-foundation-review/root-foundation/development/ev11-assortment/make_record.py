#!/usr/bin/env python3
"""Write EV11's record, note it in the record it continues (selection-within-and-among-groups-of-any-sizes), and give
the coverage file's evolution row its record:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations of Becoming.SelectionLevels and
Becoming.GroupEnding (a short name must match exactly one declaration, an exact name first), and the receipt must bind the module's current bytes."""
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
HEAD = f'## {N}. Groups formed by descent (EV11)'
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
    full = [d['name'] for mod in ('SelectionLevels', 'GroupEnding') for d in decls(mod)['declarations']]
    out = []
    for n in names:
        hits = ([f for f in full if f in ('Becoming.SelectionLevels.' + n, 'Becoming.GroupEnding.' + n)]
                or [f for f in full if f.endswith('.' + n)])
        assert len(hits) == 1, (n, hits)
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


RID = 'groups-formed-by-descent'
ANY = 'selection-within-and-among-groups-of-any-sizes'
END = 'selection-among-groups-by-ending'
STG = 'selection-term-over-generations'
USED = {'SelectionTerm': ['Becoming.SelectionTerm.Exact', 'Becoming.SelectionTerm.Generations.family',
                          'Becoming.SelectionTerm.Generations.raises_exact_iff',
                          'Becoming.SelectionTerm.Generations.not_lower_step',
                          'Becoming.SelectionTerm.Generations.not_lower', 'Becoming.SelectionTerm.lowered_exact',
                          'Becoming.SelectionTerm.discord_zero_of_below', 'Becoming.SelectionTerm.concord_alike',
                          'Becoming.SelectionTerm.discord_alike']}
laws = [
    ('A group\'s lineage over listed generations: the group at the first generation and the offspring of its lineage '
     'at each later one; the lineages of a generation listed as groups list every later generation.',
     '组在列出世代中的世系：第一代时即该组，此后每代为其上一代世系的后代；一代列为若干组时，其世系列出此后每一代。',
     ['lineage', 'lineages', 'whole_map', 'flatMap_flatMap', 'lineages_family', 'lineages_whole', 'lineage_within']),
    ('With exact transmission every member of a lineage carries the value its group was founded at, so its mean stays '
     'there while it has members, and lineages of groups uniform in an amount stay uniform in it.',
     '传递精确时，世系的每个成员都带有其组建立时的值，故世系有成员时其均值保持不变，在某量上均匀之组的世系保持均匀。',
     ['lineage_keeps', 'lineage_value', 'lineage_total', 'lineages_uniform']),
    ('Nothing is then selected within the lineages, for any weight, and the mean rises across any step exactly where the '
     'lineages\' means select for the amount: selection among them is all there is.',
     '此时世系内对任何权重都无选择，均值恰在各世系均值选择该量时上升：世系之间的选择即全部。',
     ['within_by_none_of_uniform', 'rises_iff_means_of_uniform', 'lineages_within_none', 'rises_iff_lineages']),
    ('On the base, where at each step the lineages founded lower are not active, nothing is discordant, the mean never '
     'falls below where it started over any number of steps, and it rises where a higher lineage leaves offspring '
     'beside a lower one.',
     '在基上，若每一步建立值较低的世系皆不活跃，则无不一致，任意步数后均值不低于起点，较高世系在较低世系旁留下后代时均值上升。',
     ['Flow.lineages_none_against', 'Flow.lineages_not_lower', 'Flow.lineages_raises']),
    ('Witness: a group holding back and one not, whose members leave nothing; the mean rises from a half to one and '
     'stays there, where the mixed groups of Exhausted fell below their start.',
     '见证：一个保留之组与一个不保留、成员不留后代之组；均值由一半升到一并保持，而 Exhausted 的混合组降到起点以下。',
     ['Assorted.first_listed', 'Assorted.uniform', 'Assorted.kept']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))

rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Groups formed by descent', 'zh': '由世系形成的组'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'With exact transmission, groups formed by descent from groups uniform in an amount keep their values: '
              'nothing is selected within them and selection is among the lineages alone; where the lower lineages end, '
              'the mean never falls below where it started.',
        'zh': '传递精确时，由在某量上均匀之组的世系形成的组保持其值：组内无选择，选择只在世系之间；较低世系终止时，均值从不低于起点。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(names)} for en, zh, names in laws],
    'hypotheses': [{
        'en': 'No axiom. Exact transmission at every step for the lineage laws; on the base, only active formations '
              'giving, descent, and as a hypothesis at each step that the members of the lineages founded lower are not '
              'active (supplied by the ending laws where their conditions ran into joint excess).',
        'zh': '不加公理。世系定律需每一步传递精确；在基上，需只有活跃的形成给予、世系，以及作为每一步的假设，建立值较低之世系的成员不活跃（其条件遭遇共同过度时由终止定律给出）。'}],
    'does_not_show': [
        {'en': 'Groups founded mixed (assortment below one, relatedness within groups below one), migration between '
               'lineages and inexact transmission are not stated; so the share of selection among groups as a function '
               'of assortment (Hamilton 1975) is not stated.',
         'zh': '混合建立的组（聚合低于一、组内亲缘低于一）、世系间迁移与不精确的传递未陈述；故组间选择份额作为聚合程度之函数（Hamilton 1975）未陈述。', 'kind': 'scope'},
        {'en': 'Why the lower lineages end: their members not being active is a hypothesis wherever it enters.',
         'zh': '较低世系为何终止：其成员不活跃在出现处都是假设。', 'kind': 'scope'},
        {'en': 'That keeping what ending selected is better: the mean is read in the counts; ranking goes through the '
               'comparison C.',
         'zh': '保住终止所选出的更好：均值在计数中读出；排序经由比较 C。', 'kind': 'non-implication'}],
    'counterexamples': [{'path': src('GroupEnding'), 'detail': {
        'en': 'Groups formed across lineages need not keep their differences: in Exhausted the next groups are alike in '
              'holding back and the mean falls below where it started (Exhausted.next_step), while with the groups formed '
              'by descent it stays (Assorted.kept).',
        'zh': '跨世系形成的组不必保持差异：Exhausted 中下一代的组在保留上相同，均值降到起点以下（Exhausted.next_step），而组由世系形成时均值保持（Assorted.kept）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.SelectionLevels and Becoming.GroupEnding has an empty axiom report; the checker verifies core '
              f'purity. Built and reviewed in one session, with no separate reviewer; author review in study section {N}; '
              'not independently reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.SelectionLevels 与 Becoming.GroupEnding 的每项声明公理报告为空；'
              f'检查器并核对核心纯净。在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Groups founded mixed (assortment below one); migration between lineages; inexact transmission; an '
              'independent review.',
        'zh': '混合建立的组（聚合低于一）；世系间迁移；不精确的传递；独立审查。'},
    'correspondence': {
        'en': 'Hamilton 1975 read the Price equation\'s among-group share through assortment (relatedness within '
              'groups): with groups formed by descent from uniform founders (clonal groups, the haystack limit) the '
              'within-group part vanishes and selection is among groups alone. Readings (the AI\'s): whether selection '
              'among groups accumulates or falls back is fixed by how the next groups are formed.',
        'zh': 'Hamilton 1975 经由同类聚合（组内亲缘）读 Price 方程的组间份额：组由均匀创建者的世系形成时（克隆组、干草堆极限），组内部分消失，选择只在组间。读法（AI 的）：组间选择是积累还是回落，由下一代的组如何形成决定。'},
    'canonical_source': src('SelectionLevels'),
    'aliases': ['groups formed by descent', 'lineages', 'assortment', 'complete assortment', '由世系形成的组', '同类聚合',
                'Becoming.SelectionLevels.rises_iff_lineages', 'Becoming.GroupEnding.Flow.lineages_not_lower'],
    'dependencies': [
        dep(ANY, 'formal-reuse',
            'The lineage law is the sized division of Becoming.SelectionLevels with the groups\' own terms vanishing '
            '(rises_iff_sized); the witness answers Exhausted.',
            '世系定律即 Becoming.SelectionLevels 的按大小划分、各组自身之项为零（rises_iff_sized）；见证回应 Exhausted。',
            'Selection within groups and among them for groups of any sizes.', '大小任意之组的组内与组间选择。',
            'Selection among lineages alone.', '只在世系之间的选择。',
            'A common multiple of the lineages\' sizes; exact transmission.', '各世系大小的公倍数；传递精确。',
            src('SelectionLevels')),
        dep(END, 'formal-reuse',
            'The base laws read the ending laws\' offspring_zero by lineage: a member not active has offspring number '
            'nothing.',
            '基上的定律按世系读终止定律的 offspring_zero：不活跃的成员后代数为零。',
            'Groups whose members are not active leave nothing.', '成员不活跃的组不留后代。',
            'The mean never falling back where the lower lineages end.', '较低世系终止时均值从不回落。',
            'Only active formations giving; descent.', '只有活跃的形成给予；世系。', src('GroupEnding'))],
    'related': [
        {'id': ANY, 'detail': {'en': 'Groups formed across lineages, where ending used up the differences it acted on.',
                               'zh': '跨世系形成的组，终止在那里耗尽了它所作用的差异。'}},
        {'id': END, 'detail': {'en': 'Ending among groups, read here by lineage.', 'zh': '组间终止，此处按世系读。'}},
        {'id': STG, 'detail': {'en': 'The mean\'s course over generations, chained here over lineages.',
                               'zh': '均值在世代中的进程，此处沿世系连接。'}}],
    'references': [{'path': src(mod), 'role': 'proof',
                    'declarations': sorted(d['name'] for d in decls(mod)['declarations']),
                    'sha256': sha(src(mod))} for mod in ('SelectionLevels', 'GroupEnding')
                  ] + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                       for mod, names in USED.items()] + [
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)},
                   {'path': EVO, 'role': 'statement', 'sha256': sha(EVO)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in ['SelectionLevels', 'GroupEnding'] + list(USED)],
    'history': [{
        'en': f'21 October 2026: added (EV11), groups formed by descent: lineages keep the values their groups were '
              f'founded at, selection among them alone, and on the base the mean never falling back where the lower '
              f'lineages end; study section {N}.',
        'zh': f'2026年10月21日：新增（EV11），由世系形成的组：世系保持其组建立时的值，选择只在世系之间，在基上较低世系终止时均值从不回落；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
for mod, names in USED.items():
    have = {d['name'] for d in decls(mod)['declarations']}
    assert set(names) <= have, (mod, set(names) - have)
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('written', RID)

p = RECORDS / f'{ANY}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'Groups formed by descent from uniform groups, which keep the '
                                                 'differences this record\'s witness saw used up.',
                                           'zh': '由均匀之组的世系形成的组，保持了本记录见证中被耗尽的差异。'}})
item = d['does_not_show'][1]
assert item['en'].startswith('Mixing beyond the listing of the next generation'), item
item['en'] = ('Mixing beyond the listing of the next generation: transmission that is not exact across groups, and how '
              f'groups form and keep their differences short of descent from uniform groups (record {RID} states that '
              'case), are not stated.')
item['zh'] = f'下一代列法之外的混合：跨组不精确的传递，以及组在均匀之组的世系之外如何形成并保持其差异（记录 {RID} 陈述了该情形），未陈述。'
nd = d['next_delta']
assert nd['en'].startswith('How groups form and keep their differences (assortment); '), nd
nd['en'] = nd['en'].replace('How groups form and keep their differences (assortment); ',
                            'Groups founded mixed (assortment below one); ')
nd['zh'] = nd['zh'].replace('组如何形成并保持其差异（同类聚合）；', '混合建立的组（聚合低于一）；')
d['history'].append({
    'en': f'21 October 2026, EV11: groups formed by descent from uniform groups keep their differences (record {RID}, '
          f'study section {N}); this record\'s does-not-show item on assortment and next delta updated; its laws and '
          'their statements are unchanged.',
    'zh': f'2026年10月21日，EV11：由均匀之组的世系形成的组保持其差异（记录 {RID}，研究第 {N} 节）；本记录关于同类聚合的“未表明”项与下一步已更新；定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', ANY)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'evolution')
assert RID not in row['records']
row['records'].insert(row['records'].index(ANY) + 1, RID)
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row evolution')
