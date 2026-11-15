# AI-written (Fable, attack reader), 16 November 2026. The world generator of laws3.py.
import random
from model import *
rng = random.Random(77)


def make_world(drop, hi):
    k = rng.randint(1, 3)
    for _ in range(300):
        use = [rng.randint(0, 3) for _ in range(k)]
        kids = []
        for u in range(k):
            best = None
            for _ in range(30):
                ks = tuple(rng.randrange(k) for _ in range(rng.randint(0 if drop == 'some' else 1, 3)))
                if drop == 'even' or sum(use[v] for v in ks) == use[u]:
                    best = ks
                    break
            if best is None:
                break
            kids.append(best)
        if len(kids) < k:
            continue
        need = [rng.randint(0 if drop == 'needs' else 1, hi + 1) for _ in range(k)]
        even = all(sum(use[v] for v in kids[u]) == use[u] for u in range(k))
        some = all(len(kids[u]) > 0 for u in range(k))
        down = all(need[v] <= need[u] for u in range(k) for v in kids[u])
        if drop != 'down' and not down:
            # repair: lower kids' needs along edges
            for _ in range(6):
                for u in range(k):
                    for v in kids[u]:
                        need[v] = min(need[v], need[u])
            down = all(need[v] <= need[u] for u in range(k) for v in kids[u])
        if even != (drop != 'even') or some != (drop != 'some') or down != (drop != 'down'):
            continue
        return need, use, kids
    return None


