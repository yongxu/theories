"""The measures and the frozen verdict rules of VD1 (results/verdicts.json).

python3 analyze.py            the runs in results/runs, verdicts to results/verdicts.json
python3 analyze.py --runs D   any directory of run files (dry runs), printed only

A judgment's choice is read as A, B or equal through the order the plans were shown in. In a
widening pair (W1, W2, W1X) A widens B: choosing B is a violation. A judgment's reading is
the pair of sets it listed; its read relation is computed from them as structure.relation does.
D, the disagreement of a pair, is the share of its judgments on the minority strict side,
min(#A, #B) / n, n counting every valid judgment of the pair, "equal" included: a valuer who
calls the plans equal neither agrees nor disagrees strictly, and many "equal" answers cannot
inflate D.
Pooled measures take every valid judgment of the main design (replicate 0) of every model.

The reduced design (addendum of 21 October 2026, decided before any call). A standpoint is complete
when every model has a valid main-design judgment of each of its 112 pairs. The analysis uses the
complete standpoints, cut to a multiple of four by dropping the highest-numbered (order and framing
are balanced within each block of four), and none other. The run goes in standpoint order, so a run a
limit stops leaves a prefix of complete standpoints.

The design analysed (second addendum, decided before any call, from completeness alone, never from a
judgment's content). Over every subset of the configured models with at least two models, the
standpoints complete for all of them, cut to a multiple of four, give k standpoints. A subset is
admissible when k >= MIN_STANDPOINTS and (models x k) >= MIN_JUDGMENTS, the judgments each pair's D
rests on. Of the admissible subsets the one with the most judgments per pair is analysed; ties go to
more models, then to the earlier models in the configuration. A configured model left out is reported
as not in the design, its rows kept as measurements. With no admissible subset every prediction is
untested.
"""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from pathlib import Path

from frames import CLASSES, FRAMES, STANDPOINTS
from structure import relation

HERE = Path(__file__).parent
MIN_STANDPOINTS = 8
MIN_JUDGMENTS = 24
THEORY_FAMILY = "anthropic/"   # the family of the models that built the theory (a measurement leaves it out)
WIDEN = ("W1", "W2", "W1X")
MIXED = ("M0", "M1", "M2")


def load(runs: Path) -> list[dict]:
    rows = {}
    for f in sorted(runs.glob("*.jsonl")):
        for line in f.read_text().splitlines():
            r = json.loads(line)
            k = (r["model"], r["key"])
            if k not in rows or (r["valid"] and not rows[k]["valid"]):
                rows[k] = r
    out = []
    for r in rows.values():
        if r["valid"]:
            slot = {"1": 0, "2": 1}.get(r["better"])
            r["choice"] = "equal" if slot is None else r["shown"][slot]
            read = {r["shown"][0]: frozenset(r["continue_1"]), r["shown"][1]: frozenset(r["continue_2"])}
            true = {r["shown"][0]: frozenset(r["admits_1"]), r["shown"][1]: frozenset(r["admits_2"])}
            r["read_relation"] = relation(read["A"], read["B"])
            r["true_relation"] = relation(true["A"], true["B"])
            r["read_right"] = r["read_relation"] == r["true_relation"]
            r["read_exact"] = read == true
        out.append(r)
    return out


def disagreement(rows: list[dict]) -> float:
    a = sum(r["choice"] == "A" for r in rows)
    b = sum(r["choice"] == "B" for r in rows)
    return min(a, b) / len(rows) if rows else 0.0


def by_pair(rows: list[dict]) -> dict:
    out = defaultdict(list)
    for r in rows:
        out[(r["frame"], r["cls"])].append(r)
    return out


def design(rows: list[dict], configured: list[str]) -> dict:
    """The models and standpoints analysed, from completeness alone (see the module's docstring)."""
    import itertools
    n_pairs = len(FRAMES) * len(CLASSES)
    count = defaultdict(int)
    for r in rows:
        if r["valid"] and r["replicate"] == 0:
            count[(r["model"], r["standpoint"])] += 1
    complete = {m: {s for s in range(len(STANDPOINTS)) if count[(m, s)] == n_pairs} for m in configured}
    best = None
    for n in range(len(configured), 1, -1):
        for subset in itertools.combinations(configured, n):
            joint = sorted(set.intersection(*(complete[m] for m in subset)))
            k = len(joint) // 4 * 4
            if k < MIN_STANDPOINTS or n * k < MIN_JUDGMENTS:
                continue
            score = (n * k, n)
            if best is None or score > best[0]:
                best = (score, list(subset), joint[:k])
    per_model = {m: sorted(complete[m]) for m in configured}
    if best is None:
        return {"models": [], "standpoints": [], "dropped": list(configured), "complete_per_model": per_model}
    return {"models": best[1], "standpoints": best[2], "dropped": [m for m in configured if m not in best[1]],
            "complete_per_model": per_model}


