#!/usr/bin/env python3
"""Independent re-derivation of BOUNDARY-FIELD.md draft 2's §3.0 terms and §3.5/§6 figures, written from the spec text.
python3 -B mine.py CONSTANTS.pickle MEASURE.json MASTER-LAWS.json
"""
import collections, json, pickle, re, sys

C = pickle.load(open(sys.argv[1], 'rb'))
M = json.load(open(sys.argv[2]))
ML = json.load(open(sys.argv[3]))
rows = {}
for r in M['rows']:
    rows.setdefault(r['declaration'], r)

# §3.0 generated auxiliaries, by last component, as listed ("match_N" read literally and read widely)
LIST = ['match_N', '_proof_N', 'proof_N', 'eq_N', 'eq_def', 'sizeOf_spec', '_sizeOf_N', '_sizeOf_inst', 'inj', 'injEq',
        'brecOn', 'below', 'binductionOn', 'casesOn', 'recOn', 'rec', 'noConfusion', 'noConfusionType', 'ctorIdx',
        'toCtorIdx', 'elim', '_unsafe_rec', '_sunfold', '_flat_ctor', '_aux_N', '_default']
def pat(x, wide):
    if x.endswith('_N'):
        return re.escape(x[:-1]) + (r'\d+(_\d+)*' if wide else r'\d+')
    return re.escape(x)
AUX_LIT = re.compile('^(' + '|'.join(pat(x, False) for x in LIST) + ')$')
AUX_WIDE = re.compile('^(' + '|'.join(pat(x, True) for x in LIST) + ')$')
WIDE = '--literal' not in sys.argv
AUX = AUX_WIDE if WIDE else AUX_LIT
last = lambda n: n.rsplit('.', 1)[-1]
aux = lambda n: bool(AUX.match(last(n)))

def statement(n):
    x = C[n]
    return list(x['t']) if x['k'] == 'thm' else list(x['t']) + list(x['v'])

located = lambda n: C[n]['m'] == 'Becoming.Prelude' or C[n]['m'].startswith('Becoming.Grammar')

# root constants: located, and the statement closure (all the way down) stays located
memo = {}
def stmt_closure(names):
    seen, st = set(), [b for b in names if b in C]
    while st:
        b = st.pop()
        if b in seen: continue
        seen.add(b)
        st += [c for c in statement(b) if c in C]
    return seen
loc = [n for n in C if located(n)]
# compute root via closure per constant (memoised by SCC-free fixpoint)
bad = {n for n in C if not located(n)}
changed = True
while changed:
    changed = False
    for n in loc:
        if n not in bad and any(b in bad for b in statement(n) if b in C):
            bad.add(n); changed = True
root = {n for n in loc if n not in bad}
print('located', len(loc), 'root', len(root), 'off root', len(loc) - len(root))

def direct(n):
    out, seen, st = set(), {n}, statement(n)
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if aux(b) and b.startswith(n + '.'):
            st += statement(b)
        else:
            out.add(b)
    return out

def name_test(n, allowed=frozenset()):
    return sorted(b for b in direct(n) if b not in root and b not in allowed)

term = lambda n: '«' in n and n != 'Becoming.«际»'

def proof_names(n):
    """§3.0: walk value through defs/instances/auxiliaries (types and values), stop at theorems (collected) and root."""
    out, seen, st = set(), {n}, list(C[n]['v'])
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if C[b]['k'] == 'thm' and not aux(b):
            out.add(b)
        elif b in root:
            continue
        else:
            st += list(C[b]['t']) + list(C[b]['v'])
    return out

grammar_named = [n for n in C if C[n]['k'] == 'thm' and '«' in last(n)]
print('theorems with «» last component', len(grammar_named))
cand = {}
for n in grammar_named:
    why = []
    if aux(n): why.append('aux')
    if name_test(n): why.append('name test')
    cl = stmt_closure(C[n]['t'])
    if not any(term(b) for b in cl): why.append('no term')
    if any(C[b].get('cv') for b in cl): why.append('cv closure')
    if any(C[b].get('cv') for b in direct(n)): why.append('cv direct')
    cand[n] = why
pre = {n for n, w in cand.items() if not [x for x in w if x != 'cv direct']}
pre_direct = {n for n, w in cand.items() if not [x for x in w if x != 'cv closure']}
print('laws before proof clause (cv by closure)', len(pre), '(cv direct)', len(pre_direct))
print('cv closure vs direct differ:', sorted(pre_direct - pre)[:10], sorted(pre - pre_direct)[:10])
# proof clause: proof names only root theorems and grammar laws (greatest fixpoint)
laws = set(pre)
while True:
    drop = {n for n in laws if any(not (b in root or b in laws) for b in proof_names(n))}
    if not drop: break
    laws -= drop
