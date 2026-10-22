"""EW3: EW2's frozen test of thesis T6's uncoupled side on longer series that EW2 did not read,
with the catch as the draw. Python standard library only; the statistics are EW2's own
functions (ew2.py), unchanged. Frozen rules: PREDICTIONS-2026-10-22-EW3.md.

    python3 -I ew3.py layout <series.csv>    presence only (years), no values
    python3 -I ew3.py dry [reps]             dry runs on generators (no field value)
    python3 -I ew3.py test <series.csv>      the frozen test (run after the freeze)

<series.csv> is written by ew3_data.py from the published sources (BCO-DMO 985565; ICES SAG
assessment key 21106; the MARAM data records of the 2024 sardine and anchovy assessments).

What changes from EW2: the series (raw values z-scored per series, as Cury et al. did), the
calendar, and two covariates for the draw (the catch in the year and in the year before,
z-scored), added to EW2's four level covariates. Everything else is EW2's: the window of 8
years, the window statistics, failure as the lowest third of the dependents' index, the partial
correlation with Pyper and Peterman's effective size, Stouffer's combination over the primary
stocks, alpha 0.025 per statistic.
"""

import csv
import json
import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # -I leaves the script's folder out
import ew2  # noqa: E402
from ew2 import ALPHA, W, matvec, cor, failures, residual_maker, window_stats, zscore, pp_test

HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, "results", "ew3")

# Stocks: prey(t) is a sum of source series at year t + lag; the draw is the catch at year t.
STOCKS = {
    "BEN": dict(prey=[("ben_sardine_west", 0), ("ben_anchovy", 0)], catch="ben_catch",
                deps=["bs:Malgas:Cape gannet", "bs:Lamberts:Cape gannet",
                      "bs:Robben:African penguin"],
                scope="primary",
                what="Benguela: November survey biomass of sardine west of Cape Agulhas plus "
                     "anchovy (to Port Alfred) in year t; catch of sardine west of Cape Agulhas "
                     "plus anchovy in year t; Cape gannets at Malgas and Lambert's Bay, African "
                     "penguins at Robben Island"),
    "ROST": dict(prey=[("her_recruit_age2", 2)], catch="her_catch",
                 deps=["bs:Rost:Atlantic puffin"], scope="primary",
                 what="Norwegian Sea: the year class born in year t, read as ICES's recruitment "
                      "at age 2 in year t + 2; the herring catch in year t; Atlantic puffins at "
                      "Rost"),
    "BEN4": dict(prey=[("ben_sardine_west", 0), ("ben_anchovy", 0)], catch="ben_catch",
                 deps=["bs:Malgas:Cape gannet", "bs:Lamberts:Cape gannet",
                       "bs:Robben:African penguin", "bs:Dassen:African penguin"],
                 scope="secondary: Dassen penguins added",
                 what="As BEN, with the African penguins at Dassen Island added to the index"),
    "ROST2": dict(prey=[("her_recruit_age2", 2)], catch="her_catch",
                  deps=["bs:Rost:Atlantic puffin", "bs:Rost:black-legged kittiwake, cliff colony",
                        "bs:Rost:black-legged kittiwake, harbour colony"],
                  scope="secondary: Rost kittiwakes added",
                  what="As ROST, with the Rost kittiwakes (both colonies) added to the index"),
}
PRIMARY = ["BEN", "ROST"]

# The years of EW2's test rows (study section 289), for the report on rows EW2 did not use.
EW2_ROWS = {"BEN": set(range(1996, 2010)),
            "ROST": set(range(1972, 1998)) | {2007, 2008, 2009}}


# ----------------------------------------------------------------------------- data

def load(path):
    d = {}
    for r in csv.DictReader(open(path, encoding="utf-8")):
        d.setdefault(r["series"], {})[int(r["year"])] = float(r["value"])
    return d


