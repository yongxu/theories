#!/usr/bin/env python3
"""SJ's last landing (repoint_sj.py's pattern): re-point the records drifting by its edits only.

The drift list of `research.py check` is filtered to the paths this landing changes, so another session's drift stays
with its owner. Each changed section of a text must be one this landing writes (EXPECTED); a pair outside them stops
the script, to be read and settled by hand. One Lean file changes, GuardHorizon.lean (a ring module): two theorems
added and statewise_not_uniform re-proved with its statement unchanged; the records citing it (GH_CITERS) are
re-pointed and their proof bindings rebound to the receipt, which must bind the current bytes (repoint.py checks).
usage (from the checkout root, after reland_sj2.py): python3 -B <kit>/repoint_sj2.py RECEIPT [--apply]"""
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
GH = f'{PKG}/Becoming/GuardHorizon.lean'
CH = 'theories/becoming/chapters'
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/becoming-verification.json',
         f'{CH}/03-KNOWING.md', f'{CH}/07-SIGNIFICANCE.md', f'{CH}/08-METHOD.md',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json']
MINE = {GH} | set(OTHER)
OWN = {'a-response-common-over-a-reading', 'when-to-inquire-and-when-to-respond'}
GH_CITERS = {'a-reading-kept-by-its-update', 'a-revision-that-opens-a-correction',
             'when-to-inquire-and-when-to-respond'}
CITERS = {GH: GH_CITERS}
# the sections this landing's texts change, as research.py check names them (a heading at either level, or an anchor a record
# cites), compared without their leading #s; set after reading the dry run against the home sections' diff
EXPECTED = {
    f'{CH}/03-KNOWING.md': {'12. The reading loop', '12-the-reading-loop', 'the-reading-loop',
                            'r-a-response-common-over-a-reading'},
    f'{CH}/07-SIGNIFICANCE.md': {'5. Practical judgment', '5-practical-judgment', 'practical-judgment'},
    f'{CH}/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                           'pure-core-and-periphery', '7. Shared laws and connectivity',
                           '7-shared-laws-and-connectivity', 'what-a-response-takes-in'},
}
# the seven records binding 08 as a whole file: only lines added in §7 and the counts sentence in §3 change, so most would
# stay grown rather than drift; on the coordinator's word each is read and re-pointed here, as LN2 did, whether it drifts or not
BIND_08 = {'contraction-where-duplication-is-reachable', 'one-move-covering', 'one-root-to-its-edge',
           'premises-met-and-failed', 'self-reference-does-not-certify-itself', 'type-formation-gives-no-dynamics',
           'what-a-summary-keeps'}
REASON = ("SJ's last parts: GuardHorizon's bridge to the core's law of a common response in a ring module "
          "(uniform_policy_iff_common and its witness, statewise_not_uniform re-proved with its statement unchanged), "
          "the proof bindings to GuardHorizon.lean rebound to the receipt; the map of what a response takes in at "
          "08 §7; 07 §5's sentence; 03 §12's home naming the converse; the root module's bullet and the README row; "
          "08's counts; the study; the connectivity; read before re-pointing. Each of the seven records binding 08 as a "
          "whole file read against the new text: none cites the new block or §3's counts, one-root-to-its-edge cites §7's "
          "figures, unchanged; each record binding 03 or 07 and drifting read against the new sentence: nothing they say "
          "changes")


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
bad_lean = [x for x in kept if x['path'] in CITERS and x['id'] not in OWN | CITERS[x['path']]]
assert not bad_lean, ('a record outside this landing cites a changed Lean file', bad_lean)

unexpected = []
for x in kept:
    if x['id'] in OWN or x['path'] in CITERS or x['path'] not in EXPECTED:
        continue
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if not sections or not sections <= EXPECTED[x['path']]:
        unexpected.append((x['id'], x['path'], sorted(sections)))
have = {(x['id'], x['path']) for x in kept}
M08 = f'{CH}/08-METHOD.md'
for rid in sorted(BIND_08):
    assert (ROOT / f'theories/becoming/results/records/{rid}.json').is_file(), rid
    if (rid, M08) not in have:
        kept.append({'id': rid, 'path': M08, 'changed_sections': ['(lines added only; read on the coordinator\'s word)']})
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections this landing writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name, '--receipt', RECEIPT, '--lean', GH])
    Path(f.name).unlink()
    print('repoint (texts and GuardHorizon):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
    rebound = {k for k, v in summary['by_record'].items() if v['rebound']}
    assert rebound <= GH_CITERS | OWN, rebound
else:
    print('repoint: nothing to re-point')
