#!/usr/bin/env python3
"""IV3i: extend the record self-concern-through-dependence with need in degree under capacities read off the stores,
and the OwnStores degree witness; its references are re-hashed to the new receipt and it gets one history note.
usage (from the checkout root, after apply_text_i.py): python3 -B update_records_i.py CORE_RECEIPT STUDY_SECTION"""
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
assert f'## {N}. Need in degree with capacities read off the stores (IV3i)' in (ROOT / STUDY).read_text()
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


FL = 'Becoming.Flow.'
STORED = need([FL + n for n in ['gradedStoreDrawn', 'gradedStoreDrawn_gives', 'gradedStoreDrawn_balancesOn',
                                'gradedStoreDrawn_balances_store', 'gradedStoreDrawn_fedFromStores',
                                'gradedStoreDrawn_drawsPast', 'gradedStoreDrawn_givenFrom_le', 'least_giving_from_stores']]
              + ['Becoming.OwnStores.first_in_degree'])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    'significance review\'s dependence check. Author review in study sections 373, 378, 382 to 386 and '
    f'{N}; reviewed against the Lean by a reader that did not write it, a separate AI agent, whose findings are fixed '
    'in study section 387.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382 至 386 与 {N} 节；另由一个非作者的读者（另一个 AI 代理）对照 Lean 审查，'
    f'其发现在研究第 387 节修正。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 19
d['laws'].append({**t(
    'With capacities read off the feeders\' own stores, under the store law\'s premises, every flow from the stores in '
    'which the consumer draws past the stock has a member giving at least the sum of its shortfalls under the stores\' '
    'falls, and where it can give each some such flow has it give exactly that. Witness OwnStores: the first feeder '
    'needed in degree two, the second in degree zero.',
    '以从供给者自身库存读出的容量，在库存之律的前提下，消耗者汲取超出存量的每个库存之流都使某成员至少给出其在库存下降量下的缺额之和；它能给出'
    '每个缺额时，某个这样的流使它恰好给出这么多。见证 OwnStores：第一个供给者被需要的程度为二，第二个为零。'),
    'declarations': STORED})
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'OwnStores in degree: every flow from the stores in which the user draws past the stock has the first feeder give at '
    'least two units, the units the second\'s empty store cannot give at steps 1 and 2, some has it give exactly two, '
    'and the second\'s degree is zero (OwnStores.first_in_degree).',
    'OwnStores 的程度：使用者汲取超出存量的每个库存之流都使第一个供给者至少给两个单位，即第二个的空库存在第 1、2 步给不出的单位，某个流使它恰好'
    '给两个，第二个的程度为零（OwnStores.first_in_degree）。')})
d['next_delta'] = t(
    'Capacities across a hierarchy whose upper tier divides its giving among several stores, with the stores\' rises to '
    'cover as well.',
    '上层把给予分给多个库存、并须补足库存上升的层级中的容量。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(STORED))
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
    f'{DATE}: extended (IV3i): need in degree with capacities read off the stores, by the graded flow from the stores; '
    f'the OwnStores degree witness; study section {N}.',
    f'2026年10月23日：扩展（IV3i）：以从库存读出的容量计的被需要程度，借由库存的分级之流；OwnStores 的程度见证；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
