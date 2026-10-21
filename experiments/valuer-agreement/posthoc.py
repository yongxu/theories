"""Post hoc measures of VD1, computed after the final verdicts (results/verdicts.json). Not verdicts.

python3 -B posthoc.py      writes results/posthoc.json and prints a summary

Every number here was chosen after verdicts were seen: this script was first written by the session that
started VD1's, after its early look at incomplete rows (kept as results/early-look/posthoc-2026-10-21T1111.py),
and is run here unchanged in its measures on the final rows, with standpoint 15 added beside standpoint 10.
None changes a verdict; each says where the failures came from, as the freeze's "What would change the
account" asks (R1 failing: the reasons, read after the verdicts, separate a weight below zero from an order
not increasing in admission).

1. Where the violations come from: W1/W2/W1X violations by class, by standpoint, and among right readings,
   with standpoint 10 (the urban planner, "letting outdated things give way") and standpoint 15 (the
   engineer, "much of what people treasure is clutter") left out, the two standpoints whose own text
   invites a weight below zero on what is kept.
2. Framing: in K (the same sets, one plan said by what continues, the other by what ends) and W1X
   (a widening cross-framed), the share choosing the plan said by what continues.
3. Counting: in M1 and M2, the share choosing the larger plan, by model and by standpoint.
4. Models the design rule left out (none on the final rows) and all six pooled on every valid row.
5. The reasons of right-read violations in W1 and W2, every standpoint, for reading.
6. Those reasons coded by one reading (the VD1 session, after the verdicts): "below zero" where the
   reason calls the ending of what only the wider plan keeps a gain (progress, clutter, less state, less
   comfort), "trade" where it describes the pair as a swap, the wider plan ending something the chosen
   one keeps, against the judgment's own listed sets. TRADE lists the second; every other case was read
   as the first. One coder, not blind to the hypothesis.
"""

from __future__ import annotations

import json
from collections import defaultdict
from pathlib import Path

from analyze import HERE, load, measures
from run import CONFIG

WIDEN = ("W1", "W2", "W1X")
TRADE = {  # (model, standpoint, frame, class): the reason describes a swap the listed sets do not contain
    ("deepseek/deepseek-v4.1-flash-1017", 2, "F16", "W2"), ("nvidia/nemotron-3.5-lightning", 0, "F07", "W1"),
    ("nvidia/nemotron-3.5-lightning", 5, "F03", "W1"), ("nvidia/nemotron-3.5-lightning", 5, "F07", "W1"),
    ("nvidia/nemotron-3.5-lightning", 5, "F15", "W1"), ("nvidia/nemotron-3.5-lightning", 6, "F07", "W1"),
    ("nvidia/nemotron-3.5-lightning", 6, "F10", "W1"), ("nvidia/nemotron-3.5-lightning", 6, "F15", "W1"),
    ("nvidia/nemotron-3.5-lightning", 9, "F09", "W1"), ("nvidia/nemotron-3.5-lightning", 12, "F03", "W1"),
    ("nvidia/nemotron-3.5-lightning", 13, "F03", "W1"), ("nvidia/nemotron-3.5-lightning", 14, "F02", "W1"),
    ("nvidia/nemotron-3.5-lightning", 14, "F08", "W1"), ("openai/gpt-6-luna", 0, "F05", "W2"),
    ("openai/gpt-6-luna", 7, "F06", "W1"), ("openai/gpt-6-luna", 8, "F01", "W1"),
    ("openai/gpt-6-luna", 12, "F01", "W1"), ("openai/gpt-6-luna", 12, "F05", "W1"),
    ("openai/gpt-6-luna", 12, "F15", "W1"), ("openai/gpt-6-luna", 15, "F06", "W1"),
    ("z-ai/glm-5.3-flash", 3, "F13", "W2"), ("z-ai/glm-5.3-flash", 11, "F15", "W1"),
    ("z-ai/glm-5.3-flash", 14, "F03", "W2"),
}


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
            "read_right_without_sp10_15": share([r for r in cr if r["standpoint"] not in (10, 15)],
                                                lambda r: r["choice"] == "B"),
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
            "W1_W2_without_sp10_15": share([r for r in mm if r["cls"] in ("W1", "W2")
                                            and r["standpoint"] not in (10, 15)], lambda r: r["choice"] == "B"),
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
               for r in main_rows if r["cls"] in ("W1", "W2") and r["read_right"] and r["choice"] == "B"]
    out["right_read_W12_violations"] = reasons

    # 6. reasons coded
    for r in reasons:
        r["code"] = "trade" if (r["model"], r["standpoint"], r["frame"], r["cls"]) in TRADE else "below zero"
    assert len(TRADE) == sum(r["code"] == "trade" for r in reasons)
    sp_neg = (10, 15)
    n_main = defaultdict(int)
    for r in main_rows:
        if r["cls"] in ("W1", "W2"):
            n_main[r["model"]] += 1
    out["reasons_coded"] = {
        "n": len(reasons),
        "below_zero": sum(r["code"] == "below zero" for r in reasons),
        "trade": sum(r["code"] == "trade" for r in reasons),
        "below_zero_at_10_15": sum(r["code"] == "below zero" and r["standpoint"] in sp_neg for r in reasons),
        "below_zero_elsewhere": sum(r["code"] == "below zero" and r["standpoint"] not in sp_neg for r in reasons),
        "trade_by_model": {mod: sum(r["code"] == "trade" and r["model"] == mod for r in reasons)
                           for mod in design_models},
        "trade_share_of_W12_by_model": {mod: sum(r["code"] == "trade" and r["model"] == mod for r in reasons) /
                                 max(1, n_main[mod]) for mod in design_models},
    }

    (HERE / "results" / "posthoc.json").write_text(json.dumps(out, indent=1, ensure_ascii=False))
    print(json.dumps({k: v for k, v in out.items() if k != "right_read_W12_violations"}, indent=1)[:8000])
    by_sp = defaultdict(int)
    for r in reasons:
        by_sp[r["standpoint"]] += 1
    print(f"\nright-read W1/W2 violations: {len(reasons)}, by standpoint {dict(sorted(by_sp.items()))}")
    print(json.dumps(out["reasons_coded"], indent=1))
    for r in reasons:
        print(f"- [{r['code']}] {r['model']} sp{r['standpoint']} {r['frame']} {r['cls']}: {r['reason']}")


if __name__ == "__main__":
    main()
