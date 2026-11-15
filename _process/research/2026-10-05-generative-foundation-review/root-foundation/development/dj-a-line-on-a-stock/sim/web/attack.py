# AI-written (Fable, checker of the reader "web"), 16 November 2026. A computation on four small
# courses, not a proof. It builds the proposed Web and Flow literally (F = Option U, C = Unit) and
# reads the Lean's definitions off them: Flow.taken / given / Balances (Flow.lean:269-279),
# Web.Supported / Dependent (Dependence.lean:134-139), Flow.Acting / Taking / GiversSupported
# (Flow.lean:292-301), the gate of stays_below (Continuation.lean:470-471),
# DissipatesOn (Dissipation.lean:242-244).
sub = lambda a, b: a - b if a >= b else 0                      # Nat subtraction
hump12 = lambda z: min(z, sub(12, z))                          # TurningInTime.Three.giving
step = lambda g, H, x: sub(x, H) + g(sub(x, H))                # RegimeMargin.step (line 249)
total = lambda xs, q: sum(q(a) for a in xs)                    # Prelude.total
NONE = ('none',)

def course(need, use, kids, g, w, x, n):
    out = []
    for _ in range(n + 1):
        out.append((list(w), x))
        T = total(w, lambda u: use[u])
        w, x = [v for u in w if need[u] <= x for v in kids[u]], step(g, T, x)
    return out

def check(name, need, use, kids, g, w0, x0, n, m=1):
    c = course(need, use, kids, g, w0, x0, n)
    print(f"\n== {name}: giving min z (12 - z), start level {x0}, gate m = {m}")
    acc_take = acc_give = 0
    for t in range(n):
        w, x = c[t]; x1 = c[t + 1][1]
        T = total(w, lambda u: use[u]); left = sub(x, T); G = g(left)
        present = [NONE] + [('some', u) for u in w]            # none :: w.map some
        take = lambda f: 0 if f == NONE else use[f[1]]
        give = lambda f: G if f == NONE else 0
        taken, given = total(present, take), total(present, give)
        bal = (x1 + taken == x + given)                        # Balances at t, c = ()
        # the min form: one formation takes x - (x - T) (Adjusted.step_balances, RegimeMargin.lean:517)
        bal_min = (x1 + sub(x, sub(x, T)) == x + G)
        # reading A: active (some u) := u in w and need u <= x ; reading B: active (some u) := u in w
        needf = lambda f: m if f == NONE else need[f[1]]
        actA = lambda f: (G > 0) if f == NONE else (need[f[1]] <= x)
        actB = lambda f: (G > 0) if f == NONE else True
        depA = all(needf(f) <= x for f in present if actA(f))
        depB = all(needf(f) <= x for f in present if actB(f))
        takingA = all(actA(f) for f in present if take(f) > 0)
        takingB = all(actB(f) for f in present if take(f) > 0)
        acting = all(actA(f) for f in present if give(f) > 0)
        gate = all(m <= needf(f) for f in present if give(f) > 0)
        givers = all(needf(f) <= x for f in present if give(f) > 0)
        diss = all(give(f) + (1 if take(f) > 0 else 0) <= take(f) for f in present)
        repeats = len(present) - len(set(present))
        kind = 'within' if taken <= given else 'excess'
        acc_take += taken; acc_give += given
        print(f" t={t} way={''.join(str(u) for u in w) or '-':<18} level={x:>2} taken={taken:>2} left={left:>2} "
              f"given={given} next={x1:>2} | balance {'yes' if bal else 'NO '} (min form {'yes' if bal_min else 'NO'}) "
              f"| {kind} | DependentA {depA} TakingA {takingA} | DependentB {depB} TakingB {takingB} "
              f"| Acting {acting} gate {gate} GiversSupported {givers} | Dissipates {diss} | repeats {repeats}")
        assert bal == (T <= x)
    xN = c[n][1]
    print(f" over the {n} steps: level after + taken = {xN + acc_take}, start + given = {x0 + acc_give}"
          f" (Balances.accumulates would give equality)")

# 1. WayOfUnits.With (WayOfUnits.lean:1016): units p = (need 9, use 4), q = (need 1, use 1); never ends
check("With", {'p': 9, 'q': 1}, {'p': 4, 'q': 1}, {'p': ['p'], 'q': ['q']}, hump12, ['p', 'q'], 9, 6)
# 2. WayOfUnits.Against (WayOfUnits.lean:1090): p = (9, 1), q = (1, 4); ends
check("Against", {'p': 9, 'q': 1}, {'p': 1, 'q': 4}, {'p': ['p'], 'q': ['q']}, hump12, ['p', 'q'], 9, 6)
# 3. scratch HigherStartEnds from seven (LineOnAStock.lean:1093): offspring; overdraws and ends
check("HigherStartEnds from 7", {'A': 1, 'B': 3, 'C': 12}, {'A': 3, 'B': 1, 'C': 1},
      {'A': ['B', 'B'], 'B': ['C', 'B'], 'C': ['A']}, hump12, ['A'], 7, 7)
# 4. the same from six: never ends, one kind listed twice in the way that holds
check("HigherStartEnds from 6", {'A': 1, 'B': 3, 'C': 12}, {'A': 3, 'B': 1, 'C': 1},
      {'A': ['B', 'B'], 'B': ['C', 'B'], 'C': ['A']}, hump12, ['A'], 6, 5)

# 5. A gate above one: giving nothing below m = 3. The Web's gate reads the level before the take
#    (need none = m, supported where m <= x); the regime's reads what is left (m <= x - T).
gated3 = lambda z: 0 if z < 3 else hump12(z)
print("\n== gate m = 3, one unit (need 1, use 2), levels and whether the renewer gives:")
c = course({'u': 1}, {'u': 2}, {'u': ['u']}, gated3, ['u'], 6, 5)
for t in range(5):
    w, x = c[t]; T = 2 * len(w); left = sub(x, T)
    print(f" t={t} level={x} taken={T} left={left} given={gated3(left)} | level >= m: {x >= 3} | left >= m: {left >= 3}")
