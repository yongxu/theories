# AI-written (Fable, refuter seat, round 11), 16 November 2026. Independent transcription of
# RelationalRenewal.Law.level (deeper/RelationalRenewal.lean:246) and RegimeMargin.step (RegimeMargin.lean:249).
# Searches, not proofs.
import itertools, random
def sub(a, b): return a - b if a >= b else 0
def law(start, renew, needG, needF, draw, contrib, n):
    l = start; out = [l]
    for t in range(n):
        gOn = needG <= l; fOn = needF <= l
        if gOn and fOn: l = sub(l + renew + contrib(t), draw(t))
        elif gOn: l = l + renew
        elif fOn: l = sub(l + contrib(t), draw(t))
        out.append(l)
    return out
def rm(g, H, x, n):
    out = [x]
    for _ in range(n):
        z = sub(x, H); x = z + g(z); out.append(x)
    return out
c = lambda v: (lambda t: v)
assert law(3, 2, 1, 1, lambda t: t, c(0), 3)[3] == 6          # escalation_consumes (:596)
assert law(2, 1, 1, 1, c(2), c(1), 10) == [2]*11                # cultivation

# A. the phase lemma, needF = 0, constant draw d >= contrib k: all small laws incl. needG = 0, start < H
bad = n = 0
for start, renew, needG, d in itertools.product(range(10), range(5), range(7), range(7)):
    for k in range(d + 1):
        H = d - k; g = lambda z: renew if needG <= z else 0
        n += 1
        if law(start, renew, needG, 0, c(d), c(k), 30) != [sub(v, H) for v in rm(g, H, start + H, 30)]: bad += 1
print(f"A. phase lemma, needF = 0, constant net draw: {n} laws, {bad} disagree")
# A'. does it reach the laws October's theorems are used at?  needF > 0, or a net draw that changes
bad = n = 0; ex = None
for start, renew, needG, needF, d in itertools.product(range(8), range(4), range(1, 6), range(1, 6), range(1, 6)):
    H = d; g = lambda z: renew if needG <= z else 0
    n += 1
    a = law(start, renew, needG, needF, c(d), c(0), 30); b = [sub(v, H) for v in rm(g, H, start + H, 30)]
    if a != b:
        bad += 1; ex = ex or (start, renew, needG, needF, d, a[:6], b[:6])
print(f"A'. the same equation with needF >= 1: {n} laws, {bad} disagree; first (start, renew, needG, needF, draw):", ex)
for name, L in dict(malignant=(4, 1, 2, 1, c(3), c(0)), escalation=(3, 2, 1, 1, (lambda t: t), c(0)),
                    cultivation=(2, 1, 1, 1, c(2), c(1)), winning=(3, 1, 1, 0, c(2), c(0)), sharing=(3, 1, 1, 0, c(1), c(0))).items():
    print(f"    {name}: needF = {L[3]}, constant net draw: {name != 'escalation'} -> in the phase lemma's family: {L[3] == 0 and name != 'escalation'}")

# B. the schedule comparison: needF = 0 (monotone step) and needF > 0
def sched_viol(needF_max, trials=20000, seed=5):
    random.seed(seed); v = 0; ex = None
    for _ in range(trials):
        start = random.randint(0, 9); renew = random.randint(0, 3); needG = random.randint(1, 5); H = random.randint(0, 4)
        needF = random.randint(0, needF_max) if needF_max else 0
        s = [H + random.randint(0, 3) for _ in range(20)]
        a = law(start, renew, needG, needF, lambda t: s[t], c(0), 20); b = law(start, renew, needG, needF, c(H), c(0), 20)
        if any(x > y for x, y in zip(a, b)):
            v += 1; ex = ex or (start, renew, needG, needF, H, s[:4], a[:6], b[:6])
    return v, ex
print("B. schedule of draws each >= H stays at or below the standing-H course: needF = 0:", sched_viol(0)[0], "violations of 20000;",
      "needF in 0..5:", sched_viol(5)[0], "violations; first:", sched_viol(5)[1])
print("   by hand: start 4, renew 1, needG 2, needF 4, H 2: standing", law(4, 1, 2, 4, c(2), c(0), 4),
      "| schedule 3,2,2,2:", law(4, 1, 2, 4, lambda t: 3 if t == 0 else 2, c(0), 4))

# C. (d) in Law's order: gated members each giving at least their take, one standing taker H needing nothing
def step_law(kinds, x): return sub(x + sum(k[2] for k in kinds if k[0] <= x), sum(k[1] for k in kinds if k[0] <= x))
random.seed(9); viol = n = 0; ex = None
for _ in range(6000):
    ks = []
    for _ in range(random.randint(1, 3)):
        need = random.randint(0, 6); take = random.randint(0, 3); ks.append((need, take, take + random.randint(0, 3)))
    H = random.randint(1, 6); kinds = ks + [(0, H, 0)]
    N = lambda z: sum(k[2] - k[1] for k in ks if k[0] <= z)
    y = next((z for z in range(0, 8) if N(z) >= H), None)
    for x in range(0, 14):
        l = x
        for _ in range(60):
            l = step_law(kinds, l)
            if l > 500: break
        ends = (l == 0)
        want = True if y is None else x < y
        n += 1
        if ends != want: viol += 1; ex = ex or (ks, H, x, y, l)
print(f"C. Law's order, net givers and one standing taker: level at 0 after 60 steps iff start below the least z whose net giving covers H: {n} starts, {viol} violations", ex or "")
# D. odd and even starts (seat 3, against test 1)
kinds = [(1, 1, 1), (2, 2, 0)]
print("D. giver-back (need 1) beside a taker (need 2, takes 2), Law's order, g = 0: rest level from starts 0..9:",
      [[step_law(kinds, x) for _ in [0]] and (lambda x: [x := step_law(kinds, x) for _ in range(30)][-1])(x) for x in range(10)])
