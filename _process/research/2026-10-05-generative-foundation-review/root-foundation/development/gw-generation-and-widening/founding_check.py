"""Hand check, by brute force over a finite horizon, of GW's proposed witness `Founding`.

Formations: a0 a1 e e2 (kind a), b0 b1 c c2 (kind b); each requires its own condition at need 1.
Tokens (units) at a formation's condition = its level. Period 4.
Even t: a0 holds 2, b0 holds 2. t%4==1: a1, b1, c, e hold 1. t%4==3: a1, b1, c2, e2 hold 1.
Across even t: a0 moves 1 a0->a1 and 1 a0->(c if t%4==0 else c2); b0 moves 1 b0->b1 and 1 b0->(e or e2).
Across odd t: a1->a0, b1->b0, c/c2 -> b0, e/e2 -> a0.
This is design support only; the claims are made by the Lean plan, not by this script.
"""
F = ["a0", "a1", "e", "e2", "b0", "b1", "c", "c2"]
KIND = {f: ("a" if f in ("a0", "a1", "e", "e2") else "b") for f in F}
H = 40  # horizon


def moves(t):
    """List of (giver, from_condition, to_condition) unit moves across the step from t."""
    if t % 2 == 0:
        new_b = "c" if t % 4 == 0 else "c2"
        new_a = "e" if t % 4 == 0 else "e2"
        return [("a0", "a0", "a1"), ("a0", "a0", new_b), ("b0", "b0", "b1"), ("b0", "b0", new_a)]
    old_b = "c" if t % 4 == 1 else "c2"
    old_a = "e" if t % 4 == 1 else "e2"
    return [("a1", "a1", "a0"), ("b1", "b1", "b0"), (old_b, old_b, "b0"), (old_a, old_a, "a0")]


level = [{f: 0 for f in F} for _ in range(H + 2)]
level[0]["a0"] = 2
level[0]["b0"] = 2
for t in range(H + 1):
    nxt = dict(level[t])
    for g, src, dst in moves(t):
        nxt[src] -= 1
        nxt[dst] += 1
    assert all(v >= 0 for v in nxt.values()), (t, nxt)
    level[t + 1] = nxt

sup = lambda t, f: level[t][f] >= 1  # supported (need 1 at its own condition)
present = lambda t: sorted({g for g, _, _ in moves(t)})

# World premises: balance holds by construction of unit moves; Acting: givers supported.
for t in range(H + 1):
    for g, _, _ in moves(t):
        assert sup(t, g), ("acting", t, g)
    assert sum(level[t].values()) == 4, ("stock", t)
# Period 4 in levels.
for t in range(H - 3):
    assert level[t] == level[t + 4], ("period", t)


def passes(t, g, f):
    """PassesSupport t g f: g present and supported, f gains support, g gives to f's condition, which rises."""
    gives = any(gg == g and dst == f for gg, _, dst in moves(t))
    return (g in present(t) and sup(t, g) and (not sup(t, f)) and sup(t + 1, f)
            and level[t + 1][f] > level[t][f] and gives)


def R_Q(t, g, f):
    return g == f or (passes(t, g, f) and KIND[g] == KIND[f])


def R_P(t, g, f):
    return g == f or passes(t, g, f)


def R_I(t, g, f):
    return g == f


def linked_from(R, S, U):
    """For each formation h, the set of formations f with Linked R S f U h (chains ignore activity)."""
    back = {h: {h} for h in F}  # at step U: h linked from h
    for t in range(U - 1, S - 1, -1):
        new = {h: set() for h in F}
        for h in F:
            for mid in back[h]:
                for f in F:
                    if R(t, f, mid):
                        new[h].add(f)
        back = new
    return back


def includes_across(R, S, U):
    back = linked_from(R, S, U)
    return all(any(f in back[h] and sup(U, h) for h in F) for f in F if sup(S, f))


def exceeds_across(R, S, U):
    back = linked_from(R, S, U)
    return any(sup(U, h) and not any(sup(S, f) for f in back[h]) for h in F)


def keeps_widening(R, horizon):
    inc = all(includes_across(R, S, U) for S in range(horizon) for U in range(S, horizon))
    opens = all(any(exceeds_across(R, S, U) for U in range(S, S + 4)) for S in range(horizon - 4))
    return inc, opens


