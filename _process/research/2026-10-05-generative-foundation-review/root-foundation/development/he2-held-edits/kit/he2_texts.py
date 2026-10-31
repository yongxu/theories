#!/usr/bin/env python3
"""HE2: 08's core counts at HE2's receipt, and the study section (he2_study.txt, its placeholders filled from the
receipt and from the arguments). Items 6 and 7's own texts part (he2_core_li.py --apply texts) runs before this.
usage (from the checkout root of the landing worktree, after the checker and the records):
  python3 -B <kit>/he2_texts.py RECEIPT N REPOINTED SIGNATURES_LOG [--check]
REPOINTED is the number of records the re-point touched, read from its log; SIGNATURES_LOG is he2_signatures.py's
output on RECEIPT, which must end in its OK line. The study section's counts are read from it and from the kits."""
import importlib.util
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N, REPOINTED, SIGLOG = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), Path(sys.argv[4])
CHECK = '--check' in sys.argv
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'

R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
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
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items() if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies'])
superseded = len(R['superseded_modules'])
link = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
path08 = CH / '08-METHOD.md'
s = path08.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k

mods = {x['module']: x for x in R['modules']}
log = SIGLOG.read_text(encoding='utf-8')
assert log.rstrip().endswith('as the items say'), 'the signature audit did not pass'
audit = json.loads(log[:log.rindex('\n}') + 2])
assert audit['new_receipt'] == RECEIPT, (audit['new_receipt'], RECEIPT)
spec = importlib.util.spec_from_file_location('k24', ROOT / '_process/research/2026-10-05-generative-foundation-review/'
                                              'root-foundation/development/u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py')
k24 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(k24)
renamed_t, renamed_d = len(audit['gone']), len(audit['definitions_gone'])
added_t, added_d = len(audit['added']) - renamed_t, len(audit['definitions_added']) - renamed_d
fill = {'{N}': str(N), '{RECEIPT}': RECEIPT, '{MODULES}': str(modules), '{REPOINTED}': str(REPOINTED),
        '{GT}': str(mods['Becoming.GrammarLaws']['theorems']), '{GD}': str(len(mods['Becoming.GrammarLaws']['declarations'])),
        '{I24}': str(len(k24.NEW)), '{T_BEFORE}': str(audit['declarations_old']), '{T_AFTER}': str(audit['declarations_new']),
        '{RENAMED}': str(renamed_t + renamed_d), '{RENAMED_T}': str(renamed_t), '{RENAMED_D}': str(renamed_d),
        '{ADDED}': str(added_t + added_d), '{ADDED_T}': str(added_t), '{ADDED_D}': str(added_d),
        '{MOVED}': str(len(audit['moved'])), '{BY_RENAME_S}': str(len(audit['changed_by_the_renames_only'])),
        '{BY_RENAME_D}': str(len(audit['definitions_rewritten_by_the_renames_only']))}
assert len(audit['changed']) == 1, audit['changed']
section = (HERE / 'he2_study.txt').read_text(encoding='utf-8')
for key, value in fill.items():
    section = section.replace(key, value)
assert not re.search(r'\{[A-Z_]+\}', section), 'unfilled placeholder'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t
assert max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M)) == N - 1, 'N must be the last section plus one'
if CHECK:
    print(counts)
    print(section)
    print('checked: 08 counts and study section', N, '; nothing written')
else:
    path08.write_text(s, encoding='utf-8')
    STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')
    print('texts: 08 counts; study section', N)
