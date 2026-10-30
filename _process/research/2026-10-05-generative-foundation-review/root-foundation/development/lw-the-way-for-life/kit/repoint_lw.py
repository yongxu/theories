#!/usr/bin/env python3
"""LW (UE23's repoint_ue23.py): re-point the records drifting by LW's text edits only.
The drift list of `research.py check` is filtered to the paths LW's texts change, so another session's drift stays with
its owner and is printed for it. Before anything is written, every drifting (record, path) pair is listed with its
changed sections, and each changed section must be one LW's texts write (EXPECTED below); a pair outside them stops the
script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept pairs. LW writes no
record, so every drifting record's text is unchanged.

Read before re-pointing (30 October 2026, on main ffefcda8d). The records drift only because they cite these pages by
anchor, so a rewritten line before the first heading, or in a cited section, counts. LW's rewritten lines are the ethics'
open clauses and T8: 07's thesis paragraph (its "Open:" clause only), T8, does-not-show and the open item on a universal
practical warrant; OPENING's footnote [^ethics] (one clause added); the overview's T8 line (§9) and its warrant
paragraph (§10), in both editions. No drifting record states, presupposes or bounds those lines: the one record
naming a warrant, the-continuation-condition-on-the-root, lists "the warrant of the condition, or anything about C"
under does_not_show, which LW's texts keep; what-the-dynamics-leave-open states the non-entailment that T8's sentence
cites, unchanged. So nothing the records say changes, and a re-point, not a history note, is what the workflow asks.
usage (from the checkout root, after lw_texts.py):
  python3 -B <kit>/repoint_lw.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
B = 'theories/becoming'
MINE = {'AGENTS.md', f'{B}/COLLECTIVE-DIRECTION.md', f'{B}/ONE-PAGE.md', f'{B}/ONE-PAGE.zh.md', f'{B}/OPENING.md',
        f'{B}/THE-THEORY-OF-BECOMING.md', f'{B}/THE-THEORY-OF-BECOMING.zh.md', f'{B}/chapters/07-SIGNIFICANCE.md',
        f'{B}/chapters/08-METHOD.md', f'{B}/review/PHILOSOPHY.md'}
# the sections LW's texts change, as research.py check names them (heading or anchor), compared without leading #s
EXPECTED = {
    'AGENTS.md': {'(before the first heading)', 'Scope and current status'},
    f'{B}/COLLECTIVE-DIRECTION.md': {'The answer in brief', '4. What needs a premise'},
    f'{B}/ONE-PAGE.md': {'(before the first heading)'},
    f'{B}/ONE-PAGE.zh.md': {'(before the first heading)'},
    f'{B}/OPENING.md': {'Truth exists'},
    f'{B}/THE-THEORY-OF-BECOMING.md': {'9. The central results and the theses', '10. What is not shown, and what is open'},
    f'{B}/THE-THEORY-OF-BECOMING.zh.md': {'9. 核心结果与论题', '10. 尚未表明者与未决者'},
    f'{B}/chapters/07-SIGNIFICANCE.md': {'(before the first heading)', '8. Theses', 'theses', 'What this chapter does not show',
                                         'does-not-show', 'Open', 'open', 'r-universal-practical-warrant'},
    f'{B}/chapters/08-METHOD.md': {'9. Theses', 'theses', '12. The open programme', 'open-programme'},
    f'{B}/review/PHILOSOPHY.md': {'Part 6. Practice, alignment and the theses'},
}
REASON = ("LW landed (texts only): the ethics for life, T8 in the stance form; 07's thesis paragraph (its open clause), T8, "
          "does-not-show and the open item on a universal practical warrant, OPENING's footnote [^ethics], the overview's "
          "T8 line and warrant paragraph (both editions), the one page, 08, the review packet's P-26, COLLECTIVE-DIRECTION "
          "and AGENTS.md; no record states, presupposes or bounds the rewritten lines; read before re-pointing")


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
    sections = {sct.lstrip('#').strip() for sct in (x.get('changed_sections') or [])}
    allowed = EXPECTED.get(x['path'])
    if allowed is None or not sections or not sections <= allowed:
        unexpected.append((x['id'], x['path'], sorted(sections)))
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
assert not unexpected, ("drift outside the sections LW writes: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
