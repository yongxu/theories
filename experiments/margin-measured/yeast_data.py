"""D1 and D2 of PREDICTIONS-2026-10-20.md on Dai, Vorselen, Korolev and Gore (2012)'s published
bifurcation data, exactly as frozen there.

    python3 -I yeast_data.py <directory holding dilution{DF}_day{d}.txt> [results_dir]

Data: Zenodo record 5003142, the mirror of Dryad doi:10.5061/dryad.p2481134 (CC0; same DOI, file
names, sizes; md5 of data_bifurcation.zip 3891af7573f1afa105d9bc1ce9f03f1b). The archives were
extracted outside the repository and are not committed. The dataset's README PDFs were not
downloaded (not covered by the approval), so the layout below was read from the files themselves,
with every digit masked, before any value was examined (written and committed before the run):

  dilution{DF}_day{d}.txt, DF in {250, 500, 750, 1000, 1133, 1266, 1400, 1600}, d = 1..7:
  8 lines x 11 whitespace-separated numbers, one plate snapshot of population densities.
  Assumption (stated before the run): the same (line, column) position in the files of one DF is
  the same population on each day. Some values are negative (seen as a sign while masked),
  presumably measurement noise around zero.

Frozen rules, read literally:
  "nonzero" and "alive" mean > 0; "extinct" means <= 0.
  D1: at each DF, triples (n_{t-1}, n_t, n_{t+1}) of one population on consecutive days with all
      three > 0; if there are >= 30, regress log n_{t+1} on a cubic in log n_t (model 0) and on the
      cubic plus log n_{t-1} (model 1). Reduction = 1 - RSS1/RSS0; F-test of the added term.
      Failed at a DF if reduction >= 10% and p < 0.01; passed if every tested DF is not failed.
  D2: at each DF, pairs (n_t, n_{t+1}) with t + 1 <= 6, both > 0; cubic fit of log(n_{t+1}/n_t)
      on log n_t; the need u is the lowest root at which the fit crosses zero upward (the unstable
      point) within the range of the data. Start = the day-1 density; outcome = day 7. Groups:
      start > 1.5 u, start < u / 1.5. Testable at a DF where u exists and both groups have >= 5;
      passed if, at every testable DF, >= 90% of the first group are alive and >= 90% of the
      second extinct.
"""

import json
import math
import os
import sys

DFS = [250, 500, 750, 1000, 1133, 1266, 1400, 1600]
DAYS = range(1, 8)


def read(directory):
    data = {}
    for df in DFS:
        days = {}
        for d in DAYS:
            path = os.path.join(directory, f"dilution{df}_day{d}.txt")
            rows = [[float(x) for x in line.split()] for line in open(path) if line.strip()]
            days[d] = [v for row in rows for v in row]
        n = len(days[1])
        assert all(len(days[d]) == n for d in DAYS), (df, "unequal plate sizes")
        data[df] = [[days[d][i] for d in DAYS] for i in range(n)]   # population -> days 1..7
    return data


def lstsq(X, y):
    """Least squares by normal equations with Gaussian elimination (columns pre-scaled)."""
    k = len(X[0])
    A = [[sum(r[i] * r[j] for r in X) for j in range(k)] for i in range(k)]
    b = [sum(r[i] * yy for r, yy in zip(X, y)) for i in range(k)]
    for c in range(k):
        p = max(range(c, k), key=lambda r: abs(A[r][c]))
        A[c], A[p] = A[p], A[c]
        b[c], b[p] = b[p], b[c]
        for r in range(k):
            if r != c and A[c][c] != 0:
                f = A[r][c] / A[c][c]
                A[r] = [a - f * ac for a, ac in zip(A[r], A[c])]
                b[r] -= f * b[c]
    beta = [b[i] / A[i][i] for i in range(k)]
    rss = sum((yy - sum(bi * xi for bi, xi in zip(beta, r))) ** 2 for r, yy in zip(X, y))
    return beta, rss


def betacf(a, b, x):
    m_max, eps = 300, 3e-14
    qab, qap, qam = a + b, a + 1.0, a - 1.0
    c, d = 1.0, 1.0 - qab * x / qap
    d = 1.0 / (d if abs(d) > 1e-300 else 1e-300)
    h = d
    for m in range(1, m_max + 1):
        m2 = 2 * m
        aa = m * (b - m) * x / ((qam + m2) * (a + m2))
        d = 1.0 + aa * d
        d = 1.0 / (d if abs(d) > 1e-300 else 1e-300)
        c = 1.0 + aa / c if abs(1.0 + aa / c) > 1e-300 else 1e-300
        h *= d * c
        aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2))
        d = 1.0 + aa * d
        d = 1.0 / (d if abs(d) > 1e-300 else 1e-300)
        c = 1.0 + aa / c if abs(1.0 + aa / c) > 1e-300 else 1e-300
        de = d * c
        h *= de
        if abs(de - 1.0) < eps:
            break
    return h


def betai(a, b, x):
    if x <= 0.0:
        return 0.0
    if x >= 1.0:
        return 1.0
    bt = math.exp(math.lgamma(a + b) - math.lgamma(a) - math.lgamma(b) + a * math.log(x)
                  + b * math.log(1.0 - x))
    if x < (a + 1.0) / (a + b + 2.0):
        return bt * betacf(a, b, x) / a
    return 1.0 - bt * betacf(b, a, 1.0 - x) / b


def f_pvalue(F, d1, d2):
    """Upper tail of F(d1, d2)."""
    if F <= 0:
        return 1.0
    return betai(d2 / 2.0, d1 / 2.0, d2 / (d2 + d1 * F))


