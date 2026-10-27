#!/usr/bin/env python3
"""DF2 landing texts after a passing core checker: python3 -B <kit>/land_df2.py (from the checkout root), then
make research-render.

Appends the study section (the study's last + 1) with the core receipt; dates the thirty new records' history 27
October and sets the section number in every DF2 history note and in DEFECTS-FOUND's DF2 marks; ends each entry DF1
left for DF2 with what became of it; puts DF2's landed entry at the head of the board's queue line, its receipt in
the board's receipts line and its outcome in the RA row's DF cell."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
CORE = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
RECORDS = ROOT / 'theories/becoming/results/records'
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'

R = json.loads(CORE.read_text())
assert R['status'] == 'passed' and R['core_axioms'] == []
rid = R['utc']
assert json.loads((CORE.parent / 'becoming-checks' / rid / 'verification.json').read_text())['status'] == 'passed'

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_df2.txt').read_text(encoding='utf-8')
sec = sec.replace('## NNN.', f'## {N}.').replace('CRECEIPT', f'`{rid}`')
assert 'NNN' not in sec and 'CRECEIPT' not in sec and 'RECHECK' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

noted = []
for p in sorted(RECORDS.glob('*.json')):
    t = p.read_text(encoding='utf-8')
    if 'DF_N' in t:
        assert t.count('DF_N') == 2 and 'DF2' in t, p.name
        t = t.replace('26 October 2026: added (DF2)', '27 October 2026: added (DF2)')
        t = t.replace('2026年10月26日：新增（DF2）', '2026年10月27日：新增（DF2）')
        p.write_text(t.replace('DF_N', str(N)), encoding='utf-8')
        noted.append(p.stem)
assert len(noted) == 33, len(noted)

t = DEFECTS.read_text(encoding='utf-8')
assert t.count('DF_N') == 7
t = t.replace('DF_N', str(N))
LEFT_LAWS = 'their laws arrays are still left, for the schema-2 migrations ([LEFT](df/LEFT.md)).'
RENAME = ('the rename is not made: rename_ids.py refuses it, since the generativity chain\'s record names the id, so '
          'it waits on the chain\'s maintenance record.')
DONE = {
    'Several pre-spine records describe retired modules': LEFT_LAWS,
    "The grammar's interpretive readings": "D69 in DELEGATED-CHOICES (both editions), cited by 01's labels.",
    'Pre-spine records whose digest has no laws': 'statements for least-footprint-where-idleness-decided and '
                                                  'normal-forms-need-decided-apartness; ' + LEFT_LAWS,
    'becoming-renewal-reading joins': 'the record significance-through-a-common-condition, at home in 07 §3.1; '
                                      'becoming-renewal-reading keeps the run-class laws, and its statement says so.',
    'In the digests (digests/map.json)': LEFT_LAWS,
    'The earlier frame and periphery records': LEFT_LAWS,
    'Links to other chapters use record anchors': "02 links 07's anchor r-significance-through-a-common-condition.",
    'selection-under-registration-revision keeps': RENAME,
    'Several spine §9 items have no record': 'records when-to-inquire-and-when-to-respond and '
                                             'readings-a-response-needs, whose second law is that success changes the '
                                             'next response.',
    'formed-copying-registration: the record id': RENAME,
    'Sections 8 and 9 (organization within organisms': 'records recurrence-without-selector-revision, '
                                                       'equal-totals-can-hide-what-a-capacity-carries, the-updater-line '
                                                       'and same-carrier-need-not-fix-the-response.',
    'joint-plan-composition:': LEFT_LAWS,
    'draws-on-a-shared-stock and joint-practice-forms-continuation': LEFT_LAWS,
    'New result without a record: §9.9': 'record reach-from-a-seed, its anchor in 01 §9.9.',
    'Carried results with no record': 'records for the ten (certificates-sound-and-available, '
                                      'adaptive-closure-cannot-resolve, evidence-through-change, '
                                      'correction-is-not-calibration, learning-a-rule-by-narrowing, '
                                      'readings-a-response-needs, composition-route, what-a-total-keeps, '
                                      'access-yet-to-form, one-move-covering), their axiom labels as the receipts '
                                      'report them for the declarations cited.',
    'Records needed: several results now stated in 04': 'records for the seven '
                                                        '(stronger-arrangement-formed-by-reconfiguration, '
                                                        'a-selected-template-need-not-raise-structure, '
                                                        'groups-formed-by-bonds-share-a-founder, '
                                                        'recurrence-without-selector-revision, '
                                                        'equal-totals-can-hide-what-a-capacity-carries, '
                                                        'the-updater-line, same-carrier-need-not-fix-the-response).',
    'Records to create (results that are checked': 'records for the five (market-model-share-margin-and-ends, '
                                                   'joint-plans-from-a-supported-start, '
                                                   'a-swap-symmetric-assignment-singles-out-none, '
                                                   'reviewers-count-by-independent-causes, '
                                                   "succession-on-a-funded-carrier); 05's Open item for them is closed.",
    'regions.json and the graph: 07 is now home': 'record finite-agreement-does-not-identify-priority, at home in 07 §5.',
    '08 now states results that have no records': 'records for the five (what-a-summary-keeps, one-move-covering, '
                                                  'type-formation-gives-no-dynamics, '
                                                  'contraction-where-duplication-is-reachable, '
                                                  'self-reference-does-not-certify-itself), anchored in 08.',
}
lines = t.split('\n')
for start, what in DONE.items():
    hit = [i for i, l in enumerate(lines) if l.startswith('- ' + start)]
    assert len(hit) == 1, (start, hit)
    i = hit[0]
    assert 'DF2' in lines[i] and '*DF2 (study' not in lines[i], start
    lines[i] = lines[i].rstrip() + f' *DF2 (study §{N}): {what}*'
hit = [i for i, l in enumerate(lines) if l.startswith('Status after board item DF (25 October 2026')]
assert len(hit) == 1
lines[hit[0]] = (lines[hit[0]].rstrip() + f' DF2 (27 October 2026, study §{N}) made the records still missing; each '
                 'entry it took ends with what became of it, after "DF2".')
DEFECTS.write_text('\n'.join(lines), encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
claim = ('DF2 holds the head of the queue (DF, under RA: the thirty records the chapters state without one, their home '
         "sections' corrections, two statements, D69, the package's layer labels and Closing.lean's header comment; the "
         'core checker passed on the branch, to be rerun on main before landing); ')
assert b.count(claim) == 1
landed = (f'DF2 landed (the thirty records the chapters stated without one, each anchored in its home section with its '
          f"regions entry, and the home sections corrected where they said more or less than the Lean; statements for "
          f"two records; D69 for the grammar's readings; L0 the World with its imports, every layer label agreeing with "
          f"the layer computed; Closing.lean's header comment; core receipt `{rid}`, study §{N}); ")
b = b.replace(claim, landed)
recline = re.findall(r'the latest core receipt is [^`]*`\d{8}T\d{6}\.\d{6}Z` \(\d+ October 2026\)', b)
assert len(recline) == 1, recline
b = b.replace(recline[0], f"the latest core receipt is DF2's `{rid}` (27 October 2026)")
rows = [l for l in b.split('\n') if l.startswith('| **RA: repository architecture**')]
assert len(rows) == 1
row = rows[0]
old = ("**DF2 next** ([left](research/2026-10-05-repository-reconciliation/architecture/df/LEFT.md)): the 33 records "
       "still missing, two statements, schema-2 migrations with laws, two ids in the retired registration sense, a "
       "decision entry for the grammar's readings.")
assert row.count(old) == 1
new = (f"DF2 landed 27 October 2026 (core receipt `{rid}`, study §{N}): the thirty records the chapters stated without "
       f"one, with their anchors, regions entries and the home sections' corrections; two statements; D69; the "
       f"package's layer labels. **Left** ([left](research/2026-10-05-repository-reconciliation/architecture/df/LEFT.md)): "
       f"the schema-2 migrations with laws; two ids in the retired registration sense, whose renames wait on the "
       f"generativity chain's maintenance record.")
BOARD.write_text(b.replace(row, row.replace(old, new)), encoding='utf-8')
print('STUDY_SECTION', N, 'CORE_RECEIPT', rid)