def measures(rows: list[dict], expected: list[str] | None = None) -> dict:
    configured = list(expected) if expected else sorted({r["model"] for r in rows})
    chosen = design(rows, configured)
    models = chosen["models"] or configured
    included = chosen["standpoints"]
    valid = [r for r in rows if r["valid"]]
    main = [r for r in valid if r["replicate"] == 0 and r["model"] in models and r["standpoint"] in included]
    rows = [r for r in rows if r["model"] in models]
    out = {"models": models, "n_rows": len(rows), "n_valid": len(valid), "design": chosen,
           "standpoints_included": included}
    out["invalid_share"] = {m: sum(1 for r in rows if r["model"] == m and not r["valid"]) /
                            max(1, sum(1 for r in rows if r["model"] == m)) for m in models}
    out["n_main"] = {m: sum(1 for r in main if r["model"] == m) for m in models}

    # per model: violations on W1 and W2, per standpoint, and among right readings
    per_model = {}
    for m in models:
        mm = [r for r in main if r["model"] == m]
        w12 = [r for r in mm if r["cls"] in ("W1", "W2")]
        per_sp = defaultdict(int)
        for r in w12:
            per_sp[r["standpoint"]] += r["choice"] == "B"
        wr = [r for r in mm if r["cls"] in WIDEN and r["read_right"]]
        per_model[m] = {
            "W12_n": len(w12),
            "W12_violation_share": sum(r["choice"] == "B" for r in w12) / max(1, len(w12)),
            "W12_wider_share": sum(r["choice"] == "A" for r in w12) / max(1, len(w12)),
            "W12_equal_share": sum(r["choice"] == "equal" for r in w12) / max(1, len(w12)),
            "violations_per_standpoint": {str(s): per_sp[s] for s in included},
            "standpoints_over_2": sum(1 for s in included if per_sp[s] > 2),
            "W_read_right_n": len(wr),
            "W_read_right_violation_share": sum(r["choice"] == "B" for r in wr) / max(1, len(wr)),
            "W1X_violation_share": sum(r["choice"] == "B" for r in mm if r["cls"] == "W1X") /
                                   max(1, sum(1 for r in mm if r["cls"] == "W1X")),
            "K_equal_share": sum(r["choice"] == "equal" for r in mm if r["cls"] == "K") /
                             max(1, sum(1 for r in mm if r["cls"] == "K")),
            "read_right_share_by_class": {c: sum(r["read_right"] for r in mm if r["cls"] == c) /
                                          max(1, sum(1 for r in mm if r["cls"] == c)) for c in CLASSES},
            "D_by_class": {c: mean([disagreement(v) for (f, k), v in by_pair(mm).items() if k == c])
                           for c in CLASSES},
        }
    out["per_model"] = per_model

    # pooled, per pair
    pairs = by_pair(main)
    pairs_right = by_pair([r for r in main if r["read_right"]])
    frames = [f["id"] for f in FRAMES]
    D = {c: {f: disagreement(pairs.get((f, c), [])) for f in frames} for c in CLASSES}
    Dr = {c: {f: disagreement(pairs_right.get((f, c), [])) for f in frames} for c in CLASSES}
    out["D"] = D
    out["D_read_right"] = Dr
    out["D_mean"] = {c: mean(list(D[c].values())) for c in CLASSES}
    out["D_read_right_mean"] = {c: mean(list(Dr[c].values())) for c in CLASSES}
    share = lambda c, ch: sum(r["choice"] == ch for r in main if r["cls"] == c) / max(1, sum(
        1 for r in main if r["cls"] == c))
    out["choice_shares"] = {c: {ch: share(c, ch) for ch in ("A", "B", "equal")} for c in CLASSES}
    out["plan1_share_K_M0"] = {c: sum(r["better"] == "1" for r in main if r["cls"] == c) / max(1, sum(
        1 for r in main if r["cls"] == c)) for c in ("K", "M0")}

    # replicates: within-standpoint flips against the main run, M0 and M1
    rep = {(r["model"], r["frame"], r["cls"], r["standpoint"]): r for r in valid
           if r["replicate"] == 1 and r["standpoint"] in included and r["model"] in models}
    flips, n = 0, 0
    for r in main:
        k = (r["model"], r["frame"], r["cls"], r["standpoint"])
        if k in rep:
            n += 1
            flips += rep[k]["choice"] != r["choice"]
    out["replicate_pairs"] = n
    out["replicate_flip_share"] = flips / max(1, n)

    # the grid's minority share against observed D on mixed pairs (a measurement)
    grid = json.loads((HERE / "results" / "structure.json").read_text())
    g = {(p["frame"], p["cls"]): min(p["grid_139"]["A"], p["grid_139"]["B"]) /
         max(1e-9, p["grid_139"]["A"] + p["grid_139"]["B"]) for p in grid["pairs"]}
    xs = [(g[(f, c)], D[c][f]) for c in MIXED for f in frames]
    out["spearman_grid_vs_D_mixed"] = spearman(xs)
    return out


