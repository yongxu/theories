# AI-written (Fable, seat 4-5-6, round 11), 16 November 2026. Searches, not proofs. Runs in seconds.
# 1. Is RuleCapture.CarrierCounts' strict share order "Rising" (Optimum.Rising) on the family [carrier]?
# 2. Is the regime's band [H+y, hi] closed under RegimeMargin.step, and the levels below H+y too?
# 3. Does only_whole's premise hold for the regime's step (is every level on one level's orbit)?
import itertools, random

# --- 1 -------------------------------------------------------------------------------------------
# outcome o = (carrier, other), other > 0. Exceeds [carrier] o' o : o.carrier < o'.carrier (other free).
# strict share order: better o' o  :=  o.carrier * o'.other < o'.carrier * o.other
def exceeds_carrier(o2, o1): return o1[0] < o2[0]
def share_above(o2, o1): return o1[0] * o2[1] < o2[0] * o1[1]
bad = [(o1, o2) for o1 in itertools.product(range(4), range(1, 5))
       for o2 in itertools.product(range(4), range(1, 5))
       if exceeds_carrier(o2, o1) and not share_above(o2, o1)]
print("1. share order Rising on [carrier]?", not bad, "| first countermodel (o, o'):", bad[0] if bad else None,
      "| count in 0..3 x 1..4:", len(bad))
# and on the family [carrier, other] (exceeds: >= on both, > on one)
def exceeds_both(o2, o1): return o1[0] <= o2[0] and o1[1] <= o2[1] and o1 != o2
bad2 = [(o1, o2) for o1 in itertools.product(range(4), range(1, 5))
        for o2 in itertools.product(range(4), range(1, 5))
        if exceeds_both(o2, o1) and not share_above(o2, o1)]
print("   share order Rising on [carrier, other]?", not bad2, "| first countermodel:", bad2[0] if bad2 else None)

# --- 2, 3 ----------------------------------------------------------------------------------------
def step(g, H, x):
    e = max(x - H, 0)
    return e + g[e]

random.seed(11)
tried = met = 0
band_open = below_open = 0
whole = 0
for _ in range(200000):
    hi = random.randint(2, 9)
    g = [0] + [random.randint(0, 4) for _ in range(hi + 6)]        # FromNothing: g 0 = 0
    H = random.randint(1, 4)
    y = random.randint(0, hi)
    tried += 1
    short = all(g[z] < H for z in range(y))                          # Short g H y
    meets = all(H <= g[z] for z in range(y, hi + 1) if z + H <= hi)  # Meets g H y hi
    keeps = all(step(g, H, x) <= hi for x in range(hi + 1))          # Keeps g H hi
    if not (short and meets and keeps and H + y <= hi):
        continue
    met += 1
    band = [x for x in range(hi + 1) if H + y <= x]
    below = [x for x in range(hi + 1) if x < H + y]
    if any(not (H + y <= step(g, H, x) <= hi) for x in band): band_open += 1
    if any(not (step(g, H, x) < H + y) for x in below): below_open += 1
    # only_whole's premise at a band level x0: every level up to hi lies on x0's forward orbit
    for x0 in band:
        orbit, x = set(), x0
        while x not in orbit:
            orbit.add(x); x = step(g, H, x)
        if orbit >= set(range(hi + 1)): whole += 1
print(f"2. regimes meeting Short, Meets, Keeps, FromNothing with H+y<=hi: {met} of {tried} tried;"
      f" band not closed in {band_open}; below-region not closed in {below_open}")
print(f"3. band levels whose forward orbit is every level up to hi (only_whole's premise): {whole}")
