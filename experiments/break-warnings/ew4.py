"""EW4: EW2's frozen test of thesis T6's uncoupled side on the Farallon seabirds and the central
California juvenile rockfish, to 2021. Python standard library only; the statistics are EW2's
(ew2.py), unchanged, with EW2's four level covariates (the birds' prey is mostly unfished, so no
draw is read). Frozen rules: PREDICTIONS-2026-10-22-EW4.md.

    python3 -I ew4.py extract <985565.csv> <hauls.csv> <yoy.csv> <out.csv>   one CSV of series
    python3 -I ew4.py layout <series.csv>                                     presence only
    python3 -I ew4.py dry [reps]                                              generators only
    python3 -I ew4.py test <series.csv>                                       after the freeze

Sources (none committed; hashes in the predictions): BCO-DMO 985565 v1 (breeding success);
NOAA SWFSC Rockfish Recruitment and Ecosystem Assessment Survey, ERDDAP dataset
FED_Rockfish_Catch (oceanview.pfeg.noaa.gov), the core area (strata C): the hauls
(time, cruise, haul_no, station; distinct) and the young-of-the-year Sebastes catches.
The prey in year t is the mean over the year's core hauls of log(1 + YOY rockfish caught).
"""

import collections
import csv
import json
import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # -I leaves the script's folder out
import ew2  # noqa: E402
import ew3  # noqa: E402
from ew2 import ALPHA, W, Prepared, pp_test, rows_of, zscore  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, "results", "ew4")

STOCKS = {
    "CAL": dict(prey="cal_yoy_rockfish",
                deps=["bs:SE Farallon:common murre", "bs:SE Farallon:rhinoceros auklet",
                      "bs:SE Farallon:pigeon guillemot"],
                scope="primary",
                what="California Current: YOY rockfish in the core area of the NMFS midwater "
                     "trawl survey (May-June); common murre, rhinoceros auklet, pigeon guillemot "
                     "at Southeast Farallon (EW2's three)"),
    "CAL5": dict(prey="cal_yoy_rockfish",
                 deps=["bs:SE Farallon:common murre", "bs:SE Farallon:rhinoceros auklet",
                       "bs:SE Farallon:pigeon guillemot", "bs:SE Farallon:Brandt's cormorant",
                       "bs:SE Farallon:pelagic cormorant"],
                 scope="secondary: the two cormorants added",
                 what="As CAL, with Brandt's and pelagic cormorants added to the index"),
}
PRIMARY = ["CAL"]
# EW2's CAL rows (study section 289, R3 Farallon): Cury et al.'s prey to 2007.
EW2_ROWS = set(range(1983, 2008))


# ----------------------------------------------------------------------------- data

def extract(bco, hauls_csv, yoy_csv, out_path):
    series = ew3_bcodmo(bco)
    hauls = {}
    for r in list(csv.DictReader(open(hauls_csv, encoding="utf-8")))[1:]:   # row 1: units
        hauls[(r["cruise"], r["haul_no"])] = int(r["time"][:4])
    caught = collections.Counter()
    for r in list(csv.DictReader(open(yoy_csv, encoding="utf-8")))[1:]:
        caught[(r["cruise"], r["haul_no"])] += int(r["catch"])
    by_year = collections.defaultdict(list)
    for key, y in hauls.items():
        by_year[y].append(math.log1p(caught.get(key, 0)))
    series["cal_yoy_rockfish"] = {y: sum(v) / len(v) for y, v in by_year.items()}
    series["cal_hauls"] = {y: float(len(v)) for y, v in by_year.items()}
    with open(out_path, "w", encoding="utf-8", newline="") as h:
        w = csv.writer(h)
        w.writerow(["series", "year", "value"])
        for name in sorted(series):
            for y in sorted(series[name]):
                w.writerow([name, y, repr(series[name][y])])
    print(f"{len(series)} series -> {out_path}")


def ew3_bcodmo(path):
    out = {}
    for r in csv.DictReader(open(path, encoding="utf-8")):
        v = r["breeding_success"].strip()
        if v:
            out.setdefault("bs:%s:%s" % (r["site"], r["species"]), {})[int(r["year"])] = float(v)
    return out


def stock_series(data, spec):
    prey = zscore(data[spec["prey"]])
    deps = [zscore(data[d]) for d in spec["deps"]]
    index = {}
    for y in sorted(set().union(*[set(z) for z in deps])):
        vals = [z[y] for z in deps if y in z]
        index[y] = sum(vals) / len(vals)
    return prey, index


