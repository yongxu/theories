#!/usr/bin/env python3
"""IV3e: extend the record self-concern-through-dependence with the shared flow and the exact law of need with
capacities, and the SharedCopies witness; its statement's capacity clause becomes exact, the converse leaves its
boundaries, its references are re-hashed to the new receipt and it gets one history note.
usage (from the checkout root, after apply_text_e.py): python3 -B update_records_e.py CORE_RECEIPT STUDY_SECTION"""
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
assert f'## {N}. Need with capacities, exact (IV3e)' in (ROOT / STUDY).read_text()
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


B, FL, W, SC = 'Becoming.', 'Becoming.Flow.', 'Becoming.Web.', 'Becoming.SharedCopies.'
SHARED = need([B + n for n in ['repeatOnto', 'unitsOf', 'pairUp', 'total_repeatOnto', 'mem_repeatOnto', 'total_unitsOf',
                               'mem_unitsOf', 'total_pairUp_fst', 'total_pairUp_snd_le', 'mem_pairUp', 'total_eq_at']]
              + [W + n for n in ['demandAt', 'otherCapacity', 'capacityWithout', 'shares', 'total_demandAt',
                                 'otherCapacity_le', 'mem_shares']]
              + [FL + n for n in ['sharedDrawn', 'sharedDrawn_gives', 'sharedDrawn_given_members',
                                  'sharedDrawn_balancesOn', 'sharedDrawn_acting', 'sharedDrawn_given_le',
                                  'sharedDrawn_quiet', 'sharedDrawn_fedOnlyWithin', 'sharedDrawn_drawsPast',
                                  'sharedDrawn_not_gives']])
EXACT = need([FL + 'needs_giver_iff_short']
             + [SC + n for n in ['web', 'cap', 'decActive', 'cap_le_one', 'steady', 'demand_two', 'calls', 'distinct',
                                 'apart', 'user_outside', 'without_two', 'none_alone', 'needs_some', 'none_needed']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study sections 373, 378, 382, 383 and {N}; not '
    'independently reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382、383 与 {N} 节；未经独立审查。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 12
assert d['statement']['en'].endswith('where the copy is the only one or the others could not together give what is drawn.')
d['statement'] = t(
    'Held de se, self-concern is the same from every standpoint exactly where the centers lie within one another\'s '
    'closures, as centers sharing one condition do; drawn along need, it reaches a copy of what it needs exactly where '
    'the others could not together give what is drawn.',
    '从己地持有，自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同，共有一个条件的诸中心即如此；沿“所需”来画，它恰在其余者合起来'
    '给不出所汲取者之处达到其所需的该副本。')
d['laws'] += [
    {**t('Where the other active members can together give each step\'s demand, pairing in order the units each condition '
         'is to be given with the units they can give divides the giving within their capacities: the shared flow '
         'balances on the family, gives each formation at most what it can give apart from the feeder in question, and '
         'has the consumer drawing past the stock with that feeder never giving.',
         '其余活跃成员合起来能给出每步的需求时，按顺序把每个条件应得的单位与它们能给的单位配对，就在容量之内分担了给予：分担之流对该族'
         '平衡，每个构成所给不超过它除所论供给者外能给的，消耗者汲取超出存量而该供给者从不给予。'),
     'declarations': SHARED},
    {**t('With activity and identity decided and the family and the class listed without repetition, a consumer drawing '
         'past the stock needs a feeder\'s giving exactly where, at some step of the stretch, what the other active '
         'members can give together falls short of the demand. Witness SharedCopies: three copies of one unit each '
         'against a demand of two; no copy can feed alone, the class is needed, and no copy.',
         '活动与同一可判定、该族与该类都列出而无重复时，汲取超出存量的消耗者恰在这段步的某步上其余活跃成员合起来能给的少于需求之处需要某供给者的'
         '给予。见证 SharedCopies：三个各一单位的副本对两个单位的需求；没有副本能单独供给，该类被需要，而没有哪个副本被需要。'),
     'declarations': EXACT},
]
old = [i for i, item in enumerate(d['does_not_show']) if item['en'].startswith('Which web an actual family has')]
assert len(old) == 1, old
d['does_not_show'][old[0]] = {**t(
    'Which web an actual family has, or what each formation can give: the capacities are supplied with the web, not '
    'read off its levels or off what a feeder itself holds or draws on.',
    '实际的条件族有怎样的依存网，或每个构成能给多少：容量随依存网给定，并非从其水平或从供给者自身所持有、所汲取者读出。'),
    'kind': 'scope'}
d['hypotheses'].append(t(
    'For the exact law with capacities: the class listed without repetition, so that each member\'s capacity is counted '
    'once; activity and identity decided.',
    '就有容量时的精确之律：类列出而无重复，使每个成员的容量只计一次；活动与同一可判定。'))
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'SharedCopies: one condition rising by one at every step, the user and three copies active throughout, each copy '
    'able to give one unit, so every step demands two. No copy can feed alone (SharedCopies.none_alone), the user needs '
    'some copy\'s giving (SharedCopies.needs_some), and no copy\'s (SharedCopies.none_needed).',
    'SharedCopies：一个每步上升一个单位的条件，使用者与三个副本始终活跃，每个副本能给一个单位，所以每步需要两个。没有副本能单独供给'
    '（SharedCopies.none_alone），使用者需要某个副本的给予（SharedCopies.needs_some），而不需要哪一个的（SharedCopies.none_needed）。')})
d['next_delta'] = t(
    'A capacity read off the levels of what a feeder itself holds or draws on, joining its capacity to its own '
    'dependence; graded need, under which a feeder is needed in degree; an independent review.',
    '从供给者自身所持有、所汲取者的水平读出容量，使其容量与其自身的依存相连；分级的“所需”，使供给者按程度被需要；独立审查。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(SHARED + EXACT))
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
    f'{DATE}: extended (IV3e): the shares and the flow sharing the giving within capacities; need with capacities '
    f'exact (a feeder needed exactly where the others could not together give the demand); the SharedCopies witness; '
    f'the statement\'s capacity clause made exact and the converse removed from the boundaries; study section {N}.',
    f'2026年10月23日：扩展（IV3e）：配对份额与在容量之内分担给予之流；有容量时的“所需”成为精确之律（供给者恰在其余者合起来给不出需求之处'
    f'被需要）；SharedCopies 见证；陈述的容量一句改为精确，逆向从边界中移除；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
