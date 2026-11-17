"""AI-written (Fable). C1 and frozen test 6.

(a) C1 as stated, on courses of the model with give, orders L and B, random worlds.
(b) The same with the levels replaced by any two sequences of numbers that come from no law at all:
    if it still holds, C1 is true because `after` never reads the level's law.
(c) The strongest false form: two courses that differ ONLY in give (same need, kids, g, use, start,
    order): do the ways differ? If so, at which step relative to the first step where the levels
    meet different needs.
(d) In order L, do courses with the same met-needs step by step have the same givers giving?
    (In order B they must, by definition.)
"""
import random
from model import *

random.seed(15)
gs = [g_zero, hump12, lambda z: min(z, 3), lambda z: z]


def rworld(K=3):
    need = tuple(random.randint(0, 6) for _ in range(K))
    use = tuple(random.randint(0, 3) for _ in range(K))
    give = tuple(random.randint(0, 4) for _ in range(K))
    kids = tuple(tuple(random.randrange(K) for _ in range(random.randint(0, 2))) for _ in range(K))
    return World(need, use, give, kids, random.choice(gs))


def met(W, w, x):
    return tuple(W.need[u] <= x for u in w)


N = 6
a_pairs = a_hyp = a_viol = 0
b_pairs = b_hyp = b_viol = 0
c_pairs = c_differ = c_before = 0
c_example = None
d_pairs = d_samemet = d_diffgave = 0
d_example = None
for trial in range(40000):
    W = rworld()
    w0 = tuple(random.randrange(3) for _ in range(random.randint(1, 3)))
    # (a) second course: other g, use, give, start, order
    W2 = World(W.need, tuple(random.randint(0, 3) for _ in range(3)),
               tuple(random.randint(0, 4) for _ in range(3)), W.kids, random.choice(gs))
    o1, o2 = random.choice("LB"), random.choice("LB")
    x1, x2 = random.randint(0, 12), random.randint(0, 12)
    c1 = course(W, (w0, x1), N, o1)
    c2 = course(W2, (w0, x2), N, o2)
    a_pairs += 1
    # largest n with same needs met at every j < n (needs of the first course's way)
    n = 0
    while n < N and all((W.need[u] <= c1[n][1]) == (W.need[u] <= c2[n][1]) for u in c1[n][0]):
        n += 1
    if n > 0:
        a_hyp += 1
    if any(c1[j][0] != c2[j][0] for j in range(n + 1)):
        a_viol += 1
    # (b) arbitrary level sequences
    xs = [random.randint(0, 8) for _ in range(N)]
    ys = [random.randint(0, 8) for _ in range(N)]
    wa = [w0]
    wb = [w0]
    for j in range(N):
        wa.append(after(W, wa[-1], xs[j]))
        wb.append(after(W, wb[-1], ys[j]))
    n = 0
    while n < N and all((W.need[u] <= xs[n]) == (W.need[u] <= ys[n]) for u in wa[n]):
        n += 1
    b_pairs += 1
    b_hyp += n > 0
    if any(wa[j] != wb[j] for j in range(n + 1)):
        b_viol += 1
    # (c) only give differs
    W3 = World(W.need, W.use, tuple(random.randint(0, 4) for _ in range(3)), W.kids, W.g)
    c3 = course(W3, (w0, x1), N, o1)
    c_pairs += 1
    fw = next((j for j in range(N + 1) if c1[j][0] != c3[j][0]), None)
    if fw is not None:
        c_differ += 1
        fm = next(j for j in range(N) if met(W, c1[j][0], c1[j][1]) != met(W, c3[j][0], c3[j][1]))
        if fm >= fw:
            c_before += 1
        if c_example is None and len(w0) == 1 and fw <= 3:
            c_example = (W, W3.give, w0, x1, o1, c1[:fw + 1], c3[:fw + 1])
    # (d) order L, same world, two starts: same met pattern but different givers giving
    cA = course(W, (w0, x1), N, "L")
    cB = course(W, (w0, x2), N, "L")
    d_pairs += 1
    n = 0
    while n < N and met(W, cA[n][0], cA[n][1]) == met(W, cB[n][0], cB[n][1]) and cA[n][0] == cB[n][0]:
        n += 1
    if n == N:
        d_samemet += 1
        def gave(c):
            return [tuple(W.need[u] <= max(x - taken(W, w), 0) and W.give[u] > 0 for u in w)
                    for (w, x) in c[:N]]
        if gave(cA) != gave(cB):
            d_diffgave += 1
            if d_example is None and len(w0) == 1:
                d_example = (W, w0, x1, x2, cA[:3], cB[:3])

print("(a) C1 on courses with give: pairs", a_pairs, "with hypothesis for n>=1", a_hyp, "violations", a_viol)
print("(b) C1 on arbitrary level sequences: pairs", b_pairs, "with hypothesis for n>=1", b_hyp, "violations", b_viol)
print("(c) only give differs: pairs", c_pairs, "ways differ within", N, "steps:", c_differ,
      "; of these, ways differ at or before the first step with different needs met:", c_before)
print("    example:", c_example)
print("(d) order L, two starts, same ways and same needs met for", N, "steps:", d_samemet,
      "; of these with different units giving at some step:", d_diffgave)
print("    example:", d_example)

# a hand example for (c): one giver that leaves itself
W = World(need=(1,), use=(1,), give=(0,), kids=((0,),), g=g_zero)
Wg = World(need=(1,), use=(1,), give=(1,), kids=((0,),), g=g_zero)
print("hand (c): G need 1 use 1 leaves itself, g=0, from ([G],2), order L")
print("   give 0:", course(W, ((0,), 2), 4, "L"))
print("   give 1:", course(Wg, ((0,), 2), 4, "L"))
