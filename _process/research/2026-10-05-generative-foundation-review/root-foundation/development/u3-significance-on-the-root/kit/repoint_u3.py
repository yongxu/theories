#!/usr/bin/env python3
"""U3 (LW's repoint_lw.py): re-point the records drifting by U3's landing only, in two parts.

1. Texts. The drift list of `research.py check` is filtered to the pages U3's kits change (texts_u3.py and the home
   bullets of make_records_u3.py); each changed section must be one they write (EXPECTED), or the script stops.
2. Lean. `Becoming.Weightings` gains one theorem, row 10's interface law, inserted with the rest of the file byte for
   byte (integrate_u3.py asserts it). The records bound to the file are rebound to U3's core run.

Read before re-pointing (30 October 2026, rehearsed on main 85911ab22 with U3's kits applied):
- 07's preamble rewrites one clause of the thesis paragraph: "The condition on the root's grammar, beyond one
  instance" becomes "beyond the laws stated there". The chapter-7 records citing 07 by anchor drift for it (sixteen
  in the rehearsal, the record of the root form among them). None states, presupposes or bounds that clause. Each states its own law in its home section, which
  U3 leaves as it was, adding bullets after the laws only. 07 §4.5's two sentences on the root form now say that
  three more laws are proved, each in its own record. The record the-continuation-condition-on-the-root states that
  root form; its next step is updated by texts_u3.py with a history-free wording change ("Beyond the three stated at
  the own-closure reading …"), and nothing it states changes.
- The overview's §10 rewrites the bullet on the root and the ethics as one account. The three records on rule shaping
  that cite the overview (loss-read-in-time-by-the-others, readers-drawn-from-the-selected,
  shaping-read-by-readers-drawn-from-the-selected) do not state it.
- `Becoming.Weightings`: ten records bind its bytes. Each declaration they bind is unchanged; one theorem is added.
So nothing the records say changes, and re-points, not history notes, are what the workflow asks.
usage (from the checkout root, after texts_u3.py --apply and the core run):
  python3 -B <kit>/repoint_u3.py RECEIPT_ID [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
RECEIPT_ID = sys.argv[1]
B = 'theories/becoming'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
WEIGHTINGS = f'{PKG}/Becoming/Weightings.lean'
FU = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/fu-full-unification/PROPOSAL.md'
# the sections U3's kits change, as research.py check names them (heading or anchor), compared without leading #s
EXPECTED = {
    f'{B}/chapters/07-SIGNIFICANCE.md': {
        '(before the first heading)', '2. The order with no premise', 'order', 'r-significance-retained-within-margin',
        '3. The continuation condition', 'condition', 'r-continuation-condition-yields-living-significance',
        '4. Scope and order: two premises, two roles', 'scope-and-order', 'r-the-continuation-condition-on-the-root',
        'r-widening-as-what-every-weighting-ranks', 'r-comparison-by-widening', 'Open', 'open'},
    f'{B}/chapters/01-ROOT.md': {'Open', 'open'},
    f'{B}/chapters/08-METHOD.md': {'7. Master laws and connectivity', 'master-laws-and-connectivity'},
    f'{B}/ONE-PAGE.md': {'(before the first heading)'},
    f'{B}/ONE-PAGE.zh.md': {'(before the first heading)'},
    f'{B}/THE-THEORY-OF-BECOMING.md': {'10. What is not shown, and what is open'},
    f'{B}/THE-THEORY-OF-BECOMING.zh.md': {'10. 尚未表明者与未决者'},
    f'{B}/review/PHILOSOPHY.md': {'Part 5. The condition on the root, and the open question', 'p-17'},
    f'{B}/review/BUDDHIST-THOUGHT.md': {'三、《大乘起信论》', 'b-24'},
    FU: {'3. Items'},
}
REASON_TEXTS = ("U3 landed: the significance rows on the root (rows 5, 7 and 10 restated on their own carrier, rows 1, 8 "
                "and 9 specialized at the own-closure reading); 07's thesis clause on the root's grammar, its 4.5 "
                "sentences on the root form and its home bullets, 08's master-law count, the one page, the overview's "
                "open section, PHILOSOPHY, BUDDHIST-THOUGHT and FU's proposal; no record states, presupposes or bounds "
                "the rewritten lines; read before re-pointing")
REASON_LEAN = ("U3 landed: Becoming.Weightings gains row 10's interface law (Weighting.grammar_widens_iff_every_positive), "
               "inserted with the rest of the file byte for byte; every bound declaration unchanged; rebound to U3's core run")


def run_repoint(args):
    result = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py'] + args + (['--apply'] if APPLY else []),
                            cwd=ROOT, capture_output=True, text=True)
    print(result.stdout[-3000:], result.stderr[-2000:])
    assert result.returncode == 0, result.returncode
    return json.loads(result.stdout)


assert (ROOT / RECEIPT).is_file(), RECEIPT
out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
texts = [x for x in drift if x['path'] in EXPECTED]
lean = sorted({x['id'] for x in drift if x['path'] == WEIGHTINGS})
left = [(x['id'], x['path']) for x in drift if x['path'] not in EXPECTED and x['path'] != WEIGHTINGS]

unexpected = []
for x in texts:
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    if not sections or not sections <= EXPECTED[x['path']]:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(texts)} text pairs in {len({x["id"] for x in texts})} records:')
for x in texts:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print(f'rebinding {len(lean)} records to {RECEIPT_ID} for Becoming.Weightings:', lean)
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections U3 writes: read it, then settle it by hand", unexpected)
assert not left, ("drift U3 did not make: read it and give it to its owner", left)

if texts:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': texts}, f)
    summary = run_repoint(['--reason', REASON_TEXTS, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
if lean:
    summary = run_repoint(['--reason', REASON_LEAN, '--ids', *lean, '--paths', WEIGHTINGS, '--receipt', RECEIPT,
                           '--lean', WEIGHTINGS])
    print('repoint (Lean):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
