# AI-written (reader "selection", 16 Nov 2026). Hand tries of candidate laws A3, A4 of
# STEPS-3-7-ON-PAPER.md on small worlds, giving z = min z (12 - z). Read-only; runs in well under a second.
# L: kinds with need, use, kids; after w x = flatMap (kids u if need u <= x else []) w;
# left w x = RegimeMargin.step giving (taken w) x = (x - taken w) + giving (x - taken w), truncated subtraction.
def giving(z): return min(z, max(12 - z, 0))
def monus(a, b): return a - b if a >= b else 0
def step(H, x): e = monus(x, H); return e + giving(e)

class World:
    def __init__(s, name, need, use, kids): s.name, s.need, s.use, s.kids = name, need, use, kids
    def after(s, w, x): return [v for u in w for v in (s.kids[u] if s.need[u] <= x else [])]
    def taken(s, w): return sum(s.use[u] for u in w)
    def goes(s, w, x): return any(s.need[u] <= x for u in w)
    def course(s, w, x, n):
        out = [(list(w), x)]
        for _ in range(n):
            w, x = s.after(w, x), step(s.taken(w), x)
            out.append((w, x))
        return out
    def ends_at(s, w, x, n=400):
        """first step whose configuration has no unit going on (the net has no next there), or None"""
        for t, (ww, xx) in enumerate(s.course(w, x, n)):
            if not s.goes(ww, xx): return t
        return None

def excess(a, b): return a - b if a > b else 0
def price_terms(W, c, t):
    """SelectionTerm.Generations instance: first := w, kids t u := kids u if need u <= level_t else [], amount t := use."""
    (w, x), (w1, _) = c[t], c[t + 1]
    k = lambda u: W.kids[u] if W.need[u] <= x else []
    num = lambda u: len(k(u)); a = lambda u: W.use[u]
    size, size1 = len(w), len(w1)
    summ, sum1 = sum(a(u) for u in w), sum(a(u) for u in w1)
    concord = sum(excess(num(p), num(q)) * excess(a(p), a(q)) for p in w for q in w)
    discord = sum(excess(num(p), num(q)) * excess(a(q), a(p)) for p in w for q in w)
    raised = sum(excess(a(kk), a(p)) for p in w for kk in k(p))
    lowered = sum(excess(a(p), a(kk)) for p in w for kk in k(p))
    lhs = size * sum1 + (size * lowered + discord)
    rhs = size1 * summ + (concord + size * raised)
    fam_ok = [v for u in w for v in k(u)] == w1
    return dict(t=t, size=size, sum=summ, concord=concord, discord=discord, raised=raised, lowered=lowered,
                mean_step_holds=(lhs == rhs), family_is_way=fam_ok)

def show(W, w, x, n):
    c = W.course(w, x, n)
    return " | ".join("%s@%d" % ("".join(map(str, ww)) or "-", xx) for ww, xx in c)

def A3_check(W, w, x, x2, n=60):
    """A3 as written (every need met on both) and the stronger form (same needs met on both)."""
    c, c2 = W.course(w, x, n), W.course(w, x2, n)
    okA3 = okStrong = True; first_apart = None
    allmet = same = True
    for t in range(n):
        (wa, xa), (wb, xb) = c[t], c2[t]
        if allmet and wa != wb: okA3 = False
        if same and wa != wb: okStrong = False
        if wa != wb and first_apart is None: first_apart = t
        if wa == wb:
            allmet = allmet and all(W.need[u] <= xa and W.need[u] <= xb for u in wa)
            same = same and all((W.need[u] <= xa) == (W.need[u] <= xb) for u in wa)
        else:
            allmet = same = False
    return okA3, okStrong, first_apart

# World I: the case kids u = [u] (WayOfUnits). Kinds: a = (need 9, use 4), b = (need 1, use 1): WayOfUnits.With.way
W1 = World("I: kids u = [u]; a=(need 9,use 4), b=(need 1,use 1), c=(need 1,use 6)",
           need=dict(a=9, b=1, c=1), use=dict(a=4, b=1, c=6), kids=dict(a=["a"], b=["b"], c=["c"]))
# World II: a unit that leaves offspring. G = (need m, use 1, kids [G, S]); S = (need 1, use 1, kids [S])
def W2(m): return World("II(m=%d): G=(need %d,use 1,kids [G,S]), S=(need 1,use 1,kids [S])" % (m, m),
           need=dict(G=m, S=1), use=dict(G=1, S=1), kids=dict(G=["G", "S"], S=["S"]))
# World III: uses differ by kind, so the count's concordance is not zero. G=(need m,use 2,kids [G,S]); S=(need 1,use 1,kids [S])
def W3(m): return World("III(m=%d): G=(need %d,use 2,kids [G,S]), S=(need 1,use 1,kids [S])" % (m, m),
           need=dict(G=m, S=1), use=dict(G=2, S=1), kids=dict(G=["G", "S"], S=["S"]))

print("== World", W1.name)
for w in (["c"], ["a", "b"]):
    for x in range(0, 13):
        print("  start", "".join(w), x, "ends_at", W1.ends_at(w, x), "::", show(W1, w, x, 6))
print("== A3 on every pair of levels 0..12, worlds I, II(m), III(m)")
bad = 0
for W, starts in [(W1, (["c"], ["a", "b"], ["a", "b", "c"]))] + [(W2(m), (["G"],)) for m in range(1, 13)] + [(W3(m), (["G"],)) for m in range(1, 13)]:
    for w in starts:
        for x in range(13):
            for x2 in range(13):
                a3, strong, _ = A3_check(W, w, x, x2)
                if not a3 or not strong: bad += 1; print("  FAILS", W.name, w, x, x2, a3, strong)
print("  failures of A3 (as written) or of its stronger form (same needs met):", bad)

print("== A4 search: starts differing only in level, ways equal for >= 3 steps, one line ends, the other never")
def never(W, w, x): return W.ends_at(w, x) is None
for W, starts in [(W1, (["c"], ["a", "b"]))] + [(W2(m), (["G"],)) for m in range(1, 13)] + [(W3(m), (["G"],)) for m in range(1, 13)]:
    for w in starts:
        for x in range(13):
            for x2 in range(x + 1, 13):
                _, _, apart = A3_check(W, w, x, x2)
                e1, e2 = W.ends_at(w, x), W.ends_at(w, x2)
                if apart is not None and apart >= 4 and (e1 is None) != (e2 is None):
                    print("  ", W.name, "start", "".join(w), "levels", x, x2, "ways first differ at step", apart,
                          "ends_at", e1, e2)
                    print("      ", x, "::", show(W, w, x, 9)); print("      ", x2, "::", show(W, w, x2, 9))

print("== Price terms (Generations instance, amount := use) along chosen courses")
for W, w, x in [(W1, ["a", "b"], 9), (W3(8), ["G"], 12), (W3(8), ["G"], 11), (W2(9), ["G"], 12)]:
    c = W.course(w, x, 8)
    print("  ", W.name, "start", "".join(w), x, "::", show(W, w, x, 8))
    for t in range(7):
        print("      ", price_terms(W, c, t))
