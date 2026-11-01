#!/usr/bin/env python3
"""U4d's landing (repoint_el6.py's pattern): re-point the records drifting by U4d's edits only, then rebind the proof
bindings of the Lean files U4d changes to the landing's receipt.

The drift list of `research.py check` is filtered to the paths U4d changes, so another session's drift stays with
its owner and is printed for it. Every drifting (record, path) pair is listed with its changed sections first, and
in a chapter each changed section must be one U4d's texts write (EXPECTED); a pair outside them stops the script,
to be read and settled by hand. Then `repoint.py --receipt … --lean …` rebinds every record's proof binding to the
six changed Lean files, after checking that the receipt binds each file's current bytes and passed.
usage (from the checkout root, after reland_u4d.py): python3 -B <kit>/repoint_u4d.py RECEIPT [--apply]"""
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
LEAN = [f'{PKG}/Becoming/{m}.lean' for m in ('Prelude', 'GrammarLaws', 'Population', 'Locality', 'Decidedness',
                                             'Identity')]
CH = 'theories/becoming/chapters'
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/becoming-verification.json',
         f'{CH}/01-ROOT.md', f'{CH}/08-METHOD.md', 'theories/becoming/results/data/shared-laws.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json']
MINE = set(LEAN) | set(OTHER)
# the sections U4d's texts change, as research.py check names them, compared without their leading #s; set after
# reading the dry run against the chapters' diff
EXPECTED = {
    f'{CH}/01-ROOT.md': set(),
    f'{CH}/08-METHOD.md': set(),
}
REASON = ("U4d: the covering laws on the root, one count on lines from a list in GrammarLaws (ends on lines), the "
          "census of a run proved through it with two hypotheses dropped, Locality's, Decidedness' and Identity's "
          "covering laws re-proved as its cases with their statements unchanged, Identity's exact forms new, eight "
          "helpers with no consumer gone, the prelude gaining two list lemmas and nothing else in it changed, "
          "Population's coming_of_ceasing passing two fewer arguments and its endTest gone; 01 §7's ends-on-lines bullet and 01 §9.5's census row, 08's counts, the "
          "root module's bullet and both package READMEs, the study, the connectivity and the shared laws' view; read "
          "before re-pointing")


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
unexpected = []
for x in kept:
    if x['path'] not in EXPECTED:
        continue
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if not sections or not sections <= EXPECTED[x['path']]:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections U4d writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
rpath = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
summary = run_repoint(['--reason', REASON, '--paths'] + LEAN + ['--receipt', rpath, '--lean'] + LEAN)
print('repoint (bindings):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
