#!/usr/bin/env python3
"""EL6's landing (repoint_el.py's pattern): re-point the records drifting by EL6's edits only, then rebind the proof
bindings of the Lean files EL6 changes to the landing's receipt.

The drift list of `research.py check` is filtered to the paths EL6 changes, so another session's drift stays with
its owner and is printed for it. Every drifting (record, path) pair is listed with its changed sections first, and
in a chapter each changed section must be one EL6's texts write (EXPECTED); a pair outside them stops the script,
to be read and settled by hand. Then `repoint.py --receipt … --lean …` rebinds every record's proof binding to the
five changed Lean files, after checking that the receipt binds each file's current bytes and passed.
degeneration-from-a-horizon's bindings are written by reland_el6.py.
usage (from the checkout root, after reland_el6.py): python3 -B <kit>/repoint_el6.py RECEIPT [--apply]"""
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
LEAN = [f'{PKG}/Becoming/{m}.lean' for m in ('GrammarMap', 'GrammarConditionals', 'MapInstances',
                                             'KeepingWidening', 'LineageRegions')]
CH = 'theories/becoming/chapters'
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json', f'{CH}/02-MAP.md', f'{CH}/08-METHOD.md',
         'theories/becoming/results/data/regions.json', 'theories/becoming/results/data/master-laws.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/el-evolution-on-the-root/NOTE.md',
         'experiments/integrated-correction/general-framework/generative-basis/lean/history/INDEX.md',
         'experiments/integrated-correction/general-framework/generative-basis/lean/history/MANIFEST.json']
MINE = set(LEAN) | set(OTHER)
# the sections EL6's texts change, as research.py check names them, compared without their leading #s; set after
# reading the dry run against the chapters' diff
EXPECTED = {
    f'{CH}/02-MAP.md': {'1. The map on branches', '1-the-map-on-branches', 'branches'},
    f'{CH}/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                           'pure-core-and-periphery'},
}
REASON = ("EL6: EL3's leaf Becoming.LineDegeneration placed in its owners' modules on their yes and retired (the "
          "grammar part in GrammarMap under Chinese names, the kind instance in KeepingWidening, the rest in "
          "MapInstances with the landed laws proved from degeneration in place), Web.degenerates_of_gone renamed "
          "Web.end_of_gone and Map.Short.degeneration renamed Map.Short.reaches_end (each concludes 有终, not «退化»), "
          "no statement changed; the root module's bullets, the checker's core list and scope, both package README "
          "rows, 02 §1's names, 08's counts, regions.json, the study, the connectivity; read before re-pointing")


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
assert not unexpected, ("drift outside the sections EL6 writes: read it, then settle it by hand", unexpected)

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
