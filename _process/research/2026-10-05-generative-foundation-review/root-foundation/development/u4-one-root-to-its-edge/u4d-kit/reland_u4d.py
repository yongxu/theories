#!/usr/bin/env python3
"""U4d's landing (reland_el6.py's pattern): 08's counts from the receipt; the study section from study_u4d.txt
appended as section N, each changed module's counts read from the receipt; the receipt and section written into the
records' U4D_RECEIPT and U4D_SECTION marks; and the sha256 of the design and its review into the references the
branch left `PENDING`, with a receipt reference where a GrammarLaws binding the branch added names the receipt. The receipt must have checked the very bytes of the six changed modules, each in the core with
every axiom report empty, and GrammarLaws must hold the 223 theorems in 252 declarations shared-laws-on-the-grammar's
scope states. The changed modules' references and proof bindings are repoint_u4d.py's.
usage (from the checkout root of the worktree): python3 -B <kit>/reland_u4d.py RECEIPT N"""
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
U4 = f'{RF}/development/u4-one-root-to-its-edge'
STUDY = ROOT / f'{RF}/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
TITLE = 'The covering laws on the root (U4d)'
CHANGED = ('Prelude', 'GrammarLaws', 'Population', 'Locality', 'Decidedness', 'Identity')
MARKED = ('shared-laws-on-the-grammar', 'census-balance-under-continuation', 'ceasing-needs-arising',
          'recurrence-without-decidedness', 'laws-of-one-step', 'continued-change-needs-openness',
          'space-and-its-parts', 'one-root-to-its-edge')
DOCS = {f'{U4}/COVERING-ON-THE-ROOT.md', f'{U4}/REVIEW-U4D.md'}

rpath = f'{PKG}/becoming-checks/{RECEIPT}/verification.json'
R = json.loads((ROOT / rpath).read_text())
assert R['status'] == 'passed'
mods = {m['module']: m for m in R['modules']}
for short in CHANGED:
    m = mods[f'Becoming.{short}']
    assert m['layer'] == 'core', (short, m['layer'])
    assert not any(m['axiom_dependencies'].values()), short
    sha = hashlib.sha256((ROOT / f'{PKG}/Becoming/{short}.lean').read_bytes()).hexdigest()
    assert R['source_sha256'][f'Becoming.{short}'] == sha, f'the receipt checked another {short}.lean'
g = mods['Becoming.GrammarLaws']
assert (g['theorems'], len(g['declarations'])) == (223, 252), (g['theorems'], len(g['declarations']))

# 08: receipt and counts, every count read from the receipt (reland_el6.py's sentence)
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

# the study section, appended as section N, with each changed module's counts
section = (HERE / 'study_u4d.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in CHANGED:
    m = mods[f'Becoming.{short}']
    section = section.replace(f'({short.upper()})', f"({m['theorems']} theorems in {len(m['declarations'])} declarations)")
assert '{' not in section and 'TODO' not in section and not re.search(r'\([A-Z]{6,}\)', section), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, "U4d's section is already in the study"
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the records: the marks, and the design's and review's sha256
digests = {p: hashlib.sha256((ROOT / p).read_bytes()).hexdigest() for p in DOCS}
receipt_digest = hashlib.sha256((ROOT / rpath).read_bytes()).hexdigest()
filled = {}
for rid in MARKED:
    p = RECORDS / f'{rid}.json'
    text = p.read_text(encoding='utf-8')
    assert 'U4D_RECEIPT' in text or 'U4D_SECTION' in text, rid
    d = json.loads(text.replace('U4D_RECEIPT', RECEIPT).replace('U4D_SECTION', str(N)))
    for ref in d['references']:
        if ref.get('sha256') == 'PENDING':
            assert ref['path'] in DOCS, (rid, ref['path'])
            ref['sha256'] = digests[ref['path']]
            filled[rid] = filled.get(rid, 0) + 1
    # the GrammarLaws bindings the branch added name the receipt by its mark; their receipt reference goes with them
    if any(b['receipt'] == rpath for b in d['proof_bindings']) and not any(r['path'] == rpath for r in d['references']):
        d['references'].append({'path': rpath, 'role': 'receipt', 'sha256': receipt_digest, 'declarations': []})
        filled[rid] = filled.get(rid, 0) + 1
    out = json.dumps(d, ensure_ascii=False, indent=2) + '\n'
    assert 'PENDING' not in out and 'U4D_' not in out, f'a mark left in {rid}'
    p.write_text(out, encoding='utf-8')
print('reland:', counts[:110], '...; study section', N, '; marks filled in', len(MARKED), 'records; design and review',
      'sha256 in', filled)
