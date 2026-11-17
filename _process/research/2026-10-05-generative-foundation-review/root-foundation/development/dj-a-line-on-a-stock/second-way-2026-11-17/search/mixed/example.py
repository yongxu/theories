"""AI-written (Claude, DJ batch 19), 17 November 2026. Scratch, outside the package, not landed.
The kept example of (4), by a direct run of LineOnAStock's model on lists: kinds g (need 1, use 1,
kids [g]) and k (need 5, use 1, kids [k, k]), giving z -> 1 if 1 <= z else 0, way [g, k]."""
need = {'g': 1, 'k': 5}; use = {'g': 1, 'k': 1}; kids = {'g': ['g'], 'k': ['k', 'k']}
giving = lambda z: 1 if 1 <= z else 0
def step(s):
    w, x = s
    nw = [v for u in w if need[u] <= x for v in kids[u]]
    T = sum(use[u] for u in w); z = max(x - T, 0)
    return (nw, z + giving(z))
def goes(s): return any(need[u] <= s[1] for u in s[0])
for x0 in range(0, 13):
    s = (['g', 'k'], x0); path = [s]; seen = []
    res = None
    for t in range(40):
        if not goes(s): res = 'ends at step %d' % t; break
        key = (tuple(s[0]), s[1])
        if key in seen: res = 'never ends (repeats at step %d)' % t; break
        seen.append(key); s = step(s); path.append(s)
    print(x0, res, [(''.join(w), x) for w, x in path[:6]])
