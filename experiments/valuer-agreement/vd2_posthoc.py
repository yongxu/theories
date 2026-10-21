"""Post hoc measures of VD2, computed after the final verdicts (results/vd2/verdicts.json). Not verdicts.

python3 -B vd2_posthoc.py      writes results/vd2/posthoc.json and prints a summary

Every number here was chosen after the verdicts were seen. None changes a verdict. Each says where a failed
or narrowly passed rule's cases lie, as the freeze's "What would change the account" asks:
1. Raw invalid rows per model (V counts presentations after every retry, as VD1 did).
2. X3 by model, and the G2 cell's choices by standpoint group.
3. X1's violations in the P cell: by standpoint (10 and 15 against the rest) and by strength (slight only,
   or serious once), with their reasons for reading.
4. Gain shares by standpoint and model, and the formations called a gain under standpoints 4 and 6 (S2).
5. X1 on the stricter reading of "everything at stake": valuers whose signs on all six formations of the
   frame are P.
6. Violations by standpoint against VD1's W1 violations by standpoint.
"""

from __future__ import annotations

import json
from collections import defaultdict
from pathlib import Path

from vd2_analyze import EXPECTED_NEGATIVE, OUT, load_all, load_judges, measures, read_rows, share
from vd2_frames import GAIN
from vd2_run import CONFIG

HERE = Path(__file__).parent


def main():
    configured = list(CONFIG["models"])
    raw = read_rows(OUT / "runs")
    rows = load_all(OUT / "runs")
    misread = load_judges(OUT / "judge")
    m = measures(rows, configured, misread)
    models = m["design"]["models"]
    rank = [r for r in rows if r["task"] == "rank" and r["valid"] and r["model"] in models]
    exact = [r for r in rank if r["read_exact"]]
    signs = [r for r in rows if r["task"] == "sign" and r["valid"]]
    out = {}

    # 1
    out["raw_invalid_rows"] = {mod: {"rows": sum(1 for r in raw if r["model"] == mod),
                                     "invalid": sum(1 for r in raw if r["model"] == mod and not r["valid"])}
                               for mod in models}

    # 2
    g2 = [r for r in exact if r["G2"]]
    out["X3_by_model"] = {mod: {"n": sum(1 for r in g2 if r["model"] == mod),
                                "narrower": share([r for r in g2 if r["model"] == mod], lambda r: r["choice"] == "B"),
                                "equal": share([r for r in g2 if r["model"] == mod], lambda r: r["choice"] == "equal")}
                          for mod in models}
    out["X3_by_group"] = {grp: {"n": len(c), "narrower": share(c, lambda r: r["choice"] == "B")}
                          for grp, c in (("10_15", [r for r in g2 if r["standpoint"] in EXPECTED_NEGATIVE]),
                                         ("others", [r for r in g2 if r["standpoint"] not in EXPECTED_NEGATIVE]))}

    # 3
    p = [r for r in exact if r["cell"] == "P"]
    pv = [r for r in p if r["violation"]]
    out["P_violations"] = {
        "n_P": len(p), "violations": len(pv), "judged_misread_in_P": sum(1 for r in p if r["choice"] == "B" and r["misread"]),
        "at_10_15": {"n": sum(1 for r in p if r["standpoint"] in EXPECTED_NEGATIVE),
                     "violations": sum(1 for r in pv if r["standpoint"] in EXPECTED_NEGATIVE)},
        "elsewhere": {"n": sum(1 for r in p if r["standpoint"] not in EXPECTED_NEGATIVE),
                      "violations": sum(1 for r in pv if r["standpoint"] not in EXPECTED_NEGATIVE)},
        "slight_only": {"n": sum(1 for r in p if not r["serious"]), "violations": sum(1 for r in pv if not r["serious"])},
        "serious_once": {"n": sum(1 for r in p if r["serious"]), "violations": sum(1 for r in pv if r["serious"])},
        "PS_at_10_15": {"n": sum(1 for r in p if r["serious"] and r["standpoint"] in EXPECTED_NEGATIVE),
                        "violations": sum(1 for r in pv if r["serious"] and r["standpoint"] in EXPECTED_NEGATIVE)},
        "by_model_and_group": {mod: {grp: sum(1 for r in pv if r["model"] == mod and
                                              (r["standpoint"] in EXPECTED_NEGATIVE) == neg)
                                     for grp, neg in (("10_15", True), ("others", False))} for mod in models},
        "reasons": [{"model": r["model"], "standpoint": r["standpoint"], "frame": r["frame"], "added": r["added"],
                     "serious": r["serious"], "reason": r["reason"]} for r in pv],
    }

    # 4
    out["gain_share_by_standpoint_and_model"] = {
        s: {mod: share([r for r in signs if r["standpoint"] == s and r["model"] == mod], lambda r: r["ending"] in GAIN)
            for mod in models} for s in range(16)}
    out["gains_at_4_and_6"] = {
        s: sorted(((r["model"], r["frame"], r["formation"], r["kind"], r["elicitation"], r["ending"], r["reason"])
                   for r in signs if r["standpoint"] == s and r["ending"] in GAIN))
        for s in (4, 6)}
    kinds = defaultdict(int)
    for s in (4, 6):
        for x in out["gains_at_4_and_6"][s]:
            kinds[(s, x[3])] += 1
    out["gain_kinds_at_4_and_6"] = {f"{s}:{k}": n for (s, k), n in sorted(kinds.items())}

    # 5
    cells = {}
    for r in signs:
        cells.setdefault((r["model"], r["standpoint"], r["frame"]), defaultdict(dict))[r["formation"]][r["elicitation"]] = r["ending"]
    allp = {k for k, v in cells.items() if len(v) == 6 and all(
        len(e) == 2 and all(x in ("serious loss", "slight loss") for x in e.values()) for e in v.values())}
    strict = [r for r in exact if (r["model"], r["standpoint"], r["frame"]) in allp]
    out["X1_all_six_P"] = {mod: {"n": sum(1 for r in strict if r["model"] == mod),
                                 "violations": sum(1 for r in strict if r["model"] == mod and r["violation"])}
                           for mod in models}

    # 6
    vd1 = json.loads((HERE / "results" / "posthoc.json").read_text())["W12_violation_by_standpoint"]
    out["violation_by_standpoint_vs_vd1_W12"] = {s: {"vd2": m["violation_by_standpoint"].get(s),
                                                     "vd1_W12": vd1.get(str(s))} for s in range(16)}

    (OUT / "posthoc.json").write_text(json.dumps(out, indent=1, ensure_ascii=False, default=str) + "\n")
    print(json.dumps({k: v for k, v in out.items() if k not in ("gains_at_4_and_6",)}, indent=1, default=str)[:12000])


if __name__ == "__main__":
    main()
