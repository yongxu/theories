#!/usr/bin/env python3
"""GS6: 08-METHOD's receipt line moved to GS6's core receipt, its counts read off the receipt. Whatever receipt the line
names at landing, its counts are checked against that receipt first (PF's receipt_pf.py, made independent of which
landing came before).
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/receipt_gs6.py RECEIPT"""
import json
import re
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
    return dict(modules=len(v['core_closure']), core=len(v['core_modules']), theorems=th(lambda m: True),
                core_theorems=th(lambda m: m['module'] in v['core_modules']),
                audited=sum(len(m['declarations']) for m in ms), injeq=len(v['generated_axiom_dependencies']),
                superseded=len(v['superseded_modules']))


def sentence(c):
    return (f"the closure held {c['modules']} modules (3 foundation, {c['core']} core, 13 in the instance and "
            f"application ring) and {c['theorems']:,} theorems; the {c['core']} core modules held "
            f"{c['core_theorems']:,} of them; {c['audited']:,} declarations were audited; {c['injeq']} generated "
            f"`injEq` lemmas depend on `propext`; {c['superseded']} superseded modules were kept out of the run.")


text = CH8.read_text(encoding='utf-8')
m = re.search(r'At core receipt \[`(\d{8}T\d{6}\.\d+Z)`\]', text)
assert m, 'receipt line'
old_receipt = m.group(1)
assert old_receipt != RECEIPT and text.count(old_receipt) == 2, (old_receipt, text.count(old_receipt))
p, c = counts(old_receipt), counts(RECEIPT)
old = sentence(p)
assert text.count(old) == 1, '08 counts do not match its receipt; recount by hand'
assert c['core'] == p['core'] and c['modules'] == p['modules'], 'GS6 adds no module'
text = text.replace(old_receipt, RECEIPT).replace(old, sentence(c))
CH8.write_text(text, encoding='utf-8')
print('08: receipt', old_receipt, '->', RECEIPT, c['modules'], 'modules,', c['theorems'], 'theorems,', c['audited'],
      'audited')
