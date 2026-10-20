"""EW2: a frozen field test of thesis T6's uncoupled side, on Cury et al.'s (2011) forage fish
and seabirds. Python standard library only. Frozen rules: PREDICTIONS-2026-10-21-EW2.md.

    python3 -I ew2.py extract <som_text.txt> <out.csv>   rows of the SOM's data section
    python3 -I ew2.py layout <data.csv>                   presence only (years), no values
    python3 -I ew2.py dry [reps]                          dry runs on generators (no field value)
    python3 -I ew2.py test <data.csv>                     the frozen test (run after the freeze)

Source: Cury et al., Science 334:1703 (2011), the authors' accepted version with its
Supporting Online Material (Archimer 00056/16770, file 14307.pdf, sha256
5c1f8840d3538a3034b660da3face5ab697ffb33597e24fef469b81bdaa031f1). The SOM prints "the complete
data set that is used throughout the manuscript", normalized per series (z-scores), as rows
"year";"breeding success";"prey abundance";"ecosystem";"colour";"species";"prey";"series".
The text layer was read with macOS PDFKit (pdftext.js); neither the PDF nor the extract is
committed. One row prints its series as 3"2 (series 3, 1994): read as series 3.

T6 (canonical chapter, theses and conjectures), refutation clause: a drawn stock whose dependent
takes a negligible share of it, whose variance or lag-1 autocorrelation before the dependent's
break exceeds what the stock's own level and draw predict, against periods of the same stock at
the same level with no break.
"""

import json
import math
import os
import random
import re
import sys

W = 8                      # window: the W years before the breeding year
ALPHA = 0.025              # one-sided, per statistic (two statistics: familywise 0.05)
B_DRY = 499                # surrogates per dry-run replicate of the first design (record only)
MIN_SHIFT = 2              # first design: circular shifts of the dependent's residual, 2 .. m-2
HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, "results")

# Stocks: the prey series (one z-scored copy of it) and the dependents averaged into the
# dependent's index (mean of the available breeding-success z-scores in a year).
STOCKS = {
    "BEN": dict(prey="2", deps=["2", "3", "4"], scope="primary",
                what="Benguela: sardine and anchovy spawner biomass west of Cape Agulhas "
                     "(November acoustic survey); Cape gannets at Malgas and Lambert's Bay, "
                     "African penguins at Robben Island"),
    "ROST": dict(prey="18", deps=["18"], scope="primary",
                 what="Norwegian Sea: age-0 Norwegian spring-spawning herring (ICES VPA, "
                      "1 January); Atlantic puffins at Rost"),
    "CAL": dict(prey="15", deps=["15", "16", "17"], scope="secondary: share unmeasured",
                what="California Current: juvenile rockfish index (NMFS trawl survey, May-June); "
                     "common murre, rhinoceros auklet, pigeon guillemot at Southeast Farallon"),
    "SHE": dict(prey="5", deps=["5", "6", "7", "8"], scope="secondary: coupled case",
                what="North Sea: Shetland sandeel biomass (VPA, then trawl survey); Arctic skua, "
                     "great skua, Arctic tern, kittiwake at Foula"),
    "ROST2": dict(prey="18", deps=["18", "19"], scope="secondary: both Rost dependents",
                  what="As ROST, with the Rost kittiwakes added to the index"),
}
PRIMARY = ["BEN", "ROST"]


# ----------------------------------------------------------------------------- data

def extract(txt_path, out_path):
    rows = []
    for line in open(txt_path, encoding="utf-8"):
        if re.match(r'^"\d{4}";', line):
            f = [x.strip().strip('"') for x in line.strip().split(";")]
            sid = f[7].split('"')[0]          # 3"2 -> 3
            rows.append([f[0], f[1], f[2], f[3], f[4], f[5], f[6], sid])
    with open(out_path, "w", encoding="utf-8") as h:
        h.write("year,bs,prey,ecosystem,colour,species,prey_label,series\n")
        for r in rows:
            h.write(",".join("" if x == "NA" else x for x in r) + "\n")
    print(f"{len(rows)} rows -> {out_path}")


