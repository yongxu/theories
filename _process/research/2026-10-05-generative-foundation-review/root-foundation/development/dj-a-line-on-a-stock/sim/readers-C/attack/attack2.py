#!/usr/bin/env python3
# AI-written (Fable, reader with the lens "try to break it"), 16 November 2026.
# Hand models for the premises attack.py's mutated family did not reach, and two side checks.
import itertools

def rstep(g, d, x):
    z = x - d if x > d else 0
    return z + g(z)
def g3(z): return min(z, 12 - z if z <= 12 else 0)
R3 = (0, 1, 2); AR = range(6)

def evalE(fA, hA, sA, hL, Low, kept, use, giving, fav, N, K, a0, g0, x, H1, y1, H2, y2, hi, need):
    band = range(N, K)
    prem = {
        "raises": all(a <= fA(a, g) for a in AR for g in fav),
        "monotone": all(hA(p, g) <= hA(q, h) for p in AR for q in AR if p <= q for g in R3 for h in R3),
        "upper": all(h in fav for g in fav for h in R3 if g <= h),
        "sets": all(Low(sA((a, z), g)) and kept(hL((a, z), g)) for a in AR for z in band for g in R3),
        "lowRule": all(kept(hA(a, g)) for a in AR if Low(a) for g in R3),
        "lowStays": all(Low(fA(a, g)) for a in AR if Low(a) for g in R3 if kept(g)),
        "uses": all(use(a, g) == H2 for a in AR if Low(a) for g in R3 if kept(g)),
        "nothing": giving(0) == 0, "short": all(giving(z) < H2 for z in range(y2)),
        "meets": all(H2 <= giving(z) for z in range(y2, hi + 1) if z + H2 <= hi),
        "keeps": all(rstep(giving, H2, z) <= hi for z in range(hi + 1)),
        "needs": need > 0, "within": need <= H2 + y2, "short1": all(giving(z) < H1 for z in range(y1)),
        "locked": g0 in fav and g0 <= hA(a0, g0),
        "draws": all(H1 <= use(a, g) for a in AR if a >= a0 for g in R3 if g >= g0),
        "below": x < H1 + y1, "high": x <= hi,
    }
    al = lambda v: (fA(v[0], v[1]), hA(v[0], v[1]))
    aft = lambda v, X: (sA((v[0], X), v[1]), hL((v[0], X), v[1])) if N <= X < K else al(v)
    w, X, seen, levels = (a0, g0), x, set(), []
    while True:
        levels.append(X)
        if X < need: never = False; break
        if (w, X) in seen: never = True; break
        seen.add((w, X)); w, X = aft(w, X), rstep(giving, use(*w), X)
    w, X, seen, right, was = (a0, g0), x, set(), False, []
    while True:
        was.append(X)
        if X < need: break
        if N <= X < K: right = rstep(giving, use(*w), X) >= H2 + y2; break
        if (w, X) in seen: break
        seen.add((w, X)); w, X = al(w), rstep(giving, use(*w), X)
    return [k for k, v in prem.items() if not v], never, right, levels, was

cap = lambda a: min(max(a, 0), 5)
base = dict(fA=lambda a, g: a, hA=lambda a, g: 2 if a >= 3 else 0, sA=lambda p, g: 0, hL=lambda p, g: 0,
            Low=lambda a: a < 3, kept=lambda g: g == 0, use=lambda a, g: 3 if g == 0 else 5, giving=g3, fav=(1, 2),
            N=8, K=9, a0=3, g0=2, x=9, H1=5, y1=5, H2=3, y2=3, hi=12, need=1)
def show(name, **ch):
    m = dict(base); m.update(ch)
    failed, never, right, levels, was = evalE(**m)
    print(f" {name}: premises failing {failed}; never ends {never}; right side {right}; net levels {levels[:9]}; as it was {was[:7]}")

print("== E by hand: locked_turns_in_time_share_iff with one premise dropped ==")
show("base (Three.share_read_goes_on on three rules)")
show("no monotone", fA=lambda a, g: cap(a + 1) if g >= 1 else a, hA=lambda a, g: 2 if a == 3 else 0, N=10, K=11)
show("no upper", fav=(1,), g0=1, fA=lambda a, g: cap(a - 1) if g == 2 else a, use=lambda a, g: 5 if a >= 3 else 3, N=10, K=11)
show("no meets", giving=lambda z: 0 if z == 5 else g3(z), N=9, K=10)
gk = lambda z: (0, 0, 5, 6, 4)[z] if z < 5 else 0
show("no keeps", giving=gk, use=lambda a, g: 4 if g == 0 else 6, H1=6, y1=3, H2=4, y2=2, hi=8, x=8, N=8, K=9)
show("no high", giving=lambda z: z if z <= 3 else 0, hi=6, x=12, y1=10, N=12, K=13)
show("windowAfter as the case sA := fA (read_at_eight_ends)", sA=lambda p, g: p[0])

print("== ends_with_net_rising: is the rise needed at every step? ==")
bad = 0; n = 0
for hi in range(1, 5):
    for t in itertools.product(*[range(hi - z + 1) for z in range(hi + 1)]):
        if t[0]: continue
        for u0 in (0, 1):
            for x in range(hi + 1):
                for need in range(1, hi + 2):
                    X, m = x, 0
                    while X >= need and m <= hi + 1:
                        X = rstep(lambda z: t[z], u0 + min(m, hi), X); m += 1   # rises for j < hi only, then stands
                    n += 1; bad += m > hi + 1
print(f" use rising for j < hi and standing after: {n} models, {bad} not ended by step hi + 1")
print("== Three.rise_count_ends: where the use first is at least the level ==")
w, X = 3, 12
for j in range(8):
    print(f"  step {j}: share/use {w}, level {X}, use >= level: {w >= X}, use > largest giving 6: {w > 6}")
    w, X = w + 1, rstep(g3, w, X)
