"""Measures and frozen verdict rules for IN2 (see the PREDICTIONS file).

python3 analyze_ft.py [runs_dir]   writes results/verdicts.json for the frozen runs
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from lake_mixed import HOUSEHOLD

KEPT_HIGH, KEPT_LOW, GAP, CTRL_SLACK, FISHERS_HIGH, INVALID_MAX = 0.80, 0.20, 0.30, 0.10, 0.80, 0.05


def load(runs: Path):
    by = {}
    for p in sorted(runs.glob("*/*/*.json")):
        d = json.loads(p.read_text())
        by.setdefault((d["arm"], d["cell"]), []).append(d)
    return by


def measures(rs):
    valid = [r for r in rs if r["valid"]]
    n = len(valid)
    out = {"runs": len(rs), "valid_runs": n, "invalid_share": (len(rs) - n) / len(rs) if rs else None}
    if not n:
        return out
    out["kept"] = sum(r["bed_kept"] for r in valid) / n
    out["lake_kept"] = sum(r["lake_kept"] for r in valid) / n
    out["fishers_kept"] = sum(sum(r["fishers_kept"]) for r in valid) / (3 * n)
    out["season_catch_mean"] = sum(sum(sum(m["caught"]) for m in r["months"]) for r in valid) / n
    out["month1_mean_request"] = sum(sum(r["months"][0]["requested"]) / 3 for r in valid) / n
    keep = tot = 0
    for r in valid:
        alive = True
        for m in r["months"]:
            if alive and m["stock"] >= 70:
                for c in m["requested"]:
                    tot += 1
                    keep += c <= (m["stock"] - 70) // 3
            alive = m["bed_alive_after"]
    out["keeping_decisions"] = keep / tot if tot else None
    out["identity_violations"] = sum(len(r.get("identity_violations", [])) for r in valid)
    return out


def verdicts(M):
    def k(a, c):
        return M.get((a, c), {}).get("kept")

    def ok(*keys):
        return all(key in M and M[key].get("valid_runs") and M[key]["invalid_share"] <= INVALID_MAX for key in keys)

    v = {}
    v["T1_training_installs_and_transfers"] = (ok(("FT_DIR", "COMM_SEEN"), ("FT_CTRL", "COMM_SEEN"))
                                              and k("FT_DIR", "COMM_SEEN") >= KEPT_HIGH
                                              and k("FT_DIR", "COMM_SEEN") - k("FT_CTRL", "COMM_SEEN") >= GAP)
    v["T2_coupling_still_needed"] = ok(("FT_DIR", "COMM_UNSEEN")) and k("FT_DIR", "COMM_UNSEEN") <= KEPT_LOW
    v["T3_widening_not_blanket"] = (ok(("FT_DIR", "COMM_SEEN_MIXED"))
                                   and M[("FT_DIR", "COMM_SEEN_MIXED")]["fishers_kept"] >= FISHERS_HIGH
                                   and k("FT_DIR", "COMM_SEEN_MIXED") <= KEPT_LOW)
    v["T4_control_not_the_cause"] = (ok(("FT_CTRL", "COMM_SEEN"), ("BASE", "COMM_SEEN"))
                                    and k("FT_CTRL", "COMM_SEEN") <= k("BASE", "COMM_SEEN") + CTRL_SLACK)
    v["I_identities"] = all(x.get("identity_violations", 0) == 0 for x in M.values())
    return v


def main():
    runs = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("results/runs")
    M = {key: measures(rs) for key, rs in load(runs).items()}
    res = {"thresholds": {"kept_high": KEPT_HIGH, "kept_low": KEPT_LOW, "gap": GAP, "ctrl_slack": CTRL_SLACK,
                          "fishers_high": FISHERS_HIGH, "invalid_max": INVALID_MAX, "household": HOUSEHOLD},
           "measures": {f"{a}/{c}": m for (a, c), m in sorted(M.items())},
           "verdicts": verdicts(M)}
    text = json.dumps(res, indent=1)
    if runs == Path("results/runs"):
        Path("results/verdicts.json").write_text(text)
    print(text)


if __name__ == "__main__":
    main()
