#!/usr/bin/env python3
"""UE28's landing (repoint_ue27.py's pattern): re-point the records drifting by UE28's edits only.
The drift list of `research.py check` is filtered to the paths UE28 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE28's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The changed
module is cited by no record but the amended one, which make_records_ue28.py writes against the new texts.
READ is empty until a dry run lists the drifting records; each is then read against the new text and its reading
added here, and a record not read stops the script.
usage (from the checkout root, after integrate_ue28.py, texts_ue28.py and reland_ue28.py):
  python3 -B <kit>/repoint_ue28.py CORE [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[2:]
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RIDS = {'a-formations-couplings-as-its-blanket'}
LEAN = [f'{PKG}/Becoming/BlanketCouplings.lean']
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         'theories/becoming/chapters/03-KNOWING.md', 'theories/becoming/chapters/08-METHOD.md',
         'theories/becoming/FREE-ENERGY-PRINCIPLE.md', 'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json',
         f'{RF}/THEOREM-CONNECTIVITY-APART.json',
         f'{RF}/development/ue-unified-explanation/PLAN.md', f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md']
MINE = set(LEAN) | set(OTHER)
# the sections UE28's texts change, as research.py check names them (a heading, or the anchor a record cites),
# compared without their leading #s
EXPECTED = {
    'theories/becoming/chapters/03-KNOWING.md': {'1. A selection reaches what couples in',
                                                 '1-a-selection-reaches-what-couples-in', 'selection',
                                                 'r-the-markov-blanket-as-a-coupling-structure',
                                                 'r-a-formations-couplings-as-its-blanket'},
    'theories/becoming/chapters/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                                                'pure-core-and-periphery', '8. Known results', '8-known-results',
                                                'known-results'},
    'theories/becoming/FREE-ENERGY-PRINCIPLE.md': {
        'In brief', 'in-brief', 'Claim by claim', 'claim-by-claim', '1. The quantities', '1-the-quantities',
        '4. What persistence needs', '4-what-persistence-needs',
        '5. What the principle states that the theory cannot yet', '5-what-the-principle-states-that-the-theory-cannot-yet'},
    f'{RF}/development/ue-unified-explanation/PLAN.md': {'6. Owners', '6-owners'},
    f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md': {'3. The items', '3-the-items'},
}
REASON = ("UE28: Becoming.BlanketCouplings extended with a formation's level as the internal part, along one run (the "
          "root module's L1 bullet, the checker's scope sentence, the package README rows EN and ZH); 03 §1 (the "
          "blanket's reading, 'folds' for 'keeps' and the level along one run; UE27's home section label and its "
          "sentence on the agent; a new paragraph after the three levels); 08's counts and §8's known results; the "
          "principle's page (In brief, the claim table, §1, §4 and §5); the study; the UE plan and FEP-INTEGRATION's "
          "item 13; regions.json; the connectivity; read before re-pointing")
# Each record re-pointed is read against the new text before the landing, and the reading is given here; a record
# not read stops the script, to be read and added.
READ = {
    'a-code-held-as-counts': (
        "read against the new page: the code law's entries and the statements of the literature that fail are "
        "unchanged; UE28 adds the level along one run beside the blanket's entries (In brief, the claim table, §1 and "
        "§4) and narrows §5's item on a formation's own record, so nothing the record says changed"),
    'capture-by-counted-choices': (
        "read against the new 03 §1: the paragraph citing it is unchanged; UE28 changes the blanket's reading ('folds' "
        "for 'keeps', the level along one run) and UE27's home section, and the record's non-claim that the "
        "principle's partition is a coupling structure of the World model, no representation theorem joining a "
        "Langevin system with a blanket to a web, still holds, since UE28 reads one World run with the level internal "
        "and joins no Langevin system to a web; nothing the record says changed"),
    'exit-from-a-margin': (
        "read against the new 03: the margin's paragraph is unchanged, and §1's change is the blanket's reading and "
        "UE27's home section with the level's two paragraphs, which the record does not cite; nothing the record says "
        "changed"),
    'the-blanket-at-a-steady-state': (
        "read against the new page: the statistical form's entries keep their hypotheses and wording (In brief, the "
        "claim table, §1, §5); UE28's entries on the level along one run are added beside UE27's; nothing the record "
        "says changed"),
    'the-blanket-in-a-linear-steady-state': (
        "read against the new page: the linear case's entries keep their hypotheses and the synchronous loss stays a "
        "witness; UE28's entries are added beside UE27's; nothing the record says changed"),
}


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
assert not [x for x in drift if x['id'] in RIDS], 'the amended record drifts: write it after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than UE28\'s cites the changed module'

unexpected = []
for x in kept:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if x['path'] in EXPECTED and (not sections or not sections <= allowed):
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections UE28 writes: read it, then settle it by hand", unexpected)
unread = sorted({x['id'] for x in kept} - set(READ))
assert not unread, ("records not yet read against the new text: read each, then add its reading to READ", unread)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    reason = REASON + '; ' + '; '.join(f'{i}: {READ[i]}' for i in sorted({x['id'] for x in kept}))
    summary = run_repoint(['--reason', reason, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
