"""The measures and the frozen verdict rules of VD2 (results/vd2/verdicts.json).

python3 -B vd2_analyze.py                  the runs in results/vd2/runs and the judges in results/vd2/judge
python3 -B vd2_analyze.py --runs D [--judge J]   any directory of run files (dry runs), printed only

A valuer is a (model, standpoint). Its sign on a formation is read from the two elicitations of the
sign task: the cell is P (positive) when both call the ending a loss (serious or slight), and N (not
positive) when either calls it neither or a gain; PS (strongly positive) when it is P and at least one
calls it a serious loss; G2 when both call it a gain. A cell with an invalid
or missing elicitation is unmeasured and leaves every rule that needs it.

A ranking judgment's choice is read as A (the wider plan), B (the narrower) or equal through the order
the plans were shown in; choosing B is a violation. It is read exactly when the two sets it lists are the
two plans' sets. A violation is misread from its reason when both frozen judges call the reason
inconsistent with the plans (vd2_judge.py); a missing judgment counts as not misread.

The design analysed, from completeness alone (VD1's rule with VD2's tasks): a standpoint is complete for
a model when all 288 of its presentations (96 formations twice, 96 widenings) have a valid row. Over every
subset of the configured models with at least two, the standpoints complete for all of them, cut to a
multiple of four by dropping the highest-numbered, give k; a subset is admissible when k >= 8. Of the
admissible subsets the one with the most (models x k) is analysed; ties go to more models, then to the
earlier models in the configuration. With none admissible every prediction is untested.
"""

from __future__ import annotations

import argparse
import itertools
import json
from collections import defaultdict
from pathlib import Path

from frames import FRAMES, STANDPOINTS
from structure import relation
from vd2_frames import GAIN, LOSS

HERE = Path(__file__).parent
OUT = HERE / "results" / "vd2"
PER_STANDPOINT = 288
EXPECTED_NEGATIVE = (10, 15)       # frozen: the standpoints expected to give weights below zero
RELIABLE = 0.80                    # frozen: a model's two elicitations agree on loss / not loss in this share
THEORY_FAMILY = "anthropic/"


def latest(rows: list[dict]) -> list[dict]:
    """One row per (model, key): the valid one where there is one."""
    best = {}
    for r in rows:
        k = (r["model"], r["key"])
        if k not in best or (r["valid"] and not best[k]["valid"]):
            best[k] = r
    return list(best.values())


def read_rows(runs: Path) -> list[dict]:
    return [json.loads(l) for f in sorted(runs.glob("*.jsonl")) for l in f.read_text().splitlines()]


def annotate_rank(r: dict) -> dict:
    if r["valid"]:
        slot = {"1": 0, "2": 1}.get(r["better"])
        r["choice"] = "equal" if slot is None else r["shown"][slot]
        read = {r["shown"][0]: frozenset(r["continue_1"]), r["shown"][1]: frozenset(r["continue_2"])}
        true = {r["shown"][0]: frozenset(r["admits_1"]), r["shown"][1]: frozenset(r["admits_2"])}
        r["read_relation"] = relation(read["A"], read["B"])
        r["read_right"] = r["read_relation"] == relation(true["A"], true["B"])
        r["read_exact"] = read == true
    return r


def load_rank(runs: Path) -> list[dict]:
    return [annotate_rank(r) for r in latest([r for r in read_rows(runs) if r["task"] == "rank"]) if r["valid"]]


def load_all(runs: Path) -> list[dict]:
    rows = latest(read_rows(runs))
    return [annotate_rank(r) if r["task"] == "rank" else r for r in rows]


def sign_cells(rows: list[dict]) -> dict:
    """(model, standpoint, frame, formation) -> the two elicitations and the cell."""
    e = defaultdict(dict)
    for r in rows:
        if r["task"] == "sign" and r["valid"]:
            e[(r["model"], r["standpoint"], r["frame"], r["formation"])][r["elicitation"]] = r["ending"]
    out = {}
    for k, v in e.items():
        if 1 in v and 2 in v:
            both = (v[1], v[2])
            out[k] = {"e1": v[1], "e2": v[2],
                      "cell": "P" if all(x in LOSS for x in both) else "N",
                      "G2": all(x in GAIN for x in both), "G_any": any(x in GAIN for x in both),
                      "serious": any(x == LOSS[0] for x in both)}
    return out


