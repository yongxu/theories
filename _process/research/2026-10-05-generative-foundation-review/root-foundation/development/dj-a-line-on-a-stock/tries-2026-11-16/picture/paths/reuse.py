# AI-written (Fable), 16 November 2026. Read-only. Where the Lean proof text of a declaration one dynamic lists
# names a declaration another dynamic lists, and the atlas has no link between the two dynamics.
# Approximate: names are matched as text (two-component qualified suffix, or a bare name within one file).
import json, re, collections, os
ROOT = '/Users/ren/theories/'
LEAN = ROOT + 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
d = json.load(open(ROOT + 'theories/becoming/results/atlas/entries/dynamics.json'))
fam = {e['id']: e['family'] for e in d}
lists = collections.defaultdict(set)
for e in d:
    for dec in e['declarations']: lists[dec].add(e['id'])
    for p in e['premises']: lists[p['law']].add(e['id'])
idx = json.load(open(ROOT + 'theories/becoming/results/data/lean-index.json'))
prefix = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/'
where = {}   # qualified -> (file, line)
decls_in = collections.defaultdict(list)
for f in idx['files']:
    p = f['path']
    if not p.startswith(prefix) or '/' in p[len(prefix):]: continue
    c = idx['contents_by_sha256'][f['sha256']]
    for dec in c['declarations']:
        q = dec.get('qualified_name_hint') or dec['name']
        for cand in (q, 'Becoming.' + q):
            if cand in lists and cand not in where:
                where[cand] = (p[len(prefix):], dec['line'])
        decls_in[p[len(prefix):]].append(dec['line'])
print('atlas declarations', len(lists), 'located', len(where))
src = {}
def block(fn, line):
    if fn not in src: src[fn] = open(LEAN + fn).read().split('\n')
    L = sorted(set(decls_in[fn]))
    i = L.index(line) if line in L else None
    end = L[i + 1] - 1 if i is not None and i + 1 < len(L) else len(src[fn])
    txt = '\n'.join(src[fn][line - 1:end])
    # drop the following declaration's docstring
    k = txt.rfind('\n/--')
    return txt[:k] if k > 0 else txt
# index of names by suffix
suffix2 = collections.defaultdict(set)
for q in where:
    parts = q.split('.')
    if len(parts) >= 3: suffix2['.'.join(parts[-2:])].add(q)
edges = json.load(open(ROOT + 'tmp/r7/one-model/check/round10/paths/edges.json'))
linked = {frozenset((f, t)) for f, t, *_ in edges}
tok = re.compile(r'[A-Za-z_«»一-鿿][A-Za-z_0-9«»一-鿿\']*(?:\.[A-Za-z_«»一-鿿][A-Za-z_0-9«»一-鿿\']*)+')
uses = collections.defaultdict(lambda: collections.defaultdict(set))  # (D,E) -> used law -> by
for q, (fn, line) in where.items():
    body = block(fn, line)
    # only the proof part: after the first ':=' if any
    for t in set(tok.findall(body)):
        parts = t.split('.')
        for i in range(len(parts) - 1):
            s = parts[i] + '.' + parts[i + 1]
            for q2 in suffix2.get(s, ()):
                if q2 == q: continue
                for D in lists[q]:
                    for E in lists[q2]:
                        if D != E and not (lists[q] & lists[q2]):
                            uses[(D, E)][q2].add(q)
out = []
for (D, E), m in uses.items():
    out.append((D, E, frozenset((D, E)) in linked, {k: sorted(v)[:3] for k, v in m.items()}))
json.dump(out, open(ROOT + 'tmp/r7/one-model/check/round10/paths/reuse.json', 'w'), ensure_ascii=False, indent=0)
new = [(D, E, m) for D, E, l, m in out if not l]
print('dynamic pairs with Lean reuse:', len(out), 'of which with no atlas link:', len(new))
# components
adj = collections.defaultdict(set)
for f, t, *_ in edges:
    adj[f].add(t); adj[t].add(f)
comp = {}
for i in fam:
    if i in comp: continue
    st = [i]; comp[i] = i
    while st:
        u = st.pop()
        for v in adj[u]:
            if v not in comp: comp[v] = i; st.append(v)
size = collections.Counter(comp.values())
rows = []
for D, E, m in new:
    if comp[D] != comp[E]:
        rows.append((size[comp[D]] + size[comp[E]], D, E, m))
rows.sort(key=lambda r: (-r[0], r[1]))
print('pairs across pieces:', len(rows))
for s, D, E, m in rows[:70]:
    print(s, fam[D], D, '-> uses ->', fam[E], E, '|', '; '.join(k.replace('Becoming.', '') for k in list(m)[:3]))
