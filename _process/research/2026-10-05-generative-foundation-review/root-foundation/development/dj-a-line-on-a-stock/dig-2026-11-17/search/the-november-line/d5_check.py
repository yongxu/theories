# D5 check on ScratchCovering's order L (reading only; mirrors the Lean definitions, one kind of unit).
#   ScratchCovering.level need giving use give w x = RegimeMargin.step giving (taken use w) x + gift need give w (x - taken use w)
#   RegimeMargin.step g H x = (x - H) + g (x - H)   (truncated subtraction)
#   LineOnAStock.after: a unit leaves its kids where need <= x (the level BEFORE the take)
#   gift: total of give u over units with need u <= z, z = x - taken (what is left AFTER the take)
def run(a, t, b, k, N, x, g, steps=40):
    """one kind: need a, use t, give b, k kids. returns (levels, counts, ended_at or None)"""
    levels, counts = [x], [N]
    for n in range(steps):
        if N == 0 or x < a:
            return levels, counts, n
        z = max(x - N * t, 0)
        gift = N * b if a <= z else 0
        x2 = z + g(z) + gift
        N2 = N * k if a <= x else 0
        x, N = x2, N2
        levels.append(x); counts.append(N)
        if N > 10**6: break
    return levels, counts, None

nothing = lambda z: 0
hump = lambda z: min(z, max(12 - z, 0))

# 1. giving back b <= t against taking t - b and giving nothing back: same course?
diff_need = diff_stock = same = 0
examples = []
for g, gname in ((nothing, 'nothing'), (hump, 'min z (12-z)')):
    for a in range(1, 5):
        for t in range(0, 5):
            for b in range(0, t + 1):
                for N in range(1, 4):
                    for x in range(0, 13):
                        A = run(a, t, b, 1, N, x, g)
                        B = run(a, t - b, 0, 1, N, x, g)
                        if A[0] == B[0] and A[2] == B[2]:
                            same += 1
                        else:
                            if gname == 'nothing': diff_need += 1
                            else: diff_stock += 1
                            if len(examples) < 6 or (gname != 'nothing' and len(examples) < 12):
                                examples.append((gname, dict(a=a, t=t, b=b, N=N, x=x), A[0][:5], A[2], B[0][:5], B[2]))
print('k=1, b<=t: same course', same, '| differ on a stock that gives nothing', diff_need, '| differ on the hump', diff_stock)
for e in examples: print('  ', e)

# 2. the one-kind exact law of the scratch (unending iff k*t <= b and a + t*N <= x), simulated, giving nothing
bad = 0; checked = 0
for a in range(1, 4):
    for t in range(0, 4):
        for b in range(0, 7):
            for k in range(1, 3):
                for N in range(1, 3):
                    for x in range(0, 12):
                        lv, ct, ended = run(a, t, b, k, N, x, nothing, steps=14)
                        checked += 1
                        if (ended is None) != (k * t <= b and a + t * N <= x):
                            bad += 1
print('OneKind.unending_iff against simulation (14 steps): checked', checked, 'disagree', bad)

# 3. under D5's own premise b <= t: which parameters go on for ever, and does the way grow?
grow = 0; goes = 0
for a in range(1, 4):
    for t in range(0, 5):
        for b in range(0, t + 1):
            for k in range(1, 4):
                if k * t <= b:
                    goes += 1
                    if k >= 2 and t > 0: grow += 1
print('b <= t and k*t <= b: parameter triples', goes, 'of which grow (k>=2) and take something', grow)
