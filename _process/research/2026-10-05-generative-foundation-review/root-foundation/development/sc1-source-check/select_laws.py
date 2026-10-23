"""SC1 (does a model under-detect what its own text smuggles in?): the laws.

Candidates: the FC1 units (one 條 each) whose declaration is a theorem of the Lean table, not flagged as an example or
a reading, whose Lean form (FC1's `lean_form`, as the coders see it) is at most 3000 characters; distinct
declarations. A seeded sample of 60. Each law gets the class of the referent its authors plant (A, R or E, 20 each,
seeded). DESIGN.md §2.

    python3 -I sc1-source-check/select_laws.py      # needs FC1's data/lean_table.jsonl; writes data/laws.jsonl
"""
import json, random, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
FC1 = HERE.parent / 'zhonghua' / 'fidelity'
sys.path.insert(0, str(FC1))
import segments as G  # noqa: E402

L = {d['decl']: d for d in G.load('lean_table.jsonl')}
cand = []
for u in G.load('units.jsonl'):
    d = L.get(u['decl'])
    if not d or d['kind'] != 'theorem' or u['flags']['example'] or u['flags']['reading']:
        continue
    if len(json.dumps(G.lean_form(d), ensure_ascii=False)) <= 3000 and u['decl'] not in cand:
        cand.append(u['decl'])
cand.sort()
rng = random.Random('SC1-laws')
laws = rng.sample(cand, 60)
classes = ['A'] * 20 + ['R'] * 20 + ['E'] * 20
rng.shuffle(classes)
out = HERE / 'data' / 'laws.jsonl'
out.parent.mkdir(exist_ok=True)
with open(out, 'w', encoding='utf-8') as f:
    for i, decl in enumerate(laws):
        f.write(json.dumps({'law': 'L%02d' % i, 'decl': decl, 'plant_class': classes[i],
                            'lean': G.lean_form(L[decl])}, ensure_ascii=False) + '\n')
print(len(cand), 'candidates;', len(laws), 'laws written to', out)
