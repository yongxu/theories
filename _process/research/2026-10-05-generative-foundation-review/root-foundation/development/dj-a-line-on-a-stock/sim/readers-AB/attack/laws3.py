# AI-written (Fable, attack reader), 16 November 2026.
# (a) targeted countermodels the random family of laws2.py cannot reach (ways that grow without end);
# (b) unending_iff_holds and reaches_holds: as written, and each premise dropped.
import random, time
from model import *

rng = random.Random(161126)
T0 = time.time()


class C:
    """The same model on counts (a way as a multiset): exact for levels, takes, Goes, membership."""

    def __init__(self, need, use, kids, g):
        self.need, self.use, self.kids, self.g, self.k = need, use, kids, g, len(need)

    def step(self, n, x):
        out = [0] * self.k
        for u in range(self.k):
            if n[u] and self.need[u] <= x:
                for v in self.kids[u]:
                    out[v] += n[u]
        return tuple(out), lvl_step(self.g, sum(n[u] * self.use[u] for u in range(self.k)), x)

    def goes(self, n, x):
        return any(n[u] and self.need[u] <= x for u in range(self.k))

    def taken(self, n):
        return sum(n[u] * self.use[u] for u in range(self.k))

    def run(self, n, x, steps):
        out = [(tuple(n), x)]
        for _ in range(steps):
            out.append(self.step(*out[-1]))
        return out

    def never_ends_proof(self, n, x, steps=80):
        """A sound proof that Goes holds for ever: an exact repeat, or a saturated stretch
        (level = g 0 throughout, take >= level, same support, counts no smaller: then by monotony of
        the count map at one level the stretch repeats with takes no smaller)."""
        c = self.run(n, x, steps)
        for i, s in enumerate(c):
            if not self.goes(*s):
                return False
        seen = {}
        for i, s in enumerate(c):
            if s in seen:
                return True
            seen[s] = i
        g0 = self.g(0)
        for t in range(steps):
            for p in range(1, steps - t):
                if all(c[i][1] == g0 for i in range(t, t + p + 1)) and \
                   all(self.taken(c[i][0]) >= c[i][1] for i in range(t, t + p)) and \
                   all((a > 0) == (b > 0) and b >= a for a, b in zip(c[t][0], c[t + p][0])):
                    return True
        return None


print('--- targeted: premises of way_ends / line_ends (S = every unit) / one_need_ends the random family could not break')
dbl = dict(need=[1], use=[1], kids=[(0, 0)])
# without `nothing`: giving 1 at nothing, 0 elsewhere; hi = 1; Keeps: x + g x <= 1 for x <= 1
g = lambda z: 1 if z == 0 else 0
c = C(g=g, **dbl)
print('no FromNothing: g0=1, keeps', keeps(g, 0, 1), '; doubling unit from ([u],1): never ends =', c.never_ends_proof((1,), 1),
      '; levels', [s[1] for s in c.run((1,), 1, 6)], 'sizes', [s[0][0] for s in c.run((1,), 1, 6)])
# without `needs`: need 0; giving 0; hi = 1
c = C(need=[0], use=[1], kids=[(0, 0)], g=lambda z: 0)
print('no needs: need 0, giving 0, from ([u],1): never ends =', c.never_ends_proof((1,), 1))
# without `keeps`: giving 3z; closed form x_t = 4^t + 2^(t+1), size 2^t
g = lambda z: 3 * z
c = C(g=g, **dbl)
r = c.run((1,), 3, 60)
print('no Keeps: giving 3z, from ([u],3), hi=3: FromNothing', g(0) == 0, '; keeps', keeps(g, 0, 3),
      '; closed form x_t = 4^t + 2^(t+1), size 2^t for t<=60:', all(r[t] == ((2 ** t,), 4 ** t + 2 ** (t + 1)) for t in range(61)),
      '; Goes at each:', all(c.goes(*s) for s in r))
