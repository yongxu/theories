# AI-written (Fable, seat links 1-3), 16 November 2026. A search, not a proof.
# Link 2: is a level the regime holds a level regulated towards some m in Regulation's sense?
# Definitions copied from the Lean:
#   RegimeMargin.step g H x = (x - H) + g (x - H)           (truncated subtraction)
#   Short g H y  : all z < y, g z < H
#   Meets g H y hi : all z, y <= z, z + H <= hi -> H <= g z
#   Keeps g H hi : all x <= hi, step g H x <= hi
#   Adjusted.step_balances: step + (x - (x - H)) = x + g (x - H): taken = min x H, given = g (x - H)
#   Regulation.Between m x y : (m <= x -> m <= y <= x) and (x <= m -> x <= y <= m)
#   Flow.WithinGap m : taken <= given + (x - m) and given <= taken + (m - x)
#   Flow.Opposes m  : (m < x -> given < taken) and (x < m -> taken < given)
import itertools, random

def sub(a, b): return a - b if a >= b else 0
def step(g, H, x): return sub(x, H) + g[sub(x, H)]
def taken(H, x): return x - sub(x, H)
def given(g, H, x): return g[sub(x, H)]
def between(m, x, y):
    return (not (m <= x) or (m <= y <= x)) and (not (x <= m) or (x <= y <= m))
def within(g, H, m, x):
    return taken(H, x) <= given(g, H, x) + sub(x, m) and given(g, H, x) <= taken(H, x) + sub(m, x)
def opposes(g, H, m, x):
    return (not (m < x) or given(g, H, x) < taken(H, x)) and (not (x < m) or taken(H, x) < given(g, H, x))
def meets(g, H, y, hi): return all(H <= g[z] for z in range(y, hi + 1) if z + H <= hi)
def keeps(g, H, hi): return all(step(g, H, x) <= hi for x in range(hi + 1))
def short(g, H, y): return all(g[z] < H for z in range(y))

HI = 5
checked = held = top_fixed_fail = within_fail = opp_fail = balance_fail = iff_fail = 0
noraise_fail = 0
opp_examples = []
for g in itertools.product(range(4), repeat=HI + 1):
    for H in range(0, 4):
        # balance, and WithinGap <-> Between, at every level and every m (Regulation.within_iff_between)
        for x in range(HI + 1):
            s = step(g, H, x)
            if s + taken(H, x) != x + given(g, H, x): balance_fail += 1
            for m in range(HI + 3):
                if within(g, H, m, x) != between(m, x, s): iff_fail += 1
        for y in range(0, HI + 1):
            # below the point of no return: the premise of Flow.never_returns_below at m = H + y
            if short(g, H, y) and g[0] == 0:
                for x in range(min(H + y, HI + 1)):
                    if not given(g, H, x) <= taken(H, x): noraise_fail += 1
            for hi in range(H + y, HI + 1):
                if not (meets(g, H, y, hi) and keeps(g, H, hi)): continue
                checked += 1
                if step(g, H, hi) != hi: top_fixed_fail += 1
                for x in range(H + y, hi + 1):
                    held += 1
                    if not within(g, H, hi, x): within_fail += 1
                    if not opposes(g, H, hi, x):
                        opp_fail += 1
                        if len(opp_examples) < 3: opp_examples.append((g, H, y, hi, x))
print("regimes with holds' premises and a band:", checked, " levels held:", held)
print("balance failures (taken = min x H, given = g(x-H)):", balance_fail)
print("WithinGap m <-> Between m x (step x) failures:", iff_fail)
print("top hi not a fixed level of the step:", top_fixed_fail)
print("held level not within the gap to hi:", within_fail)
print("held level at which the exchange does NOT oppose departure from hi:", opp_fail, opp_examples)
print("below H + y with Short and FromNothing, given > taken somewhere:", noraise_fail)

# The matched thermostat (RoomNet.heater m 1, draw 1): every level 1..m is held, none returns to m.
def heater(m, c): return [c if z < m else 0 for z in range(20)]
m = 4; g = heater(m, 1); H = 1
print("matched: meets", meets(g, H, 0, m), "keeps", keeps(g, H, m),
      "runs", [[x] + [step(g, H, x)] for x in range(1, m + 1)],
      "opposes m at m-1:", opposes(g, H, m, m - 1), "within:", within(g, H, m, m - 1))
# The overshooting thermostat (heater 3 2, draw 1): course 3,4,3,4; against m = 3 and m = 4.
g = heater(3, 2); xs = [3]
for _ in range(5): xs.append(step(g, 1, xs[-1]))
print("overshooting course", xs,
      "opposes 3:", [opposes(g, 1, 3, x) for x in xs], "within 3:", [within(g, 1, 3, x) for x in xs],
      "opposes 4:", [opposes(g, 1, 4, x) for x in xs], "within 4:", [within(g, 1, 4, x) for x in xs])
# Alternation (giving 2 from nothing, 0 from more; draw 1), course 1,2,1,2 against m = 1, 2.
g = [2] + [0] * 19; xs = [1]
for _ in range(5): xs.append(step(g, 1, xs[-1]))
print("alternation course", xs,
      "opposes 1:", [opposes(g, 1, 1, x) for x in xs], "within 1:", [within(g, 1, 1, x) for x in xs])
