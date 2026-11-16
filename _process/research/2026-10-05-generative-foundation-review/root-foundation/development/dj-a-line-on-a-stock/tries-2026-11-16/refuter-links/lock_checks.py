# AI-written (Fable, refuter of the links), 16 November 2026. Small worked courses, not proofs.
# RuleShaping.covering_locks on CarrierCounts: does the course COME to lock (not locked before), what `covers` carries,
# and whether the count of carriers rises without favouring (so an ending by that count takes no lock).
def shaped(a, s, p, c): return (a + s + p, a + c + p)
def select(x, g): return (x[0] * g[0], x[1] * g[1])
def le(x, y): return x[0] * y[1] <= y[0] * x[1]          # CarrierCounts.order
def favours(g): return g[1] <= g[0]
def locked(h, x, g): return favours(g) and le(g, h(x, g))  # RuleCapture.Locked
def course(a, p, c, sigma, reads, x, s, n):
    h = lambda x, g: shaped(a, sigma(x), p, c)
    g = shaped(a, s, p, c); out = []
    for t in range(n):
        out.append((t, x, g, locked(h, x, g)))
        x, g = select(x, g), (h(x, g) if reads(t) else g)
    return out
reads = lambda t: t in (2, 5, 8)
print('1. covers at every share (sigma 1 below parity, 3 from parity; c = 1), start rule above what is read (s = 5):')
for row in course(1, 0, 1, lambda x: 3 if x[1] <= x[0] else 1, reads, (1, 3), 5, 7): print('  ', row)
print('2. covers fails below parity (sigma 0 there; c = 1), same start: locked after the first reading?')
for row in course(1, 0, 1, lambda x: 3 if x[1] <= x[0] else 0, lambda t: t in (0, 3), (1, 30), 5, 5): print('  ', row)
print('3. carriers under a rule that disfavours, (2, 5):', [select((3, 1), (2, 5)), select(select((3, 1), (2, 5)), (2, 5))])
bad = 0; n = 0
for a in (1, 2):
    for p in (0, 1):
        for c in (0, 1, 2):
            for lo in range(c, c + 3):
                for hi_ in range(lo, lo + 3):
                    for s in range(c, c + 4):
                        for x in ((1, 1), (1, 4), (3, 2), (0, 1)):
                            for first in (0, 1, 3):
                                rs = lambda t, first=first: t == first or t == first + 2
                                rows = course(a, p, c, lambda y: hi_ if y[1] <= y[0] else lo, rs, x, s, first + 5)
                                n += 1
                                if not all(r[3] for r in rows if r[0] in (first + 1, first + 3)): bad += 1
print('4. grid of covering starts: cases', n, 'not locked at the step after a reading step:', bad)
