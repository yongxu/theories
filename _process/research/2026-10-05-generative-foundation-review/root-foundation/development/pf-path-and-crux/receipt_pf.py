#!/usr/bin/env python3
"""PF: 08-METHOD's receipt line moved to PF's core receipt, its counts read off the receipt (one more core module,
Becoming.GrammarPath). The previous counts are checked against the previous receipt first.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/receipt_pf.py RECEIPT"""
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT = sys.argv[1]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH8 = ROOT / 'theories/becoming/chapters/08-METHOD.md'
def counts(receipt_id):
    v = json.loads((ROOT / PKG / f'becoming-checks/{receipt_id}/verification.json').read_text())
    assert v['status'] == 'passed'
    ms = v['modules']
    th = lambda sel: sum(m['theorems'] if isinstance(m['theorems'], int) else len(m['theorems']) for m in ms if sel(m))
    return dict(v=v, modules=len(v['core_closure']), core=len(v['core_modules']), theorems=th(lambda m: True),
                core_theorems=th(lambda m: m['module'] in v['core_modules']),
                audited=sum(len(m['declarations']) for m in ms), injeq=len(v['generated_axiom_dependencies']),
                superseded=len(v['superseded_modules']))


c = counts(RECEIPT)
assert any(m['module'] == 'Becoming.GrammarPath' for m in c['v']['modules'])
text = CH8.read_text(encoding='utf-8')
old_receipt = '20261025T045617.350224Z'
old = ('the closure held 319 modules (3 foundation, 303 core, 13 in the instance and application ring) and 14,678 '
       'theorems; the 303 core modules held 13,844 of them; 20,095 declarations were audited; 223 generated `injEq` '
       'lemmas depend on `propext`; 75 superseded modules were kept out of the run.')
assert text.count(old_receipt) == 2 and text.count(old) == 1, '08 changed since MA2; recount by hand'
p = counts(old_receipt)
assert (p['modules'], p['core'], p['theorems'], p['core_theorems'], p['audited']) == (319, 303, 14678, 13844, 20095)
assert c['injeq'] == 223 and c['superseded'] == 75 and c['core'] == p['core'] + 1
new = (f"the closure held {c['modules']} modules (3 foundation, {c['core']} core, 13 in the instance and application "
       f"ring) and {c['theorems']:,} theorems; the {c['core']} core modules held {c['core_theorems']:,} of them; "
       f"{c['audited']:,} declarations were audited; 223 generated `injEq` lemmas depend on `propext`; 75 superseded "
       f"modules were kept out of the run.")
text = text.replace(old_receipt, RECEIPT).replace(old, new)
CH8.write_text(text, encoding='utf-8')
print('08: receipt', RECEIPT, c['modules'], 'modules,', c['theorems'], 'theorems,', c['audited'], 'audited')
