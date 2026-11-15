#!/usr/bin/env python3
# AI-written (Fable, reader with the lens "try to break it"), 16 November 2026.
# Reads nothing, writes nothing; small models of the statements added to TurningInTime.lean in scratch.
import itertools, random, sys
random.seed(20261116)

def rstep(g, d, x):                      # RegimeMargin.step g d x = (x - d) + g (x - d), truncated
    z = x - d if x > d else 0
    return z + g(z)

def g3(z):                               # Three.giving z = min z (12 - z), truncated subtraction
    return min(z, 12 - z if z <= 12 else 0)

def alone_of(fA, hA, reads):             # windowAlone
    return lambda v: (fA(v[0], v[1]), hA(v[0], v[1]) if reads(v[2]) else v[1], v[2] + 1)

def after_window(fA, hA, hL, N, K):      # windowAfter, every step reading
    return lambda v, x: (fA(v[0], v[1]), hL((v[0], x), v[1]) if N <= x < K else hA(v[0], v[1]), v[2] + 1)

def after_share(fA, hA, sA, hL, N, K):   # windowAfterShare
    al = alone_of(fA, hA, lambda n: True)
    return lambda v, x: (sA((v[0], x), v[1]), hL((v[0], x), v[1]), v[2] + 1) if N <= x < K else al(v)

def course(after, giving, use, s, n):    # orbit of pair after (step giving (use w))
    out = [s]
    for _ in range(n):
        w, x = out[-1]
        out.append((after(w, x), rstep(giving, use(w), x)))
    return out

print("== A. namespace Three, recomputed ==")
lockRead = lambda a, g: a >= 3
lockShare = lambda a, g: a
riseShare = lambda a, g: a + 1 if g else a
lockUse = lambda v: 5 if v[1] else 3
drawerUse = lambda v: v[0]
always = lambda n: True
riseAlone = alone_of(riseShare, lockRead, always)
c = course(lambda w, x: riseAlone(w), g3, drawerUse, ((3, True, 0), 12), 8)
print("rise_count course:", c[:8])
print(" first step below need 1:", next(i for i, s in enumerate(c) if s[1] < 1), " bound 2*12+1 =", 25)
print(" step giving 3 12 =", rstep(g3, 3, 12), " giving 0 =", g3(0),
      " Keeps giving 0 12:", all(x + g3(x) <= 12 for x in range(13)))
bad = [(H, y) for H in range(4) for y in range(60) if all(g3(z) < H for z in range(y)) and 12 < H + y]
print(" (H,y) with H<=3, Short giving H y, 12 < H+y:", bad)
# earliest configuration of that course from which the OLD law's premises can be met
for j, (w, x) in enumerate(c[:8]):
    ok = [(H, y) for H in range(1, w[0] + 1) for y in range(40) if all(g3(z) < H for z in range(y)) and x < H + y]
    if ok:
        print(" old premises (floor H <= use from there on, Short, level < H+y) first meetable at step", j, w, x, "e.g.", ok[0])
        break
ras = course(after_window(lockShare, lockRead, lambda p, g: False, 8, 9), g3, lockUse, ((3, True, 0), 9), 6)
print("read_at_eight (old) course:", ras)
sh = after_share(lockShare, lockRead, lambda p, g: 0, lambda p, g: False, 8, 9)
c2 = course(sh, g3, lockUse, ((3, True, 0), 9), 6)
print("share_read course:", c2)
lockAlone = alone_of(lockShare, lockRead, always)
aw = course(lambda w, x: lockAlone(w), g3, lockUse, ((3, True, 0), 9), 5)
print(" as it was:", [s[1] for s in aw], " T=1: read", 8 <= aw[1][1] < 9, " level at T+1 >= 6:", aw[2][1] >= 6)
print(" Short 5 5:", all(g3(z) < 5 for z in range(5)), " Short 3 3:", all(g3(z) < 3 for z in range(3)),
      " Meets 3 3 12:", all(g3(z) >= 3 for z in range(3, 10)), " Keeps 3 12:", all(rstep(g3, 3, x) <= 12 for x in range(13)))
