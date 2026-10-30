#!/usr/bin/env python3
"""UE24 (UE23's repoint_ue23.py): re-point the records drifting by UE24's edits only.
The drift list of `research.py check` is filtered to the paths UE24 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE24's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The two records
make_records_ue24.py writes (identical-cells-under-noise, new, and identical-cells-under-a-descent-treating-them-alike,
whose references to 05 and the study it refreshes) are not re-pointed here.
usage (from the checkout root, after texts_ue24.py and make_records_ue24.py):
  python3 -B <kit>/repoint_ue24.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
FE = f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RIDS = {'identical-cells-under-noise', 'identical-cells-under-a-descent-treating-them-alike'}
MINE = {f'{FE}/CellsUnderNoise.lean', f'{FE}/check_cells_under_noise.py',
        'theories/becoming/FREE-ENERGY-PRINCIPLE.md', 'theories/becoming/chapters/05-COLLECTIVES.md',
        'theories/becoming/chapters/08-METHOD.md', 'theories/becoming/results/data/regions.json',
        f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/development/ue-unified-explanation/PLAN.md',
        f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md'}
# the sections UE24's texts change, as research.py check names them, compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/05-COLLECTIVES.md': {'(before the first heading)', '9. Shared codes',
                                                     'r-identical-cells-under-a-descent-treating-them-alike',
                                                     'r-identical-cells-under-noise'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table', 'known-results'},
    'theories/becoming/FREE-ENERGY-PRINCIPLE.md': {'In brief', 'Claim by claim',
                                                   '3. What the theory forbids that the literature claims',
                                                   '5. What the principle states that the theory cannot yet',
                                                   'Standing'},
}
REASON = ("UE24 landed: the new periphery module CellsUnderNoise and its checker; 05's thesis and the new home section "
          "of identical-cells-under-noise in 05 §9, 08 §8's bullet, the principle's page, the study, the UE plan and "
          "FEP-INTEGRATION, regions.json; read before re-pointing")


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
kept = [x for x in drift if x['path'] in MINE and x['id'] not in RIDS]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
assert not [x for x in drift if x['id'] in RIDS], 'a record make_records_ue24.py wrote drifts: write it after the texts'

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
assert not unexpected, ("drift outside the sections UE24 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