def stock_series(data, spec):
    """prey and catch z-scored over their years; the dependents' index is the mean of the
    available breeding-success z-scores (each series z-scored over all its years)."""
    parts = []
    for name, lag in spec["prey"]:
        parts.append({y - lag: v for y, v in data[name].items()})
    years = set.intersection(*[set(p) for p in parts])
    prey = zscore({y: sum(p[y] for p in parts) for y in years})
    catch = zscore(data[spec["catch"]])
    deps = [zscore(data[d]) for d in spec["deps"]]
    index = {}
    for y in sorted(set().union(*[set(z) for z in deps])):
        vals = [z[y] for z in deps if y in z]
        index[y] = sum(vals) / len(vals)
    return prey, catch, index


def rows_of(prey, catch, index, w=W):
    """Usable years t: prey at t and at each of t-w .. t-1, catch at t and t-1, the index at t.
    Row: (t, level, level^2, prey(t-1), window slope, AR1, variance, index, catch(t),
    catch(t-1))."""
    out = []
    for t in sorted(index):
        if t not in prey or any((t - k) not in prey for k in range(1, w + 1)):
            continue
        if t not in catch or (t - 1) not in catch:
            continue
        win = [prey[t - k] for k in range(w, 0, -1)]
        ar1, var, slope = window_stats(win)
        lv = prey[t]
        out.append((t, lv, lv * lv, prey[t - 1], slope, ar1, var, index[t], catch[t], catch[t - 1]))
    return out


class Prepared(ew2.Prepared):
    """EW2's Prepared with the draw: covariates 'draw' (EW2's four and the two catches, the
    frozen test), 'level' (EW2's four only) or 'none' (intercept only)."""

    def __init__(self, rows, adjust="draw"):
        self.m = len(rows)
        if adjust == "draw":
            self.x = [[1.0, r[1], r[2], r[3], r[4], r[8], r[9]] for r in rows]
        elif adjust == "level":
            self.x = [[1.0, r[1], r[2], r[3], r[4]] for r in rows]
        else:
            self.x = [[1.0] for r in rows]
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


def layout(path):
    data = load(path)
    out = {}
    for name, spec in STOCKS.items():
        prey, catch, index = stock_series(data, spec)
        rows = rows_of(prey, catch, index)
        ys = [r[0] for r in rows]
        out[name] = dict(scope=spec["scope"], prey_years=[min(prey), max(prey)],
                         prey_missing=sorted(set(range(min(prey), max(prey) + 1)) - set(prey)),
                         catch_years=[min(catch), max(catch)],
                         deps_missing={d: sorted(set(range(min(data[d]), max(data[d]) + 1))
                                                 - set(data[d])) for d in spec["deps"]},
                         deps_years={d: [min(data[d]), max(data[d])] for d in spec["deps"]},
                         usable=len(rows), usable_years=ys, failures=int(round(len(rows) / 3)),
                         usable_not_in_ew2=len([y for y in ys
                                                if y not in EW2_ROWS.get(name.rstrip("24"), set())]))
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "layout.json"), "w") as h:
        json.dump(out, h, indent=1)
    print(json.dumps(out, indent=1))
    return out


# ----------------------------------------------------------------------------- generators

# Calendar and presence of the primary stocks, from `layout` (presence only).
LAYOUT = {
    "BEN": dict(years=list(range(1984, 2021)), prey_missing=[],
                deps={"Malgas": list(range(1984, 1987)) + [2016, 2019],
                      "Lamberts": list(range(1984, 1990)) + [2000, 2005],
                      "Robben": list(range(1984, 1989)) + [2000, 2020]}),
    "ROST": dict(years=list(range(1986, 2022)), prey_missing=[], deps={"puffin": []}),
}


