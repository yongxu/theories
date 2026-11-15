# AI-written (Fable, attack reader), 16 November 2026.
# line_ends and fall as written, again on counts (ways that multiply do not stop the search): with
# `closed`, a step with no unit of S settles it (gone_from). And which courses unending_iff_holds has
# instances on.
import random, time
from model import *

rng = random.Random(4)
lt = lambda use, S, w: sum(use[u] for u in w if S[u])


def gone_step(cm, S, n, x, steps=400):
    """First step with no unit of S in the way, or None within `steps`."""
    for i in range(steps + 1):
        if not any(n[u] for u in range(cm.k) if S[u]):
            return i
        n, x = cm.step(n, x)
    return None


st = dict(line_ends=0, le_fail=0, le_proper_line=0, le_max_step=0, le_max_step_minus_hi=-99, fall=0, fall_fail=0, fall_max_step=0)
ex = {}
t0 = time.time()
while time.time() - t0 < 12:
    k = rng.randint(1, 3)
    hi = rng.randint(1, 6)
    need = [rng.randint(0, hi + 1) for _ in range(k)]
    use = [rng.randint(0, 3) for _ in range(k)]
    kids = rand_kids(rng, k, 3)
    S = [rng.random() < 0.6 for _ in range(k)]
    w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 3)))
    n0 = tuple(w.count(u) for u in range(k))
    closed = all(S[u] for u in range(k) for v in kids[u] if S[v])
    if not closed:
        continue
    # line_ends
    grows = all(use[u] < lt(use, S, kids[u]) for u in range(k) if S[u])
    needs = all(need[u] > 0 for u in range(k) if S[u])
    down = all(need[v] <= need[u] for u in range(k) if S[u] for v in kids[u])
    if grows and needs and down:
        gt, tail = rand_giving(rng, hi, want_nothing=True, want_keeps=True)
        cm = Counts(need, use, kids, lambda z, gt=gt, tail=tail: gt[z] if z < len(gt) else tail)
        x = rng.randint(0, hi)
        g_ = gone_step(cm, S, n0, x)
        st['line_ends'] += 1
        st['le_proper_line'] += any(S[u] for u in w) and not all(S[u] for u in w)
        if g_ is None:
            st['le_fail'] += 1; ex.setdefault('line_ends', (hi, need, use, kids, S, gt, tail, w, x))
        else:
            st['le_max_step'] = max(st['le_max_step'], g_)
            st['le_max_step_minus_hi'] = max(st['le_max_step_minus_hi'], g_ - hi)
    # fall
    mm = rng.randint(1, hi + 1)
    need2 = [mm if S[u] else need[u] for u in range(k)]
    keepsS = all(use[u] <= lt(use, S, kids[u]) for u in range(k) if S[u])
    gt = [rng.randint(0, 4) for _ in range(hi + 3)]
    if rng.random() < 0.6:
        gt[0] = 0
    tail = rng.choice([0, gt[-1]])
    g = lambda z, gt=gt, tail=tail: gt[z] if z < len(gt) else tail
    if keepsS and g(0) < mm and all(g(z) < lt(use, S, w) for z in range(len(gt) + 2)):
        cm = Counts(need2, use, kids, g)
        x = rng.randint(0, 3 * hi + 6)
        g_ = gone_step(cm, S, n0, x)
        st['fall'] += 1
        if g_ is None:
            st['fall_fail'] += 1; ex.setdefault('fall', (need2, use, kids, S, mm, gt, tail, w, x))
        else:
            st['fall_max_step'] = max(st['fall_max_step'], g_)
print('line_ends and fall as written, on counts [random: 1-3 kinds, closed S, kids len<=3, way len<=3; 400 steps]:')
print('  ', st, ex)

# unending_iff_holds: instances where both sides hold, by kind of course
from laws3_world import make_world  # noqa
import laws3_world
st = dict(both_true=0, take_positive=0, way_changes=0, way_changes_and_take_positive=0, some_taker_count_grows=0,
          zero_takers_multiply=0, undecided=0)
ex2 = None
t0 = time.time()
r = laws3_world.rng
while time.time() - t0 < 12:
    hi = r.randint(1, 7)
    wr = make_world(None, hi)
    if wr is None:
        continue
    need, use, kids = wr
    k = len(need)
    gt, tail = rand_giving(r, hi, want_nothing=True)
    m = M(need, use, kids, gt, tail)
    w = tuple(r.randrange(k) for _ in range(r.randint(1, 3)))
    x = r.randint(0, hi)
    reach, todo = set(), list(w)
    while todo:
        u = todo.pop()
        if u not in reach:
            reach.add(u); todo += list(kids[u])
    if not all(need[u] > 0 for u in reach):
        continue
    states, cyc = m.orbit(w, x, cap_len=600, cap_steps=120)
    ytab = {}

    def y(T):
        if T not in ytab:
            good = [v for v in range(hi + 2) if short(m.g, T, v) and meets(m.g, T, v, hi)]
            ytab[T] = r.choice(good) if good else 0
        return ytab[T]
    if not all(m.goes(*s) for s in states):
        continue
    if not all(regime(m, y, hi, s[0]) for s in states):
        continue
    if cyc is None:
        # a way that grows without end: zero-takers multiplying. Under `even` the takers' counts and the
        # zero-takers' support decide levels and Goes; a repeat of those is a proof.
        st['undecided'] += 1
        continue
    if not any(holds(m, y, *s) for s in states):
        continue
    st['both_true'] += 1
    T = [m.taken(s[0]) for s in states]
    ch = len({tuple(sorted(s[0])) for s in states}) > 1
    st['take_positive'] += T[0] > 0
    st['way_changes'] += ch
    st['way_changes_and_take_positive'] += ch and T[-1] > 0
    if ch and T[-1] > 0 and ex2 is None:
        ex2 = (hi, need, use, kids, gt, tail, w, x, dict(ytab), states[:4])
    takers = [sum(1 for u in s[0] if use[u] > 0) for s in states]
    st['some_taker_count_grows'] += any(b > a for a, b in zip(takers, takers[1:]))
print('unending_iff_holds, instances with both sides true [random, premises all true]:')
print('  ', st)
print('   an instance whose way changes and takes something:', ex2)
