# AI-written (reader, premises lens, stage C), 16 November 2026. Seconds only; no Lean.
# Re-computes the worked numbers of the scratch Three cases and probes premises by small models.
from itertools import product


def step(giving, d, x):
    left = max(x - d, 0)
    return left + giving(left)


def g3(z):  # Three.giving
    return min(z, max(12 - z, 0))


def use_b(b):  # Three.use
    return 5 if b else 3


def lock_read(a, _g):
    return a >= 3


def window_alone(fA, hA, w):  # reads at every step
    a, g, k = w
    return (fA(a, g), hA(a, g), k + 1)


def rise_share(a, g):
    return a + 1 if g else a


def lock_share(a, _g):
    return a


print("A. Three.rise_count_ends: riseShare, lockRead, drawerUse, from ((3,T,0),12), need 1")
w, x = (3, True, 0), 12
course = [(w, x)]
for _ in range(9):
    w, x = window_alone(rise_share, lock_read, w), step(g3, w[0], x)
    course.append((w, x))
print("  ", course[:8])
first_below = next(i for i, (_, lv) in enumerate(course) if lv < 1)
print("   first step with level below the need:", first_below, "| law's bound 2*12+1 =", 25)

print("E. no H <= 3, y with Short giving H y and 12 < H + y:")
bad = [(H, y) for H in range(0, 4) for y in range(0, 40)
       if all(g3(z) < H for z in range(y)) and 12 < H + y]
print("   counterexamples:", bad)

print("F. first step of A's course from which ends_with_net_regime's premises can be met")
for i, (wv, lv) in enumerate(course[:8]):
    H = wv[0]  # uses from here on are >= this share
    ok = [(h, y) for h in range(0, H + 1) for y in range(0, 40)
          if all(g3(z) < h for z in range(y)) and lv < h + y]
    print("   step", i, "use", H, "level", lv, "->", "met, e.g. H,y=%s" % (ok[0],) if ok else "cannot be met")

print("C. tight bound for ends_with_net_rising (need 1, use rising by one from 0, start x = hi)")
for hi in range(0, 6):
    worst = 0
    # all giving on 0..hi with giving 0 = 0 and z + giving z <= hi (Keeps giving 0 hi)
    ranges = [range(0, hi - z + 1) for z in range(1, hi + 1)]
    for tail in product(*ranges):
        table = (0,) + tail
        for x0 in range(0, hi + 1):
            for u0 in range(0, 3):
                x, n = x0, 0
                while x >= 1:
                    left = max(x - (u0 + n), 0)
                    x = left + table[left]
                    n += 1
                    assert n < 100
                worst = max(worst, n)
    print("   hi", hi, "worst number of steps", worst, "| hi + 1 =", hi + 1, "| 2*hi + 1 =", 2 * hi + 1)

print("D. `more` met with a use that reads only the step count, on lockShare (share never moves)")
w, x = (3, True, 0), 12
lv = [x]
shares = [w[0]]
for _ in range(12):
    w, x = window_alone(lock_share, lock_read, w), step(g3, w[2], x)
    lv.append(x)
    shares.append(w[0])
print("   levels", lv)
print("   shares", shares)

print("B. Three.share_read_goes_on: windowAfterShare lockShare lockRead zeroShare noRule 8 9")


def after_share(N, K, w, x, fA=lock_share):
    if N <= x < K:
        return (0, False, w[2] + 1)
    return window_alone(fA, lock_read, w)


def run_share(N, K, start, n, fA=lock_share):
    w, x = start
    out = [(w, x)]
    for _ in range(n):
        w, x = after_share(N, K, w, x, fA), step(g3, use_b(w[1]), x)
        out.append((w, x))
    return out


print("  ", run_share(8, 9, ((3, True, 0), 9), 6))
print("   riseShare variant (not in Lean):", run_share(8, 9, ((3, True, 0), 9), 5, rise_share))
print("G. the share window read too late (not in Lean): band [2,3)")
print("  ", run_share(2, 3, ((3, True, 0), 9), 5))
print("   band [6,7):", run_share(6, 7, ((3, True, 0), 9), 5))

print("H. premises of locked_turns_in_time_share_iff at the Three instance")
print("   Short giving 3 3:", all(g3(z) < 3 for z in range(3)),
      "| Meets giving 3 3 12:", all(3 <= g3(z) for z in range(3, 40) if z + 3 <= 12),
      "| Keeps giving 3 12:", all(step(g3, 3, v) <= 12 for v in range(13)),
      "| Short giving 5 5:", all(g3(z) < 5 for z in range(5)),
      "| Keeps giving 0 12:", all(step(g3, 0, v) <= 12 for v in range(13)))
