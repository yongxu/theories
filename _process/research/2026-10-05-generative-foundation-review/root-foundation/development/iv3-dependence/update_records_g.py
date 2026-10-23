#!/usr/bin/env python3
"""IV3g: extend the record self-concern-through-dependence with need in degree (the shortfall, the least a feeder
gives, attained, and need as a positive degree), with the Capacities degree witness; its references are re-hashed to
the new receipt and it gets one history note.
usage (from the checkout root, after apply_text_g.py): python3 -B update_records_g.py CORE_RECEIPT STUDY_SECTION"""
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
assert f'## {N}. Need in degree (IV3g)' in (ROOT / STUDY).read_text()
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
DEGREE = need([B + n for n in ['covered_by_excess', 'excess_le_of_covered', 'split_by']]
              + [W + n for n in ['shortfall', 'shortCapacity']]
              + [FL + n for n in ['givenFrom', 'gradedDrawn', 'replenishment_split', 'others_le_capacityWithout',
                                  'shortfall_le_givenFrom', 'shortfalls_le_given', 'otherCapacity_short',
                                  'capacityWithout_short', 'shortCapacity_le', 'gradedDrawn_fedOnlyWithin',
                                  'gradedDrawn_givenFrom_le', 'least_giving', 'needs_giver_iff_shortfalls_pos']]
              + [B + 'Capacities.' + n for n in ['copies_apart', 'second_in_degree']])
SCOPE = t(
    f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
    'Becoming.Weightings has an empty axiom report, and the checker verifies core purity. The literature check is the '
    f'significance review\'s dependence check. Author review in study sections 373, 378, 382 to 385 and {N}; not '
    'independently reviewed.',
    f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.Weightings 的每项声明公理报告为空；检查器并核对核心纯净。文献核查是'
    f'显著性审查中的“依存”核查。作者审查见研究第 373、378、382 至 385 与 {N} 节；未经独立审查。')

path = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(path.read_text(encoding='utf-8'))
assert len(d['laws']) == 17
d['laws'].append({**t(
    'A feeder\'s shortfall at a step is what the step demands beyond what the other active members can give. In every '
    'possible flow in which the consumer draws past the stock the feeder gives at least the sum of its shortfalls, and '
    'where it can give each, some possible flow has it give exactly that: its degree of need. Need is a positive '
    'degree. Witness Capacities: the second copy needed in degree one, the first in degree zero.',
    '供给者某步的缺额，是该步需求超出其余活跃成员合起来能给者。在消耗者汲取超出存量的每个可能的流中，供给者所给至少是其缺额之和；它能给出每个'
    '缺额时，某个可能的流使它恰好给出这么多：这是它被需要的程度。“所需”就是程度为正。见证 Capacities：第二个副本被需要的程度为一，第一个为零。'),
    'declarations': DEGREE})
d['hypotheses'].append(t(
    'For need in degree to be attained: the feeder a member able to give its shortfall at every step of the stretch.',
    '就程度的达成：供给者是成员，且在这段步的每一步都能给出其缺额。'))
d['counterexamples'].append({'path': SOURCE, 'detail': t(
    'Capacities in degree: with copies of one unit and two against a demand of two, every flow in which the user draws '
    'past the stock has the second copy give at least one unit, some has it give exactly one, and the first copy\'s '
    'degree is zero (Capacities.second_in_degree).',
    'Capacities 的程度：以一个单位与两个单位的副本对两个单位的需求，使用者汲取超出存量的每个流都使第二个副本至少给一个单位，某个流使它恰好给一个，'
    '第一个副本的程度为零（Capacities.second_in_degree）。')})
d['next_delta'] = t(
    'Capacities across a hierarchy whose upper tier divides its giving among several stores; the degree of need with '
    'capacities read off stores; an independent review.',
    '上层把给予分给多个库存的层级中的容量；以从库存读出的容量计的被需要程度；独立审查。')
d['validation_scope'] = SCOPE
d['reviewed_at_utc'] = NOW
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | set(DEGREE))
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
    f'{DATE}: extended (IV3g): need in degree (the shortfall; the least a feeder gives while the consumer draws past the '
    f'stock, attained; need as a positive degree); the Capacities degree witness; study section {N}.',
    f'2026年10月23日：扩展（IV3g）：按程度的“所需”（缺额；消耗者汲取超出存量时供给者至少要给的，并可达成；“所需”即程度为正）；'
    f'Capacities 的程度见证；研究第 {N} 节。'))
path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated', d['id'])
