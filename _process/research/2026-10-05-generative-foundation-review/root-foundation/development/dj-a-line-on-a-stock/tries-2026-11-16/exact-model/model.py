"""AI-written (Fable, seat exact-model), 16 November 2026. A transcription for search; a search is not a proof.

The Lean's own definitions, at chosen types, nothing new:

  Pace.turn  f h : Bool -> S x R -> S x R
      | true,  p => (f p.1 p.2, h p.1 p.2)
      | false, p => (f p.1 p.2, p.2)
  Pace.paced f h reads c t : the run of `turn`, reading where `reads` is true at the step count.
  RegimeMargin.step g H x = (x - H) + g (x - H)          (truncated subtraction)
  Regulation.Between m x y = (m <= x -> m <= y /\\ y <= x) /\\ (x <= m -> x <= y /\\ y <= m)

Chosen types:  S := Nat x Nat  (take x, stock level y),   R := Nat  (the set level m).
  f (x, y) m := (A x m, RegimeMargin.step g x y)          A : a move with Between m x (A x m), strictly nearer off m
  h (x, y) m := the source of the value (fixed, from the take, from the stock, with a top)
The net goes on while the level meets a need of one (TurningInTime.net at need 1); with g 0 = 0 the level 0 stays 0.
"""

# ---------- the Lean's definitions ----------
def rstep(g, H, x):
    left = x - H if x >= H else 0
    return left + g(left)

def between(m, x, y):
    return ((not m <= x) or (m <= y and y <= x)) and ((not x <= m) or (x <= y and y <= m))

def turn(f, h, b, p):
    s, r = p
    return (f(s, r), h(s, r)) if b else (f(s, r), r)

# ---------- moves towards m (the fast loop) ----------
def by_one(x, m):  return x + 1 if x < m else (x - 1 if x > m else x)
def by_half(x, m): return x + (m - x + 1) // 2 if x < m else (x - (x - m + 1) // 2 if x > m else x)
def at_once(x, m): return m
MOVES = {'by one': by_one, 'by half': by_half, 'at once': at_once}

def check_moves(top=30):
    for name, A in MOVES.items():
        for x in range(top):
            for m in range(top):
                y = A(x, m)
                assert between(m, x, y), (name, x, m)
                assert (not m < x) or y < x
                assert (not x < m) or x < y
    return True

# ---------- givings ----------
def tent(hi):    return lambda z: min(z, hi - z) if 0 <= z <= hi else 0     # min z (hi - z)
def refill(hi):  return lambda z: hi - z if 1 <= z <= hi else 0             # from anything left, back to the ceiling
def capped_double(hi): return lambda z: min(z, hi - z) if z <= hi else 0    # same as tent; kept for naming
def nothing():   return lambda z: 0
def doubling():  return lambda z: z                                         # rising, no bound
def flat(K):     return lambda z: min(z, K)                                 # rising, at most K a step, no ceiling
def crossing():  return lambda z: 0 if z < 2 else 4                         # RegimeMargin.Crossing.giving
def concave():   return lambda z: min(2 * z, z + 2)                         # RegimeMargin.Concave.giving

def keeps(g, H, hi):   # RegimeMargin.Keeps g H hi
    return all(rstep(g, H, x) <= hi for x in range(hi + 1))

# ---------- the fast step: two orders, both of type S -> R -> S ----------
def fast_O1(A, g):   # the stock steps under the take as it stands; the take moves in the same step
    return lambda s, m: (A(s[0], m), rstep(g, s[0], s[1]))
def fast_O2(A, g):   # the take moves first; the stock steps under the moved take
    return lambda s, m: (A(s[0], m), rstep(g, A(s[0], m), s[1]))

# ---------- sources of the value: all of type S -> R -> R ----------
def src_fixed():        return lambda s, m: m
def src_itself(c):      return lambda s, m: s[0] + c
def src_gave(g):        return lambda s, m: g(s[1] - s[0] if s[1] >= s[0] else 0)     # what the stock gives in this step
def src_reserve(r):     return lambda s, m: s[1] - r if s[1] >= r else 0             # the level less a reserve
def src_left_reserve(r):return lambda s, m: max(s[1] - s[0], 0) - r if max(s[1] - s[0], 0) >= r else 0
def src_top(c, top):    return lambda s, m: min(s[0] + c, top)
def after(f, h):        # the reading sees the configuration after the step: still S -> R -> R
    return lambda s, m: h(f(s, m), m)

# ---------- schedules ----------
def every(L, off=0): return lambda t: t % L == off % L
def never():         return lambda t: False

# ---------- running ----------
def run(f, h, reads, c, horizon, period=None, need=1):
    """Returns ('ends', step, course) or ('goes on', None, course) when a configuration with the
    schedule's phase comes back (exact for a periodic schedule), or ('open', None, course) at the horizon."""
    p = c
    seen = {}
    course = []
    for t in range(horizon):
        course.append(p)
        if p[0][1] < need:
            return 'ends', t, course
        if period is not None:
            key = (p, t % period)
            if key in seen:
                return 'goes on', None, course
            seen[key] = t
        p = turn(f, h, reads(t), p)
    return 'open', None, course

def regime_fate(g, H, y, horizon=400):
    seen = set()
    for t in range(horizon):
        if y < 1: return 'ends'
        if y in seen: return 'goes on'
        seen.add(y)
        y = rstep(g, H, y)
    return 'open'

if __name__ == '__main__':
    print('moves are Between and strictly nearer on 0..29:', check_moves())
    # the coordinator's probe, re-run through Pace.turn: tent 12, start take 3, held 3
    g = tent(12)
    for name, h in (('fixed', src_fixed()), ('itself', src_itself(1)), ('stock', src_gave(g))):
        for L in (1, 4):
            fates = ''
            for y0 in range(1, 13):
                fate, step, _ = run(fast_O1(by_one, g), h, every(L), ((3, y0), 3), 400, period=L)
                fates += '.' if fate == 'goes on' else ('x' if fate == 'ends' else '?')
            print(f'{name:7} read every {L}: start levels 1..12 -> {fates}')
