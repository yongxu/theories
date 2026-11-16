# AI-written (Fable), 16 November 2026. Read-only measurement over the atlas's dynamics.json.
import json, collections, sys, re
P = '/Users/ren/theories/theories/becoming/results/atlas/entries/dynamics.json'
d = json.load(open(P))
ids = [e['id'] for e in d]
byid = {e['id']: e for e in d}
fam = {e['id']: e['family'] for e in d}

# which dynamics list a law (declarations or premises)
lists = collections.defaultdict(set)
for e in d:
    for dec in e.get('declarations') or []:
        lists[dec].add(e['id'])
    for p in e.get('premises') or []:
        lists[p['law']].add(e['id'])

edges = []  # (from, to, kind, law, strength)
for e in d:
    for i, x in enumerate(e['exits']):
        if isinstance(x['to'], str):
            edges.append((e['id'], x['to'], 'exit', x.get('law'), x.get('strength')))
    for p in e.get('premises') or []:
        for c in p.get('case_of') or []:
            tg = lists.get(c['law'], set()) - {e['id']}
            for t in sorted(tg):
                edges.append((e['id'], t, 'case_of', p['law'] + ' <= ' + c['law'], 'proved'))
    for c in e.get('compose') or []:
        f, t = c['from']['dynamic'], c['to']['dynamic']
        edges.append((f, t, 'compose', (c['from'].get('law') or 'None') + ' -> ' + str(c['to'].get('law')), c.get('order_kept')))

json.dump(edges, open('/Users/ren/theories/tmp/r7/one-model/check/round10/paths/edges.json', 'w'), indent=0)

# undirected components
adj = collections.defaultdict(set)
for f, t, k, l, s in edges:
    if f != t and t in byid:
        adj[f].add(t); adj[t].add(f)
bad = [(f, t) for f, t, k, l, s in edges if t not in byid]
print('edges', len(edges), collections.Counter(k for _, _, k, _, _ in edges), 'dangling', bad)
print('distinct undirected pairs', len({frozenset((f, t)) for f, t, *_ in edges if f != t}))
seen = {}
comps = []
for i in ids:
    if i in seen: continue
    st = [i]; c = []
    seen[i] = len(comps)
    while st:
        u = st.pop(); c.append(u)
        for v in adj[u]:
            if v not in seen:
                seen[v] = len(comps); st.append(v)
    comps.append(c)
comps.sort(key=len, reverse=True)
print('components', len(comps), 'sizes', collections.Counter(len(c) for c in comps))
print('isolated', sum(1 for c in comps if len(c) == 1))
for c in comps[:8]:
    if len(c) > 1:
        print(len(c), collections.Counter(fam[x] for x in c), sorted(c))
print()
deg = sorted(((len(adj[i]), i) for i in ids), reverse=True)[:15]
print('hubs (distinct neighbours):')
for n, i in deg: print(' ', n, fam[i], i)
print()
print('per family: dynamics, linked (>=1 neighbour), in largest piece, within-family pairs, cross-family pairs')
big = set(comps[0])
for F in sorted(set(fam.values())):
    m = [i for i in ids if fam[i] == F]
    linked = [i for i in m if adj[i]]
    within = {frozenset((a, b)) for a in m for b in adj[a] if fam[b] == F}
    cross = {frozenset((a, b)) for a in m for b in adj[a] if fam[b] != F}
    print(F, len(m), len(linked), len([i for i in m if i in big]), len(within), len(cross))
