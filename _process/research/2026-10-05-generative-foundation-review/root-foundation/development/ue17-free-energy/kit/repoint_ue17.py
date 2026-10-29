#!/usr/bin/env python3
"""UE17 (UE16's repoint_ue16.py): re-point the records drifting by UE17's edits only: 03's thesis and §6 (the new
anchor after conditioning's reading), 08 §8, and UE2's study files, whose links to the superseded periphery draft the
move to history rewrote. Each drifting pair's changed sections must be ones UE17 writes (EXPECTED); a pair outside them
stops the script. The periphery module is cited by no record but the new one.
usage (from the checkout root, after texts_ue17.py and make_records_ue17.py):
  python3 -B <kit>/repoint_ue17.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
UE2 = f'{RF}/development/ue2-conditional-weights'
RIDS = {'free-energy-bounds-surprisal'}
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'(before the first heading)', '6. 理: lumping', 'lumping',
                                                 'r-the-split-that-makes-sense'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table', 'known-results'},
    f'{UE2}/NOTE.md': {'(before the first heading)', '## 3. The periphery draft', '3. The periphery draft'},
    f'{UE2}/REVIEW-UE2.md': None,
    f'{UE2}/LANDING.md': None,
}
REASON = ("UE17 landed: the periphery module FreeEnergyReals with its checker, no core file changed; 03's thesis and "
          "03 §6 (free-energy-bounds-surprisal after conditioning's reading, with a labelled reading); 08 §8's bullet; "
          "UE2's periphery draft moved to history (research.py move), its study files' links rewritten; the study; the "
          "UE plan and FEP-INTEGRATION; regions.json; read before re-pointing")


def run_repoint(args):
    result = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py'] + args + (['--apply'] if APPLY else []),
                            cwd=ROOT, capture_output=True, text=True)
    print(result.stdout[-3000:], result.stderr[-2000:])
    assert result.returncode == 0, result.returncode
    return json.loads(result.stdout)


out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
kept = [x for x in drift if x['path'] in EXPECTED and x['id'] not in RIDS]
left = [(x['id'], x['path']) for x in drift if x['path'] not in EXPECTED]
assert not [x for x in drift if x['id'] in RIDS], 'the new record drifts: write it after the texts'
unexpected = []
for x in kept:
    sections = {s.lstrip('#').strip() for s in (x.get('changed_sections') or [])}
    allowed = EXPECTED[x['path']]
    allowed = {a.lstrip('#').strip() for a in allowed} if allowed is not None else None
    if allowed is not None and (not sections or not sections <= allowed):
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records; left to their owners: {left}')
assert not unexpected, ('drift outside the sections UE17 writes: read it, then settle it by hand', unexpected)
if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint:', summary['records'], 'records', 'written' if APPLY else '(dry run)')
