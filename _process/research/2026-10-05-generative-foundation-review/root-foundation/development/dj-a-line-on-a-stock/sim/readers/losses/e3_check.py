# AI-written (Fable reader, 16 Nov 2026). Simulation of WayOfUnits' course, not Lean.
# unit = (need, use); after w x = [u in w if need u <= x]; left = step giving (taken w) x
import itertools
def giving(z): return min(z, max(12 - z, 0))
def step(g, H, x):
    z = max(x - H, 0); return z + g(z)
def course(g, w, x, n=60):
    out = [(tuple(w), x)]
    for _ in range(n):
        w2 = tuple(u for u in w if u[0] <= x)
        x2 = step(g, sum(u[1] for u in w), x)
        w, x = w2, x2
        out.append((w, x))
    return out
def unending(g, w, x, n=25):
    c = course(g, w, x, n)
    return all(any(u[0] <= lv for u in way) for way, lv in c)
def show(label, w, x, n=6):
    c = course(giving, w, x, n)
    print(label, [ (list(way), lv) for way, lv in c ], "unending" if unending(giving, w, x) else "ENDS")

A, B = (1, 3), (9, 2)
print("== E3 inside the regime (start 9 <= 12) ==")
show("B alone      ", [B], 9)
show("A and B      ", [A, B], 9)
show("A alone at 6 ", [A], 6)
show("A alone at 9 ", [A], 9)
show("A with B'=(1,2) (B not lost)", [A, (1, 2)], 9)
show("A=(1,3) at 5 (one below)   ", [A], 5)
print("== E3 above hi (start 20): bystander B takes nothing ==")
A2, B2 = (1, 3), (15, 0)
show("B alone      ", [B2], 20, 7)
show("A and B      ", [A2, B2], 20, 7)
show("A alone at 20", [A2], 20, 7)
show("A alone at 12", [A2], 12, 4)
print("== three kinds inside the regime: C takes nothing ==")
show("A,B,C=(7,0)  ", [A, B, (7, 0)], 9)
show("A,B          ", [A, B], 9)

# Break 1 (E3a no-difference): zero-use units never change level or the others' way
bad = 0
units = [(n, u) for n in (1, 5, 9) for u in (0, 1, 2, 3)]
ways3 = list(itertools.combinations_with_replacement(units, 3))
for w in ways3:
    for x in range(0, 21):
        c1 = course(giving, w, x, 25)
        wp = tuple(u for u in w if u[1] > 0)
        c2 = course(giving, wp, x, 25)
        for (way1, l1), (way2, l2) in zip(c1, c2):
            if l1 != l2 or tuple(u for u in way1 if u[1] > 0) != way2: bad += 1
print("E3a violations (zero-use units dropped):", bad)

# Break 2 (E3b): inside the regime (x <= 12), a unit met at the start is lost while NO drawer is ever lost
def lost_units(c):
    first = c[0][0]; last = c[-1][0]
    res = []
    for i, u in enumerate(first):
        # count multiplicity-insensitive
        if u not in last: res.append(u)
    return res
viol_in, viol_above, ex_above = 0, 0, None
for w in ways3:
    for x in range(1, 21):
        c = course(giving, w, x, 25)
        lost = lost_units(c)
        met_lost = [u for u in lost if u[0] <= x]
        drawer_lost = [u for u in lost if u[1] > 0]
        if met_lost and not drawer_lost and any(u[1] > 0 for u in w):
            if x <= 12: viol_in += 1
            else:
                viol_above += 1
                if ex_above is None: ex_above = (w, x)
print("E3b violations with start <= 12:", viol_in, "; cases with start > 12:", viol_above, ex_above)

# Break 3: is the first loss ever by use? (E2) trivial by construction; skip.
# Break 4: many-unit greater_need: raising one unit's need turns unending into ending (3 units, start <= 12)
found = None; cnt = 0
for w in ways3:
    if any(u[0] == 0 for u in w): continue
    for x in range(1, 13):
        if not unending(giving, w, x): continue
        for i in range(3):
            for m2 in (5, 9, 13):
                if m2 <= w[i][0]: continue
                w2 = list(w); w2[i] = (m2, w[i][1])
                if not unending(giving, w2, x):
                    cnt += 1
                    if found is None: found = (w, x, i, m2)
print("3 units: a greater need ends a line that did not end:", cnt, found)
if found:
    w, x, i, m2 = found
    show("before", list(w), x, 8)
    w2 = list(w); w2[i] = (m2, w[i][1]); show("after ", w2, x, 8)

# Break 5: B's loss is what keeps A: two drawers inside the regime; A persists after B lost;
# does A persist with B's need lowered to A's (B never lost before A)?
dep, indep = 0, 0
for a in units:
    for b in units:
        if a[1] == 0 or b[1] == 0 or not (a[0] < b[0]): continue
        for x in range(1, 13):
            if b[0] > x: continue
            c = course(giving, [a, b], x, 25)
            if b in c[-1][0] or not unending(giving, [a, b], x): continue
            # b lost, a persists
            if unending(giving, [a, (a[0], b[1])], x): indep += 1
            else: dep += 1
print("two drawers, B lost and A persists (start<=12): A ends if B is kept (need lowered):", dep, "; A persists either way:", indep)