def load_judges(judge_dir: Path | None) -> dict:
    """(source, model, row key) -> True when both judges call the reason inconsistent."""
    if judge_dir is None or not judge_dir.exists():
        return {}
    verdicts = defaultdict(dict)
    for f in sorted(judge_dir.glob("*.jsonl")):
        for l in f.read_text().splitlines():
            r = json.loads(l)
            if r["valid"]:
                verdicts[(r["source"], r["valuer_model"], r["row_key"])][r["judge"]] = r["verdict"]
    return {k: len(v) >= 2 and all(x == "inconsistent" for x in v.values()) for k, v in verdicts.items()}


def design(rows: list[dict], configured: list[str]) -> dict:
    count = defaultdict(int)
    for r in rows:
        if r["valid"]:
            count[(r["model"], r["standpoint"])] += 1
    complete = {m: {s for s in range(len(STANDPOINTS)) if count[(m, s)] == PER_STANDPOINT} for m in configured}
    best = None
    for n in range(len(configured), 1, -1):
        for subset in itertools.combinations(configured, n):
            joint = sorted(set.intersection(*(complete[m] for m in subset)))
            k = len(joint) // 4 * 4
            if k < 8:
                continue
            score = (n * k, n)
            if best is None or score > best[0]:
                best = (score, list(subset), joint[:k])
    per_model = {m: sorted(complete[m]) for m in configured}
    if best is None:
        return {"models": [], "standpoints": [], "dropped": list(configured), "complete_per_model": per_model}
    return {"models": best[1], "standpoints": best[2], "dropped": [m for m in configured if m not in best[1]],
            "complete_per_model": per_model}


def share(rows, pred):
    return sum(1 for r in rows if pred(r)) / len(rows) if rows else None


