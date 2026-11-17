"""AI-written (Fable), 17 November 2026. Items 1, 2, 3, 4, 6 of the brief: C2 in the two-kind world.
A search, not a proof.  Usage: python3 search_c2.py all | wide0

World: givers (need a, use t, give b, kids [self]); takers (need m, use c, give 0, kids k takers);
G givers and N takers at the start; start level x; stock giving g; orders L and B.
Ranges
  all  : givings 0, min(z,r) r=1..3, gate(z>=q: r) (q,r) in (1,1),(2,1),(2,2),(3,2);
         a 1..3, m 1..5, t 0..2, b 0..3, c 1..2, k 2..3, G 1..2, N 1..2, x 0..24
  wide0: giving 0 only; a 1..4, m 1..7, t 0..3, b 0..4, c 1..2, k 2..3, G 1..3, N 1..2, x 0..40
Never-ends is decided as in twokind.py (R repeat, S saturated rise, P pinned with takers).
"""
import sys, time, collections, itertools, json
from twokind import givings, run

mode = sys.argv[1] if len(sys.argv) > 1 else 'all'
if mode == 'all':
    GV = givings(); A = range(1, 4); M = range(1, 6); T = range(0, 3); B = range(0, 4)
    C = (1, 2); K = (2, 3); GG = (1, 2); NN = (1, 2); X = range(0, 25)
else:
    GV = givings()[:1]; A = range(1, 5); M = range(1, 8); T = range(0, 4); B = range(0, 5)
    C = (1, 2); K = (2, 3); GG = (1, 2, 3); NN = (1, 2); X = range(0, 41)

def root(geff, d, bound):
    for z in range(bound + 1):
        if geff(z) >= d: return z
    return None

def holds_L(g, zs, a, t, b, G, x):
    """need met at the level and the level at or above the take and the root of g(z) + G*b*[a <= z]"""
    y = root(lambda z: g(z) + (G * b if a <= z else 0), G * t, max(zs, a) + 1)
    return y is not None and x >= a and x >= G * t + y

def holds_B(g, zs, a, t, b, G, x):
    y = root(lambda z: g(z) + G * b, G * t, zs + 1)
    return x >= a and (G * b >= a or (y is not None and x >= G * t + y))

