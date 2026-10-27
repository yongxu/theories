#!/usr/bin/env python3
"""UE11 (UE10's repoint_ue10.py): re-point the records drifting by UE11's edits only. The drift list of `research.py
check` is filtered to the paths UE11 changes, so another session's drift stays with its owner and is printed for it.
Before anything is written, every drifting (record, path) pair is listed with its changed sections, and each changed
section must be one UE11's texts write (EXPECTED below); a pair outside them stops the script, to be read and settled
by hand. Then tools/research/repoint.py re-points exactly the kept pairs.

Lean: the new module is cited by no record but the new one. SelectionPool.lean's docstring correction (DF's LEFT.md)
rides with UE11: its records drift on exact bytes, so the script first checks that the module's only change against
HEAD is that one line, then re-points the records citing it and rebinds their proof bindings to UE11's receipt, which
checked the corrected bytes (repoint.py --receipt --lean).
usage (from the checkout root, after texts_ue11.py and make_records_ue11.py):
  python3 -B <kit>/repoint_ue11.py RECEIPT [--apply]"""
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
RID = 'where-the-possible-grows'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
LEAN = [f'{PKG}/Becoming/HeldPossible.lean']
POOL = f'{PKG}/Becoming/SelectionPool.lean'
POOL_OLD = '(`Revision.web_keeps_iff` is the case of one formation at two steps)'
POOL_NEW = '(`Registration.web_keeps_iff` is the case of one formation at two steps)'
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/01-ROOT.md', 'theories/becoming/chapters/02-MAP.md',
         'theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE11's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/01-ROOT.md': {'Open', 'open'},
    'theories/becoming/chapters/02-MAP.md': {'9. Capture', 'r-rules-that-change-themselves-in-the-grammar'},
    'theories/becoming/chapters/07-SIGNIFICANCE.md': {'2. The order with no premise', 'r-what-a-course-keeps-reachable'},
    'theories/becoming/chapters/08-METHOD.md': {'8. Known results', 'beyond-the-table'},
}
REASON = ("UE11 landed: Becoming.HeldPossible joined to the core as a leaf (the root module's import and doc, the "
          "checker's core list and scope, the package README rows EN and ZH), no landed statement or proof changed; 07 "
          "§2 (the home section of where-the-possible-grows after what a course keeps reachable, whose reading's last "
          "clause now points to it), 01's Open item on self-changing conditions narrowed, a pointer in 02 after rules "
          "that change themselves, 08 §8 and 08's counts; the study; the UE plan; regions.json; the connectivity; "
          "what-a-course-keeps-reachable and rules-that-change-themselves-in-the-grammar related to the new record, "
          "each with its history note; read before re-pointing")
POOL_REASON = ("UE11's core run carries SelectionPool's docstring correction (DF's LEFT.md, for UE1b's owner): "
               "anticipates_iff cites Registration.web_keeps_iff, not Revision.web_keeps_iff; one docstring line, no "
               "statement or proof changed; the bindings rebound to UE11's receipt, which checked the corrected bytes")


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
kept = [x for x in drift if x['path'] in MINE and x['id'] != RID]
pool = [x for x in drift if x['path'] == POOL]
left = [(x['id'], x['path']) for x in drift if x['path'] not in MINE and x['path'] != POOL]
assert not [x for x in drift if x['id'] == RID], 'the new record drifts: write it after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than the new one cites the new module'

# SelectionPool: the docstring line is the only change, and the drifting records are exactly those citing it
diff = subprocess.run(['git', 'diff', '--unified=0', 'HEAD', '--', POOL], cwd=ROOT, capture_output=True,
                      text=True).stdout
changed = [line for line in diff.split('\n') if line and line[0] in '+-' and not line.startswith(('+++', '---'))]
assert len(changed) == 2 and changed[0].startswith('-') and changed[1].startswith('+'), changed
assert POOL_OLD in changed[0] and changed[0][1:].replace(POOL_OLD, POOL_NEW) == changed[1][1:], changed
citing = sorted(json.loads(p.read_text(encoding='utf-8'))['id']
                for p in (ROOT / 'theories/becoming/results/records').glob('*.json')
                if any(r.get('path') == POOL for r in json.loads(p.read_text(encoding='utf-8')).get('references', [])))
assert sorted(x['id'] for x in pool) == citing, (sorted(x['id'] for x in pool), citing)

unexpected = []
for x in kept:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print(f'SelectionPool: {len(pool)} records citing it re-pointed and rebound:', citing)
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections UE11 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
summary = run_repoint(['--reason', POOL_REASON, '--paths', POOL, '--ids'] + citing
                      + ['--receipt', RECEIPT, '--lean', POOL])
print('repoint (SelectionPool):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
