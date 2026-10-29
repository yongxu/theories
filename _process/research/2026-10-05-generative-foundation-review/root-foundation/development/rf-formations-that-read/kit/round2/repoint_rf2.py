#!/usr/bin/env python3
"""RF round 2, first landing (round 1's repoint_rf.py): re-point the records drifting by RF's edits only.
The drift list of `research.py check` is filtered to the paths RF changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one RF's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The two new
modules are cited by no record but the new ones.
usage (from the checkout root, after integrate_rf2.py and reland_rf2.py):
  python3 -B <kit>/round2/repoint_rf2.py RECEIPT [--apply]"""
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
RIDS = {'a-reading-kept-by-its-update', 'what-a-course-chosen-through-its-model-does-not-test',
        'acts-alike-from-a-model-or-from-an-order', 'a-prediction-read-by-what-it-predicts'}
LEAN = [f'{PKG}/Becoming/ReadingLoop.lean', f'{PKG}/Becoming/ReflexivePrediction.lean']
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
    'theories/becoming/chapters/03-KNOWING.md': {'Knowing, learning and testing', 'knowing',
                                                 'knowing-learning-and-testing', '(before the first heading)',
                                                 "11. What a formation's acts show", '11-what-a-formations-acts-show',
                                                 'what-the-acts-show', '12. The reading loop', '12-the-reading-loop',
                                                 'the-reading-loop', 'Open', 'open', 'What this chapter does not show',
                                                 'does-not-show', 'what-this-chapter-does-not-show'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
    'theories/becoming/THE-THEORY-OF-BECOMING.md': {'3. Knowing, learning and testing', '3-knowing-learning-and-testing'},
    f'{RF}/development/rf-formations-that-read/PLAN.md': {'4. The new laws', '4-the-new-laws',
                                                          '12. Order, owners and what it serves',
                                                          '12-order-owners-and-what-it-serves',
                                                          '13. The review and what was taken',
                                                          '13-the-review-and-what-was-taken', 'Evidence', 'evidence'},
}
REASON = ("RF round 2's first landing: Becoming.ReadingLoop and Becoming.ReflexivePrediction joined to the core as leaves "
          "(the root module's imports and doc, the checker's core list and scope, the package README rows EN and ZH), no "
          "landed statement or proof changed; 03 §12 (the reading loop: the theorems of a-reading-kept-by-its-update, "
          "what-a-course-chosen-through-its-model-does-not-test, acts-alike-from-a-model-or-from-an-order and "
          "a-prediction-read-by-what-it-predicts with their readings), 03's bases sentence and Open; 08's counts and §8's "
          "known results; the overview's §3; AJ5's scope box in the alignment dossier; the study; regions.json; the "
          "connectivity; RF's plan (§4's opening and §4.6 on what round 2's design became, §12's order, §13's review "
          "and the evidence list), which round 1's records cite; read before re-pointing")


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
