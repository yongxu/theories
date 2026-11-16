# AI-written (Fable, seat links 1-3), 16 November 2026. A search, not a proof.
# Link 3: the reader rebuilt from the level (ReaderRebuilding), against the regime's level and a
# line of units with a need (LineOnAStock). The rule is copied from ReaderRebuilding.lean:
#   read m k l  = if l < m then (if l + k < m then l + k else m) else l
#   older s     : each age + 1, a unit reaching s ends
#   rebuild (source level): if len(as) < n: l = 0 -> (0, as); l + 1 -> (l, 0 :: as)
#   step on x   = rebuild (if on then read m (len ages) (level - 1) else level - 1) (older ages)
import itertools

def sub(a, b): return a - b if a >= b else 0
def read(m, k, l): return (l + k if l + k < m else m) if l < m else l
def older(s, ages): return [a + 1 for a in ages if a + 1 < s]
def step(s, n, m, on, level, ages):
    l = read(m, len(ages), sub(level, 1)) if on else sub(level, 1)
    as_ = older(s, ages)
    if len(as_) < n:
        if l == 0: return 0, as_
        return l - 1, [0] + as_
    return l, as_

# (a) Under a cut the level's step is RegimeMargin.step (giving nothing) (use w) x, with
#     use w = 1 + (1 if fewer than n units remain after ageing), and the way after the step reads
#     the level only through "2 <= x" (a mark below two).
def regime_step(g, H, x): return sub(x, H) + g(sub(x, H))
bad_a = bad_alone = 0
ends_late = 0; worst = 0
for s in range(1, 5):
    for n in range(1, 4):
        for k in range(0, n + 1):
            for ages in itertools.product(range(s), repeat=k):
                ages = list(ages)
                for level in range(0, 13):
                    lv, as_ = step(s, n, 2, False, level, ages)
                    use = 1 + (1 if len(older(s, ages)) < n else 0)
                    if lv != regime_step(lambda z: 0, use, level): bad_a += 1
                    alone = ([0] + older(s, ages)) if len(older(s, ages)) < n else older(s, ages)
                    if level >= 2 and as_ != alone: bad_alone += 1
                    # (b) the open item: under a cut it ends from every stock, within level + span
                    L, A, t = level, ages, 0
                    while A and t < 200:
                        L, A = step(s, n, 2, False, L, A); t += 1
                    if A: ends_late += 1
                    else:
                        worst = max(worst, t - (level + s))
                        if t > level + s: ends_late += 1
print("cut step's level is not the regime's step under giving nothing:", bad_a)
print("at a level of two or more the way after a cut step is not 'alone' of the way:", bad_alone)
print("cut courses not ended within level + span steps:", ends_late, " (latest end minus that bound:", worst, ")")

# (c) One unit, span one, under a cut: on the states reached from ([0], x) the course is
#     LineOnAStock's with one unit of need 2, use 2, kids [itself], giving nothing.
def line_step(way, x):  # after: kids where need met; left: regime step under total use
    use = 2 * len(way)
    new_way = [0 for u in way if 2 <= x]
    return new_way, regime_step(lambda z: 0, use, x)
diff = 0; diff_empty = 0
for x in range(0, 15):
    L, A = x, [0]; W, X = [0], x
    for t in range(12):
        L, A = step(1, 1, 2, False, L, A); W, X = line_step(W, X)
        if (A, L) != (W, X): diff += 1
    # off the reached states: an empty reader over a level of two or more is rebuilt; an empty way is not
    L, A = step(1, 1, 2, False, x, []); W, X = line_step([], x)
    if (A, L) != (W, X): diff_empty += 1
print("one unit, span one: steps where reader and line differ from ([0], x):", diff,
      "; from the empty reader/way over x:", diff_empty, "of 15")

# (d) With the supply on and no rebuild due, k >= 2 units: the level's step against the set level m
#     is within the gap and opposes on both sides (Regulation's two premises), for levels 1..m+3.
def within(tk, gv, m, x): return tk <= gv + sub(x, m) and gv <= tk + sub(m, x)
def opposes(tk, gv, m, x): return (not (m < x) or gv < tk) and (not (x < m) or tk < gv)
res = {}
for k in (1, 2, 3):
    for m in (2, 3, 5):
        ok_w = ok_o = True
        for x in range(1, m + 4):
            l = read(m, k, x - 1)          # draw one, then read; no ageing out, full count
            tk, gv = 1, l - (x - 1)
            ok_w &= within(tk, gv, m, x); ok_o &= opposes(tk, gv, m, x)
        res[(k, m)] = (ok_w, ok_o)
print("supplied, full reader of k units against set level m: (within the gap, opposes):", res)

# (e) One unit (count 1), any span, under a cut, from one new unit over x: LineOnAStock with the
#     ages as units: kids a = [a + 1], need 0, use 1 while a + 1 < span; the last age has kids [0],
#     need 2, use 2 (the draw of one and the rebuild's unit). after = flatMap of kids where need met;
#     left = RegimeMargin.step (giving nothing) (total use) x.
def line_step_s(s, way, x):
    need = lambda a: 0 if a + 1 < s else 2
    use = lambda a: 1 if a + 1 < s else 2
    kids = lambda a: [a + 1] if a + 1 < s else [0]
    new = [k for a in way if need(a) <= x for k in kids(a)]
    return new, regime_step(lambda z: 0, sum(use(a) for a in way), x)
diff = 0
for s in range(1, 6):
    for x in range(0, 16):
        L, A = x, [0]; W, X = [0], x
        for t in range(20):
            L, A = step(s, 1, 2, False, L, A); W, X = line_step_s(s, W, X)
            if A == [] and W == []: break     # both ended (the reader's standing draw goes on without it)
            if (A, L) != (W, X): diff += 1
print("count 1, spans 1..5: steps where the cut reader and the line of ages differ before both end:", diff)
# count 2: two units end at one step, the rebuild makes one a step, a line would leave two
L, A = 9, [0, 0]
trace = []
for t in range(5):
    L, A = step(2, 2, 2, False, L, A); trace.append((L, list(A)))
print("count 2, span 2, from two new units over nine, cut:", trace)
