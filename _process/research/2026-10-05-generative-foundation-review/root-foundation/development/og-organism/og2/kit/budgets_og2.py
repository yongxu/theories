#!/usr/bin/env python3
"""OG2's landing: READING-BUDGETS' rows for the one page and the overview, re-measured after the status sentence changed
them by a few words. Only the figures change; each pattern must match once.
usage (from the checkout root): python3 -B budgets_og2.py"""
import re
import subprocess
from pathlib import Path

D = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers')
out = subprocess.run(['python3', '-B', str(D / 'kit/measure_layers.py')], capture_output=True, text=True, check=True).stdout
def row(name):
    m = re.search(r'^\| ' + re.escape(name) + r' \| ([\d,]+) \| ([\d,]+) \| ([\d.]+)–([\d.]+) \| (\d+) \|', out, re.M)
    assert m, name
    return m.groups()
F = D / 'READING-BUDGETS.md'
s = F.read_text(encoding='utf-8')
for title, en, zh in (('One page (and Chinese)', 'one page', 'one page, Chinese'), ('Overview (and Chinese)', 'overview', 'overview, Chinese')):
    w, c, lo, hi, b = row(en)
    w2, c2, lo2, hi2, _ = row(zh)
    over = int(int(w.replace(',', '')) + int(c.replace(',', '')) / 2 - int(b))
    pat = re.compile(r'(\| ' + re.escape(title) + r' \| )[\d,]+ words and [\d,]+ characters \([\d.]+ to [\d.]+ minutes\)(, stating [^;]*; Chinese )[\d,]+ words and [\d,]+ characters \([\d.]+ to [\d.]+ minutes\)( \| [^|]* \| Done: )[\d,]+( budget-words over)')
    s, n = pat.subn(lambda m: f'{m.group(1)}{w} words and {c} characters ({lo} to {hi} minutes){m.group(2)}{w2} words and {c2} characters ({lo2} to {hi2} minutes){m.group(3)}{over}{m.group(4)}', s)
    assert n == 1, title
    print(title, w, c, over)
F.write_text(s, encoding='utf-8')
