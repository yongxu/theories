#!/usr/bin/env python3
"""IV3f: extend the record self-concern-through-dependence with what a feeder can give read off its own supply (the
supply bounds, capacities read off stores and the exact law with them) and need up a hierarchy, with the OwnStores and
TwoTiers witnesses; its statement gains the hierarchy, its references are re-hashed to the new receipt and it gets one
history note.
usage (from the checkout root, after apply_text_f.py): python3 -B update_records_f.py CORE_RECEIPT STUDY_SECTION"""
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
assert f'## {N}. What a feeder can give, read off its own supply, and need up a hierarchy (IV3f)' in (ROOT / STUDY).read_text()
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


B, FL, W = 'Becoming.', 'Becoming.Flow.', 'Becoming.Web.'
SUPPLY = need([FL + n for n in ['PassesOn', 'replenishment_le_uptake', 'passed_le_supply', 'passed_le_drop',
                                'passed_zero_of_exhausted']])
STORES = need([W + 'storeFall']
              + [FL + n for n in ['FedFromStores', 'take_le_storeFall', 'fedFromStores_within', 'storeDrawn',
                                  'storeDrawn_balancesOn', 'storeDrawn_given_store', 'storeDrawn_taken_store',
                                  'storeDrawn_balances_store', 'storeDrawn_fedFromStores', 'storeDrawn_drawsPast',
                                  'storeDrawn_not_gives', 'needs_giver_iff_store_short']]
              + [B + 'OwnStores.' + n for n in ['level', 'web', 'store', 'decActive', 'distinct', 'apart',
                                                'user_outside', 'own', 'separate', 'first_steady', 'second_steady',
                                                'steady', 'second_store_spent', 'second_spent', 'needs_first',
                                                'not_needs_second']])
