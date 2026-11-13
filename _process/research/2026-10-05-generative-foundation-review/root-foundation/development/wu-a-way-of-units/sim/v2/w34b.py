from gen import *
rng = random.Random(13)
def U(g, w, x): return unending(g, (w, x))[0]
keys3 = ['order','more','nothing','short','meets','keeps','needs','within','short1','below','high']
d3 = {k: [0, None] for k in keys3}; prem3 = fail3 = 0
keys4 = ['order','nothing','short','meets','keeps','within','short_','meets_','keeps_','within_','needs','sum','more','short1','below','high']
d4 = {k: [0, None] for k in keys4}; prem4 = fail4 = strict4 = 0
w2cases = w2unend = 0
for it in range(300000):
    g, m, h, n, H2, y1, y2, hi, x = case(rng)
    if rng.random() < .1: n = rng.randint(0, 3)
    if rng.random() < .1 and m > 0: m = rng.randint(0, n)
    if rng.random() < .1:  # break FromNothing
        g = mk([rng.randint(1, 4)] + g.tab[1:])
    p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
    a = U(g, [(m, h), (n, H2)], x)
    if all(p.values()): w2cases += 1; w2unend += a
    if not a: continue
    # W3
    m2 = rng.randint(max(0, m - 3), m + 8)
    b = U(g, [(m2, h), (n, H2)], x)
    p3 = dict(p); p3['more'] = m <= m2
    if all(p3.values()):
        prem3 += 1
        if not b: fail3 += 1; print('W3 FAIL', g.tab[:hi + 2], m, m2, h, n, H2, y1, y2, hi, x)
    for k in keys3:
        if not p3[k] and all(p3[j] for j in keys3 if j != k):
            d3[k][0] += 1
            if not b and d3[k][1] is None: d3[k][1] = dict(tab=g.tab[:hi + 3], m=m, m2=m2, h=h, n=n, H2=H2, y1=y1, y2=y2, hi=hi, x=x, c1=unending(g, ([(m, h), (n, H2)], x))[1][:6], c2=unending(g, ([(m2, h), (n, H2)], x))[1][:6])
    # W4
    S = h + H2; h2 = rng.randint(h, S) if rng.random() < .9 else rng.randint(0, S); H22 = S - h2
    if rng.random() < .1: H22 = rng.randint(0, 8)
    y22 = root_y(g, hi)(H22) if rng.random() < .8 else rng.randint(0, hi)
    b4 = U(g, [(m, h2), (n, H22)], x)
    p4 = dict(p); p4.update(short_=Short(g, H22, y22), meets_=Meets(g, H22, y22, hi), keeps_=Keeps(g, H22, hi), within_=n <= H22 + y22, sum=h + H2 == h2 + H22, more=h <= h2)
    if all(p4.values()):
        prem4 += 1; strict4 += h2 > h
        if not b4: fail4 += 1; print('W4 FAIL', g.tab[:hi + 2], m, h, H2, h2, H22, n, y1, y2, y22, hi, x)
    for k in keys4:
        if not p4[k] and all(p4[j] for j in keys4 if j != k):
            d4[k][0] += 1
            if not b4 and d4[k][1] is None: d4[k][1] = dict(tab=g.tab[:hi + 3], m=m, h=h, H2=H2, h2=h2, H22=H22, n=n, y1=y1, y2=y2, y22=y22, hi=hi, x=x, c1=unending(g, ([(m, h), (n, H2)], x))[1][:6], c2=unending(g, ([(m, h2), (n, H22)], x))[1][:7])
print('W2 premise cases', w2cases, 'unending among them', w2unend)
print('W3 premise cases', prem3, 'failures', fail3)
for k in keys3: print('  W3 drop', k, d3[k][0], 'CE:', d3[k][1])
print('W4 premise cases', prem4, 'h2>h', strict4, 'failures', fail4)
for k in keys4: print('  W4 drop', k, d4[k][0], 'CE:', d4[k][1])
