# AI-written (Claude Fable 5.2), reader "several-conditions", 17 Nov 2026.
# Small exact checks of RegimeMargin.Coupled's step in whole numbers. Not Lean; a reader's aid.
def step(g1, g2, H1, H2, p):
    a, b = max(p[0]-H1, 0), max(p[1]-H2, 0)
    return (a + g1(a, b), b + g2(a, b))

def run(g1, g2, H1, H2, p, n):
    out = [p]
    for _ in range(n):
        p = step(g1, g2, H1, H2, p); out.append(p)
    return out

# Relay (RegimeMargin.lean:3524, 3527), draws 1 and 1
first  = lambda a, b: 2 if (1 <= a and 2 <= b) else 0
second = lambda a, b: 2 if (2 <= a and 1 <= b) else 0
print("Relay from (2,3):", run(first, second, 1, 1, (2, 3), 6))
# what each gains and loses per step on the cycle: nothing moves between the two
p = (2, 3)
for _ in range(4):
    a, b = max(p[0]-1, 0), max(p[1]-1, 0)
    print("  state", p, "drawn", (p[0]-a, p[1]-b), "given to itself", (first(a, b), second(a, b)))
    p = step(first, second, 1, 1, p)

# fate of every start up to 8 x 8 (bounded look: 200 steps, then classify by the tail)
def fate(p):
    tail = run(first, second, 1, 1, p, 400)[200:]
    if all(s == (0, 0) for s in tail): return "both end"
    if len(set(tail)) == 1: return "rest %s" % (tail[0],)
    if max(max(s) for s in tail) > 100: return "grows"
    return "cycle %s" % (sorted(set(tail)),)
from collections import Counter
c = Counter()
rows = {}
for x in range(0, 9):
    for y in range(0, 9):
        f = fate((x, y)); c[f] += 1; rows[(x, y)] = f
print("Relay fates for starts 0..8 x 0..8:", dict(c))
for x in range(0, 6):
    print("  x=%d:" % x, [rows[(x, y)] for y in range(0, 6)])

# A giving of one from anything, nothing included, under a draw of five, band up to five:
# Rises (constant), Band holds, and the condition never ends though the draw is never met.
g = lambda a, b: 1
z = lambda a, b: 0
assert all(step(g, z, 5, 5, (x, y))[0] <= 5 and step(g, z, 5, 5, (x, y))[1] <= 5 for x in range(6) for y in range(6))
print("constant giving 1, draw 5, from (0,0):", run(g, z, 5, 5, (0, 0), 4), " from (5,0):", run(g, z, 5, 5, (5, 0), 4))