TIERS = need([B + 'topTier', W + 'stockTiers']
             + [FL + n for n in ['BalancesTiers', 'PassesTiers', 'uptake_le_tiers', 'FedThroughTiers', 'DrawsPastTiers',
                                 'needsSome_tiers']]
             + [B + 'TwoTiers.' + n for n in ['Part', 'Place', 'web', 'chain', 'drawn_not_supply', 'possible',
                                              'needs_source']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study sections 373, 378, 382, 383, 384 and {N}; not '
    'independently reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382、383、384 与 {N} 节；未经独立审查。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 14
assert d['statement']['en'].endswith('exactly where the others could not together give what is drawn.')
d['statement'] = t(
    'Held de se, self-concern is the same from every standpoint exactly where the centers lie within one another\'s '
    'closures; drawn along need, it reaches a copy of what it needs exactly where the others could not together give '
    'what is drawn, and what feeds the top of any hierarchy it draws past.',
    '从己地持有，自我关切恰在诸中心彼此位于对方闭包之内处对每个立场都相同；沿“所需”来画，它恰在其余者合起来给不出所汲取者之处达到其所需'
    '的该副本，并达到它汲取超出其所持有的任何层级之顶层的供给者。')
d['laws'] += [
    {**t('What the formations taking part give a family, each passing on at most what it takes from a supply, is at '
         'most what is taken from the supply; the supply after the step, with what it passed on, holds at most what it '
         'held and was given, so a supply that nothing feeds passes on at most what it loses, and an exhausted one '
         'nothing.',
         '参与的构成给予某族者，若各自所给不超过它从某供给处所取，则至多是从供给处所取之量；该步之后供给处连同所传出者，至多是它原有的与所得的，'
         '所以无所供给的供给处至多传出它失去的，耗尽者什么也传不出。'),
     'declarations': SUPPLY},
    {**t('Where each feeder gives the family at most what it takes from its own store, which nothing feeds, its '
         'capacity at a step is the store\'s fall, read off the web; with the stores its own, outside the family and '
         'not rising in the stretch, a consumer needs a feeder\'s giving exactly where the other active feeders\' '
         'stores together fall short of the demand. Witness OwnStores: a store running out leaves its feeder no copy.',
         '每个供给者给该族的不超过它从自己的、无所供给的库存所取时，它某步的容量就是库存的下降量，从依存网读出；库存各属其主、在该族之外且在'
         '这段步内不上升时，消耗者恰在其余活跃供给者的库存下降量合计少于需求之处需要某供给者的给予。见证 OwnStores：库存耗尽的供给者不再是副本。'),
     'declarations': STORES},
    {**t('Over a hierarchy of families, each given only what is passed on from the one above, what is drawn from the '
         'bottom across a stretch is at most what the whole hierarchy held and what was given to its top; so drawing '
         'past what the whole hierarchy holds needs giving into its top. Witness TwoTiers: a user needs the giving of '
         'its feeder\'s source.',
         '在一个层级的诸族之上，若每族只得到从其上一族传来者，那么一段步内从底层取走的，至多是整个层级原有的与其顶层所得的；所以汲取超出整个'
         '层级所持有者需要向其顶层的给予。见证 TwoTiers：使用者需要其供给者之来源的给予。'),
     'declarations': TIERS},
]
old = [i for i, item in enumerate(d['does_not_show']) if item['en'].startswith('Which web an actual family has')]
assert len(old) == 1, old
d['does_not_show'][old[0]] = {**t(
    'Which web an actual family has, which stores feed which formations, and which families form a hierarchy: the '
    'laws read capacities and bounds off a given web, and the arrangement of stores and tiers is supplied.',
    '实际的条件族有怎样的依存网、哪些库存供给哪些构成、哪些族构成层级：这些规律从给定的依存网读出容量与界限，库存与层级的安排是给定的。'),
    'kind': 'scope'}
d['hypotheses'].append(t(
    'For stores: each member\'s store its own and outside the family, nothing feeding the stores, the stores not '
    'rising within the stretch. For a hierarchy: its families in order, each given only what is passed on from the '
    'one above.',
    '就库存：每个成员的库存属其自身且在该族之外，无物供给库存，库存在这段步内不上升。就层级：其诸族有序，每族只得到从其上一族传来者。'))
d['counterexamples'] += [
    {'path': SOURCE, 'detail': t(
        'OwnStores: two feeders on their own stores, the first holding three and falling by one a step, the second '
        'holding one; the user draws one a step. Once its store is empty the second gives nothing '
        '(OwnStores.second_spent), so the user needs the first feeder and not the second (OwnStores.needs_first, '
        'OwnStores.not_needs_second).',
        'OwnStores：两个各依自己库存的供给者，第一个持有三、每步降一，第二个持有一；使用者每步汲取一。库存耗尽后第二个什么也给不出'
        '（OwnStores.second_spent），所以使用者需要第一个而不需要第二个（OwnStores.needs_first、OwnStores.not_needs_second）。')},
    {'path': SOURCE, 'detail': t(
        'TwoTiers: a user draws on a condition a feeder gives to, passing on what it takes from its supply, which a '
        'source gives to; both stand empty. The chain is possible (TwoTiers.possible), and the user needs the source\'s '
        'giving to the supply (TwoTiers.needs_source).',
        'TwoTiers：使用者汲取某条件，一个供给者给予它并传出从自身供给处所取者，一个来源给予该供给处；两者都空着。这一链条是可能的'
        '（TwoTiers.possible），使用者需要来源对供给处的给予（TwoTiers.needs_source）。')},
]
d['next_delta'] = t(
    'Capacities across a hierarchy whose upper tier divides its giving among several stores; graded need, under which '
    'a feeder is needed in degree; an independent review.',
    '上层把给予分给多个库存的层级中的容量；分级的“所需”，使供给者按程度被需要；独立审查。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(SUPPLY + STORES + TIERS))
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
    f'{DATE}: extended (IV3f): what a feeder can give, read off its own supply (the supply bounds, capacities read off '
    f'the feeders\' own stores and the exact law with them); need up a hierarchy; the OwnStores and TwoTiers witnesses; '
    f'the statement gained the hierarchy; study section {N}.',
    f'2026年10月23日：扩展（IV3f）：从供给者自身的供给读出它能给多少（供给之界、从各自库存读出的容量及其下的精确之律）；“所需”沿层级上溯；'
    f'OwnStores 与 TwoTiers 见证；陈述增加了层级；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
