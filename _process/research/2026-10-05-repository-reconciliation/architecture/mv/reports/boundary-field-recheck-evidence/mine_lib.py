import collections, json, pickle, re
C = pickle.load(open('/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/bd-constants.pickle', 'rb'))
AUX = re.compile(r'^(match_\d+(_\d+)*|_proof_\d+|proof_\d+|eq_\d+|eq_def|sizeOf_spec|_sizeOf_\d+|_sizeOf_inst|injEq|inj|brecOn|below|binductionOn|casesOn|recOn|rec|noConfusion|noConfusionType|ctorIdx|toCtorIdx|_unsafe_rec|_sunfold|_flat_ctor|_aux_\d+|_default|elim)$')
last = lambda n: n.rsplit('.', 1)[-1]
aux = lambda n: bool(AUX.match(last(n)))
def statement(n):
    x = C[n]
    return list(x['t']) if x['k'] == 'thm' else list(x['t']) + list(x['v'])
located = lambda n: C[n]['m'] == 'Becoming.Prelude' or C[n]['m'].startswith('Becoming.Grammar')
def stmt_closure(names):
    seen, st = set(), [b for b in names if b in C]
    while st:
        b = st.pop()
        if b in seen: continue
        seen.add(b)
        st += [c for c in statement(b) if c in C]
    return seen
loc = [n for n in C if located(n)]
bad = {n for n in C if not located(n)}
changed = True
while changed:
    changed = False
    for n in loc:
        if n not in bad and any(b in bad for b in statement(n) if b in C):
            bad.add(n); changed = True
root = {n for n in loc if n not in bad}
def direct(n):
    out, seen, st = set(), {n}, statement(n)
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if aux(b) and b.startswith(n + '.'): st += statement(b)
        else: out.add(b)
    return out
def name_test(n, allowed=frozenset()):
    return sorted(b for b in direct(n) if b not in root and b not in allowed)
term = lambda n: '«' in n and n != 'Becoming.«际»'
def proof_names(n):
    out, seen, st = set(), {n}, list(C[n]['v'])
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if C[b]['k'] == 'thm' and not aux(b): out.add(b)
        elif b in root: continue
        else: st += list(C[b]['t']) + list(C[b]['v'])
    return out
laws = set()
for n in C:
    if C[n]['k'] == 'thm' and '«' in last(n) and not aux(n) and not name_test(n):
        cl = stmt_closure(C[n]['t'])
        if any(term(b) for b in cl) and not any(C[b].get('cv') for b in cl): laws.add(n)
fw = {}
def forwarder(n):
    if n in fw: return fw[n]
    fw[n] = None
    g = C[n].get('f')
    if g and g in C and proof_names(n) <= {g}:
        fw[n] = g if g in laws else forwarder(g)
    return fw[n]
for n in C:
    if C[n]['k'] == 'thm': forwarder(n)
F = {n: g for n, g in fw.items() if g and n not in laws}
law_of = lambda n: n if n in laws else F.get(n)
