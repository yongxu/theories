"""T1N's dry run (DESIGN.md, section 8): synthetic archives of walleye lakes in worlds with and without a need,
read by the frozen rules; the reader on synthetic files in the assumed layout; and the rules on scripted
cases. No value of the archive is read, and nothing is downloaded.

    python3 -B tools/research/gate.py hold -- python3 -B experiments/need-measured-in-advance/dry_run.py
                                       # writes results/dry-run.json

A synthetic lake, year by year from 1990 to 2025: spring adults per acre x; fall age-0 per mile
r = R(x) e^(s_r z), R(x) = A x^q / (K^q + x^q); next spring x' = S x - H + C r(t - 3), the draw H = e x (the
lake's exploitation, part of it tribal and recorded, the angling part recorded only in creel years);
the recorders estimate adults every 3 to 5 years (log-normal error, CV 0.25, and a 95% interval) and
survey age-0 most years; managers cut the harvest of a lake that falls below a level and stock it, recording
the stocking and changing its label, except where a world stocks unrecorded. Worlds:
    need          q = 3: renewal stops below a need, as T1 has it (the primary world)
    no need       q = 1: renewal goes on at every level above zero
    needs vary    q = 3, each lake's K drawn about the common one (a factor of 2)
    need rises    q = 3, K doubled from 2013: the need moved after the fit, the way MQ3's regimes moved
    need falls    q = 3, K halved from 2013: the fitted need too high afterwards
    unrecorded    q = 3, a third of the lakes that fall stocked with nothing recorded, the label kept
    open          q = 3, adults arriving from connected waters every year, unmeasured giving from beyond
    survival compensates   q = 3 for age-0, but the adults they make rise as age-0^0.3: renewal of adults
                  does not stop where the age-0 surveys say, so the need is read at the wrong stage
    episodic      q = 1.5 and renewal's spread doubled (1.6): below the need renewal is rare, not stopped,
                  and a strong year class can bring a lake back with nothing given from beyond
    renewal unseen   q = 1, renewal goes on at every level, but the survey catches age-0 in proportion to
                  x / (x + 0.5), so the need is measured where renewal does not stop
In every world a lake loses nine tenths of its adults in a year with chance KNOCK (a winterkill or
summerkill), which puts lakes below the need whatever the need's cause.
Each world is run at four speeds of the managers' response (STOCK_SPEEDS), which no record gives before
the data: how fast falling lakes are stocked and relabelled, and so leave the test. Standard library only;
seeded.
"""

import csv
import hashlib
import io
import json
import math
import random
import sys
import tempfile
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1n                       # noqa: E402
import reader                    # noqa: E402
import run as RUN                # noqa: E402

SEED = "T1N-dry-run-2026-11-05"
ARCHIVES = 40                   # synthetic archives a world and speed
LAKES = 300                     # lakes an archive
YEARS = range(1990, 2026)
A, K, S, C = 60.0, 1.5, 0.70, 0.03     # with these, a lake exploited above 0.3 a year has no level it keeps
SIGMA_R, CV = 0.8, 0.25
WORLDS = {
    "need": dict(q=3, k_spread=0.0, k_after=1.0, unrecorded=0.0),
    "no need": dict(q=1, k_spread=0.0, k_after=1.0, unrecorded=0.0),
    "needs vary": dict(q=3, k_spread=math.log(2), k_after=1.0, unrecorded=0.0),
    "need rises": dict(q=3, k_spread=0.0, k_after=2.0, unrecorded=0.0),
    "need falls": dict(q=3, k_spread=0.0, k_after=0.5, unrecorded=0.0),
    "unrecorded": dict(q=3, k_spread=0.0, k_after=1.0, unrecorded=1 / 3),
    "open": dict(q=3, k_spread=0.0, k_after=1.0, unrecorded=0.0, immigration=0.15),
    "survival compensates": dict(q=3, k_spread=0.0, k_after=1.0, unrecorded=0.0, gamma=0.3, c_gamma=0.40),
    "episodic": dict(q=1.5, k_spread=0.0, k_after=1.0, unrecorded=0.0, sigma_r=1.6),
    "renewal unseen": dict(q=1, k_spread=0.0, k_after=1.0, unrecorded=0.0, unseen=0.5),
}
STOCK_SPEEDS = (0.3, 0.1, 0.03, 0.0)   # the chance a year that managers stock a lake below STOCK_BELOW
STOCK_BELOW = 1.0               # adults per acre below which managers stock a lake and cut its harvest
CUT = 0.05                      # the exploitation a lake below STOCK_BELOW is cut to
KNOCK = 0.02                    # a year's chance that a lake loses nine tenths of its adults
NATURAL, STOCKED = t1n.NR, "stocked"


