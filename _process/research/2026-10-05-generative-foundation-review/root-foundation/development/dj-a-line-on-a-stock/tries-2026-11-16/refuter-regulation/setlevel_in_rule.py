# AI-written (Fable, refuter), 16 November 2026. A search, not a proof; runs in about a second.
# A candidate for paper, not from the seats: Pace's two-level course with a set level in the rule's
# place. Fast level x, rule m; f x m lies between m and x and is strictly nearer off m
# (Regulation.Between with Between.gap_falls's premise); the rule is read by any h at reading steps.
# Claim: over a stretch of k steps with no reading from step a, the rule is the one at a and the gap
# to it at a + j is at most the gap at a less j; so a stretch at least the gap ends at the rule.
# Kept countermodel when the rule is read at every step: the level never reaches it.
import random
random.seed(11)
def turn(f, h, b, x, m): return (f(x, m), h(x, m) if b else m)
bad = 0; n = 0
for trial in range(4000):
    tab = {}
    def f(x, m):
        if x == m: return m
        key = (x, m)
        if key not in tab: tab[key] = random.randint(1, abs(x - m))
        return x + tab[key] if x < m else x - tab[key]
    hv = {}
    def h(x, m):
        if (x, m) not in hv: hv[(x, m)] = random.randint(0, 9)
        return hv[(x, m)]
    reads = [random.random() < 0.3 for _ in range(40)]
    x, m = random.randint(0, 9), random.randint(0, 9)
    course = [(x, m)]
    for t in range(40):
        x, m = turn(f, h, reads[t], x, m); course.append((x, m))
    for a in range(40):
        k = 0
        while a + k < 40 and not reads[a + k]: k += 1
        xa, ma = course[a]
        for j in range(k + 1):
            n += 1
            xj, mj = course[a + j]
            if mj != ma or abs(xj - ma) > max(abs(xa - ma) - j, 0): bad += 1
print("stretches checked", n, "failures", bad)
# every step reads, the rule moved one past the level each time: the level chases and never holds
x, m, gaps = 0, 1, []
for t in range(30):
    x, m = (x + 1 if x < m else x), x + 2      # f moves one toward m; h x m = x + 2
    gaps.append(m - x)
print("read at every step, h x m = x + 2: gaps", gaps[:8], "never 0:", all(g > 0 for g in gaps))
