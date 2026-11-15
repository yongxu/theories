# AI-written (Fable, attack reader), 16 November 2026. The laws that ask little of the stock.
# For each: the statement as written is tested; then each premise is dropped in turn.
import itertools, random, sys, time
from model import *

rng = random.Random(20261116)
T0 = time.time()


def report(name, stats):
    print(f"{name}: " + ", ".join(f"{k}={v}" for k, v in stats.items()), flush=True)


def lists_upto(k, n):
    out = []
    for l in range(n + 1):
        out += list(itertools.product(range(k), repeat=l))
    return out


# ---------- alike_iff, alike_of_met (exhaustive, 2 kinds) ----------
def t_alike():
    k = 2
    kidopts = lists_upto(k, 2)
    ways = lists_upto(k, 3)
    st = dict(cases=0, leaves_true=0, as_written_fail=0, right_to_left_fail=0, drop_leaves_cm=0)
    first = None
    for need in itertools.product(range(4), repeat=k):
        for kids in itertools.product(kidopts, repeat=k):
            m = M(list(need), [0] * k, list(kids), [0])
            for w in ways:
                leaves = all(len(kids[u]) > 0 for u in w)
                for x in range(5):
                    for x2 in range(5):
                        st['cases'] += 1
                        alike = m.after(w, x) == m.after(w, x2)
                        same = all((need[u] <= x) == (need[u] <= x2) for u in w)
                        if same and not alike:
                            st['right_to_left_fail'] += 1
                        if leaves:
                            st['leaves_true'] += 1
                            if alike != same:
                                st['as_written_fail'] += 1
                        elif alike and not same:
                            st['drop_leaves_cm'] += 1
                            first = first or (need, kids, w, x, x2)
    report('alike_iff [exhaustive: 2 kinds, need 0..3, kids len<=2, way len<=3, levels 0..4]', st)
    print('   first countermodel without leaves:', first)


# ---------- needs_after_iff, needs_kept, need_in_after (exhaustive, 2 kinds) ----------
def t_needs_after():
    k = 2
    kidopts = lists_upto(k, 2)
    ways = lists_upto(k, 3)
    st = dict(cases=0, prem_true=0, fail=0, kept_prem=0, kept_fail=0, drop_inherit_cm=0, drop_some_cm=0,
              kept_drop_met_cm=0, need_in_after_fail=0)
    ex = {}
    for need in itertools.product(range(4), repeat=k):
        for kids in itertools.product(kidopts, repeat=k):
            m = M(list(need), [0] * k, list(kids), [0])
            inherit = all(need[v] == need[u] for u in range(k) for v in kids[u])
            some = all(len(kids[u]) > 0 for u in range(k))
            for w in ways:
                for x in range(5):
                    aft = m.after(w, x)
                    met = all(need[u] <= x for u in w)
                    for n in range(5):
                        st['cases'] += 1
                        lhs = any(need[v] == n for v in aft)
                        rhs = any(need[u] == n and n <= x for u in w)
                        rhs_kept = any(need[u] == n for u in w)
                        # need_in_after: no premise
                        if lhs and not any(need[u] <= x and need[v] == n for u in w for v in kids[u]):
                            st['need_in_after_fail'] += 1
                        if inherit and some:
                            st['prem_true'] += 1
                            if lhs != rhs:
                                st['fail'] += 1
                            if met:
                                st['kept_prem'] += 1
                                if lhs != rhs_kept:
                                    st['kept_fail'] += 1
                            elif lhs != rhs_kept:
                                st['kept_drop_met_cm'] += 1
                        elif some and not inherit and lhs != rhs:
                            st['drop_inherit_cm'] += 1
                            ex.setdefault('inherit', (need, kids, w, x, n))
                        elif inherit and not some and lhs != rhs:
                            st['drop_some_cm'] += 1
                            ex.setdefault('some', (need, kids, w, x, n))
    report('needs_after_iff / needs_kept / need_in_after [exhaustive, same family, n 0..4]', st)
    print('   countermodels:', ex)


