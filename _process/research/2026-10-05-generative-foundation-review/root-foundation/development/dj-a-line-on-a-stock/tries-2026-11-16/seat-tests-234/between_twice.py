"""AI-written (Fable, seat tests 2-3-4), 16 November 2026. A search, not a proof.
Regulation.Between m x y            := (m <= x -> m <= y and y <= x) and (x <= m -> x <= y and y <= m)     (Regulation.lean:109)
RegimeMargin.Adjusted.Between A g   := forall e r, (r <= A e r and A e r <= g e) or (g e <= A e r and A e r <= r)  (RegimeMargin.lean:325)
Is the second, at each (e, r), the first with m := g e, x := r, y := A e r ?"""
N = 14
bad = 0; n = 0
for m in range(N):
    for x in range(N):
        for y in range(N):
            n += 1
            reg = ((not m <= x) or (m <= y and y <= x)) and ((not x <= m) or (x <= y and y <= m))
            adj = (x <= y and y <= m) or (m <= y and y <= x)
            if reg != adj: bad += 1
print(f'triples (m, x, y) below {N}: {n}; where the two differ: {bad}')
