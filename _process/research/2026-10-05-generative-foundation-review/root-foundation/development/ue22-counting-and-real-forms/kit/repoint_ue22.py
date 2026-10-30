#!/usr/bin/env python3
"""UE22 (UE21's repoint_ue21.py): re-point the records drifting by UE22's edits only, and rebind the record of expected
free energy to the two new periphery receipts.
The drift list of `research.py check` is filtered to the paths UE22 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE22's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs, and rebinds
expected-free-energy-and-its-terms's two Lean files to the receipts of the landing runs (bookkeeping: its text does not
change). The two records make_records_ue22.py writes are not re-pointed here.
usage (from the checkout root, after texts_ue22.py and make_records_ue22.py):
  python3 -B <kit>/repoint_ue22.py RECEIPT_FE RECEIPT_EFE [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
RECEIPT_FE, RECEIPT_EFE = sys.argv[1], sys.argv[2]
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
FE = f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RIDS = {'free-energy-bounds-surprisal', 'free-energy-bound-in-counts'}
EFE = 'expected-free-energy-and-its-terms'
LEAN = [f'{FE}/FreeEnergyReals.lean']
OTHER = [f'{FE}/check_free_energy_reals.py', 'theories/becoming/FREE-ENERGY-PRINCIPLE.md',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json', f'{RF}/BECOMING-RENEWAL-READING.md',
         f'{RF}/development/ue-unified-explanation/PLAN.md',
         f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE22's texts change, as research.py check names them, compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'6. 理: lumping', 'lumping', 'r-free-energy-bounds-surprisal',
                                                 'r-free-energy-bound-in-counts'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table', 'known-results'},
    'theories/becoming/FREE-ENERGY-PRINCIPLE.md': {'(before the first heading)', 'In brief', 'Claim by claim',
                                                   '1. The quantities', 'Standing'},
}
REASON = ("UE22 landed: FreeEnergyReals gained the section joining the core's counting form to the real form (its "
          "earlier declarations and proofs unchanged, the docstring's counting-form sentence replaced by the join), and "
          "its checker's scope; 03 §6's two free-energy home sections, 08 §8's bullet, the principle's page, the study, "
          "the UE plan and FEP-INTEGRATION, regions.json; read before re-pointing")
REBIND = ("UE22: the landing runs of check_free_energy_reals.py and check_expected_free_energy_reals.py on FreeEnergyReals "
          "with the join; ExpectedFreeEnergyReals unchanged, rechecked against it")


def run_repoint(args):
    result = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py'] + args + (['--apply'] if APPLY else []),
                            cwd=ROOT, capture_output=True, text=True)
    print(result.stdout[-4000:], result.stderr[-2000:])
    assert result.returncode == 0, result.returncode
    return json.loads(result.stdout)


# the rebinding first, so that the drift of the module it cites is settled by its receipt
for receipt, lean in [(f'{FE}/free-energy-reals-checks/{RECEIPT_FE}/verification.json', f'{FE}/FreeEnergyReals.lean'),
                      (f'{FE}/expected-free-energy-reals-checks/{RECEIPT_EFE}/verification.json',
                       f'{FE}/ExpectedFreeEnergyReals.lean')]:
    summary = run_repoint(['--reason', REBIND, '--ids', EFE, '--paths', lean, '--receipt', receipt, '--lean', lean])
    print('rebind:', lean.rsplit('/', 1)[1], '->', receipt.rsplit('/', 2)[1], 'written' if APPLY else '(dry run)')

out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
kept = [x for x in drift if x['path'] in MINE and x['id'] not in RIDS]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
assert not [x for x in drift if x['id'] in RIDS], 'a record make_records_ue22.py wrote drifts: write it after the texts'

unexpected = []
for x in kept:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if x['path'] in LEAN and x['id'] == EFE:
        continue
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections UE22 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
