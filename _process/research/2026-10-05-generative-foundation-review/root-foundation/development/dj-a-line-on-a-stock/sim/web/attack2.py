# AI-written (Fable, checker of the reader "web"), 16 November 2026. A search, not a proof.
# (a) Stock.along (Stock.lean:492-494) against the course's level, and Stock.carried_iff's right side.
# (b) On courses that go on through the horizon: is an unmet unit present and taking at late steps?
# (c) Flow.replenished_over (Flow.lean:705-707) read on the instance: K * N <= level at S + given over N.
# (d) Web.SelectsThrough (Selection.lean:137-139) at one unit, with offspring.
import random
random.seed(1611)
sub = lambda a, b: a - b if a >= b else 0
def hump(c): return lambda z: min(z, sub(c, z))
step = lambda g, H, x: sub(x, H) + g(sub(x, H))

def course(need, use, kids, g, w, x, n):
    out = []
    for _ in range(n + 1):
        out.append((list(w), x))
        T = sum(use[u] for u in w)
        w2 = [v for u in w if need[u] <= x for v in kids[u]]
        if len(w2) > 200: return None
        w, x = w2, step(g, T, x)
    return out

N = 24
st = dict(courses=0, along_bad=0, carried_iff_bad=0, goes_on=0, late_unmet_taker=0, late_unmet_units=0,
          late_units=0, rep_app=0, rep_bad=0, takers_over_Y=0)
for offspring in (False, True):
    r = dict(st)
    for _ in range(3000):
        k = random.randint(1, 3)
        need = [random.randint(1, 12) for _ in range(k)]; use = [random.randint(0, 5) for _ in range(k)]
        kids = [[random.randrange(k) for _ in range(random.randint(0, 2))] for _ in range(k)] if offspring else [[u] for u in range(k)]
        cc = random.randint(8, 14); g = hump(cc); Y = max(g(z) for z in range(0, 40))
        c = course(need, use, kids, g, [random.randrange(k) for _ in range(random.randint(1, 3))], random.randint(0, 14), N)
        if c is None: continue
        r['courses'] += 1
        T = [sum(use[u] for u in w) for w, _ in c]; X = [x for _, x in c]
        G = [g(sub(X[t], T[t])) for t in range(N + 1)]
        # (a) along draw replenish n acts (k+1) = along k - draw (acts k) + replenish (acts k)
        a = X[0]; ok = True
        for t in range(N):
            a = sub(a, T[t]) + G[t]; ok &= (a == X[t + 1])
        r['along_bad'] += not ok
        covered = all(T[t] <= X[t] for t in range(N))                    # carried_iff's right side
        balanced = all(X[t + 1] + T[t] == X[t] + G[t] for t in range(N)) # Balances on the horizon
        r['carried_iff_bad'] += (covered != balanced)
        goes = all(any(need[u] <= x for u in w) for w, x in c[:N])
        if goes:
            r['goes_on'] += 1
            late = range(N - 6, N)
            if any(any(need[u] > c[t][1] and use[u] > 0 for u in c[t][0]) for t in late): r['late_unmet_taker'] += 1
            r['late_unmet_units'] += sum(sum(1 for u in c[t][0] if need[u] > c[t][1]) for t in late)
            r['late_units'] += sum(len(c[t][0]) for t in late)
            # (c) from S on at least K units take; K * n <= X[S] + sum of given over n steps
            for S in (0, 6, 12):
                K = min(sum(1 for u in c[t][0] if use[u] > 0) for t in range(S, N))
                for n in range(1, N - S + 1):
                    r['rep_app'] += 1; r['rep_bad'] += not (K * n <= X[S] + sum(G[S:S + n]))
            Kl = min(sum(1 for u in c[t][0] if use[u] > 0) for t in range(12, N))
            r['takers_over_Y'] += (Kl > Y)
    print("offspring" if offspring else "way of units", r)

# (d) SelectsThrough at one unit with offspring: A (need 1) leaves B; B (need 5) leaves B. Way [A].
# Two level histories alike through B's couplings at step 0 (5 <= 1 and 5 <= 0 both false),
# yet B is in the way at step 1 along one and not along the other.
need = {'A': 1, 'B': 5}; kids = {'A': ['B'], 'B': ['B']}
def way1(l0): return [v for u in ['A'] if need[u] <= l0 for v in kids[u]]
l0, l0p = 1, 0
print("SelectsThrough at B, t = 0: alike through B:", (need['B'] <= l0) == (need['B'] <= l0p),
      "| B in the way at 1 along l:", 'B' in way1(l0), "| along l':", 'B' in way1(l0p))
