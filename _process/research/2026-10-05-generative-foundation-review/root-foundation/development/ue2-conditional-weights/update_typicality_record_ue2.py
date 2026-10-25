#!/usr/bin/env python3
"""UE2: update the record typicality-by-counting for the change to Becoming.Typicality (board rule 9).

The record's claim gains a law, so this takes a history note, written here, and is not a bookkeeping re-point. The
script adds the moved arithmetic (`regroup_square`, `square_gap`, `margin_square`, with `two_mul_le_of_le` and
`two_mul_le`) as a law after law 3, and the bound at every step (Kolmogorov's maximal inequality, `typical_throughout`)
as a law after it, each with its declarations; law 3 keeps `offBy` and `typical` and gains `offBy_le_within`. It removes `offBy_le` from law 3, the Typicality reference and the
aliases. It re-binds Typicality.lean to the new core receipt, with the receipt as a reference, and rewrites the
validation scope's receipt and counts. It adds the history note. Every edit asserts that it applies exactly once.
usage (from the checkout root, after the checker): python3 -B <kit>/update_typicality_record_ue2.py RECEIPT N"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
TYP = f'{PKG}/Becoming/Typicality.lean'
RECORD = ROOT / 'theories/becoming/results/records/typicality-by-counting.json'
LANDED_TYPICALITY = '904976890149379d5d5e061cebf97235035ed94091985003ff51801b52e1d8a3'
T = 'Becoming.Typicality.'
NEW_SECTION = ['pairSquare', 'pairCross', 'stopStep', 'stopped', 'reachesBy', 'reachesBy_of_end', 'stopped_spec',
               'moving', 'moving_le', 'stepCross', 'stopped_go', 'stopped_square_step', 'stopped_cross_step',
               'stopped_spread', 'offByWithin', 'offByWithin_le', 'typical_throughout']
MOVED = ['regroup_square', 'square_gap', 'margin_square']
NEW = NEW_SECTION + MOVED + ['offBy_le_within']
REMOVED = 'offBy_le'
MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November',
          'December']


def receipt_day(receipt_id):
    """The receipt's day in local time, as the repository dates its history notes and board rows."""
    utc = datetime.datetime.strptime(receipt_id, '%Y%m%dT%H%M%S.%fZ').replace(tzinfo=datetime.timezone.utc)
    day = utc.astimezone().date()
    return f'{day.day} {MONTHS[day.month - 1]} {day.year}', f'{day.year}年{day.month}月{day.day}日'


OLD_LAW3_EN = ("Most courses show the weights: those with x·x + y·y ≥ 2·x·y + d weigh, times d, at most n·p·q·(p + q)ⁿ; "
               "so those whose frequency of ones is off p / (p + q) by ε or more weigh a share of at most "
               "p·q / ((p + q)²·ε²·n), arithmetic from that bound with d = (p + q)²·ε²·n², not a separate theorem.")
LAW3 = {
    'zh': '多数历程于终点显示权重：x·x + y·y ≥ 2·x·y + d 的历程之重乘 d 至多 n·p·q·(p + q)ⁿ；所以一的频率与 p / (p + q) 相差 ε '
          '以上者，所占之重至多 p·q / ((p + q)²·ε²·n)；这是由那一界取 d = (p + q)²·ε²·n² 的算术，不是另一条定理。',
    'en': 'Most courses show the weights at the horizon: those with x·x + y·y ≥ 2·x·y + d weigh, times d, at most '
          'n·p·q·(p + q)ⁿ; so those whose frequency of ones is off p / (p + q) by ε or more weigh a share of at most '
          'p·q / ((p + q)²·ε²·n), arithmetic from that bound with d = (p + q)²·ε²·n², not a separate theorem.',
    'declarations': [T + s for s in ['offBy', 'offBy_le_within', 'typical']]}
