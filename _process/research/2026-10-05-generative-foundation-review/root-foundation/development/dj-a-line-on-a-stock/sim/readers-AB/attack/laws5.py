# AI-written (Fable, attack reader), 16 November 2026.
# unending_iff_holds as written, again, with ways whose zero-takers multiply decided: under `even` a unit
# that takes nothing leaves only units that take nothing, so (the takers as a multiset, which zero-takers
# are present, the level) decides every later level, take, Goes and Holds. A repeat of that key is a proof.
import random, time
from model import *
import laws3_world
from laws3_world import make_world

r = laws3_world.rng
st = dict(as_written=0, fail=0, undecided=0, both_true=0, both_true_way_grows_without_end=0, both_false=0)
ex = None
t0 = time.time()
while time.time() - t0 < 20:
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
    key = lambda w, x: (tuple(sorted(u for u in w if use[u] > 0)), frozenset(u for u in w if use[u] == 0), x)
    seen, states, cyc = {}, [], None
    ww, xx = w, x
    for _ in range(200):
        kk = key(ww, xx)
        if kk in seen:
            cyc = seen[kk]
            break
        seen[kk] = len(states)
        # keep an abstract way: takers as they are, one of each zero-taker present (membership, takes, needs unchanged)
        states.append((tuple(u for u in ww if use[u] > 0) + tuple(sorted(kk[1])), xx))
        nw = m.after(ww, xx)
        xx = lvl_step(m.g, m.taken(ww), xx)
        ww = tuple(u for u in nw if use[u] > 0) + tuple(sorted({u for u in nw if use[u] == 0}))
    if cyc is None:
        st['undecided'] += 1
        continue
    ytab = {}

    def y(T):
        if T not in ytab:
            good = [v for v in range(hi + 2) if short(m.g, T, v) and meets(m.g, T, v, hi)]
            ytab[T] = r.choice(good) if good and r.random() < 0.9 else r.randint(0, hi + 1)
        return ytab[T]
    goes = [m.goes(*s) for s in states]
    n_go = next((i for i, gg in enumerate(goes) if not gg), len(states))
    if not all(regime(m, y, hi, states[q][0]) for q in range(min(n_go, len(states)))):
        continue
    lhs = n_go == len(states)
    rhs = any(holds(m, y, *states[q]) for q in range(min(n_go + 1, len(states))))
    st['as_written'] += 1
    if lhs != rhs:
        st['fail'] += 1
        ex = ex or (hi, need, use, kids, gt, tail, w, x, dict(ytab))
    elif lhs:
        st['both_true'] += 1
        st['both_true_way_grows_without_end'] += m.orbit(w, x, cap_len=300, cap_steps=60)[1] is None
    else:
        st['both_false'] += 1
print('unending_iff_holds as written, zero-takers that multiply decided:', st, ex)
