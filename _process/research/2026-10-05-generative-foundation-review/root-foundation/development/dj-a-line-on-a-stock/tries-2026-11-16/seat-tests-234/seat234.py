"""AI-written (Fable, seat for frozen tests 2, 3, 4), 16 November 2026.
Searches over small finite families. A search is not a proof. Runs in a few seconds.

The guessed model (LINKS-ON-PAPER.md, "A fourth try"):
  stock  y' = (y - x) + g(y - x)                RegimeMargin.step g x y
  take   x' = one step from x towards m          Regulation.Between m x x', nearer
  value  m' = h(x, m, y) at reading steps, else m   the rule slot of Pace.paced
"""
import itertools

def tent(c):      return lambda z: min(z, c - z) if 0 <= z <= c else 0
def flat(c, top): return lambda z: min(z, top, c - z) if 0 <= z <= c else 0
def gated(k, v, c): return lambda z: (v if k <= z <= c - v else 0)

def toward(x, m): return x + 1 if x < m else (x - 1 if x > m else x)
def step(g, H, y):
    left = y - H if y >= H else 0
    return left + g(left)

SRC = {
    'fixed':  lambda g, y, x, m: m,
    'itself': lambda g, y, x, m: x + 1,
    'stock':  lambda g, y, x, m: g(max(y - x, 0)),
}

def run(g, y, x, m, source, reads, steps=400, move=toward):
    """returns (fate, course). fate: ('ends', t) or ('goes on', None). need 1."""
    course = []
    for t in range(steps):
        if y < 1:
            return ('ends', t), course
        course.append((y, x, m))
        ny = step(g, x, y)
        nx = move(x, m)
        nm = SRC[source](g, y, x, m) if reads(t) else m
        y, x, m = ny, nx, nm
    return ('goes on', None), course

def every(k, phase=0): return lambda t: (t + phase) % k == 0

print('== A. from itself: does it end from every start, every periodic schedule; how late ==')
worst = {}
bad = 0
count = 0
for c in (8, 12, 16):
    g = tent(c)
    for k in (1, 2, 3, 4, 6, 8):
        for phase in range(k):
            for y in range(1, c + 1):
                for x in range(0, c + 1):
                    for m in range(0, c + 1):
                        count += 1
                        fate, course = run(g, y, x, m, 'itself', every(k, phase), steps=40 * c)
                        if fate[0] != 'ends':
                            bad += 1
                        else:
                            worst[(c, k)] = max(worst.get((c, k), 0), fate[1])
print(f'   starts x schedules tried: {count}; not ending: {bad}')
print('   latest ending step by (tent top level c, reading period k):', worst)

print('== B. is the take strictly higher after every step (locked_ends_rising `more`, rising_takes_all `rises`)? ==')
g = tent(12)
for k in (1, 2, 4):
    fate, course = run(g, 12, 3, 3, 'itself', every(k))
    takes = [x for (_, x, _) in course]
    plateaus = sum(1 for a, b in zip(takes, takes[1:]) if not a < b)
    print(f'   read every {k}: takes {takes}; steps at which the take does not rise: {plateaus} of {len(takes) - 1}')

print('== C. from itself, once take <= held: two steps after a reading step the take is at least one higher ==')
viol = 0
tried = 0
for k in (1, 2, 3, 4, 6):
    for phase in range(k):
        for x in range(0, 13):
            for m in range(0, 13):
                rd = every(k, phase)
                xs, ms = [x], [m]
                for t in range(60):
                    nx = toward(xs[-1], ms[-1]); nm = xs[-1] + 1 if rd(t) else ms[-1]
                    xs.append(nx); ms.append(nm)
                for t in range(58):
                    if rd(t) and xs[t] <= ms[t]:
                        tried += 1
                        if not xs[t + 2] >= xs[t] + 1: viol += 1
print(f'   reading steps checked: {tried}; violations: {viol}')

print('== D. the lock of Three.rise_count_ends under other schedules (share a, rule true, use = share) ==')
def lock_run(reads, a=3, rule=True, y=12, steps=40):
    g = tent(12)
    for t in range(steps):
        if y < 1: return t, a
        ny = step(g, a, y)
        na = a + 1 if rule else a
        nrule = (3 <= a) if reads(t) else rule
        y, a, rule = ny, na, nrule
    return None, a
for name, rd in (('every step', every(1)), ('every 4', every(4)), ('never', lambda t: False)):
    print(f'   lock, reads {name}: ends at step {lock_run(rd)[0]} with share {lock_run(rd)[1]}')
print('   guess, from itself, never reading (start 12, take 3, held 3):', run(tent(12), 12, 3, 3, 'itself', lambda t: False)[0])