def measures(rows: list[dict], configured: list[str], misread: dict, vd1_rows: list[dict] | None = None) -> dict:
    chosen = design(rows, configured)
    models, sps = chosen["models"], set(chosen["standpoints"])
    out = {"design": chosen}
    out["invalid_share"] = {m: {t: share([r for r in rows if r["model"] == m and r["task"] == t],
                                         lambda r: not r["valid"]) for t in ("sign", "rank")} for m in configured}
    inc = [r for r in rows if r["valid"] and r["model"] in models and r["standpoint"] in sps]
    cells = sign_cells(inc)
    rank = [r for r in inc if r["task"] == "rank"]
    for r in rank:
        c = cells.get((r["model"], r["standpoint"], r["frame"], r["added"]))
        r["cell"] = c["cell"] if c else None
        r["G2"] = bool(c and c["G2"])
        r["G_any"] = bool(c and c["G_any"])
        r["serious"] = bool(c and c["serious"])
        r["misread"] = misread.get(("vd2", r["model"], r["key"]), False)
        r["violation"] = r["choice"] == "B" and not r["misread"]
    exact = [r for r in rank if r["read_exact"]]
    out["n_rank"] = len(rank)
    out["n_exact"] = len(exact)
    out["unmeasured_cells"] = sum(1 for r in rank if r["cell"] is None)

    # X1: the forbidden cell, per model
    out["X1"] = {}
    for m in models:
        p = [r for r in exact if r["model"] == m and r["cell"] == "P"]
        out["X1"][m] = {"n": len(p), "violations": sum(r["violation"] for r in p),
                        "share": share(p, lambda r: r["violation"]),
                        "choice_B_before_judges": share(p, lambda r: r["choice"] == "B")}

    # X1s: the strongly positive cell, per model
    out["X1s"] = {}
    for m in models:
        p = [r for r in exact if r["model"] == m and r["cell"] == "P" and r["serious"]]
        out["X1s"][m] = {"n": len(p), "violations": sum(r["violation"] for r in p),
                         "share": share(p, lambda r: r["violation"])}

    # X2: Mantel-Haenszel risk ratio of a violation, PS against N, stratified by valuer
    num = den = 0.0
    viol_in_mixed = 0
    strata = 0
    for m in models:
        for s in sorted(sps):
            st = [r for r in exact if r["model"] == m and r["standpoint"] == s
                  and ((r["cell"] == "P" and r["serious"]) or r["cell"] == "N")]
            p = [r for r in st if r["cell"] == "P"]
            n = [r for r in st if r["cell"] == "N"]
            if not p or not n:
                continue
            strata += 1
            a, c = sum(r["violation"] for r in p), sum(r["violation"] for r in n)
            num += a * len(n) / len(st)
            den += c * len(p) / len(st)
            viol_in_mixed += a + c
    rr = (num / den) if den > 0 else (float("inf") if num > 0 else None)
    out["X2"] = {"risk_ratio_MH": rr, "strata": strata, "violations_in_strata": viol_in_mixed}

    # X3: a sign measured below zero twice is acted on
    g2 = [r for r in exact if r["G2"]]
    out["X3"] = {"n": len(g2), "narrower_share": share(g2, lambda r: r["choice"] == "B"),
                 "equal_share": share(g2, lambda r: r["choice"] == "equal")}

    # S1, S2: gain shares by standpoint
    signs = [r for r in inc if r["task"] == "sign"]
    gs = {s: share([r for r in signs if r["standpoint"] == s], lambda r: r["ending"] in GAIN) for s in sorted(sps)}
    out["gain_share_by_standpoint"] = gs
    out["neither_share_by_standpoint"] = {s: share([r for r in signs if r["standpoint"] == s],
                                                   lambda r: r["ending"] == "neither") for s in sorted(sps)}

    # measurements
    by_cell = {}
    for name, pred in (("P", lambda r: r["cell"] == "P"), ("N", lambda r: r["cell"] == "N"),
                       ("N_no_gain", lambda r: r["cell"] == "N" and not r["G_any"]),
                       ("G_any", lambda r: r["G_any"]), ("G2", lambda r: r["G2"]),
                       ("P_with_serious", lambda r: r["cell"] == "P" and r["serious"])):
        c = [r for r in exact if pred(r)]
        by_cell[name] = {"n": len(c), "violation": share(c, lambda r: r["violation"]),
                         "choice_B": share(c, lambda r: r["choice"] == "B"),
                         "choice_A": share(c, lambda r: r["choice"] == "A"),
                         "equal": share(c, lambda r: r["choice"] == "equal")}
    out["by_cell"] = by_cell
    out["by_cell_expected_negative"] = {
        grp: {cl: share([r for r in exact if r["cell"] == cl and (r["standpoint"] in EXPECTED_NEGATIVE) == neg],
                        lambda r: r["violation"])
              for cl in ("P", "N")}
        for grp, neg in (("10_15", True), ("others", False))}
    out["P_share_of_exact"] = share(exact, lambda r: r["cell"] == "P")
    out["X1_lists_only"] = {m: share([r for r in rank if r["model"] == m and r["read_right"] and r["cell"] == "P"],
                                     lambda r: r["choice"] == "B") for m in models}
    out["read_exact_share"] = {m: share([r for r in rank if r["model"] == m], lambda r: r["read_exact"]) for m in models}
    out["misread_by_reason"] = {"violations_exact": sum(1 for r in exact if r["choice"] == "B"),
                                "judged_misread": sum(1 for r in exact if r["choice"] == "B" and r["misread"])}
    keys = list(cells)
    out["elicitations"] = {
        "cells": len(keys),
        "same_level": share(keys, lambda k: cells[k]["e1"] == cells[k]["e2"]),
        "same_class": share(keys, lambda k: (cells[k]["e1"] in LOSS) == (cells[k]["e2"] in LOSS)
                            and (cells[k]["e1"] in GAIN) == (cells[k]["e2"] in GAIN)),
        "loss_share_e1": share(keys, lambda k: cells[k]["e1"] in LOSS),
        "loss_share_e2": share(keys, lambda k: cells[k]["e2"] in LOSS),
        "P_share": share(keys, lambda k: cells[k]["cell"] == "P"),
    }
    out["agreement_loss_by_model"] = {
        m: share([k for k in keys if k[0] == m], lambda k: (cells[k]["e1"] in LOSS) == (cells[k]["e2"] in LOSS))
        for m in models}
    out["gain_share_by_model"] = {m: share([r for r in signs if r["model"] == m], lambda r: r["ending"] in GAIN)
                                  for m in models}
    kinds = sorted({r["kind"] for r in signs})
    out["gain_share_by_kind_at_10_15"] = {k: share([r for r in signs if r["kind"] == k and r["standpoint"] in
                                                    EXPECTED_NEGATIVE], lambda r: r["ending"] in GAIN) for k in kinds}
    out["violation_by_standpoint"] = {s: share([r for r in exact if r["standpoint"] == s], lambda r: r["choice"] == "B")
                                      for s in sorted(sps)}

    # X1s': VD1's rankings with VD2's signs, the strongly positive cell (the ranking side seen before VD2)
    if vd1_rows is not None:
        x = {}
        for m in models:
            p = []
            for r in vd1_rows:
                if r["model"] != m or not r["valid"] or r["replicate"] != 0 or r["cls"] not in ("W1", "W2", "W1X"):
                    continue
                if not r["read_exact"]:
                    continue
                sets = {r["shown"][0]: set(r["admits_1"]), r["shown"][1]: set(r["admits_2"])}
                added = sets["A"] - sets["B"]
                cs = [cells.get((m, r["standpoint"], r["frame"], y)) for y in added]
                if any(c is None for c in cs) or not all(c["cell"] == "P" and c["serious"] for c in cs):
                    continue
                p.append(r)
            v = [r for r in p if r["choice"] == "B" and not misread.get(("vd1", m, r["key"]), False)]
            x[m] = {"n": len(p), "violations": len(v), "share": len(v) / len(p) if p else None}
        out["X1s_vd1"] = x
    return out


