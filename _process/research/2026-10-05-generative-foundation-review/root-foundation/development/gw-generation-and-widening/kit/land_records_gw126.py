#!/usr/bin/env python3
"""GW1, GW2 and GW6 at landing: the two records' evidence at the receipt (validation scope, reviewed time, receipt
reference, proof bindings of the two leaves and the sha256 of their proof references), and the study's integration
references with their current bytes. Run after records_gw126.py and before the re-point of the remaining drift.
usage (from the checkout root): python3 -B <kit>/land_records_gw126.py RECEIPT MR_THEOREMS MR_DECLS WM_THEOREMS WM_DECLS"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

RECEIPT, MR_T, MR_D, WM_T, WM_D = sys.argv[1:6]
R = Path('theories/becoming/results/records')
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RCPT = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
MR = f'{PKG}/Becoming/MapRegions.lean'
WM = f'{PKG}/Becoming/WideningOnTheMap.lean'
G = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/gw-generation-and-widening'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
LIM = (600, 260)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load(n):
    return json.loads((R / f'{n}.json').read_text(encoding='utf-8'))


def save(n, d):
    (R / f'{n}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def bind(d, source, module):
    if not any(b['source'] == source for b in d['proof_bindings']):
        d['proof_bindings'].append({'source': source, 'receipt': RCPT, 'sha256_pointer': f'/source_sha256/{module}',
                                    'success_pointer': '/status', 'success_value': 'passed'})
    for b in d['proof_bindings']:
        if b['source'] == source:
            b['receipt'] = RCPT
    for ref in d['references']:
        if ref['path'] == source and ref.get('role') == 'proof':
            ref['sha256'] = sha(source)


def receipt_ref(d):
    if not any(r['path'] == RCPT for r in d['references']):
        d['references'].append({'path': RCPT, 'role': 'receipt', 'sha256': sha(RCPT)})


def integrate(d, paths):
    have = {r['path'] for r in d['references']}
    for p in paths:
        if p not in have:
            d['references'].append({'path': p, 'role': 'integration', 'sha256': sha(p)})


t = load('generation-and-degeneration-at-two-grains')
en, zh = t['validation_scope']['en'], t['validation_scope']['zh']
add_en = (f' Becoming.MapRegions (GW1, GW2), a core leaf importing GrammarMap only, {MR_T} theorems in {MR_D} declarations '
          f'at receipt {RECEIPT}, every axiom report empty; independent read-only review REVIEW-GW126-LEAN.')
add_zh = f'Becoming.MapRegions（GW1、GW2，只导入 GrammarMap 之核心叶）于回执 {RECEIPT}：{MR_D} 项声明（{MR_T} 项定理），公理报告皆空；独立只读审查 REVIEW-GW126-LEAN。'
assert 'MapRegions' not in en
assert len(en + add_en) <= LIM[0] and len(zh + add_zh) <= LIM[1], (len(en + add_en), len(zh + add_zh))
t['validation_scope'] = {'en': en + add_en, 'zh': zh + add_zh}
t['reviewed_at_utc'] = NOW
bind(t, MR, 'Becoming.MapRegions')
receipt_ref(t)
integrate(t, [f'{G}/NOTE.md', f'{G}/REVIEW-GW126-LEAN.md'])
save('generation-and-degeneration-at-two-grains', t)

NEW = 'keeping-widening-is-generation-losing-nothing'
k = load(NEW)
en = (f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT}): Becoming.WideningOnTheMap, a core '
      f'leaf, {WM_T} theorems in {WM_D} declarations, every one with an empty axiom report, all cited here. Built in a '
      f'session; an independent read-only review by a separate AI agent, REVIEW-GW126-LEAN (study section of GW1, GW2 '
      f'and GW6); not reviewed by a person.')
zh = (f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT}）：核心叶 Becoming.WideningOnTheMap 之 {WM_D} 项声明（{WM_T} 项定理），'
      f'公理报告皆空，本记录全引。另一 AI 代理作独立只读审查 REVIEW-GW126-LEAN；未经人审。')
assert len(en) <= LIM[0] and len(zh) <= LIM[1], (len(en), len(zh))
k['validation_scope'] = {'en': en, 'zh': zh}
k['reviewed_at_utc'] = NOW
bind(k, WM, 'Becoming.WideningOnTheMap')
receipt_ref(k)
integrate(k, [f'{G}/NOTE.md', f'{G}/REVIEW-GW126-LEAN.md'])
save(NEW, k)
print('records landed at', RECEIPT)
