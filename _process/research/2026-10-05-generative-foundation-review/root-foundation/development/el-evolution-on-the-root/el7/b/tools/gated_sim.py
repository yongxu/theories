"""Plain simulation of the `Gated` run of /Users/ren/tmp/el7/b/Becoming/PairFlow.lean, with giving
read by a pair law from the run's last two sends (not in the Lean). Checks by-hand claims only.

usage: python3 -I gated_sim.py
"""
NEED, UPKEEP, OWN, GIFT = 3, 1, 1, 1
FIRST, SECOND = 0, 1


def renew_fail_at_one(p, t):
    return 2 if p == FIRST else (0 if t == 1 else 2)


def run(law, renew, start=(5, 3), steps=12, draw=lambda p, t: 0):
    levels = list(start)
    hist = [(True, True), (True, True)]  # (sent at t-1, sent at t-2), mutual giving before step 0
    lines = [0, 0]
    out = []
    for t in range(steps):
        active = [levels[p] >= NEED for p in (FIRST, SECOND)]
        intends = [law(hist[p], hist[1 - p]) for p in (FIRST, SECOND)]
        sends = [intends[p] and active[p] for p in (FIRST, SECOND)]
        nxt = []
        for p in (FIRST, SECOND):
            own_take = (UPKEEP + OWN + (GIFT if sends[p] else 0)) if active[p] else 0
            renewal = renew(p, t) if active[p] else 0
            gets = GIFT if sends[1 - p] else 0
            avail = levels[p] - own_take + (renewal + gets)
            taken = min(draw(p, t), avail)
            nxt.append(avail - taken)
        for p in (FIRST, SECOND):
            lines[p] += OWN if active[p] else 0
        out.append((t, tuple(levels), tuple(sends), tuple(lines)))
        levels = nxt
        hist = [(sends[p], hist[p][0]) for p in (FIRST, SECOND)]
    return out


laws = {
    'sharing': lambda own, partner: True,
    'keeping': lambda own, partner: False,
    'answering': lambda own, partner: partner[0],
    'windowed': lambda own, partner: partner[0] or partner[1],
}

if __name__ == '__main__':
    for name, law in laws.items():
        rows = run(law, renew_fail_at_one)
        print(name)
        for t, lv, sd, ln in rows:
            print(f'  t={t:2d} levels={lv} sends={sd} lines after={ln}')