def load(path):
    """series -> {year: (bs or None, prey or None)}"""
    data = {}
    lines = open(path, encoding="utf-8").read().strip().split("\n")[1:]
    for line in lines:
        f = line.split(",")
        yr, bs, prey, sid = int(f[0]), f[1], f[2], f[7]
        val = (float(bs) if bs else None, float(prey) if prey else None)
        data.setdefault(sid, {})[yr] = val
    return data


def stock_series(data, spec):
    prey = {y: v[1] for y, v in data[spec["prey"]].items() if v[1] is not None}
    index = {}
    years = set()
    for d in spec["deps"]:
        years |= set(data[d])
    for y in sorted(years):
        vals = [data[d][y][0] for d in spec["deps"] if y in data[d] and data[d][y][0] is not None]
        if vals:
            index[y] = sum(vals) / len(vals)
    return prey, index


# ----------------------------------------------------------------------------- statistics

def mean(v):
    return sum(v) / len(v)


def detrend(v):
    n = len(v)
    mx = (n - 1) / 2
    my = mean(v)
    sxx = sum((i - mx) ** 2 for i in range(n))
    b = sum((i - mx) * (y - my) for i, y in enumerate(v)) / sxx
    return [y - (my + b * (i - mx)) for i, y in enumerate(v)], b


def window_stats(v):
    r, slope = detrend(v)
    ss = sum(x * x for x in r)
    ar1 = sum(r[i] * r[i + 1] for i in range(len(r) - 1)) / ss if ss > 0 else 0.0
    var = ss / (len(r) - 2)
    return ar1, var, slope


def rows_of(prey, index, w=W):
    """Usable years t: prey at t and at each of t-w .. t-1, and the dependent's index at t.
    Row: (t, level, level^2, prey(t-1), window slope, AR1, variance, index)."""
    out = []
    for t in sorted(index):
        if t not in prey or any((t - k) not in prey for k in range(1, w + 1)):
            continue
        win = [prey[t - k] for k in range(w, 0, -1)]
        ar1, var, slope = window_stats(win)
        lv = prey[t]
        out.append((t, lv, lv * lv, prey[t - 1], slope, ar1, var, index[t]))
    return out


def solve(a, b):
    n = len(b)
    m = [row[:] + [b[i]] for i, row in enumerate(a)]
    for c in range(n):
        p = max(range(c, n), key=lambda r: abs(m[r][c]))
        m[c], m[p] = m[p], m[c]
        if abs(m[c][c]) < 1e-12:
            raise ValueError("singular design")
        for r in range(n):
            if r != c:
                f = m[r][c] / m[c][c]
                for k in range(c, n + 1):
                    m[r][k] -= f * m[c][k]
    return [m[i][n] / m[i][i] for i in range(n)]


def residual_maker(x):
    """M = I - X (X'X)^-1 X' as a list of rows."""
    n, k = len(x), len(x[0])
    xtx = [[sum(x[i][a] * x[i][b] for i in range(n)) for b in range(k)] for a in range(k)]
    inv = [solve(xtx, [1.0 if j == c else 0.0 for j in range(k)]) for c in range(k)]
    # inv[c] is column c of (X'X)^-1 (symmetric)
    h = [[sum(x[i][a] * inv[b][a] * x[j][b] for a in range(k) for b in range(k))
          for j in range(n)] for i in range(n)]
    return [[(1.0 if i == j else 0.0) - h[i][j] for j in range(n)] for i in range(n)]


def matvec(m, v):
    return [sum(a * b for a, b in zip(row, v)) for row in m]


def failures(index_vals):
    """1 for the round(m/3) lowest values (ties broken by order), else 0."""
    m = len(index_vals)
    k = int(round(m / 3))
    order = sorted(range(m), key=lambda i: (index_vals[i], i))
    f = [0.0] * m
    for i in order[:k]:
        f[i] = 1.0
    return f


def cor(a, b):
    sa = math.sqrt(sum(x * x for x in a))
    sb = math.sqrt(sum(x * x for x in b))
    if sa == 0 or sb == 0:
        return 0.0
    return sum(x * y for x, y in zip(a, b)) / (sa * sb)