# ---------- ways_of_alike, ways_alike (random) ----------
def t_ways(N=60000):
    st = dict(samples=0, alike_prem=0, alike_fail=0, met_prem=0, met_fail=0, met_prem_levels_differ=0,
              alike_not_met=0, weaker_prem_cm=0, kids_alike_fail=0, born_fail=0)
    for _ in range(N):
        k = rng.randint(1, 3)
        need = [rng.randint(0, 6) for _ in range(k)]
        kids = rand_kids(rng, k, 2)
        hi = rng.randint(2, 7)
        m1 = M(need, [rng.randint(0, 3) for _ in range(k)], kids, *rand_giving(rng, hi))
        m2 = M(need, [rng.randint(0, 3) for _ in range(k)], kids, *rand_giving(rng, hi))
        w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 3)))
        x, x2 = rng.randint(0, hi + 2), rng.randint(0, hi + 2)
        if rng.random() < 0.5:
            x2 = x + rng.choice([-1, 0, 1, 1]) if x > 0 else x + 1
        n = rng.randint(0, 5)
        c1, c2 = m1.course(w, x, n), m2.course(w, x2, n)
        if max(len(s[0]) for s in c1 + c2) > 400:
            continue
        st['samples'] += 1
        alike = [m1.after(c1[j][0], c1[j][1]) == m1.after(c1[j][0], c2[j][1]) for j in range(n)]
        met = [all((need[u] <= c1[j][1]) == (need[u] <= c2[j][1]) for u in c1[j][0]) for j in range(n)]
        concl = all(c1[j][0] == c2[j][0] for j in range(n + 1))
        if all(alike):
            st['alike_prem'] += 1
            if not concl:
                st['alike_fail'] += 1
            if not all(met):
                st['alike_not_met'] += 1
        if all(met):
            st['met_prem'] += 1
            if not concl:
                st['met_fail'] += 1
            if any(c1[j][1] != c2[j][1] for j in range(n)):
                st['met_prem_levels_differ'] += 1
            # kids_alike and born_alike at each j < n
            for j in range(n):
                for u in c1[j][0]:
                    ka = kids[u] if need[u] <= c1[j][1] else ()
                    kb = kids[u] if need[u] <= c2[j][1] else ()
                    if ka != kb:
                        st['kids_alike_fail'] += 1
                b1 = sum(len(kids[u]) if need[u] <= c1[j][1] else 0 for u in c1[j][0])
                b2 = sum(len(kids[u]) if need[u] <= c2[j][1] else 0 for u in c2[j][0])
                if b1 != b2:
                    st['born_fail'] += 1
        # weaker premise: alike only at j < n - 1
        if n >= 1 and all(alike[:-1]) and not alike[-1] and not concl:
            st['weaker_prem_cm'] += 1
    report('ways_of_alike / ways_alike / kids_alike / born_alike [random: 1-3 kinds, need 0..6, kids len<=2, n<=5]', st)


# ---------- rise, draw_holds (random) ----------
def t_rise(N=80000):
    st = dict(samples=0, prem=0, fail=0, holds_prem=0, holds_fail=0, drop_grows_cm=0, drop_met_cm=0, nonempty_S=0)
    for _ in range(N):
        k = rng.randint(1, 3)
        need = [rng.randint(0, 4) for _ in range(k)]
        use = [rng.randint(0, 3) for _ in range(k)]
        kids = rand_kids(rng, k, 3)
        S = [rng.random() < 0.6 for _ in range(k)]
        m = M(need, use, kids, [0])
        lt = lambda w: sum(use[u] for u in w if S[u])
        lc = lambda w: sum(1 for u in w if S[u])
        grows = all(use[u] < lt(kids[u]) for u in range(k) if S[u])
        keepsS = all(use[u] <= lt(kids[u]) for u in range(k) if S[u])
        w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 4)))
        x = rng.randint(0, 5)
        met = all(need[u] <= x for u in w if S[u])
        aft = m.after(w, x)
        concl = lt(w) + lc(w) <= lt(aft)
        st['samples'] += 1
        if grows and met:
            st['prem'] += 1
            st['nonempty_S'] += lc(w) > 0
            st['fail'] += not concl
        if keepsS and met:
            st['holds_prem'] += 1
            st['holds_fail'] += not (lt(w) <= lt(aft))
        if met and not grows and not concl:
            st['drop_grows_cm'] += 1
        if grows and not met and not concl:
            st['drop_met_cm'] += 1
    report('rise / draw_holds [random: 1-3 kinds, any S, kids len<=3, way len<=4]', st)


