#!/usr/bin/env python3
"""PF2: 08-METHOD's receipt line moved to PF2's core receipt, its counts read off the receipt (the same modules,
Becoming.GrammarPath extended); the previous line's receipt and counts are read and checked against that receipt.
usage (from the checkout root of the landing worktree, after the checker): python3 -B <kit>/round2/receipt_pf2.py RECEIPT"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT = sys.argv[1]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH8 = ROOT / 'theories/becoming/chapters/08-METHOD.md'


def counts(rid):
    v = json.loads((ROOT / PKG / f'becoming-checks/{rid}/verification.json').read_text())
    assert v['status'] == 'passed'
    ms = v['modules']
    th = lambda sel: sum(m['theorems'] if isinstance(m['theorems'], int) else len(m['theorems']) for m in ms if sel(m))
    return dict(modules=len(v['core_closure']), core=len(v['core_modules']), theorems=th(lambda m: True),
                core_theorems=th(lambda m: m['module'] in v['core_modules']), audited=sum(len(m['declarations']) for m in ms),
                injeq=len(v['generated_axiom_dependencies']), superseded=len(v['superseded_modules']))


def line(rid, c):
    return (f"the closure held {c['modules']} modules (3 foundation, {c['core']} core, 13 in the instance and application "
            f"ring) and {c['theorems']:,} theorems; the {c['core']} core modules held {c['core_theorems']:,} of them; "
            f"{c['audited']:,} declarations were audited; {c['injeq']} generated `injEq` lemmas depend on `propext`; "
            f"{c['superseded']} superseded modules were kept out of the run.")


text = CH8.read_text(encoding='utf-8')
old_rid = re.search(r'At core receipt \[`(\d{8}T\d{6}\.\d{6}Z)`\]', text).group(1)
old = line(old_rid, counts(old_rid))
assert text.count(old) == 1 and text.count(old_rid) == 2, ('08 counts do not match its receipt', old_rid)
new_c = counts(RECEIPT)
text = text.replace(old_rid, RECEIPT).replace(old, line(RECEIPT, new_c))
CH8.write_text(text, encoding='utf-8')
print('08:', old_rid, '->', RECEIPT, new_c)