class Prepared:
    """One stock's rows, its residual maker and the dependent's fitted values and residuals."""

    def __init__(self, rows, adjust=True):
        self.m = len(rows)
        self.x = [[1.0, r[1], r[2], r[3], r[4]] if adjust else [1.0] for r in rows]
        self.p = len(self.x[0])
        self.M = residual_maker(self.x)
        idx = [r[7] for r in rows]
        res = matvec(self.M, idx)
        self.fitted = [a - b for a, b in zip(idx, res)]
        self.res = res
        self.fail = failures(idx)
        self.stat_res = {"ar1": matvec(self.M, [r[5] for r in rows]),
                         "var": matvec(self.M, [r[6] for r in rows])}
        self.weight = math.sqrt(max(self.m - self.p - 2, 1))

    def r(self, fail, which):
        return cor(matvec(self.M, fail), self.stat_res[which])

    def surrogate_fail(self, k):
        n = self.m
        idx = [self.fitted[i] + self.res[(i + k) % n] for i in range(n)]
        return failures(idx)


def fisher(r):
    r = max(min(r, 0.999999), -0.999999)
    return 0.5 * math.log((1 + r) / (1 - r))


def combined(preps, rs):
    num = sum(p.weight * fisher(r) for p, r in zip(preps, rs))
    den = math.sqrt(sum(p.weight ** 2 for p in preps))
    return num / den


def crt_both(preps, n_sur, rng):
    """The first design, kept for the record (it failed the dry-run acceptance): the combined
    statistic's one-sided p from circular shifts of each dependent's residual on the level
    covariates, the fitted values kept, failures recomputed. The observed residual is
    orthogonal to the covariates and its shifts are not, so the observed configuration is not
    exchangeable with them; rejections ran at about twice the nominal rate."""
    obs_r = {w: [p.r(p.fail, w) for p in preps] for w in ("ar1", "var")}
    obs = {w: combined(preps, obs_r[w]) for w in obs_r}
    ge = {"ar1": 0, "var": 0}
    for _ in range(n_sur):
        mfs = [matvec(p.M, p.surrogate_fail(rng.randint(MIN_SHIFT, p.m - MIN_SHIFT)))
               for p in preps]
        for w in ge:
            rs = [cor(mf, p.stat_res[w]) for p, mf in zip(preps, mfs)]
            if combined(preps, rs) >= obs[w]:
                ge[w] += 1
    return {w: dict(T=obs[w], r=obs_r[w], p=(1 + ge[w]) / (1 + n_sur)) for w in ge}


def acf(a, k):
    n = len(a)
    m = mean(a)
    d = sum((x - m) ** 2 for x in a)
    if d == 0:
        return 0.0
    return sum((a[i] - m) * (a[i + k] - m) for i in range(n - k)) / d * (n / (n - k))


