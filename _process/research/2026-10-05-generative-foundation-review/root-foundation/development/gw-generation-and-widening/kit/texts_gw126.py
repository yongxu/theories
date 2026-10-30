#!/usr/bin/env python3
"""GW1, GW2 and GW6's landing texts: 08's counts at the receipt (computed from it), study section N in
BECOMING-RENEWAL-READING.md, the note's landing line, the board's landed clause and latest receipt, and the GW1, GW2
and GW6 row moved from the board to the history file's landed rows after the row of AFTER (links made relative to
that file). Each edit is asserted to apply exactly once.
usage (from the checkout root): python3 -B <kit>/texts_gw126.py RECEIPT N AFTER MEASURE
  AFTER    the bold title opening the history row to insert after, e.g. "UE23: seeking"
  MEASURE  the measure sentence for the study section"""
import json
import re
import sys
from pathlib import Path

RECEIPT, N, AFTER, MEASURE = sys.argv[1:5]
RF = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation')
G = RF / 'development/gw-generation-and-widening'
KIT = G / 'kit'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (str(path), old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


rec = json.loads(Path(f'{PKG}/becoming-checks/{RECEIPT}/verification.json').read_text(encoding='utf-8'))
assert rec['status'] == 'passed'
mods = rec['modules']
by = {m['module']: m for m in mods}
layers = {}
for m in mods:
    layers[m['layer']] = layers.get(m['layer'], 0) + 1
ring = layers.get('instance', 0) + layers.get('application', 0)
theorems = sum(m['theorems'] for m in mods)
core_theorems = sum(m['theorems'] for m in mods if m['layer'] == 'core')
decls = sum(len(m['declarations']) for m in mods)
MR, WM = by['Becoming.MapRegions'], by['Becoming.WideningOnTheMap']
COUNTS = (f'Becoming.MapRegions ({MR["theorems"]} theorems in {len(MR["declarations"])} declarations) and '
          f'Becoming.WideningOnTheMap ({WM["theorems"]} in {len(WM["declarations"])})')

import os
# BOARD_ONLY=1 runs only the board and history steps (the earlier ones assert they have not yet applied)
BOARD_ONLY = os.environ.get('BOARD_ONLY') == '1'

# 08's counts
m08 = Path('theories/becoming/chapters/08-METHOD.md')
text = m08.read_text(encoding='utf-8')
pat = re.compile(r'At core receipt \[`[0-9T.Z]+`\]\(\.\./\.\./\.\./' + re.escape(PKG) + r'/becoming-checks/[0-9T.Z]+/verification\.json\) \(Lean 4\.29\.1\), the closure held [0-9,]+ modules \([0-9]+ foundation, [0-9]+ core, [0-9]+ in the instance and application ring\) and [0-9,]+ theorems; the [0-9]+ core modules held [0-9,]+ of them; [0-9,]+ declarations were audited;')
assert BOARD_ONLY or len(pat.findall(text)) == 1
text = text if BOARD_ONLY else pat.sub(f'At core receipt [`{RECEIPT}`](../../../{PKG}/becoming-checks/{RECEIPT}/verification.json) (Lean 4.29.1), the closure held '
               f'{len(mods)} modules ({layers["foundation"]} foundation, {layers["core"]} core, {ring} in the instance and application ring) '
               f'and {theorems:,} theorems; the {layers["core"]} core modules held {core_theorems:,} of them; {decls:,} declarations were audited;', text)
m08.write_text(text, encoding='utf-8')

# the study section
study = (KIT / 'study_gw126.txt').read_text(encoding='utf-8')
study = study.replace('## SECTION.', f'## {N}.', 1).replace('`RECEIPT`', f'`{RECEIPT}`').replace('COUNTS', COUNTS)
study = study.replace('MEASURE', MEASURE)
assert 'SECTION' not in study and 'COUNTS' not in study and 'MEASURE' not in study and '`RECEIPT`' not in study
reading = RF / 'BECOMING-RENEWAL-READING.md'
text = reading.read_text(encoding='utf-8')
if not BOARD_ONLY:
    assert f'\n## {int(N) - 1}.' in text and f'\n## {N}.' not in text, 'section number'
    reading.write_text(text.rstrip('\n') + '\n\n' + study.rstrip('\n') + '\n', encoding='utf-8')

# the note's landing line
if not BOARD_ONLY:
    edit(G / 'NOTE.md', '''Figures at the build (`scratch_build.py`):''',
         f'''The core checker passed at landing, at receipt `{RECEIPT}` (study §{N}); the two modules are new leaves, so no earlier statement changed. Figures at the build (`scratch_build.py`):''')

# the board
board = Path('_process/BECOMING-WORKBOARD.md')
text = board.read_text(encoding='utf-8')
head = re.search(r'- \*\*Queue:\*\* GW1, GW2 and GW6 at the head of the queue \(landing now: [^)]*\); ', text)
assert head, 'head clause'
landed = (f'- **Queue:** GW1, GW2 and GW6 landed (§{N}, core receipt `{RECEIPT}`: the map\'s regions, and widening on '
          'the map both ways. In Becoming.MapRegions, a core leaf: the split of a beginning on the root; keeping from '
          'some point on, with which excluded middle makes the three regions cover, on single lines exactly one; '
          'Map.Once, the gap strict keeping leaves, so 02\'s open item closes; on a single line deciding 后守 gives LPO '
          'and deciding 生成 WLPO. In Becoming.WideningOnTheMap, a core leaf: on a course\'s moments, with nothing lost '
          'in the coarse place and the same possible in the fine, keeping widening is 全生成 both ways under two '
          'premises, a representation since nothing lost is widening\'s inclusion half; with the classes fixed apart it '
          'is generation under the one that loses nothing, so what parts them is exactly loss, the release gate\'s '
          'item 2 met by the split stated; the premises exactly weak excluded middle forward and excluded middle back, '
          'Markov\'s principle on decided chains; by name, each admitted formation kept on the occurrences while the '
          f'course\'s moments are 全生成, two carriers. {COUNTS}, every axiom report empty; two records, 02 §1, 07 §2, '
          "01 §6, the overview, D1, D65, the glossary and 08's counts; the review packet's L-10 brought up to the Lean; one independent review, every finding taken; "
          "row in the history file). Then, in the coordinator's order: UE24, RR's Lean, item 13 with LW's follow-up, RV21b, AJ6b; ask the coordinator for a slot. ")
text = text.replace(head.group(0), landed)
# the earlier clause's order sentence is superseded by this one: drop it, printed for review
qline = [l for l in text.split('\n') if l.startswith('- **Queue:**')]
assert len(qline) == 1
rest = qline[0][len(landed):]
stale = re.findall(r"\)\. Then, in the coordinator's order: [^;]*; ask the coordinator for a slot[;.] ", rest)
for s in stale:
    print('dropped an earlier order sentence:', s)
    rest = rest.replace(s, '); ', 1)
text = text.replace(qline[0], landed + rest)
old_latest = re.search(r"the latest core receipt is [^`]*`[0-9T.Z]+` \([0-9]+ October 2026\)", text)
assert old_latest and text.count(old_latest.group(0)) == 1
text = text.replace(old_latest.group(0), f"the latest core receipt is GW1, GW2 and GW6's `{RECEIPT}` (30 October 2026)")
rows = [l for l in text.split('\n') if l.startswith("| **GW1, GW2 and GW6: the map's regions")]
assert len(rows) == 1
row = rows[0]
text = text.replace(row + '\n', '')
board.write_text(text, encoding='utf-8')

# the history file's landed rows
hist = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
cells = row.split(' | ')
assert len(cells) == 5, len(cells)
cells[0] = ("| **GW1, GW2 and GW6: the map's regions, and widening on the map both ways** (GW's "
            '[note](research/2026-10-05-generative-foundation-review/root-foundation/development/gw-generation-and-widening/NOTE.md) '
            '§§3.1, 9, 10 and 18; [WHAT-REMAINS](research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md), '
            '"OU\'s decisions on U4 and on GW1–GW2", and the release gate\'s item 2). GW1: keeping from some point on '
            '(`«后守»`), with which excluded middle makes the three regions cover; `Map.Once`, the gap strict keeping '
            'leaves; on a single line deciding 后守 gives LPO and deciding 生成 WLPO. GW2: the split of a beginning on the '
            'root. GW6 (added at the claim): on a course\'s moments keeping widening is 全生成 at (nothing lost, the same '
            'possible) both ways under two premises, a representation; with the classes fixed apart it is generation '
            'under the one that loses nothing, parted from it by exactly loss; the premises calibrated; by name, kept '
            'on the occurrences while the moments are 全生成, two carriers')
cells[2] = (f'landed 2026-10-30 at core receipt `{RECEIPT}`, study §{N}: {COUNTS}, every axiom report empty, both new '
            'leaves; REVIEW-GW126-LEAN, every finding taken; OU\'s two checks answered. For the next rebuild of '
            '`Becoming.GrammarMap` or `Becoming.Arising`: the reach lemmas twice over (`Map.step_reached_le`, '
            '`Steps.reached_le`, HeldPossible\'s local `reached_le` and `reach_to`), and GrammarMap\'s docstring sentence '
            'that how the strong forms stand to 生成, 守 and 退化 "is not stated", which MapRegions now states')
new_row = ' | '.join(cells)
new_row = re.sub(r'\]\((research/)', r'](../../\1', new_row)
new_row = re.sub(r'\]\(\.\./(theories|sources)/', r'](../../../\1/', new_row)
htext = hist.read_text(encoding='utf-8')
prev = [l for l in htext.split('\n') if l.startswith(f'| **{AFTER}')]
assert len(prev) == 1, (AFTER, len(prev))
htext = htext.replace(prev[0] + '\n', prev[0] + '\n' + new_row + '\n')
hist.write_text(htext, encoding='utf-8')
print('texts written:', COUNTS, len(mods), theorems, core_theorems, decls)
