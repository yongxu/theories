# AI-written (Fable), 16 Nov 2026. Read-only check: phase portrait of TurningInTime.Three
# giving z = min z (12 - z); step g H x = (x - H) + g (x - H) with truncated subtraction; need 1.
def g(z): return min(z, 12 - z) if z <= 12 else 0
def step(H, x):
    z = max(x - H, 0); return z + g(z)
def fate(H, x, n=60):
    for t in range(n):
        if x < 1: return ('ends', t)
        x = step(H, x)
    return ('goes on', x)
for H in (5, 3):
    print('use', H, [(x, fate(H, x)) for x in range(0, 13)])
