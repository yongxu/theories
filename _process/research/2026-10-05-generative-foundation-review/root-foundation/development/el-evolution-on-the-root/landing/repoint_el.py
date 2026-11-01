#!/usr/bin/env python3
"""EL's landing (repoint_bd3.py's pattern): re-point the records drifting by EL's edits only.

The drift list of `research.py check` is filtered to the paths EL changes, so another session's drift stays with its
owner and is printed for it. Every drifting (record, path) pair is listed with its changed sections first, and each
changed section must be one EL's texts write (EXPECTED); a pair outside them stops the script, to be read and settled
by hand. EL's own six records may drift on their own paths. No existing Lean file changes, so no proof binding is
rebound: the new records' bindings to the six leaves are written by reland_el.py.
usage (from the checkout root, after reland_el.py): python3 -B <kit>/repoint_el.py RECEIPT [--apply]"""
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
ELD = f'{RF}/development/el-evolution-on-the-root'
LEAN = [f'{PKG}/Becoming/{m}.lean' for m in ('LineDegeneration', 'SelectionShift', 'LineageRegions',
                                             'LineageRegimes', 'WindowedWaiting', 'PairSelection')]
CH = 'theories/becoming/chapters'
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         f'{CH}/02-MAP.md', f'{CH}/04-LIFE.md', f'{CH}/05-COLLECTIVES.md', f'{CH}/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{ELD}/NOTE.md', f'{ELD}/WS.md']
MINE = set(LEAN) | set(OTHER)
OWN = {'degeneration-from-a-horizon', 'the-selection-term-and-a-lineages-fate', 'ending-laws-as-regimes-on-a-lineage',
       'a-pair-tolerates-only-within-a-window', 'offspring-read-from-giving-that-waits',
       'what-giving-that-waits-draws-on'}
# the sections EL's texts change, as research.py check names them (a heading at either level, or an anchor a record
# cites), compared without their leading #s; set after reading the dry run against the home sections' diff
EXPECTED = {
    f'{CH}/02-MAP.md': {'1. The map on branches', '1-the-map-on-branches', 'branches'},
    f'{CH}/04-LIFE.md': {'3. Descent', '3-descent', 'descent', '4. Reproduction', '4-reproduction', 'reproduction'},
    f'{CH}/05-COLLECTIVES.md': {'5. Giving that waits on giving', '5-giving-that-waits-on-giving', 'giving-waits',
                                 '6. What a rise draws from beyond', '6-what-a-rise-draws-from-beyond',
                                 'rise-from-beyond', '1. Joint consumption and joint excess',
                                 '1-joint-consumption-and-joint-excess', 'joint-consumption'},
    f'{CH}/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                           'pure-core-and-periphery'},
    f'{ELD}/NOTE.md': {'State of the Lean', 'state-of-the-lean', '5. EL3: the constructive degeneration law',
                       '9. Coordination, order and the release gate', '11. Result block'},
    f'{ELD}/WS.md': {'8. Placement', '10. Result block'},
}
REASON = ("EL: six core leaves joined to the core, no existing module changed (the root module's imports and bullets, "
          "the checker's core list and scope, the package README rows EN and ZH); the six new records' home sections "
          "in 02 §1, 04 §3–§4 and 05 §5–§6; 08's counts; regions.json; the study; the connectivity; the design "
          "texts' State of the Lean and landing marks; read before re-pointing")


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
kept = [x for x in drift if x['path'] in MINE]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
bad_lean = [x for x in kept if x['path'] in LEAN and x['id'] not in OWN]
assert not bad_lean, ('a record outside EL cites a new leaf', bad_lean)

unexpected = []
for x in kept:
    if x['id'] in OWN or x['path'] in LEAN or x['path'] not in EXPECTED:
        continue
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if not sections or not sections <= EXPECTED[x['path']]:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections EL writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
