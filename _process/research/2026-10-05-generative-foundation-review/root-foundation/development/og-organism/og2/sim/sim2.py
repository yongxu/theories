"""OG2's second rule, run over small parameters. A state: quota, level, holders and others by cohort
(index = age, youngest first). Each member draws one unit a step. An empty level renews nothing.
Variants test what the laws depend on; each prints which laws still hold."""
import collections
import itertools

def sm(l): return sum(l)

def step(p, x, on=True, rev=None, v=()):
    s, l, g, f, src = p
    q, L, hs, os_ = x
    take = sm(hs) + sm(os_)
    if 'renew-at-zero' in v:
        if take > L + g:
            # graded: nobody is ruined; the draw is cut to what is there, the youngest leaving first
            room = L + g
            def cut(c):
                nonlocal room
                out = []
                for n in reversed(c):
                    t = min(n, room); room -= t; out.append(t)
                return list(reversed(out))
            hs, os_ = cut(hs), cut(os_)
            take = sm(hs) + sm(os_)
    elif L == 0 or take > L + g:
        return (q, 0, [], [])
    teacher = sm(hs[l:]) > 0
    if 'teach-after-age' in v: teacher = sm(hs[:s-1][l:]) > 0
    eh, eo = 0, 0
    if on:
        if src == 'members' and teacher: eh = q
        elif src == 'outside': eh = q
        else: eo = f
    if 'door-free' in v and on: eo = f if src != 'outside' else 0   # the door stands whoever keeps it: others always enter
    if 'door-param' in v and on and src == 'members' and not teacher: eo = 0   # a door nobody keeps
    q2 = rev if (rev is not None and sm(hs) > 0 and src != 'outside') else q
    return (q2, L + g - take, ([eh] + hs)[:s], ([eo] + os_)[:s])

def settled(q, L, s): return (q, L, [q] * s, [])
def gone(x): return x[1] == 0 and sm(x[2]) == 0 and sm(x[3]) == 0
def run(p, x, k, v=()):
    for _ in range(k): x = step(p, x, True, None, v)
    return x

