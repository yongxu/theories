#!/usr/bin/env python3
"""UE12 (UE11's repoint_ue11.py, without its SelectionPool part): re-point the records drifting by UE12's edits only.
The drift list of `research.py check` is filtered to the paths UE12 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE12's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new module
is cited by no record but the new one.
usage (from the checkout root, after texts_ue12.py and make_records_ue12.py):
  python3 -B <kit>/repoint_ue12.py RECEIPT [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID = sys.argv[1]
APPLY = '--apply' in sys.argv[2:]
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RID = 'tasks-and-what-performs-them'
LEAN = [f'{PKG}/Becoming/Tasks.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE12's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'2. The order with no premise', 'r-where-the-possible-grows'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table'},
}
REASON = ("UE12 landed: Becoming.Tasks joined to the core as a leaf (the root module's import and doc, the checker's "
          "core list and scope, the package README rows EN and ZH), no landed statement or proof changed; 07 §2 (the "
          "home section of tasks-and-what-performs-them after where the possible grows), 08 §8 and 08's counts; the "
          "study; the UE plan; regions.json; the connectivity; what-a-course-keeps-reachable and "
          "where-the-possible-grows related to the new record, each with its history note; read before re-pointing")


def run_repoint(args):
    result = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py'] + args + (['--apply'] if APPLY else []),
                            cwd=ROOT, capture_output=True, text=True)
    print(result.stdout[-4000:], result.stderr[-2000:])
    assert result.returncode == 0, result.returncode
    return json.loads(result.stdout)


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
assert not unexpected, ("drift outside the sections UE12 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
