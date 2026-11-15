# AI-written (Fable, reader "stock"), 16 November 2026. Small hand worlds for candidate C and the Flow instance.
# Model L of STEPS-3-7-ON-PAPER.md: units with need, use, kids; level by RegimeMargin.step.

def step(g, H, x):
    left = max(x - H, 0)
    return left + g(left)

def after(units, w, x):
    out = []
    for u in w:
        if units[u]["need"] <= x:
            out += units[u]["kids"]
    return out

def taken(units, w):
    return sum(units[u]["use"] for u in w)

def goes(units, w, x):
    return any(units[u]["need"] <= x for u in w)

def course(units, g, w, x, n):
    rows = []
    for k in range(n):
        rows.append((list(w), x, goes(units, w, x)))
        if not goes(units, w, x):
            break
        w, x = after(units, w, x), step(g, taken(units, w), x)
    return rows

def show(name, rows):
    print(name)
    for k, (w, x, g) in enumerate(rows):
        print("  ", k, "".join(w), x, "goes" if g else "ENDS")

three = lambda z: min(z, 12 - z) if z <= 12 else 0   # TurningInTime.Three.giving shape

# World 1: two kinds that leave each other. No multiplying.
u1 = {"A": dict(need=1, use=1, kids=["B"]), "B": dict(need=1, use=2, kids=["A"])}
g1 = lambda z: {4: 1, 3: 2}.get(z, 0)
show("World 1  ([A],5)", course(u1, g1, ["A"], 5, 9))

# World 2: A leaves itself and a B; B leaves itself; B needs more than the level's top (12).
u2 = {"A": dict(need=1, use=1, kids=["A", "B"]), "B": dict(need=13, use=1, kids=["B"])}
show("World 2  need B = 13, ([A,B],6)", course(u2, three, ["A", "B"], 6, 9))
# World 2': the same with B's need within the top.
u2b = {"A": dict(need=1, use=1, kids=["A", "B"]), "B": dict(need=9, use=1, kids=["B"])}
show("World 2' need B = 9, ([A,B],6)", course(u2b, three, ["A", "B"], 6, 20))
# World 2'' fixed draw 2 from 6 for comparison (RegimeMargin alone)
x = 6; xs = []
for _ in range(6):
    xs.append(x); x = step(three, 2, x)
print("level alone under draw 2 from 6:", xs)

# World 3: strict doubling.
u3 = {"A": dict(need=1, use=1, kids=["A", "A"])}
show("World 3  doubling, ([A],6)", course(u3, three, ["A"], 6, 12))

# (a) the Flow reading of RegimeMargin.step: level' + taken = level + given
bad_min = bad_H = 0
for H in range(0, 8):
    for x in range(0, 14):
        nxt = step(three, H, x); given = three(max(x - H, 0))
        if nxt + min(x, H) != x + given: bad_min += 1
        if nxt + H != x + given: bad_H += 1
print("balance fails with take = min x H:", bad_min, "; with take = H:", bad_H, "(all at x < H:",
      all(x < H for H in range(8) for x in range(14) if step(three, H, x) + H != x + three(max(x - H, 0))), ")")