t0 = time.process_time()
cnt = collections.Counter()
dis = collections.defaultdict(list)
fn_z = {}; fn_N = {}; fn_x = {}
conf = collections.Counter(); conf_ex = {}
hs = collections.Counter(); hs_small = {}; hs_small_real = {}; hs_viol = []
diff = collections.Counter(); diff_ex = {}
shift = collections.Counter(); kind = collections.Counter(); kind_ex = {}
nontriv = {}
i_ex = {}
runs = 0
for gv in GV:
    name, g, zs, gsat = gv
    for a, m, t, b, c, k, G, N in itertools.product(A, M, T, B, C, K, GG, NN):
        row = {'L': [], 'B': []}
        for x in X:
            for order in 'LB':
                r = run(order, gv, a, t, b, m, c, k, G, N, x)
                runs += 1
                row[order].append(r)
                nev = r['out'] == 'never'; cut = r['cut']
                key = (order, name)
                if m <= a:
                    # ---------------- item 1
                    cnt[key + ('i', 'n')] += 1
                    cnt[key + ('i', 'never')] += nev
                    if nev:
                        cnt[key + ('i', 'never', r['why'])] += 1
                        w = a + t + b + m + c + k + G + N + x
                        if key not in i_ex or w < i_ex[key][0]:
                            i_ex[key] = (w, dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x=x, why=r['why']))
                    if cut is not None:
                        cnt[key + ('i', 'cut')] += 1
                        if r['gcut'] is not None and r['gcut'] <= cut['n']:
                            cnt[key + ('i', 'givers no later')] += 1
                            if r['gcut'] < cut['n']: cnt[key + ('i', 'givers strictly earlier')] += 1
                        else:
                            dis[key + ('i', 'givers later')].append(dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x=x))
                else:
                    # ---------------- item 2
                    cnt[key + ('ii', 'n')] += 1
                    cnt[key + ('ii', 'never')] += nev
                    if nev: cnt[key + ('ii', 'never', r['why'])] += 1
                    if cut is None: cnt[key + ('ii', 'no cut')] += 1
                    xs, zst, Ns, x1 = (cut['x'], cut['z'], cut['N'], cut['x1']) if cut else (None, None, None, None)
                    forms = {}
                    forms['guess: left meets the need'] = cut is not None and xs >= a and zst >= a
                    if order == 'L':
                        forms['exact'] = cut is not None and xs >= a and holds_L(g, zs, a, t, b, G, x1)
                        if name == '0':
                            forms['closed g=0'] = cut is not None and zst >= a and b >= t
                    else:
                        forms['exact'] = (x >= m and G * b >= m) or (cut is not None and xs >= a and holds_B(g, zs, a, t, b, G, x1))
                        if name == '0':
                            forms['closed g=0'] = (x >= m and G * b >= m) or (cut is not None and xs >= a and (G * b >= a or (b >= t and zst + G * b >= a)))
                    for f, v in forms.items():
                        cnt[key + ('ii', f, 'n')] += 1
                        if v == nev: cnt[key + ('ii', f)] += 1
                        else:
                            d = dis[key + ('ii', f)]
                            if len(d) < (10 ** 6 if f != 'guess: left meets the need' else 2):
                                d.append(dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x=x, never=nev, xstar=xs, zstar=zst, Nstar=Ns, x1=x1))
                    # is the outcome a function of fewer numbers at the cut-off step?
                    if cut is not None and xs >= a:
                        base = (order, name, a, t, b, m, c, k, G)
                        for tag, store, val in (('z*', fn_z, zst), ('N*', fn_N, Ns), ('x*', fn_x, xs)):
                            kk = base + (val,)
                            if kk in store:
                                if store[kk][0] != nev:
                                    conf[(order, name, tag)] += 1
                                    conf_ex.setdefault((order, tag), (kk, store[kk][1], dict(N=N, x=x, never=nev, xstar=xs, zstar=zst, Nstar=Ns)))
                            else:
                                store[kk] = (nev, dict(N=N, x=x, never=nev, xstar=xs, zstar=zst, Nstar=Ns))
                    # item 6: the exact condition holds and fails with the same a, m, k
                    if order == 'L' and name == '0' and cut is not None and xs >= a:
                        nontriv.setdefault((a, m, k), {}).setdefault(nev, dict(t=t, b=b, c=c, G=G, N=N, x=x, xstar=xs, zstar=zst, Nstar=Ns))
                # ---------------- item 4, per run
            rl, rb = row['L'][-1], row['B'][-1]
            reg = 'm<=a' if m <= a else 'm>a'
            diff[(name, reg, 'n')] += 1
            if rl['out'] != rb['out']:
                tag = (name, reg, 'L ' + rl['out'] + ', B ' + rb['out'] + (' (' + rb['why'] + ')' if rb['out'] == 'never' else ''),
                       'b>=t' if b >= t else 'b<t', 'Gb>=a' if G * b >= a else 'Gb<a')
                diff[tag] += 1; diff[(name, reg, 'differ')] += 1
                diff_ex.setdefault(tag[2:] , dict(g=name, a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x=x))
        # ---------------- item 3, per parameter set
        for order in 'LB':
            outs = [r['out'] for r in row[order]]
            key = (order, name)
            first_never = next((i for i, o in enumerate(outs) if o == 'never'), None)
            if first_never is not None:
                highs = [j for j in range(first_never + 1, len(outs)) if outs[j] == 'ends']
                if highs:
                    hs[key + ('m<=a' if m <= a else 'm>a',)] += 1
                    xl, xh = None, None
                    for j in highs:           # the pair with the least higher start
                        lows = [i for i in range(j) if outs[i] == 'never']
                        xl, xh = lows[-1], j; break
                    w = a + t + b + m + c + k + G + N + X[xh]
                    ex = dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N, x_never=X[xl], x_ends=X[xh],
                              cut_never=row[order][xl]['cut'], cut_ends=row[order][xh]['cut'])
                    if key not in hs_small or w < hs_small[key][0]: hs_small[key] = (w, ex)
                    if b >= 1 and t >= 1 and (key not in hs_small_real or w < hs_small_real[key][0]): hs_small_real[key] = (w, ex)
                    # every pair: has the higher start a later cut-off step?
                    for j in highs:
                        for i in range(j):
                            if outs[i] == 'never':
                                ci, cj = row[order][i]['cut'], row[order][j]['cut']
                                hs[key + ('pairs',)] += 1
                                if ci is not None and cj is not None and cj['n'] > ci['n'] and cj['N'] > ci['N']:
                                    hs[key + ('pairs: higher start has later cut-off and more takers there',)] += 1
                                elif len(hs_viol) < 5:
                                    hs_viol.append((order, name, ex, X[i], X[j]))
        # ---------------- item 4, per parameter set: a shift of the start?
        oL = [r['out'] for r in row['L']]; oB = [r['out'] for r in row['B']]
        reg = 'm<=a' if m <= a else 'm>a'
        shift[(name, reg, 'sets')] += 1
        if oL == oB: shift[(name, reg, 'same at every start')] += 1
        else:
            found = None
            for s in sorted(range(-8, 9), key=abs):
                idx = [i for i in range(len(oB)) if 0 <= i + s < len(oL)]
                if all(oB[i] == oL[i + s] for i in idx):
                    found = s; break
            shift[(name, reg, 'differ; a shift of the start in -8..8 fits' if found is not None else 'differ; no shift of the start in -8..8 fits')] += 1
        anyL = 'never' in oL; anyB = 'never' in oB
        kind[(name, reg, 'never somewhere: L %s, B %s' % (anyL, anyB))] += 1
        if anyB and not anyL: kind_ex.setdefault((name, reg), dict(a=a, t=t, b=b, m=m, c=c, k=k, G=G, N=N))

