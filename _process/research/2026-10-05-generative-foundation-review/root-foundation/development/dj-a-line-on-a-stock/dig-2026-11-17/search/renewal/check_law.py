# AI-written (Claude Fable 5.2), 17 Nov 2026. Small arithmetic checks of RelationalRenewal.Law.level
# (deeper/RelationalRenewal.lean:246) transcribed by hand; not a Lean run.
def monus(a, b): return a - b if a >= b else 0

def law_step(l, renew, needG, needF, draw, contrib):
    if needG <= l:
        if needF <= l: return monus(l + renew + contrib, draw)
        return l + renew
    if needF <= l: return monus(l + contrib, draw)
    return l

def levels(start, renew, needG, needF, draw, contrib, n):
    out = [start]
    for t in range(n):
        out.append(law_step(out[-1], renew, needG, needF, draw(t), contrib(t)))
    return out

# 1. D5 on the Law: for contrib c <= draw d, (draw d, contrib c) and (draw d-c, contrib 0) give the same step.
bad = []
R = range(0, 7)
for l in R:
    for renew in R:
        for needG in R:
            for needF in R:
                for d in R:
                    for c in range(0, d + 1):
                        if law_step(l, renew, needG, needF, d, c) != law_step(l, renew, needG, needF, d - c, 0):
                            bad.append((l, renew, needG, needF, d, c))
print("1. netting changes a step of the Law (c <= d):", len(bad), "cases of", 7**5 * 28 // 7)

# 2. cultivation <2,1,1,1,draw 2,contrib 1> against the netted law <2,1,1,1,draw 1,contrib 0>
print("2. cultivation:", levels(2,1,1,1,lambda t:2,lambda t:1,8), "netted:", levels(2,1,1,1,lambda t:1,lambda t:0,8))

# 3. pulse 2 = <2,1,2,1, draw 2 then 0, contrib 0 then 1>; restraint after the pulse = contrib 0 throughout
print("3. pulse 2:", levels(2,1,2,1,lambda t:2 if t==0 else 0,lambda t:0 if t==0 else 1,8))
print("   pulse 2 with no contribution (restraint only):", levels(2,1,2,1,lambda t:2 if t==0 else 0,lambda t:0,8))
print("   pulse 3:", levels(2,1,2,1,lambda t:3 if t==0 else 0,lambda t:0 if t==0 else 1,8))

# 4. Law (focal always active, contrib 0, constant draw H, renew r gated at G) against RegimeMargin.step
#    with g(z) = r if z + H >= G else 0  (RegimeMargin.lean:249: step g H x = (x - H) + g (x - H)).
diff = []
for x in R:
    for r in R:
        for G in R:
            for H in R:
                a = law_step(x, r, G, 0, H, 0)
                g = lambda z: r if z + H >= G else 0
                b = monus(x, H) + g(monus(x, H))
                if a != b: diff.append((x, r, G, H, a, b))
print("4. Law step differs from RegimeMargin.step with the matching gated giving in", len(diff), "of", 7**4, "cases; first:", diff[:6])
only_edge = all(x < H for (x, r, G, H, a, b) in diff)
print("   all differences have level < draw:", only_edge)
