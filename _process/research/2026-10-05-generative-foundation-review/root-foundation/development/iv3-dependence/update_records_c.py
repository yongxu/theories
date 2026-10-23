#!/usr/bin/env python3
"""IV3c: extend the record self-concern-through-dependence with the flows read off a web, which feeders can feed a
family alone (PartAlone derived), the exact law of need, and the FeedersInTurn witness; its references are re-hashed to the
new receipt and it gets one history note.
usage (from the checkout root, after apply_text_c.py): python3 -B update_records_c.py CORE_RECEIPT STUDY_SECTION"""
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
assert f'## {N}. Which feeders can feed a family alone, read off a web (IV3c)' in (ROOT / STUDY).read_text()
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


B, FL = 'Becoming.', 'Becoming.Flow.'
READ = need([FL + 'FedOnlyOn', FL + 'needsSome_on', B + 'Web.CallsForGiving', B + 'Web.decCallsForGiving',
             B + 'total_two', B + 'mem_steps_of_between', FL + 'given_pos_of_calls'])
ALONE = need([FL + n for n in ['drawnAcross', 'drawnAcross_gives', 'drawnAcross_balancesOn', 'drawnAcross_acting',
                               'drawnAcross_fedOnlyOn', 'drawnAcross_drawsPast', 'partAlone_on',
                               'needs_giver_iff_only_on']]
             + [B + 'Feeders.decEqPart', B + 'Feeders.user_outside', B + 'Feeders.two_feeders_on'])
EXACT = need([FL + n for n in ['firstActiveOther', 'firstActiveOther_mem', 'firstActiveOther_active',
                               'needs_giver_iff_alone']]
             + [B + 'FeedersInTurn.' + n for n in ['activeAt', 'web', 'decActive', 'calls', 'needs_both']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study sections 373, 378 and {N}; not independently '
    'reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378 与 {N} 节；未经独立审查。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 6
d['laws'] += [
    {**t('With the web fixed, the possible flows balance on the family within the stretch, only active formations '
         'give and only a class gives to the family; over them a formation drawing past the stock needs some member\'s '
         'giving. A step calls for giving where some condition rises or none falls, and there a drawing consumer '
         'forces giving.',
         '固定依存网，可能的流在一段步之内对该族平衡、只有活跃构成给予、只有某一类给予该族；在其上，汲取超出存量的构成需要某成员的给予。'
         '某条件上升或没有条件下降的步需要给予，在那里汲取的消耗者迫使给予。'),
     'declarations': READ},
    {**t('Read off the web, every member active at every step calling for giving can feed the family alone, by the '
         'flow drawn across the stretch with that member giving; so the copies law holds over the web with nothing '
         'supplied. On Feeders\' web, where every formation is active, neither copy is needed.',
         '从依存网读出，在每个需要给予的步上都活跃的成员都能单独供给该族，由以该成员给予画过这段步的流可见；所以副本之律在依存网上'
         '成立，无需另设。在 Feeders 的依存网上每个构成都活跃，两个副本都不被需要。'),
     'declarations': ALONE},
    {**t('With activity and identity decided and the class listed, a consumer drawing past the stock needs a member\'s '
         'giving exactly where, at some step calling for giving, that member is the only one active. Witness FeedersInTurn: two '
         'copies active in turn, both needed.',
         '活动与同一可判定、类为有限列表时，汲取超出存量的消耗者恰在某个需要给予的步上某成员是唯一活跃者时需要它的给予。见证 FeedersInTurn：'
         '两个轮流活跃的副本，两者都被需要。'),
     'declarations': EXACT},
]
old = [i for i, item in enumerate(d['does_not_show'])
       if item['en'].startswith('Which flows are possible, or that a given feeder can feed a family alone')]
assert len(old) == 1, old
d['does_not_show'][old[0]] = {**t(
    'Which web an actual family has, or a capacity of giving: the laws read levels and activity off a given web, '
    'and a web that limited what a feeder can give would read fewer flows.',
    '实际的条件族有怎样的依存网，或给予的容量：这些规律从给定的依存网读出水平与活动；限制供给者能给多少的依存网会读出较少的流。'),
    'kind': 'scope'}
d['hypotheses'].append(t(
    'For the flows read off a web: the web fixed, balance on the family within the stretch, only active formations '
    'giving, taking unrestricted; for the exact law, activity and identity of formations decided and the class a '
    'finite list.',
    '就从依存网读出的流：依存网固定，在一段步之内对该族平衡，只有活跃构成给予，取用不受限制；就精确之律：构成的活动与同一可判定，'
    '类为有限列表。'))
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'FeedersInTurn: one condition standing still, the first copy active at step 0 and the second at step 1; both steps call '
    'for giving, so the user, drawing past the stock across both, needs each copy\'s giving (FeedersInTurn.needs_both).',
    'FeedersInTurn：一个静止的条件，第一个副本在第 0 步活跃，第二个在第 1 步；两步都需要给予，所以在两步上汲取超出存量的使用者需要每个副本'
    '的给予（FeedersInTurn.needs_both）。')})
d['next_delta'] = t(
    'A capacity of giving read off the web, so that which feeders can feed alone depends on how much each can give; '
    'graded need, under which a feeder is needed in degree; an independent review.',
    '从依存网读出给予的容量，使哪些供给者能单独供给取决于各自能给多少；分级的“所需”，使供给者按程度被需要；独立审查。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(READ + ALONE + EXACT))
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
    f'{DATE}: extended (IV3c): the possible flows read off a fixed web; which feeders can feed a family alone derived '
    f'from activity at the steps calling for giving, so the copies law holds over the web; the exact law of need; the '
    f'FeedersInTurn witness; study section {N}.',
    f'2026年10月23日：扩展（IV3c）：从固定的依存网读出可能的流；哪些供给者能单独供给某族由其在需要给予之步上的活动导出，所以副本之律在依存网'
    f'上成立；“所需”的精确之律；FeedersInTurn 见证；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
