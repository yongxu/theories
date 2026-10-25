#!/usr/bin/env python3
"""UE7 (OU3b's repoint_ou3b.py with UE7's paths): re-point the records drifting by UE7's edits only. The drift list
of `research.py check` is filtered to the paths UE7 changes, so another session's drift stays with its owner and is
printed for it. Before anything is written:
- the Lean drift (Population, Novelty, Gain, Admission) is checked by the signature audit (signatures_ue7.compare):
  every theorem of each module prints the statement it printed at main's receipt and no declaration is gone, so a
  record citing a module says what it said; the three records make_records_ue7.py extends with the general laws are
  among them, their hashes left for this step;
- every other drifting (record, path) pair is listed with its changed sections, and each changed section must be one
  UE7's texts write (EXPECTED below); a pair outside them stops the script, to be read and settled by hand.
Then tools/research/repoint.py re-points exactly the kept pairs and rebinds the proof bindings of the five Lean files
to the landing's receipt (it checks that the receipt binds each file's current bytes and records success).
usage (from the checkout root, after texts_ue7.py and make_records_ue7.py):
  python3 -B <kit>/repoint_ue7.py RECEIPT [--apply]"""
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
RID = 'what-keeping-widening-needs'
CHANGED = ('Population', 'Novelty', 'Gain', 'Admission')
LEAN = [f'{PKG}/Becoming/KeepingWidening.lean'] + [f'{PKG}/Becoming/{m}.lean' for m in CHANGED]
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/02-MAP.md', 'theories/becoming/chapters/07-SIGNIFICANCE.md',
         'theories/becoming/chapters/08-METHOD.md', 'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json']
MINE = set(LEAN) | set(OTHER)
# the sections UE7's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/02-MAP.md': {'3.2 Continued arising needs renewal, from beyond', 'Open', 'r-support-passed-on'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'2. The order with no premise', 'Open', 'r-eventual-widening'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table'},
}



def at_head(path):
    return subprocess.run(['git', 'show', f'HEAD:{path}'], cwd=ROOT, capture_output=True, text=True, check=True).stdout


# JSON sources UE7 edits in place (none beyond regions.json, which no record cites by section)
VERIFIED = {}

out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
kept = [x for x in drift if x['path'] in MINE and x['id'] != RID]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
assert not [x for x in drift if x['id'] == RID], 'the new record drifts: write it after the texts'

spec = importlib.util.spec_from_file_location('signatures_ue7', HERE / 'signatures_ue7.py')
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
            unexpected.append((x['id'], x['path'], 'changed beyond UE7\'s edit'))
        continue
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records: {len(lean_pairs)} Lean pairs '
      f'(statements unchanged in all {len(CHANGED)} modules), {len(other_pairs)} others:')
for x in other_pairs:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ('drift outside the sections UE7 writes: read it, then settle it by hand', unexpected)

with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
    json.dump({'source_drift': kept}, f)
cmd = [sys.executable, '-B', 'tools/research/repoint.py', '--reason',
       "UE7 landed: Becoming.KeepingWidening joined to the core as a leaf (the root module's import and doc, the "
       "checker's core list and scope, the package README rows EN and ZH); Population, Novelty, Gain and Admission "
       "gain the general laws below seven landed laws, re-proved from them, every theorem's printed statement "
       "unchanged (signatures_ue7.py); 07 §2 (the home section of what-keeping-widening-needs, eventual widening's "
       "first carrier form superseded), 07's and 02's Open items, 02's support-passed-on paragraph, 08 §8 and 08's "
       "counts; the study; regions.json; the connectivity; three records extended with the general laws and "
       "eventual-widening revised, each with its history note; read before re-pointing",
       '--drift-json', f.name, '--receipt', RECEIPT, '--lean'] + LEAN + (['--apply'] if APPLY else [])
result = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
Path(f.name).unlink()
print(result.stdout[-4000:], result.stderr[-2000:])
summary = json.loads(result.stdout)
print('repoint:', summary['records'], 'records', 'written' if APPLY else '(dry run)')
sys.exit(result.returncode)
