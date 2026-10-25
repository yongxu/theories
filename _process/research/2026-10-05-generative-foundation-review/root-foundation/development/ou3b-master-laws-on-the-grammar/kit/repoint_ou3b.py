#!/usr/bin/env python3
"""OU3b: re-point the records drifting by OU3b's edits only (IV3k's repoint_k.sh, in Python). The drift list of
`research.py check` is filtered to the paths OU3b changes, so another session's drift stays with its owner and is
printed for it. Before anything is written:
- the Lean drift (the fourteen changed modules) is checked by the signature audit (signatures_ou3b.compare): every
  theorem of each module prints the statement it printed at main's receipt and no declaration is gone, so a record
  citing a module says what it said;
- every other drifting (record, path) pair is listed with its changed sections, and each changed section must be one
  OU3b's texts write (EXPECTED below), or, for a JSON source OU3b edits, the file must differ from main's only by
  OU3b's edit (VERIFIED below); a pair outside them stops the script, to be read and settled by hand.
Then tools/research/repoint.py re-points exactly the kept pairs and rebinds the proof bindings of the fifteen Lean
files to the landing's receipt (it checks that the receipt binds each file's current bytes and records success).
usage (from the checkout root, after texts_ou3b.py and make_records_ou3b.py):
  python3 -B <kit>/repoint_ou3b.py RECEIPT [--apply]"""
import importlib.util
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT_ID = sys.argv[1]
APPLY = '--apply' in sys.argv[2:]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RID = 'master-laws-on-the-grammar'
CHANGED = ('Frame', 'Recurrence', 'Attraction', 'Laws', 'Mechanism', 'IdentificationRuns', 'GrammarRegularity',
           'GrammarScope', 'Regions', 'Admission', 'Flow', 'Amounts', 'InAmounts', 'Weightings')
LEAN = [f'{PKG}/Becoming/GrammarLaws.lean'] + [f'{PKG}/Becoming/{m}.lean' for m in CHANGED]
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/completion/COVERAGE.json', 'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json']
MINE = set(LEAN) | set(OTHER)
# the sections OU3b's texts change, as research.py check names them (a heading, or the anchor a record cites)
EXPECTED = {
    'theories/becoming/chapters/01-ROOT.md': {'7. What the grammar can say and what it derives', 'Open'},
    'theories/becoming/chapters/08-METHOD.md': {'7. Master laws and connectivity'},
}



def at_head(path):
    return subprocess.run(['git', 'show', f'HEAD:{path}'], cwd=ROOT, capture_output=True, text=True, check=True).stdout


def coverage_only_finite_runs(path):
    """COVERAGE.json differs from main's only in the finite-runs master law's statement."""
    old, new = json.loads(at_head(path)), json.loads((ROOT / path).read_text(encoding='utf-8'))
    law = next(x for x in new['master_laws'] if x['id'] == 'return')
    law['statement'] = next(x for x in old['master_laws'] if x['id'] == 'return')['statement']
    return old == new


# JSON sources OU3b edits in place, each with the check that only OU3b's edit changed it
VERIFIED = {'theories/becoming/results/completion/COVERAGE.json': coverage_only_finite_runs}

out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
kept = [x for x in drift if x['path'] in MINE and x['id'] != RID]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
assert not [x for x in drift if x['id'] == RID], 'the new record drifts: write it after the texts'

spec = importlib.util.spec_from_file_location('signatures_ou3b', HERE / 'signatures_ou3b.py')
sig = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sig)
_, _, report = sig.compare(RECEIPT_ID)
bad = {m: r for m, r in report.items() if r['changed'] or r['gone'] or r['definitions_gone']}
assert not bad, ('a statement changed or a declaration is gone: read the records citing it', bad)

lean_pairs = [x for x in kept if x['path'] in LEAN]
other_pairs = [x for x in kept if x['path'] not in LEAN]
unexpected = []
for x in other_pairs:
    if x['path'] in VERIFIED:
        if not VERIFIED[x['path']](x['path']):
            unexpected.append((x['id'], x['path'], 'changed beyond OU3b\'s edit'))
        continue
    sections = set(x.get('changed_sections') or [])
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records: {len(lean_pairs)} Lean pairs '
      f'(statements unchanged in all {len(CHANGED)} modules), {len(other_pairs)} others:')
for x in other_pairs:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ('drift outside the sections OU3b writes: read it, then settle it by hand', unexpected)

with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
    json.dump({'source_drift': kept}, f)
cmd = [sys.executable, '-B', 'tools/research/repoint.py', '--reason',
       "OU3b landed: Becoming.GrammarLaws joined to the core below the frame (the root module's import and doc, the "
       "checker's core list and scope, the package README rows EN and ZH); fourteen model modules prove their laws "
       "from the grammar's, every theorem's printed statement unchanged (signatures_ou3b.py) and the representation "
       "theorems added; 01 §7 (the home section of master-laws-on-the-grammar, the Open item on lifting), 08 §7 (the "
       "column On the grammar, the finite-runs clause corrected, the counts and the measure) and 08's counts; "
       "COVERAGE.json's finite-runs statement; the study; regions.json; the connectivity and its register; read "
       "before re-pointing",
       '--drift-json', f.name, '--receipt', RECEIPT, '--lean'] + LEAN + (['--apply'] if APPLY else [])
result = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
Path(f.name).unlink()
print(result.stdout[-4000:], result.stderr[-2000:])
summary = json.loads(result.stdout)
print('repoint:', summary['records'], 'records', 'written' if APPLY else '(dry run)')
sys.exit(result.returncode)
