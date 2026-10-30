#!/usr/bin/env python3
"""RF round 2, RF7's landing (repoint_rf61.py's pattern): re-point the records drifting by RF's edits only.
The drift list of `research.py check` is filtered to the paths RF changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one RF's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
module is cited by no record but the new one.
usage (from the checkout root, after integrate_rf7.py and reland_rf7.py):
  python3 -B <kit>/round2/repoint_rf7.py RECEIPT [--apply]"""
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
RIDS = {'when-complying-when-read-is-best'}
LEAN = [f'{PKG}/Becoming/ReadStages.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/05-COLLECTIVES.md',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         'theories/becoming/THE-THEORY-OF-BECOMING.md',
         'theories/becoming/review/ALIGNMENT.md',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/rf-formations-that-read/PLAN.md']
MINE = set(LEAN) | set(OTHER)
# the sections RF's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {"11. What a formation's acts show", '11-what-a-formations-acts-show',
                                                 'what-the-acts-show', 'r-what-readings-fix-of-the-unread', 'Open',
                                                 'open'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'9. Objections and verdicts', '9-objections-and-verdicts',
                                                     'objections'},
    'theories/becoming/THE-THEORY-OF-BECOMING.md': {'3. Knowing, learning and testing', '3-knowing-learning-and-testing'},
    'theories/becoming/review/ALIGNMENT.md': {'Review dossier A: alignment', 'review-dossier-a-alignment'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
    f'{RF}/development/rf-formations-that-read/PLAN.md': {'4. The new laws', '4-the-new-laws',
                                                          '5. A shared obstruction pattern (readings, on existing laws)',
                                                          '5-a-shared-obstruction-pattern-readings-on-existing-laws',
                                                          '8. The literature: contained, restated or owed',
                                                          '8-the-literature-contained-restated-or-owed',
                                                          '12. Order, owners and what it serves',
                                                          '12-order-owners-and-what-it-serves',
                                                          '13. The review and what was taken',
                                                          '13-the-review-and-what-was-taken', 'Evidence', 'evidence'},
}
REASON = ("RF round 2's RF7: Becoming.ReadStages joined to the core as a leaf (the root module's import and doc, the "
          "checker's core list and scope, the package README rows EN and ZH, Unread's root bullet no longer a leaf), no "
          "landed statement or proof changed; 03 §11 (its opening, the theorem of when-complying-when-read-is-best with "
          "its reading) and 03's Open; 07 §9's row on deception; 08's counts and §8's known results; the overview's §3 "
          "paragraph on what acts show; the alignment dossier's scope box and its account of how it was made; RF's "
          "plan (§4's intro, §4.2's analogy, §4.4's and §4.5's headings, §4.6's intro and RF7 bullet, §5's table, §8's "
          "literature row, §12, §13's reviews and the Evidence list), which RF's records cite; the study; regions.json; the connectivity; read before re-pointing")


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
assert not [x for x in kept if x['path'] in LEAN], 'a record other than the new ones cites a new module'

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
assert not unexpected, ("drift outside the sections RF writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