# without `high`: giving 0 up to hi=1, 3z above; start 3 > 1
g = lambda z: 0 if z <= 1 else 3 * z
c = C(g=g, **dbl)
r = c.run((1,), 3, 60)
print('no high: giving 0 for z<=1, 3z above, hi=1: FromNothing', g(0) == 0, '; keeps', keeps(g, 0, 1),
      '; same closed form:', all(r[t] == ((2 ** t,), 4 ** t + 2 ** (t + 1)) for t in range(61)))
# one_need_ends without keeps, the bound: u (use 0) leaves v; v (use 1) leaves v, v; need 1; hi = 1; g 1 = 30
g = lambda z: 30 if z == 1 else 0
c = C(need=[1, 1], use=[0, 1], kids=[(1,), (1, 1)], g=g)
r = c.run((1, 0), 1, 8)
first = next(i for i, s in enumerate(r) if not c.goes(*s))
print('one_need_ends, no Keeps (hi=1, bound 3): keeps', keeps(g, 0, 1), '; first step with no need met =', first,
      '; levels', [s[1] for s in r[:8]])
# one_need_ends without `ne`: the empty way
print('one_need_ends, empty way: the conclusion holds at m = 0 for any world (Goes fails at step 0; generation 0 [] = [])')


# ---------- unending_iff_holds / reaches_holds ----------
def make_world(drop, hi):
    k = rng.randint(1, 3)
    for _ in range(300):
        use = [rng.randint(0, 3) for _ in range(k)]
        kids = []
        for u in range(k):
            best = None
            for _ in range(30):
                ks = tuple(rng.randrange(k) for _ in range(rng.randint(0 if drop == 'some' else 1, 3)))
                if drop == 'even' or sum(use[v] for v in ks) == use[u]:
                    best = ks
                    break
            if best is None:
                break
            kids.append(best)
        if len(kids) < k:
            continue
        need = [rng.randint(0 if drop == 'needs' else 1, hi + 1) for _ in range(k)]
        even = all(sum(use[v] for v in kids[u]) == use[u] for u in range(k))
        some = all(len(kids[u]) > 0 for u in range(k))
        down = all(need[v] <= need[u] for u in range(k) for v in kids[u])
        if drop != 'down' and not down:
            # repair: lower kids' needs along edges
            for _ in range(6):
                for u in range(k):
                    for v in kids[u]:
                        need[v] = min(need[v], need[u])
            down = all(need[v] <= need[u] for u in range(k) for v in kids[u])
        if even != (drop != 'even') or some != (drop != 'some') or down != (drop != 'down'):
            continue
        return need, use, kids
    return None