sh2 = after_share(riseShare, lockRead, lambda p, g: 0, lambda p, g: False, 8, 9)
print("riseShare variant (not in Lean):", course(sh2, g3, lockUse, ((3, True, 0), 9), 5))

print("== B. ends_with_net_rising, every small model ==")
worst = {}
count = 0
for hi in range(0, 5):
    tabs = [t for t in itertools.product(*[range(hi - z + 1) for z in range(hi + 1)]) if t[0] == 0]
    for t in tabs:
        g = lambda z, t=t: t[z]
        for incs in itertools.product((1, 2), repeat=min(hi + 1, 4)):
            for u0 in (0, 1):
                us = [u0]
                for k in range(2 * hi + 3):
                    us.append(us[-1] + (incs[k] if k < len(incs) else 1))
                for x in range(hi + 1):
                    for need in range(1, hi + 2):
                        X, m = x, 0
                        while X >= need and m <= 2 * hi + 2:
                            X = rstep(g, us[m], X); m += 1
                        count += 1
                        if m > 2 * hi + 1:
                            print("COUNTEREXAMPLE", hi, t, us, x, need); sys.exit(1)
                        worst[hi] = max(worst.get(hi, 0), m)
print(" models:", count, " no counterexample;  largest ending step by hi:", worst, "(stated bound 2*hi+1; hi+1 is reached)")

print("== C. ends_with_net_rising with one premise dropped (hand models, simulated 200 steps) ==")
def ends(g, use_at, x, need, steps=200):
    for m in range(steps):
        if x < need: return m
        x = rstep(g, use_at(m), x)
    return None
print(" no `nothing` (giving 0 = 1, giving 1 = 0, hi 1, x 1, need 1, use j):", ends(lambda z: 1 if z == 0 else 0, lambda j: j, 1, 1))
print(" no `keeps` (giving z = z + 5 for z > 0, x 3, use j):", ends(lambda z: z + 5 if z else 0, lambda j: j, 3, 1))
print(" no `high` (giving 0 up to hi = 2, z + 5 above; x 3):", ends(lambda z: z + 5 if z > 2 else 0, lambda j: j, 3, 1))
print(" `rises` weakened to <= (use 0 always, x 3):", ends(g3, lambda j: 0, 3, 1))
print(" `rises` only for j < 50 then constant (use min(j, 5), Three.giving, x 12):", ends(g3, lambda j: min(j, 5), 12, 1))
print(" need 0:", ends(g3, lambda j: j, 12, 0))
# no `un`: level hi marked and >= need; after resets the way to 0 there
w, x, hi = 0, 4, 4
gg = lambda z: (hi - z) if 0 < z <= hi else 0
for m in range(200):
    if x < 1: break
    w, x = (0 if x == hi else w + 1), rstep(gg, w, x)
print(" no `un` (level hi marked, way reset there): after 200 steps level", x)

print("== D. locked_ends_rising / count_rises, mutated models ==")
R3 = (0, 1, 2)
GIV = {"three": g3, "from0": lambda z: 1 if z == 0 else g3(z), "big": lambda z: z + 5 if 0 < z < 40 else 0,
       "zero": lambda z: 0}
def modelD():
    return dict(d={0: 0, 1: 1, 2: 1}, fav=(1, 2), thr=3, rlo=0, rhi=2, gdep=False, reads="all",
                use=("count", 1, (0, 0, 0)), giv="three", hi=12, x=12, need=1, a0=3, g0=2)
