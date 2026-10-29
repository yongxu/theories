#!/usr/bin/env python3
"""GW3-GW5 at landing: the four records' evidence at the receipt (validation scope, reviewed time, receipt reference
and proof bindings of GW's Lean files), and the study's integration references with their current bytes. Run after
records.py (on the records as main holds them) and before the re-point of the remaining drift.
usage (from the checkout root): python3 -B <kit>/land_records_gw.py RECEIPT"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

RECEIPT = sys.argv[1]
R = Path('theories/becoming/results/records')
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RCPT = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
G = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/gw-generation-and-widening'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
LIM = (600, 260)


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def load(n):
    return json.loads((R / f'{n}.json').read_text(encoding='utf-8'))


def save(n, d):
    (R / f'{n}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def scope(d, en, zh):
    assert len(en) <= LIM[0] and len(zh) <= LIM[1], (len(en), len(zh))
    d['validation_scope'] = {'en': en, 'zh': zh}


def rebind(d, files):
    """Proof bindings of `files` to the receipt; the record's receipt reference to it."""
    for b in d['proof_bindings']:
        if b['source'].split('/')[-1] in files:
            b['receipt'] = RCPT
    for ref in d['references']:
        if ref.get('role') == 'receipt' and 'becoming-checks/' in ref['path']:
            ref['path'], ref['sha256'] = RCPT, sha(RCPT)
            break
    else:
        d['references'].append({'path': RCPT, 'role': 'receipt', 'sha256': sha(RCPT)})


def integrate(d, paths):
    have = {r['path'] for r in d['references']}
    for p in paths:
        if p not in have:
            d['references'].append({'path': p, 'role': 'integration', 'sha256': sha(p)})


w = load('what-keeping-widening-needs')
scope(w, f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT}): Becoming.KeepingWidening, 307 declarations, and Population\'s length_le_count, every one with an empty axiom report, all cited here; every earlier statement of the module prints unchanged (signature audit). Built in sessions; independent read-only reviews by a separate AI agent, REVIEW-UE7 (study section 419) and REVIEW-GW-LEAN with its re-check (study section 448), every finding taken but one of the first; not reviewed by a person.',
      f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT}）：Becoming.KeepingWidening 之 307 项声明与 Population 之 length_le_count，公理报告皆空，本记录全引；本模块之每一旧陈述所印不变（签名审查）。另一 AI 代理作独立只读审查：REVIEW-UE7（研究第 419 节）与 REVIEW-GW-LEAN 及其复查（研究第 448 节），所见除首次一项外皆采；未经人审。')
w['reviewed_at_utc'] = NOW
rebind(w, {'KeepingWidening.lean', 'Population.lean'})
integrate(w, [f'{G}/NOTE.md', f'{G}/REVIEW-GW-LEAN.md', f'{G}/RECHECK-GW-LEAN.md', f'{G}/signatures.json'])
save('what-keeping-widening-needs', w)

g = load('where-the-possible-grows')
old = g['validation_scope']['en']
assert '110 declarations' in old
scope(g, f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT}): Becoming.HeldPossible, 118 declarations, every one with an empty axiom report, all cited here; the two instance theorems, the laws of reach and traces under the held moves, adaptive_keeps_rule_iff and the root law sit in the leaf until the owners of the definitions they concern move them. Independent read-only reviews by a separate AI agent: REVIEW-UE11 and RECHECK-UE11 (study section 429), REVIEW-GW-LEAN and its re-check (448); not reviewed by a person.',
      f'Lean 4.29.1 合并检查器实查（回执 {RECEIPT}）：Becoming.HeldPossible 之 118 项声明，公理报告皆空，本记录全引；两实例定理、持守之步下之达与迹之律、adaptive_keeps_rule_iff 与根之律暂居此叶，待其所涉定义之主移之。另一 AI 代理作独立只读审查：REVIEW-UE11 与 RECHECK-UE11（研究第 429 节），REVIEW-GW-LEAN 及其复查（448）；未经人审。')
g['reviewed_at_utc'] = NOW
rebind(g, {'HeldPossible.lean'})
integrate(g, [f'{G}/NOTE.md', f'{G}/REVIEW-GW-LEAN.md'])
save('where-the-possible-grows', g)

t = load('generation-and-degeneration-at-two-grains')
en = t['validation_scope']['en']
assert 'Becoming.MapInstances, 25 theorems' in en
t['validation_scope']['en'] = en.replace('Becoming.MapInstances, 25 theorems', 'Becoming.MapInstances, 28 theorems')
t['validation_scope']['zh'] = t['validation_scope']['zh'].replace('25', '28', 1) if '25' in t['validation_scope']['zh'] else t['validation_scope']['zh']
rebind(t, {'MapInstances.lean'})
integrate(t, [f'{G}/REVIEW-GW-LEAN.md'])
save('generation-and-degeneration-at-two-grains', t)

a = load('a-pattern-lasts-through-passing')
en = a['validation_scope']['en']
assert 'the 29 declarations of Becoming.PatternPassing, 19 of them theorems' in en
a['validation_scope']['en'] = en.replace('(receipt 20261019T064004.300228Z): the 29 declarations of Becoming.PatternPassing, 19 of them theorems',
                                         f'(receipt {RECEIPT}): the 46 declarations of Becoming.PatternPassing, 33 of them theorems')
assert RECEIPT in a['validation_scope']['en']
zh = a['validation_scope']['zh']
assert '（回执 20261019T064004.300228Z）：Becoming.PatternPassing 的 29 项声明（19 项定理）' in zh
a['validation_scope']['zh'] = zh.replace('（回执 20261019T064004.300228Z）：Becoming.PatternPassing 的 29 项声明（19 项定理）',
                                         f'（回执 {RECEIPT}）：Becoming.PatternPassing 的 46 项声明（33 项定理）')
rebind(a, {'PatternPassing.lean'})
integrate(a, [f'{G}/REVIEW-GW-LEAN.md'])
save('a-pattern-lasts-through-passing', a)
print('records landed at', RECEIPT)
