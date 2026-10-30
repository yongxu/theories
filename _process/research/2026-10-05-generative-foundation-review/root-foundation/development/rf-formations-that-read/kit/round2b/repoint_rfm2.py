#!/usr/bin/env python3
"""RF round 2, second part, RF-M.2's landing (repoint_rf7.py's pattern): re-point the records drifting by RF's edits only.
The drift list of `research.py check` is filtered to the paths RF changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one RF's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
module is cited by no record but the new one.
usage (from the checkout root, after integrate_rfm2.py and reland_rfm2.py):
  python3 -B <kit>/round2b/repoint_rfm2.py RECEIPT [--apply]
For the landing of RF-M.2's design, reviews and kit without its Lean, `docs` in place of RECEIPT re-points only the
drift by RF's plan, whose rewritten sections are its own:
  python3 -B <kit>/round2b/repoint_rfm2.py docs [--apply]"""
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
RIDS = {'what-holding-for-a-reading-is-worth'}
LEAN = [f'{PKG}/Becoming/HeldForReading.lean']
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
DOCS = RECEIPT_ID == 'docs'
if DOCS:
    LEAN, MINE = [], {f'{RF}/development/rf-formations-that-read/PLAN.md'}
# the sections RF's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'12. The reading loop', '12-the-reading-loop', 'the-reading-loop',
                                                 'r-acts-alike-from-a-model-or-from-an-order', 'Open', 'open'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'7. The conditional direction', '7-the-conditional-direction',
                                                     'direction', 'executable'},
    'theories/becoming/THE-THEORY-OF-BECOMING.md': {'3. Knowing, learning and testing', '3-knowing-learning-and-testing'},
    'theories/becoming/review/ALIGNMENT.md': {'Review dossier A: alignment', 'review-dossier-a-alignment'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
    f'{RF}/development/rf-formations-that-read/PLAN.md': {
        '4. The new laws', '4-the-new-laws',
        '4.7 Round 2, second part: an act held for a reading, and the order as state',
        '47-round-2-second-part-an-act-held-for-a-reading-and-the-order-as-state',
        '4.7 Round 2, second part: an act held for a reading, and the valuation as state',
        '47-round-2-second-part-an-act-held-for-a-reading-and-the-valuation-as-state',
        '8. The literature: contained, restated or owed', '8-the-literature-contained-restated-or-owed',
        '12. Order, owners and what it serves', '12-order-owners-and-what-it-serves',
        '13. The review and what was taken', '13-the-review-and-what-was-taken', 'Evidence', 'evidence'},
}
REASON = ("RF round 2's RF-M.2: Becoming.HeldForReading joined to the core as a leaf (the root module's import and doc, "
          "the checker's core list and scope, the package README rows EN and ZH, ReadingLoop's root bullet no longer a "
          "leaf and ShownOrder's naming both its importers), no landed statement or proof changed; 03 §12 (its opening, the theorem of "
          "what-holding-for-a-reading-is-worth with its reading, a pointer in the acts-alike reading) and 03's Open; "
          "07 §7's paragraph on executable change; 08's counts and §8's known results; the overview's paragraph after "
          "the reading loop's; the alignment dossier's scope box and its account of how it was made; RF's plan (§4.7, "
          "§8's literature row, §12, §13's reviews and the Evidence list), which RF's records cite; the study; "
          "regions.json; the connectivity; read before re-pointing")
if DOCS:
    REASON = ("RF round 2's RF-M.2, its design, reviews and kit landed without its Lean: RF's plan gained §4.7 (the "
              "second part's design, and RF-M.2's module built in the kit, not yet joined), §8's literature row for "
              "RF-M.2, §9's eighth proposal, §12's order, §13's review of the design and the Evidence list's kit "
              "entry; no statement, premise or declaration of the records citing it changed; read before re-pointing")


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
