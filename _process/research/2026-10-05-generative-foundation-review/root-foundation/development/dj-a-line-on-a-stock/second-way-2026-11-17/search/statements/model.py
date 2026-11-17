"""AI-written (Fable), 17 November 2026. Round 15, label search-statements.

A faithful Python transcription of the definitions of
Becoming/LineOnAStock.lean (lines 136-165) and RegimeMargin.step (RegimeMargin.lean:249),
with one more thing a unit does, give : U -> Nat, in the two orders of
FROZEN-THE-SECOND-WAY.md (L: gate on what is left; B: gate on the level before the take).

Lean:
  after need kids : List U -> Nat -> List U
    | [], _ => []
    | u :: w, x => cond (decide (need u <= x)) (kids u) [] ++ after need kids w x
  taken use w = total w use
  RegimeMargin.step g H x = (x - H) + g (x - H)          (Nat subtraction, truncated)
  left giving use w x = RegimeMargin.step giving (taken use w) x
  Goes need (w, x) = exists u in w, need u <= x
  step = TurningInTime.pair after left : (w, x) |-> (after w x, left w x)
  net = Law.stepWhile Goes step ; never ends iff Goes at every configuration of the orbit
        (Law.stepWhile_unending_iff, GuardedStep.lean:143)
  course s n = Law.orbit step s n

A search, not a proof.
"""

def after(need, kids, w, x):
    out = []
    for u in w:
        if need(u) <= x:
            out.extend(kids(u))
    return out

def taken(use, w):
    return sum(use(u) for u in w)

def rm_step(g, H, x):
    z = max(x - H, 0)
    return z + g(z)

def left(giving, use, w, x):
    return rm_step(giving, taken(use, w), x)

def goes(need, s):
    w, x = s
    return any(need(u) <= x for u in w)

def step(need, kids, giving, use, s, give=None, order=None):
    """The pair's step. With give=None this is the Lean step exactly.
    With give and order in {'L','B'}: the frozen file's two orders.
      L: z = x - taken; next = z + giving z + total of give u over u in w with need u <= z
      B: the same with need u <= x
    """
    w, x = s
    w2 = after(need, kids, w, x)
    x2 = left(giving, use, w, x)
    if give is not None:
        z = max(x - taken(use, w), 0)
        gate = z if order == 'L' else x
        assert order in ('L', 'B')
        x2 += sum(give(u) for u in w if need(u) <= gate)
    return (w2, x2)

def course(need, kids, giving, use, s, n, give=None, order=None):
    for _ in range(n):
        s = step(need, kids, giving, use, s, give, order)
    return s

def outcome_by_repeat(need, kids, giving, use, s, give=None, order=None, cap=400, maxlen=5000):
    """('ends', n) with n the first step at which Goes fails; ('never', n) where the
    configuration at step n (way as a sorted multiset, level) repeats an earlier one with
    Goes at every step up to it (sound: the step depends on the way only through the
    multiset of its units, so the course is periodic from there); ('unknown', n) at the cap."""
    seen = {}
    for n in range(cap):
        if not goes(need, s):
            return ('ends', n)
        key = (tuple(sorted(map(repr, s[0]))), s[1])
        if key in seen:
            return ('never', n)
        seen[key] = n
        if len(s[0]) > maxlen:
            return ('unknown', n)
        s = step(need, kids, giving, use, s, give, order)
    return ('unknown', cap)

# ---------------------------------------------------------------- kept examples of the Lean

def three_giving(z):           # TurningInTime.Three.giving (TurningInTime.lean:2350): min z (12 - z)
    return min(z, max(12 - z, 0))

def check_doubling():
    """LineOnAStock.Doubling.course_values (LineOnAStock.lean:1736-1750)."""
    need = lambda u: 1
    use = lambda u: 1
    kids = lambda u: [(), ()]
    levels = [course(need, kids, three_giving, use, ([()], 12), n)[1] for n in range(6)]
    lens = [len(course(need, kids, three_giving, use, ([()], 12), n)[0]) for n in range(6)]
    assert levels == [12, 12, 12, 12, 8, 0], levels
    assert lens == [1, 2, 4, 8, 16, 32], lens
    assert not goes(need, course(need, kids, three_giving, use, ([()], 12), 5))
    assert all(goes(need, course(need, kids, three_giving, use, ([()], 12), n)) for n in range(5))
    assert outcome_by_repeat(need, kids, three_giving, use, ([()], 12)) == ('ends', 5)
    return levels, lens

def check_higher_start_ends():
    """LineOnAStock.HigherStartEnds.from_six, from_seven, higher_ends (lines 1810-1853)."""
    need = {'A': 1, 'B': 3, 'C': 12}.__getitem__
    use = {'A': 3, 'B': 1, 'C': 1}.__getitem__
    kd = {'A': ['B', 'B'], 'B': ['C', 'B'], 'C': ['A']}
    kids = lambda u: list(kd[u])
    c = lambda x, n: course(need, kids, three_giving, use, (['A'], x), n)
    assert c(6, 1) == (['B', 'B'], 6)
    assert c(6, 2) == (['C', 'B', 'C', 'B'], 8)
    assert c(6, 3) == (['C', 'B', 'C', 'B'], 8)
    assert outcome_by_repeat(need, kids, three_giving, use, (['A'], 6))[0] == 'never'
    assert c(7, 1) == (['B', 'B'], 8)
    assert c(7, 2) == (['C', 'B', 'C', 'B'], 12)
    assert c(7, 3) == (['A', 'C', 'B', 'A', 'C', 'B'], 12)
    assert c(7, 4) == (['B', 'B', 'A', 'C', 'B', 'B', 'B', 'A', 'C', 'B'], 4)
    assert len(c(7, 5)[0]) == 16 and c(7, 5)[1] == 0
    assert outcome_by_repeat(need, kids, three_giving, use, (['A'], 7)) == ('ends', 5)
    assert all(c(6, j)[0] == c(7, j)[0] for j in range(3))
    return True

if __name__ == '__main__':
    print('Doubling.course_values reproduced:', check_doubling())
    print('HigherStartEnds.from_six, from_seven, higher_ends reproduced:', check_higher_start_ends())
    # give = 0 is the line on a stock, in both orders
    need = {'A': 1, 'B': 3, 'C': 12}.__getitem__
    use = {'A': 3, 'B': 1, 'C': 1}.__getitem__
    kd = {'A': ['B', 'B'], 'B': ['C', 'B'], 'C': ['A']}
    kids = lambda u: list(kd[u])
    for x in range(0, 15):
        for n in range(6):
            base = course(need, kids, three_giving, use, (['A'], x), n)
            for o in ('L', 'B'):
                assert course(need, kids, three_giving, use, (['A'], x), n, give=lambda u: 0, order=o) == base
    print('give = 0 is the line on a stock in both orders: checked on HigherStartEnds, starts 0..14, steps 0..5')
