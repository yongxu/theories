# AI-written (Fable), 16 November 2026. A search and a worked course, not a proof.
# Link 1: a closed line that grows (LineOnAStock.line_ends) against Founding.Flow.ConfinedRise.
# The model is LineOnAStock's as it stands: after / taken / left = RegimeMargin.step giving (taken use w) x.
from collections import Counter

def step_level(giving, H, x):            # RegimeMargin.step g H x = (x - H) + g (x - H), truncated
    z = max(x - H, 0)
    return z + giving(z)

def run(kinds, giving, way, x, steps):
    """kinds: name -> (need, use, kids). way: Counter of names. Returns list of (way, level)."""
    out = [(Counter(way), x)]
    for _ in range(steps):
        w, lv = out[-1]
        nxt = Counter()
        for u, c in w.items():
            need, use, kids = kinds(u)
            if need <= lv:
                for k in kids:
                    nxt[k] += c
        T = sum(kinds(u)[1] * c for u, c in w.items())
        out.append((nxt, step_level(giving, T, lv)))
    return out

def taken(kinds, w): return sum(kinds(u)[1] * c for u, c in w.items())

def concord_discord(kinds, w, lv, amount):
    # SelectionTerm.concord / discord over ordered pairs of the family (with repeats),
    # weight = offspring number at this step (kids where met, none where not), amount = the mark.
    items = list(w.items())
    def off(u):
        need, use, kids = kinds(u)
        return len(kids) if need <= lv else 0
    con = dis = 0
    for p, cp in items:
        for q, cq in items:
            ew = max(off(p) - off(q), 0)
            con += cp * cq * ew * max(amount(p) - amount(q), 0)
            dis += cp * cq * ew * max(amount(q) - amount(p), 0)
    return con, dis

def report(title, kinds, isS, giving, hi, start_way, x0, steps, sample):
    print('==', title)
    # premises of line_ends on the kinds that occur
    assert giving(0) == 0, 'FromNothing'
    assert all(step_level(giving, 0, x) <= hi for x in range(hi + 1)), 'Keeps giving 0 hi'
    assert x0 <= hi
    for u in sample:
        need, use, kids = kinds(u)
        for v in kids:
            if isS(v): assert isS(u), 'closed'
        if isS(u):
            assert use < sum(kinds(v)[1] for v in kids if isS(v)), 'grows'
            assert 0 < need, 'needs'
            assert all(kinds(v)[0] <= need for v in kids), 'down'
    print('premises of line_ends hold on the kinds sampled: nothing, keeps, closed, grows, needs, down, high')
    c = run(kinds, giving, start_way, x0, steps)
    levels = [lv for _, lv in c]
    line = [sum(n for u, n in w.items() if isS(u)) for w, _ in c]
    takes = [taken(kinds, w) for w, _ in c]
    goes = [any(kinds(u)[0] <= lv for u in w) for w, lv in c]
    print('levels      ', levels[:16], '...', levels[-1])
    print('line units  ', line[:16])
    print('way takes   ', takes[:16])
    last = max(t for t in range(len(c)) if line[t] > 0)
    print('last step with a unit of the line in the way:', last, '; gone at every later step up to', steps, ':', all(l == 0 for l in line[last + 1:]))
    print('least level over the course:', min(levels), '; some need met at every step:', all(goes))
    rises_after = [t for t in range(last, steps) if levels[t + 1] > levels[t]]
    print('steps after the line is gone at which the level rises:', rises_after[:6])
    print('steps where what the way takes exceeds the level (take := use unbalanced):', [t for t in range(steps) if takes[t] > levels[t]])
    # windows that Founding's excess / start / draws would need, with the stock as the one condition,
    # take := use, given := giving(left over): for a gate m with giving z = 0 below m
    gates = [m for m in range(0, hi + 2) if all(giving(z) == 0 for z in range(m))]
    found = []
    for m in gates:
        for T in range(steps):
            for n in range(1, steps - T):
                if not all(giving(max(levels[T + k] - takes[T + k], 0)) < takes[T + k] for k in range(n)): break
                if levels[T] < n + m and any(line[t] > 0 for t in range(T, T + n)):
                    found.append((m, T, n))
    print('gates m with nothing given below m:', gates, '; windows (m, T, n) meeting excess, start and draws:', found)
    # the hand argument: any reading with these levels as the stock makes the level never rise from T on, T <= last
    print('level never rises from some T <= last on:', any(all(levels[t + 1] <= levels[t] for t in range(T, steps)) for T in range(last + 1)))
    mark = lambda u: 1 if isS(u) else 0
    sel = [(t,) + concord_discord(kinds, c[t][0], c[t][1], mark) for t in range(min(steps, 14))]
    print('(t, concord, discord) with the mark of the line as amount:', sel)
    print('steps at which selection within goes for the line (discord < concord):', [t for t, a, b in sel if b < a])
    print()

# A. Two kinds. D doubles and needs 71 of 100; O leaves itself and needs 1.
def kindsA(u): return {'D': (71, 1, ['D', 'D']), 'O': (1, 1, ['O'])}[u]
gA = lambda z: min(z, max(100 - z, 0))
report('A: a doubling line that needs 71 of 100, beside a unit that needs 1', kindsA, lambda u: u == 'D', gA, 100,
       {'D': 1, 'O': 1}, 100, 40, ['D', 'O'])

# B. A line whose one kid takes one more (D_k -> [D_{k+1}], use k, need 11), beside O.
def kindsB(u):
    if u == 0: return (1, 1, [0])
    return (11, u, [u + 1])
gB = lambda z: min(z, max(12 - z, 0))
report('B: a line of one kid that takes one more, needing 11 of 12, beside a unit that needs 1', kindsB, lambda u: u != 0, gB, 12,
       {1: 1, 0: 1}, 12, 40, list(range(0, 45)))
