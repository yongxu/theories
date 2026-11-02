"""OG2's third rule, each law below run over small parameters, on-steps and off-steps where a law's
hypotheses allow them. A state: quota, level, holders and others by cohort (index = age). One formula
for who enters: others enter f - c*T past T teachers (truncated); a holder enters where taught."""
import collections
import itertools

def sm(l): return sum(l)
def sub(a, b): return max(0, a - b)
def teachers(hs, l): return sm(hs[l:])

def step(p, x, on=True, rev=None):
    s, l, g, f, c, src = p
    q, L, hs, os_ = x
    take = sm(hs) + sm(os_)
    if L == 0 or take > L + g:
        return (q, 0, [], [])
    t = teachers(hs, l)
    eh = q if on and (src == 'outside' or (src == 'members' and t > 0)) else 0
    eo = sub(f, c * t) if on else 0
    q2 = rev if rev is not None and sm(hs) > 0 and src != 'outside' else q
    return (q2, L + g - take, ([eh] + hs)[:s], ([eo] + os_)[:s])

def leak(p, q):
    s, l, g, f, c, _ = p
    return sub(f, c * q * sub(s, l))
def steady(p, q, L):
    s = p[0]
    return (q, L, [q] * s, [leak(p, q)] * s)
def nobody(q, L, s, f): return (q, L, [0] * s, [f] * s)
def gone(x): return x[1] == 0 and sm(x[2]) == 0 and sm(x[3]) == 0
def run(p, x, k):
    for _ in range(k): x = step(p, x)
    return x

S, LS, GS, FS, CS, QS = range(1, 5), range(0, 6), range(0, 13), range(0, 5), range(0, 4), range(0, 5)
bad = []
def B(*a): bad.append(a)

for s, l, g, f, c, q, L in itertools.product(S, LS, GS, FS, CS, QS, range(0, 9)):
    p = (s, l, g, f, c, 'members')
    x = steady(p, q, L); e = leak(p, q); a = q + e
    if l < s and q >= 1:
        # the inflow lemma, at the steady state
        if a * s <= g:
            if L >= 1:
                y = step(p, x)
                if y != steady(p, q, L + g - a * s): B('keep', p, q, L, y)
        else:
            d = a * s - g
            k, y = 0, x
            while k * d <= L:
                if y != steady(p, q, L - k * d): B('horizon', p, q, L, k, y)
                y = step(p, y); k += 1
            if not gone(y): B('horizon-gone', p, q, L, y)
    # the band: held at every step iff l < s, 1 <= q, (q+e)*s <= g, from level >= 1
    if L >= 1:
        y, ok = x, True
        for _ in range(60):
            if sm(y[2]) == 0: ok = False; break
            y = step(p, y)
        if ok != (l < s and q >= 1 and a * s <= g): B('band', p, q, L, ok)
    # the drain: q = 0 or s <= l: no holder after s on-steps, from every level and every holders of at most s cohorts
    if q == 0 or s <= l:
        y = run(p, x, s)
        if sm(y[2]) != 0: B('drain', p, q, L, y)

# the region: closed under on-steps with a revision in [P, Q], level not falling
for s, l, g, f, c in itertools.product(range(1, 4), range(0, 4), range(0, 13), range(0, 4), range(0, 3)):
    if l >= s: continue
    for P, Q in [(a, b) for a in range(1, 4) for b in range(a, 4)]:
        E = sub(f, c * P * (s - l))
        if (Q + E) * s > g: continue
        p = (s, l, g, f, c, 'members')
        for hs in itertools.product(range(P, Q + 1), repeat=s):
            for os_ in ([], [E], [0, E], [E] * s):
                for q, rev in itertools.product(range(P, Q + 1), [None] + list(range(P, Q + 1))):
                    y = step(p, (q, 2, list(hs), list(os_)), True, rev)
                    if not (len(y[2]) == s and all(P <= n <= Q for n in y[2]) and len(y[3]) <= s and all(n <= E for n in y[3]) and P <= y[0] <= Q and y[1] >= 2):
                        B('region', p, P, Q, hs, os_, q, rev, y)

# no holder stays no holder under the whole net, the quota kept and read by nothing
for s, l, g, f, c, q, L in itertools.product(range(1, 4), range(0, 4), range(0, 5), range(0, 4), range(0, 3), range(0, 4), range(0, 4)):
    p = (s, l, g, f, c, 'members')
    for os_ in ([], [1], [0, 2], [1, 1, 1, 1]):
        for on, rev in itertools.product((True, False), (None, 0, 5)):
            x = (q, L, [0] * s, list(os_))
            y = step(p, x, on, rev)
            if sm(y[2]) != 0 or y[0] != q: B('no-holder', p, q, L, os_, on, rev)
        a, b = (q, L, [0] * s, list(os_)), (q + 3, L, [0] * s, list(os_))
        for _ in range(8):
            a, b = step(p, a), step(p, b)
            if a[1:] != b[1:]: B('dead-letter', p, q, L, os_); break

# the end closed: level 0, nobody; every source, every branch
for s, l, g, f, c, q, src in itertools.product(range(1, 4), range(0, 3), range(0, 4), range(0, 3), range(0, 3), range(0, 3), ('members', 'outside', 'none')):
    for on, rev in itertools.product((True, False), (None, 1)):
        y = step((s, l, g, f, c, src), (q, 0, [], []), on, rev)
        if not gone(y): B('end', s, l, g, f, c, q, src, on, rev)

