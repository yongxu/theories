# AI-written (Fable, attack reader), 16 November 2026. The laws that need the stock.
# For each: the statement as written; then each premise dropped in turn (all the others kept, that one false).
import itertools, random, sys, time
from model import *

rng = random.Random(1116)
T0 = time.time()


def report(name, stats):
    print(f"{name}: " + ", ".join(f"{k}={v}" for k, v in stats.items()), flush=True)


def units(k, maxneed, maxuse, maxkids, pos_need=None):
    need = [rng.randint(0, maxneed) for _ in range(k)]
    if pos_need is True:
        need = [max(n, 1) for n in need]
    use = [rng.randint(0, maxuse) for _ in range(k)]
    kids = rand_kids(rng, k, maxkids)
    return need, use, kids


def gen(drop, want, tries=400, S_any=False, one_need=False):
    """Sample a world; `want` lists unit-level predicates by name -> fn(need,use,kids,S) that must hold,
    except `drop`, which must fail. Giving premises `nothing`, `keeps` handled by rand_giving."""
    hi = rng.randint(1, 6)
    gv = rand_giving(rng, hi, want_nothing=(drop != 'nothing') if 'nothing' in want else None,
                     want_keeps=(drop != 'keeps') if 'keeps' in want else None)
    if gv is None:
        return None
    for _ in range(tries):
        k = rng.randint(1, 3)
        need, use, kids = units(k, hi + 1, 3, 3 if rng.random() < 0.3 else 2)
        if one_need:
            n0 = rng.randint(0, hi + 1)
            need = [n0] * k
        S = [True] * k if not S_any else [rng.random() < 0.6 for _ in range(k)]
        ok = True
        for name, fn in want.items():
            if name in ('nothing', 'keeps'):
                continue
            v = fn(need, use, kids, S)
            if v != (name != drop):
                ok = False
                break
        if ok:
            return hi, M(need, use, kids, *gv), S
    return None


lt = lambda use, S, w: sum(use[u] for u in w if S[u])
P = dict(
    nothing=None, keeps=None,
    grows=lambda need, use, kids, S: all(use[u] < lt(use, S, kids[u]) for u in range(len(need)) if S[u]),
    needs=lambda need, use, kids, S: all(need[u] > 0 for u in range(len(need)) if S[u]),
    down=lambda need, use, kids, S: all(need[v] <= need[u] for u in range(len(need)) if S[u] for v in kids[u]),
    closed=lambda need, use, kids, S: all(S[u] for u in range(len(need)) for v in kids[u] if S[v]),
)


def start(m, hi, high=True, ne=None, met=None, tries=60):
    for _ in range(tries):
        w = tuple(rng.randrange(m.k) for _ in range(rng.randint(0, 3)))
        x = rng.randint(0, hi) if high else rng.randint(hi + 1, hi + 4)
        if ne is not None and (len(w) > 0) != ne:
            continue
        if met is not None and all(m.need[u] <= x for u in w) != met:
            continue
        return w, x
    return None


def gone_eventually(m, S, w, x):
    states, c = m.orbit(w, x)
    if c is None:
        return None
    return not any(S[u] for s in states[c:] for u in s[0])


