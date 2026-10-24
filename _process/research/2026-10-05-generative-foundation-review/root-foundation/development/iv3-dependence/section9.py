#!/usr/bin/env python3
"""IV3: chapter §9's current receipt and counts (EN, ZH), the counts read from the receipt (Becoming.Weightings grew
from 146 theorems; no module was added).
usage (from the checkout root, after apply_text.py): python3 -B section9.py RECEIPT MAIN_COMMIT STUDY_SECTION"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, MAIN, N = sys.argv[1], sys.argv[2], int(sys.argv[3])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
LAYERS = {}
for module in R['modules']:
    count = LAYERS.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
CORE = LAYERS['core']
CLOSURE = [sum(v[0] for v in LAYERS.values()), sum(v[1] for v in LAYERS.values())]
SPINE = sum(m['theorems'] for m in R['modules'] if m['spine'])
LINK = (f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
        f'#{N}-self-concern-through-dependence-iv3')
CHECKS = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'


def put(text, label, modules, theorems):
    """Set the row whose first cell starts with `label` to its counts, in the row's own words."""
    rows = [line for line in text.split('\n') if line.startswith('| ' + label)]
    assert len(rows) == 1, (label, rows)
    row = rows[0]
    numbers = re.findall(r'\d{1,3}(?:,\d{3})+|\d+', row.split(' | ')[-1])
    new = row.split(' | ')
    cell = new[-1]
    if modules is not None:
        cell = re.sub(r'^\d+', str(modules), cell, count=1)
    cell = re.sub(r'\d{1,3}(?:,\d{3})+(?= (?:theorems|条定理))', f'{theorems:,}', cell, count=1)
    new[-1] = cell
    assert numbers, row
    return text.replace(row, ' | '.join(new))


en_path = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
en = en_path.read_text()
en, k = re.subn(r'\*\*The current receipt\*\* is run \[`[0-9TZ.]+`\]\([^)]*\) \(the \[current pointer\]\(([^)]*)\)\), '
                r'checked with Lean 4\.29\.1 on main [0-9a-f]+ with [^(]+ in the working tree \(\[study §\d+\]\([^)]*\)\)\.',
                lambda m: f'**The current receipt** is run [`{RECEIPT}`]({CHECKS}) (the [current pointer]({m.group(1)})), '
                          f'checked with Lean 4.29.1 on main {MAIN} with IV3 in the working tree ([study §{N}]({LINK})).', en)
assert k == 1, k
en = put(en, 'Core modules', CORE[0], CORE[1])
en = put(en, 'Closure (core, ring and foundation)', CLOSURE[0], CLOSURE[1])
en = put(en, 'Spine (the core and the ring', None, SPINE)
en_path.write_text(en)

zh_path = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
zh = zh_path.read_text()
zh, k = re.subn(r'\*\*当前回执\*\*是运行 \[`[0-9TZ.]+`\]\([^)]*\)（\[当前指针\]\(([^)]*)\)），以 Lean 4\.29\.1 检查'
                r'（\[研究第 \d+ 节\]\([^)]*\)）。',
                lambda m: f'**当前回执**是运行 [`{RECEIPT}`]({CHECKS})（[当前指针]({m.group(1)})），以 Lean 4.29.1 检查'
                          f'（[研究第 {N} 节]({LINK})）。', zh)
assert k == 1, k
zh = put(zh, '核心模块', CORE[0], CORE[1])
zh = put(zh, '闭包（核心、环与根基）', CLOSURE[0], CLOSURE[1])
if any(line.startswith('| 脊柱') for line in zh.split('\n')):
    zh = put(zh, '脊柱', None, SPINE)
zh_path.write_text(zh)
print('section 9 updated', RECEIPT, MAIN)
