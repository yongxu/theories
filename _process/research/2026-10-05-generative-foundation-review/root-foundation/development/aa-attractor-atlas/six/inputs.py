"""AA six-family pass: one input file per share of the work, and the shared index of every dynamic. Each dynamic gives
its entry's fields, each declaration its kind and, for a theorem in the Becoming core, the binders of its statement whose
type is a proposition (the lister's, complete), a script's guess at existing premises a binder names, the head of its
proof and the atlas laws of other dynamics its proof uses; outside the core, its statement's source text."""
import json, re, sys, collections
from pathlib import Path
W = Path('/Users/ren/tmp/aa-six/wt'); K = Path('/Users/ren/tmp/aa-six')
sys.path.insert(0, str(W / 'tools/research'))
import atlas  # noqa: E402
D = json.loads((W / 'theories/becoming/results/atlas/entries/dynamics.json').read_text(encoding='utf-8'))
P = json.loads((W / 'theories/becoming/results/atlas/entries/premises.json').read_text(encoding='utf-8'))
rows = json.load(open(K / 'run/lister.json'))
repo = atlas.Repository()
owner = collections.defaultdict(list)
for e in D:
    for d in e.get('declarations', []):
        owner[d].append(e['id'])
fam = {e['id']: e['family'] for e in D}
by_lean = collections.defaultdict(set)
for p in P:
    for l in p.get('lean', []):
        by_lean[l.rsplit('.', 1)[-1]].add(p['id'])

def load(e):
    b = sum(len(rows[d]['binders']) for d in e['declarations'] if rows.get(d, {}).get('kind') == 'theorem')
    return b + 10 * len(e.get('exits') or []) + 5 * len(e.get('transitions') or []) + 4 * sum(1 for d in e['declarations'] if d not in rows)

def cut(xs, frac):
    tot = sum(load(e) for e in xs); acc = 0
    for i, e in enumerate(xs):
        acc += load(e)
        if acc >= tot * frac:
            return i + 1
fams = {f: [e for e in D if e['family'] == f] for f in 'ABEFGH'}
b = cut(fams['B'], 0.57)
F_H = fams['F'] + fams['H']
h = cut(F_H, 0.5)
SHARES = {'A': fams['A'], 'B1': fams['B'][:b], 'B2E': fams['B'][b:] + fams['E'], 'G': fams['G'],
          'FH1': F_H[:h], 'H2': F_H[h:]}

def periphery(n):
    where = repo.declared(n)
    if where in (None, 'core'):
        return {'source': 'not found', 'file': where}
    text = (W / where).read_text(encoding='utf-8')
    last = n.rsplit('.', 1)[1]
    m = re.search(r'^[ \t]*(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+)*(theorem|lemma|def|abbrev|structure|inductive|class)\s+(?:[\w.]*\.)?'
                  + re.escape(last) + r'(?=[\s:({\[⦃]).*?(?::=|\bwhere\b)', text, re.S | re.M)
    return {'source': 'source text', 'file': where, 'line': text[:m.start()].count('\n') + 1 if m else None,
            'kind': m.group(1) if m else None, 'statement_text': m.group(0)[:3000] if m else None}

def decl(n, e):
    r = rows.get(n)
    if r is None or r.get('missing'):
        return {'law': n, **periphery(n)}
    if r['kind'] != 'theorem':
        return {'law': n, 'kind': r['kind'], 'note': 'not a law: a definition or a type; no premise list'}
    binders = []
    for x in r['binders']:
        toks = set(re.findall(r"[A-Za-z_][A-Za-z0-9_']*", x['type']))
        guess = sorted({p for t in toks if t[:1].isupper() for p in by_lean.get(t, ())})
        binders.append({**x, 'existing_premise_guess': guess})
    uses = [{'law': u, 'listed_under': owner[u], 'families': sorted({fam[o] for o in owner[u]})}
            for u in r['uses'] if u in owner and e['id'] not in owner[u]]
    return {'law': n, 'kind': 'theorem', 'source': 'lister', 'binders': binders, 'proof_head': r['head'],
            'proof_head_listed_under': owner.get(r['head'], []), 'uses_laws_of_other_dynamics': uses}

for share, es in SHARES.items():
    out = []
    for e in es:
        out.append({'id': e['id'], 'family': e['family'], 'name': e['name'], 'mechanism': e['mechanism'], 'base': e['base'],
                    'records': e['records'], 'hypotheses': e['hypotheses'], 'open': e['open'], 'beyond': e['beyond'],
                    'forbids': e['forbids'],
                    'declarations': [decl(n, e) for n in e['declarations']],
                    'exits': [{'index': i, **x} for i, x in enumerate(e.get('exits') or [], 1)],
                    'transitions': [{'index': i, **t} for i, t in enumerate(e.get('transitions') or [], 1)]})
    json.dump({'share': share, 'families': sorted({e['family'] for e in es}), 'dynamics': out},
              open(K / f'run/input-{share}.json', 'w'), ensure_ascii=False, indent=1)
    nb = sum(len(d.get('binders', [])) for x in out for d in x['declarations'])
    nl = sum(1 for x in out for d in x['declarations'] if d.get('kind') == 'theorem' or d.get('source') == 'source text')
    print(share, len(es), 'dynamics', [x['id'] for x in out][:1], '...', 'laws or periphery', nl, 'binders', nb,
          'exits', sum(len(x['exits']) for x in out), 'transitions', sum(len(x['transitions']) for x in out),
          'load', sum(load(e) for e in es))
idx = [{'id': e['id'], 'family': e['family'], 'name': e['name']['en'], 'mechanism': e['mechanism']['en'],
        'read_for_premises': 'premises' in e} for e in D]
json.dump(idx, open(K / 'run/dynamics-index.json', 'w'), ensure_ascii=False, indent=1)
cd = [{'dynamic': e['id'], 'family': e['family'], 'index': i, 'law': x['law'], 'to': x['to'], 'edge': x['edge']['en']}
      for e in D if e['family'] in 'CD' for i, x in enumerate(e.get('exits') or [], 1) if not isinstance(x['to'], str)]
json.dump(cd, open(K / 'run/cd-exits-in-words.json', 'w'), ensure_ascii=False, indent=1)
print('index', len(idx), 'C and D exits in words', len(cd))
