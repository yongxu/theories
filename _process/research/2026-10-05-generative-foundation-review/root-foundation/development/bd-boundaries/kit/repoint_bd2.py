#!/usr/bin/env python3
"""BD2's landing (repoint_rr2.py's pattern): re-point the records drifting by BD2's edits only, then rebind the proof
bindings of the Lean files BD2 changes to its receipt.

The drift list of `research.py check` is filtered to the paths BD2 changes, so another session's drift stays with its
owner and is printed for it. Every drifting (record, path) pair is listed with its changed sections first, and each
changed section must be one BD2's texts write (EXPECTED); a pair outside them stops the script, to be read and settled
by hand. BD2's own three records may drift on its own paths (they were written before the review's edits). Then
tools/research/repoint.py re-points exactly the kept pairs, and rebinds the GrammarPath-bound records' proof bindings
(their statements unchanged) to the receipt.
usage (from the checkout root, after reland_bd2.py): python3 -B <kit>/repoint_bd2.py RECEIPT [--apply]"""
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
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
LEAN = [f'{PKG}/Becoming/GrammarCrossing.lean', f'{PKG}/Becoming/ConveyanceBoundaries.lean',
        f'{PKG}/Becoming/GrammarPath.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json', 'GLOSSARY.md',
         'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/chapters/04-LIFE.md',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/bd-boundaries/NOTE.md', f'{RF}/development/bd-boundaries/REVIEW.md',
         'sources/15-codex-theory-conversations/2026-10-31-close-the-formal-gap.md']
MINE = set(LEAN) | set(OTHER)
OWN = {'not-going-out-of-a-region', 'conveyance-crosses-the-boundary', 'what-a-line-holds-and-a-regularity-takes-in'}
BOUND = OWN | {'constancy-read-at-a-members-class', 'what-leaves-a-class-follows-its-line'}
# the sections BD2's texts change, as research.py check names them (a heading, or an anchor a record cites), compared
# without their leading #s
EXPECTED = {
    'theories/becoming/chapters/01-ROOT.md': {'9.9 Wholes, parts and closures', '99-wholes-parts-and-closures',
                                              'wholes-and-closures', 'boundaries', 'r-not-going-out-of-a-region',
                                              '9. Ways of reading the root', '9-ways-of-reading-the-root'},
    'theories/becoming/chapters/04-LIFE.md': {'1. Life as a condition of life', '1-life-as-condition-of-life',
                                              '1-life-as-a-condition-of-life', 'life-as-condition',
                                              'r-conveyance-crosses-the-boundary'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'4.6 The future without the step: one path',
                                                     '46-the-future-without-the-step-one-path', 'future-path',
                                                     'r-what-a-line-holds-and-a-regularity-takes-in'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery'},
}
REASON = ("BD2: Becoming.GrammarCrossing and Becoming.ConveyanceBoundaries joined to the core, «所经必同» proved from "
          "the step going out with its statement unchanged (the root module's imports and bullets, the checker's core "
          "list and scope, the package README rows EN and ZH, the Chinese Boundaries row and the checker's Boundaries "
          "scope brought to the continuation condition); 01 §9.9 (the theorem paragraph, BD's reading citing it); "
          "04 §1 (the sixth and seventh laws' sentences); 07 §4.6 (the line record's home sentence); 08's counts; the glossary's "
          "boundary row; regions.json; the study and BD's note §6 and review; the connectivity; read before re-pointing")


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
bad_lean = [x for x in kept if x['path'] in LEAN and x['id'] not in BOUND]
assert not bad_lean, ('a record outside BD2 and the GrammarPath-bound ones cites the changed modules', bad_lean)

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
assert not unexpected, ("drift outside the sections BD2 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
summary = run_repoint(['--reason', REASON, '--ids'] + sorted(BOUND) + ['--paths'] + LEAN
                      + ['--receipt', RECEIPT, '--lean'] + LEAN)
print('repoint (bindings):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