print("R_Q (within kind):", keeps_widening(R_Q, 24))
print("by name:", keeps_widening(R_I, 24))
print("all passings:", keeps_widening(R_P, 24))

# The map, along a relation R on occurrences (t, f), coarse class L and fine class E.
act = lambda x: sup(x[0], x[1])
actC = lambda x, y: act(x) == act(y)
carrier = lambda x, y: actC(x, y) and x[1] == y[1]
kindC = lambda x, y: actC(x, y) and KIND[x[1]] == KIND[y[1]]
one = lambda x, y: True


def step(R):
    return lambda x, y: y[0] == x[0] + 1 and R(x[0], x[1], y[1])


def cont(Rel, L, x, y):
    return Rel(x, y) and L(x, y)


def begins(Rel, E, y):
    if y[0] == 0:
        return True
    return not any(cont(Rel, E, (y[0] - 1, w), y) for w in F)


def carries(Rel, L, E, x, y):
    return cont(Rel, L, x, y) and begins(Rel, E, y)


def successors(Rel, L, x):
    return [(x[0] + 1, f) for f in F if cont(Rel, L, x, (x[0] + 1, f))]


def check_full_generation(Rel, L, E, x, horizon):
    """全生成 up to the horizon: every point reached has a continuation and a carrying renewal ahead."""
    reached, frontier = {x}, [x]
    while frontier:
        z = frontier.pop()
        if z[0] >= horizon:
            continue
        for w in successors(Rel, L, z):
            if w not in reached:
                reached.add(w)
                frontier.append(w)
    for y in reached:
        if y[0] >= horizon - 6:
            continue
        if not successors(Rel, L, y):
            return False, ("ends", y)
        # a carrying renewal ahead of y within 4 steps
        ok, seen, fr = False, {y}, [y]
        while fr and not ok:
            z = fr.pop()
            for w in successors(Rel, L, z):
                if begins(Rel, E, w):
                    ok = True
                    break
                if w not in seen and w[0] <= y[0] + 4:
                    seen.add(w)
                    fr.append(w)
        if not ok:
            return False, ("no renewal ahead", y)
    return True, len(reached)


P = step(R_P)
print("order 0, along R_Q at (activity, carrier):", check_full_generation(step(R_Q), actC, carrier, (0, "a0"), 30))
print("order 0, along passings at (kind, carrier):", check_full_generation(P, kindC, carrier, (0, "a0"), 30))
print("order 1, along passings at (activity, kind):", check_full_generation(P, actC, kindC, (0, "a0"), 30))
print("order 1 from a b-point:", check_full_generation(P, actC, kindC, (2, "b0"), 30))
# continuation along R_Q under activity equals continuation along passings under kind, on supported points
for t in range(20):
    for g in F:
        for f in F:
            x, y = (t, g), (t + 1, f)
            if act(x):
                assert cont(step(R_Q), actC, x, y) == cont(P, kindC, x, y), (x, y)
print("cont along R_Q under activity == cont along passings under kind, from supported points: ok")
# founding passings: passings not in R_Q into formations with no supported R_Q-predecessor
found = [(t, g, f) for t in range(12) for g in F for f in F
         if passes(t, g, f) and not R_Q(t, g, f) and not any(sup(t, h) and R_Q(t, h, f) for h in F)]
print("foundings to step 12:", found)


# By kind name: any two formations of one kind linked across a step.
def R_K(t, g, f):
    return KIND[g] == KIND[f]


print("by kind name:", keeps_widening(R_K, 24))


# Renewal without end (生生) along passings at the kind class: the family {(4k, a0), (4k + 2, b0)}.
def line_reaches(Rel, E, y, targets, horizon):
    seen, fr = {y}, [y]
    while fr:
        z = fr.pop()
        if z in targets:
            return True
        if z[0] >= horizon:
            continue
        for w in successors(Rel, E, z):
            if w not in seen:
                seen.add(w)
                fr.append(w)
    return False


family = {(t, "a0") for t in range(0, 40, 4)} | {(t, "b0") for t in range(2, 40, 4)}
ok = True
for z in sorted(family):
    if z[0] > 30:
        continue
    found_member = False
    for f in F:
        y = (z[0] + 1, f)
        if P(z, y) and begins(P, kindC, y) and line_reaches(P, kindC, y, family - {z}, 40):
            found_member = True
    ok = ok and found_member
print("生生 along passings at the kind class, family of a0 and b0 hubs:", ok)