LAW_MARGIN = {
    'zh': '边距平方：x + m ≤ y 则 m·m + 2·x·y ≤ x·x + y·y；m = 0 时即均值不等式之一步 2·x·y ≤ x·x + y·y。',
    'en': 'The margin square: x + m ≤ y gives m·m + 2·x·y ≤ x·x + y·y, and at m = 0 the AM–GM step '
          '2·x·y ≤ x·x + y·y.',
    'declarations': [T + s for s in MOVED + ['two_mul_le_of_le', 'two_mul_le']]}
LAW_EVERY_STEP = {
    'zh': '偏差在每一步都守于此界：每个历程之对于其平方偏差首次达到 d 之步停住，每一步只给仍在动之历程之重加 p·q·(p + q) 倍，'
          '所以某一步平方偏差达到 d 的历程之重乘 d 至多 n·p·q·(p + q)ⁿ，即 Kolmogorov 极大不等式；'
          '计数在每一步都近其均值，频率只在终点显示权重。',
    'en': "The deviation stays within the bound at every step: stopping each course's pair where its squared "
          'deviation first reaches d, a step adds p·q·(p + q) times the weight of the moving courses, so those whose '
          'squared deviation reaches d at some step weigh, times d, at most n·p·q·(p + q)ⁿ (Kolmogorov\'s maximal '
          'inequality). The counts stay near their means throughout; the frequencies show the weights only at the '
          'horizon.',
    'declarations': [T + s for s in NEW_SECTION]}
OLD_SCOPE_EN = ('Machine-checked by the consolidated Lean 4.29.1 checker (receipt 20261015T193101.075446Z): the 56 '
                'declarations of Becoming.Typicality, 43 of them theorems, have empty axiom reports; the checker verifies '
                'core purity. Author counterreview in study sections 140 and 150; reviewed by the eighteenth review (AI, '
                'read-only, no Lean rebuild), whose corrections are applied.')
OLD_SCOPE_ZH = ('Lean 4.29.1 合并检查器实查（回执 20261015T193101.075446Z）：Becoming.Typicality 的 56 项声明（43 项定理）'
                '公理报告为空；检查器并核对核心纯净。作者反审见研究 §140 与 §150；经第十八次审查（AI，只读，未重建 Lean）审阅，'
                '其更正已处理。')


