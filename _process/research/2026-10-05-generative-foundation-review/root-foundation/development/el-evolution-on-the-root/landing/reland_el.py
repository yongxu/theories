#!/usr/bin/env python3
"""EL's landing (reland_bd2.py's and reland_bd3.py's pattern): 08's counts from the receipt, the study section from
study_el.txt appended as section N, and the receipt written into the six new records the kit left `PENDING`, each
with a receipt reference, and into the study texts' EL_RECEIPT and EL_SECTION marks. The other texts are already on
the branch. The receipt must have checked the very six leaves the records name.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_el.py RECEIPT N"""
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / f'{RF}/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
MARKED = [ROOT / f'{RF}/development/el-evolution-on-the-root/NOTE.md',
          ROOT / f'{RF}/development/el-evolution-on-the-root/WS.md']
TITLE = 'Evolution read on the root (EL)'
# each new record and the leaves it binds
PENDING = {
    'degeneration-from-a-horizon': ('LineDegeneration',),
    'the-selection-term-and-a-lineages-fate': ('SelectionShift', 'LineageRegions'),
    'ending-laws-as-regimes-on-a-lineage': ('LineageRegimes',),
    'a-pair-tolerates-only-within-a-window': ('WindowedWaiting',),
    'offspring-read-from-giving-that-waits': ('PairSelection',),
    'what-giving-that-waits-draws-on': ('PairSelection',),
}
MODULES = ('LineDegeneration', 'SelectionShift', 'LineageRegions', 'LineageRegimes', 'WindowedWaiting', 'PairSelection')

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
sha = {}
for short in MODULES:
    m = mods[f'Becoming.{short}']
    assert m['layer'] == 'core', (short, m['layer'])
    assert not any(m['axiom_dependencies'].values()), short
    sha[short] = hashlib.sha256((ROOT / f'{PKG}/Becoming/{short}.lean').read_bytes()).hexdigest()
    assert R['source_sha256'][f'Becoming.{short}'] == sha[short], f'the receipt checked another {short}.lean'

# 08: receipt and counts, every count read from the receipt
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# the study section, appended as section N, with each leaf's counts
section = (HERE / 'study_el.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in MODULES:
    m = mods[f'Becoming.{short}']
    section = section.replace(f'({short.upper()})', f"({m['theorems']} theorems in {len(m['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and not re.search(r'\([A-Z]{8,}\)', section), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "EL's section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the study texts' marks
for p in MARKED:
    s = p.read_text(encoding='utf-8')
    assert 'EL_RECEIPT' in s or 'EL_SECTION' in s, p
    p.write_text(s.replace('EL_RECEIPT', RECEIPT).replace('EL_SECTION', str(N)), encoding='utf-8')

# the receipt in the records: validation scope (both languages) and each leaf's proof binding
digest = hashlib.sha256((ROOT / rpath).read_bytes()).hexdigest()
for rid, leaves in PENDING.items():
    p = RECORDS / f'{rid}.json'
    text = p.read_text(encoding='utf-8')
    assert text.count('PENDING') >= 1 + len(leaves), (rid, text.count('PENDING'))
    d = json.loads(text.replace('PENDING', RECEIPT))
    for short in leaves:
        leaf = f'{PKG}/Becoming/{short}.lean'
        named = [x for x in d['references'] if x['path'] == leaf]
        assert len(named) == 1 and named[0]['sha256'] == sha[short], (rid, f'the record names another {short}.lean')
        bound = [b for b in d['proof_bindings'] if b['source'] == leaf]
        assert len(bound) == 1 and bound[0]['receipt'] == rpath, (rid, bound)
        m = mods[f'Becoming.{short}']
        for lang in ('en', 'zh'):
            assert str(m['theorems']) in d['validation_scope'][lang], (rid, lang, short, 'theorem count')
    if not any(x.get('path') == rpath for x in d['references']):
        d['references'].append({'path': rpath, 'role': 'receipt', 'sha256': digest, 'declarations': []})
    p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; receipt written into', list(PENDING))
