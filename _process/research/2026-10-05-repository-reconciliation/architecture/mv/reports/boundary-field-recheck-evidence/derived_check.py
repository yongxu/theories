#!/usr/bin/env python3
"""D1-D5 of BOUNDARY-FIELD.md draft 2 §3.1, implemented from the text; tries balance rows as 'derived'."""
import json, pickle, sys
sys.argv += []
exec(open('/private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/recheck-bf/mine_lib.py').read())

FLOW = ['Becoming.Flow.Balances', 'Becoming.Flow.BalancesOn', 'Becoming.Flow.BalancesBetween']
PRE = 'Becoming.balance_over_stretch_on'
ANCH = set(FLOW) | {PRE}
cmemo = {}
def counting(n):
    if n in cmemo: return cmemo[n]
    cmemo[n] = False
    if n in ANCH: cmemo[n] = True; return True
    if n in root and C[n]['k'] == 'thm':
        # 'a root theorem whose proof reaches one': proof walk, stopping at theorems
        pn = proof_names(n)
        cmemo[n] = bool(pn & ANCH) or any(counting(b) for b in pn if b in root)
    return cmemo[n]

def walk_all(n):
    """as proof_names, but also returns every constant visited (definitions walked through)"""
    out, seen, st = set(), {n}, list(C[n]['v'])
    while st:
        b = st.pop()
        if b not in C or b in seen: continue
        seen.add(b)
        if C[b]['k'] == 'thm' and not aux(b): out.add(b)
        elif b in root: continue
        else: st += list(C[b]['t']) + list(C[b]['v'])
    return out, seen

def closed(row):
    need, used, roots, count, visited = set(), set(), set(), set(), set()
    seen, st = {row}, [row]
    while st:
        x = st.pop()
        th, vis = walk_all(x)
        visited |= vis
        for b in th:
            if b in seen: continue
            seen.add(b)
            if law_of(b): used.add(law_of(b))
            elif b in root and counting(b): count.add(b)
            elif b in root: roots.add(b)
            else: need.add(b); st.append(b)
    return need, used, roots, count, visited

def check(row, Y, bridges):
    need, used, roots, count, visited = closed(row)
    res = {'D1': Y in laws, 'D2': need <= set(bridges), 'D3': Y in used, 'D4': set(bridges) <= need,
           'D5_theorems_only': not count, 'D5_visited': not (visited & ANCH) and not count}
    return res, sorted(need), sorted(used), sorted(visited & ANCH)

for row, Y in [('Becoming.Flow.unselected_beyond_pool', 'Becoming.«所闭之闭»'),
               ('Becoming.Flow.unexcluded_beyond_coupling', 'Becoming.«所闭之闭»'),
               ('Becoming.Flow.unselected_beyond_coupling', 'Becoming.«所闭之闭»'),
               ('Becoming.Flow.Dissipative.opens', 'Becoming.«尽则不或屡»'),
               ('Becoming.World.comes_to_rest_unrefuted', 'Becoming.«尽则不或屡»'),
               ('Becoming.Flow.act_unselected', 'Becoming.«所闭之传递»')]:
    need = closed(row)[0]
    res, need, used, anch = check(row, Y, need)
    print(row.removeprefix('Becoming.'), res, 'bridges', len(need), [n.removeprefix('Becoming.') for n in need][:6], 'laws', [u.removeprefix('Becoming.') for u in used], 'anchors visited', anch)
# the eight
EIGHT = json.load(open('/Users/ren/theories/.claude/worktrees/mv-status/_process/research/2026-10-05-repository-reconciliation/architecture/mv/boundary/probe.json'))['summary']['eight']
for d, e in EIGHT.items():
    row = 'Becoming.' + d
    br = ['Becoming.' + b for b in e['bridges_needed']]
    res, need, used, anch = check(row, 'Becoming.' + e['law'], br)
    print(d, res, 'anchors visited', anch)