# ---------- gone_from, never_in (random; drop closed) ----------
def t_gone(N=40000):
    st = dict(samples=0, prem=0, fail=0, drop_closed_cm=0)
    for _ in range(N):
        k = rng.randint(1, 3)
        need = [rng.randint(0, 4) for _ in range(k)]
        use = [rng.randint(0, 3) for _ in range(k)]
        kids = rand_kids(rng, k, 2)
        S = [rng.random() < 0.5 for _ in range(k)]
        hi = rng.randint(1, 6)
        m = M(need, use, kids, *rand_giving(rng, hi))
        closed = all(S[u] for u in range(k) for v in kids[u] if S[v])
        w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 3)))
        c = m.course(w, rng.randint(0, hi + 1), 7)
        if len(c[-1][0]) > 300:
            continue
        st['samples'] += 1
        has = [any(S[u] for u in s[0]) for s in c]
        bad = any((not has[i]) and has[j] for i in range(8) for j in range(i, 8))
        if closed:
            st['prem'] += 1
            st['fail'] += bad
        elif bad:
            st['drop_closed_cm'] += 1
    report('gone_from / never_in [random, 7 steps]', st)


# ---------- takes_nothing, strip_course (random; drop zero, drop inZ) ----------
def t_strip(N=60000):
    st = dict(samples=0, prem=0, prem_with_Z_in_way=0, fail=0, drop_zero_cm=0, drop_inZ_cm=0, sc_prem=0, sc_fail=0)
    ex = {}
    for _ in range(N):
        k = rng.randint(1, 3)
        need = [rng.randint(0, 5) for _ in range(k)]
        Z = [rng.random() < 0.4 for _ in range(k)]
        use = [0 if (Z[u] and rng.random() < 0.8) else rng.randint(0, 3) for u in range(k)]
        kids = []
        for u in range(k):
            pool = [v for v in range(k) if Z[v]] if (Z[u] and rng.random() < 0.8) else list(range(k))
            kids.append(tuple(rng.choice(pool) for _ in range(rng.randint(0, 2))) if pool else ())
        hi = rng.randint(2, 7)
        m = M(need, use, kids, *rand_giving(rng, hi))
        zero = all(use[u] == 0 for u in range(k) if Z[u])
        inZ = all(Z[v] for u in range(k) if Z[u] for v in kids[u])
        strip = lambda w: tuple(u for u in w if not Z[u])
        w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 4)))
        x = rng.randint(0, hi + 1)
        n = 6
        c1, c2 = m.course(strip(w), x, n), m.course(w, x, n)
        if max(len(s[0]) for s in c1 + c2) > 400:
            continue
        st['samples'] += 1
        concl = all(c1[j][1] == c2[j][1] and strip(c1[j][0]) == strip(c2[j][0]) for j in range(n + 1))
        if zero and inZ:
            st['prem'] += 1
            st['prem_with_Z_in_way'] += any(Z[u] for u in w)
            st['fail'] += not concl
            # strip_course: another start with the same stripped way
            w2 = list(strip(w))
            zs = [u for u in range(k) if Z[u]]
            for _ in range(rng.randint(0, 3)):
                if zs:
                    w2.insert(rng.randint(0, len(w2)), rng.choice(zs))
            c3 = m.course(tuple(w2), x, n)
            st['sc_prem'] += 1
            st['sc_fail'] += not all(c3[j][1] == c2[j][1] and strip(c3[j][0]) == strip(c2[j][0]) for j in range(n + 1))
        elif inZ and not zero and not concl:
            st['drop_zero_cm'] += 1
            ex.setdefault('zero', (need, use, kids, Z, m.gt, m.tail, w, x))
        elif zero and not inZ and not concl:
            st['drop_inZ_cm'] += 1
            ex.setdefault('inZ', (need, use, kids, Z, m.gt, m.tail, w, x))
    report('takes_nothing / strip_course [random: 1-3 kinds, 6 steps]', st)
    print('   countermodels:', ex)


