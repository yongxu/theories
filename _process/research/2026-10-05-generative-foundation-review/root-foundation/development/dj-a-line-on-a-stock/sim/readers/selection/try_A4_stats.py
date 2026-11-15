# AI-written (reader "selection", 16 Nov 2026). Why no A4 pair with sustained growth: do levels merge? Read-only; seconds.
import itertools, sys, io, contextlib
sys.path.insert(0, "/Users/ren/theories/tmp/r7/one-model/check/round9/readers/selection")
with contextlib.redirect_stdout(io.StringIO()):
    from try_A import World, A3_check, show
never_after_growth = []; merged = 0; pairs = 0; one_growth = []
for m, g, s in itertools.product(range(1, 13), (0, 1, 2, 3), (1, 2, 3)):
    for K in (["G", "S"], ["G", "S", "S"], ["S", "G"]):
        W = World("G=(need %d,use %d,kids %s), S=(need 1,use %d,kids [S])" % (m, g, "".join(K), s),
                  need=dict(G=m, S=1), use=dict(G=g, S=s), kids=dict(G=K, S=["S"]))
        cs = [W.course(["G"], x, 40) for x in range(13)]
        ends = [W.ends_at(["G"], x, 80) for x in range(13)]
        for x in range(13):
            c = cs[x]
            gsteps = sum(len(c[t + 1][0]) > len(c[t][0]) for t in range(40))
            if ends[x] is None and gsteps >= 2: never_after_growth.append((gsteps, W, x))
            for x2 in range(x + 1, 13):
                pairs += 1
                # do the two courses come to the same configuration?
                if any(cs[x][t] == cs[x2][t] for t in range(41)): merged += 1
                _, _, apart = A3_check(W, ["G"], x, x2)
                if apart is not None and (ends[x] is None) != (ends[x2] is None):
                    gs = sum(len(c[t + 1][0]) > len(c[t][0]) for t in range(apart - 1))
                    if gs >= 1 and apart >= 3: one_growth.append((apart, W, x, x2, ends[x], ends[x2]))
print("pairs of starts differing only in level:", pairs, "| pairs whose courses come to one configuration within 40 steps:", merged)
print("never-ending starts whose way grew at >= 2 steps (a turn in time after growth):", len(never_after_growth))
never_after_growth.sort(key=lambda r: -r[0])
for gsteps, W, x in never_after_growth[:3]:
    print("  ", W.name, "| level", x, "| growth steps", gsteps); print("      ", show(W, ["G"], x, 10))
print("A4 pairs, ways equal >= 3 steps with growth at >= 1 step in the stretch:", len(one_growth))
one_growth.sort(key=lambda r: -r[0])
seen = set()
for apart, W, x, x2, e1, e2 in one_growth:
    if W.name in seen: continue
    seen.add(W.name)
    if len(seen) > 3: break
    print("  ", W.name, "| levels", x, x2, "| ways first differ at step", apart, "| ends_at", e1, e2)
    print("      ", x, "::", show(W, ["G"], x, 9)); print("      ", x2, "::", show(W, ["G"], x2, 9))
