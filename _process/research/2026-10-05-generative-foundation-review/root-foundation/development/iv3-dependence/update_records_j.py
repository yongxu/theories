#!/usr/bin/env python3
"""IV3j: extend the record self-concern-through-dependence with need across two tiers and the Routing witness; its
references are re-hashed to the new receipt and it gets one history note.
usage (from the checkout root, after apply_text_j.py): python3 -B update_records_j.py CORE_RECEIPT STUDY_SECTION"""
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
assert f'## {N}. Need across two tiers, the upper dividing its giving among the stores (IV3j)' in (ROOT / STUDY).read_text()
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
DATE = '24 October 2026'


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


def t(en, zh, cap=None):
    if cap:
        assert len(en) <= cap[0] and len(zh) <= cap[1], (len(en), len(zh), en[:60])
    return {'en': en, 'zh': zh}


FL = 'Becoming.Flow.'
TIERS = need([FL + n for n in ['FedThroughStores', 'GivesInto', 'taken_store', 'storesRisen_le_given',
                               'storesRisen_le_capacity', 'replenishment_le_othersThrough', 'routedDrawn',
                               'routedDrawn_fedThroughStores', 'routedDrawn_drawsPast', 'routedDrawn_not_gives',
                               'needs_iff_through_short']]
             + ['Becoming.Web.RoutesAt', 'Becoming.Web.storesRisen', 'Becoming.Web.othersThrough',
                'Becoming.Web.storeNeed']
             + ['Becoming.Routing.' + n for n in ['top_needed', 'lone_router_needed', 'router_not_needed',
                                                  'tops_not_needed', 'rise_needs_top', 'fill_needs_top']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    'significance review\'s dependence check. Author review in study sections 373, 378, 382 to 386, 388 and '
    f'{N}; an independent AI reader checked the line through study section 386, its findings fixed in section 387.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382 至 386、388 与 {N} 节；一个独立的 AI 读者核对了至第 386 节的部分，'
    f'其发现在第 387 节修正。', (600, 260))

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 20 and len(d['hypotheses']) == 8
d['laws'].append({**t(
    'Across two tiers, lower members passing on what they take from their own stores and upper members giving the '
    'stores within supplied capacities, a consumer drawing past the stock needs a formation\'s giving into the hierarchy '
    'exactly where, at some step, the other upper members cannot give what the stores rise or the others cannot give '
    'the demand through the hierarchy. Witness Routing.',
    '跨两层，下层成员传递取自自身库存者、上层成员在所给容量内给予诸库存：消耗者汲取超出存量时，恰在某步其余上层成员给不出诸库存的'
    '上升、或其余者经由层级给不出需求之处，需要某构成向层级的给予。见证 Routing。', (420, 190)),
    'declarations': TIERS})
d['hypotheses'].append(t(
    'For two tiers: the lower members\' stores their own, outside the family and given only by upper members, whose '
    'capacities are supplied with the web; balance on the family and on every store within the stretch, the stores free '
    'to rise; the consumer in neither tier; the family and both tiers listed without repetition and apart.',
    '对两层：下层成员的库存为各自所有、在该族之外、只由上层成员给予，上层的容量随依存网给定；该族与每个库存在区间内平衡，库存可以'
    '上升；消耗者不在任一层；该族与两层都无重复地列出且彼此分开。', (420, 190)))
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'Routing: with every level at zero and one unit drawn a step, the user needs a lone upper member '
    '(Routing.top_needed) and a lone lower member that holds nothing, all the giving passing through it '
    '(Routing.lone_router_needed), but neither of two lower members (Routing.router_not_needed), and neither of two '
    'upper members (Routing.tops_not_needed) until a lower store rises by one, when each is (Routing.rise_needs_top); '
    'with one upper member and a store rising that only it can give, the user needs it though the lower stores\' falls '
    'could feed the user (Routing.fill_needs_top).',
    'Routing：各水平为零、每步汲取一个单位时，使用者需要唯一的上层成员（Routing.top_needed），也需要一无所持、一切给予都须经过的'
    '唯一下层成员（Routing.lone_router_needed），但两个下层成员中哪个都不需要（Routing.router_not_needed）；两个上层成员中哪个都不'
    '需要（Routing.tops_not_needed），直到某个下层库存上升一个单位，此时两者都被需要（Routing.rise_needs_top）；只有一个上层成员、'
    '某库存上升而只有它能给时，使用者需要它，虽然下层库存的下降本可供给使用者（Routing.fill_needs_top）。')})
d['next_delta'] = t(
    'Whether need across a stretch reaches what is active only after it, and the feeding closure read with time; then '
    'more tiers, each tier\'s capacity read off its own supply.',
    '跨一个区间的“所需”是否达到只在其后才活跃者，以及带着时间来读的供养闭包；然后是更多层，每层的容量从其自身供给读出。',
    (400, 180))
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(TIERS))
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
    f'{DATE}: extended (IV3j): need across two tiers, the upper members dividing their giving among the stores and '
    f'giving the stores\' rises; the Routing witness; study section {N}.',
    f'2026年10月24日：扩展（IV3j）：跨两层的“所需”，上层成员把给予分给诸库存并补足其上升；Routing 见证；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
