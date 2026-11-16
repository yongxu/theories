# AI-written (Fable), 16 November 2026. A worked course and a small search, not a proof.
import io, contextlib, sys, random
sys.path.insert(0, '.')
with contextlib.redirect_stdout(io.StringIO()):
    from apart_line_and_whole import step_level, run, taken, concord_discord, report

# C. Four kinds. The line a -> [b], b -> [c], c -> [a, a, a, a] (uses 1, 2, 3), each needing 17; O leaves itself, needs 1.
line = {'a': (1, ['b']), 'b': (2, ['c']), 'c': (3, ['a', 'a', 'a', 'a'])}
def kindsC(u):
    if u == 'O': return (1, 1, ['O'])
    use, kids = line[u]; return (17, use, kids)
gC = lambda z: min(z, max(17 - z, 0))
report('C: a line of three kinds needing 17 of 17, beside a unit that needs 1', kindsC, lambda u: u != 'O', gC, 17,
       {'a': 1, 'O': 1}, 17, 40, ['a', 'b', 'c', 'O'])

# One side only (LineOnAStock's terms): a closed line of ONE need n that grows, not empty at the start,
# every other kind needing at least n. Claim tried: the net ends (at some step no need is met).
# And the count of worlds, with some other kind needing less than n, where the line is gone and the net goes on.
random.seed(16)
STEPS = 60
def world(others_need_at_least):
    hi = random.randint(4, 14)
    g = [0] + [random.randint(0, hi - z) for z in range(1, hi + 1)]
    giving = lambda z: g[z] if z <= hi else 0
    n = random.randint(1, hi)
    nl, no = random.randint(1, 3), random.randint(1, 3)
    L = ['L%d' % i for i in range(nl)]; O = ['O%d' % i for i in range(no)]
    K = {}
    for u in O:
        need = random.randint(n, hi + 1) if others_need_at_least else random.randint(1, hi + 1)
        K[u] = (need, random.randint(0, 2), [random.choice(O) for _ in range(random.randint(0, 2))])
    for u in L: K[u] = [n, random.randint(1, 2), None]   # a positive use, so that kids can take more
    for u in L:
        for _try in range(200):          # bounded: the first run looped for ever here (my mistake; stopped)
            kids = [random.choice(L) for _ in range(random.randint(1, 3))]
            if sum(K[v][1] for v in kids) > K[u][1]: break
        else:
            return None
        if True:
            extra = [v for v in O if K[v][0] <= n and random.random() < 0.3]   # down: kids need no more
        K[u][2] = kids + extra
    K = {u: tuple(v) for u, v in K.items()}
    way = {random.choice(L): 1}
    for u in O:
        if random.random() < 0.7: way[u] = random.randint(1, 2)
    return K, giving, hi, way, random.randint(0, hi), set(L)
def fate(K, giving, hi, way, x0, L):
    c = run(lambda u: K[u], giving, way, x0, STEPS)
    ends = next((t for t, (w, lv) in enumerate(c) if not any(K[u][0] <= lv for u in w)), None)
    gone = next((t for t, (w, lv) in enumerate(c) if not any(u in L and n > 0 for u, n in w.items())), None)
    return ends, gone
bad = 0; N = 1500; done = 0
for _ in range(N):
    w = world(True)
    if w is None: continue
    done += 1
    ends, gone = fate(*w)
    if ends is None: bad += 1
N = done
print('others needing at least the line\'s need:', N, 'worlds; the net did not end within', STEPS, 'steps in', bad)
on = 0; tot = 0
for _ in range(1500):
    w = world(False)
    if w is None: continue
    ends, gone = fate(*w)
    tot += 1
    if ends is None and gone is not None: on += 1
print('others free to need less:', tot, 'worlds; the line gone and the net still going at step', STEPS, 'in', on)
