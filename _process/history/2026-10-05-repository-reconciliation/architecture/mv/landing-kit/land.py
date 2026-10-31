#!/usr/bin/env python3
"""MV's follow-up and README's first screen, the landing texts: from the checkout root, after main is merged and the
head clause is on the board, python3 -B <kit>/land.py SUITE REHEARSED 'ORDER', then make research-render.

SUITE is the test count of the clean rehearsal, REHEARSED its commit, ORDER the coordinator's order sentence as it stands
at landing ("Then, in the coordinator's order: …; ask the coordinator for a slot."). Appends the two study sections (MV's
first, at the study's last + 1), puts the landed entry in place of the head clause on the board's Queue line, replaces
RA's row clause, and adds the row in the history file. Each file is read whole before it is written."""
import ast
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
HISTORY = ROOT / '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
suite, rehearsed, order = sys.argv[1], sys.argv[2], sys.argv[3]
assert suite.isdigit() and re.fullmatch(r'[0-9a-f]{9,40}', rehearsed), (suite, rehearsed)
assert order.startswith("Then, in the coordinator's order: ") and order.endswith('ask the coordinator for a slot.'), order

# the head clause, as claim_head.py wrote it
tree = ast.parse((HERE / 'claim_head.py').read_text(encoding='utf-8'))
CLAUSE = next(ast.literal_eval(n.value) for n in tree.body if isinstance(n, ast.Assign) and getattr(n.targets[0], 'id', None) == 'CLAUSE')

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
secs = []
for i, name in enumerate(('section-mv-followup.txt', 'section-readme-first-screen.txt')):
    s = (HERE / name).read_text(encoding='utf-8')
    assert s.count('## NNN.') == 1, name
    s = s.replace('## NNN.', f'## {N + i}.').replace('SUITE tests', f'{suite} tests')
    assert not re.search(r'NNN|SUITE|FC_|NAMES_', s), name
    secs.append(s.strip('\n'))
