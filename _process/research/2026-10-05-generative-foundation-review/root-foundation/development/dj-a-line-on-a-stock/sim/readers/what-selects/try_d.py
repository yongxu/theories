# AI-written (Fable reader, 16 November 2026). Hand-tries of candidate law D of
# STEPS-3-7-ON-PAPER.md, model L (lines on a stock). Runs in well under a second.
# giving z = min z (12 - z)  (TurningInTime.Three.giving)
# left w x = RegimeMargin.step giving (taken w) x = (x - taken w) + giving (x - taken w), truncated.

def giving(z):
    return min(z, max(12 - z, 0))

def run(kinds, w, x, steps=12):
    """kinds: name -> (need, use, kids). Returns list of (way, level, thresholds)."""
    out = []
    for _ in range(steps):
        th = sorted({kinds[u][0] for u in w if kinds[u][0] > 0})
        out.append((list(w), x, th))
        if not any(kinds[u][0] <= x for u in w):
            break
        nxt = []
        for u in w:
            if kinds[u][0] <= x:
                nxt += kinds[u][2]
        t = sum(kinds[u][1] for u in w)
        r = max(x - t, 0)
        w, x = nxt, r + giving(r)
    return out

def alike(kinds, w, z, z2):
    return all((kinds[u][0] <= z) == (kinds[u][0] <= z2) for u in w)

def kernel(kinds, w, z, z2):
    f = lambda x: [k for u in w if kinds[u][0] <= x for k in kinds[u][2]]
    return f(z) == f(z2)

def show(name, kinds, w, x, steps=12):
    print("==", name)
    c = run(kinds, w, x, steps)
    for n, (way, lvl, th) in enumerate(c):
        tag = "".join(way) if len(way) <= 12 else f"{way[0]}x{len(way)}"
        print(f"  step {n}: way {tag:<14} level {lvl:<3} needs in the way {th}")
    # D1 check: alike to way_0 => alike to way_n
    coarsens = all(
        (not alike(kinds, c[i][0], z, z2)) or alike(kinds, c[j][0], z, z2)
        for i in range(len(c)) for j in range(i, len(c))
        for z in range(0, 14) for z2 in range(0, 14))
    same_as_kernel = all(
        alike(kinds, way, z, z2) == kernel(kinds, way, z, z2)
        for (way, _, _) in c for z in range(0, 14) for z2 in range(0, 14))
    print("  only coarsens along the course:", coarsens,
          "| 'same needs met' = kernel of the way's own step:", same_as_kernel)
    return c

# --- D1, world 1: WayOfUnits.With.way and Against.way (kids u = [u]) from 9
K1 = {"a": (9, 4, ["a"]), "b": (1, 1, ["b"])}
show("D1 world 1a: [(9,4),(1,1)] from 9, no kids but itself", K1, ["a", "b"], 9)
K1b = {"a": (9, 1, ["a"]), "b": (1, 4, ["b"])}
show("D1 world 1b: [(9,1),(1,4)] from 9", K1b, ["a", "b"], 9)

# --- D1, world 2: copies that multiply (kids A = [A, A]), need 3, use 1, from 9
K2 = {"A": (3, 1, ["A", "A"])}
show("D1 world 2: one kind doubling, need 3 use 1, from 9", K2, ["A"], 9)

# --- D1 boundary: a kid that is NOT a copy but has a need already in the way (use differs)
K3 = {"G": (1, 5, ["g"]), "g": (1, 2, ["g"])}
show("D1 boundary: kid not a copy, same need (use 5 -> 2), from 9", K3, ["G"], 9)

# --- D1 boundary: a unit that leaves nothing: 'same needs' is finer than the step's kernel
K4 = {"d": (5, 1, []), "b": (1, 1, ["b"])}
show("kernel boundary: a unit with no kids (need 5)", K4, ["d", "b"], 9, steps=3)

# --- D2 in time: G (need 1, use 4) leaves H (need 7, use 4); S (need 1, use 1) leaves S
K5 = {"G": (1, 4, ["H"]), "H": (7, 4, ["H"]), "S": (1, 1, ["S"])}
c9 = show("D2 in time: G->H(need 7), S, from 9", K5, ["G", "S"], 9)
c8 = show("D2 same way from 8 (8 and 9 are alike to [G,S])", K5, ["G", "S"], 8)
print("  alike to [G,S]: 7~6 ?", alike(K5, ["G", "S"], 7, 6),
      "| alike to [H,S]: 7~6 ?", alike(K5, ["H", "S"], 7, 6))

# --- no variation: G leaves G
K6 = {"G": (1, 4, ["G"]), "S": (1, 1, ["S"])}
show("no variation: G->G, S, from 9", K6, ["G", "S"], 9)

# --- D2 too late (the new need lower): H needs 3
K7 = {"G": (1, 4, ["H"]), "H": (3, 4, ["H"]), "S": (1, 1, ["S"])}
show("D2 too late (new need 3): from 9", K7, ["G", "S"], 9)

# --- D2 too late (the new kind arrives two steps later): G -> G1 -> G2 -> H(7)
K8 = {"G": (1, 4, ["G1"]), "G1": (1, 4, ["G2"]), "G2": (1, 4, ["H"]),
      "H": (7, 4, ["H"]), "S": (1, 1, ["S"])}
show("D2 too late (H(7) arrives at step 3): from 9", K8, ["G", "S"], 9)

# --- D2 one step later only: G -> G1 -> H(7)
K9 = {"G": (1, 4, ["G1"]), "G1": (1, 4, ["H"]), "H": (7, 4, ["H"]), "S": (1, 1, ["S"])}
show("D2 (H(7) arrives at step 2): from 9", K9, ["G", "S"], 9)
