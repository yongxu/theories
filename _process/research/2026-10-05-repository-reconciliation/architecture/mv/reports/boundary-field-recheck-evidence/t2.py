from lib import *
import json
probe = json.load(open('probe-rerun.json'))
anchors = set(FLOW) | {PRELUDE_LAW}
reaches_anchor = {}
def counting(n):
    if n not in reaches_anchor:
        reaches_anchor[n] = False
        reaches_anchor[n] = n in anchors or bool(closure([n]) & anchors) or any(counting(b) for b in walk(n) if b in root)
    return reaches_anchor[n]
def law_of(n): return n if n in laws else forwarders.get(n)
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
for r in probe['rows']:
    if r['balance']['flow_statement']:
        n = 'Becoming.' + r['declaration']
        need, used, helpers, count = closed_set(n)
        # does the full proof closure contain a Flow anchor (def)?
        cl = closure(C[n]['v'])
        print(r['declaration'][:50], r['dependence'], 'laws', len(used), 'count', sorted(count), 'flow-anchor in proof closure', bool(cl & set(FLOW)), 'bridges', len(need))

def D(row, Y, Br):
    Br = set(Br)
    res = {'D1': Y in laws}
    ok, reached_laws, reached_br, count = True, set(), set(), set()
    seen, stack = {row}, [row]
    while stack:
        x = stack.pop()
        for b in walk(x):
            if b in seen: continue
            seen.add(b)
            if law_of(b): reached_laws.add(law_of(b))
            elif b in root and not counting(b): pass
            elif b in Br: reached_br.add(b); stack.append(b)
            elif b in anchors or (b in root and counting(b)): count.add(b)
            else: ok = False
    res['D2'] = ok; res['D3'] = Y in reached_laws; res['D4'] = reached_br == Br; res['D5'] = not count
    return res
print()
for row in ['Becoming.Flow.unselected_beyond_pool', 'Becoming.Flow.act_unselected', 'Becoming.World.comes_to_rest_unrefuted']:
    need, used, helpers, count = closed_set(row)
    for Y in used:
        print(row, Y, D(row, Y, need))
