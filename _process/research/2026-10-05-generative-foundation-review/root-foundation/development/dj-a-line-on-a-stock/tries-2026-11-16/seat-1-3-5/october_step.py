"""AI-written (Fable, seat 1-3-5, round 11), 16 November 2026. A search, not a proof.
Is October's level step (RelationalRenewal.Law.level, with needF = 0, no contribution, a constant
draw d) RegimeMargin.step g d for some giving g with g 0 = 0?
October: x -> (x + renew*[needG <= x]) -. d      (gate read before the take; give, then take)
Regime : x -> (x -. d) + g(x -. d)               (take, then give of what is left)
For x >= d the equation forces g(z) = renew*[needG <= z + d]; then x < d and g 0 = 0 are checked."""
N = 30
ok = bad = 0; firstbad = None; pattern_holds = True
for needG in range(0, 8):
    for renew in range(0, 6):
        for d in range(0, 8):
            oct_ = lambda x: max(0, x + (renew if needG <= x else 0) - d)
            g = lambda z: renew if needG <= z + d else 0
            reg = lambda x: max(0, x - d) + g(max(0, x - d))
            same = all(oct_(x) == reg(x) for x in range(N)) and g(0) == 0
            if same: ok += 1
            else:
                bad += 1
                if firstbad is None and renew > 0: firstbad = (needG, renew, d, [x for x in range(N) if oct_(x) != reg(x)][:3], g(0))
            if same != (d < needG or renew == 0): pattern_holds = False
print('parameter triples (needG, renew, d):', ok + bad, '; a giving with g 0 = 0 exists for', ok, '; none for', bad)
print('exists exactly where d < needG or renew = 0:', pattern_holds)
print('first failing triple with renew > 0 (needG, renew, d, levels that differ, g 0):', firstbad)
print('the giving, where it exists, is g z = renew*[needG <= z + d]: it depends on the draw d')
