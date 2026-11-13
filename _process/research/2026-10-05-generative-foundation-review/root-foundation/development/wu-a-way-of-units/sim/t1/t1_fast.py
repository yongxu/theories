# AI-written (Opus reader), 13 November 2026. A faster targeted search, with t1_sim's definitions:
# every unit needing something (n >= 1) unless the case says n = 0, small hi, the first line required
# unending and with n >= 1, for the statements with every premise and with each premise dropped.
import importlib.util, random, sys
spec = importlib.util.spec_from_file_location('t', '/Users/ren/theories/tmp/r7/wu2/readers/t1_sim.py')
t = importlib.util.module_from_spec(spec); spec.loader.exec_module(t)

def gen_g(rng, hi, H, y, drop):
    L = hi + 4
    tab = []
    for z in range(L):
        r = rng.random()
        if r < 0.5:
            if z < y: v = rng.randint(0, max(H - 1, 0))
            elif z + H <= hi: v = rng.randint(H, max(H, hi - z))  # meets and (often) keeps
            else: v = rng.randint(0, 6)
        else: v = rng.randint(0, 7)
        tab.append(v)
    if drop != 'nothing' or rng.random() < 0.3: tab[0] = 0
    return tab

def case(rng, which, drop):
    hi = rng.randint(1, 10); H = rng.randint(0, 4); y = rng.randint(0, 4)
    tab = gen_g(rng, hi, H, y, drop); tail = rng.choice([0, 0, 2]); g = t.mkg(tab, tail)
    n = rng.choice([1, 1, 2, 3, 4, 0]) if rng.random() < 0.97 else 0
    m = n if rng.random() < 0.2 else rng.randint(0, 9)
    x = rng.randint(0, hi + 5) if drop == 'high' else rng.randint(0, hi)
    if which == 'T1':
        h = 0 if rng.random() < 0.15 else rng.randint(0, 4)
        m2 = rng.randint(0, m) if drop == 'more' else m + rng.randint(0, 5)
        P = {'order': n <= m, 'more': m <= m2, 'nothing': t.fromnothing(g), 'short': t.short(g, H, y),
             'meets': t.meets(g, H, y, hi), 'keeps': t.keeps(g, H, hi), 'high': x <= hi}
        a = (((m, h), (n, H)), x); b = (((m2, h), (n, H)), x)
        info = dict(tab=tab, tail=tail, hi=hi, m=m, m2=m2, h=h, n=n, H2=H, y2=y, x=x)
    else:
        hp = rng.randint(0, 5); h = 0 if rng.random() < 0.15 else rng.randint(0, hp)
        if drop == 'more': h = rng.randint(hp, hp + 4)
        H2 = hp + H - h
        if drop == 'sum': H2 = rng.randint(0, 7)
        if H2 < 0: return None
        P = {'order': n <= m, 'nothing': t.fromnothing(g), 'short': t.short(g, H, y),
             'meets': t.meets(g, H, y, hi), 'keeps': t.keeps(g, H, hi),
             'sum': h + H2 == hp + H, 'more': h <= hp, 'high': x <= hi}
        a = (((m, h), (n, H2)), x); b = (((m, hp), (n, H)), x)
        info = dict(tab=tab, tail=tail, hi=hi, m=m, n=n, h=h, H2=H2, hp=hp, H2p=H, y2p=y, x=x)
    if not all(v for k, v in P.items() if k != drop): return None
    if drop is not None and P[drop]: return None      # only cases that break the dropped premise
    if not t.unending(g, a): return None     # None (undecided) or False: not a case
    r = t.unending(g, b)
    if r is None: return None                # undecided second line: not counted
    return r, info

def run(which, drops, N, seed):
    rng = random.Random(seed)
    for drop in drops:
        tested = pos = eqn = 0; bad = None
        for _ in range(N):
            r = case(rng, which, drop)
            if r is None: continue
            ok, info = r; tested += 1
            if info['n'] > 0: pos += 1
            if info['n'] == info['m']: eqn += 1
            if not ok and bad is None: bad = info
        print(f"{which} drop={drop}: {tested} cases ({pos} with n>0, {eqn} with n=m); "
              + ("no counterexample" if bad is None else f"COUNTEREXAMPLE {bad}"), flush=True)

N = int(sys.argv[1])
run('T1', [None, 'order', 'more', 'nothing', 'short', 'meets', 'keeps', 'high'], N, 11)
run('T2', [None, 'order', 'nothing', 'short', 'meets', 'keeps', 'sum', 'more', 'high'], N, 12)
