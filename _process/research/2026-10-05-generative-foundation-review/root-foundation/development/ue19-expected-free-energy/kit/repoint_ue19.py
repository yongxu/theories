#!/usr/bin/env python3
"""UE19 (UE18's repoint_ue18.py): re-point the records drifting by UE19's edits only.
The drift list of `research.py check` is filtered to the paths UE19 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE19's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
modules are cited by no record but the two new ones.
usage (from the checkout root, after texts_ue19.py and make_records_ue19.py):
  python3 -B <kit>/repoint_ue19.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
FE = f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RIDS = {'expected-free-energy-and-its-terms', 'what-seeking-cannot-separate'}
LEAN = [f'{PKG}/Becoming/LumpedSeeking.lean', f'{FE}/ExpectedFreeEnergyReals.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json', f'{FE}/check_expected_free_energy_reals.py',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md',
         f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE19's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'(before the first heading)', 'Knowing, learning and testing', 'knowing',
                                                 '6. 理: lumping', 'lumping', 'r-conditioning-by-restriction',
                                                 'r-free-energy-bounds-surprisal'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table', 'known-results'},
}
REASON = ("UE19 landed: Becoming.LumpedSeeking joined to the core as a leaf (the root module's import and doc, the "
          "checker's core list and scope, the package README rows EN and ZH) and ExpectedFreeEnergyReals to the "
          "periphery with its checker, no landed statement or proof changed; 03's thesis and 03 §6 "
          "(expected-free-energy-and-its-terms and what-seeking-cannot-separate after free energy, with a labelled "
          "reading); 08 §8 and 08's counts; the study; the UE plan and FEP-INTEGRATION; regions.json; the connectivity; "
          "read before re-pointing")


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
assert not [x for x in drift if x['id'] in RIDS], 'a new record drifts: write them after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than the new ones cites a new module'

# UE18's two records, written earlier in the same landing (with UE19), bound 03 and the study before UE19's texts; with
# no committed version to compare, their changed sections read '(reviewed version not in history)'
LANDED_WITH = {'the-markov-blanket-as-a-coupling-structure', 'what-the-existence-claim-forbids'}
SAME_LANDING = {'theories/becoming/chapters/03-KNOWING.md', f'{RF}/BECOMING-RENEWAL-READING.md'}
unexpected = []
for x in kept:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if x['id'] in LANDED_WITH and x['path'] in SAME_LANDING and sections == {'(reviewed version not in history)'}:
        continue
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections UE19 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