print('grammar laws with the proof clause', len(laws), 'dropped by proof clause', sorted(pre - laws))
for n in sorted(pre - laws):
    print('  ', n, C[n]['m'], sorted(b for b in proof_names(n) if b not in root and b not in laws)[:8])
print('laws outside Grammar*/Prelude modules', sorted((n, C[n]['m']) for n in laws if not located(n)))
whys = collections.Counter(tuple(w) for n, w in cand.items() if n not in pre)
print('left out', whys)
print('left out «» theorems that are aux:', sum(1 for n in grammar_named if aux(n)))

# forwarders
fw = {}
def forwarder(n, depth=0):
    if n in fw: return fw[n]
    fw[n] = None
    g = C[n].get('f')
    if g and g in C and C[n].get('fk') in ('pure', 'projection') and proof_names(n) <= {g}:
        fw[n] = (g, 0) if g in laws else ((forwarder(g)[0], forwarder(g)[1] + 1) if forwarder(g) else None)
    return fw[n]
for n in C:
    if C[n]['k'] == 'thm': forwarder(n)
F = {n: v for n, v in fw.items() if v and n not in laws}
print('forwarders', len(F), 'direct', sum(1 for v in F.values() if v[1] == 0))
for n, v in sorted(F.items()): print('  ', n, '->', v[0], 'chain' if v[1] else 'direct', C[n]['f'])
# forwarders whose proof names other theorems only because of the walk
fw_raw = [n for n in C if C[n].get('f') in laws]
print('theorems with f naming a law directly', len(fw_raw), 'of which not forwarders by proof clause',
      sorted((n, sorted(proof_names(n))) for n in fw_raw if n not in F and n not in laws)[:10])
print('law with f naming a law:', sorted(n for n in fw_raw if n in laws)[:10])

central = set(rows)
print('central', len(central), 'kinds', collections.Counter(C[n]['k'] for n in central if n in C))
print('central passing name test', [n for n in central if not name_test(n)])
print('forwarders that are central', [n for n in F if n in central])

law_of = lambda n: n if n in laws else (F[n][0] if n in F else None)
def reach(n):
    out, seen, st = set(), {n}, list(C[n]['t']) + list(C[n]['v'])
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if law_of(b): out.add(law_of(b))
        elif b in root: continue
        else: st += list(C[b]['t']) + list(C[b]['v'])
    return out
grows = [n for n in central if rows[n]['dependence'] == 'grammar']
print('grammar rows', len(grows), 'reaching a law', sum(1 for n in grows if reach(n)), [n for n in grows if not reach(n)])

FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRE = 'Becoming.balance_over_stretch_on'
def full_deps(n):
    seen, st = {n}, [n]
    while st:
        x = st.pop()
        for b in list(C[x]['t']) + list(C[x]['v']):
            if b in C and b not in seen: seen.add(b); st.append(b)
    return seen
bal_stmt = {n for n in central if stmt_closure(C[n]['t']) & set(FLOW)}
print('balance in statement', len(bal_stmt), 'grammar', len(bal_stmt & set(grows)), 'other', len(bal_stmt - set(grows)))
# measure's 'balance, represented' dependence and EC6 category
dep_bal = {n for n in central if rows[n]['dependence'] == 'balance, represented'}
cat_bal = {n for n in central if rows[n]['category'] == 'balance, represented'}
print('dependence balance', len(dep_bal), 'category balance', len(cat_bal), 'same', dep_bal == cat_bal)
for name, S in (('dependence', dep_bal), ('category', cat_bal)):
    st = {n for n in S if n in bal_stmt}
    po = {n for n in S if n not in bal_stmt and full_deps(n) & set(FLOW)}
    pl = {n for n in S if not (full_deps(n) & set(FLOW)) and PRE in full_deps(n)}
    print(' ', name, 'stmt', len(st), 'proof only', len(po), 'prelude only', len(pl), 'rest', len(S - st - po - pl))
print('rule balance set = dep_bal statement part + 12 grammar?', bal_stmt == ({n for n in dep_bal if n in bal_stmt} | (bal_stmt & set(grows))))

# the rule
items = ML['central_reach']['rows']
lab = {}
for n in central:
    models = {m for x in items.get(n, []) for m in x['models']}
    if n in bal_stmt: lab[n] = 'balance in its statement'
    elif rows[n]['dependence'] == 'grammar': lab[n] = 'connected'
    elif models & {'occurrence', 'process'}: lab[n] = 'at a represented model'
    elif models: lab[n] = 'own carrier'
    else: lab[n] = 'unplaced'
print('rule', collections.Counter(lab.values()))
print('F5 items on balance rows', [n for n in items if n in bal_stmt])
print('F5 items on grammar rows', [n for n in items if n in set(grows)])
json.dump({'laws': sorted(laws), 'forwarders': {n: v[0] for n, v in F.items()}, 'rule': lab, 'root': sorted(root)},
          open('mine-out.json', 'w'), ensure_ascii=False, indent=0)
