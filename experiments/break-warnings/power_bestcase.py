"""EW2 step 1 (run before the test was designed in full): can Cury et al.'s (2011) forage-fish series support a test of T6's uncoupled side?

A best-case power check on generators only; it reads no field value. Python standard library.

The test T6's refutation clause describes: within a stock, the prey's early-warning statistic
over the w years before year t (lag-1 autocorrelation or variance of the linearly detrended
window), compared between years in which the dependent fails and years in which it does not,
at the same level (the level in year t, the window's mean and the window's slope, removed by
regression within the series). The per-series partial correlation between failure and the
statistic is combined across series (Fisher z, Stouffer weights).

Best case on purpose, so that low power here bounds every valid field test from above:
- the critical value is the exact 95th percentile under the threshold-only generator (an
  oracle; a field test must estimate its null and loses power doing so);
- the effect acts on the realized window statistic itself (no attenuation by estimation);
- the generator's prey dynamics are the simple ones (log-level AR(1) about a drawdown path,
  the return rate proportional to the level, as for logistic renewal under a proportional draw).

Generator: log level y_t = mu_t + u_t, u_{t+1} = exp(-lambda_t) u_t + 0.3 e_t,
lambda_t = exp(mu_t) (full level: AR1 about 0.37; a fifth of it: about 0.82); mu_t falls
from 0 to -1.6 and returns, with a random phase. Breeding success
BS_t = 2/(1+exp(-(y_t - N)/0.25)) - delta z_t + eta_t, eta_t ~ N(0, 1), N = log(1/3),
z_t the standardized residual of the window statistic on the level covariates. delta = 0 is
the threshold-only dependent (T6's uncoupled side); delta > 0 makes failure more likely
where the window statistic is higher (the direction the refutation clause names); beyond level, z explains
delta^2/(1+delta^2) of breeding success's residual variance. A failure year is a year in the
lowest third of the usable years' breeding success.

Run: python3 power_bestcase.py  (about four minutes; deterministic seeds; output in results/power_bestcase.log)
"""

import math
import random

REPS_NULL = 4000
REPS_ALT = 1500
LEVEL_NEED = math.log(1.0 / 3.0)


def mean(v):
    return sum(v) / len(v)


def detrend(v):
    n = len(v)
    xs = list(range(n))
    mx, my = mean(xs), mean(v)
    sxx = sum((x - mx) ** 2 for x in xs)
    b = sum((x - mx) * (y - my) for x, y in zip(xs, v)) / sxx
    return [y - (my + b * (x - mx)) for x, y in zip(xs, v)], b


def ar1(r):
    m = mean(r)
    num = sum((r[i] - m) * (r[i + 1] - m) for i in range(len(r) - 1))
    den = sum((x - m) ** 2 for x in r)
    return num / den if den > 0 else 0.0


def var(r):
    m = mean(r)
    return sum((x - m) ** 2 for x in r) / (len(r) - 1)


def solve(a, b):
    n = len(b)
    m = [row[:] + [b[i]] for i, row in enumerate(a)]
    for c in range(n):
        p = max(range(c, n), key=lambda r: abs(m[r][c]))
        m[c], m[p] = m[p], m[c]
        if abs(m[c][c]) < 1e-12:
            return None
        for r in range(n):
            if r != c:
                f = m[r][c] / m[c][c]
                for k in range(c, n + 1):
                    m[r][k] -= f * m[c][k]
    return [m[i][n] / m[i][i] for i in range(n)]


def residual(y, cols):
    """Residual of y on the columns (with intercept), ordinary least squares."""
    x = [[1.0] + [c[i] for c in cols] for i in range(len(y))]
    k = len(x[0])
    xtx = [[sum(x[i][a] * x[i][b] for i in range(len(y))) for b in range(k)] for a in range(k)]
    xty = [sum(x[i][a] * y[i] for i in range(len(y))) for a in range(k)]
    beta = solve(xtx, xty)
    if beta is None:
        return [v - mean(y) for v in y]
    return [y[i] - sum(beta[a] * x[i][a] for a in range(k)) for i in range(len(y))]


def standardize(v):
    m = mean(v)
    s = math.sqrt(sum((x - m) ** 2 for x in v) / (len(v) - 1)) or 1.0
    return [(x - m) / s for x in v]


def corr(a, b):
    ma, mb = mean(a), mean(b)
    sa = math.sqrt(sum((x - ma) ** 2 for x in a))
    sb = math.sqrt(sum((x - mb) ** 2 for x in b))
    if sa == 0 or sb == 0:
        return 0.0
    return sum((x - ma) * (y - mb) for x, y in zip(a, b)) / (sa * sb)


def series(rng, n, w, which, delta):
    """One stock and its dependent; returns the series' Fisher z and its weight."""
    phase = rng.random()
    mu = [-0.8 + 0.8 * math.cos(2 * math.pi * (t / n + phase)) for t in range(n)]
    u, y = 0.0, []
    for t in range(n):
        y.append(mu[t] + u)
        u = math.exp(-math.exp(mu[t])) * u + 0.3 * rng.gauss(0, 1)
    rows = []
    for t in range(w, n):
        r, slope = detrend(y[t - w:t])
        stat = ar1(r) if which == "ar1" else var(r)
        rows.append((y[t], mean(y[t - w:t]), slope, stat))
    lev = [list(c) for c in zip(*rows)][:3]
    stat = [row[3] for row in rows]
    z = standardize(residual(stat, lev))
    bs = [2 / (1 + math.exp(-(row[0] - LEVEL_NEED) / 0.25)) - delta * z[i] + rng.gauss(0, 1)
          for i, row in enumerate(rows)]
    cut = sorted(bs)[len(bs) // 3]
    fail = [1.0 if b < cut else 0.0 for b in bs]
    r = corr(residual(fail, lev), residual(stat, lev))
    r = max(min(r, 0.999), -0.999)
    m = len(rows)
    return 0.5 * math.log((1 + r) / (1 - r)), math.sqrt(max(m - 3 - 3, 1))


def combined(rng, lengths, w, which, delta):
    num = den = 0.0
    for n in lengths:
        zf, wt = series(rng, n, w, which, delta)
        num += wt * zf
        den += wt * wt
    return num / math.sqrt(den)


def power(lengths, w, which, deltas, seed):
    rng = random.Random(seed)
    null = sorted(combined(rng, lengths, w, which, 0.0) for _ in range(REPS_NULL))
    crit = null[int(0.95 * REPS_NULL)]
    out = []
    for d in deltas:
        hits = sum(combined(rng, lengths, w, which, d) > crit for _ in range(REPS_ALT))
        out.append(hits / REPS_ALT)
    return crit, out


SCOPES = [
    ("in scope: Benguela (22 years)", [22]),
    ("in scope with Rost as marginal (22, 34)", [22, 34]),
    ("all four stocks, scope ignored (22, 34, 30, 25)", [22, 34, 30, 25]),
]
DELTAS = [1 / 3, 1 / math.sqrt(3), 1.0]  # partial R^2 0.10, 0.25, 0.50


def main():
    print("partial R^2 of the window statistic beyond level:",
          ", ".join(f"{d * d / (1 + d * d):.2f}" for d in DELTAS))
    seed = 20261021
    for w in (6, 8, 10):
        for which in ("ar1", "var"):
            for name, lengths in SCOPES:
                seed += 1
                crit, pw = power(lengths, w, which, DELTAS, seed)
                print(f"w={w:2d} {which:3s} {name:48s} power " +
                      " ".join(f"{p:.2f}" for p in pw))


if __name__ == "__main__":
    main()