def pr(*a): print(*a)
pr('mode', mode, '| runs', runs, '| cpu seconds', round(time.process_time() - t0, 1))
pr('\n== item 1: m <= a ==')
for gv in GV:
    for order in 'LB':
        key = (order, gv[0]); n = cnt[key + ('i', 'n')]
        whys = {w: cnt[key + ('i', 'never', w)] for w in 'PRSZ' if cnt[key + ('i', 'never', w)]}
        pr(f"{order} g={gv[0]:<14} runs {n}: ends {n - cnt[key+('i','never')]}, never {cnt[key+('i','never')]} {whys}; "
           f"takers go unmet in {cnt[key+('i','cut')]}, givers unmet no later in {cnt[key+('i','givers no later')]} (strictly earlier {cnt[key+('i','givers strictly earlier')]}); later: {len(dis.get(key+('i','givers later'), []))}"
           + (f" | least never: {i_ex[key][1]}" if key in i_ex else ''))
pr('\n== item 2: m > a ==')
for gv in GV:
    for order in 'LB':
        key = (order, gv[0]); n = cnt[key + ('ii', 'n')]
        whys = {w: cnt[key + ('ii', 'never', w)] for w in 'PRSZ' if cnt[key + ('ii', 'never', w)]}
        pr(f"{order} g={gv[0]:<14} runs {n}: never {cnt[key+('ii','never')]} {whys}, takers never unmet {cnt[key+('ii','no cut')]}")
        for f in ('exact', 'closed g=0', 'guess: left meets the need'):
            if cnt[key + ('ii', f, 'n')]:
                d = dis.get(key + ('ii', f), [])
                pr(f"     {f}: agrees {cnt[key+('ii',f)]} of {cnt[key+('ii',f,'n')]}" + (f"; disagreements e.g. {d[:2]}" if d else ''))
pr('\nis the outcome a function of one number at the cut-off step (same order, giving, a, t, b, m, c, k, G; x* >= a)?  conflicts found:')
for gv in GV:
    pr('  g=%-14s' % gv[0], {(o, tag): conf[(o, gv[0], tag)] for o in 'LB' for tag in ('z*', 'N*', 'x*')})
for kk, v in conf_ex.items(): pr('  e.g.', kk, v)
pr('\n== item 3: a higher start ends, a lower one never ends ==')
for gv in GV:
    for order in 'LB':
        key = (order, gv[0])
        pr(f"{order} g={gv[0]:<14} parameter sets with such a pair: m>a {hs[key+('m>a',)]}, m<=a {hs[key+('m<=a',)]}; pairs {hs[key+('pairs',)]}, of which the higher start has a later cut-off step and more takers there: {hs[key+('pairs: higher start has later cut-off and more takers there',)]}")
        if key in hs_small: pr('     least (by sum of the numbers):', hs_small[key])
        if key in hs_small_real: pr('     least with b >= 1 and t >= 1:', hs_small_real[key])
if hs_viol: pr('  pairs without a later cut-off:', hs_viol)
pr('\n== item 4: orders L and B ==')
for gv in GV:
    for reg in ('m<=a', 'm>a'):
        n = diff[(gv[0], reg, 'n')]
        pr(f"g={gv[0]:<14} {reg}: outcomes differ in {diff[(gv[0], reg, 'differ')]} of {n} runs")
        for kk, v in sorted(diff.items()):
            if kk[0] == gv[0] and kk[1] == reg and len(kk) == 5: pr('       ', kk[2:], v)
        pr('        parameter sets:', {kk[2]: v for kk, v in shift.items() if kk[0] == gv[0] and kk[1] == reg})
        pr('        ', {kk[2]: v for kk, v in kind.items() if kk[0] == gv[0] and kk[1] == reg}, 'e.g.', kind_ex.get((gv[0], reg)))
pr('  examples of each kind of difference:')
for kk, v in sorted(diff_ex.items()): pr('   ', kk, v)
pr('\n== item 6: the condition holds and fails with the same a, m, k (order L, g = 0) ==')
both = {kk: v for kk, v in nontriv.items() if True in v and False in v}
pr(f"(a, m, k) with m > a: {len(nontriv)}; with both a start where it holds and one where it fails: {len(both)}")
for kk in sorted(both)[:3]: pr('   ', kk, both[kk])
pr('cpu seconds', round(time.process_time() - t0, 1))
