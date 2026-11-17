# AI-written (Claude Fable 5.2, reader "pairs-and-groups", round 16). A hand copy of
# Becoming/PairFlow.lean WhileStanding.advance (lines 481-532), natural-number subtraction truncated,
# to evaluate runs the Lean does not state. Not a proof; the Lean decides.
def run(need, upkeep, own, gift, intends, renew, draw, start, T):
    assert all(upkeep + own + gift <= need[p] for p in (0, 1))  # Parts.fits
    x = list(start); line = [0, 0]; out = [tuple(x)]; inflow = 0
    for t in range(T):
        act = [x[p] >= need[p] for p in (0, 1)]
        sends = [intends(p, t) and act[p] for p in (0, 1)]
        nxt = []
        for p in (0, 1):
            own_take = (upkeep + own + (gift if sends[p] else 0)) if act[p] else 0
            ren = renew(p, t) if act[p] else 0
            gets = gift if sends[1 - p] else 0
            avail = max(x[p] - own_take, 0) + ren + gets
            d = min(draw(p, t), avail)
            nxt.append(avail - d)
            line[p] += own if act[p] else 0
            inflow += ren
        x = nxt; out.append(tuple(x))
    return out, line, inflow

need = (3, 3)
# 1. FailedRenewal as in the Lean: one failure of the second's renewal at step 1.
ren1 = lambda p, t: 2 if p == 0 else (0 if t == 1 else 2)
for name, intends in (("sharing", lambda p, t: True), ("keeping", lambda p, t: False)):
    lv, line, inflow = run(need, 1, 1, 1, intends, ren1, lambda p, t: 0, (5, 3), 12)
    print("one failure ", name, lv[:6], "... lines", line, "sum", sum(line), "renewer gave", inflow)
# 2. A second failure of the second's renewal, at step 6, after the sharing pair settled at (3,3).
ren2 = lambda p, t: 2 if p == 0 else (0 if t in (1, 6) else 2)
for name, intends in (("sharing", lambda p, t: True), ("keeping", lambda p, t: False)):
    lv, line, inflow = run(need, 1, 1, 1, intends, ren2, lambda p, t: 0, (5, 3), 40)
    print("two failures", name, lv[:10], "... lines", line, "sum", sum(line), "renewer gave", inflow)
# 3. Mutual giving against no giving with no shortfall, from (3,3): levels and lines the same for ever.
for name, intends in (("sharing", lambda p, t: True), ("keeping", lambda p, t: False)):
    lv, line, inflow = run(need, 1, 1, 1, intends, lambda p, t: 2, lambda p, t: 0, (3, 3), 40)
    print("no shortfall", name, set(lv), "lines", line)
# 4. Routes (PairFlow.lean 373): line = start + own*n + (reach+matched)*received + kept*withheld.
#    carried = stand 2, need 1, upkeep 0, own 0, start 0, reach 1, spill 1, kept 2, spoiled 0, matched 0.
n = 40
print("Routes.carried, n=40: giver beside giver", 0 + 0*n + (1+0)*n + 2*0, "; withholder beside withholder", 0 + 0*n + (1+0)*0 + 2*n)
