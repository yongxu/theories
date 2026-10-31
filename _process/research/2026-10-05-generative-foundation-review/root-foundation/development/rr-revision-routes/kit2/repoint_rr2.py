"""RR2's landing (repoint_rr.py's pattern): re-point the records drifting by RR2's edits only.
The drift list of `research.py check` is filtered to the paths RR2 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one RR2's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
module is cited by no record but the new one, and HeldForReading by no record but RF-M.2's and the new one, which
make_records_rr2.py writes; RR's record is amended there too.
usage (from the checkout root, after integrate_rr2.py and reland_rr2.py):
  python3 -B <kit2>/repoint_rr2.py RECEIPT [--apply]"""
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
RIDS = {'when-holding-for-a-reading-stands-above-a-route', 'what-holding-for-a-reading-is-worth',
        'when-no-route-stands-above-a-revision'}
LEAN = [f'{PKG}/Becoming/RevisionPlans.lean', f'{PKG}/Becoming/HeldForReading.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/07-SIGNIFICANCE.md',
         'theories/becoming/chapters/08-METHOD.md', 'theories/becoming/results/data/regions.json',
         'theories/becoming/review/ALIGNMENT.md',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/rr-revision-routes/NOTE.md', f'{RF}/development/rr-revision-routes/REVIEW.md']
MINE = set(LEAN) | set(OTHER)
# the sections RR2's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'12. The reading loop', '12-the-reading-loop', 'the-reading-loop',
                                                 'r-what-holding-for-a-reading-is-worth'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'7. The conditional direction', '7-the-conditional-direction',
                                                     'direction', 'executable', 'r-when-no-route-stands-above-a-revision'},
    'theories/becoming/review/ALIGNMENT.md': {'Review dossier A: alignment', 'review-dossier-a-alignment'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
}
REASON = ("RR2: Becoming.RevisionPlans joined to the core below Becoming.HeldForReading, which takes its two balances "
          "from RevisionPlans.balance with every statement and name kept (the root module's import and bullets, the "
          "checker's core list and scope, the package README rows EN and ZH); 07 §7 (the section after RR's, RR's "
          "reading pointed to it); 03 §12 (holding as a plan of that order); 08's counts and §8's known results; the "
          "alignment dossier's corrigibility bullet and its account of how it was made; RR's note §10 and review; the "
          "study; regions.json; the connectivity; read before re-pointing")


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
assert not [x for x in kept if x['path'] in LEAN], 'a record other than RR2\'s and RF-M.2\'s cites the modules'

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
assert not unexpected, ("drift outside the sections RR writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
