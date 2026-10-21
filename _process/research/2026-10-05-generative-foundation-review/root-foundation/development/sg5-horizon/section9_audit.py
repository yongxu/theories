# SG5 (from SG4, SG3): chapter section 9's sentence on unnamed instances and market words, rebuilt from the receipt (used by
# apply_text.py; standalone: python3 -B section9_audit.py RECEIPT from the checkout root).
import json
import re
import sys
from pathlib import Path

if 'R' not in globals():
    ROOT = Path.cwd()
    PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
    CH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
    R = json.loads((ROOT / PKG / 'becoming-checks' / sys.argv[1] / 'verification.json').read_text())
words = {2: 'Two', 3: 'Three', 4: 'Four', 5: 'Five', 6: 'Six'}
unnamed = [m.removeprefix('Becoming.') for m in R['not_audited_by_name']]
market = R['market_names']
ch_text = (ROOT / CH).read_text(encoding='utf-8')
m = re.search(r'Unnamed instances in \d+ modules \([^)]*\) are covered by the audit of the whole core environment, not by '
              r'name\. \w+ declaration names carry market words, .*?\)\.(?= The run reused)', ch_text)
assert m and ch_text.count(m.group(0)) == 1, 'section 9 audit sentence'
names = [f'`{n.removeprefix("Becoming.")}` ({", ".join(w)})' for n, w in market.items()]
listed = ', '.join(names[:-1]) + ' and ' + names[-1] if len(names) > 1 else names[0]
new = (f'Unnamed instances in {len(unnamed)} modules ({", ".join(unnamed)}) are covered by the audit of the whole core '
       f'environment, not by name. {words[len(names)]} declaration names carry market words, {listed}.')
(ROOT / CH).write_text(ch_text.replace(m.group(0), new), encoding='utf-8')
print('section 9 audit sentence:', len(unnamed), 'modules,', len(names), 'market names')
