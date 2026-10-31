"""Critic: draft 2's grammar-law predicate (§3.0, probe.py's grammar_law plus the proof clause) on main's MapRegions
(GW1/GW2's core leaf, landed e077583c6 before draft 2), dumped with the dump script and merged into the run's pickle."""
import collections, json, pickle, re
P = '/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/bd-constants.pickle'
C = pickle.load(open(P, 'rb'))
new = [json.loads(l) for l in open('mr/mr.jsonl')]
added = 0
for d in new:
    if d['m'] == 'CriticMR.MapRegions':
        d['m'] = 'Becoming.MapRegions'; C[d['n']] = d; added += 1
    else:
        assert d['n'] in C, d['n']
TERM = 'Becoming.«际»'
AUX = re.compile(r'^(match_\d+(_\d+)*|_proof_\d+|proof_\d+|eq_\d+|eq_def|sizeOf_spec|_sizeOf_\d+|_sizeOf_inst|injEq|inj|'
                 r'brecOn|below|binductionOn|casesOn|recOn|rec|noConfusion|noConfusionType|ctorIdx|toCtorIdx|'
                 r'_unsafe_rec|_sunfold|_flat_ctor|_aux_\d+|_default|elim)$')
aux = lambda n: bool(AUX.match(n.rsplit('.', 1)[-1]))
located = lambda n: C[n]['m'] == 'Becoming.Prelude' or C[n]['m'].startswith('Becoming.Grammar')
own = lambda n: list(C[n]['t']) if C[n]['k'] == 'thm' else list(C[n]['t']) + list(C[n]['v'])
nonroot = {n for n in C if not located(n)}
users = collections.defaultdict(set)
for n in C:
    for b in own(n):
        if b in C: users[b].add(n)
st = list(nonroot)
while st:
    for u in users[st.pop()]:
        if u not in nonroot: nonroot.add(u); st.append(u)
root = {n for n in C if n not in nonroot}
def direct(n):
    out, seen, s = set(), {n}, own(n)
    while s:
        b = s.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if aux(b) and b.startswith(n + '.'): s += own(b)
        else: out.add(b)
    return out
def closure(ns):
    seen, s = set(), list(ns)
    while s:
        b = s.pop()
        if b in C and b not in seen: seen.add(b); s += own(b)
    return seen
term = lambda n: '«' in n and n != TERM
def statement_ok(n):
    x = C[n]
    if x['k'] != 'thm' or '«' not in n.rsplit('.', 1)[-1] or aux(n): return False
    if any(b not in root for b in direct(n)): return False
    cl = closure(x['t'])
    return any(term(b) for b in cl) and not any(C[b].get('cv') for b in cl)
def walk(n):
    out, seen, s = set(), {n}, list(C[n]['v'])
    while s:
        b = s.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if C[b]['k'] == 'thm' and not aux(b): out.add(b)
        elif b in root: continue
        else: s += list(C[b]['t']) + list(C[b]['v'])
    return out
cand = {n for n in C if statement_ok(n)}
laws = set(cand)
while True:  # the proof clause: proof names only root theorems and grammar laws (greatest fixpoint)
    drop = {n for n in laws if any(not (b in root or b in laws) for b in walk(n))}
    if not drop: break
    laws -= drop
mr = sorted(n for n in laws if C[n]['m'] == 'Becoming.MapRegions')
print('MapRegions constants added:', added)
print('grammar laws in the merged run:', len(laws), '(probe on the pickle alone: 391)')
print('of them declared in MapRegions:', len(mr))
for n in mr: print('  ', n.removeprefix('Becoming.'))
fw = {}
def forwarder(n):
    if n in fw: return fw[n]
    fw[n] = None
    g = C[n].get('f')
    if g and g in C and walk(n) <= {g}:
        fw[n] = g if g in laws else forwarder(g)
    return fw[n]
for n in C:
    if C[n]['k'] == 'thm': forwarder(n)
fwd = {n: g for n, g in fw.items() if g and n not in laws}
print('forwarders in the merged run:', len(fwd), '; in MapRegions:', sorted(n for n in fwd if C[n]['m'] == 'Becoming.MapRegions'))
print('MapRegions «» theorems not counted:', sorted(n.removeprefix('Becoming.') for n in C if C[n]['m']=='Becoming.MapRegions' and C[n]['k']=='thm' and '«' in n.rsplit('.',1)[-1] and n not in laws))
