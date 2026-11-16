# AI-written (Fable, seat 2 of round 11), 16 November 2026.
# (b) In general: for small worlds, how often is the set of levels from which a given way never ends
# an up-set, an interval, or neither; and under which restrictions on the world it is always an
# up-set. A search by script is not a proof; every count is of the family named beside it.
#
# usage: python3 b_general.py two HI      exhaustive, two kinds, ceiling HI (6 by default)
#        python3 b_general.py three HI N  sampled, three kinds, N worlds per giving (seeded)
import sys, os, itertools, random, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from model import make_world, step, goes, never_ends, classify, multisets


def givings(hi):
    """name -> table g[0..hi]; every one gives nothing from nothing and keeps levels within hi from a
    way that takes at least one (all but the last keep them within hi under no draw too)."""
    out = {}
    out["nothing"] = [0] * (hi + 1)
    out["tent min(z,hi-z)"] = [min(z, hi - z) for z in range(hi + 1)]
    out["inflow min(2,hi-z)"] = [0] + [min(2, hi - z) for z in range(1, hi + 1)]
    out["logistic z(hi-z)/hi"] = [(z * (hi - z)) // hi for z in range(hi + 1)]
    out["fold (hi-2z below half)"] = [0] + [(hi - 2 * z if z <= hi // 2 else 0) for z in range(1, hi + 1)]
    out["one from anything (g rising)"] = [0] + [1] * hi   # rising as a function; level never rises under a take >= 1
    return out


def step_rising(g):
    return all(z + g[z] <= z + 1 + g[z + 1] for z in range(len(g) - 1))


def g_rising(g):
    return all(g[z] <= g[z + 1] for z in range(len(g) - 1))


def flags(need, use, kids):
    K = len(need)
    down = all(need[v] <= need[u] for u in range(K) for v in kids[u])
    even = all(sum(use[v] for v in kids[u]) == use[u] for u in range(K))
    some = all(len(kids[u]) > 0 for u in range(K))
    selfk = all(kids[u] == (u,) for u in range(K))
    one = len(set(need)) == 1
    return down, even, some, selfk, one


RESTR = [
    ("any world", lambda f: True),
    ("down (kids need no more)", lambda f: f[0]),
    ("even (kids take the same)", lambda f: f[1]),
    ("down, even, every unit has kids", lambda f: f[0] and f[1] and f[2]),
    ("kids u = [u] (WayOfUnits)", lambda f: f[3]),
    ("one need", lambda f: f[4]),
]


def run(worlds, K, hi, way_sizes, label):
    G = givings(hi)
    ways = [c for s in way_sizes for c in multisets(K, s)]
    print("\n=== %s; ceiling %d; start ways of %s units (%d ways); levels 0..%d ===" % (
        label, hi, list(way_sizes), len(ways), hi))
    smallest = {}
    for gname, g in G.items():
        rising = step_rising(g)
        counts = {r[0]: {"empty": 0, "up-set": 0, "interval": 0, "neither": 0} for r in RESTR}
        met_counts = {r[0]: {"empty": 0, "up-set": 0, "interval": 0, "neither": 0} for r in RESTR}
        nworlds = 0
        for (need, use, kids) in worlds():
            nworlds += 1
            W = make_world(need, use, kids, g)
            f = flags(need, use, kids)
            memo = {}
            for c in ways:
                lv = [x for x in range(hi + 1) if never_ends(W, c, x, memo)]
                cl = classify(lv, hi)
                # the same, among the levels that meet every need of the start way
                top_need = max(need[i] for i in range(K) if c[i])
                lv_met = [x for x in lv if x >= top_need]
                if not lv_met:
                    clm = "empty"
                else:
                    convex = lv_met[-1] - lv_met[0] + 1 == len(lv_met)
                    clm = "up-set" if (convex and lv_met[-1] == hi) else ("interval" if convex else "neither")
                for rname, pred in RESTR:
                    if pred(f):
                        counts[rname][cl] += 1
                        met_counts[rname][clm] += 1
                if cl != "up-set" and cl != "empty":
                    size = (sum(len(k) for k in kids), sum(c), sum(use), sum(need))
                    for tag, cond in (("not an up-set", True), ("neither", cl == "neither"),
                                      ("not an up-set; down, even, some", f[0] and f[1] and f[2]),
                                      ("not an up-set among all-met levels; down, even, some",
                                       f[0] and f[1] and f[2] and clm in ("interval", "neither")),
                                      ("neither; kids u=[u]", cl == "neither" and f[3])):
                        if cond:
                            key = (gname, tag)
                            if key not in smallest or size < smallest[key][0]:
                                smallest[key] = (size, need, use, kids, c, lv)
        print("\ngiving: %s   [step z+g(z) rising: %s; g rising: %s]   worlds: %d" % (
            gname, rising, g_rising(g), nworlds))
        print("  %-34s %8s %8s %8s %8s | all-met levels only: %7s %8s %8s" % (
            "restriction", "empty", "up-set", "interval", "neither", "up-set", "interval", "neither"))
        for rname, _ in RESTR:
            d, m = counts[rname], met_counts[rname]
            print("  %-34s %8d %8d %8d %8d | %27d %8d %8d" % (
                rname, d["empty"], d["up-set"], d["interval"], d["neither"],
                m["up-set"], m["interval"], m["neither"]))
    print("\nsmallest found (by total kids, then units in the start way, total use, total need):")
    for (gname, tag), (size, need, use, kids, c, lv) in sorted(smallest.items()):
        print("  [%s] %s: need %s use %s kids %s start counts %s never-ending levels %s" % (
            gname, tag, need, use, kids, c, lv))


def two_kinds(hi):
    kidsets = [k for s in range(0, 4) for k in itertools.combinations_with_replacement(range(2), s)]
    def worlds():
        for k0 in kidsets:
            for k1 in kidsets:
                for use in itertools.product((1, 2, 3), repeat=2):
                    for need in itertools.product(range(1, hi + 1), repeat=2):
                        yield need, use, (k0, k1)
    return worlds


def three_kinds_sample(hi, n, seed=20261116):
    kidsets = [k for s in range(0, 4) for k in itertools.combinations_with_replacement(range(3), s)]
    def worlds():
        rnd = random.Random(seed)
        for _ in range(n):
            yield (tuple(rnd.randint(1, hi) for _ in range(3)),
                   tuple(rnd.randint(1, 3) for _ in range(3)),
                   tuple(rnd.choice(kidsets) for _ in range(3)))
    return worlds


if __name__ == "__main__":
    t0 = time.time()
    mode = sys.argv[1] if len(sys.argv) > 1 else "two"
    if mode == "two":
        hi = int(sys.argv[2]) if len(sys.argv) > 2 else 6
        run(two_kinds(hi), 2, hi, (1, 2), "two kinds, exhaustive: kids lists of 0..3, uses 1..3, needs 1..%d" % hi)
    else:
        hi = int(sys.argv[2]) if len(sys.argv) > 2 else 12
        n = int(sys.argv[3]) if len(sys.argv) > 3 else 5000
        run(three_kinds_sample(hi, n), 3, hi, (1, 2),
            "three kinds, %d worlds drawn at random per giving (seed 20261116): kids lists of 0..3, uses 1..3, needs 1..%d" % (n, hi))
    print("\nseconds: %.1f" % (time.time() - t0))