def mutateD(m):
    k = random.choice(list(m))
    m[k] = {"d": lambda: {g: random.choice((-1, 0, 1)) for g in R3},
            "fav": lambda: random.choice(((2,), (1,), (1, 2), (0, 1, 2), (), (0,))),
            "thr": lambda: random.randrange(7), "rlo": lambda: random.choice(R3), "rhi": lambda: random.choice(R3),
            "gdep": lambda: random.random() < .5, "reads": lambda: random.choice(("all", "even", "never")),
            "use": lambda: (random.choice(("count", "steps", "const", "rule")), random.choice((0, 1, 2)),
                            tuple(random.choice((0, 1, 4)) for _ in R3)),
            "giv": lambda: random.choice(list(GIV)), "hi": lambda: random.randrange(15),
            "x": lambda: random.randrange(16), "need": lambda: random.choice((0, 1, 2, 5)),
            "a0": lambda: random.randrange(7), "g0": lambda: random.choice(R3)}[k]()
def runD(m):
    fA = lambda a, g: max(a + m["d"][g], 0)
    hA = (lambda a, g: max(g, m["rhi"] if a >= m["thr"] else m["rlo"])) if m["gdep"] else \
         (lambda a, g: m["rhi"] if a >= m["thr"] else m["rlo"])
    reads = {"all": lambda n: True, "even": lambda n: n % 2 == 0, "never": lambda n: False}[m["reads"]]
    kind, u, bon = m["use"]
    use = {"count": lambda v: v[0] * u + bon[v[1]], "steps": lambda v: v[2] * u + bon[v[1]],
           "const": lambda v: 3, "rule": lambda v: bon[v[1]]}[kind]
    giving, hi, x, need, a0, g0 = GIV[m["giv"]], m["hi"], m["x"], m["need"], m["a0"], m["g0"]
    al = alone_of(fA, hA, reads)
    AR = range(0, 12)
    locked = lambda a, g: g in m["fav"] and g <= hA(a, g)
    prem = {
        "raises": all(a <= fA(a, g) for a in AR for g in m["fav"]),
        "monotone": all(hA(p, g) <= hA(q, h) for p in AR for q in AR if p <= q for g in R3 for h in R3),
        "upper": all(h in m["fav"] for g in m["fav"] for h in R3 if g <= h),
        "needs": need > 0, "nothing": giving(0) == 0,
        "keeps": all(z + giving(z) <= hi for z in range(hi + 1)), "high": x <= hi, "locked": locked(a0, g0),
        "more": all(use((a, g, n)) < use(al((a, g, n))) for a in range(a0, a0 + 30) for g in R3 if g >= g0 for n in (0, 1)),
    }
    w, X, mm = (a0, g0, 0), x, 0
    while X >= need and mm <= 2 * hi + 1:
        w, X = al(w), rstep(giving, use(w), X); mm += 1
    concl = mm <= 2 * hi + 1 and locked(w[0], w[1])
    cnt = None
    if kind == "count" and bon == (0, 0, 0):   # count_rises: upper, rise, pos, locked.1 give more
        rise = all(a < a + m["d"][g] for a in AR for g in m["fav"])
        cnt = (prem["upper"], rise, u > 0, g0 in m["fav"], prem["more"])
    return prem, concl, mm, cnt
validD = 0; dropD = {}; slack = -99; cr = [0, 0]
for i in range(60000):
    m = modelD()
    for _ in range(random.choice((1, 1, 2, 3))): mutateD(m)
    prem, concl, mm, cnt = runD(m)
    failed = [k for k, v in prem.items() if not v]
    if not failed:
        validD += 1
        slack = max(slack, mm - (m["hi"] + 1))
        if not concl: print("COUNTEREXAMPLE D", m); sys.exit(1)
    elif len(failed) == 1 and not concl:
        dropD.setdefault(failed[0], (m, mm))
    if cnt is not None and all(cnt[:4]):
        cr[0] += 1
        if not cnt[4]: print("COUNTEREXAMPLE count_rises", m); sys.exit(1)
    if cnt is not None and sum(cnt[:4]) == 3 and not cnt[4]:
        cr[1] += 1
