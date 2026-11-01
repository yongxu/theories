#!/usr/bin/env python3
"""BD4's landing (reland_bd3.py's pattern): 08's counts from the receipt, the study section from study_bd4.txt appended
as section N, and the receipt written into the one record the kit left `PENDING` (balance-from-conservation-along-a-
relation, whose seventh and eighth laws the leaf proves), with the leaf's counts read from the receipt and a receipt
reference. The other texts are already on the branch. The receipt must have checked the very BalanceRegions.lean the
record names.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_bd4.py RECEIPT N"""
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORD = ROOT / 'theories/becoming/results/records/balance-from-conservation-along-a-relation.json'
LEAF = f'{PKG}/Becoming/BalanceRegions.lean'
TITLE = 'Balance on each closure, on the root (BD4)'

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
leaf = mods['Becoming.BalanceRegions']
assert leaf['layer'] == 'core', leaf['layer']
assert not any(leaf['axiom_dependencies'].values()), 'an axiom in BalanceRegions'
leaf_sha = hashlib.sha256((ROOT / LEAF).read_bytes()).hexdigest()
assert R['source_sha256']['Becoming.BalanceRegions'] == leaf_sha, 'the receipt checked another BalanceRegions.lean'

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

# the study section, appended as section N
section = (HERE / 'study_bd4.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(BALANCEREGIONS)', f"({leaf['theorems']} theorems in {len(leaf['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and not re.search(r'\([A-Z]{8,}\)', section), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "BD4's section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the receipt in the record: validation scope (both languages) and the leaf's proof binding
text = RECORD.read_text(encoding='utf-8')
assert text.count('PENDING') == 3, text.count('PENDING')
d = json.loads(text.replace('PENDING', RECEIPT))
n_decl, n_thm = len(leaf['declarations']), leaf['theorems']
# the leaf's counts as the scratch build gave them, replaced by the receipt's
for lang, pattern, new in (('en', r'at receipt ' + re.escape(RECEIPT) + r', \d+ declarations \(\d+ theorems\)',
                            f'at receipt {RECEIPT}, {n_decl} declarations ({n_thm} theorems)'),
                           ('zh', r'回执 ' + re.escape(RECEIPT) + r'，\d+ 个声明中 \d+ 条定理',
                            f'回执 {RECEIPT}，{n_decl} 个声明中 {n_thm} 条定理')):
    vs, k = re.subn(pattern, new, d['validation_scope'][lang])
    assert k == 1, (lang, d['validation_scope'][lang])
    d['validation_scope'][lang] = vs
named = [x for x in d['references'] if x['path'] == LEAF]
assert len(named) == 1 and named[0]['sha256'] == leaf_sha, 'the record names another BalanceRegions.lean'
bound = [b for b in d['proof_bindings'] if b['source'] == LEAF]
assert len(bound) == 1 and bound[0]['receipt'] == rpath, bound
digest = hashlib.sha256((ROOT / rpath).read_bytes()).hexdigest()
if not any(x.get('path') == rpath for x in d['references']):
    d['references'].append({'path': rpath, 'role': 'receipt', 'sha256': digest, 'declarations': []})
RECORD.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; receipt written into balance-from-conservation-along-a-relation;',
      f'BalanceRegions {n_thm} theorems in {n_decl} declarations')
