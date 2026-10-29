#!/usr/bin/env python3
"""RF round 1 (WRT2's repoint_wrt2.py): re-point the records drifting by RF's edits only.
The drift list of `research.py check` is filtered to the paths RF changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one RF's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The three new
modules are cited by no record but the new ones.
usage (from the checkout root, after texts_rf.py and make_records_rf.py):
  python3 -B <kit>/repoint_rf.py RECEIPT [--apply]"""
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
RIDS = {'what-choices-show-of-an-order', 'what-readings-fix-of-the-unread', 'readers-reading-readers'}
LEAN = [f'{PKG}/Becoming/ShownOrder.lean', f'{PKG}/Becoming/Unread.lean', f'{PKG}/Becoming/Cascade.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/05-COLLECTIVES.md',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/THEOREM-CONNECTIVITY-APART.json']
MINE = set(LEAN) | set(OTHER)
# the sections RF's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'10. A break seen coming', '10-a-break-seen-coming', 'break-seen-coming',
                                                 'Open', 'open', 'What this chapter does not show', 'does-not-show',
                                                 'what-this-chapter-does-not-show'},
    'theories/becoming/chapters/05-COLLECTIVES.md': {'8. Pools', '8-pools', 'pools'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'6. What a selection reaches: alignment with no premise',
                                                      '6-what-a-selection-reaches-alignment-with-no-premise',
                                                      'alignment-without-premise', 'r-what-training-installs'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery'},
}
REASON = ("RF round 1 landed: Becoming.ShownOrder, Becoming.Unread and Becoming.Cascade joined to the core as leaves (the "
          "root module's imports and doc, the checker's core list and scope, the package README rows EN and ZH), no "
          "landed statement or proof changed; 03 §11 (what a formation's acts show: the theorems of "
          "what-choices-show-of-an-order and what-readings-fix-of-the-unread with their readings) and 03's Open; 05 §8 "
          "(the theorem of readers-reading-readers); one pointer sentence in 07 §6; 08's counts; the study; "
          "regions.json; the connectivity; read before re-pointing")


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
