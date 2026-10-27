#!/usr/bin/env python3
"""UE10 (UE9's repoint_ue9.py: UE10 is a leaf and changes no landed module): re-point the records drifting by UE10's
edits only. The drift list of `research.py check` is filtered to the paths UE10 changes, so another session's drift
stays with its owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed
with its changed sections, and each changed section must be one UE10's texts write (EXPECTED below); a pair outside
them, or any drift on a Lean file, stops the script, to be read and settled by hand. Then tools/research/repoint.py
re-points exactly the kept pairs; no proof binding is rebound, since no record but the new one cites the new module.
usage (from the checkout root, after texts_ue10.py and make_records_ue10.py):
  python3 -B <kit>/repoint_ue10.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RID = 'what-a-course-keeps-reachable'
LEAN = [f'{PKG}/Becoming/ReachableRanges.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE10's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'2. The order with no premise', 'Open', 'r-eventual-widening',
                                                     'r-comparing-two-courses-on-what-they-admit'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table'},
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
assert not unexpected, ("drift outside the sections UE10 writes: read it, then settle it by hand", unexpected)
if not kept:
    print('repoint: nothing to re-point')
    sys.exit(0)

with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
    json.dump({'source_drift': kept}, f)
cmd = [sys.executable, '-B', 'tools/research/repoint.py', '--reason',
       "UE10 landed: Becoming.ReachableRanges joined to the core as a leaf (the root module's import and doc, the "
       "checker's core list and scope, the package README rows EN and ZH), no landed module changed; 07 §2 (the home "
       "section of what-a-course-keeps-reachable after comparing two courses on what they admit, eventual widening's "
       "and comparing two courses' readings pointed to it), 07's Open item on the second-order direction narrowed, 08 "
       "§8 and 08's counts; the study; the UE plan; regions.json; the connectivity; the next steps of "
       "comparing-two-courses-on-what-they-admit, eventual-widening and what-keeping-widening-needs pointed to the new "
       "record, each with its history note; read before re-pointing",
       '--drift-json', f.name] + (['--apply'] if APPLY else [])
result = subprocess.run(cmd, cwd=ROOT, capture_output=True, text=True)
Path(f.name).unlink()
print(result.stdout[-4000:], result.stderr[-2000:])
summary = json.loads(result.stdout)
print('repoint:', summary['records'], 'records', 'written' if APPLY else '(dry run)')
sys.exit(result.returncode)