def mean(xs: list[float]) -> float:
    return sum(xs) / len(xs) if xs else 0.0


def spearman(pairs: list[tuple[float, float]]) -> float:
    def ranks(v):
        order = sorted(range(len(v)), key=lambda i: v[i])
        r = [0.0] * len(v)
        i = 0
        while i < len(order):
            j = i
            while j + 1 < len(order) and v[order[j + 1]] == v[order[i]]:
                j += 1
            for k in range(i, j + 1):
                r[order[k]] = (i + j) / 2
            i = j + 1
        return r
    if len(pairs) < 3:
        return 0.0
    a, b = ranks([p[0] for p in pairs]), ranks([p[1] for p in pairs])
    ma, mb = mean(a), mean(b)
    num = sum((x - ma) * (y - mb) for x, y in zip(a, b))
    den = (sum((x - ma) ** 2 for x in a) * sum((y - mb) ** 2 for y in b)) ** 0.5
    return num / den if den else 0.0


def verdicts(m: dict) -> dict:
    enough = bool(m["design"]["models"])
    tested = {mod: enough and m["invalid_share"][mod] <= 0.05 for mod in m["models"]}
    all_tested = all(tested.values())
    pm = m["per_model"]
    v = {}

    def per_model_rule(name, ok_of):
        res = {mod: (ok_of(pm[mod]) if tested[mod] else "untested") for mod in m["models"]}
        v[name] = {"per_model": res, "pass": all(x is True for x in res.values())}

    per_model_rule("A1", lambda p: p["W12_violation_share"] <= 0.03)
    per_model_rule("A2", lambda p: p["standpoints_over_2"] <= 1)
    per_model_rule("R1", lambda p: (p["W_read_right_violation_share"] <= 0.01) if p["W_read_right_n"] >= 100
                   else "untested")

    D, Dr = m["D"], m["D_read_right"]
    frames = list(D["W1"].keys())

    def locus(DD, hi, lo, diff, wins):
        d = mean([DD[hi][f] - DD[lo][f] for f in frames])
        k = sum(DD[hi][f] > DD[lo][f] for f in frames)
        return {"mean_difference": d, "frames_higher": k, "tested": all_tested,
                "pass": all_tested and d >= diff and k >= wins}

    v["L1"] = locus(D, "M1", "W1", 0.10, 12)
    v["L2"] = locus(D, "M2", "W1", 0.05, 10)
    mixed_hi = sum(D[c][f] >= 0.10 for c in MIXED for f in frames)
    widen_hi = sum(D[c][f] >= 0.10 for c in ("W1", "W2") for f in frames)
    v["L3"] = {"mixed_pairs_D_ge_0.10": mixed_hi, "widening_pairs_D_ge_0.10": widen_hi,
               "tested": all_tested, "pass": all_tested and mixed_hi >= 24 and widen_hi <= 1}
    v["L4"] = locus(Dr, "M1", "W1", 0.10, 12)
    keq = m["choice_shares"]["K"]["equal"]
    v["K1"] = {"K_equal_share": keq, "tested": all_tested, "pass": all_tested and keq >= 0.70}
    v["V"] = {"tested": tested, "invalid_share": m["invalid_share"],
              "standpoints_included": m["standpoints_included"], "enough_standpoints": enough}
    return v


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--runs")
    ap.add_argument("--models", nargs="*", help="with --runs: the models the design expects")
    args = ap.parse_args()
    runs = Path(args.runs) if args.runs else HERE / "results" / "runs"
    expected = None
    if not args.runs:
        from run import CONFIG
        expected = list(CONFIG["models"])
    elif args.models:
        expected = args.models
    rows = load(runs)
    m = measures(rows, expected)
    v = verdicts(m)
    # a measurement, not a verdict: the same rules on the analysed design without the theory's family
    rest = [x for x in m["design"]["models"] if not x.startswith(THEORY_FAMILY)]
    if m["design"]["models"] and len(rest) < len(m["design"]["models"]) and len(rest) >= 2:
        sub = [r for r in rows if r["model"] in rest and r["standpoint"] in m["standpoints_included"]]
        m2 = measures(sub, rest)
        m["without_theory_family"] = {"models": rest, "D_mean": m2["D_mean"],
                                      "rules": {k: x.get("pass") for k, x in verdicts(m2).items() if "pass" in x}}
    summary = {k: (x["pass"] if x.get("tested", True) and "untested" not in x.get("per_model", {}).values()
                   else "untested") for k, x in v.items() if "pass" in x}
    print(json.dumps({"summary": summary, "standpoints_included": m["standpoints_included"], "D_mean": m["D_mean"], "choice_shares": m["choice_shares"],
                      "replicate_flip_share": m["replicate_flip_share"],
                      "spearman_grid_vs_D_mixed": m["spearman_grid_vs_D_mixed"]}, indent=1))
    if not args.runs:
        (HERE / "results" / "verdicts.json").write_text(json.dumps({"verdicts": v, "measures": m}, indent=1,
                                                                    sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
