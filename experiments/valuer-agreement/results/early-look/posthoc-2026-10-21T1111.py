"""Post hoc measures of VD1, computed after the frozen verdicts (results/verdicts.json). Not verdicts.

python3 posthoc.py      writes results/posthoc.json and prints a summary

Every number here was chosen after the verdicts were seen. None changes a verdict; each says where
the failures came from, as the freeze's "What would change the account" asks.

1. Where the violations come from: W1/W2/W1X violations by class, by standpoint, and among right
   readings, in the analysed design (four models) and with standpoint 10 (the urban planner, "letting
   outdated things give way", a standpoint that may weigh a formation below zero) left out.
2. Framing: in K (the same sets, one plan said by what continues, the other by what ends) and W1X
   (a widening cross-framed), the share choosing the plan said by what continues.
3. Counting: in M1 and M2, the share choosing the larger plan, by model and by standpoint.
4. The two models the design rule left out (Qwen: 1 invalid row; Nemotron: 56), on their own valid
   rows, and all six models pooled on every valid row.
5. The reasons of right-read violations in W1 and W2 outside standpoint 10, listed for reading.
"""

from __future__ import annotations

import json
from collections import defaultdict
from pathlib import Path

from analyze import HERE, load, measures
from run import CONFIG

WIDEN = ("W1", "W2", "W1X")


def share(rows, pred):
    return sum(1 for r in rows if pred(r)) / len(rows) if rows else None


def main():
    rows = load(HERE / "results" / "runs")
    configured = list(CONFIG["models"])
    m = measures(rows, configured)
    design_models = m["models"]
    sps = set(m["standpoints_included"])
    valid = [r for r in rows if r["valid"] and r["replicate"] == 0]
    main_rows = [r for r in valid if r["model"] in design_models and r["standpoint"] in sps]
    out = {}

    # 1. violations
    viol = {}
    for cls in WIDEN:
        c = [r for r in main_rows if r["cls"] == cls]
        cr = [r for r in c if r["read_right"]]
        viol[cls] = {
            "all": share(c, lambda r: r["choice"] == "B"),
            "read_right": share(cr, lambda r: r["choice"] == "B"),
            "read_right_without_sp10": share([r for r in cr if r["standpoint"] != 10], lambda r: r["choice"] == "B"),
            "n_read_right": len(cr),
        }
    out["violations_by_class"] = viol
    per_sp = {}
    for s in sorted(sps):
        w = [r for r in main_rows if r["cls"] in ("W1", "W2") and r["standpoint"] == s]
        per_sp[s] = share(w, lambda r: r["choice"] == "B")
    out["W12_violation_by_standpoint"] = per_sp
    r1 = {}
    for mod in design_models:
        mm = [r for r in main_rows if r["model"] == mod and r["read_right"]]
        r1[mod] = {
            "W1_W2": share([r for r in mm if r["cls"] in ("W1", "W2")], lambda r: r["choice"] == "B"),
            "W1_W2_without_sp10": share([r for r in mm if r["cls"] in ("W1", "W2") and r["standpoint"] != 10],
                                        lambda r: r["choice"] == "B"),
            "W1X": share([r for r in mm if r["cls"] == "W1X"], lambda r: r["choice"] == "B"),
        }
    out["R1_decomposed"] = r1

    # 2. framing
    def continues_plan(r):
        fr = {r["shown"][0]: r["framing_1"], r["shown"][1]: r["framing_2"]}
        return next((p for p, f in fr.items() if f == "continue"), None)

    k = [r for r in main_rows if r["cls"] == "K"]
    x = [r for r in main_rows if r["cls"] == "W1X"]
    out["framing"] = {
        "K_chooses_plan_said_by_continues": share(k, lambda r: r["choice"] == continues_plan(r)),
        "K_chooses_plan_said_by_ends": share(k, lambda r: r["choice"] not in ("equal", continues_plan(r))),
        "K_equal": share(k, lambda r: r["choice"] == "equal"),
        "W1X_violation_when_wider_said_by_ends": share([r for r in x if continues_plan(r) == "B"],
                                                       lambda r: r["choice"] == "B"),
        "W1X_violation_when_wider_said_by_continues": share([r for r in x if continues_plan(r) == "A"],
                                                            lambda r: r["choice"] == "B"),
        "K_by_model": {mod: {
            "continues": share([r for r in k if r["model"] == mod], lambda r: r["choice"] == continues_plan(r)),
            "equal": share([r for r in k if r["model"] == mod], lambda r: r["choice"] == "equal")}
            for mod in design_models},
    }

    # 3. counting
    cnt = {}
    for cls in ("M1", "M2"):
        c = [r for r in main_rows if r["cls"] == cls]
        cnt[cls] = {
            "larger_chosen": share(c, lambda r: r["choice"] == "A"),
            "by_model": {mod: share([r for r in c if r["model"] == mod], lambda r: r["choice"] == "A")
                         for mod in design_models},
            "by_standpoint": {s: share([r for r in c if r["standpoint"] == s], lambda r: r["choice"] == "A")
                              for s in sorted(sps)},
        }
    out["counting"] = cnt

    # 4. left-out models and all six pooled (every valid main-design row)
    def class_D(rs):
        from analyze import by_pair, disagreement
        d = defaultdict(list)
        for (f, cls), pr in by_pair(rs).items():
            d[cls].append(disagreement(pr))
        return {cls: sum(v) / len(v) for cls, v in sorted(d.items())}

    left = {}
    for mod in m["design"]["dropped"]:
        mm = [r for r in valid if r["model"] == mod]
        w12 = [r for r in mm if r["cls"] in ("W1", "W2")]
        left[mod] = {
            "valid_main_rows": len(mm),
            "W12_violation": share(w12, lambda r: r["choice"] == "B"),
            "M1_larger": share([r for r in mm if r["cls"] == "M1"], lambda r: r["choice"] == "A"),
            "M2_larger": share([r for r in mm if r["cls"] == "M2"], lambda r: r["choice"] == "A"),
            "K_equal": share([r for r in mm if r["cls"] == "K"], lambda r: r["choice"] == "equal"),
            "D_by_class": class_D(mm),
        }
    out["left_out_models"] = left
    six = [r for r in valid if r["model"] in configured]
    out["six_models_pooled_D"] = class_D(six)

    # 5. reasons
    reasons = [{"model": r["model"], "standpoint": r["standpoint"], "frame": r["frame"], "cls": r["cls"],
                "reason": r.get("reason")}
               for r in main_rows if r["cls"] in ("W1", "W2") and r["read_right"] and r["choice"] == "B"
               and r["standpoint"] != 10]
    out["right_read_W12_violations_outside_sp10"] = reasons

    (HERE / "results" / "posthoc.json").write_text(json.dumps(out, indent=1, ensure_ascii=False))
    print(json.dumps({k: v for k, v in out.items() if k != "right_read_W12_violations_outside_sp10"},
                     indent=1)[:6000])
    print(f"\nright-read W1/W2 violations outside standpoint 10: {len(reasons)}")
    for r in reasons:
        print(f"- {r['model']} sp{r['standpoint']} {r['frame']} {r['cls']}: {r['reason']}")


if __name__ == "__main__":
    main()