FROZEN_FILES = ("t1n.py", "reader.py", "run.py", "dry_run.py")   # the files the dry run runs with


def code_hashes():
    """The sha-256 of each file the dry run runs with, repository-relative."""
    rel = HERE.relative_to(HERE.parents[1])
    return {str(rel / f): hashlib.sha256((HERE / f).read_bytes()).hexdigest() for f in FROZEN_FILES}


class Checks:
    def __init__(self):
        self.by_kind, self.failed = {}, []

    def __call__(self, kind, name, ok, detail=None):
        self.by_kind[kind] = self.by_kind.get(kind, 0) + 1
        if not ok:
            self.failed.append({"kind": kind, "check": name, "detail": detail})


def recruitment(x, q, k):
    return A * x ** q / (k ** q + x ** q) if x > 0 else 0.0


def lake(rng, i, world, speed):
    """One synthetic lake's records, as reader.py builds them, and its true course."""
    w = WORLDS[world]
    acres = math.exp(rng.uniform(math.log(100), math.log(5000)))
    k0 = K * math.exp(rng.gauss(0, w["k_spread"])) if w["k_spread"] else K
    e = rng.uniform(0.05, 0.6)                   # exploitation; above about 0.3 a lake declines
    speared = rng.random() < 0.4
    x = rng.uniform(1.5, 8.0)
    age0_hist = {}
    rec = {"id": f"L{i:04d}", "acres": acres, "label": {}, "adults": {}, "age0": {}, "harvest": {},
           "creel": set(), "stocked": set(), "seepage": rng.random() < 0.3}
    phase, every = rng.randrange(5), rng.choice((3, 4, 5))
    surveyed_age0 = rng.random() < 0.7
    label, rescued = NATURAL, False
    for yr in YEARS:
        k = k0 * (w["k_after"] if yr > t1n.CUTOFF else 1.0)
        sr = w.get("sigma_r", SIGMA_R)
        r = recruitment(x, w["q"], k) * math.exp(sr * rng.gauss(0, 1) - sr * sr / 2 + SIGMA_R * SIGMA_R / 2)
        age0_hist[yr] = r
        rec["label"][yr] = label
        if (yr - 1990 + phase) % every == 0:
            est = x * math.exp(CV * rng.gauss(0, 1) - CV * CV / 2)
            rec["adults"][yr] = (est, est * math.exp(-1.96 * CV), est * math.exp(1.96 * CV))
        if surveyed_age0 or rng.random() < 0.4:
            seen = x / (x + w["unseen"]) if "unseen" in w else 1.0
            rec["age0"][yr] = round(r * seen * math.exp(0.3 * rng.gauss(0, 1)), 1)
        h = (e if x >= STOCK_BELOW else CUT) * x      # harvest cut where a lake falls, as safe harvests are set
        creel = rng.random() < 0.2
        recorded = (0.6 * h if speared else 0.0) + (0.4 * h if creel else 0.0)
        if recorded:
            rec["harvest"][yr] = recorded
        if creel:
            rec["creel"].add(yr)
        add = 0.0
        if x < STOCK_BELOW and rng.random() < speed:
            if w["unrecorded"] and (rescued or rng.random() < w["unrecorded"]):
                rescued = True                     # stocked, nothing recorded, the label kept
            else:
                rec["stocked"].add(yr)
                label = STOCKED
            add = 1.0
        r3 = age0_hist.get(yr - 3, recruitment(x, w["q"], k))
        joins = w["c_gamma"] * r3 ** w["gamma"] if "gamma" in w else C * r3
        x = max(S * x - h + joins + add + w.get("immigration", 0.0), 0.0)
        if rng.random() < KNOCK:
            x *= 0.1
    return rec