def generate(kind, rng):
    """EW2's generators (ew2.generate's docstring) on EW3's calendar, with the catch observed:
    the catch in a year is the draw times the level, plus observation noise of sd 0.1 on its
    logarithm, z-scored. The observed prey is the level plus observation noise (sd 0.2 of the
    level's own sd; 0.4 in G0n), z-scored: raw values, as the field series are read.
      G0, G0s, G0n, G5, G0r: the nulls (no association beyond the stock's own course)
      G1, G2: feedback of the measured and of the coupled size
      G3a, G3b: a need on the prey's recent autocorrelation or variance
      G4, G4s: a shared driver of the stock's noise and the birds' success
      G6: a need on the catch (competition with the fishery), no association with the statistics
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
        x, b, e_env = 0.8, 1.0, 0.0
        xs = []
        for t in range(-burn, n):
            u = max(t, 0) / n
            draw = 0.1 + (peak - 0.1) * 0.5 * (1 - math.cos(2 * math.pi * (u * cycles + phase)))
            e_env = 0.7 * e_env + math.sqrt(1 - 0.49) * rng.gauss(0, 1)
            sigma = {"G4": 0.4 * math.exp(0.35 * e_env),
                     "G4s": 0.4 * math.exp(0.7 * e_env)}.get(kind, 0.4)
            share = c * b / (0.1 + x)
            if t >= 0:
                xs.append((x, e_env, draw * x))
            mean_bs = 1 - math.exp(-x / 0.12)
            b = min(max(b * math.exp(0.3 * (mean_bs - 0.7)), 0.3), 3.0)
            x = max(x * math.exp(1.0 - x - draw - share + sigma * rng.gauss(0, 1)), 1e-4)
        level_sd = math.sqrt(sum((v[0] - mean_of(xs)) ** 2 for v in xs) / (n - 1)) or 1.0
        obs_sd = (0.4 if kind == "G0n" else 0.2) * level_sd
        prey = zscore({years[i]: xs[i][0] + obs_sd * rng.gauss(0, 1)
                       for i in range(n) if years[i] not in lay["prey_missing"]})
        catch = zscore({years[i]: xs[i][2] * math.exp(0.1 * rng.gauss(0, 1)) for i in range(n)})
        g3 = {}
        if kind in ("G3a", "G3b"):
            rows = rows_of(prey, catch, {y: 0.0 for y in years})
            prep = Prepared([r[:7] + (0.0,) + r[8:] for r in rows])
            z = prep.stat_res["ar1" if kind == "G3a" else "var"]
            s = math.sqrt(sum(v * v for v in z) / (len(z) - 1)) or 1.0
            g3 = {r[0]: z[i] / s for i, r in enumerate(rows)}
        data[name + ":prey"] = prey
        data[name + ":catch"] = catch
        for dep, missing in lay["deps"].items():
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
                if kind == "G6":
                    mu -= 0.5 * xs[i][2]
                mu -= 0.144 * g3.get(y, 0.0)
                bs_raw[y] = mu + 0.25 * (nz if kind == "G0r" else rng.gauss(0, 1))
            data[name + ":" + dep] = bs_raw
    return data


def mean_of(xs):
    return sum(v[0] for v in xs) / len(xs)


def gen_series(data, name):
    prey, catch = data[name + ":prey"], data[name + ":catch"]
    deps = [zscore(data[name + ":" + d]) for d in LAYOUT[name]["deps"]]
    index = {}
    for y in sorted(set().union(*[set(z) for z in deps])):
        vals = [z[y] for z in deps if y in z]
        index[y] = sum(vals) / len(vals)
    return prey, catch, index


def dry_one(args):
    kind, seed = args
    rng = random.Random(seed)
    data = generate(kind, rng)
    out = {}
    for adj in ("draw", "level", "none"):
        preps = [Prepared(rows_of(*gen_series(data, n)), adj) for n in PRIMARY]
        res = pp_test(preps)
        out[adj] = {w: res[w]["p"] for w in res}
    return kind, out


GENERATORS = ["G0", "G0s", "G0n", "G5", "G0r", "G1", "G2", "G3a", "G3b", "G4", "G4s", "G6"]
NULLS = ["G0", "G0s", "G0n", "G5", "G0r", "G6"]


def dry(reps):
    from multiprocessing import Pool
    jobs = [(k, 1000003 * (i + 1) + 7919 * j + 31) for j, k in enumerate(GENERATORS)
            for i in range(reps)]
    with Pool() as pool:
        res = pool.map(dry_one, jobs, chunksize=8)
    out = {}
    for kind in GENERATORS:
        rs = [r[1] for r in res if r[0] == kind]
        rate = lambda adj, w: sum(r[adj][w] < ALPHA for r in rs) / len(rs)
        out[kind] = dict(reps=len(rs),
                         reject_ar1=rate("draw", "ar1"), reject_var=rate("draw", "var"),
                         reject_either=sum(min(r["draw"].values()) < ALPHA for r in rs) / len(rs),
                         level_only_reject_ar1=rate("level", "ar1"),
                         level_only_reject_var=rate("level", "var"),
                         unadjusted_reject_ar1=rate("none", "ar1"),
                         unadjusted_reject_var=rate("none", "var"))
    accept = all(out[k]["reject_ar1"] <= 0.045 and out[k]["reject_var"] <= 0.045 for k in NULLS)
    summary = dict(window=W, alpha_each=ALPHA, generators=out, nulls=NULLS,
                   acceptance_nulls_at_most_0_045=accept)
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "dry.json"), "w") as h:
        json.dump(summary, h, indent=1)
    for k in GENERATORS:
        o = out[k]
        print(f"{k:4s} reps {o['reps']}  reject AR1 {o['reject_ar1']:.3f}  var {o['reject_var']:.3f}"
              f"  | level only AR1 {o['level_only_reject_ar1']:.3f}  var "
              f"{o['level_only_reject_var']:.3f}  | unadjusted AR1 {o['unadjusted_reject_ar1']:.3f}"
              f"  var {o['unadjusted_reject_var']:.3f}")
    print("acceptance (every null generator rejects at most 0.045 per statistic):", accept)


# ----------------------------------------------------------------------------- the test

def test(path):
    data = load(path)
    report = dict(window=W, alpha_each=ALPHA,
                  test="partial correlation given level and draw, Pyper-Peterman N*")

    def run(names, w=W, adjust="draw", keep=None):
        preps, info = [], []
        for name in names:
            prey, catch, index = stock_series(data, STOCKS[name])
            rows = rows_of(prey, catch, index, w)
            if keep is not None:
                rows = [r for r in rows if keep(name, r[0])]
            prep = Prepared(rows, adjust)
            preps.append(prep)
            info.append(dict(stock=name, usable=prep.m, failures=int(sum(prep.fail)),
                             years=[rows[0][0], rows[-1][0]]))
        res = pp_test(preps)
        for st in res.values():
            for n, d, prep in zip(names, st["per"], preps):
                d["stock"] = n
                d["q"] = prep.p - 1
                d["r"] = round(d["r"], 4)
                d["n_eff"] = round(d["n_eff"], 2)
            st["Z"] = round(st["Z"], 4)
        return dict(stocks=info, result=res)

    prim = run(PRIMARY)
    report["V"] = prim
    report["V1_AR1"] = "passed" if prim["result"]["ar1"]["p"] >= ALPHA else "failed"
    report["V2_variance"] = "passed" if prim["result"]["var"]["p"] >= ALPHA else "failed"
    reported = {}
    reported["R1_unadjusted"] = run(PRIMARY, adjust="none")
    reported["R4_level_only"] = run(PRIMARY, adjust="level")
    reported["R2_window_6"] = run(PRIMARY, w=6)
    reported["R2_window_10"] = run(PRIMARY, w=10)
    reported["R5_rows_not_in_ew2"] = run(PRIMARY, keep=lambda n, t: t not in EW2_ROWS[n])
    for name in STOCKS:
        reported["R3_" + name] = run([name])
    report["reported_only"] = reported
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "test.json"), "w") as h:
        json.dump(report, h, indent=1)
    print(json.dumps(dict(V1_AR1=report["V1_AR1"], V2_variance=report["V2_variance"],
                          V=prim), indent=1))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "layout":
        layout(sys.argv[2])
    elif cmd == "dry":
        dry(int(sys.argv[2]) if len(sys.argv) > 2 else 2000)
    elif cmd == "test":
        test(sys.argv[2])
    else:
        print(__doc__)
