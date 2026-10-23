#!/usr/bin/env python3
"""IV3d: extend the record self-concern-through-dependence with capacities of giving: a step's demand and the least
flow, feeding alone exactly with capacities, need by shortfall, and the Capacities witnesses; its statement gains the
capacity clause, its references are re-hashed to the new receipt and it gets one history note.
usage (from the checkout root, after apply_text_d.py): python3 -B update_records_d.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
MODULE = 'Becoming.Weightings'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
assert f'## {N}. Capacities of giving, read with the web (IV3d)' in (ROOT / STUDY).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '23 October 2026'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


found = [m for m in R['modules'] if m['module'] == MODULE]
assert len(found) == 1 and not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert R['source_sha256'][MODULE] == sha(SOURCE)


def need(names):
    for n in names:
        assert n in HAVE, n
    return names


def t(en, zh):
    return {'en': en, 'zh': zh}


B, FL, W, CA = 'Becoming.', 'Becoming.Flow.', 'Becoming.Web.', 'Becoming.Capacities.'
DEMAND = need([B + 'decSomeEq'] + [W + n for n in ['decSomeFalls', 'demand', 'drawnUnit', 'callsForGiving_iff_demand_pos',
                                                   'total_drawnUnit']]
              + [FL + n for n in ['given_of_steady', 'rise_le_given', 'demand_le_replenishment', 'leastDrawn',
                                  'leastDrawn_gives', 'leastDrawn_balancesOn', 'leastDrawn_acting',
                                  'leastDrawn_given_total', 'leastDrawn_drawsPast']])
ALONE = need([W + 'CanFeedAlone'] + [FL + n for n in ['FedOnlyWithin', 'needsSome_within', 'leastDrawn_fedOnlyWithin',
                                                      'feedsAlone_iff', 'partAlone_within_iff',
                                                      'needs_giver_iff_only_within']])
SHORT = need([FL + 'needs_giver_of_short']
             + [CA + n for n in ['web', 'cap', 'decActive', 'excess_succ', 'steady', 'demand_two', 'calls', 'distinct',
                                 'second_alone_first_not', 'needs_second', 'not_needs_first', 'capOne', 'jointly',
                                 'jointly_feeds', 'neither_alone', 'needs_both']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study sections 373, 378, 382 and {N}; not '
    'independently reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382 与 {N} 节；未经独立审查。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 9
old_statement = ('Held de se, self-concern is the same from every standpoint exactly where the centers lie within one '
                 'another\'s closures, as centers sharing one condition do; drawn along need, it reaches a copy of what '
                 'it needs exactly where that copy is the only one.')
assert d['statement']['en'] == old_statement
d['statement'] = t(
    old_statement[:-1] + ', and, with capacities of giving, wherever the others could not together give what is drawn.',
    d['statement']['zh'].rstrip('。') + '，而在有给予容量时，凡其余者合起来给不出所汲取者之处，它都达到该副本。')
d['laws'] += [
    {**t('A step\'s demand is what the family\'s conditions rise, and one more where none falls; it is positive exactly '
         'where the step calls for giving. Every balanced flow in which a consumer takes from the family gives it at '
         'least the demand, and the least flow, with one giver, gives exactly the demand.',
         '某步的需求是该族诸条件的上升量，在无一下降处再加一；它恰在该步需要给予处为正。消耗者从该族取用的每个平衡的流至少给予该族这一需求，'
         '而只有一个给予者的最小流恰好给予这一需求。'),
     'declarations': DEMAND},
    {**t('With capacities supplied with the web, and each formation taking part once a step, a member can feed the '
         'family alone exactly where, at every step calling for giving, it is active and its capacity covers the '
         'demand; where every member can, the copies law holds.',
         '以随依存网给定的容量、每个构成每步只参与一次，某成员恰在每个需要给予之步上活跃且其容量覆盖需求时能单独供给该族；每个成员都能时，'
         '副本之律成立。'),
     'declarations': ALONE},
    {**t('A feeder is needed wherever, at some step of the stretch, the capacities of the other members active there '
         'total less than the demand. Witness Capacities: with one unit and two against a demand of two the user needs '
         'the second copy and not the first; with one unit each, neither can feed alone, both giving feed the '
         'condition, and the user needs both.',
         '凡在这段步中的某步上其余活跃成员的容量合计少于需求之处，供给者都被需要。见证 Capacities：以一个单位与两个单位对两个单位的需求，'
         '使用者需要第二个副本而不需要第一个；各一个单位时，两者都不能单独供给，两者一起给予能供给该条件，使用者两者都需要。'),
     'declarations': SHORT},
]
old = [i for i, item in enumerate(d['does_not_show'])
       if item['en'].startswith('Which web an actual family has, or a capacity of giving')]
assert len(old) == 1, old
d['does_not_show'][old[0]] = {**t(
    'Which web an actual family has, or what each formation can give: the capacities are supplied with the web, not '
    'read off its levels or off what a feeder itself holds or draws on.',
    '实际的条件族有怎样的依存网，或每个构成能给多少：容量随依存网给定，并非从其水平或从供给者自身所持有、所汲取者读出。'),
    'kind': 'scope'}
d['does_not_show'].append({**t(
    'That a feeder is not needed where, at every step calling for giving, the others active there could together '
    'give the demand: the converse of the shortfall law needs a flow sharing the giving among several givers within '
    'their capacities, which is not built.',
    '在每个需要给予之步上其余活跃者合起来能给出需求之处供给者不被需要：缺额之律的逆向需要一个在多个给予者之间按容量分担给予的流，'
    '尚未构造。'),
    'kind': 'scope'})
corr = [i for i, item in enumerate(d['does_not_show']) if item['kind'] == 'correspondence']
assert len(corr) == 1 and d['does_not_show'][corr[0]]['en'].startswith('That actual centers depend on one another')
d['does_not_show'][corr[0]] = {**t(
    'That actual centers depend on one another, or that the alternatives to a condition they all need could not '
    'together give what they draw: both are empirical.',
    '实际的诸中心彼此依存，或它们都需要的某个条件的诸替代者合起来给不出它们所汲取者：二者都是经验问题。'),
    'kind': 'correspondence'}
d['hypotheses'].append(t(
    'For capacities: capacities supplied with the web, per formation and step over the whole family; each formation '
    'taking part once a step; the family listed without repetition and holding a named condition; for the shortfall '
    'law, activity and identity decided and the class listed.',
    '就容量：容量随依存网给定，按构成与步、对整个族；每个构成每步只参与一次；该族列出而无重复且含一个指名的条件；就缺额之律，活动与同一'
    '可判定，类为有限列表。'))
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'Capacities: one condition rising by one at every step, the user and two copies active throughout, so every step '
    'demands two units. With capacities one and two the user needs the second copy\'s giving and not the first\'s '
    '(Capacities.needs_second, Capacities.not_needs_first); with one each, neither can feed alone, both giving feed '
    'the condition, and the user needs both (Capacities.neither_alone, Capacities.jointly_feeds, Capacities.needs_both).',
    'Capacities：一个每步上升一个单位的条件，使用者与两个副本始终活跃，所以每步需要两个单位。容量为一与二时，使用者需要第二个副本的给予而'
    '不需要第一个的（Capacities.needs_second、Capacities.not_needs_first）；各为一时，两者都不能单独供给，两者一起给予能供给该条件，使用者两者'
    '都需要（Capacities.neither_alone、Capacities.jointly_feeds、Capacities.needs_both）。')})
d['next_delta'] = t(
    'The converse of the shortfall law, by a flow sharing the giving among several givers within their capacities, '
    'which would make need with capacities exact; a capacity read off the levels of what a feeder itself holds or '
    'draws on, joining its capacity to its own dependence; graded need; an independent review.',
    '以在多个给予者之间按容量分担给予的流证明缺额之律的逆向，使有容量时的“所需”成为精确之律；从供给者自身所持有、所汲取者的水平读出容量，'
    '使其容量与其自身的依存相连；分级的“所需”；独立审查。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(DEMAND + ALONE + SHORT))
        ref['sha256'] = sha(SOURCE)
    elif ref['role'] == 'receipt':
        ref['path'] = RECEIPT
        ref['sha256'] = sha(RECEIPT)
    else:
        ref['sha256'] = sha(ref['path'])
for binding in d['proof_bindings']:
    if binding['source'] == SOURCE:
        binding['receipt'] = RECEIPT
d['history'].append(t(
    f'{DATE}: extended (IV3d): capacities of giving supplied with the web; a step\'s demand and the least flow; '
    f'feeding alone exactly with capacities, and the copies law with them; need where the others could not together '
    f'give the demand; the Capacities witnesses; the statement gained the capacity clause; study section {N}.',
    f'2026年10月23日：扩展（IV3d）：随依存网给定的给予容量；某步的需求与最小流；有容量时单独供给的精确之律，及其下的副本之律；凡其余者合起来'
    f'给不出需求之处的“所需”；Capacities 见证；陈述增加了容量一句；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
