#!/usr/bin/env python3
"""UE26's landing (repoint_ue25.py's pattern): re-point the records drifting by UE26's edits only.
The drift list of `research.py check` is filtered to the paths UE26 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE26's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
modules are cited by no record but the new ones.
usage (from the checkout root, after integrate_ue26.py, texts_ue26.py and reland_ue26.py):
  python3 -B <kit>/repoint_ue26.py CORE [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[2:]
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG, FE = f'{LEANR}/becoming', f'{LEANR}/free-energy'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RIDS = {'the-blanket-at-a-steady-state', 'the-blanket-in-a-linear-steady-state'}
LEAN = [f'{PKG}/Becoming/BlanketWeights.lean', f'{FE}/LinearBlankets.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json', f'{FE}/check_linear_blankets.py', f'{FE}/linear-blankets-verification.json',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/FREE-ENERGY-PRINCIPLE.md', 'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md', f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE26's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'1. A selection reaches what couples in',
                                                 '1-a-selection-reaches-what-couples-in', 'selection',
                                                 'r-the-markov-blanket-as-a-coupling-structure'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
    'theories/becoming/FREE-ENERGY-PRINCIPLE.md': {
        'In brief', 'in-brief', 'Claim by claim', 'claim-by-claim', '1. The quantities', '1-the-quantities',
        '2. Where the two agree', '2-where-the-two-agree',
        '5. What the principle states that the theory cannot yet', '5-what-the-principle-states-that-the-theory-cannot-yet',
        'Standing', 'standing'},
    f'{RF}/development/ue-unified-explanation/PLAN.md': {'6. Owners', '6-owners'},
    f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md': {'3. The items', '3-the-items'},
}
REASON = ("UE26: Becoming.BlanketWeights joined to the core as a leaf importing Blanket and Flow (the root module's "
          "import and bullet, the checker's core list and scope, the package README rows EN and ZH), the periphery "
          "module LinearBlankets and its checker; 03 §1 (the blanket at a steady state and its linear case, after the "
          "blanket); 08's counts and §8's known results; the principle's page (In brief, the claim table, §1, §2, §5 "
          "and Standing); the study; the UE plan and FEP-INTEGRATION's item 11; regions.json; the connectivity; read "
          "before re-pointing")
# Each record re-pointed is read against the new text before the landing, and the reading is given here; a record
# not read stops the script, to be read and added.
READ = {
    'a-code-held-as-counts': (
        "read against the new page: its five statements of the literature that fail and the code law's entries are "
        "unchanged; UE26 adds the blanket's statistical form beside them (In brief, the claim table, §1, §2, §5 and "
        "Standing) and a fourth further law where three stood, so nothing the record says changed"),
}


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
assert not [x for x in kept if x['path'] in LEAN], 'a record other than UE26\'s cites a new module'

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
assert not unexpected, ("drift outside the sections UE26 writes: read it, then settle it by hand", unexpected)
unread = sorted({x['id'] for x in kept} - set(READ))
assert not unread, ("records not yet read against the new text: read each, then add its reading to READ", unread)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    reason = REASON + '; ' + '; '.join(f'{i}: {READ[i]}' for i in sorted({x['id'] for x in kept}))
    summary = run_repoint(['--reason', reason, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
