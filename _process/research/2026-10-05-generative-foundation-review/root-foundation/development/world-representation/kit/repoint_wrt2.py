#!/usr/bin/env python3
"""WRT2 (UE15's repoint_ue15.py): re-point the records drifting by WRT2's edits only.
The drift list of `research.py check` is filtered to the paths WRT2 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one WRT2's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The two new
modules are cited by no record but the new one.
usage (from the checkout root, after texts_wrt2.py and make_records_wrt2.py):
  python3 -B <kit>/repoint_wrt2.py RECEIPT [--apply]"""
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
RIDS = {'the-world-represented-both-ways'}
LEAN = [f'{PKG}/Becoming/GrammarTransport.lean', f'{PKG}/Becoming/WorldRepresentation.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/THE-THEORY-OF-BECOMING.md', 'theories/becoming/review/LOGIC.md', 'GLOSSARY.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json']
MINE = set(LEAN) | set(OTHER)
# the sections WRT2's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/01-ROOT.md': {'(before the first heading)', 'The root: continuation relative to a class',
                                              'the-root-continuation-relative-to-a-class',
                                              '8.6 The World model in the grammar', 'the-world-model-in-the-grammar',
                                              'instances', 'What this chapter does not show',
                                              'what-this-chapter-does-not-show', 'Open', 'open'},
    'theories/becoming/chapters/08-METHOD.md': {'Open', 'open', '3. The pure core and the periphery',
                                                '3-the-pure-core-and-the-periphery', 'pure-core-and-periphery'},
    'theories/becoming/THE-THEORY-OF-BECOMING.md': {'1. The root: continuation relative to a class',
                                                    '1-the-root-continuation-relative-to-a-class',
                                                    '10. What is not shown, and what is open',
                                                    '10-what-is-not-shown-and-what-is-open'},
    'theories/becoming/review/LOGIC.md': {'L-21 Expressible is not derived; the World as a model', 'l-21'},
    'GLOSSARY.md': {'The root', 'the-root'},
}
REASON = ("WRT2 landed: Becoming.GrammarTransport and Becoming.WorldRepresentation joined to the core as leaves (the root "
          "module's imports and doc, the checker's core list and scope, the package README rows EN and ZH), no landed "
          "statement or proof changed; 01 §8.6 (the theorem of the-world-represented-both-ways, and the corrected "
          "sentence on what is no instance), 01's thesis, its paragraph on what is claimed, the clause of its not-shown "
          "line on the representation theorem and its Open entry; 08's Open entry and counts; the overview's two "
          "sentences on faithful representation; L-21's weakness line; the glossary; the study; regions.json; the "
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
assert not [x for x in drift if x['id'] in RIDS], 'the new record drifts: write it after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than the new one cites a new module'

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
assert not unexpected, ("drift outside the sections WRT2 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