print(" models meeting every premise:", validD, " none fails; largest (ending step - (hi+1)):", slack)
print(" count_rises: models meeting its premises", cr[0], "none fails; with one premise dropped and `more` false:", cr[1])
for k in ("raises", "monotone", "upper", "needs", "nothing", "keeps", "high", "locked", "more"):
    print("  drop", k, "->", "conclusion fails, e.g. " + str(dropD[k][0]) if k in dropD else "no failing model found in this family")

print("== E. locked_turns_in_time_share_iff / share_corrected_stays, mutated models ==")
CAP = 5
GIVE = {"three": g3, "from0": lambda z: 1 if z == 0 else g3(z), "low3": lambda z: z if z <= 3 else 0,
        "flat": lambda z: min(z, 6) if z <= 20 else 0}
def modelE():
    return dict(d={0: 0, 1: 0, 2: 0}, fav=(1, 2), thr=3, rlo=0, rhi=2, gdep=False, sA=0, hL=0, L=3, kept=(0,),
                u={0: 3, 1: 5, 2: 5}, sb=0, giv="three", N=8, K=9, a0=3, g0=2, x=9, H1=5, y1=5, H2=3, y2=3, hi=12, need=1)
def mutateE(m):
    k = random.choice(list(m))
    m[k] = {"d": lambda: {g: random.choice((-1, 0, 1)) for g in R3},
            "fav": lambda: random.choice(((2,), (1,), (1, 2), (0, 1, 2), (), (0,))),
            "thr": lambda: random.randrange(7), "rlo": lambda: random.choice(R3), "rhi": lambda: random.choice(R3),
            "gdep": lambda: random.random() < .5, "sA": lambda: random.choice((0, 1, 2, 3, 4, 5, "keep", "fA")),
            "hL": lambda: random.choice((0, 1, 2, "hA")), "L": lambda: random.randrange(7),
            "kept": lambda: random.choice(((0,), (1,), (2,), (0, 1), (0, 1, 2), ())),
            "u": lambda: {g: random.choice((2, 3, 4, 5, 6)) for g in R3}, "sb": lambda: random.choice((0, 1, 2)),
            "giv": lambda: random.choice(list(GIVE)), "N": lambda: random.randrange(13), "K": lambda: random.randrange(14),
            "a0": lambda: random.randrange(6), "g0": lambda: random.choice(R3), "x": lambda: random.randrange(15),
            "H1": lambda: random.randrange(8), "y1": lambda: random.randrange(12), "H2": lambda: random.randrange(7),
            "y2": lambda: random.randrange(8), "hi": lambda: random.randrange(4, 15), "need": lambda: random.choice((0, 1, 2, 5, 8))}[k]()