def n_eff(a, b):
    """Pyper and Peterman (1998): 1/N* = 1/N + (2/N) sum_{k<=N/5} ((N-k)/N) rho_a(k) rho_b(k)."""
    n = len(a)
    s = sum(((n - k) / n) * acf(a, k) * acf(b, k) for k in range(1, max(1, n // 5) + 1))
    inv = 1 / n + (2 / n) * s
    return min(float(n), 1 / inv) if inv > 0 else float(n)


def pp_test(preps):
    """The frozen test: per stock the partial correlation r between failure and the window
    statistic given the level covariates, Fisher z with the effective size N* of the two
    residual series (Pyper and Peterman 1998) less the covariates, combined across stocks
    (Stouffer, weights sqrt(N* - q - 3), q covariates besides the intercept); one-sided p
    for a statistic higher before failures."""
    out = {}
    for w in ("ar1", "var"):
        num = den = 0.0
        per = []
        for p in preps:
            a = matvec(p.M, p.fail)
            b = p.stat_res[w]
            r = cor(a, b)
            ne = n_eff(a, b)
            wt = math.sqrt(max(ne - (p.p - 1) - 3, 1.0))
            num += wt * wt * fisher(r)
            den += wt * wt
            per.append(dict(r=r, n_eff=ne, m=p.m))
        z = num / math.sqrt(den)
        p_one = 0.5 * math.erfc(z / math.sqrt(2))
        out[w] = dict(Z=z, p=p_one, p_two_sided=min(1.0, 2 * min(p_one, 1 - p_one)), per=per)
    return out


# ----------------------------------------------------------------------------- layout

def layout(path):
    data = load(path)
    out = {}
    for name, spec in STOCKS.items():
        prey, index = stock_series(data, spec)
        rows = rows_of(prey, index)
        out[name] = dict(scope=spec["scope"], prey_years=[min(prey), max(prey)],
                         prey_missing=sorted(set(range(min(prey), max(prey) + 1)) - set(prey)),
                         index_years=len(index), usable=len(rows),
                         usable_years=[r[0] for r in rows],
                         failures=int(round(len(rows) / 3)))
    print(json.dumps(out, indent=1))
    return out


# ----------------------------------------------------------------------------- generators

LAYOUT = {
    # calendar and presence of the primary stocks (from `layout`, presence only)
    "BEN": dict(years=list(range(1988, 2010)), prey_missing=[],
                deps={"2": [], "3": [1988, 1989, 1990, 2001, 2006],
                      "4": [1999, 2004, 2005, 2006, 2007, 2008, 2009]}),
    "ROST": dict(years=list(range(1964, 2010)), prey_missing=[1998], deps={"18": [1998]}),
}


def zscore(d):
    vals = list(d.values())
    m = mean(vals)
    s = math.sqrt(sum((x - m) ** 2 for x in vals) / (len(vals) - 1)) or 1.0
    return {k: (v - m) / s for k, v in d.items()}


def generate(kind, rng):
    """Field-shaped data for the two primary stocks under one generator.

    Stock: Ricker renewal on the level X (carrying capacity 1), X' = X exp(1 - X - e - s + sigma eps),
    under a draw e that rises from 0.1 to a peak in [0.5, 0.95] and falls, with a random phase and
    0.5-1.5 cycles over the series; sigma 0.4. Observed prey: log X plus observation noise
    (sd 0.2; 0.4 in G0n), z-scored. Each dependent's breeding success follows Cury et al.'s
    asymptote 1 - exp(-X/0.12) (G0s: a sigmoid at X = 1/3) plus noise sd 0.25, z-scored.
      G0   no feedback, need on the level only (T6's uncoupled side)
      G0s  as G0 with a sigmoid need at a third of the carrying capacity
      G0n  as G0 with observation noise 0.4
      G5   as G0 with the need on last year's level (a prey index a year off)
      G1   feedback of the measured size: the birds take a share 0.013 B/(0.1 + X)
           (3% at X = 1/3 with B = 1); bird numbers B follow breeding success
      G2   feedback of the coupled case: share 0.17 B/(0.1 + X) (40% at X = 1/3)
      G3a  a need on the prey's recent autocorrelation: breeding success lowered by 0.144 per
           standard deviation of the window AR1 beyond the level covariates
      G3b  the same on the window variance
      G4   a shared driver: an AR(1) environment (0.7) raises the stock's noise
           (sigma 0.4 exp(0.35 E)) and lowers breeding success by 0.1 E
      G4s  a strong shared driver: sigma 0.4 exp(0.7 E), breeding success lowered by 0.2 E
      G0r  as G0 with the breeding-success noise AR(1) (0.5): residuals autocorrelated
    """
    data = {}
    for name, lay in LAYOUT.items():
        years = lay["years"]
        n = len(years)
        burn = 20
        cycles = rng.uniform(0.5, 1.5)
        phase = rng.random()
        peak = rng.uniform(0.5, 0.95)
        c = {"G1": 0.013, "G2": 0.17}.get(kind, 0.0)
        obs_sd = 0.4 if kind == "G0n" else 0.2
        x, b, e_env = 0.8, 1.0, 0.0
        xs, bs_mean_hist = [], []
        for t in range(-burn, n):
            u = max(t, 0) / n
            draw = 0.1 + (peak - 0.1) * 0.5 * (1 - math.cos(2 * math.pi * (u * cycles + phase)))
            e_env = 0.7 * e_env + math.sqrt(1 - 0.49) * rng.gauss(0, 1)
            sigma = {"G4": 0.4 * math.exp(0.35 * e_env),
                     "G4s": 0.4 * math.exp(0.7 * e_env)}.get(kind, 0.4)
            share = c * b / (0.1 + x)
            if t >= 0:
                xs.append((x, e_env))
            mean_bs = 1 - math.exp(-x / 0.12)
            b = min(max(b * math.exp(0.3 * (mean_bs - 0.7)), 0.3), 3.0)
            x = max(x * math.exp(1.0 - x - draw - share + sigma * rng.gauss(0, 1)), 1e-4)
        prey_raw = {years[i]: math.log(xs[i][0]) + obs_sd * rng.gauss(0, 1)
                    for i in range(n) if years[i] not in lay["prey_missing"]}
        prey = zscore(prey_raw)
        sid_prey = name + "_prey"
        data[sid_prey] = {y: (None, prey.get(y)) for y in years}
        # the effect of G3: standardized residual of the window statistic on the covariates
        g3 = {}
        if kind in ("G3a", "G3b"):
            dummy_index = {y: 0.0 for y in years}
            rows = rows_of(prey, dummy_index)
            prep = Prepared([r[:7] + (0.0,) for r in rows])
            z = prep.stat_res["ar1" if kind == "G3a" else "var"]
            s = math.sqrt(sum(v * v for v in z) / (len(z) - 1)) or 1.0
            g3 = {r[0]: z[i] / s for i, r in enumerate(rows)}
        for sid, missing in lay["deps"].items():
            bs_raw = {}
            nz = 0.0
            for i, y in enumerate(years):
                nz = 0.5 * nz + math.sqrt(1 - 0.25) * rng.gauss(0, 1)
                if y in missing:
                    continue
                xl = xs[i - 1][0] if (kind == "G5" and i > 0) else xs[i][0]
                if kind == "G0s":
                    mu = 1 / (1 + math.exp(-(xl - 1 / 3) / 0.06))
                else:
                    mu = 1 - math.exp(-xl / 0.12)
                if kind == "G4":
                    mu -= 0.1 * xs[i][1]
                if kind == "G4s":
                    mu -= 0.2 * xs[i][1]
                mu -= 0.144 * g3.get(y, 0.0)
                bs_raw[y] = mu + 0.25 * (nz if kind == "G0r" else rng.gauss(0, 1))
            bz = zscore(bs_raw)
            data[name + "_" + sid] = {y: (bz.get(y), None) for y in years}
    return data


def gen_specs():
    return {name: dict(prey=name + "_prey", deps=[name + "_" + s for s in LAYOUT[name]["deps"]])
            for name in LAYOUT}


def dry_one(args):
    kind, seed = args
    rng = random.Random(seed)
    data = generate(kind, rng)
    specs = gen_specs()
    preps, preps_u = [], []
    for name in PRIMARY:
        prey, index = stock_series(data, specs[name])
        rows = rows_of(prey, index)
        preps.append(Prepared(rows))
        preps_u.append(Prepared(rows, adjust=False))
    adj = pp_test(preps)
    una = pp_test(preps_u)
    first = crt_both(preps, B_DRY, rng)
    return (kind, {w: adj[w]["p"] for w in adj}, {w: una[w]["p"] for w in una},
            {w: first[w]["p"] for w in first})


GENERATORS = ["G0", "G0s", "G0n", "G5", "G0r", "G1", "G2", "G3a", "G3b", "G4", "G4s"]
NULLS = ["G0", "G0s", "G0n", "G5", "G0r"]


def dry(reps):
    from multiprocessing import Pool
    jobs = [(k, 1000003 * (i + 1) + 7919 * j) for j, k in enumerate(GENERATORS)
            for i in range(reps)]
    with Pool() as pool:
        res = pool.map(dry_one, jobs, chunksize=8)
    out = {}
    for kind in GENERATORS:
        rs = [r for r in res if r[0] == kind]
        rate = lambda i, w: sum(r[i][w] < ALPHA for r in rs) / len(rs)
        out[kind] = dict(
            reps=len(rs),
            reject_ar1=rate(1, "ar1"), reject_var=rate(1, "var"),
            reject_either=sum(min(r[1].values()) < ALPHA for r in rs) / len(rs),
            unadjusted_reject_ar1=rate(2, "ar1"), unadjusted_reject_var=rate(2, "var"),
            first_design_reject_ar1=rate(3, "ar1"), first_design_reject_var=rate(3, "var"))
    accept = all(out[k]["reject_ar1"] <= 0.045 and out[k]["reject_var"] <= 0.045 for k in NULLS)
    accept_first = all(out[k]["first_design_reject_ar1"] <= 0.045 and
                       out[k]["first_design_reject_var"] <= 0.045 for k in NULLS)
    summary = dict(window=W, alpha_each=ALPHA, generators=out, nulls=NULLS,
                   acceptance_nulls_at_most_0_045=accept,
                   first_design_surrogates=B_DRY, first_design_acceptance=accept_first)
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "dry.json"), "w") as h:
        json.dump(summary, h, indent=1)
    for k in GENERATORS:
        o = out[k]
        print(f"{k:4s} reps {o['reps']}  reject AR1 {o['reject_ar1']:.3f}  var {o['reject_var']:.3f}"
              f"  either {o['reject_either']:.3f}  | unadjusted AR1 {o['unadjusted_reject_ar1']:.3f}"
              f"  var {o['unadjusted_reject_var']:.3f}  | first design AR1 "
              f"{o['first_design_reject_ar1']:.3f}  var {o['first_design_reject_var']:.3f}")
    print("acceptance (every null generator rejects at most 0.045 per statistic):", accept)
    print("first design's acceptance:", accept_first)


# ----------------------------------------------------------------------------- the test

def test(path):
    data = load(path)
    report = dict(window=W, alpha_each=ALPHA, test="partial correlation, Pyper-Peterman N*")

    def run(names, w=W, adjust=True):
        preps, info = [], []
        for name in names:
            prey, index = stock_series(data, STOCKS[name])
            rows = rows_of(prey, index, w)
            prep = Prepared(rows, adjust)
            preps.append(prep)
            info.append(dict(stock=name, usable=prep.m, failures=int(sum(prep.fail)),
                             years=[rows[0][0], rows[-1][0]]))
        res = pp_test(preps)
        for st in res.values():
            for n, d in zip(names, st["per"]):
                d["stock"] = n
                d["r"] = round(d["r"], 4)
                d["n_eff"] = round(d["n_eff"], 2)
            st["Z"] = round(st["Z"], 4)
        return dict(stocks=info, result=res)

    prim = run(PRIMARY)
    report["V"] = prim
    report["V1_AR1"] = "passed" if prim["result"]["ar1"]["p"] >= ALPHA else "failed"
    report["V2_variance"] = "passed" if prim["result"]["var"]["p"] >= ALPHA else "failed"
    reported = {}
    reported["R1_unadjusted"] = run(PRIMARY, adjust=False)
    reported["R2_window_6"] = run(PRIMARY, w=6)
    reported["R2_window_10"] = run(PRIMARY, w=10)
    for name in ["BEN", "ROST", "CAL", "SHE", "ROST2"]:
        reported["R3_" + name] = run([name])
    report["reported_only"] = reported
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "test.json"), "w") as h:
        json.dump(report, h, indent=1)
    print(json.dumps(dict(V1_AR1=report["V1_AR1"], V2_variance=report["V2_variance"],
                          V=prim), indent=1))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "extract":
        extract(sys.argv[2], sys.argv[3])
    elif cmd == "layout":
        layout(sys.argv[2])
    elif cmd == "dry":
        dry(int(sys.argv[2]) if len(sys.argv) > 2 else 2000)
    elif cmd == "test":
        test(sys.argv[2])
    else:
        print(__doc__)