# ---------- account (random; drop within) ----------
def t_account(N=60000):
    st = dict(samples=0, prem=0, prem_N_pos=0, fail=0, drop_within_cm=0)
    for _ in range(N):
        k = rng.randint(1, 3)
        need = [rng.randint(0, 5) for _ in range(k)]
        use = [rng.randint(0, 3) for _ in range(k)]
        kids = rand_kids(rng, k, 2)
        hi = rng.randint(2, 9)
        m = M(need, use, kids, *rand_giving(rng, hi))
        w = tuple(rng.randrange(k) for _ in range(rng.randint(0, 3)))
        x = rng.randint(0, hi + 3)
        Nn = rng.randint(0, 6)
        c = m.course(w, x, Nn)
        if len(c[-1][0]) > 400:
            continue
        st['samples'] += 1
        tk = [m.taken(s[0]) for s in c]
        within = all(tk[t] <= c[t][1] for t in range(Nn))
        lhs = c[Nn][1] + sum(tk[t] for t in range(Nn))
        rhs = x + sum(m.g(max(c[t][1] - tk[t], 0)) for t in range(Nn))
        if within:
            st['prem'] += 1
            st['prem_N_pos'] += Nn > 0 and sum(tk[:Nn]) > 0
            st['fail'] += lhs != rhs
        elif lhs != rhs:
            st['drop_within_cm'] += 1
    report('account [random: N<=6]', st)


# ---------- step_lowers, step_overdrawn, step_zero, keeps_any (exhaustive over small numbers, random giving) ----------
def t_steps(N=4000):
    st = dict(cases=0, lowers_prem=0, lowers_fail=0, drop_short=0, drop_nothing=0, drop_more=0, drop_below=0,
              over_prem=0, over_fail=0, over_drop_short=0, over_drop_le=0, zero_fail=0, keeps_any_fail=0)
    for _ in range(N):
        hi = rng.randint(1, 7)
        gt, tail = rand_giving(rng, hi)
        g = lambda z: gt[z] if z < len(gt) else tail
        H, y, D, z = rng.randint(0, 6), rng.randint(0, 6), rng.randint(0, 8), rng.randint(0, 10)
        for z in range(0, 11):
            st['cases'] += 1
            sh, no, mo, be = short(g, H, y), g(0) == 0, H <= D, z < H + y
            s = lvl_step(g, D, z)
            concl = s == 0 or s < z
            if sh and no and mo and be:
                st['lowers_prem'] += 1
                st['lowers_fail'] += not concl
            elif not concl:
                if no and mo and be and not sh: st['drop_short'] += 1
                if sh and mo and be and not no: st['drop_nothing'] += 1
                if sh and no and be and not mo: st['drop_more'] += 1
                if sh and no and mo and not be: st['drop_below'] += 1
            # step_overdrawn: short : forall z, g z < T ; le : T <= H
            Tt = rng.randint(0, 8)
            allshort = all(g(q) < Tt for q in range(len(gt) + 2))
            c2 = lvl_step(g, D, z) < z or lvl_step(g, D, z) == g(0)
            if allshort and Tt <= D:
                st['over_prem'] += 1
                st['over_fail'] += not c2
            elif not c2:
                if Tt <= D and not allshort: st['over_drop_short'] += 1
                if allshort and Tt > D: st['over_drop_le'] += 1
            if no and z <= D and lvl_step(g, D, z) != 0:
                st['zero_fail'] += 1
            if keeps(g, 0, hi) and z <= hi and lvl_step(g, D, z) > hi:
                st['keeps_any_fail'] += 1
    report('step_lowers / step_overdrawn / step_zero / keeps_any [random giving, small numbers]', st)


for f in (t_alike, t_needs_after, t_ways, t_rise, t_gone, t_strip, t_account, t_steps):
    t = time.time()
    f()
    print(f'   ({time.time() - t:.1f}s)', flush=True)
print(f'total {time.time() - T0:.1f}s')