def runE(m):
    fA = lambda a, g: min(max(a + m["d"][g], 0), CAP)
    hA = (lambda a, g: max(g, m["rhi"] if a >= m["thr"] else m["rlo"])) if m["gdep"] else \
         (lambda a, g: m["rhi"] if a >= m["thr"] else m["rlo"])
    sA = (lambda p, g: p[0]) if m["sA"] == "keep" else (lambda p, g: fA(p[0], g)) if m["sA"] == "fA" else (lambda p, g: m["sA"])
    hL = (lambda p, g: hA(p[0], g)) if m["hL"] == "hA" else (lambda p, g: m["hL"])
    Low = lambda a: a < m["L"]; kept = lambda g: g in m["kept"]
    use = lambda v: m["u"][v[1]] + (m["sb"] if v[0] >= 4 else 0)
    giving = GIVE[m["giv"]]
    N, K, a0, g0, x, H1, y1, H2, y2, hi, need = (m[k] for k in ("N", "K", "a0", "g0", "x", "H1", "y1", "H2", "y2", "hi", "need"))
    AR = range(CAP + 1); band = range(N, K)
    prem = {
        "raises": all(a <= fA(a, g) for a in AR for g in m["fav"]),
        "monotone": all(hA(p, g) <= hA(q, h) for p in AR for q in AR if p <= q for g in R3 for h in R3),
        "upper": all(h in m["fav"] for g in m["fav"] for h in R3 if g <= h),
        "sets": all(Low(sA((a, z), g)) and kept(hL((a, z), g)) for a in AR for z in band for g in R3),
        "lowRule": all(kept(hA(a, g)) for a in AR if Low(a) for g in R3),
        "lowStays": all(Low(fA(a, g)) for a in AR if Low(a) for g in R3 if kept(g)),
        "uses": all(use((a, g, 0)) == H2 for a in AR if Low(a) for g in R3 if kept(g)),
        "nothing": giving(0) == 0, "short": all(giving(z) < H2 for z in range(y2)),
        "meets": all(H2 <= giving(z) for z in range(y2, hi + 1) if z + H2 <= hi),
        "keeps": all(rstep(giving, H2, z) <= hi for z in range(hi + 1)),
        "needs": need > 0, "within": need <= H2 + y2, "short1": all(giving(z) < H1 for z in range(y1)),
        "locked": g0 in m["fav"] and g0 <= hA(a0, g0),
        "draws": all(H1 <= use((a, g, 0)) for a in AR if a >= a0 for g in R3 if g >= g0),
        "below": x < H1 + y1, "high": x <= hi,
    }
    al = alone_of(fA, hA, lambda n: True); aft = after_share(fA, hA, sA, hL, N, K)
    # left side: the net never ends (cycle on share, rule, level; the step count is inert here)
    w, X, seen, never, stays = (a0, g0, 0), x, set(), None, True
    read_seen = False
    while never is None:
        if X < need: never = False; break
        key = (w[0], w[1], X, read_seen)
        if key in seen: never = True; break
        seen.add(key)
        if read_seen and not (Low(w[0]) and kept(w[1])): stays = False
        nr = read_seen or (N <= X < K)
        w, X = aft(w, X), rstep(giving, use(w), X)
        read_seen = nr
    # share_corrected_stays is about the pair's whole course; here checked along the net's line only
    # right side: first step of the course as it was in the band
    w, X, seen, T, right = (a0, g0, 0), x, set(), 0, False
    while True:
        if X < need: break
        if N <= X < K:
            right = rstep(giving, use(w), X) >= H2 + y2; break
        if (w[0], w[1], X) in seen: break
        seen.add((w[0], w[1], X))
        w, X = al(w), rstep(giving, use(w), X)
    return prem, never, right, stays
validE = 0; trueE = 0; dropE = {}; staysBad = 0
for i in range(60000):
    m = modelE()
    for _ in range(random.choice((1, 1, 2, 3))): mutateE(m)
    prem, never, right, stays = runE(m)
    failed = [k for k, v in prem.items() if not v]
    if not failed:
        validE += 1; trueE += never
        if never != right: print("COUNTEREXAMPLE E", m, never, right); sys.exit(1)
    elif len(failed) == 1 and never != right:
        dropE.setdefault(failed[0], (dict(m), never, right))
    if prem["sets"] and prem["lowRule"] and prem["lowStays"] and not stays:
        staysBad += 1
print(" models meeting every premise:", validE, " of them never ending:", trueE, " iff holds in all")
print(" share_corrected_stays along the net's line, violations under its three premises:", staysBad)
for k in ("raises", "monotone", "upper", "sets", "lowRule", "lowStays", "uses", "nothing", "short", "meets", "keeps",
          "needs", "within", "short1", "locked", "draws", "below", "high"):
    if k in dropE:
        mm, nv, rt = dropE[k]
        base = modelE()
        print("  drop", k, "-> iff fails (never ends:", nv, ", right side:", rt, ") changed:", {a: b for a, b in mm.items() if base[a] != b})
    else:
        print("  drop", k, "-> no failing model found in this family")