STUDY.write_text(st.rstrip('\n') + '\n\n' + '\n\n'.join(secs) + '\n', encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
assert b.count(CLAUSE) == 1, 'the head clause is not on the board as claim_head.py wrote it'
landed = (f"MV's follow-up and the README's first screen landed (§{N} and §{N + 1}, no Lean in the package, no record "
          "statement and no core run: the attachment rule's third and fourth re-checks taken in both copies, twelve "
          "findings, each generated auxiliary read by the kind of declaration it attaches to and the kinds the dump lacks "
          "taken from the Lean check, none of the new shapes on the core dumps, so no figure, walk or reach changes "
          "(master_laws.py changing only its hashed inputs, and on the dumps of RF-M.3, HE2 and RR2 the same auxiliaries, "
          "walks and laws before and after the fourth re-check's fixes), 157 names each told as generated or not and 32 "
          "mutations each caught; README's first screen, four points before the opening with its figures and "
          "times filled at render, the opening's first-person body unchanged, a line before its notes saying they are "
          "written apart from it and follow the current account, five notes changed ([^ethics], [^good-evil], [^axiom] and "
          "[^own] brought to the current account, [^transitions]'s label to front pages naming no one) and a proposal "
          "to the body for Ren; eight records re-pointed in one rebinds line; three checks of the drafts and notes, 54 "
          "findings, 39 confirmed and taken, and one of the landing texts, 21 findings, 20 confirmed and taken; the row in "
          "the history file; render, strict check, links (0 broken) and the "
          f"{suite} tests pass in a clean worktree on {rehearsed[:9]}). {order} ")
b = b.replace(CLAUSE, landed)
ra = (HERE / 'ra-row-clause.txt').read_text(encoding='utf-8')
old = re.search(r'^OLD: (.*)$', ra, re.M).group(1)
new = re.search(r'^NEW: (.*)$', ra, re.M).group(1).replace('§M', f'§{N}').replace('§R', f'§{N + 1}')
assert b.count(old) == 1, "RA's row clause is not on the board as the kit has it"
b = b.replace(old, new)
BOARD.write_text(b, encoding='utf-8')

h = HISTORY.read_text(encoding='utf-8')
mark = '\n\n## Lapsed claims (18 October 2026)'
assert h.count(mark) == 1
row = ("| **MV's follow-up and README's first screen** (RA's line: the attachment rule's third and fourth re-checks, which "
       "landed after MV's boundary field as MV's, and the release gate's item 6, the README's first screen; "
       "[WHAT-REMAINS](../../research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md)). "
       "(1) Both copies of the attachment rule (`tools/research/boundary.py`, `boundary_check.lean`) read each generated "
       "auxiliary by the kind of declaration it attaches to: an opaque its own kind, lifted proofs under an inductive "
       "type, `_arg_pusher`, a nested type's auxiliaries, the functional induction and cases Lean realizes on use, "
       "a hygienic name read without its macro scopes and the name before it with them (in boundary.py as the dump "
       "prints it), and the kinds the dump lacks taken from the Lean check, which runs before D1 to D5; none of the new "
       "shapes occurs on the core dumps, so no figure, walk or reach changes: master_laws.py changes only its hashed "
       "inputs, and on the dumps of RF-M.3, HE2 and RR2 the auxiliaries, walks, forwarders, laws and root constants are "
       "the same before and after the fourth re-check's fixes. (2) README's first screen: four points before the opening (what the theory is, the two "
       "premises of its ethics by role, where to start, with the reading times of the one page, the overview and the "
       "opening, what is tested), every figure and "
       "time filled at render, 172 words; OPENING's first-person body unchanged, a line before its notes saying they are "
       "written apart from it and follow the current account, five notes changed ([^ethics], [^good-evil], [^axiom] and "
       "[^own] brought to the current account, [^transitions]'s label to front pages naming no one), and "
       "[a proposal to the body](../../../drafts/2026-10-10-opening/OPENING-V13-PROPOSAL.md) for Ren. No Lean in the "
       "package, no record statement, no core run "
       "| Claude Code desktop session \"Theory status and claims\" (31 October 2026) "
       f"| landed 2026-10-31 (study §{N} and §{N + 1}; on the coordinator's order, after RR2, the front pages' correction, "
       "fm-rf3, BD and RF's tests' designs): the third re-check's eight findings and the fourth's four taken, 157 names (70 generated, 87 not) "
       "each told as the tests expect and 32 mutations each caught; the coordinator's two front-page requests (no person or AI named, a tightening pass from "
       "205 to 172 words) and the coordinator's condition for [^transitions]'s plain label (the line before the notes); "
       "three checks of the study drafts and the notes, 54 findings, 39 confirmed and taken, 15 refuted; a check of the "
       "three landing texts, 21 findings, 20 confirmed and taken "
       "([report](../../research/2026-10-05-repository-reconciliation/architecture/mv/reports/landing-texts-check.json)); "
       "eight records "
       "re-pointed in one rebinds line; render, strict check, links (0 broken) and the "
       f"{suite} tests pass in a clean worktree on {rehearsed[:9]} "
       "| [architecture/mv/](../../research/2026-10-05-repository-reconciliation/architecture/mv/BOUNDARY-FIELD.md), "
       "[ra-first-screen/](../../research/2026-10-05-repository-reconciliation/architecture/ra-first-screen/design.json) "
       f"| BOUNDARY-FIELD §3.0, §3.2, §3.6, §8, §9, OPENING, 07 §4, §4.6, 08 §12 → boundary.py, boundary_check.lean, "
       f"README's first screen, OPENING's notes, study §{N}, §{N + 1} |")
i = h.index(mark)
assert h[:i].rstrip('\n').splitlines()[-1].startswith('| **'), 'the table does not end where the kit expects'
HISTORY.write_text(h[:i].rstrip('\n') + '\n' + row + h[i:], encoding='utf-8')
print('STUDY_SECTIONS', N, N + 1)
