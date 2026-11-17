# AI-written (Claude Fable 5.2), a small arithmetic check of what was read in SelectionPace.Displacement,
# Swap and Evolution.Drawdown. Reading aid only; nothing here is a proof.
def excess(a, b): return max(a - b, 0)
def inflow(present, give, take, cs):
    return sum(excess(sum(give.get((f, c), 0) for c in cs), sum(take.get((f, c), 0) for c in cs)) for f in present)

# Displacement, step 0
take = {('carrier','pool'):1, ('carrier','carrier'):1, ('carrier','other'):1}
give = {('carrier','left'):1, ('carrier','right'):1}
present = ['carrier']
whole = ['pool','carrier','other','left','right']
kids = {'carrier':['left','right'], 'other':[]}
marks = {'carrier':1,'other':0,'left':1,'right':1}
lin = lambda ps: ps + [k for p in ps for k in kids[p]]
fam0 = ['carrier','other']; fam1 = lin(fam0)[len(fam0):]
carried = sum(marks[p]*inflow(present, give, take, lin([p])) for p in fam0)
size0, size1 = len(fam0), len(fam1)
sum0, sum1 = sum(marks[p] for p in fam0), sum(marks[p] for p in fam1)
print('Displacement: inflow whole', inflow(present, give, take, whole),
      'pop lineage', inflow(present, give, take, lin(fam0)), 'carried', carried)
print(' response lhs', size0*sum1, 'rhs carried', size1*sum0 + size0*carried,
      'rhs whole', size1*sum0 + size0*inflow(present, give, take, whole))
# total given vs taken by the carrier
print(' carrier takes', sum(take.values()), 'gives', sum(give.values()))

# Swap, step 0
take = {('left','left'):1, ('right','right'):1}
give = {('left','rightKid'):1, ('right','leftKid'):1}
present = ['left','right']
kids = {'left':['leftKid'], 'right':['rightKid']}
print('Swap: carried', sum(inflow(present, give, take, lin([p])) for p in ['left','right']),
      'joint', inflow(present, give, take, lin(['left','right'])))

# Evolution.Drawdown, step 0: parent takes 1 from pool, gives 1 to same and 1 to varied
print('Drawdown step 0: parent takes', 1, 'gives', 2, '(gives one more than it takes)')
pool = {0:2, 1:1, 2:0, 3:0}
need = {'parent':2, 'same':2, 'varied':1}
for t in range(4):
    print(' t', t, 'pool', pool[t], {x: need[x] <= pool[t] for x in need})
