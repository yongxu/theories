#!/usr/bin/env python3
"""Item 13 with the restated question (LW's repoint_lw.py): re-point the records drifting by this landing's text edits
only. The drift list of `research.py check` is filtered to the paths the two kits change (one_sense.py and LW's
upw_question.py), so another session's drift stays with its owner and is printed for it. Every drifting (record, path)
pair is listed with its changed sections, and each changed section must be one the kits write (EXPECTED below); a pair
outside them stops the script, to be read and settled by hand. Then tools/research/repoint.py re-points exactly the kept
pairs. The landing changes one record (universal-practical-warrant, through its own history note); every drifting
record's text is unchanged.

Read before re-pointing (30 October 2026, rehearsed on main 8b44f1c58 with both kits applied). Three records drift, each
because it cites the overview and the overview's §1 rewrites one sentence: "In the grammar 生生 names only renewal
without end" becomes "In the grammar `«生生»` names only renewal without end", and the theory's reading is called plain
生生, without guillemets. The three are loss-read-in-time-by-the-others, readers-drawn-from-the-selected and
shaping-read-by-readers-drawn-from-the-selected, on rule shaping and who reads a loss. None states, presupposes or
bounds the grammar's 生生 or the reading of the ethics' word; the two that use 生生 use the ethics' sense, which the
edit keeps. So nothing the records say changes, and a re-point, not a history note, is what the workflow asks. The
other sections listed in EXPECTED are written by the kits and drew no drift in the rehearsal; they are listed so that a
record citing them by the landing's time is re-pointed only after the same reading, and anything else stops the script.
usage (from the checkout root, after one_sense.py --apply and upw_question.py --apply):
  python3 -B <kit>/repoint_os.py [--apply]"""
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
B = 'theories/becoming'
C = f'{B}/chapters'
# the sections the two kits change, as research.py check names them (the level-2 heading, or before the first one),
# compared without leading #s
EXPECTED = {
    'GLOSSARY.md': {'The root', 'The map', 'Knowing', 'Collectives and significance'},
    f'{B}/THE-THEORY-OF-BECOMING.md': {'1. The root: continuation relative to a class'},
    f'{B}/THE-THEORY-OF-BECOMING.zh.md': {'1. 根：相对于类的续'},
    f'{B}/ONE-PAGE.zh.md': {'(before the first heading)'},
    f'{B}/COLLECTIVE-DIRECTION.md': {'7. Keeping the future open'},
    f'{C}/01-ROOT.md': {'4. Constancy and the core', '6. Renewal and grains'},
    f'{C}/02-MAP.md': {'1. The map on branches'},
    f'{C}/06-CLASSICAL-TEXTS.md': {'二、语料与归类', '三、定义：古文之定义写入文法', '八、文理生生：文为值之所历',
                                   '十、闭之类型与开之四标'},
    f'{C}/07-SIGNIFICANCE.md': {'2. The order with no premise', 'Open'},
    f'{C}/08-METHOD.md': {'2. Standings and bases', '12. The open programme'},
}
MINE = set(EXPECTED)
REASON = ("Item 13 of the twenty-first review (texts only): the grammar's 生生 written «生生» and 理 read as 03's lumping, "
          "the core of a class a 理 where the step's successor is fixed, and its 理 where every occurrence also has a "
          "successor, in the glossary, 01 (the core, renewal), 02 (the "
          "map on branches), 06 (corpus, definitions, 文理, the corpus's words in §十), 07 (the order with no premise), "
          "08 (the table of words), COLLECTIVE-DIRECTION's witness, the overview's root section (both editions) and the "
          "one page's Chinese edition; with the open item on a universal practical warrant restated as the question (07 "
          "and 08's open items); no record states, presupposes or bounds the rewritten lines; read before re-pointing")


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
assert not unexpected, ("drift outside the sections the kits write: read it, then settle it by hand", unexpected)

if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    summary = run_repoint(['--reason', REASON, '--drift-json', f.name])
    Path(f.name).unlink()
    print('repoint (texts):', summary['records'], 'records', 'written' if APPLY else '(dry run)')
else:
    print('repoint (texts): nothing to re-point')
