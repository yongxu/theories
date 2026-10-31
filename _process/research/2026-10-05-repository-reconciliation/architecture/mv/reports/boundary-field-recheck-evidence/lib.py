import collections, json, pickle, re, sys
P='/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/bd-constants.pickle'
C = pickle.load(open(P,'rb'))
FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRELUDE_LAW = 'Becoming.balance_over_stretch_on'
TERM = 'Becoming.«际»'
AUX = re.compile(r'^(match_\d+(_\d+)*|_proof_\d+|proof_\d+|eq_\d+|eq_def|sizeOf_spec|_sizeOf_\d+|_sizeOf_inst|injEq|inj|'
                 r'brecOn|below|binductionOn|casesOn|recOn|rec|noConfusion|noConfusionType|ctorIdx|toCtorIdx|'
                 r'_unsafe_rec|_sunfold|_flat_ctor|_aux_\d+|_default|elim)$')
def aux(n): return bool(AUX.match(n.rsplit('.', 1)[-1]))
def located(n):
    m = C[n]['m']; return m == 'Becoming.Prelude' or m.startswith('Becoming.Grammar')
def own(n):
    x = C[n]; return list(x['t']) if x['k'] == 'thm' else list(x['t']) + list(x['v'])
nonroot = {n for n in C if not located(n)}
users = collections.defaultdict(set)
for n in C:
    for b in own(n):
        if b in C: users[b].add(n)
stack = list(nonroot)
while stack:
    for u in users[stack.pop()]:
        if u not in nonroot:
            nonroot.add(u); stack.append(u)
root = {n for n in C if n not in nonroot}
def direct(n):
    out, seen, stack = set(), {n}, own(n)
    while stack:
        b = stack.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if aux(b) and b.startswith(n + '.'): stack += own(b)
        else: out.add(b)
    return out
def closure(names):
    seen, stack = set(), list(names)
    while stack:
        b = stack.pop()
        if b in C and b not in seen:
            seen.add(b); stack += own(b)
    return seen
def term(n): return '«' in n and n != TERM
def name_test(n, allowed=()):
    return sorted(b for b in direct(n) if b not in root and b not in allowed)
def grammar_law(n):
    x = C[n]
    if x['k'] != 'thm' or '«' not in n.rsplit('.', 1)[-1] or aux(n): return False
    if name_test(n): return False
    cl = closure(x['t'])
    return any(term(b) for b in cl) and not any(C[b].get('cv') for b in cl)
laws = {n for n in C if grammar_law(n)}
def walk(n):
    out, seen, stack = set(), {n}, list(C[n]['v'])
    while stack:
        b = stack.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if C[b]['k'] == 'thm' and not aux(b): out.add(b)
        elif b in root: continue
        else: stack += list(C[b]['t']) + list(C[b]['v'])
    return out
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
forwarders = {n: g for n, g in fw.items() if g and n not in laws}
