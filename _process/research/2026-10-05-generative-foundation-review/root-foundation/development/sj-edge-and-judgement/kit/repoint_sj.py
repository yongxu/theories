#!/usr/bin/env python3
"""SJ1's landing (repoint_el.py's pattern): re-point the records drifting by SJ1's edits only.

The drift list of `research.py check` is filtered to the paths SJ1 changes, so another session's drift stays with
its owner and is printed for it. Every drifting (record, path) pair is listed with its changed sections first, and
each changed section must be one SJ1's texts write (EXPECTED); a pair outside them stops the script, to be read and
settled by hand. SJ1's own record may drift on its own paths. One existing Lean file changes, Viability.lean, whose
two kernel laws are re-proved with their statements unchanged and one theorem added (kernel_iff_held): the records
citing it (VIA_CITERS) have their hashes re-pointed, and their proof bindings to it rebound to the receipt, which
must bind the current bytes (repoint.py checks). The invariance-kernel correction, applied with SJ1, changes the
docstrings of Keeping.lean and Lasting.lean ("viability kernel" to "invariance kernel", and Lasting's one sentence that
for a determined law it is also the viability kernel), with no declaration changed: the records citing them
(KEEP_CITERS, LAST_CITERS) are re-pointed and their proof bindings rebound the same way.
usage (from the checkout root, after reland_sj.py): python3 -B <kit>/repoint_sj.py RECEIPT [--apply]"""
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
LEAF = f'{PKG}/Becoming/CommonResponse.lean'
VIA = f'{PKG}/Becoming/Viability.lean'
KEEP = f'{PKG}/Becoming/Keeping.lean'
LAST = f'{PKG}/Becoming/Lasting.lean'
CH = 'theories/becoming/chapters'
OTHER = [f'{PKG}/Becoming.lean', f'{PKG}/README.md', f'{PKG}/README.zh.md', f'{PKG}/check_becoming.py',
         f'{PKG}/becoming-verification.json',
         f'{CH}/03-KNOWING.md', f'{CH}/05-COLLECTIVES.md', f'{CH}/08-METHOD.md',
         'theories/becoming/results/data/regions.json',
         f'{RF}/BECOMING-RENEWAL-READING.md', f'{RF}/THEOREM-CONNECTIVITY.json', f'{RF}/THEOREM-CONNECTIVITY-APART.json']
MINE = {LEAF, VIA, KEEP, LAST} | set(OTHER)
OWN = {'a-response-common-over-a-reading'}
VIA_CITERS = {'market-protected-continuation', 'conditions-kept-together'}
KEEP_CITERS = {'finite-continuation-plans', 'joint-plan-composition', 'what-holding-for-a-reading-is-worth',
               'when-to-inquire-and-when-to-respond'}
LAST_CITERS = {'coupled-regimes', 'coupled-webs', 'identification-where-runs-part', 'market-finite-support-obstruction',
               'market-supported-finite-transition', 'lifting-where-branching-is-finite',
               'market-partial-correction-boundary', 'regime-in-any-amounts', 'threshold-in-the-state-plane',
               'where-a-run-goes-on', 'where-a-run-of-a-regime-comes-to-rest', 'whether-a-loop-closes-a-difference'}
CITERS = {VIA: VIA_CITERS, KEEP: KEEP_CITERS, LAST: LAST_CITERS}
# the sections SJ1's texts change, as research.py check names them (a heading at either level, or an anchor a record
# cites), compared without their leading #s; set after reading the dry run against the home sections' diff
EXPECTED = {
    f'{CH}/03-KNOWING.md': {'12. The reading loop', '12-the-reading-loop', 'the-reading-loop',
                            '(before the first heading)'},
    f'{CH}/05-COLLECTIVES.md': {'10. Markets', '10-markets', 'markets', 'r-market-protected-continuation'},
    f'{CH}/08-METHOD.md': {'3. The pure core and the periphery', '3-the-pure-core-and-the-periphery',
                           'pure-core-and-periphery'},
}
REASON = ("SJ1: one core leaf, Becoming.CommonResponse, joined to the core (the root module's import and bullets, the "
          "checker's core list and scope, the package README rows EN and ZH); Viability's two kernel laws re-proved "
          "from it with their statements unchanged and kernel_iff_held added, the proof bindings to Viability.lean "
          "rebound to the receipt; the new record's home in 03 §12, the §12 opening's count of its laws and 03's bases "
          "line naming it; 05 §10's "
          "row naming the kernel's home; 08's counts; regions.json; the study; the connectivity; with SJ1, "
          "\"viability kernel\" corrected to \"invariance kernel\" (Viability.Kernel holds where every course stays "
          "in the guard) in the docstrings of Viability, Keeping and Lasting, no declaration changed, their proof "
          "bindings rebound to the receipt; read before re-pointing")


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
bad_lean = [x for x in kept if (x['path'] == LEAF and x['id'] not in OWN)
            or (x['path'] in CITERS and x['id'] not in OWN | CITERS[x['path']])]
assert not bad_lean, ('a record outside SJ1 cites a changed Lean file', bad_lean)

unexpected = []
for x in kept:
    if x['id'] in OWN or x['path'] == LEAF or x['path'] in CITERS or x['path'] not in EXPECTED:
        continue
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if not sections or not sections <= EXPECTED[x['path']]:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections SJ1 writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name, '--receipt', RECEIPT, '--lean', VIA, KEEP, LAST])
    Path(f.name).unlink()
    print('repoint (texts, Viability, Keeping and Lasting):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
    rebound = {k for k, v in summary['by_record'].items() if v['rebound']}
    assert rebound <= VIA_CITERS | KEEP_CITERS | LAST_CITERS | OWN, rebound
else:
    print('repoint: nothing to re-point')
