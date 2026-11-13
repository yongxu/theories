from w2 import *
rng = random.Random(11)
G = givings(rng, allow_nonzero0=True)
def U(g, w, x): return unending(g, (w, x))[0]
def gen_g():
    if rng.random() < .5: return rng.choice(G)
    hi = rng.randint(3, 10)
    return 'small', mk([0] + [rng.randint(0, 7) for _ in range(20)])
# ---- W3 greater_need
keys3 = ['order','more','nothing','short','meets','keeps','needs','within','short1','below','high']
d3 = {k: [0, None] for k in keys3}; prem3 = fail3 = nontriv3 = 0
for it in range(250000):
    name, g, m, h, n, H2, y1, y2, hi, x = sample()
    if rng.random() < .5:
        _, g = gen_g(); hi = rng.randint(3, 10); y2 = root_y(g, hi)(H2) if rng.random() < .7 else rng.randint(0, hi); y1 = rng.randint(0, root_y(g, hi)(h + H2) + 1); x = rng.randint(0, hi + 2)
    m2 = rng.randint(0, 16)
    p = W2prem(g, m, h, n, H2, y1, y2, hi, x); p['more'] = m <= m2
    a = U(g, [(m, h), (n, H2)], x)
    if not a: continue
    b = U(g, [(m2, h), (n, H2)], x)
    if all(p.values()):
        prem3 += 1; nontriv3 += (m2 > m)
        if not b: fail3 += 1; print('W3 FAIL', name, m, m2, h, n, H2, y1, y2, hi, x)
    for k in keys3:
        if not p[k] and all(p[j] for j in keys3 if j != k):
            d3[k][0] += 1
            if not b and d3[k][1] is None: d3[k][1] = dict(tab=g.tab[:hi + 3], m=m, m2=m2, h=h, n=n, H2=H2, y1=y1, y2=y2, hi=hi, x=x)
print('W3 premise cases (with line never ending at m)', prem3, 'm2>m', nontriv3, 'failures', fail3)
for k in keys3: print('  W3 drop', k, d3[k][0], 'CE:', d3[k][1])
# ---- W4 more_use_on_first
keys4 = ['order','nothing','short','meets','keeps','within','short_','meets_','keeps_','within_','needs','sum','more','short1','below','high']
d4 = {k: [0, None] for k in keys4}; prem4 = fail4 = strict4 = 0
for it in range(400000):
    name, g, m, h, n, H2, y1, y2, hi, x = sample()
    if rng.random() < .5:
        _, g = gen_g(); hi = rng.randint(3, 10); x = rng.randint(0, hi + 2)
        y2 = root_y(g, hi)(H2)
        y1 = rng.randint(0, root_y(g, hi)(h + H2) + 1)
    S = h + H2
    h2 = rng.randint(0, S + 1); H22 = S - h2 if rng.random() < .85 else rng.randint(0, 7)
    if H22 < 0: H22 = 0
    y22 = root_y(g, hi)(H22) if rng.random() < .7 else rng.randint(0, hi)
    if rng.random() < .3: y2 = rng.randint(0, hi)
    a = U(g, [(m, h), (n, H2)], x)
    if not a: continue
    b = U(g, [(m, h2), (n, H22)], x)
    p = W2prem(g, m, h, n, H2, y1, y2, hi, x)
    p.update(short_=Short(g, H22, y22), meets_=Meets(g, H22, y22, hi), keeps_=Keeps(g, H22, hi), within_=n <= H22 + y22, sum=h + H2 == h2 + H22, more=h <= h2)
    if all(p.values()):
        prem4 += 1; strict4 += h2 > h
        if not b: fail4 += 1; print('W4 FAIL', g.tab[:hi+2], m, h, H2, h2, H22, n, y1, y2, y22, hi, x)
    for k in keys4:
        if not p[k] and all(p[j] for j in keys4 if j != k):
            d4[k][0] += 1
            if not b and d4[k][1] is None: d4[k][1] = dict(tab=g.tab[:hi + 3], m=m, h=h, H2=H2, h2=h2, H22=H22, n=n, y1=y1, y2=y2, y22=y22, hi=hi, x=x)
print('W4 premise cases (line never ends at h)', prem4, 'h2>h', strict4, 'failures', fail4)
for k in keys4: print('  W4 drop', k, d4[k][0], 'CE:', d4[k][1])
# ---- W5 takes_nothing_ends
keys5 = ['order','nothing','short','meets','keeps','needs','within','short1','below','high']
d5 = {k: [0, None] for k in keys5}; prem5 = fail5 = 0
for it in range(300000):
    name, g, m, h, n, H2, y1, y2, hi, x = sample()
    if rng.random() < .5:
        _, g = gen_g(); hi = rng.randint(3, 10); x = rng.randint(0, hi + 2)
        y2 = root_y(g, hi)(H2) if rng.random() < .7 else rng.randint(0, hi)
        y1 = rng.randint(0, root_y(g, hi)(H2) + 2)
    a = U(g, [(m, 0), (n, H2)], x)
    p = W2prem(g, m, 0, n, H2, y1, y2, hi, x)
    if all(p.values()):
        prem5 += 1
        if a: fail5 += 1; print('W5 FAIL', g.tab[:hi + 2], m, n, H2, y1, y2, hi, x)
    for k in keys5:
        if not p[k] and all(p[j] for j in keys5 if j != k):
            d5[k][0] += 1
            if a and d5[k][1] is None: d5[k][1] = dict(tab=g.tab[:hi + 3], m=m, n=n, H2=H2, y1=y1, y2=y2, hi=hi, x=x, course=unending(g, ([(m, 0), (n, H2)], x))[1][:6])
print('W5 premise cases', prem5, 'failures', fail5)
for k in keys5: print('  W5 drop', k, d5[k][0], 'CE:', d5[k][1])