def archive(world, a, speed=0.1):
    rng = random.Random("|".join((SEED, world, str(speed), str(a))))
    return [lake(rng, i, world, speed) for i in range(LAKES)]


def worlds(chk):
    """Each world's verdicts over ARCHIVES synthetic archives at each speed, under branch B."""
    out = {}
    key = "V1 verdicts, of %d archives" % ARCHIVES
    for world in WORLDS:
        out[world] = {}
        for speed in STOCK_SPEEDS:
            tallies, needs_, n_disc, ret = {}, [], [], 0
            for a in range(ARCHIVES):
                lakes = archive(world, a, speed)
                nb = t1n.need_branch_b(lakes)
                needs_.append(nb["need"])
                if nb["need"] is None:
                    tallies["not decided"] = tallies.get("not decided", 0) + 1
                    continue
                res = t1n.read(lakes, {lk["id"]: nb["need"] for lk in lakes})
                v = res["V1"]["verdict"].split(":")[0]
                tallies[v] = tallies.get(v, 0) + 1
                n_disc.append(res["V1"]["resolved"])
                ret += res["V2"]["met"]
            fitted = sorted(y for y in needs_ if y is not None)
            out[world][f"stocking chance {speed} a year"] = {
                key: tallies, "V2 met, archives": ret,
                "the fitted need, median": round(fitted[len(fitted) // 2], 3) if fitted else None,
                "resolved lakes where T1 and the null differ, median":
                    sorted(n_disc)[len(n_disc) // 2] if n_disc else None}
    for speed in STOCK_SPEEDS:
        cell = out["no need"][f"stocking chance {speed} a year"][key]
        chk("worlds", f"no need: never supported, at stocking chance {speed}", cell.get("supported", 0) == 0, cell)
    for speed in (0.03, 0.0):
        cell = out["need"][f"stocking chance {speed} a year"][key]
        chk("worlds", f"the need world supported more often than refuted at stocking chance {speed}",
            cell.get("supported", 0) > cell.get("refuted", 0), cell)
    for speed in (0.1, 0.03, 0.0):
        cell = out["survival compensates"][f"stocking chance {speed} a year"][key]
        chk("worlds", f"a need read at the wrong stage refuted more often than supported at stocking chance {speed}",
            cell.get("refuted", 0) > cell.get("supported", 0), cell)
    return out


def scripted(chk):
    """The rules on scripted lakes: each verdict at its thresholds, the null, the scope and the fate."""
    def lk(i, x, fate_est, h=0.0, label=NATURAL, stocked=(), width=0.1, label_fate=None, age0=None):
        return {"id": f"S{i}", "acres": 100.0, "label": {2013: label, 2017: label_fate or label},
                "adults": {2013: (x, x * (1 - width), x * (1 + width)),
                           2017: (fate_est, fate_est * (1 - width), fate_est * (1 + width))},
                "age0": dict(age0) if age0 is not None else {2010: 0.0, 2011: 0.0, 2012: 0.0},
                "harvest": {2013: h} if h else {}, "creel": set(), "stocked": set(stocked)}
    y = 1.0
    for n in (10, 14, 20):
        k = t1n.critical(n)
        for fell, want in ((k, "supported"), (k - 1, "not decided"),
                           (n // 2, "refuted" if n >= t1n.N_REFUTE else "not decided"),
                           (n - k, "refuted"), (n - k + 1, "refuted" if n >= t1n.N_REFUTE else "not decided")):
            lakes = [lk(i, 0.5, 0.2 if i < fell else 2.0) for i in range(n)]
            v = t1n.read(lakes, {l["id"]: y for l in lakes})["V1"]["verdict"]
            chk("rules: V1", f"{fell} of {n} below the point fell: {want}", v.startswith(want), v)
    lakes = [lk(i, 0.5, 0.2) for i in range(t1n.N_MIN - 1)]
    v = t1n.read(lakes, {l["id"]: y for l in lakes})["V1"]["verdict"]
    chk("rules: V1", "fewer than N_MIN resolved: not decided", v.startswith("not decided"), v)
    lakes = [lk(i, 0.5, 0.2) for i in range(12)] + [lk(100 + i, 0.5, 1.0, width=0.5) for i in range(30)]
    r = t1n.read(lakes, {l["id"]: y for l in lakes})["V1"]
    chk("rules: V1", "unresolved fates are not counted", r["resolved"] == 12 and r["discordant"] == 42, r)
    lakes = [lk(1, 1.5, 0.2, h=1.0), lk(2, 0.8, 0.2, h=1.0)]
    t = t1n.rows(lakes, {l["id"]: y for l in lakes})
    chk("rules: the point", "T1 predicts a fall below the need alone; the point with the draw is reported",
        t[0]["T1 predicts"] == "persists" and t[0]["below the point with the recorded draw"]
        and t[1]["T1 predicts"] == "falls" and all(r["null predicts"] == "persists" for r in t), t)
    for why, l in (("label at the reference", lk(1, 0.5, 0.2, label=STOCKED)),
                   ("stocking recorded before the reference", lk(2, 0.5, 0.2, stocked=(2010,))),
                   ("stocking recorded before the reference", lk(3, 0.5, 0.2, stocked=(2013,)))):
        t = t1n.rows([l], {l["id"]: y})
        chk("rules: the scope", f"out of scope: {why}", t[0].get("out", "").startswith(why), t)
    t = t1n.rows([lk(4, 0.5, 0.2, stocked=(2007,))], {"S4": y})
    chk("rules: the scope", "stocking more than STOCK_BEFORE years before the reference keeps the lake",
        "out" not in t[0], t)
    t = t1n.rows([lk(5, 0.5, 3.0, stocked=(2016,))], {"S5": y})
    chk("rules: the fate", "stocking after the reference with the label kept: unresolved",
        t[0]["fate"] == "unresolved" and "stocking" in t[0]["fate by"], t)
    t = t1n.rows([lk(6, 0.5, 3.0, label_fate=STOCKED, stocked=(2016,))], {"S6": y})
    chk("rules: the fate", "the label leaving natural recruitment: fell, whatever the estimate",
        t[0]["fate"] == "fell" and "label" in t[0]["fate by"], t)
    t = t1n.rows([lk(7, 0.5, 1.0, width=0.5)], {"S7": y})
    chk("rules: the fate", "an interval holding the need: unresolved", t[0]["fate"] == "unresolved", t)
    t = t1n.rows([lk(8, 0.5, 0.2, age0={2011: 3.0})], {"S8": y})
    chk("rules: renewal pending", "a fall predicted with age-0 at or above the floor before it: read, marked pending",
        "out" not in t[0] and t[0]["pending at the reference"].startswith("renewal pending"), t)
    t = t1n.rows([lk(9, 0.5, 0.2, age0={})], {"S9": y})
    chk("rules: renewal pending", "a fall predicted with no age-0 survey before it: read, marked unread",
        "out" not in t[0] and t[0]["pending at the reference"].startswith("renewal unread"), t)
    v = t1n.read([lk(12, 0.2, 3.0, age0={2011: 3.0})], {"S12": y})["V2"]
    chk("rules: V2", "a return with renewal pending is not the single-lake form", not v["met"], v)
    two = {"id": "S11", "acres": 100.0, "label": {2013: NATURAL, 2015: NATURAL, 2019: NATURAL},
           "adults": {2013: (3.0, 2.9, 3.1), 2015: (0.5, 0.45, 0.55), 2019: (0.2, 0.18, 0.22)},
           "age0": {2012: 0.0, 2013: 0.0, 2014: 0.0}, "harvest": {}, "creel": set(), "stocked": set()}
    t = t1n.rows([two], {"S11": y})
    chk("rules: the reference", "the first estimate at which T1 predicts a fall is the reference",
        t[0]["ref"] == 2015 and t[0]["fate year"] == 2019 and t[0]["T1 predicts"] == "falls", t)
    v = t1n.read([lk(1, 0.5, 3.0)], {"S1": y})["V2"]
    chk("rules: V2", "a lake below its need returning above it with no stocking is the single-lake form",
        v["met"] and v["lakes"] == ["S1"], v)
    v = t1n.read([lk(1, 0.95, 3.0, width=0.2)], {"S1": y})["V2"]
    chk("rules: V2", "a reference whose interval reaches the need is not below it", not v["met"], v)
    chk("rules: the tail", "critical counts", (t1n.critical(10), t1n.critical(14), t1n.critical(20)) == (9, 11, 15))


def branch_a(chk):
    """Branch A's need on synthetic published curves: the bisection meets the floor."""
    for form, p in (("bh-q", {"alpha": A / K ** 3, "beta": 1 / K ** 3, "q": 3}),
                    ("ricker-q", {"alpha": 20.0, "beta": 0.3, "q": 2.5})):
        y = t1n.need_branch_a(form, p)
        f = t1n.CURVES[form]
        chk("rules: branch A", f"the curve reaches the floor at the need: {form}",
            y is not None and abs(f(y, p) - t1n.FLOOR) < 1e-6, (y, f(y, p) if y else None))
    chk("rules: branch A", "a curve below the floor everywhere gives no need",
        t1n.need_branch_a("bh-q", {"alpha": 1e-6, "beta": 1.0, "q": 3}) is None)


def branch_b(chk):
    """Branch B's fit on synthetic pairs with a known need, and its refusals."""
    rng = random.Random(SEED + "|fit")
    lakes = []
    for i in range(60):
        rec = {"id": f"F{i}", "adults": {}, "age0": {}}
        for yr in range(1995, 2013):
            x = math.exp(rng.uniform(math.log(0.1), math.log(8)))
            rec["adults"][yr] = (x, x, x)
            rec["age0"][yr] = 5.0 if rng.random() < 1 / (1 + (0.8 / x) ** 4) else 0.0
        lakes.append(rec)
    nb = t1n.need_branch_b(lakes)
    chk("rules: branch B", "the fit recovers a known need within 25%", nb["need"] and abs(nb["need"] / 0.8 - 1) < 0.25, nb)
    chk("rules: branch B", "too few pairs: no need", t1n.need_branch_b(lakes[:5])["need"] is None)
    flat = [{"id": f"G{i}", "adults": {y: (1.0 + i % 7, 0, 0) for y in range(1995, 2013)},
             "age0": {y: 5.0 * ((i + y) % 2) for y in range(1995, 2013)}} for i in range(40)]
    chk("rules: branch B", "renewal not rising with the level: no need",
        t1n.need_branch_b(flat)["need"] is None, t1n.need_branch_b(flat))
    later = [dict(l, adults={**l["adults"], 2014: (0.01, 0.01, 0.01)}, age0={**l["age0"], 2014: 99.0})
             for l in lakes]
    chk("rules: branch B", "years after the cutoff do not enter the fit",
        t1n.need_branch_b(later)["need"] == nb["need"])


def reader_checks(chk):
    """The reader on synthetic files in the assumed layout (reader.COLUMNS): it rebuilds the lakes, and
    refuses a file lacking a column."""
    lakes = archive("need", 0)[:20]
    with tempfile.TemporaryDirectory() as tmp:
        reader.write_synthetic(lakes, Path(tmp))
        back = reader.read_all(Path(tmp))
        same = all(abs(back[l["id"]]["adults"][y][0] - l["adults"][y][0]) < 1e-6
                   and back[l["id"]]["label"].get(y) == l["label"].get(y)
                   for l in lakes for y in l["adults"])
        chk("the reader", "rebuilds the lakes from the assumed layout", same and len(back) == 20)
        chk("the reader", "keeps stocking, creel years and age-0 surveys",
            all(back[l["id"]]["stocked"] == l["stocked"] and back[l["id"]]["creel"] == l["creel"]
                and set(back[l["id"]]["age0"]) == set(l["age0"]) for l in lakes))
        p = Path(tmp) / reader.FILES["adults"]
        text = p.read_text().split("\n")
        p.write_text("\n".join([text[0].replace(reader.COLUMNS["adults"]["estimate"], "something else")] + text[1:]))
        try:
            reader.read_all(Path(tmp))
            refused = False
        except SystemExit:
            refused = True
        chk("the reader", "refuses a file lacking a column it reads", refused)
        probe = reader.layout(Path(tmp))
        chk("the reader", "the layout probe gives headers and counts, no value",
            all(set(v) == {"columns", "rows"} for v in probe.values()), probe)


def run_checks(chk):
    """run.py end to end on synthetic files: under branch B, then with a curves file settling branch A; the
    layout facts from structural columns only; and the run refusing before the freeze."""
    lakes = archive("need", 0, 0.03)
    with tempfile.TemporaryDirectory() as tmp:
        reader.write_synthetic(lakes, Path(tmp))
        facts = reader.layout_facts(Path(tmp))
        chk("the run", "layout facts: the window, the pairs and the candidates, from structure alone",
            facts["last estimate year"] == 2025 and facts["reference window"] == [2013, 2022]
            and facts["pairs up to the cutoff"] > t1n.PAIRS_MIN and facts["curves"] is None, facts)
        out = RUN.run(Path(tmp), check_frozen=False)
        mine = t1n.read(lakes, {l["id"]: t1n.need_branch_b(lakes)["need"] for l in lakes}, 2013, 2022)
        chk("the run", "branch B decides where no curves file is given, and V1 is the rules' own",
            out["branch deciding V1"] == "B" and out["V1"] == mine["V1"], (out["V1"], mine["V1"]))
        chk("the run", "the floors 0, 1 and 5 and the seepage lakes are reported",
            set(out["branch B"]) == {f"floor {f}" for f in t1n.FLOORS_REPORTED}
            and "seepage lakes alone (reported)" in out["branch B"]["floor 1.0"], sorted(out["branch B"]))
        cols = reader.COLUMNS["curves"]
        with (Path(tmp) / reader.FILES["curves"]).open("w", newline="") as f:
            wr = csv.DictWriter(f, fieldnames=list(cols.values()))
            wr.writeheader()
            for lk in lakes[:t1n.BRANCH_A_LAKES]:
                wr.writerow({cols["lake"]: lk["id"], cols["form"]: "bh-q", cols["alpha"]: A / K ** 3,
                             cols["beta"]: 1 / K ** 3, cols["q"]: 3, cols["last year"]: 2015})
        out = RUN.run(Path(tmp), check_frozen=False)
        chk("the run", "a curves file for BRANCH_A_LAKES lakes settles branch A, its references after 2015",
            out["branch deciding V1"] == "A" and out["branch A"]["floor 1.0"]["references from"] == 2016
            and all(r.get("ref", 2016) >= 2016 for r in out["rows"]), out["branch deciding V1"])
    try:
        RUN.frozen()
        refused = False
    except SystemExit:
        refused = True
    chk("the run", "the run refuses while the freeze is not written", refused)


def main():
    t0 = time.process_time()
    code = code_hashes()
    chk = Checks()
    scripted(chk)
    branch_a(chk)
    branch_b(chk)
    reader_checks(chk)
    run_checks(chk)
    out = {"worlds (branch B), %d lakes an archive" % LAKES: worlds(chk)}
    out.update({"checks": sum(chk.by_kind.values()), "checks by kind": chk.by_kind, "failed": chk.failed,
                "CPU seconds": round(time.process_time() - t0, 1),
                "code hashes": code, "code unchanged during the run": code_hashes() == code})
    path = HERE / "results" / "dry-run.json"
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(out, indent=1) + "\n")
    print("checks:", out["checks"], "failed:", len(chk.failed), "CPU seconds:", out["CPU seconds"],
          "code unchanged:", out["code unchanged during the run"])
    for f in chk.failed[:8]:
        print("  FAILED", f["kind"], "|", f["check"], str(f["detail"])[:200])


if __name__ == "__main__":
    main()
