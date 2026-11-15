"""AI-written (Fable, reader R2:lock), 16 November 2026. Seconds. Not Lean: an independent
recomputation of the numbers in Three.rise_count_ends and Three.share_read_goes_on, from the
definitions as read in the scratch TurningInTime.lean and RegimeMargin.lean."""


def sub(a, b):
    return a - b if a >= b else 0


def giving(z):
    return min(z, sub(12, z))


def step(g, H, x):  # RegimeMargin.step
    return sub(x, H) + g(sub(x, H))


def short(g, H, y):
    return all(g(z) < H for z in range(y))


def meets(g, H, y, hi):
    return all(H <= g(z) for z in range(y, hi + 1) if z + H <= hi)


def keeps(g, H, hi):
    return all(step(g, H, x) <= hi for x in range(hi + 1))


# rise_count_ends ---------------------------------------------------------------------------
def lockRead(a, g):
    return 3 <= a


def riseShare(a, g):
    return a + 1 if g else a


def lockShare(a, g):
    return a


def windowAlone(fA, hA, v):  # reads = fun _ => true
    a, g, c = v
    return (fA(a, g), hA(a, g), c + 1)


def drawerUse(v):
    return v[0]


def use(b):
    return 5 if b else 3


def lockUse(v):
    return use(v[1])


def orbit(f, s, n):
    out = [s]
    for _ in range(n):
        s = f(s)
        out.append(s)
    return out


rise = lambda s: (windowAlone(riseShare, lockRead, s[0]), step(giving, drawerUse(s[0]), s[1]))
course = orbit(rise, ((3, True, 0), 12), 8)
print('rise_count_ends course:', course)
assert course[1:8] == [((4, True, 1), 12), ((5, True, 2), 12), ((6, True, 3), 12), ((7, True, 4), 12),
                       ((8, True, 5), 10), ((9, True, 6), 4), ((10, True, 7), 0)]
assert all(1 <= s[1] for s in course[:7]) and course[7][1] < 1, 'line of exactly 7 steps at need 1'
assert giving(0) == 0 and keeps(giving, 0, 12), 'FromNothing; Keeps giving 0 12'
assert step(giving, 3, 12) == 12
# more: use v < use (windowAlone v) at every v with share >= 3 and rule true (sample)
assert all(drawerUse(v) < drawerUse(windowAlone(riseShare, lockRead, v))
           for a in range(3, 60) for c in range(3) for v in [(a, True, c)])
# old law's premises: is there H <= use(start at step j) and y with Short giving H y and level < H + y ?
for j in range(0, 7):
    (a, g, c), x = course[j]
    pairs = [(H, y) for H in range(0, drawerUse((a, g, c)) + 1) for y in range(0, 40)
             if short(giving, H, y) and x < H + y]
    print('step', j, 'share', a, 'level', x, 'pairs (H<=use, y) with Short and level < H+y:', pairs[:4], '...' if len(pairs) > 4 else '')
assert short(giving, 7, 6) and 7 <= drawerUse((7, True, 4)) and 12 < 7 + 6
# tightness of hi + 1 here? first step below need is 7 <= 13
# rises: use strictly rises at each of first 12 steps of alone's orbit
al = orbit(lambda v: windowAlone(riseShare, lockRead, v), (3, True, 0), 13)
assert all(drawerUse(al[j]) < drawerUse(al[j + 1]) for j in range(12))

# a use that reads only the step count meets `more` with the share never moving
assert all(v[2] < windowAlone(lockShare, lockRead, v)[2] for a in range(0, 9) for g in (True, False) for c in range(5) for v in [(a, g, c)])

# share_read_goes_on -------------------------------------------------------------------------
def windowAfterShare(fA, hA, sA, hL, N, K, w, x):
    a, g, c = w
    if N <= x < K:
        return (sA((a, x), g), hL((a, x), g), c + 1)
    return windowAlone(fA, hA, w)


zeroShare = lambda p, g: 0
noRule = lambda p, g: False
sh = lambda s: (windowAfterShare(lockShare, lockRead, zeroShare, noRule, 8, 9, s[0], s[1]), step(giving, lockUse(s[0]), s[1]))
c2 = orbit(sh, ((3, True, 0), 9), 12)
print('share_read_goes_on course:', c2[:5])
assert c2[1] == ((3, True, 1), 8) and c2[2] == ((0, False, 2), 6)
assert all(c2[n + 2] == ((0, False, n + 2), 6) for n in range(10))
asw = orbit(lambda s: (windowAlone(lockShare, lockRead, s[0]), step(giving, lockUse(s[0]), s[1])), ((3, True, 0), 9), 6)
print('course as it was levels:', [s[1] for s in asw])
# right side of the iff, for which T it holds (need 1, window [8,9), H2 + y2 = 6)
lv = [s[1] for s in asw]
Ts = [T for T in range(5) if all(1 <= lv[j] and not (8 <= lv[j] < 9) for j in range(T)) and 1 <= lv[T] and 8 <= lv[T] < 9 and 6 <= lv[T + 1]]
print('T with the right side:', Ts)
assert Ts == [1]
assert short(giving, 5, 5) and 9 < 5 + 5 and 9 <= 12 and short(giving, 3, 3) and meets(giving, 3, 3, 12) and keeps(giving, 3, 12)

# the bound hi + 1 of rising_takes_all / ends_with_net_rising: is it reached? (not claimed in any docstring)
def reach(hi):
    g = lambda z: sub(hi, z) if 0 < z <= hi else 0
    assert g(0) == 0 and all(step(g, 0, x) <= hi for x in range(hi + 1))
    x, j = hi, 0
    while x >= 1:
        x = step(g, j, x)  # use j at step j
        j += 1
    return j
print('first step below need 1 with use j at step j, giving hi - z:', [(hi, reach(hi)) for hi in range(1, 7)])
print('all assertions passed')
