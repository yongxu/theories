#!/usr/bin/env python3
"""UE25's landing (repoint_rr.py's pattern): re-point the records drifting by UE25's edits only.
The drift list of `research.py check` is filtered to the paths UE25 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE25's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
module is cited by no record but the new one.
usage (from the checkout root, after integrate_ue25.py, texts_ue25.py and reland_ue25.py):
  python3 -B <kit>/repoint_ue25.py RECEIPT [--apply]"""
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
RIDS = {'a-code-held-as-counts'}
LEAN = [f'{PKG}/Becoming/CountedCodes.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/05-COLLECTIVES.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/FREE-ENERGY-PRINCIPLE.md', 'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md', f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md',
         f'{RF}/development/ue1-fep-bridge/THIRD-PART-SEARCH.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE25's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/05-COLLECTIVES.md': {'(before the first heading)', 'Joint activity and selection',
                                                     'joint-activity-and-selection',
                                                     '9. Shared codes', '9-shared-codes'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
    'theories/becoming/FREE-ENERGY-PRINCIPLE.md': {
        'In brief', 'in-brief', 'Claim by claim', 'claim-by-claim',
        '3. What the theory forbids that the literature claims', '3-what-the-theory-forbids-that-the-literature-claims',
        '5. What the principle states that the theory cannot yet', '5-what-the-principle-states-that-the-theory-cannot-yet',
        'Standing', 'standing'},
    f'{RF}/development/ue-unified-explanation/PLAN.md': {'6. Owners', '6-owners'},
    f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md': {'3. The items', '3-the-items', '4. Done when',
                                                                     '4-done-when'},
    f'{RF}/development/ue1-fep-bridge/THIRD-PART-SEARCH.md': {'Correction after UE25 (31 October 2026)',
                                                               'correction-after-ue25-31-october-2026'},
}
REASON = ("UE25: Becoming.CountedCodes joined to the core as a leaf importing SharedCodes and FreeEnergyCounting (the "
          "root module's import and bullet, the checker's core list and scope, the package README rows EN and ZH); "
          "05's thesis and §9 (a code held as counts, after imposing a code); 08's counts and §8's known results; the "
          "principle's page (In brief, the claim table, §3's fifth entry, §5 and Standing); the study; the UE plan, "
          "FEP-INTEGRATION's item 10 and a correction section appended to UE1's search; regions.json; the "
          "connectivity; read before re-pointing")


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
assert not [x for x in drift if x['id'] in RIDS], 'a new record drifts: write it after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than UE25\'s cites the module'

unexpected = []
for x in kept:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if x['path'] in EXPECTED and (not sections or not sections <= allowed):
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections UE25 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
