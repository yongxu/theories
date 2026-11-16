# AI-written (Fable, seat "giving", round 11), 16 November 2026. Further searches; not proofs.
import itertools, random, sys
sys.path.insert(0, '/Users/ren/theories/tmp/r7/one-model/check/round11/giving')
from check_giving import sub, rm_step, rm_run, law_levels, const, root, hump, step_left, step_law, run, zero
random.seed(16)

# (d) the same member (standing take h, gated give >= h), boundary read in "what is left" (Law's phase): y1 against y0
lower = same = higher = 0; highneed = 0
for base in itertools.product(range(0, 3), repeat=4):
    baseK = [(m + 1, 0, base[m]) for m in range(4)]
    for T in (1, 2, 3):
        y0 = root(lambda z: sum(k[2] for k in baseK if k[0] <= z), T, 8)
        if y0 is None: continue
        for h in (1, 2):
            for gam in (h, h + 1):
                for m in (1, 2, 3, 4):
                    K = baseK + [(m, h, gam)]
                    y1 = root(lambda z: sum(k[2] for k in K if k[0] <= z), T + h, 8)
                    if y1 < y0: lower += 1
                    elif y1 == y0: same += 1
                    else:
                        higher += 1
                        if m > y0: highneed += 1
print(f"(d) what-is-left phase: root lower {lower}, same {same}, higher {higher}; of the higher, the member's need is above the old root in {highneed}")

# (c) a scheduled draw against the standing draw it stays above (comparison in the take), Law, needF = 0, contrib 0
viol = 0; n = 0
for _ in range(20000):
    start = random.randint(0, 9); renew = random.randint(0, 3); needG = random.randint(1, 5); H = random.randint(0, 4)
    sched = [H + random.randint(0, 3) for _ in range(20)]
    a = law_levels(start, renew, needG, 0, lambda t: sched[t], const(0), 20)
    b = law_levels(start, renew, needG, 0, const(H), const(0), 20)
    n += 1
    if any(x > y for x, y in zip(a, b)): viol += 1
print(f"(c) Law, independent taker: a schedule of draws each at least H keeps the level at or below the standing-H course: {n} laws, {viol} violations")

# the smallest case found where a higher start stops and a lower goes on, in October's Law itself
print("(test 1) Law start 3, renew 0, needG 1, needF 2, draw 2:", law_levels(3, 0, 1, 2, const(2), const(0), 5),
      "| start 4:", law_levels(4, 0, 1, 2, const(2), const(0), 5))

# mortal against permanent givers. State: (alive givers, level). Survival read on the level before the take
# (LineOnAStock.after), giving read on what is left; a standing taker T; stock giving g.
def mortal_run(g, T, givers, x, n=200):
    alive = list(givers); out = [x]
    for _ in range(n):
        z = sub(x, T)
        nx = z + g(z) + sum(gv for (m, gv) in alive if m <= z)
        alive = [(m, gv) for (m, gv) in alive if m <= x]
        x = nx; out.append(x)
    return out, alive
def perm_run(g, T, givers, x, n=200):
    out = [x]
    for _ in range(n):
        z = sub(x, T); x = z + g(z) + sum(gv for (m, gv) in givers if m <= z); out.append(x)
    return out
diff = 0; fam = 0; ex = None
for T in range(1, 9):
    for m in range(1, 13):
        for gv in (1, 2, 3):
            fam += 1
            for x in range(0, 30):
                p = perm_run(hump, T, [(m, gv)], x)[-1] > 0
                q = mortal_run(hump, T, [(m, gv)], x)[0][-1] > 0
                if p != q:
                    diff += 1
                    if ex is None: ex = (T, m, gv, x, perm_run(hump, T, [(m, gv)], x, 8), mortal_run(hump, T, [(m, gv)], x, 8)[0])
print(f"(e) hump, one giver, standing take: {fam} families x 30 starts; permanent and mortal fates differ at {diff} starts; first:", ex)
# Relay with mortal givers
def relay(mortal, s, n=8):
    alive = [True, True]; out = [s]
    for _ in range(n):
        a, b = sub(s[0], 1), sub(s[1], 1)
        f = 2 if (alive[0] and 1 <= a and 2 <= b) else 0
        g2 = 2 if (alive[1] and 2 <= a and 1 <= b) else 0
        if mortal: alive = [alive[0] and f > 0, alive[1] and g2 > 0]
        s = (a + f, b + g2); out.append(s)
    return out
print("(e) Relay, givers that come back:", relay(False, (2, 3)), "| givers gone once unmet:", relay(True, (2, 3)))
