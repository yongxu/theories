#!/usr/bin/env python3
"""DF3 batch A landing texts: python3 -B <kit>/land_df3.py (from the checkout root), then make research-render and
generative_chain.py --record-review for the eight sources df3/chain-section.md records.

No Lean changed, so no checker runs. Appends the study section (the study's last + 1); sets the section number in
the thirty records' DF3 history notes; appends the chain section to the chain's index record; ends each
DEFECTS-FOUND entry DF2 left for the schema-2 migrations with what became of it; brings LEFT, the plan and the kit
README up to date; puts DF3's landed entry at the head of the board's queue line and its outcome in the RA row."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAIN = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/GENERATIVITY-CHAIN-INDEX-RECORD.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
RECORDS = ROOT / 'theories/becoming/results/records'
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
IDS = list(json.loads((HERE / 'df3/snapshots.json').read_text()))

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_df3.txt').read_text(encoding='utf-8').replace('## NNN.', f'## {N}.')
assert 'NNN' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

for i in IDS:
    p = RECORDS / f'{i}.json'
    t = p.read_text(encoding='utf-8')
    assert t.count('DF_N') == 2, i
    p.write_text(t.replace('DF_N', str(N)), encoding='utf-8')
assert not [p.name for p in RECORDS.glob('*.json') if 'DF_N' in p.read_text(encoding='utf-8')]

c = CHAIN.read_text(encoding='utf-8')
cs = (HERE / 'df3/chain-section.md').read_text(encoding='utf-8').replace('NNN', str(N))
assert 'df3-chain-review-28-october-2026' not in c and 'gc-chain-review-28-october-2026' in c
CHAIN.write_text(c.rstrip('\n') + '\n\n' + cs.strip('\n') + '\n', encoding='utf-8')

LEFT_LAWS = 'their laws arrays are still left, for the schema-2 migrations ([LEFT](df/LEFT.md)).*'
PLAN = '([plan](df/DF3-PLAN.md))'
DONE = {
    'Several pre-spine records describe retired modules': f'the five records migrated to schema 2, each law read against its core declarations {PLAN}.',
    'Pre-spine records whose digest has no laws': 'the twelve records migrated to schema 2 with laws arrays.',
    'In the digests (digests/map.json)': ('the ten in batch A migrated to schema 2 with laws arrays; endpoint-loss-and-return, '
                                          'open-form-realization-under-revision and versioned-request-completion are in batch B ' + PLAN + '.'),
    'The earlier frame and periphery records': ('effective-capacity-and-eventual-reachability, control-coherence-loss, renewing-consuming-formation, '
                                                'growth-constrained-fragmentation and pending-task-context-applicability migrated to schema 2 with laws '
                                                'arrays, each read hypothesis by hypothesis; endpoint-loss-and-return is in batch B ' + PLAN + '.'),
    'joint-plan-composition:': 'migrated to schema 2 with laws arrays, the core Keeping laws first.',
    'draws-on-a-shared-stock and joint-practice-forms-continuation': ('draws-on-a-shared-stock migrated to schema 2 with laws arrays; '
                                                                      'joint-practice-forms-continuation is in batch B ' + PLAN + '.'),
}
t = DEFECTS.read_text(encoding='utf-8')
lines = t.split('\n')
for start, what in DONE.items():
    hit = [k for k, l in enumerate(lines) if l.startswith('- ' + start)]
    assert len(hit) == 1, (start, hit)
    k = hit[0]
    assert lines[k].rstrip().endswith(LEFT_LAWS) and '*DF3' not in lines[k], start
    lines[k] = lines[k].rstrip() + f' *DF3 (study §{N}): {what}*'
hit = [k for k, l in enumerate(lines) if l.startswith('Status after board item DF (25 October 2026')]
assert len(hit) == 1
lines[hit[0]] = (lines[hit[0]].rstrip() + f' DF3 (28 October 2026, study §{N}) migrated to schema 2, with laws arrays, the '
                 'thirty schema-1 records DF1 named; each entry it took ends with what became of it, after "DF3".')
DEFECTS.write_text('\n'.join(lines), encoding='utf-8')

LEFT = HERE / 'LEFT.md'
s = LEFT.read_text(encoding='utf-8')
old = [l for l in s.split('\n') if l.startswith('- Schema-2 migrations with laws arrays for the schema-1 records whose rows proposed laws')]
assert len(old) == 1
s = s.replace(old[0], (f'- Batch B of the schema-2 migrations ([plan](DF3-PLAN.md)): the 87 schema-1 records DF3 (study §{N}) did not take, '
                       '46 of them without a statement and 33 fingerprinted by the generativity chain, among them '
                       'endpoint-loss-and-return, open-form-realization-under-revision, versioned-request-completion and '
                       'joint-practice-forms-continuation. Batch A (the thirty DF1 named) is migrated.'))
s = s.replace('DF2 (27 October 2026) made the 33 missing-record rows into thirty records, gave the two records with no statement their '
              'statements, and added decision D69; what DF1 and DF2 leave is below.',
              'DF2 (27 October 2026) made the 33 missing-record rows into thirty records, gave the two records with no statement their '
              f'statements, and added decision D69; DF3 (28 October 2026, study §{N}) migrated the thirty schema-1 records DF1 named to '
              'schema 2; what DF leaves is below.')
assert f'study §{N}) migrated the thirty' in s
LEFT.write_text(s, encoding='utf-8')

P = HERE / 'DF3-PLAN.md'
s = P.read_text(encoding='utf-8')
assert s.startswith('# DF3: the plan (proposed, not claimed)')
s = s.replace('# DF3: the plan (proposed, not claimed)', f'# DF3: the plan (batch A landed, study §{N})', 1)
s = s.rstrip('\n') + ('\n\n## Batch A, measured\n\n'
                      'Batch A landed on 28 October 2026 (study §' + str(N) + '). Two figures differ from the estimates above:\n\n'
                      '- **Agents:** ten in all: four migrators, four reviewers, two cold readers.\n'
                      '- **Subagent tokens:** 4.3M (3.46M for migration and review in 75 minutes, 0.87M for the cold read), '
                      'more than the 2.5–3.5M estimated.\n\n'
                      'At that rate, batch B (87 records) would take about 12–13M tokens in three region batches.\n')
P.write_text(s, encoding='utf-8')

R = HERE / 'README.md'
s = R.read_text(encoding='utf-8')
assert 'DF3 migrated' not in s
s = s.rstrip('\n') + ('\n\nDF3 migrated to schema 2, with laws arrays, the thirty schema-1 records DF1 named (batch A; [LEFT](LEFT.md) says what '
                      'it leaves):\n\n'
                      '- [`DF3-PLAN.md`](DF3-PLAN.md): the units, the method, the chain and the cost, with batch A as measured.\n'
                      '- `df3/snapshots.json` the text_versions entries of the snapshots taken first, `df3/triage-rows.json` the triage rows '
                      'bearing on each record, `df3/chain-notes.md` the division with the chain review (GC), `df3/chain-section.md` the '
                      'chain index record\'s DF3 section; `df3-mapping/<id>.md` every earlier sentence of each record and where it went.\n'
                      '- `workflows/9-df3-migrate.js`: the four migrators and four reviewers, as run; '
                      '[`reports/df3-migrate-review.json`](reports/df3-migrate-review.json) their returns (148 review edits); `df3_apply.py` '
                      'the edits and twelve home-section edits as applied; [`reports/df3-cold-read.json`](reports/df3-cold-read.json) the '
                      'cold read of the applied state (33 findings) and `df3_coldfix.py` what was taken from it, with the rule; '
                      '`df3_caps.py` two Chinese evidence paragraphs within the cap.\n'
                      '- `land_df3.py`: the landing texts (study section, history notes, the chain section, DEFECTS-FOUND\'s marks, LEFT, '
                      'the plan, the board).\n')
R.write_text(s, encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
q = '- **Queue:** '
assert b.count(q) == 1
landed = (f'DF3 batch A landed (the thirty schema-1 records DF1 named, migrated to schema 2 with 224 laws, each read against '
          f'its declarations, and their limitations as typed does-not-show items; the home sections in 01, 02, 05 and 07 '
          f'corrected where the Lean says less or more; the chain\'s eight fingerprinted records read, two pages held for '
          f'proposals A4 and A5 on M20; no Lean, no checker run; study §{N}); ')
b = b.replace(q, q + landed, 1)
claim = re.findall(r"\*\*DF3 claimed\*\* \(28 October 2026, \[plan\]\(research/2026-10-05-repository-reconciliation/architecture/df/DF3-PLAN\.md\)\): .*?batch B, the other 87, proposed after A lands\. ", b)
assert len(claim) == 1, claim
b = b.replace(claim[0], (f'DF3 batch A landed 28 October 2026 (study §{N}, [plan](research/2026-10-05-repository-reconciliation/architecture/df/DF3-PLAN.md)): '
                         'the thirty schema-1 records DF1 named, migrated to schema 2 with laws arrays; batch B, the other 87 '
                         '(about 12–13M tokens at batch A\'s measured rate), is proposed to Ren. **Next on RA\'s line: MV**, a '
                         'view computed from the Lean dependencies of the master law and category each law of a record rests on '
                         '(not written into records), to start after OU3c\'s and fork 2\'s changes to measure_grammar.py land, '
                         'on fork 2\'s version. '))
old = re.findall(r"DF3: the schema-2 migrations, with laws arrays, of the thirty schema-1 records DF1's editors named \(batch A, approved and claimed 28 October 2026; the other 87 are batch B, proposed after A\)\.", b)
assert len(old) == 1
b = b.replace(old[0], f"DF3: batch A landed (study §{N}); batch B, the other 87 schema-1 records, is proposed with batch A's measured cost.")
BOARD.write_text(b, encoding='utf-8')
print('STUDY_SECTION', N)
