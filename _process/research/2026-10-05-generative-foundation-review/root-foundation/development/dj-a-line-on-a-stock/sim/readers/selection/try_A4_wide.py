# AI-written (reader "selection", 16 Nov 2026). Wider search for A4 pairs in worlds where a unit leaves
# offspring (kids u != [u]), giving z = min z (12 - z). Read-only; seconds.
import itertools, sys
sys.path.insert(0, "/Users/ren/theories/tmp/r7/one-model/check/round9/readers/selection")
from try_A import World, A3_check, show
import io, contextlib

def grows(W, w, x, upto):
    c = W.course(w, x, upto)
    return any(len(c[t + 1][0]) > len(c[t][0]) for t in range(upto))

print("== which starts never end, worlds G=(need m,use g,kids K), S=(need 1,use s,kids [S]), start [G]")
found = []
count_never = 0
for m, g, s in itertools.product(range(1, 13), (0, 1, 2, 3), (1, 2, 3)):
    for K in (["G", "S"], ["S", "S"], ["G", "S", "S"], ["S", "G"], ["S"]):
        W = World("G=(need %d,use %d,kids %s), S=(need 1,use %d,kids [S])" % (m, g, "".join(K), s),
                  need=dict(G=m, S=1), use=dict(G=g, S=s), kids=dict(G=K, S=["S"]))
        ends = [W.ends_at(["G"], x) for x in range(13)]
        count_never += sum(e is None for e in ends)
        for x in range(13):
            for x2 in range(x + 1, 13):
                _, _, apart = A3_check(W, ["G"], x, x2)
                if apart is not None and apart >= 3 and (ends[x] is None) != (ends[x2] is None) \
                        and grows(W, ["G"], x, apart - 1):
                    found.append((apart, W, x, x2, ends[x], ends[x2]))
print("  starts (world, level) that never end:", count_never)
print("  A4 pairs with ways equal >= 3 steps and the way growing in that stretch:", len(found))
found.sort(key=lambda r: -r[0])
for apart, W, x, x2, e1, e2 in found[:6]:
    print("  ", W.name, "levels", x, x2, "ways first differ at step", apart, "ends_at", e1, e2)
    print("      ", x, "::", show(W, ["G"], x, 10)); print("      ", x2, "::", show(W, ["G"], x2, 10))
