"""Apply draft 2's D1-D5 mechanically to every central row reaching the grammar, with the row's whole closed set
declared as bridges and Y any grammar law the closed set reaches (as the spec's checks would accept)."""
from lib import *
import json
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
law_of = lambda n: n if n in laws else forwarders.get(n)
FLOWA = set(FLOW); anchors = FLOWA | {PRELUDE_LAW}
memo = {}
def counting(n):
    if n not in memo:
        memo[n] = n in anchors or bool(closure([n]) & anchors) or any(counting(b) for b in walk(n) if b in root)
    return memo[n]
def closed_set(row):
    need, used, helpers, count, seen, stack = set(), set(), set(), set(), {row}, [row]
    while stack:
        for b in walk(stack.pop()):
            if b in seen: continue
            seen.add(b)
            if law_of(b): used.add(law_of(b))
            elif b in anchors or (b in root and counting(b)): count.add(b)
            elif b in root: helpers.add(b)
            else: need.add(b); stack.append(b)
    return need, used, helpers, count
P = json.load(open('probe-full.json'))
U4 = {x['declaration']: x for x in json.load(open('u4-table.json'))['rows']}
for x in P['rows']:
    if x['dependence'] != 'grammar' or x['balance']['flow_statement']: continue
    n = 'Becoming.' + x['declaration']
    need, used, helpers, count = closed_set(n)
    # does any bridge's statement carry Flow's balance (the type's closure)?
    bal_bridges = sorted(short(b) for b in need if closure(C[b]['t']) & FLOWA)
    passes = bool(used) and not count
    print(f"{x['declaration']:55s} U4={U4[x['declaration']]['standing']:10s} D1-D5={'PASS' if passes else 'fail'} laws={len(used)} bridges={len(need)} counting={len(count)} bridges_with_balance_in_statement={bal_bridges[:3]}")
