# AI-written (reader "selection", 16 Nov 2026). Random small worlds of three kinds: is there an A4 pair
# (starts differing only in level; ways equal while the way grows at >= 2 steps; then one line ends and the
# other never does)? giving z = min z (12 - z). Read-only; capped so it runs in seconds.
import random
def giving(z): return min(z, max(12 - z, 0))
def step(H, x): e = x - H if x >= H else 0; return e + giving(e)
CAP = 40  # a way longer than this is cut off and the course marked 'big'
def run(need, use, kids, w, x, n=60):
    seen = {}; out = []
    for t in range(n):
        key = (tuple(w), x)
        out.append(key)
        if not any(need[u] <= x for u in w): return out, "ends", t
        if key in seen: return out, "never", None          # a configuration recurs with some unit going on
        seen[key] = t
        if len(w) > CAP: return out, "big", None
        w, x = [v for u in w for v in (kids[u] if need[u] <= x else [])], step(sum(use[u] for u in w), x)
    return out, "open", None
random.seed(20261116)
found = []; worlds = 0; never_grown = 0; big_never = 0
for _ in range(6000):
    K = "ABC"
    need = {k: random.randint(1, 12) for k in K}; use = {k: random.randint(0, 4) for k in K}
    kids = {k: [random.choice(K) for _ in range(random.choice((0, 1, 1, 2, 2, 3)))] for k in K}
    worlds += 1
    res = [run(need, use, kids, ["A"], x) for x in range(13)]
    for x in range(13):
        c, verdict, _ = res[x]
        g = sum(len(c[t + 1][0]) > len(c[t][0]) for t in range(len(c) - 1))
        if verdict == "never" and g >= 2: never_grown += 1
        for x2 in range(x + 1, 13):
            c2, verdict2, _ = res[x2]
            if {verdict, verdict2} != {"ends", "never"}: continue
            apart = next((t for t in range(min(len(c), len(c2))) if c[t][0] != c2[t][0]), None)
            if apart is None: continue
            gs = sum(len(c[t + 1][0]) > len(c[t][0]) for t in range(apart - 1))
            if gs >= 2: found.append((gs, apart, need, use, kids, x, x2, c[:10], c2[:10], verdict, verdict2))
print("worlds:", worlds, "| never-ending starts whose way grew at >= 2 steps:", never_grown)
print("A4 pairs with growth at >= 2 steps while the ways are equal:", len(found))
found.sort(key=lambda r: (-r[0], -r[1]))
fmt = lambda c: " | ".join("%s@%d" % ("".join(w) or "-", x) for w, x in c)
for gs, apart, need, use, kids, x, x2, c, c2, v, v2 in found[:3]:
    print("  need", need, "use", use, "kids", {k: "".join(v_) for k, v_ in kids.items()}, "| growth steps", gs, "| ways first differ at step", apart)
    print("     ", x, v, "::", fmt(c)); print("     ", x2, v2, "::", fmt(c2))
lower_ends = [r for r in found if r[9] == "ends"]; higher_ends = [r for r in found if r[9] == "never"]
print("of these: the lower start ends and the higher never:", len(lower_ends), "| the higher start ends and the lower never:", len(higher_ends))
for gs, apart, need, use, kids, x, x2, c, c2, v, v2 in lower_ends[:2]:
    print("  need", need, "use", use, "kids", {k: "".join(v_) for k, v_ in kids.items()}, "| growth steps", gs, "| ways first differ at step", apart)
    print("     ", x, v, "::", fmt(c)); print("     ", x2, v2, "::", fmt(c2))
