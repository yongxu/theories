#!/usr/bin/env python3
"""RR2's landing (reland_rr.py's pattern): 08's counts from the receipt, the study section from study_rr2.txt appended as
section N, and the records built and amended by make_records_rr2.py after copying the amended records and moving any
earlier new one to ASIDE (a folder outside the repository; nothing is deleted). The other texts are put in place by
integrate_rr2.py.
usage (from the checkout root of the landing worktree): python3 -B <kit2>/reland_rr2.py RECEIPT N ASIDE"""
import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N, ASIDE = sys.argv[1], int(sys.argv[2]), Path(sys.argv[3])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CH = ROOT / 'theories/becoming/chapters'
RECORDS = ROOT / 'theories/becoming/results/records'
RIDS = ('when-holding-for-a-reading-stands-above-a-route',)
AMENDED = ('what-holding-for-a-reading-is-worth', 'when-no-route-stands-above-a-revision')
LVR = 'a-reading-informed-and-revalued'  # RF-M.3's record, amended where it has landed
TITLE = 'When holding for a reading stands above a route of keeping (RR2)'

R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
for m in R['modules']:
    if m['module'] in ('Becoming.RevisionPlans', 'Becoming.HeldForReading'):
        assert not any(m['axiom_dependencies'].values()), m['module']

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
mods = {m['module']: m for m in R['modules']}
section = (HERE / 'study_rr2.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
for short in ('RevisionPlans', 'HeldForReading'):
    m = mods[f'Becoming.{short}']
    section = section.replace(f'({short.upper()})', f"({m['theorems']} theorems in {len(m['declarations'])} declarations)")
# RF-M.3's ListingValuation, where it has landed
lv = mods.get('Becoming.ListingValuation')
fill = {
    '{LVR_LINE}': ("a-reading-informed-and-revalued (ListingValuation.forgone_lt_iff, with the comparisons through it, "
                   "proved from the\n       order of plans, its statements unchanged)." if lv else ''),
    '{LV_DELTA}': ("\n  - ListingValuation: forgone_lt_iff, holding for two rules each forgoing an amount, is above_iff "
                   "at two held plans\n    (held_above_held_iff); forgone_through_lt_iff, revalued_forgone_lt_iff and "
                   "presented_forgone_lt_iff follow\n    from it as before." if lv else ''),
    '{LV_EVIDENCE}': (f", and Becoming.ListingValuation rebuilt on it ({lv['theorems']} theorems in "
                      f"{len(lv['declarations'])} declarations)" if lv else ''),
    '{LVR_OUT}': ' and RF-M.3\'s' if lv else '',
}
for key, value in fill.items():
    section = section.replace(key, value)
section = section.replace("when-no-route-stands-above-a-revision (the join removed from its next step); \n",
                          "when-no-route-stands-above-a-revision (the join removed from its next step).\n")
assert '{' not in section and 'TODO' not in section and '(HELDFORREADING)' not in section and '(REVISIONPLANS)' not in section, 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert TITLE not in t, 'RR2\'s section is already in the study'
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the records: the earlier ones moved aside, then rebuilt
ASIDE.mkdir(parents=True, exist_ok=True)
for rid in AMENDED + ((LVR,) if (RECORDS / f'{LVR}.json').exists() else ()):
    shutil.copyfile(RECORDS / f'{rid}.json', ASIDE / f'{rid}.before.json')
for rid in RIDS:
    for ext in ('.json', '.md'):
        p = RECORDS / f'{rid}{ext}'
        if p.exists():
            shutil.move(str(p), str(ASIDE / f'{rid}{ext}'))
subprocess.run([sys.executable, '-B', str(HERE / 'make_records_rr2.py'), RECEIPT, str(N)], check=True)
print('reland:', counts[:100], '...; study section', N, '; records rebuilt; earlier records in', ASIDE)
