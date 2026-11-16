# AI-written (Fable, seat 2 of round 11), 16 November 2026.
# (a) HigherStartEnds's world on Three.giving = min z (12 - z): the fate from every start way of up
# to three units and every level 0..12, and candidate conditions on the start alone.
# A search by script is not a proof.
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from model import make_world, step, goes, never_ends, course, classify, multisets

HI = 12
g = [min(z, HI - z) for z in range(HI + 1)]
A, B, C = 0, 1, 2
need = (1, 3, 12)
use = (3, 1, 1)
kids = ((B, B), (C, B), (A,))
W = make_world(need, use, kids, g)
memo = {}

def name(c):
    return "".join("ABC"[i] * c[i] for i in range(3)) or "(empty)"

def taken(c):
    return sum(c[i] * use[i] for i in range(3))

# the Lean's two courses, as a check of the transcription
assert course(W, (1, 0, 0), 6, 3) == [((1, 0, 0), 6), ((0, 2, 0), 6), ((0, 2, 2), 8), ((0, 2, 2), 8)]
c7 = course(W, (1, 0, 0), 7, 5)
assert [x for _, x in c7] == [7, 8, 12, 12, 4, 0] and sum(c7[5][0]) == 16 and c7[4][0] == (2, 6, 2)
assert never_ends(W, (1, 0, 0), 6, memo) and not never_ends(W, (1, 0, 0), 7, memo)
print("transcription agrees with from_six and from_seven (ways as counts)")

def how_it_ends(c, x):
    """for an ending start: steps until no need is met, and whether a C was ever met on the way"""
    n, cmet = 0, False
    while goes(W, c, x):
        if c[2] and x >= 12:
            cmet = True
        c, x = step(W, c, x)
        n += 1
    return n, cmet

ways = [c for size in range(0, 4) for c in multisets(3, size)]
print("\nfate table: rows are start ways (counts as letters), columns levels 0..12")
print("  N = never ends; d = ends with no C ever met (the level ran down); u = ends after a C was met")
print("%-8s take  " % "way" + " ".join("%2d" % x for x in range(HI + 1)) + "   never-ending levels")
table = {}
for c in ways:
    row, lv = [], []
    for x in range(HI + 1):
        ne = never_ends(W, c, x, memo)
        table[(c, x)] = ne
        if ne:
            row.append(" N")
            lv.append(x)
        elif not goes(W, c, x):
            row.append(" .")
        else:
            n, cmet = how_it_ends(c, x)
            row.append(" u" if cmet else " d")
    print("%-8s %3d   " % (name(c), taken(c)) + " ".join(row) + "   " + str(lv) + "  " + classify(lv, HI))

total = len(table)
nev = [k for k, v in table.items() if v]
print("\nstarts: %d; never ending: %d" % (total, len(nev)))
print("never-ending starts:", [(name(c), x) for c, x in nev])

# 1. a threshold in the level per way
bad = [name(c) for c in ways if classify([x for x in range(HI + 1) if table[(c, x)]], HI) not in ("empty", "up-set")]
print("\n1. threshold in the level per way: fails for", len(bad), "of", len(ways), "ways:", bad)
more = [name(c) for c in ways if len([x for x in range(HI + 1) if table[(c, x)]]) > 1]
print("   ways with more than one never-ending level:", more)

# 2. a threshold in level minus take; is the fate a function of level minus take at all
byd = {}
for (c, x), v in table.items():
    byd.setdefault(x - taken(c), set()).add(v)
mixed = sorted(d for d, s in byd.items() if len(s) == 2)
print("2. level minus take: values at which both fates occur:", mixed)
print("   so no condition on level minus take alone is exact; a threshold in particular is not")

# 3. a potential that is linear in (a, b, c, x): midpoint obstruction
print("3. potential: ([A],5) %s, ([A],6) %s, ([A],7) %s -> no function monotone in the level at a fixed way,"
      % tuple("never" if table[((1, 0, 0), x)] else "ends" for x in (5, 6, 7)))
print("   and no half-space in (counts, level), separates: (A,6) is the midpoint of two ending starts")

# 4. the exact condition found by hand, checked on the table and on every way of up to 12 units
def formula(c, x):
    # (first try, kept: "next way has no A and one or two B's, and level minus take = twice its B's"
    #  was wrong for a way with an A, whose balance is one step further on)
    a, b, cc = c
    if a == 0:
        return b in (1, 2) and x == 3 * b + cc and x <= 11      # level minus take = twice the B's
    return a == 1 and b == 0 and x == 6 + cc and x <= 11        # level minus take = three

ok = all(formula(c, x) == v for (c, x), v in table.items())
print("4. 'no A, one or two B's, level = 3b + c <= 11' or 'one A, no B, level = 6 + c <= 11': exact on the table:", ok)
big = 0
okbig = True
for size in range(0, 13):
    for c in multisets(3, size):
        for x in range(HI + 1):
            big += 1
            if formula(c, x) != never_ends(W, c, x, memo):
                okbig = False
                print("   differs at", name(c), x)
print("   and on every way of up to 12 units, levels 0..12 (%d starts):" % big, okbig)

# 5. band condition: 'the level never reaches the next need above' (C's need, 12)
reach12_never, reach12_end, low_end = 0, 0, 0
for (c, x), v in table.items():
    cc, xx, hit = c, x, False
    seen = set()
    while goes(W, cc, xx) and (cc, xx) not in seen:
        seen.add((cc, xx))
        if xx >= 12 and cc[2]:
            hit = True
        cc, xx = step(W, cc, xx)
    if v and hit: reach12_never += 1
    if (not v) and hit: reach12_end += 1
    if (not v) and (not hit) and goes(W, c, x): low_end += 1
print("5. courses on which a C is met at some step: never ending %d, ending %d;" % (reach12_never, reach12_end))
print("   ending with no C ever met (and some need met at the start): %d" % low_end)
print("   so 'no C is ever met' is necessary for never ending on this table and far from sufficient")

# 6. the whole kernel: every never-ending configuration with at most 12 units
ker = []
for size in range(0, 13):
    for c in multisets(3, size):
        for x in range(HI + 1):
            if never_ends(W, c, x, memo):
                ker.append((c, x))
fixed = [(c, x) for c, x in ker if step(W, c, x) == (c, x)]
print("\n6. never-ending configurations with at most 12 units: %d; of them fixed under the step: %s"
      % (len(ker), [(name(c), x) for c, x in fixed]))
print("   every never-ending course ends in:", sorted(set(
    (name(course(W, c, x, 30)[-1][0]), course(W, c, x, 30)[-1][1]) for c, x in ker)))

# 7. one level either side of each fixed configuration, same way
for c, x in fixed:
    print("   at %s: level %d fixed; level %d -> %s; level %d -> %s" % (
        name(c), x, x - 1, "never" if never_ends(W, c, x - 1, memo) else "ends",
        x + 1, "never" if never_ends(W, c, x + 1, memo) else "ends"))