def scaled(xs):
    m = sum(xs) / len(xs)
    s = math.sqrt(sum((x - m) ** 2 for x in xs) / len(xs)) or 1.0
    return [(x - m) / s for x in xs], m, s


def detection_floor(data):
    """D1'/D2' (addendum, frozen before the run): 3 x the root mean square of every negative
    reading in the bifurcation data, pooled over dilution factors and days (readings scatter
    around zero with the instrument's noise; the negatives estimate its spread)."""
    neg = [v for df in DFS for p in data[df] for v in p if v < 0]
    if not neg:
        return 0.0, 0
    return 3.0 * math.sqrt(sum(v * v for v in neg) / len(neg)), len(neg)


def d1(data, floor=0.0):
    out = {}
    for df in DFS:
        trip = [(p[t - 1], p[t], p[t + 1]) for p in data[df] for t in range(1, 6)
                if p[t - 1] > floor and p[t] > floor and p[t + 1] > floor]
        if len(trip) < 30:
            out[df] = dict(n=len(trip), tested=False)
            continue
        x, _, _ = scaled([math.log(b) for _, b, _ in trip])
        z, _, _ = scaled([math.log(a) for a, _, _ in trip])
        y = [math.log(c) for _, _, c in trip]
        X0 = [[1.0, xi, xi * xi, xi ** 3] for xi in x]
        X1 = [r + [zi] for r, zi in zip(X0, z)]
        _, rss0 = lstsq(X0, y)
        beta1, rss1 = lstsq(X1, y)
        n = len(trip)
        F = (rss0 - rss1) / (rss1 / (n - 5)) if rss1 > 0 else float("inf")
        p = f_pvalue(F, 1, n - 5)
        red = 1.0 - rss1 / rss0 if rss0 > 0 else 0.0
        out[df] = dict(n=n, tested=True, reduction=red, F=F, p=p,
                       coef_log_prev_scaled=beta1[4], failed=(red >= 0.10 and p < 0.01))
    tested = [v for v in out.values() if v["tested"]]
    verdict = ("not testable" if not tested else
               ("failed" if any(v["failed"] for v in tested) else "passed"))
    return dict(D1=verdict, floor=floor, by_df=out)


def cubic_roots_upward(beta, lo, hi, steps=4000):
    f = lambda x: beta[0] + beta[1] * x + beta[2] * x * x + beta[3] * x ** 3
    roots = []
    prev = f(lo)
    for i in range(1, steps + 1):
        x = lo + (hi - lo) * i / steps
        cur = f(x)
        if prev < 0 <= cur:
            roots.append(x)
        prev = cur
    return roots


def d2(data, floor=0.0):
    out = {}
    for df in DFS:
        pairs = [(p[t], p[t + 1]) for p in data[df] for t in range(0, 5)
                 if p[t] > floor and p[t + 1] > floor]             # days 1..6
        if len(pairs) < 5:
            out[df] = dict(pairs=len(pairs), testable=False, reason="too few pairs")
            continue
        lx = [math.log(a) for a, _ in pairs]
        ly = [math.log(b / a) for a, b in pairs]
        m = sum(lx) / len(lx)
        s = math.sqrt(sum((v - m) ** 2 for v in lx) / len(lx)) or 1.0
        xs = [(v - m) / s for v in lx]
        beta, _ = lstsq([[1.0, x, x * x, x ** 3] for x in xs], ly)
        ups = cubic_roots_upward(beta, min(xs), max(xs))
        if not ups:
            out[df] = dict(pairs=len(pairs), testable=False, reason="no upward crossing in range")
            continue
        u = math.exp(m + s * ups[0])
        starts = [(p[0], p[6]) for p in data[df]]
        high = [end for start, end in starts if start > 1.5 * u]
        low = [end for start, end in starts if start < u / 1.5]
        testable = len(high) >= 5 and len(low) >= 5
        res = dict(pairs=len(pairs), need=u, high_n=len(high), low_n=len(low),
                   high_alive=(sum(1 for e in high if e > floor) / len(high)) if high else None,
                   low_extinct=(sum(1 for e in low if e <= floor) / len(low)) if low else None,
                   testable=testable)
        if testable:
            res["passed"] = res["high_alive"] >= 0.9 and res["low_extinct"] >= 0.9
        out[df] = res
    tested = [v for v in out.values() if v.get("testable")]
    verdict = ("not testable" if not tested else
               ("passed" if all(v["passed"] for v in tested) else "failed"))
    return dict(D2=verdict, floor=floor, by_df=out)


def main(directory, results, source="Zenodo 5003142 (mirror of Dryad doi:10.5061/dryad.p2481134)"):
    data = read(directory)
    floor, nneg = detection_floor(data)
    res = dict(source=source,
               populations={df: len(data[df]) for df in DFS}, d1=d1(data), d2=d2(data),
               detection_floor=dict(value=floor, negative_readings=nneg),
               d1_prime=d1(data, floor), d2_prime=d2(data, floor))
    os.makedirs(results, exist_ok=True)
    with open(os.path.join(results, "VERDICTS-data.json"), "w") as f:
        json.dump(res, f, indent=1)
    print(json.dumps(res, indent=1))


if __name__ == "__main__":
    here = os.path.dirname(os.path.abspath(__file__))
    args = [a for a in sys.argv[1:] if a != "--null"]
    main(args[0], args[1] if len(args) > 1 else os.path.join(here, "results", "data"),
         *(["synthetic null (synth_null.py: Markov two-phase model, measurement noise N(0, 50))"]
           if "--null" in sys.argv else []))
