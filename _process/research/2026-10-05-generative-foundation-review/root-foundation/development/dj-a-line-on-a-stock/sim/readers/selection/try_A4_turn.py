# AI-written (reader "selection", 16 Nov 2026). A4 pairs where the way keeps growing while the two ways
# are equal, and the lines part by a turn. giving z = min z (12 - z). Read-only; seconds.
import itertools, sys, io, contextlib
sys.path.insert(0, "/Users/ren/theories/tmp/r7/one-model/check/round9/readers/selection")
with contextlib.redirect_stdout(io.StringIO()):
    from try_A import World, A3_check, show

def growth_steps(W, w, x, upto):
    c = W.course(w, x, upto)
    return sum(len(c[t + 1][0]) > len(c[t][0]) for t in range(upto))

rows = []; higher_ends = []
for m, g, s in itertools.product(range(1, 13), (0, 1, 2, 3), (1, 2, 3)):
    for K in (["G", "S"], ["G", "S", "S"], ["S", "G"]):  # [G,G] doubles the way each step: left out (exponential)
        W = World("G=(need %d,use %d,kids %s), S=(need 1,use %d,kids [S])" % (m, g, "".join(K), s),
                  need=dict(G=m, S=1), use=dict(G=g, S=s), kids=dict(G=K, S=["S"]))
        ends = [W.ends_at(["G"], x) for x in range(13)]
        for x in range(13):
            for x2 in range(x + 1, 13):
                _, _, apart = A3_check(W, ["G"], x, x2)
                if apart is None or (ends[x] is None) == (ends[x2] is None): continue
                gs = growth_steps(W, ["G"], x, apart - 1)
                if gs >= 2: rows.append((gs, apart, W, x, x2, ends[x], ends[x2]))
                if ends[x] is None and ends[x2] is not None: higher_ends.append((apart, W, x, x2, ends[x], ends[x2]))
print("pairs differing only in level, way growing at >= 2 steps while the ways are equal, one ends and one never:", len(rows))
rows.sort(key=lambda r: (-r[0], -r[1]))
for gs, apart, W, x, x2, e1, e2 in rows[:4]:
    print("  ", W.name, "| levels", x, x2, "| growth steps", gs, "| ways first differ at step", apart, "| ends_at", e1, e2)
    print("      ", x, "::", show(W, ["G"], x, 10)); print("      ", x2, "::", show(W, ["G"], x2, 10))
print("pairs where the HIGHER start ends and the lower never does:", len(higher_ends))
higher_ends.sort(key=lambda r: -r[0])
for apart, W, x, x2, e1, e2 in higher_ends[:4]:
    print("  ", W.name, "| levels", x, x2, "| ways first differ at step", apart, "| ends_at", e1, e2)
    print("      ", x, "::", show(W, ["G"], x, 10)); print("      ", x2, "::", show(W, ["G"], x2, 10))