def update(r, receipt_id, n, typ_sha, receipt_sha, names, theorems, now):
    """Edit the record `r` in place: `names` are the receipt's declaration names of Becoming.Typicality, `theorems`
    its theorem count, `typ_sha` the new Typicality.lean's sha256, `receipt_sha` the receipt file's."""
    receipt = f'{PKG}/becoming-checks/{receipt_id}/verification.json'
    assert r['id'] == 'typicality-by-counting'
    # law 3, and the bound at every step after it
    at = [i for i, law in enumerate(r['laws']) if law.get('en') == OLD_LAW3_EN]
    assert len(at) == 1, at
    old_law = r['laws'][at[0]]
    assert old_law['declarations'] == [T + 'two_mul_le', T + 'offBy', T + REMOVED, T + 'typical'], old_law['declarations']
    r['laws'][at[0]:at[0] + 1] = [LAW3, LAW_MARGIN, LAW_EVERY_STEP]
    # the Typicality reference: the receipt's declarations, offBy_le gone, the new ones in
    refs = [x for x in r['references'] if x['path'] == TYP]
    assert len(refs) == 1
    ref = refs[0]
    assert ref['sha256'] == LANDED_TYPICALITY, ref['sha256']
    old = set(ref['declarations'])
    assert T + REMOVED in old and not any(T + s in old for s in NEW)
    assert names == (old - {T + REMOVED}) | {T + s for s in NEW}, sorted(names ^ ((old - {T + REMOVED}) | {T + s for s in NEW}))
    ref['declarations'] = [d for d in ref['declarations'] if d != T + REMOVED]
    ref['declarations'] += [T + s for s in NEW]
    assert set(ref['declarations']) == names and len(ref['declarations']) == len(names)
    ref['sha256'] = typ_sha
    # the aliases
    assert r['aliases'].count(T + REMOVED) == 1
    r['aliases'].remove(T + REMOVED)
    for alias in (T + 'typical_throughout', T + 'margin_square', "Kolmogorov's maximal inequality in counting form"):
        assert alias not in r['aliases']
        r['aliases'].append(alias)
    # the receipt as a reference, and Typicality's binding to it
    assert not any(x['path'] == receipt for x in r['references'])
    r['references'].append({'path': receipt, 'role': 'receipt', 'sha256': receipt_sha, 'declarations': []})
    bindings = [b for b in r['proof_bindings'] if b['source'] == TYP]
    assert len(bindings) == 1
    bindings[0]['receipt'] = receipt
    # the validation scope's receipt and counts
    assert r['validation_scope']['en'] == OLD_SCOPE_EN and r['validation_scope']['zh'] == OLD_SCOPE_ZH
    r['validation_scope'] = {
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {receipt_id}）：Becoming.Typicality 的 {len(names)} 项声明（{theorems} 项定理）'
              f'公理报告为空；检查器并核对核心纯净。作者反审见研究 §140 与 §150；经第十八次审查（AI，只读，未重建 Lean）审阅，'
              f'其更正已处理；每一步之界随 UE2 经独立审查（AI，只读，重建 Lean，所见皆采）。',
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {receipt_id}): the {len(names)} '
              f'declarations of Becoming.Typicality, {theorems} of them theorems, have empty axiom reports; the checker '
              f'verifies core purity. Author counterreview in study sections 140 and 150; reviewed by the eighteenth '
              f'review (AI, read-only, no Lean rebuild), whose corrections are applied; the bound at every step '
              f'reviewed independently with UE2 (AI, read-only, with a Lean rebuild, its findings taken).'}
    r['reviewed_at_utc'] = now
    day_en, day_zh = receipt_day(receipt_id)
    r['history'].append({
        'en': f"{day_en}, UE2 (board rule 9): the bound at every step added, the courses whose squared deviation "
              f"reaches d at some step weighing, times d, at most n·p·q·(p + q)ⁿ (Typicality.typical_throughout, "
              f"Kolmogorov's maximal inequality), with typical now its corollary and its statement unchanged; the margin "
              f"square moved in from ConditionalWeights, two_mul_le_of_le derived from it at margin zero; offBy_le, the "
              f"remains of typical's direct proof, removed from the module, law 3, the references and the aliases. "
              f"Typicality.lean rebound to core receipt {receipt_id} after reading the change; study section {n}.",
        'zh': f'{day_zh}，UE2（看板规则 9）：加每一步之界，某一步平方偏差达到 d 之历程之重乘 d 至多 n·p·q·(p + q)ⁿ'
              f'（Typicality.typical_throughout，Kolmogorov 极大不等式），typical 现为其推论，陈述不变；边距平方自 ConditionalWeights '
              f'移入，two_mul_le_of_le 由之于边距为零时推出；typical 直接证明之余 offBy_le 自模块、第 3 条定律、引用与别名中删去。'
              f'读过改动后 Typicality.lean 改绑核心回执 {receipt_id}；研究第 {n} 节。'})
    return r


def main():
    receipt_id, n = sys.argv[1], int(sys.argv[2])
    receipt = f'{PKG}/becoming-checks/{receipt_id}/verification.json'

    def sha(path):
        return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()

    core = json.loads((ROOT / receipt).read_text())
    assert core['status'] == 'passed'
    assert core['source_sha256']['Becoming.Typicality'] == sha(TYP)
    mod = next(m for m in core['modules'] if m['module'] == 'Becoming.Typicality')
    assert not any(mod['axiom_dependencies'].values())
    names = {d['name'] for d in mod['declarations']}
    now = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
    r = json.loads(RECORD.read_text(encoding='utf-8'))
    update(r, receipt_id, n, sha(TYP), sha(receipt), names, mod['theorems'], now)
    RECORD.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('typicality-by-counting:', len(names), 'declarations,', mod['theorems'], 'theorems; rebound to', receipt_id)


if __name__ == '__main__':
    main()
