"""Reimplementation from DESIGN s2 prose only. State: (quota, level, holders, others)."""
def step(p, x, on=True, rev=None):
    s, l, g, f, src = p
    q, L, H, O = x
    take = sum(H) + sum(O)
    if L == 0 or take > L + g:                     # 1 end
        return (q, 0, [], [])
    L1 = L + g - take                              # 2 draw and renew
    teacher = any(c > 0 for i, c in enumerate(H) if i >= l)   # 3 teach, before ageing
    eh = eo = 0                                    # 4 enter
    if on:
        if src == 'members' and teacher: eh = q
        elif src == 'outside': eh = q
        else: eo = f
    H1 = ([eh] + list(H))[:s]                      # 5 age (off step: a zero cohort, the prose leaves this implicit)
    O1 = ([eo] + list(O))[:s]
    q1 = q
    if rev is not None and sum(H) > 0 and src != 'outside': q1 = rev   # 6 revise
    return (q1, L1, H1, O1)
def settled(q, L, s): return (q, L, [q]*s, [])
def gone(x): return x[1] == 0 and sum(x[2]) == 0 and sum(x[3]) == 0
def held(x): return sum(x[2]) > 0
def run(p, x, k):
    for _ in range(k): x = step(p, x)
    return x
