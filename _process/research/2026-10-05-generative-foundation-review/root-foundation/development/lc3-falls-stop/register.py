"""Remove from the apart register the roots LC3 joins to the base: Layered's structure, its stock that never rests and
its lack of the Archimedean property are now used by Layered.worlds_need_not_rest, which quantifies over worlds.
Textual removal of the three entries, the rest of the file byte for byte.
usage (from the checkout root): python3 -B register.py"""
import json
import re
from pathlib import Path
F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
t = F.read_text(encoding='utf-8')
for name in ("Becoming.Layered.ext'", 'Becoming.Layered.never_rests', 'Becoming.Layered.not_archimedean'):
    pat = re.compile(r'  "' + re.escape(name) + r'": \{\n(?:   [^\n]*\n)*?  \},\n')
    assert len(pat.findall(t)) == 1, name
    t = pat.sub('', t)
d = json.loads(t)
assert all(n not in d['roots'] for n in ("Becoming.Layered.ext'", 'Becoming.Layered.never_rests'))
F.write_text(t, encoding='utf-8')
print('register: 3 roots joined')
