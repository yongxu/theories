#!/usr/bin/env python3
"""BD3's landing (repoint_bd2.py's pattern): re-point the records drifting by BD3's edits only.

The drift list of `research.py check` is filtered to the paths BD3 changes, so another session's drift stays with its
owner and is printed for it. Every drifting (record, path) pair is listed with its changed sections first, and each
changed section must be one BD3's texts write (EXPECTED); a pair outside them stops the script, to be read and settled
by hand. BD3's own record may drift on its own paths. No existing Lean file changes, so no proof binding is rebound:
the record's binding to the new leaf is written by reland_bd3.py.
usage (from the checkout root, after reland_bd3.py): python3 -B <kit>/repoint_bd3.py RECEIPT [--apply]"""
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
LEAN = [f'{PKG}/Becoming/BalanceRegions.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/bd-boundaries/REVIEW-BD3.md']
MINE = set(LEAN) | set(OTHER)
OWN = {'balance-from-conservation-along-a-relation'}
# the sections BD3's texts change, as research.py check names them (a heading at either level, or an anchor a record
# cites), compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/01-ROOT.md': {'8.4 Balance from physics', '84-balance-from-physics',
                                              'balance-from-physics', 'r-balance-from-conservation-along-a-relation',
                                              '8. The models', '8-the-models', 'models'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery'},
}
REASON = ("BD3: Becoming.BalanceRegions joined to the core as a leaf, no existing module changed (the root module's "
          "import and bullet, the checker's core list and scope, the package README rows EN and ZH); 01 §8.4 (the "
          "theorem paragraph's sentence reading balance on «不出»); 08's counts; regions.json; the study; the "
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
kept = [x for x in drift if x['path'] in MINE]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE]
bad_lean = [x for x in kept if x['path'] in LEAN and x['id'] not in OWN]
assert not bad_lean, ('a record outside BD3 cites the new leaf', bad_lean)

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
assert not unexpected, ("drift outside the sections BD3 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