print('== E. fixed against from-the-stock: do the fates ever differ from one start (held = take at the start)? ==')
fams = {'tent 8': tent(8), 'tent 12': tent(12), 'tent 16': tent(16),
        'flat top 6 on 20': flat(20, 6), 'flat top 4 on 14': flat(14, 4), 'gated 2 gives 4 (to 12)': gated(2, 4, 12)}
for name, g in fams.items():
    hi = 20
    diff = []
    n = 0
    for k in (1, 2, 4, 8):
        for y in range(1, hi + 1):
            for x in range(0, hi + 1):
                n += 1
                f1 = run(g, y, x, x, 'fixed', every(k))[0][0]
                f2 = run(g, y, x, x, 'stock', every(k))[0][0]
                if f1 != f2: diff.append((k, y, x, f1, f2))
    kinds = {}
    for d in diff: kinds[(d[3], d[4])] = kinds.get((d[3], d[4]), 0) + 1
    print(f'   {name}: starts x schedules {n}; fates differ at {len(diff)}: {kinds}; first: {diff[:2]}')
g = tent(12)
same = all(run(g, y, 3, 3, 'fixed', every(k))[0][0] == run(g, y, 3, 3, 'stock', every(k))[0][0]
           for y in range(1, 13) for k in (1, 2, 3, 4, 6, 8))
print('   the probe itself (tent 12, take 3, held 3, levels 1..12, six schedules): fixed and stock fates all the same:', same)

print('== F. from the stock with a take that moves at once (x\' = m) and m = what the stock just gave, read at every step ==')
viol = 0; n = 0
for name, g in fams.items():
    for y in range(0, 21):
        for x in range(0, 21):
            # one step to set m, then take = m each step
            yy, xx = y, x
            lefts = []
            for t in range(12):
                left = max(yy - xx, 0); lefts.append(left)
                gave = g(left)
                yy, xx = left + gave, gave      # take at once = what was just given
            n += 1
            # from step 1 on, is what is left constant?
            if len(set(lefts[1:])) != 1: viol += 1
print(f'   starts {n}; courses where what is left changes after the first step: {viol}')

print('== G. the fast loop under a held value that stays is Regulation.relay at lateness 0, band [m, m], step 1 ==')
def relay(a, b, M, r): return (M if r < a else 0, M if b < r else 0)
viol = 0; within_viol = 0; opp_viol = 0; n = 0
for m in range(0, 15):
    for x0 in range(0, 15):
        x = x0; lvl = x0
        for t in range(20):
            give, take = relay(m, m, 1, lvl)
            n += 1
            # WithinGap: take <= give + (lvl - m), give <= take + (m - lvl)   (natural subtraction)
            if not (take <= give + max(lvl - m, 0) and give <= take + max(m - lvl, 0)): within_viol += 1
            # Opposes: m < lvl -> give < take ; lvl < m -> take < give
            if (m < lvl and not give < take) or (lvl < m and not take < give): opp_viol += 1
            # balance without cut: take <= lvl + give
            if not take <= lvl + give: viol += 1
            lvl = lvl + give - take
            x = toward(x, m)
            if lvl != x: viol += 1
print(f'   (m, start, step) triples {n}; relay level differs from the take or is cut at nothing: {viol}; not within the gap: {within_viol}; not opposing: {opp_viol}')

print('== H. RuleCapture.Raises for the fast step `toward`, order <= on takes ==')
bad = [(x, m) for x in range(6) for m in range(6) if not x <= toward(x, m)]
print('   pairs (take, held) at which the step lowers the take:', bad[:6], '... count', len(bad), 'of 36: every held value has one (take = held + 1)')
print('   CarrierCounts.select: share (2,1) under rule (2,1) ->', (2 * 2, 1 * 1), 'past the rule; under the tie (1,1) ->', (2 * 1, 1 * 1), 'unmoved though the tie favours (1 <= 1)')

print('== I. the fixed source once the take has arrived: fate against RegimeMargin.ends_iff_below (H + y) ==')
viol = 0; n = 0
for c in (8, 12, 16):
    g = tent(c)
    for H in range(1, c + 1):
        roots = [z for z in range(0, c + 1) if g(z) >= H]
        for y0 in range(1, c + 1):
            n += 1
            fate = run(g, y0, H, H, 'fixed', every(1))[0][0]
            if roots:
                yroot = roots[0]
                # premises of ends_iff_below need Meets up to hi and Keeps; on a tent take hi = c, Meets fails above the far root, so
                # compare only where the prediction is unconditional: below H + y ends (ends_below)
                if y0 < H + yroot and fate != 'ends': viol += 1
            else:
                if fate != 'ends': viol += 1   # ends_beyond_giving
print(f'   (tent, take, level) triples {n}; starts below H + y (or a take beyond all giving) that do not end: {viol}')
