# AI-written (Opus reader), 13 November 2026.
# Faithful python of Becoming.WayOfUnits's net (lists, the filter `after`, `taken`, `left`),
# RegimeMargin.step/Short/Meets/Keeps/FromNothing, and the three statements as the Lean now states
# them: unending_above, greater_need, more_use_on_first. Each premise is also dropped in turn.
import random, sys

def step(g, H, x):
    e = x - H if x >= H else 0
    return e + g(e)

def short(g, H, y):  return all(g(z) < H for z in range(y))
def meets(g, H, y, hi): return all(H <= g(z) for z in range(y, hi + 1) if z + H <= hi)
def keeps(g, H, hi): return all(step(g, H, x) <= hi for x in range(hi + 1))
def fromnothing(g): return g(0) == 0

def taken(w): return sum(u[1] for u in w)
def after(w, x): return tuple(u for u in w if u[0] <= x)        # GrammarLaws.keep (goes x) w
def Goes(s): return any(u[0] <= s[1] for u in s[0])
def pair(g, s): return (after(s[0], s[1]), step(g, taken(s[0]), s[1]))

def orbit_all(g, s0, cap=100000):
    """The course (pair's orbit, not cut) until it cycles: list of states up to the first repeat."""
    seen = {}; states = []; s = s0
    while s not in seen:
        if len(states) > cap: return None
        seen[s] = len(states); states.append(s); s = pair(g, s)
    return states   # every later state is among these

def unending(g, s0):
    st = orbit_all(g, s0)
    if st is None: return None
    return all(Goes(s) for s in st)

def mkg(table, tail):
    T = tuple(table)
    return lambda z: T[z] if z < len(T) else tail

def rand_case(rng):
    hi = rng.randint(0, 16)
    H2 = rng.randint(0, 6); y2 = rng.randint(0, 6)
    L = hi + rng.randint(0, 4) + 1
    mode = rng.random()
    tab = []
    for z in range(L):
        if mode < 0.6:   # shaped to satisfy the regime often
            if z < y2: v = rng.randint(0, max(H2 - 1, 0)) if H2 > 0 else 0
            elif z + H2 <= hi: v = rng.randint(H2, H2 + 3)
            else: v = rng.randint(0, max(0, hi + H2 - z)) if rng.random() < 0.7 else rng.randint(0, 3)
        else:
            v = rng.randint(0, 8)
        tab.append(v)
    if rng.random() < 0.8: tab[0] = 0
    g = mkg(tab, rng.choice([0, 0, 1, 3]))
    return g, tab, hi, H2, y2

def needs(rng, special):
    n = 0 if special == 'n0' else rng.randint(1, 6)
    m = n if special == 'eq' else rng.randint(0, 10)
    return m, n

SPECIALS = ['none'] * 6 + ['n0', 'eq', 'eq', 'h0', 'h0', 'abovehi']

# ---------- T0 unending_above ----------
def T0(rng, drop):
    g, tab, hi, H, y = rand_case(rng)
    sp = rng.choice(SPECIALS)
    m, n = needs(rng, sp)
    h = 0 if sp == 'h0' else rng.randint(0, 5)
    x = rng.randint(0, 20)
    P = {'order': n <= m, 'nothing': fromnothing(g), 'short': short(g, H, y), 'needs': 0 < n}
    if not all(v for k, v in P.items() if k != drop): return None
    s0 = (((m, h), (n, H)), x)
    if not unending(g, s0): return None
    st = orbit_all(g, s0)
    ok = all(H + y <= s[1] for s in st)
    return ok, dict(tab=tab, m=m, h=h, n=n, H=H, y=y, x=x, levels=[s[1] for s in st][:12], P=P)

# ---------- T1 greater_need ----------
def T1(rng, drop):
    g, tab, hi, H2, y2 = rand_case(rng)
    sp = rng.choice(SPECIALS)
    m, n = needs(rng, sp)
    m2 = m + rng.randint(0, 5) if drop != 'more' else rng.randint(0, m)
    h = 0 if sp == 'h0' else rng.randint(0, 5)
    x = rng.randint(0, hi + 6) if (sp == 'abovehi' or drop == 'high') else rng.randint(0, hi)
    P = {'order': n <= m, 'more': m <= m2, 'nothing': fromnothing(g), 'short': short(g, H2, y2),
         'meets': meets(g, H2, y2, hi), 'keeps': keeps(g, H2, hi), 'high': x <= hi}
    if not all(v for k, v in P.items() if k != drop): return None
    a = unending(g, (((m, h), (n, H2)), x))
    if not a: return None
    b = unending(g, (((m2, h), (n, H2)), x))
    if b is None: return None
    return b, dict(tab=tab, hi=hi, m=m, m2=m2, h=h, n=n, H2=H2, y2=y2, x=x, P=P)

# ---------- T2 more_use_on_first ----------
def T2(rng, drop):
    g, tab, hi, H2p, y2p = rand_case(rng)
    sp = rng.choice(SPECIALS)
    m, n = needs(rng, sp)
    hp = rng.randint(0, 5)
    h = 0 if sp == 'h0' else rng.randint(0, hp)
    if drop == 'more' and rng.random() < 0.7: h = rng.randint(0, hp + 4)
    S = hp + H2p
    H2 = S - h
    if drop == 'sum' and rng.random() < 0.8: H2 = rng.randint(0, 8)
    if H2 < 0: return None
    x = rng.randint(0, hi + 6) if (sp == 'abovehi' or drop == 'high') else rng.randint(0, hi)
    P = {'order': n <= m, 'nothing': fromnothing(g), 'short': short(g, H2p, y2p),
         'meets': meets(g, H2p, y2p, hi), 'keeps': keeps(g, H2p, hi),
         'sum': h + H2 == hp + H2p, 'more': h <= hp, 'high': x <= hi}
    if not all(v for k, v in P.items() if k != drop): return None
    a = unending(g, (((m, h), (n, H2)), x))
    if not a: return None
    b = unending(g, (((m, hp), (n, H2p)), x))
    if b is None: return None
    return b, dict(tab=tab, hi=hi, m=m, n=n, h=h, H2=H2, hp=hp, H2p=H2p, y2p=y2p, x=x, P=P)

def run(name, f, premises, N, seed):
    rng = random.Random(seed)
    for drop in [None] + premises:
        tested = 0; bad = None; tally = {'n0': 0, 'eq': 0, 'h0': 0, 'abovehi': 0}
        for _ in range(N):
            r = f(rng, drop)
            if r is None: continue
            tested += 1
            ok, info = r
            if info['n'] == 0: tally['n0'] += 1
            if info['n'] == info['m']: tally['eq'] += 1
            if info.get('h', 1) == 0: tally['h0'] += 1
            if 'hi' in info and info['x'] > info['hi']: tally['abovehi'] += 1
            if not ok and bad is None: bad = info
        print(f"{name} drop={drop}: tested {tested} (n=0: {tally['n0']}, n=m: {tally['eq']}, h=0: {tally['h0']}, x>hi: {tally['abovehi']}); "
              + ("no counterexample" if bad is None else f"COUNTEREXAMPLE {bad}"))
        sys.stdout.flush()

if __name__ == '__main__':
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 200000
    run('T0 unending_above', T0, ['order', 'nothing', 'needs'], N, 1)
    run('T1 greater_need', T1, ['order', 'more', 'nothing', 'short', 'meets', 'keeps', 'high'], N, 2)
    run('T2 more_use_on_first', T2, ['order', 'nothing', 'short', 'meets', 'keeps', 'sum', 'more', 'high'], N, 3)
