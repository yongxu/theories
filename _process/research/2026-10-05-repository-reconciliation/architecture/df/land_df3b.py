#!/usr/bin/env python3
"""DF3 batch B landing texts: python3 -B <kit>/land_df3b.py (from the checkout root), then make research-render and
generative_chain.py --record-review for the sources df3b/chain-section.md records.

No Lean changed, so no checker runs. Appends the study section (the study's last + 1); sets the section number in
the 87 records' batch-B history notes; appends the chain section to the chain's index record; ends each
DEFECTS-FOUND entry batch A left for batch B with what became of it; brings LEFT, the plan and the kit README up to
date; puts batch B's landed entry in place of its claim on the board's queue line and its outcome in the RA row."""
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
IDS = list(json.loads((HERE / 'df3b/snapshots.json').read_text()))
assert len(IDS) == 87

st = STUDY.read_text(encoding='utf-8')
N = max(int(m) for m in re.findall(r'^## (\d+)\. ', st, re.M)) + 1
sec = (HERE / 'study_df3b.txt').read_text(encoding='utf-8').replace('## NNN.', f'## {N}.')
assert 'NNN' not in sec
STUDY.write_text(st.rstrip('\n') + '\n\n' + sec.strip('\n') + '\n', encoding='utf-8')

for i in IDS:
    p = RECORDS / f'{i}.json'
    t = p.read_text(encoding='utf-8')
    assert t.count('DF_N') == 2, (i, t.count('DF_N'))
    p.write_text(t.replace('DF_N', str(N)), encoding='utf-8')
assert not [p.name for p in RECORDS.glob('*.json') if 'DF_N' in p.read_text(encoding='utf-8')]

c = CHAIN.read_text(encoding='utf-8')
cs = (HERE / 'df3b/chain-section.md').read_text(encoding='utf-8')
cs = re.sub(r'^<!--.*?-->\n', '', cs, flags=re.S).replace('NNN', str(N))
assert 'df3b-chain-review-29-october-2026' not in c and 'df3-chain-review-28-october-2026' in c
CHAIN.write_text(c.rstrip('\n') + '\n\n' + cs.strip('\n') + '\n', encoding='utf-8')

DONE = {
    'In the digests (digests/map.json)': 'endpoint-loss-and-return, open-form-realization-under-revision and versioned-request-completion migrated to schema 2 with laws arrays.',
    'The earlier frame and periphery records': 'endpoint-loss-and-return migrated to schema 2 with laws arrays.',
    'draws-on-a-shared-stock and joint-practice-forms-continuation': 'joint-practice-forms-continuation migrated to schema 2 with laws arrays.',
}
t = DEFECTS.read_text(encoding='utf-8')
lines = t.split('\n')
for start, what in DONE.items():
    hit = [k for k, l in enumerate(lines) if l.startswith('- ' + start)]
    assert len(hit) == 1, (start, hit)
    k = hit[0]
    assert 'in batch B' in lines[k] and '*DF3 batch B' not in lines[k], start
    lines[k] = lines[k].rstrip() + f' *DF3 batch B (study §{N}): {what}*'
hit = [k for k, l in enumerate(lines) if l.startswith('Status after board item DF (25 October 2026')]
assert len(hit) == 1
lines[hit[0]] = lines[hit[0]].rstrip() + f' DF3 batch B (29 October 2026, study §{N}) migrated the other 87 schema-1 records; every record is now on schema 2.'
DEFECTS.write_text('\n'.join(lines), encoding='utf-8')

LEFT = HERE / 'LEFT.md'
s = LEFT.read_text(encoding='utf-8')
old = [l for l in s.split('\n') if l.startswith('- Batch B of the schema-2 migrations')]
assert len(old) == 1
s = s.replace(old[0] + '\n', '')
s = s.replace('schema 2; what DF leaves is below.', f'schema 2, and DF3 batch B (29 October 2026, study §{N}) the other 87, so every record is on schema 2; what DF leaves is below.')
assert f'study §{N}) the other 87' in s
LEFT.write_text(s, encoding='utf-8')