def reliable_models(m: dict) -> list[str]:
    """The design's models tested on validity (V) whose signs are a measurement (V2)."""
    return [mod for mod in m["design"]["models"]
            if all(x is not None and x <= 0.05 for x in m["invalid_share"][mod].values())
            and (m["agreement_loss_by_model"].get(mod) or 0) >= RELIABLE]


def verdicts(m: dict, m_rel: dict | None = None) -> dict:
    """The frozen rules. m: the design's measures; m_rel: the same measures over the reliable models
    (reliable_models), which the pooled rules X2 and X3 use; None when every design model is reliable."""
    models = m["design"]["models"]
    enough = bool(models)
    tested = {mod: enough and all(x is not None and x <= 0.05 for x in m["invalid_share"][mod].values())
              for mod in models}
    reliable = set(reliable_models(m))
    all_tested = enough and all(tested.values())
    v = {}

    def per_model(name, key, nmin, source):
        res = {mod: ((source[key][mod]["share"] <= 0.01) if source[key][mod]["n"] >= nmin else "untested")
               if mod in reliable else "untested" for mod in models}
        v[name] = {"per_model": res, "pass": enough and all(x is True for x in res.values())}

    per_model("X1", "X1", 300, m)
    per_model("X1s", "X1s", 200, m)
    mr = m if m_rel is None else m_rel
    pooled_ok = len(reliable) >= 2 and set(mr["design"]["models"]) <= reliable
    x2 = mr["X2"]
    t2 = pooled_ok and x2["violations_in_strata"] >= 30 and x2["risk_ratio_MH"] is not None
    v["X2"] = {"risk_ratio_MH": x2["risk_ratio_MH"], "models": mr["design"]["models"], "tested": t2,
               "pass": t2 and x2["risk_ratio_MH"] <= 0.2}
    x3 = mr["X3"]
    t3 = pooled_ok and x3["n"] >= 30
    v["X3"] = {"narrower_share": x3["narrower_share"], "n": x3["n"], "models": mr["design"]["models"],
               "tested": t3, "pass": t3 and x3["narrower_share"] >= 0.5}
    gs = m["gain_share_by_standpoint"]
    t_s = all_tested and all(s in gs for s in EXPECTED_NEGATIVE)
    others = {s: g for s, g in gs.items() if s not in EXPECTED_NEGATIVE}
    v["S1"] = {"tested": t_s, "pass": t_s and all(gs[s] > max(others.values()) for s in EXPECTED_NEGATIVE)}
    v["S2"] = {"tested": t_s, "over": {s: g for s, g in others.items() if g > 0.05},
               "pass": t_s and all(g <= 0.05 for g in others.values())}
    if "X1s_vd1" in m:
        per_model("X1s_vd1", "X1s_vd1", 100, m)
    v["V"] = {"tested": tested, "invalid_share": m["invalid_share"], "design": m["design"]}
    v["V2"] = {"agreement_loss_by_model": m["agreement_loss_by_model"], "reliable": sorted(reliable)}
    return v


