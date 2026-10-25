#!/usr/bin/env python3
"""UE9 (UE7's repoint_ue7.py without its Lean audit: UE9 is a leaf and changes no landed module): re-point the records
drifting by UE9's edits only. The drift list of `research.py check` is filtered to the paths UE9 changes, so another
session's drift stays with its owner and is printed for it. Before anything is written, every drifting (record, path)
pair is listed with its changed sections, and each changed section must be one UE9's texts write (EXPECTED below); a
pair outside them, or any drift on a Lean file, stops the script, to be read and settled by hand. Then
tools/research/repoint.py re-points exactly the kept pairs; no proof binding is rebound, since no record but the new one
cites the new module.
usage (from the checkout root, after texts_ue9.py and make_records_ue9.py):
  python3 -B <kit>/repoint_ue9.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RID = 'comparing-two-courses-on-what-they-admit'
LEAN = [f'{PKG}/Becoming/ComparingCourses.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/chapters/02-MAP.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json']
MINE = set(LEAN) | set(OTHER)
# the sections UE9's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'2. The order with no premise', 'Open', 'r-eventual-widening',
                                                     'r-what-keeping-widening-needs'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table'},
    'theories/becoming/chapters/02-MAP.md': {'Open'},
}

out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
kept = [x for x in drift if x['path'] in MINE and x['id'] != RID]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
assert not [x for x in drift if x['id'] == RID], 'the new record drifts: write it after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than the new one cites the new module'

unexpected = []
for x in kept:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections UE9 writes: read it, then settle it by hand", unexpected)
if not kept:
    print('repoint: nothing to re-point')
    sys.exit(0)

with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
    json.dump({'source_drift': kept}, f)
cmd = [sys.executable, '-B', 'tools/research/repoint.py', '--reason',
       "UE9 landed: Becoming.ComparingCourses joined to the core as a leaf (the root module's import and doc, the "
       "checker's core list and scope, the package README rows EN and ZH), no landed module changed; 07 §2 (the home "
       "section of comparing-two-courses-on-what-they-admit after what keeping widening needs, eventual widening's "
       "reading pointed to the lag's decision, what keeping widening needs' passing laws stated with requirements never "
       "loosening), 07's Open item on the second-order direction narrowed, 02's Open item with the same premise, 08 §8 "
       "and 08's "
       "counts; the study; regions.json; the connectivity; eventual-widening's and what-keeping-widening-needs' next "
       "steps pointed to the new record, each with its history note; read before re-pointing",
       '--drift-json', f.name] + (['--apply'] if APPLY else [])
result = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
Path(f.name).unlink()
print(result.stdout[-4000:], result.stderr[-2000:])
summary = json.loads(result.stdout)
print('repoint:', summary['records'], 'records', 'written' if APPLY else '(dry run)')
sys.exit(result.returncode)