P = HERE / 'DF3-PLAN.md'
s = P.read_text(encoding='utf-8')
s = re.sub(r'^# DF3: the plan \(batch A landed, study §(\d+)\)', lambda m: f'# DF3: the plan (batch A landed, study §{m.group(1)}; batch B landed, study §{N})', s, count=1, flags=re.M)
assert f'batch B landed, study §{N}' in s
s = s.rstrip('\n') + ('\n\n## Batch B, measured\n\n'
                      f'Batch B landed on 29 October 2026 (study §{N}).\n\n'
                      '- **Agents:** 13 migrators and 13 reviewers, in units by region, and 4 for the cold read: 3 readers and 1 chain reader. '
                      'Two network outages stopped 11 agents, and the five reviews and three migrations they had not finished were rerun.\n'
                      '- **Subagent tokens:** about TOKENS in all, more than the 12–13M estimated, because of the outages and the larger records.\n\n'
                      'Every result record is now on schema 2. The tools\' schema-1 code paths can go, and that is a change of its own.\n')
P.write_text(s, encoding='utf-8')

R = HERE / 'README.md'
s = R.read_text(encoding='utf-8')
assert 'DF3 batch B migrated' not in s
s = s.rstrip('\n') + ('\n\nDF3 batch B migrated the other 87 schema-1 records the same way:\n\n'
                      '- `df3b/units.json` the thirteen units, `df3b/snapshots.json` and `df3b/triage-rows.json` as for batch A, '
                      '`df3b/chain-sources.json` the chain sources among them and the entries that link them, `df3b/chapter-edits.json` the home-section edits as applied, '
                      '`df3b/chain-section.md` the chain index record\'s batch-B section.\n'
                      '- `workflows/10-df3b-migrate.js` (the thirteen migrators and reviewers; `df3b/workflow-args.json` its units), '
                      '`workflows/11-df3b-finish.js` (the migrations and reviews a network outage stopped), `workflows/12-df3b-cold-read.js` '
                      '(three readers and the chain reader); `reports/df3b-migrate-review-{1,2,3}.json`, `reports/df3b-cold-read.json` their returns.\n'
                      '- `df3b_apply.py` (the reviews and the chapter edits), `df3b_items.py` (edits replacing a whole item), `df3b_coldfix.py` '
                      '(what was taken from the cold read), `land_df3b.py` (the landing texts).\n')
R.write_text(s, encoding='utf-8')

b = BOARD.read_text(encoding='utf-8')
claim = re.findall(r'DF3 batch B holds the head of the queue \([^)]*\); ', b)
assert len(claim) == 1, claim
b = b.replace(claim[0], (f'DF3 batch B landed (the other 87 schema-1 records migrated to schema 2 with laws arrays, each law read against its '
                         f'declarations, a skeptical review per unit and a cold read; the home sections in 01, 02, 03, 04, 07 and 08 corrected '
                         f'where the Lean says less or more; the chain\'s fingerprinted records read; every record now on schema 2; no Lean, '
                         f'no checker run; study §{N}); '))
old = re.findall(r"batch B, the other 87 \(about 12–13M tokens at batch A's measured rate\), \*\*claimed\*\* 28 October 2026 on Ren's yes: .*?no Lean, no checker run\. ", b)
assert len(old) == 1, old
b = b.replace(old[0], f'batch B, the other 87, landed 29 October 2026 (study §{N}): every record is now on schema 2. ')
old2 = 'DF3: batch A landed (study §436); batch B, the other 87 schema-1 records, claimed 28 October 2026.'
assert b.count(old2) == 1
b = b.replace(old2, f'DF3: batch A landed (study §436) and batch B (study §{N}); every record is on schema 2.')
BOARD.write_text(b, encoding='utf-8')
print('STUDY_SECTION', N)