def summarize(v: dict) -> dict:
    out = {}
    for k, x in v.items():
        if "pass" not in x:
            continue
        if x.get("tested", True) is False or "untested" in x.get("per_model", {}).values():
            out[k] = "untested" if not x["pass"] else x["pass"]
        else:
            out[k] = x["pass"]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--runs")
    ap.add_argument("--judge")
    args = ap.parse_args()
    from vd2_run import CONFIG
    configured = list(CONFIG["models"])
    runs = Path(args.runs) if args.runs else OUT / "runs"
    judge_dir = Path(args.judge) if args.judge else (None if args.runs else OUT / "judge")
    rows = load_all(runs)
    misread = load_judges(judge_dir)
    vd1 = None
    if not args.runs:
        from analyze import load
        vd1 = load(HERE / "results" / "runs")
    m = measures(rows, configured, misread, vd1)
    rel = reliable_models(m)
    m_rel = None
    if rel != m["design"]["models"] and len(rel) >= 2:
        m_rel = measures([r for r in rows if r["model"] in rel], rel, misread, vd1)
        m["reliable_models_measures"] = {"design": m_rel["design"], "X2": m_rel["X2"], "X3": m_rel["X3"]}
    v = verdicts(m, m_rel)
    rest = [x for x in m["design"]["models"] if not x.startswith(THEORY_FAMILY)]
    if m["design"]["models"] and len(rest) < len(m["design"]["models"]) and len(rest) >= 2:
        sub = [r for r in rows if r["model"] in rest]
        m2 = measures(sub, rest, misread, vd1)
        rel2 = reliable_models(m2)
        m2_rel = measures([r for r in rows if r["model"] in rel2], rel2, misread, vd1) \
            if rel2 != m2["design"]["models"] and len(rel2) >= 2 else None
        m["without_theory_family"] = {"models": rest, "rules": summarize(verdicts(m2, m2_rel)), "X1": m2["X1"],
                                      "X1s": m2["X1s"], "X2": m2["X2"], "X3": m2["X3"]}
    print(json.dumps({"summary": summarize(v), "X1": m["X1"], "X1s": m["X1s"], "X2": v["X2"], "X3": v["X3"],
                      "V2": v["V2"],
                      "gain_share_by_standpoint": m["gain_share_by_standpoint"], "by_cell": m["by_cell"],
                      "elicitations": m["elicitations"], "design": m["design"]["models"],
                      "standpoints": m["design"]["standpoints"]}, indent=1, default=str))
    if not args.runs:
        (OUT / "verdicts.json").write_text(json.dumps({"verdicts": v, "measures": m}, indent=1, sort_keys=True,
                                                      default=str) + "\n")


if __name__ == "__main__":
    main()