def layout(path):
    data = ew3.load(path)
    out = {}
    for name, spec in STOCKS.items():
        prey, index = stock_series(data, spec)
        rows = rows_of(prey, index)
        ys = [r[0] for r in rows]
        out[name] = dict(scope=spec["scope"], prey_years=[min(prey), max(prey)],
                         prey_missing=sorted(set(range(min(prey), max(prey) + 1)) - set(prey)),
                         hauls_per_year={y: int(data["cal_hauls"][y]) for y in sorted(data["cal_hauls"])},
                         deps_years={d: [min(data[d]), max(data[d])] for d in spec["deps"]},
                         deps_missing={d: sorted(set(range(min(data[d]), max(data[d]) + 1))
                                                 - set(data[d])) for d in spec["deps"]},
                         usable=len(rows), usable_years=ys, failures=int(round(len(rows) / 3)),
                         usable_not_in_ew2=len([y for y in ys if y not in EW2_ROWS]))
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "layout.json"), "w") as h:
        json.dump(out, h, indent=1)
    print(json.dumps({k: {kk: v[kk] for kk in ("usable", "usable_years", "failures",
                                                 "usable_not_in_ew2", "deps_years")}
                      for k, v in out.items()}, indent=1))
    return out


# ----------------------------------------------------------------------------- generators

# CAL's calendar and presence (from `layout`, presence only): prey 1990-2025 complete; the three
# dependents complete over 1990-2021.
ew3.LAYOUT = {"CAL": dict(years=list(range(1990, 2022)), prey_missing=[],
                          deps={"murre": [], "auklet": [], "guillemot": []})}
GENERATORS = ["G0", "G0s", "G0n", "G5", "G0r", "G1", "G2", "G3a", "G3b", "G4", "G4s"]
NULLS = ["G0", "G0s", "G0n", "G5", "G0r"]


def dry_one(args):
    kind, seed = args
    rng = random.Random(seed)
    data = ew3.generate(kind, rng)
    prey, _, index = ew3.gen_series(data, "CAL")
    rows = rows_of(prey, index)
    out = {}
    for adj in (True, False):
        res = pp_test([Prepared(rows, adj)])
        out["level" if adj else "none"] = {w: res[w]["p"] for w in res}
    return kind, out


def dry(reps):
    from multiprocessing import Pool
    jobs = [(k, 1000003 * (i + 1) + 7919 * j + 47) for j, k in enumerate(GENERATORS)
            for i in range(reps)]
    with Pool() as pool:
        res = pool.map(dry_one, jobs, chunksize=8)
    out = {}
    for kind in GENERATORS:
        rs = [r[1] for r in res if r[0] == kind]
        rate = lambda adj, w: sum(r[adj][w] < ALPHA for r in rs) / len(rs)
        out[kind] = dict(reps=len(rs), reject_ar1=rate("level", "ar1"),
                         reject_var=rate("level", "var"),
                         unadjusted_reject_ar1=rate("none", "ar1"),
                         unadjusted_reject_var=rate("none", "var"))
    accept = all(out[k]["reject_ar1"] <= 0.045 and out[k]["reject_var"] <= 0.045 for k in NULLS)
    power_ok = out["G3a"]["reject_ar1"] >= 0.5 and out["G3b"]["reject_var"] >= 0.5
    summary = dict(window=W, alpha_each=ALPHA, generators=out, nulls=NULLS,
                   acceptance_nulls_at_most_0_045=accept,
                   stop_rule_power_at_least_0_5=power_ok)
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "dry.json"), "w") as h:
        json.dump(summary, h, indent=1)
    for k in GENERATORS:
        o = out[k]
        print(f"{k:4s} reps {o['reps']}  reject AR1 {o['reject_ar1']:.3f}  var {o['reject_var']:.3f}"
              f"  | unadjusted AR1 {o['unadjusted_reject_ar1']:.3f}  var {o['unadjusted_reject_var']:.3f}")
    print("acceptance (every null at most 0.045):", accept, "| stop rule (power >= 0.5):", power_ok)


# ----------------------------------------------------------------------------- the test

def test(path):
    data = ew3.load(path)
    report = dict(window=W, alpha_each=ALPHA, test="partial correlation given the level path, "
                                                   "Pyper-Peterman N* (EW2's design)")

    def run(names, w=W, adjust=True, keep=None):
        preps, info = [], []
        for name in names:
            prey, index = stock_series(data, STOCKS[name])
            rows = rows_of(prey, index, w)
            if keep is not None:
                rows = [r for r in rows if keep(r[0])]
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
    reported = {"R1_unadjusted": run(PRIMARY, adjust=False),
                "R2_window_6": run(PRIMARY, w=6),
                "R2_window_10": run(PRIMARY, w=10),
                "R5_rows_not_in_ew2": run(PRIMARY, keep=lambda t: t not in EW2_ROWS),
                "R3_CAL5": run(["CAL5"])}
    report["reported_only"] = reported
    os.makedirs(RESULTS, exist_ok=True)
    with open(os.path.join(RESULTS, "test.json"), "w") as h:
        json.dump(report, h, indent=1)
    print(json.dumps(dict(V1_AR1=report["V1_AR1"], V2_variance=report["V2_variance"],
                          V=prim), indent=1))


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "extract":
        extract(*sys.argv[2:6])
    elif cmd == "layout":
        layout(sys.argv[2])
    elif cmd == "dry":
        dry(int(sys.argv[2]) if len(sys.argv) > 2 else 2000)
    elif cmd == "test":
        test(sys.argv[2])
    else:
        print(__doc__)
