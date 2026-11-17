"""AI-written (Fable), 17 November 2026. Worked courses for the report, on the list transcription
(model.py), and the least pair "higher start ends, lower never ends" in which the takers are met at
both starts (so both courses have a cut-off step after step 0).  A search, not a proof."""
import itertools
import model
from twokind import givings, run

def show(order, a, t, b, m, c, k, G, N, x, steps=6, g=lambda z: 0):
    need = lambda u: a if u == 'g' else m
    use = lambda u: t if u == 'g' else c
    give = lambda u: b if u == 'g' else 0
    kids = lambda u: ['g'] if u == 'g' else ['t'] * k
    s = (['g'] * G + ['t'] * N, x)
    out = []
    for n in range(steps):
        cs = model.course(need, kids, g, use, s, n, give, order)
        out.append((cs[0].count('g'), cs[0].count('t'), cs[1], model.goes(need, cs)))
    return out, model.outcome_by_repeat(need, kids, g, use, s, give, order, cap=60, maxlen=100000)

print('each entry: (givers, takers, level, Goes); then the outcome by the list model')
print('least pair, give = 0 (this is the plain line on a stock): a=1 t=0 b=0 m=3 c=1 k=2 G=1 N=1, g=0')
for x in (2, 3): print('  L from', x, show('L', 1, 0, 0, 3, 1, 2, 1, 1, x))
print('least pair with b >= 1 and t >= 1, order L: a=1 t=1 b=1 m=4 c=1 k=2 G=1 N=1, g=0')
for x in (3, 4): print('  L from', x, show('L', 1, 1, 1, 4, 1, 2, 1, 1, x))
for x in (3, 4): print('  B from', x, show('B', 1, 1, 1, 4, 1, 2, 1, 1, x))
print('order B, takers never unmet (pinned): a=1 t=0 b=1 m=1 c=1 k=2 G=1 N=1, from 1')
print('  B', show('B', 1, 0, 1, 1, 1, 2, 1, 1, 1, steps=7)); print('  L', show('L', 1, 0, 1, 1, 1, 2, 1, 1, 1, steps=4))
print('order B, givers alone giving less than they use: a=1 t=2 b=1 G=1, no takers, from 5')
print('  B', show('B', 1, 2, 1, 9, 1, 2, 1, 0, 5, steps=7)); print('  L', show('L', 1, 2, 1, 9, 1, 2, 1, 0, 5, steps=7))

gv0 = givings()[0]
best = {}
for order in 'LB':
    for a, m, t, b, c, k, G, N in itertools.product(range(1, 4), range(2, 8), range(0, 3), range(0, 4), (1, 2), (2, 3), (1, 2), (1, 2)):
        if m <= a: continue
        outs = [run(order, gv0, a, t, b, m, c, k, G, N, x) for x in range(0, 41)]
        for xl in range(m, 41):
            if outs[xl]['out'] != 'never' or outs[xl]['cut'] is None: continue
            for xh in range(xl + 1, 41):
                if outs[xh]['out'] == 'ends':
                    w = a + t + b + m + c + k + G + N + xh
                    for tag, cond in (('any', True), ('b>=1,t>=1', b >= 1 and t >= 1)):
                        if cond and ((order, tag) not in best or w < best[(order, tag)][0]):
                            best[(order, tag)] = (w, dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x_never=xl, x_ends=xh, cut_never=outs[xl]['cut'], cut_ends=outs[xh]['cut']))
                    break
for kk, v in sorted(best.items()): print('least pair with the takers met at both starts,', kk, v)
e = best[('L', 'b>=1,t>=1')][1]
for x in (e['x_never'], e['x_ends']):
    print('  L from', x, show('L', e['a'], e['t'], e['b'], e['m'], e['c'], e['k'], e['G'], e['N'], x, steps=7))