# ---------- need_unmet ----------
def t_need_unmet(N=9000):
    names = ['nothing', 'keeps', 'grows', 'needs', 'high', 'ne', 'met']
    st = {'as_written': 0, 'fail': 0, 'bound_reached(hi+1)': 0, 'first_n_max_minus_hi': -99}
    cms = {n: 0 for n in names}
    tried = {n: 0 for n in names}
    ex = {}
    for drop in [None] + names:
        for _ in range(N):
            r = gen(drop, {k: P[k] for k in ('nothing', 'keeps', 'grows', 'needs')})
            if r is None:
                continue
            hi, m, S = r
            s = start(m, hi, high=(drop != 'high'), ne=(drop != 'ne'), met=(drop != 'met'))
            if s is None:
                continue
            w, x = s
            c = m.course(w, x, hi + 1)
            if max(len(q[0]) for q in c) > 3000:
                continue
            ns = [n for n in range(1, hi + 2) if any(c[n][1] < m.need[u] for u in c[n][0])]
            if drop is None:
                st['as_written'] += 1
                if not ns:
                    st['fail'] += 1
                    ex.setdefault('FAIL', (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
                else:
                    st['first_n_max_minus_hi'] = max(st['first_n_max_minus_hi'], ns[0] - hi)
                    if ns[0] == hi + 1:
                        st['bound_reached(hi+1)'] += 1
                        ex.setdefault('bound', (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
            else:
                tried[drop] += 1
                if not ns:
                    cms[drop] += 1
                    ex.setdefault(drop, (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
    report('need_unmet [random: 1-3 kinds, hi 1..6, need 0..hi+1, use 0..3, kids len<=3, way len<=3]', st)
    print('   dropped premise -> countermodels / tried:', {n: f'{cms[n]}/{tried[n]}' for n in names})
    for kx, v in ex.items():
        print('   ', kx, v)


# ---------- way_ends ----------
def t_way_ends(N=9000):
    names = ['nothing', 'keeps', 'grows', 'needs', 'down', 'high']
    st = {'as_written': 0, 'fail': 0, 'undecided': 0, 'nonempty_start': 0}
    cms = {n: 0 for n in names}; tried = {n: 0 for n in names}; und = {n: 0 for n in names}; ex = {}
    for drop in [None] + names:
        for _ in range(N):
            r = gen(drop, {k: P[k] for k in ('nothing', 'keeps', 'grows', 'needs', 'down')})
            if r is None:
                continue
            hi, m, S = r
            s = start(m, hi, high=(drop != 'high'))
            w, x = s
            un = m.unending(w, x)
            if drop is None:
                st['as_written'] += 1
                st['nonempty_start'] += len(w) > 0 and m.goes(w, x)
                if un is None: st['undecided'] += 1
                elif un:
                    st['fail'] += 1
                    ex.setdefault('FAIL', (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
            else:
                tried[drop] += 1
                if un is None: und[drop] += 1
                elif un:
                    cms[drop] += 1
                    ex.setdefault(drop, (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
    report('way_ends [random, same family]', st)
    print('   dropped premise -> countermodels / tried (undecided):', {n: f'{cms[n]}/{tried[n]} ({und[n]})' for n in names})
    for kx, v in ex.items():
        print('   ', kx, v)


# ---------- line_ends ----------
def t_line_ends(N=9000):
    names = ['nothing', 'keeps', 'closed', 'grows', 'needs', 'down', 'high']
    st = {'as_written': 0, 'fail': 0, 'undecided': 0, 'proper_line_in_way': 0}
    cms = {n: 0 for n in names}; tried = {n: 0 for n in names}; und = {n: 0 for n in names}; ex = {}
    for drop in [None] + names:
        for _ in range(N):
            r = gen(drop, {k: P[k] for k in ('nothing', 'keeps', 'closed', 'grows', 'needs', 'down')}, S_any=True)
            if r is None:
                continue
            hi, m, S = r
            w, x = start(m, hi, high=(drop != 'high'))
            ge = gone_eventually(m, S, w, x)
            if drop is None:
                st['as_written'] += 1
                st['proper_line_in_way'] += any(S[u] for u in w) and not all(S[u] for u in w)
                if ge is None: st['undecided'] += 1
                elif not ge:
                    st['fail'] += 1
                    ex.setdefault('FAIL', (hi, m.need, m.use, m.kids, S, m.gt, m.tail, w, x))
            else:
                tried[drop] += 1
                if ge is None: und[drop] += 1
                elif not ge:
                    cms[drop] += 1
                    ex.setdefault(drop, (hi, m.need, m.use, m.kids, S, m.gt, m.tail, w, x))
    report('line_ends [random, any S]', st)
    print('   dropped premise -> countermodels / tried (undecided):', {n: f'{cms[n]}/{tried[n]} ({und[n]})' for n in names})
    for kx, v in ex.items():
        print('   ', kx, v)


# ---------- fall ----------
def t_fall(N=30000):
    names = ['closed', 'one', 'keeps', 'low', 'over']
    st = {'as_written': 0, 'fail': 0, 'undecided': 0}
    cms = {n: 0 for n in names}; tried = {n: 0 for n in names}; und = {n: 0 for n in names}; ex = {}
    for drop in [None] + names:
        for _ in range(N):
            k = rng.randint(1, 3)
            hi = rng.randint(1, 6)
            need, use, kids = units(k, hi + 1, 4, 2)
            S = [rng.random() < 0.6 for _ in range(k)]
            mm = rng.randint(0, hi + 1)
            if drop != 'one':
                need = [mm if S[u] else need[u] for u in range(k)]
            gt = [rng.randint(0, 4) for _ in range(hi + 3)]
            if rng.random() < 0.5: gt[0] = 0
            tail = rng.choice([0, gt[-1]])
            m = M(need, use, kids, gt, tail)
            w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 3)))
            x = rng.randint(0, hi + 3)
            pv = dict(
                closed=P['closed'](need, use, kids, S),
                one=all(need[u] == mm for u in range(k) if S[u]),
                keeps=all(use[u] <= lt(use, S, kids[u]) for u in range(k) if S[u]),
                low=m.g(0) < mm,
                over=all(m.g(z) < lt(use, S, w) for z in range(len(gt) + 2)),
            )
            if drop is None:
                if not all(pv.values()):
                    continue
            elif pv[drop] or not all(v for n, v in pv.items() if n != drop):
                continue
            ge = gone_eventually(m, S, w, x)
            if drop is None:
                st['as_written'] += 1
                if ge is None: st['undecided'] += 1
                elif not ge:
                    st['fail'] += 1
                    ex.setdefault('FAIL', (need, use, kids, S, mm, gt, tail, w, x))
            else:
                tried[drop] += 1
                if ge is None: und[drop] += 1
                elif not ge:
                    cms[drop] += 1
                    ex.setdefault(drop, (need, use, kids, S, mm, gt, tail, w, x))
    report('fall [random: 1-3 kinds, any S, giving 0..4 on a table with a constant tail, level 0..hi+3]', st)
    print('   dropped premise -> countermodels / tried (undecided):', {n: f'{cms[n]}/{tried[n]} ({und[n]})' for n in names})
    for kx, v in ex.items():
        print('   ', kx, v)


# ---------- one_need_ends ----------
def t_one_need(N=9000):
    names = ['one', 'pos', 'grows', 'nothing', 'keeps', 'high', 'ne']
    st = {'as_written': 0, 'fail': 0, 'max_m_minus_(hi+1)': -99, 'max_m_minus_(2hi+1)': -99}
    cms = {n: 0 for n in names}; tried = {n: 0 for n in names}; ex = {}
    for drop in [None] + names:
        for _ in range(N):
            want = {k: P[k] for k in ('nothing', 'keeps', 'grows')}
            r = gen(drop, want, one_need=True)
            if r is None:
                continue
            hi, m, S = r
            n0 = m.need[0]
            if drop == 'one':
                if m.k < 2: continue
                m.need = [rng.randint(1, hi + 1) for _ in range(m.k)]
                if len(set(m.need)) == 1: continue
                n0 = m.need[0]
            if (n0 > 0) != (drop != 'pos') and drop != 'one':
                continue
            if drop == 'one' and min(m.need) == 0:
                continue
            s = start(m, hi, high=(drop != 'high'), ne=(drop != 'ne'))
            if s is None: continue
            w, x = s
            # the conclusion: exists mstep <= 2hi+1 with Goes at all j < mstep, not Goes at mstep, way = generation
            c, first = [(tuple(w), x)], None
            for j in range(2 * hi + 2):
                if not m.goes(*c[j]):
                    first = j
                    break
                if len(c[j][0]) > 20000:
                    first = -1
                    break
                c.append(m.step(*c[j]))
            if first == -1:
                continue
            ok = first is not None and c[first][0] == m.generation(first, w)
            if drop is None:
                st['as_written'] += 1
                if not ok:
                    st['fail'] += 1
                    ex.setdefault('FAIL', (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
                else:
                    st['max_m_minus_(hi+1)'] = max(st['max_m_minus_(hi+1)'], first - (hi + 1))
                    st['max_m_minus_(2hi+1)'] = max(st['max_m_minus_(2hi+1)'], first - (2 * hi + 1))
            else:
                tried[drop] += 1
                if not ok:
                    cms[drop] += 1
                    ex.setdefault(drop, (hi, m.need, m.use, m.kids, m.gt, m.tail, w, x))
    report('one_need_ends [random: one need 0..hi+1, hi 1..6]', st)
    print('   dropped premise -> countermodels / tried:', {n: f'{cms[n]}/{tried[n]}' for n in names})
    for kx, v in ex.items():
        print('   ', kx, v)


# ---------- taken_below ----------
def t_taken_below(N=40000):
    st = {'samples': 0, 'prem': 0, 'fail': 0, 'drop_nothing_cm': 0, 'drop_needs_cm': 0}
    ex = {}
    for _ in range(N):
        k = rng.randint(1, 3)
        hi = rng.randint(1, 6)
        need, use, kids = units(k, hi + 1, 3, 2)
        gv = rand_giving(rng, hi)
        m = M(need, use, kids, *gv)
        w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 3)))
        x = rng.randint(0, hi + 2)
        # Needing: every unit of every generation of w needs something = every kind reachable from w
        reach, todo = set(), list(w)
        while todo:
            u = todo.pop()
            if u not in reach:
                reach.add(u); todo += list(kids[u])
        needing = all(need[u] > 0 for u in reach)
        nothing = m.g(0) == 0
        c = m.course(w, x, 7)
        if len(c[-1][0]) > 2000: continue
        st['samples'] += 1
        for n in range(7):
            if m.goes(*c[n + 1]):
                concl = m.taken(c[n][0]) < c[n][1]
                if nothing and needing:
                    st['prem'] += 1
                    st['fail'] += not concl
                elif needing and not nothing and not concl:
                    st['drop_nothing_cm'] += 1; ex.setdefault('nothing', (need, use, kids, m.gt, w, x, n))
                elif nothing and not needing and not concl:
                    st['drop_needs_cm'] += 1; ex.setdefault('needs', (need, use, kids, m.gt, w, x, n))
    report('taken_below [random, n<=6]', st)
    print('   ', ex)


for f in (t_need_unmet, t_way_ends, t_line_ends, t_fall, t_one_need, t_taken_below):
    t = time.time()
    f()
    print(f'   ({time.time() - t:.1f}s)', flush=True)
print(f'total {time.time() - T0:.1f}s')
