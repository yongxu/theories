# AI-written (Fable), 16 November 2026. A worked course, not a proof.
# Link 2: LineOnAStock.need_unmet / TurningInTime.rising_takes_all against Exhaustion's Flow.seeking_bounded.
# LineOnAStock.Doubling as it stands: one kind, need 1, use 1, kids two of itself; giving min z (12 - z); start ([()], 12).
giving = lambda z: min(z, max(12 - z, 0)); hi = 12
n_units, x = 1, 12
rows = []
for t in range(8):
    H = n_units                      # what the way takes (the use, a draw asked)
    z = max(x - H, 0); g = giving(z)
    actual = x - z                   # what is in fact taken: min(x, H)
    x1 = z + g
    rows.append(dict(t=t, units=n_units, level=x, use=H, actual=actual, given=g, next=x1,
                     balanced_with_use=(x1 + H == x + g), balanced_with_actual=(x1 + actual == x + g),
                     met=(1 <= x)))
    n_units = 2 * n_units if 1 <= x else 0
    x = x1
for r in rows: print(r)
print('take := use: unbalanced at steps', [r['t'] for r in rows if not r['balanced_with_use']])
act = [r['actual'] for r in rows]
print('take := what is in fact taken:', act, '; more than now fails first at step',
      next(t for t in range(len(act) - 1) if not act[t] < act[t + 1]), 'while every need is met there:', rows[3]['met'], rows[4]['met'])
first_unmet = next(r['t'] for r in rows if r['units'] > 0 and not r['met'])
B = max(giving(z) for z in range(hi + 1))
print('first step with an unmet need:', first_unmet, '; need_unmet bound hi + 1 =', hi + 1,
      '; Exhaustion window with B =', B, ': B + 1 + (level at B + 1) + 1 >=', B + 2)
# Keeps giving 0 hi gives a bound on what is given at levels within hi (B := hi), by hand: z + giving z <= hi.
assert all(z + giving(z) <= hi for z in range(hi + 1))
