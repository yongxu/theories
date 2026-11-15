"""Lines on a stock: small-world search for the candidate laws B and C.
AI-written (Fable), 16 November 2026. A search, not a proof."""
import itertools, random, sys
random.seed(20261116)

def hump(c):
    return lambda z: max(0, min(z, c - z))
def cap(Y):
    return lambda z: min(z, Y)

def step(way, x, need, use, kids, g):
    taken = sum(use[u] for u in way)
    nxt = []
    for u in way:
        if need[u] <= x:
            nxt.extend(kids[u])
    d = max(x - taken, 0)
    return tuple(sorted(nxt)), d + g(d)

def goes(way, x, need):
    return any(need[u] <= x for u in way)

def run(way, x, need, use, kids, g, maxlen=400, maxsteps=400):
    """returns ('ends', n, trace) | ('cycle', n, trace) | ('blown', n, trace)"""
    seen = {}
    trace = []
    way = tuple(sorted(way))
    for n in range(maxsteps):
        trace.append((way, x))
        if not goes(way, x, need):
            return 'ends', n, trace
        if (way, x) in seen:
            return 'cycle', n, trace
        seen[(way, x)] = n
        if len(way) > maxlen:
            return 'blown', n, trace
        way, x = step(way, x, need, use, kids, g)
    return 'long', maxsteps, trace

def taken(way, use): return sum(use[u] for u in way)

def worlds(K, trials):
    for _ in range(trials):
        need = [random.randint(1, 9) for _ in range(K)]
        use = [random.randint(0, 3) for _ in range(K)]
        kids = [tuple(random.randrange(K) for _ in range(random.randint(0, 3))) for _ in range(K)]
        c = random.choice([8, 10, 12, 14])
        g = hump(c)
        n0 = random.randint(1, 3)
        way = tuple(random.randrange(K) for _ in range(n0))
        x = random.randint(0, c)
        yield need, use, kids, c, g, way, x

def growth_strict(use, kids):
    return all(use[u] < sum(use[v] for v in kids[u]) for u in range(len(use)))
def needs_not_rising(need, kids):
    return all(need[v] <= need[u] for u in range(len(need)) for v in kids[u])
def needs_inherited(need, kids):
    return all(need[v] == need[u] for u in range(len(need)) for v in kids[u])

def B_search(trials=400000):
    stats = dict(tested_B1=0, B1_fail=0, tested_B2=0, B2_fail=0, B2_blown=0,
                 no_i_tested=0, no_i_unending=0, eq_tested=0, eq_unending=0)
    ex = {}
    for K in (1, 2, 3):
        for need, use, kids, c, g, way, x in worlds(K, trials // 3):
            if growth_strict(use, kids):
                # B1: within hi+2 steps some unit's need is unmet (way nonempty at start)
                stats['tested_B1'] += 1
                w, lvl = tuple(sorted(way)), x
                unmet_at = None
                for n in range(c + 3):
                    if any(need[u] > lvl for u in w) or not w:
                        unmet_at = n; break
                    if len(w) > 5000: break
                    w, lvl = step(w, lvl, need, use, kids, g)
                if unmet_at is None and len(w) <= 5000:
                    stats['B1_fail'] += 1; ex.setdefault('B1_fail', (need, use, kids, c, way, x))
                res, n, tr = run(way, x, need, use, kids, g)
                if needs_not_rising(need, kids):
                    stats['tested_B2'] += 1
                    if res == 'cycle' or res == 'long':
                        stats['B2_fail'] += 1; ex.setdefault('B2_fail', (need, use, kids, c, way, x, tr[:8]))
                    if res == 'blown': stats['B2_blown'] += 1
                else:
                    stats['no_i_tested'] += 1
                    if res == 'cycle':
                        stats['no_i_unending'] += 1; ex.setdefault('no_i_unending', (need, use, kids, c, way, x, tr[:6]))
            elif all(use[u] <= sum(use[v] for v in kids[u]) for u in range(K)) and needs_not_rising(need, kids):
                stats['eq_tested'] += 1
                res, n, tr = run(way, x, need, use, kids, g)
                if res == 'cycle':
                    stats['eq_unending'] += 1; ex.setdefault('eq_unending', (need, use, kids, c, way, x, tr[:6]))
    return stats, ex

if __name__ == '__main__':
    s, ex = B_search()
    print(s)
    for k, v in ex.items(): print(k, v)