def t_iff(N=14000):
    names = ['even', 'some', 'down', 'needs', 'nothing', 'high', 'along']
    st = {'as_written': 0, 'fail': 0, 'undecided': 0, 'both_true': 0, 'both_false': 0,
          'both_true_way_changes': 0, 'both_true_not_kids_self': 0, 'rhs_without_goes_before_differs': 0,
          'reaches_prem(all+down+needs+nothing+along)': 0, 'reaches_fail': 0}
    cms = {n: 0 for n in names}; tried = {n: 0 for n in names}; ex = {}
    for drop in [None] + names:
        for _ in range(N):
            hi = rng.randint(1, 7)
            wr = make_world(drop, hi)
            if wr is None:
                continue
            need, use, kids = wr
            k = len(need)
            gt, tail = rand_giving(rng, hi, want_nothing=(drop != 'nothing'))
            m = M(need, use, kids, gt, tail)
            w = tuple(rng.randrange(k) for _ in range(rng.randint(1, 3)))
            x = rng.randint(0, hi) if drop != 'high' else rng.randint(hi + 1, hi + 4)
            reach, todo = set(), list(w)
            while todo:
                u = todo.pop()
                if u not in reach:
                    reach.add(u); todo += list(kids[u])
            needing = all(need[u] > 0 for u in reach)
            if needing != (drop != 'needs'):
                continue
            states, cyc = m.orbit(w, x, cap_len=600)
            if cyc is None:
                st['undecided'] += drop is None
                continue
            ytab = {}

            def y(T):
                if T not in ytab:
                    good = [v for v in range(hi + 2) if short(m.g, T, v) and meets(m.g, T, v, hi)]
                    ytab[T] = rng.choice(good) if good and rng.random() < 0.9 else rng.randint(0, hi + 1)
                return ytab[T]
            goes = [m.goes(*s) for s in states]
            n_go = next((i for i, gg in enumerate(goes) if not gg), len(states))  # Goes at all j < n_go
            along = all(regime(m, y, hi, states[kk][0]) for kk in range(min(n_go, len(states))))
            lhs = n_go == len(states)
            rhs = any(holds(m, y, *states[kk]) for kk in range(min(n_go + 1, len(states))))
            rhs_any = any(holds(m, y, *s) for s in states)
            if along != (drop != 'along'):
                continue
            if drop is None:
                st['as_written'] += 1
                if rhs != rhs_any:
                    st['rhs_without_goes_before_differs'] += 1
                if lhs != rhs:
                    st['fail'] += 1
                    ex.setdefault('FAIL', (hi, need, use, kids, gt, tail, w, x, dict(ytab)))
                elif lhs:
                    st['both_true'] += 1
                    st['both_true_way_changes'] += len({tuple(sorted(s[0])) for s in states}) > 1
                    st['both_true_not_kids_self'] += any(kids[u] != (u,) for u in reach)
                    ex.setdefault('instance_with_a_way_that_changes', None)
                    if len({tuple(sorted(s[0])) for s in states}) > 1 and ex['instance_with_a_way_that_changes'] is None:
                        ex['instance_with_a_way_that_changes'] = (hi, need, use, kids, gt, tail, w, x, dict(ytab), states[:5])
                else:
                    st['both_false'] += 1
            else:
                tried[drop] += 1
                if lhs != rhs:
                    cms[drop] += 1
                    ex.setdefault(drop, (hi, need, use, kids, gt, tail, w, x, dict(ytab), 'lhs', lhs, 'rhs', rhs))
            # reaches_holds as written: down, needs, nothing, along, all  (no even, some, high)
            if drop in (None, 'even', 'some', 'high') and lhs:
                st['reaches_prem(all+down+needs+nothing+along)'] += 1
                if not rhs_any:
                    st['reaches_fail'] += 1
                    ex.setdefault('REACHES_FAIL', (hi, need, use, kids, gt, tail, w, x, dict(ytab)))
    print('unending_iff_holds [random: 1-3 kinds, hi 1..7, need 1..hi+1, use 0..3, kids len<=3, way len 1..3; y chosen per take]:')
    print('  ', st)
    print('   dropped premise -> countermodels / tried:', {n: f'{cms[n]}/{tried[n]}' for n in names})
    for kx, v in ex.items():
        print('   ', kx, v)


t = time.time()
t_iff()
print(f'   ({time.time() - t:.1f}s)')

print('--- the implementer\'s three hand countermodels for unending_iff_holds, recomputed')
# without needs
m = M([0], [1], [(0,)], [0]); y = lambda T: 0
st_, cy = m.orbit((0,), 0)
print('no needs: unending', m.unending((0,), 0), '; Regime at [u], hi=0:', regime(m, y, 0, (0,)), '; Holds anywhere:', any(holds(m, y, *s) for s in st_))
# without some
m = M([1], [0], [()], [0]); y = lambda T: 0
st_, cy = m.orbit((0,), 5)
print('no some: unending', m.unending((0,), 5), '; Regime at [u], hi=5, y 0 = 0:', regime(m, y, 5, (0,)), '; Holds at step 0:', holds(m, y, (0,), 5),
      '; with y 0 = 1 Regime at [u]:', regime(m, lambda T: 1, 5, (0,)))
# without even: Doubling, y = id, hi = 12
g12 = [min(z, 12 - z) for z in range(13)]
m = M([1], [1], [(0, 0)], g12); y = lambda T: T
cc = m.course((0,), 12, 6)
print('no even (Doubling, y=id, hi=12): Goes', [m.goes(*s) for s in cc], '; Regime at steps 0..4:', [regime(m, y, 12, s[0]) for s in cc[:5]],
      '; Holds at step 0:', holds(m, y, *cc[0]))
print(f'total {time.time() - T0:.1f}s')