# no holder and open entry: keeps at f*s <= g (level >= 1, f >= 1, at most s cohorts each at most f); ruin at f*s > g
for s, l, g, f, c, L in itertools.product(S, range(0, 4), range(0, 13), range(1, 5), range(0, 3), range(0, 9)):
    p = (s, l, g, f, c, 'members')
    for os_ in ([], [f], [0, f], [f] * s):
        os_ = os_[:s]
        x = (1, L, [0] * s, list(os_))
        if f * s <= g and L >= 1:
            y = x
            for _ in range(24):
                z = step(p, y)
                if z[1] < y[1] or sm(z[3]) == 0 or sm(z[2]) != 0: B('open-keeps', p, L, os_, y, z)
                y = z
        if f * s > g:
            y, hit = x, False
            for _ in range(300):
                if gone(y): hit = True; break
                y = step(p, y)
            if not hit: B('ruin', p, L, os_)

# what the rule does: the four quadrants, from the same level >= 1, l < s, 1 <= q, f >= 1
quad = collections.Counter()
for s, l, g, f, c, q, L in itertools.product(S, range(0, 4), GS, range(1, 5), CS, range(1, 5), range(1, 9)):
    if l >= s: continue
    p = (s, l, g, f, c, 'members')
    a = (q + leak(p, q)) * s
    r, n = steady(p, q, L), nobody(q, L, s, f)
    kr, kn = None, None
    for t in range(1, 80):
        r, n = step(p, r), step(p, n)
        if kr is None and gone(r): kr = t
        if kn is None and gone(n): kn = t
    want_r, want_n = a > g, f * s > g
    if (kr is not None) != want_r or (kn is not None) != want_n: B('quadrant', p, q, L, kr, kn)
    if want_r and want_n:
        if kr != L // (a - g) + 1 or kn != L // (f * s - g) + 1: B('quadrant-horizon', p, q, L, kr, kn)
    quad[(want_r, want_n)] += 1

# the band is two-sided: where c >= 1 a small quota can fail and a larger hold
two = collections.Counter(); wit = []
for s, l, g, f, c in itertools.product(S, range(0, 4), GS, range(0, 7), range(0, 4)):
    if l >= s: continue
    p = (s, l, g, f, c, 'members')
    ok = [q for q in range(1, 12) if (q + leak(p, q)) * s <= g]
    k = 'none' if not ok else 'from-1' if ok[0] == 1 else 'above-1'
    two[k] += 1
    if k == 'above-1' and len(wit) < 3: wit.append((p[:5], ok))

# the family: after an empty membership, level >= 1, on, 1 <= s, 1 <= q: outside returns; members and none do not
for s, l, g, f, c, q, L in itertools.product(S, range(0, 6), range(0, 5), range(0, 3), range(0, 3), range(1, 3), range(1, 4)):
    if sm(step((s, l, g, f, c, 'outside'), (q, L, [], []))[2]) == 0: B('outside-returns', s, l, q, L)
    for src in ('members', 'none'):
        if sm(step((s, l, g, f, c, src), (q, L, [], []))[2]) != 0: B(src + '-returns', s, l, q, L)

# gaps: at l = s - 1, k strands of s, others aligned: held at every step iff k*(q+e) + (s-k)*f <= g
for s, g, f, c, q, L in itertools.product(range(2, 5), range(0, 16), range(0, 4), range(0, 3), range(1, 3), range(1, 5)):
    l = s - 1; p = (s, l, g, f, c, 'members'); e = sub(f, c * q)
    for pat in itertools.product((0, 1), repeat=s):
        k = sm(pat)
        if k == 0: continue
        hs = [q * b for b in pat]
        # others alongside: a strand's cohort came in with e, a gap's with f; aligned so that the next to enter follows the pattern
        os_ = [e if b else f for b in pat]
        x = (q, L, hs, os_); ok = True
        for _ in range(60):
            if sm(x[2]) == 0: ok = False; break
            x = step(p, x)
        want = k * (q + e) + (s - k) * f <= g
        if ok != want: B('strands', p, q, L, pat, ok)

c_ = collections.Counter(b[0] for b in bad)
print('counterexamples', len(bad), dict(c_))
seen = set()
for b in bad:
    if b[0] not in seen: seen.add(b[0]); print(' ', b)
print('quadrants (rule ends, no holder ends):', dict(quad))
print('quota bands:', dict(two), wit)
for p in [(1, 0, 2, 4, 2, 'members'), (4, 2, 20, 6, 1, 'members'), (4, 3, 20, 6, 1, 'members')]:
    print(p[:5], 'admits q in', [q for q in range(0, 12) if q >= 1 and p[1] < p[0] and (q + leak(p, q)) * p[0] <= p[2]])
for name, p, x in [
    ('held with a leak', (3, 1, 9, 4, 1, 'members'), None),
    ('rule ruins: keepers overdraw where open entry would not', (1, 0, 1, 1, 1, 'members'), None),
]:
    q = 2 if name.startswith('rule') else 1
    y = steady(p, q, 2); print(name, p[:5], 'q', q)
    for t in range(5):
        print(' ', t, y); y = step(p, y)
