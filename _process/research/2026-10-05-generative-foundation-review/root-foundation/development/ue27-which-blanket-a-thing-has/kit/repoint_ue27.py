#!/usr/bin/env python3
"""UE27's landing (repoint_ue26.py's pattern): re-point the records drifting by UE27's edits only.
The drift list of `research.py check` is filtered to the paths UE27 changes, so another session's drift stays with its
owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its changed
sections, and each changed section must be one UE27's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. The new
module is cited by no record but the new one.
usage (from the checkout root, after integrate_ue27.py, texts_ue27.py and reland_ue27.py):
  python3 -B <kit>/repoint_ue27.py CORE [--apply]"""
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
# the sections UE27's texts change, as research.py check names them (a heading, or the anchor a record cites),
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
        '2. Where the two agree', '2-where-the-two-agree', '4. What persistence needs', '4-what-persistence-needs',
        '5. What the principle states that the theory cannot yet', '5-what-the-principle-states-that-the-theory-cannot-yet',
        'Standing', 'standing'},
    f'{RF}/development/ue-unified-explanation/PLAN.md': {'6. Owners', '6-owners'},
    f'{RF}/development/ue-unified-explanation/FEP-INTEGRATION.md': {'3. The items', '3-the-items'},
}
REASON = ("UE27: Becoming.BlanketCouplings joined to the core as a leaf importing Blanket, Histories and "
          "IdentificationRuns (the root module's import and bullet, the checker's core list and scope, the package "
          "README rows EN and ZH); 03 §1 (a formation's couplings as its blanket, after the blanket's reading; the "
          "blanket's last sentence and reading brought to it); 08's counts and §8's known results; the principle's page "
          "(In brief, the claim table, §1, §2, §4, §5 and Standing); the study; the UE plan and FEP-INTEGRATION's item "
          "12; regions.json; the connectivity; read before re-pointing")
# Each record re-pointed is read against the new text before the landing, and the reading is given here; a record
# not read stops the script, to be read and added.
READ = {
    'a-code-held-as-counts': (
        "read against the new page: the code law's entries and the five statements of the literature that fail are "
        "unchanged; UE27 adds which blanket a thing has beside the blanket's entries (In brief, the claim table, §1, "
        "§2, §4, §5 and Standing, the self-evidencing row among the claims) and a fifth further law where four stood, "
        "so nothing the record says changed"),
    'capture-by-counted-choices': (
        "read against the new 03 §1: the paragraph citing it is unchanged; UE27 adds a home section after the "
        "blanket's reading, and the record's non-claim that the principle's partition is a coupling structure of the "
        "World model, no representation theorem joining a Langevin system with a blanket to a web, still holds, since "
        "UE27 builds a blanketed law from a web's couplings and joins no Langevin system to a web; nothing the record "
        "says changed"),
    'exit-from-a-margin': (
        "read against the new 03: the margin's paragraph in 03 is unchanged, and §1's change is the blanket's last "
        "sentence and reading and UE27's new section, which the record does not cite; nothing the record says changed"),
    'the-blanket-at-a-steady-state': (
        "read against the new page: the statistical form's entries keep their hypotheses (In brief, the claim table, "
        "§1, §2, §5 and Standing), In brief only dropping the item's leading 'and' and joining 'need not hold with "
        "circulation, as in a witness' into its clause, the meaning unchanged; UE27's entries are added beside them; "
        "nothing the record says changed"),
    'the-blanket-in-a-linear-steady-state': (
        "read against the new page: the linear case's entries keep their hypotheses and the synchronous loss stays a "
        "witness, a loss of the discrete step; UE27's entries are added beside them; nothing the record says changed"),
    'the-markov-blanket-as-a-coupling-structure': (
        "read against the new 03 §1: its home section's statement and laws are unchanged; its last sentence points to "
        "UE27's section in place of saying a World formation in general is not shown, and its reading says which "
        "half UE27 makes a theorem; the record's does_not_show and next_delta are narrowed the same way by UE27's "
        "records script; nothing else the record says changed"),
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
assert not [x for x in drift if x['id'] in RIDS], 'a new record drifts: write it after the texts'
assert not [x for x in kept if x['path'] in LEAN], 'a record other than UE27\'s cites the new module'

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
assert not unexpected, ("drift outside the sections UE27 writes: read it, then settle it by hand", unexpected)
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
