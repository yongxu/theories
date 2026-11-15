# AI-written (Fable, reader "web"), 16 November 2026. A search, not a proof.
# Web.RecruitsThrough on the pool "the way after t steps along a level history l", any l (not only the
# regime's own): obs := nothing, requires := always, need := the unit's need, so
# AlikeThrough obs u l l' s  <->  (need u <= l s  <->  need u <= l' s).
import random
random.seed(16)
sub = lambda a, b: a - b if a >= b else 0
def ways(need, kids, w, l):            # the ways along a free level history l
    out = [list(w)]
    for x in l:
        w = [v for u in w if need[u] <= x for v in kids[u]]
        if len(w) > 60: w = w[:60]
        out.append(list(w))
    return out
def alike_upto(need, u, l, l2, t): return all((need[u] <= l[s]) == (need[u] <= l2[s]) for s in range(t + 1))
def alike_all(need, group, l, l2, t): return all(alike_upto(need, u, l, l2, t) for u in group)

def run(offspring, trials=4000, n=7):
    r = dict(rec_app=0, rec_bad=0, list_bad=0, fa_app=0, fa_bad=0, sel_app=0, sel_bad=0)
    for _ in range(trials):
        k = random.randint(1, 3); need = [random.randint(1, 9) for _ in range(k)]
        kids = [[random.randrange(k) for _ in range(random.randint(0, 2))] for _ in range(k)] if offspring else [[u] for u in range(k)]
        w = [random.randrange(k) for _ in range(random.randint(1, 3))]
        l = [random.randint(0, 10) for _ in range(n)]
        l2 = [x if random.random() < .6 else random.randint(0, 10) for x in l]
        a, b = ways(need, kids, w, l), ways(need, kids, w, l2)
        for t in range(n - 1):
            if set(a[t]) == set(b[t]) and alike_all(need, set(a[t]), l, l2, t):       # RecruitsThrough's premises
                r['rec_app'] += 1; r['rec_bad'] += set(a[t + 1]) != set(b[t + 1])
        # members_alike / first_apart: T the first step the pool along l couples l, l2 apart
        T = next((t for t in range(n) if not alike_all(need, set(a[t]), l, l2, t)), None)
        if T is not None:
            r['fa_app'] += 1
            r['fa_bad'] += not (set(a[T]) == set(b[T]) and not alike_all(need, set(b[T]), l, l2, T))
            r['list_bad'] += any(a[s] != b[s] for s in range(T + 1))                 # the ways as lists, counts kept
        # SelectsThrough obs u t (u is in the way at t+1)
        u = random.randrange(k); t = random.randint(0, n - 2)
        if alike_upto(need, u, l, l2, t) and not offspring:
            r['sel_app'] += 1; r['sel_bad'] += (u in a[t + 1]) != (u in b[t + 1])
    return r
print("C1 way of units:", run(False))
print("C2 candidate with kids:", run(True))

# ---- two stocks, one way, one start: the levels are each made by the way's own draw
def step(g, H, x): return sub(x, H) + g(sub(x, H))
def course(g, need, use, w, x, n):
    out = []
    for _ in range(n):
        out.append((list(w), x)); T = sum(use[u] for u in w)
        w, x = [u for u in w if need[u] <= x], step(g, T, x)
    return out
need = {'p': 9, 'q': 1}
for name, use in (("With", {'p': 4, 'q': 1}), ("Against", {'p': 1, 'q': 4})):
    c = course(lambda z: min(z, sub(12, z)), need, use, ['p', 'q'], 9, 7)
    print(name, [(''.join(w), x) for w, x in c])
