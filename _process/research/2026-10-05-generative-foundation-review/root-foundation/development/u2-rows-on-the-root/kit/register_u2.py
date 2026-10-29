#!/usr/bin/env python3
"""U2: register the apart roots the connectivity check lists without a reason that are U2's, each with a category and
a reason; stop on any other root, which belongs to its owner, and on a stale entry, which U2 does not expect.

* Three of U2's readings stand apart: the rows stated on their own carriers whose rows are themselves laws of every
  valuation, family of ideals or selection of functions (Valuation, Ideals, Learning). Each reading states its row
  through the grammar's relations on that carrier and is proved through the row; nothing uses it, and the base supplies
  no reading of the carrier (general structure). The other readings reach the base through their rows or their models.

Textual edits, the rest of the file byte for byte (register_wrp2.py's pattern).
usage (from the checkout root): python3 -B register_u2.py CONNECTIVITY_LOG"""
import json
import re
import sys
from pathlib import Path

F = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json')
log = Path(sys.argv[1]).read_text(encoding='utf-8')
m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
unclassified = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
stale = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
stale_names = [] if not stale else [s.strip().strip("'\"") for s in stale.group(1).strip('[]').split(',') if s.strip()]
assert not stale_names, ('stale entries: U2 retires none; their owners do', stale_names)
M = 'Becoming.ModelStatements.'
reasons = {
    M + 'significant_iff_held_reading': (
        "ModelStatements.significant_iff_held_reading: the row Valuation.significant_iff_held through the partial "
        "identities of regions of claims: where living lies within the positions' own regions, living lies within "
        "every position's significance exactly where each position's own living lies within its significance and "
        "what is living and significant from one position is significant from every other; a law of every valuation of any claims, "
        "stated on its own carrier; the base supplies no reading of claims, positions or significance (the theory "
        "states them as conditions) (U2)"),
    M + 'verifiableBy_reading': (
        "ModelStatements.verifiableBy_reading: the row Ideals.verifiableBy_iff_interior through membership of points "
        "in stretches: a reading is verifiable exactly where each point it holds bears membership to a stretch every "
        "bearer of which it holds; a law of every family of ideals of any order, stated on its own carrier; the base "
        "supplies no reading of an order's ideals (at runs they are the finite stretches) (U2)"),
    M + 'unselected_beyond_data_reading': (
        "ModelStatements.unselected_beyond_data_reading: the row Learning.Training.unselected_beyond_data through "
        "agreeing on the data: with the selection closed along that agreement and the class free at a point beyond "
        "the data, a selected member is related to every member by agreeing on the data with a selected member then "
        "alike at the point; a law of every class and selection of functions on any types, stated on its own "
        "carrier; the base supplies no reading of functions or data (U2)"),
}
others = [n for n in unclassified if n not in reasons]
assert not others, ("apart roots not registered here: read them; another session's belong to their owners", others)
t = F.read_text(encoding='utf-8')
block = ''
for name in unclassified:
    assert json.dumps(name, ensure_ascii=False) not in t, name
    block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.ModelStatements",\n'
              '   "category": "general-structure",\n   "reason": ' + json.dumps(reasons[name], ensure_ascii=False)
              + '\n  },\n')
if block:
    anchor = '  }\n },\n "instances": {'
    assert t.count(anchor) == 1
    t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
    json.loads(t)
    F.write_text(t, encoding='utf-8')
print('register: added', len(unclassified), unclassified)