def check(v=()):
    bad = []
    # central: from settled, level >= 1, held at every step iff l < s, q >= 1, q*s <= g
    for s, l, g, f, q, L in itertools.product(range(1, 5), range(0, 6), range(0, 9), range(0, 4), range(0, 4), range(1, 8)):
        p = (s, l, g, f, 'members'); x = settled(q, L, s); ok = True
        for k in range(60):
            if sm(x[2]) == 0: ok = False; break
            x = step(p, x, True, None, v)
        if ok != (l < s and q >= 1 and q * s <= g): bad.append(('central', p, q, L, ok))
    # horizon: l < s, q*s > g, q >= 1: settled through L//d, gone at L//d + 1
    for s, l, g, q, L in itertools.product(range(1, 5), range(0, 4), range(0, 9), range(1, 4), range(0, 12)):
        if l >= s or q * s <= g: continue
        d = q * s - g; p = (s, l, g, 1, 'members'); x = settled(q, L, s)
        for k in range(L // d + 1):
            if (x[0], x[1], x[2], sm(x[3])) != (q, L - k * d, [q] * s, 0): bad.append(('horizon', p, q, L, k, x))
            x = step(p, x, True, None, v)
        if not gone(x): bad.append(('horizon-gone', p, q, L, x))
    # kept: Within Q closed under on-steps, revision in [1, Q], level not falling
    for s, l, g in itertools.product(range(1, 4), range(0, 4), range(0, 9)):
        if l >= s: continue
        for Q in range(1, 4):
            if Q * s > g: continue
            for hs in itertools.product(range(1, Q + 1), repeat=s):
                for q in range(1, Q + 1):
                    for rev in [None] + list(range(1, Q + 1)):
                        y = step((s, l, g, 2, 'members'), (q, 3, list(hs), [0] * s), True, rev, v)
                        if not (len(y[2]) == s and all(1 <= c <= Q for c in y[2]) and sm(y[3]) == 0 and 1 <= y[0] <= Q and y[1] >= 3):
                            bad.append(('kept', s, l, g, Q, hs, q, rev, y))
    # no holder stays no holder, every branch, quota kept (members)
    for s, l, g, f, q, L in itertools.product(range(1, 5), range(0, 4), range(0, 4), range(0, 3), range(0, 3), range(0, 3)):
        for os_ in ([], [1], [0, 2]):
            for on, rev in itertools.product((True, False), (None, 0, 5)):
                y = step((s, l, g, f, 'members'), (q, L, [0] * s, list(os_)), on, rev, v)
                if sm(y[2]) != 0 or y[0] != q: bad.append(('no-holder', s, l, g, f, q, L, os_, on, rev))
    # the end closed: level 0, nobody, every branch, every source
    for s, l, g, f, q, src in itertools.product(range(1, 4), range(0, 3), range(0, 4), range(0, 3), range(0, 3), ('members', 'outside', 'none')):
        for on, rev in itertools.product((True, False), (None, 1)):
            y = step((s, l, g, f, src), (q, 0, [], []), on, rev, v)
            if not gone(y): bad.append(('end', s, l, g, f, q, src, on, rev))
    # open access: f*s > g ends from full cohorts at L//d + 1; f*s <= g it never does
    for s, g, f, L in itertools.product(range(1, 5), range(0, 9), range(1, 4), range(0, 12)):
        p = (s, 0, g, f, 'none'); x = (1, L, [], [f] * s)
        if f * s > g:
            d = f * s - g; x = run(p, x, L // d + 1, v)
            if not gone(x): bad.append(('open-ends', p, L, x))
        elif L >= 1:
            for _ in range(30):
                x = step(p, x, True, None, v)
                if sm(x[3]) == 0: bad.append(('open-keeps', p, L, x)); break
    # the ruin: no holder, f*s > g, every step on: gone within some bound, from every level and any others
    for s, l, g, f, q, L in itertools.product(range(1, 5), range(0, 4), range(0, 9), range(1, 4), range(0, 2), range(0, 10)):
        if f * s <= g: continue
        for os_ in ([], [f], [0, 1]):
            p = (s, l, g, f, 'members'); x = (q, L, [0] * s, list(os_)); hit = False
            for k in range(200):
                if gone(x): hit = True; break
                x = step(p, x, True, None, v)
            if not hit: bad.append(('ruin', p, q, L, os_))
    # three ends side by side, at l < s, q*s <= g < f*s: held keeps the level; hollow ends it
    # the drain: q = 0 or l >= s: no holder after s steps, on every level
    for s, l, g, f, q, L in itertools.product(range(1, 5), range(0, 6), range(0, 9), range(0, 3), range(0, 3), range(0, 5)):
        if not (q == 0 or l >= s): continue
        x = run((s, l, g, f, 'members'), settled(q, L, s), s, v)
        if sm(x[2]) != 0: bad.append(('drain', s, l, g, f, q, L, x))
    # revised to 0 with (q+f)*s <= g: holders gone, others present from s + 1 on
    for s, l, g, f, q, L in itertools.product(range(1, 5), range(0, 4), range(0, 20), range(1, 3), range(1, 3), range(1, 3)):
        if l >= s or (q + f) * s > g: continue
        p = (s, l, g, f, 'members'); x = step(p, settled(q, L, s), True, 0, v)
        x = run(p, x, s + 1, v)
        if sm(x[2]) != 0 or sm(x[3]) == 0: bad.append(('hollow', p, q, L, x))
        for k in range(30):
            x = step(p, x, True, None, v)
            if sm(x[2]) != 0 or sm(x[3]) == 0: bad.append(('hollow-stays', p, q, L, x)); break
    # the quota at no holder reads nothing: two quotas, same others and level, same future
    for s, l, g, f, L in itertools.product(range(1, 4), range(0, 3), range(0, 5), range(0, 3), range(0, 5)):
        a, b = (0, L, [0] * s, [f]), (3, L, [0] * s, [f])
        p = (s, l, g, f, 'members')
        for _ in range(12):
            a, b = step(p, a, True, None, v), step(p, b, True, None, v)
            if a[1:] != b[1:]: bad.append(('dead-letter', p, L, a, b)); break
    # family: outside held at every l, members not at l >= s; after an empty membership outside returns, members not
    for s, l, g, f, q, L in itertools.product(range(1, 4), range(0, 6), range(0, 9), range(0, 3), range(1, 3), range(1, 4)):
        if q * s > g: continue
        x = settled(q, L, s); p = (s, l, g, f, 'outside')
        for k in range(30):
            x = step(p, x, True, None, v)
            if sm(x[2]) == 0: bad.append(('outside-held', p, q, L)); break
        if sm(step(p, (q, L, [], []), True, None, v)[2]) == 0: bad.append(('outside-returns', p, q, L))
        if sm(step((s, l, g, f, 'members'), (q, L, [], []), True, None, v)[2]) != 0: bad.append(('members-returns', s, l, g, f, q, L))
    return bad

if __name__ == '__main__':
    names = ['central', 'horizon', 'horizon-gone', 'kept', 'no-holder', 'end', 'open-ends', 'open-keeps', 'ruin', 'drain', 'hollow', 'hollow-stays', 'dead-letter', 'outside-held', 'outside-returns', 'members-returns']
    for v in [(), ('renew-at-zero',), ('teach-after-age',), ('door-free',), ('door-param',)]:
        bad = check(v)
        c = collections.Counter(b[0] for b in bad)
        print(v or 'the rule', 'counterexamples', len(bad), dict(c))
        seen = set()
        for b in bad:
            if b[0] not in seen and v == ():
                seen.add(b[0]); print(' ', b)
    s, l, g, f = 3, 1, 6, 4
    for name, p, x, rv in [
        ('held, q*s <= g < f*s', (s, l, g, f, 'members'), settled(2, 2, s), None),
        ('too loose q*s > g', (s, l, g, f, 'members'), settled(3, 7, s), None),
        ('revised to 0, f*s > g', (s, l, g, f, 'members'), settled(2, 2, s), 0),
        ('revised to 0, f*s <= g', (s, l, 9, 1, 'members'), settled(2, 2, s), 0),
    ]:
        print(name); y = x
        for t in range(12):
            print(' ', t, y); y = step(p, y, True, rv if t == 0 else None)
