#!/usr/bin/env python3
"""MA3a: 08's receipt and counts read from the receipt, and the study section (texts_ma3.py's counts, IV3j's receipts_j).
usage (from the checkout root of the landing worktree, after the checker): python3 -B land_ma3a.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
mod = next(m for m in R['modules'] if m['module'] == 'Becoming.RuleShaping')
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
assert 'Becoming.RuleShaping.lower_c_raises_strictly' in names
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure'])
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies'])
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path = ROOT / 'theories/becoming/chapters/08-METHOD.md'
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

section = f"""
## {N}. MA3's texts made exact, and the strict law of the cost (MA3a)

An independent review of the alignment dossier, relayed by board item AJ, found one overstatement in MA3's home section (§403): 02 §9 said "a smaller cost raises it" where `RuleShaping.lower_c_raises` proves a rule not lower (`order.le`, weak, for `c' ≤ c`). The same overstatement stood in the module's reading on help that lowers the cost, the root module's bullet and the checker's scope. Rather than only weaken those lines, MA3a proves the strict law, so the reading holds exactly where the cost is lowered strictly.

```text
Result(s): record shaping-the-rule-selected-by-what-comes-back extended (law 2, its declarations, history).
Delta: lower_c_raises_strictly: with the cost strictly lowered (c' < c) and nothing else changed, the rule after
       shaping is strictly higher in the share order. Texts: 02 §9's paragraph and reading, the module's doc and its
       reading on help that lowers the cost, the root bullet, the checker's scope and the package README rows (EN, ZH)
       now say "a smaller cost gives a rule not lower, and a strictly smaller one a strictly higher rule", and state
       "the shapers present" with nothing_back_falls and stretch_iff wherever those are stated (02 §9 already did);
       the shared part is said to decide the direction only at a step, as before.
Supplied premises / correspondence: none new.
Evidence: Becoming.RuleShaping, {mod['theorems']} theorems in {len(names)} declarations; core receipt {RECEIPT}, every
       axiom report empty.
Boundary: as in §403.
Output → input: the record; 02 §9; the module; the root bullet; the checker's scope; the README rows; 08's counts.
       Feeds AJ's reading on assistance (07 §6, D68), which can cite the strict law.
```

**Self-review.** (1) Every sentence that cited `lower_c_raises` was reread against its statement (weak) and now cites the strict law where it says "higher". (2) No other statement of MA3 changed.
"""
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
STUDY.write_text(t.rstrip('\n') + '\n' + section, encoding='utf-8')
print('08 counts:', counts[:100], '... ; study section', N)
