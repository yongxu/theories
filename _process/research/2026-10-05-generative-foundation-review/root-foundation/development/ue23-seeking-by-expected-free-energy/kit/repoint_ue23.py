#!/usr/bin/env python3
"""UE23 (UE22's repoint_ue22.py): re-point the records drifting by UE23's edits only.
The drift list of `research.py check` is filtered to the paths UE23 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE23's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The two records
make_records_ue23.py writes (expected-free-energy-and-its-terms, whose binding it moves to the landing receipt, and
what-seeking-cannot-separate) are not re-pointed here.
usage (from the checkout root, after texts_ue23.py and make_records_ue23.py):
  python3 -B <kit>/repoint_ue23.py [--apply]"""
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
RIDS = {'expected-free-energy-and-its-terms', 'what-seeking-cannot-separate'}
MINE = {f'{FE}/ExpectedFreeEnergyReals.lean', f'{FE}/check_expected_free_energy_reals.py',
        'theories/becoming/FREE-ENERGY-PRINCIPLE.md', 'theories/becoming/chapters/03-KNOWING.md',
        'theories/becoming/chapters/08-METHOD.md', 'theories/becoming/results/data/regions.json',
        f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/development/ue-unified-explanation/PLAN.md',
        f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md'}
# the sections UE23's texts change, as research.py check names them, compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'6. 理: lumping', 'lumping', 'r-expected-free-energy-and-its-terms',
                                                 'r-what-seeking-cannot-separate'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table', 'known-results'},
    'theories/becoming/FREE-ENERGY-PRINCIPLE.md': {'(before the first heading)', 'In brief', 'Claim by claim',
                                                   '1. The quantities', '3. What the theory forbids that the literature claims',
                                                   '5. What the principle states that the theory cannot yet',
                                                   'Standing'},
}
REASON = ("UE23 landed: ExpectedFreeEnergyReals gained the section joining seeking by expected free energy to the "
          "core's seeking (its earlier declarations and proofs unchanged), and its checker's scope; 03 §6's two home "
          "sections on expected free energy and seeking, 08 §8's bullet, the principle's page, the study, the UE plan and "
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
assert not [x for x in drift if x['id'] in RIDS], 'a record make_records_ue23.py wrote drifts: write it after the texts'

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
assert not unexpected, ("drift outside the sections UE23 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
