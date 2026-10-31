import itertools
# law f[(own_prev, partner_prev)] -> give (True)
keys=[(True,True),(True,False),(False,True),(False,False)]
names={}
for bits in itertools.product([False,True],repeat=4):
    f=dict(zip(keys,bits))
    if not f[(True,True)]: continue  # keeps mutual giving
    # one error: A withholds at step 0 (intended give), B gives
    a,b=False,True; returns=None
    for t in range(1,20):
        a,b=f[(a,b)],f[(b,a)]
        if a and b: returns=t; break
    # against always-withholder, starting from own giving
    o=True; gives=[]
    for t in range(1,20):
        o=f[(o,False)]; gives.append(o)
    retaliates = not all(gives)
    monotone = all(f[k1] <= f[k2] for k1 in keys for k2 in keys if k1[0]<=k2[0] and k1[1]<=k2[1])
    partner_only = f[(True,True)]==f[(False,True)] and f[(True,False)]==f[(False,False)]
    print(''.join('G' if f[k] else 'W' for k in keys), 'returns', returns, 'retaliates', retaliates,
          'gives vs ALLW', sum(gives),'/19', 'keeps inclusion', monotone, 'reads partner only', partner_only)
