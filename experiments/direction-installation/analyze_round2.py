"""Measures and frozen verdict rules for IN1 round 2 (PREDICTIONS-ROUND2-2026-10-21.md).

python3 analyze_round2.py [runs_dir]   writes results/verdicts-round2.json for the frozen runs
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from lake import NEED

R1_KEPT = {"gpt-5.4-mini": 0.80, "gpt-4.1-mini": 0.50}
KEPT_LOW, GAP, INVALID_MAX = 0.20, 0.30, 0.05
# round 1's over-take share in DIR_SEEN (results/posthoc-round1.json): over / decisions while alive
ROUND1_OVER = {"gpt-5.4-mini": 12 / 183, "gpt-4.1-mini": 14 / 66}


def measures(rs):
    valid = [r for r in rs if r["valid"]]
    n = len(valid)
    out = {"runs": len(rs), "valid_runs": n, "invalid_share": (len(rs) - n) / len(rs) if rs else None}
    if not n:
        return out
    out["kept"] = sum(r["bed_kept"] for r in valid) / n
    out["lake_kept"] = sum(r["lake_kept"] for r in valid) / n
    out["season_catch_mean"] = sum(sum(sum(m["caught"]) for m in r["months"]) for r in valid) / n
    over = tot = 0
    for r in valid:
        alive = True
        for m in r["months"]:
            if alive and m["stock"] >= NEED:
                for c in m["requested"]:
                    tot += 1
                    over += c > (m["stock"] - NEED) // 3
            alive = m["bed_alive_after"]
    out["over_share"] = over / tot if tot else None
    out["decisions_while_alive"] = tot
    out["identity_violations"] = sum(len(r.get("identity_violations", [])) for r in valid)
    return out


def main():
    runs = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("results/runs-round2")
    by = {}
    for p in sorted(runs.glob("*/*/*.json")):
        d = json.loads(p.read_text())
        by.setdefault(d["model"], {}).setdefault(d["cell"], []).append(d)
    res = {"thresholds": {"R1_kept": R1_KEPT, "kept_low": KEPT_LOW, "gap": GAP, "invalid_max": INVALID_MAX,
                          "round1_over": ROUND1_OVER}, "models": {}}
    for mo, cells in by.items():
        M = {c: measures(rs) for c, rs in cells.items()}

        def ok(*cs):
            return all(c in M and M[c].get("valid_runs") and M[c]["invalid_share"] <= INVALID_MAX for c in cs)
        v = {
            "R1_talk_completes_where_coupled": ok("DIR_SEEN_TALK") and M["DIR_SEEN_TALK"]["kept"] >= R1_KEPT.get(mo, 0.8),
            "R2_pool_does_not_reach_beyond": ok("DIR_UNSEEN_TALK") and M["DIR_UNSEEN_TALK"]["kept"] <= KEPT_LOW,
            "R3_scope_makes_the_difference": (ok("DIR_SEEN_TALK", "COMM_SEEN_TALK")
                                              and M["DIR_SEEN_TALK"]["kept"] - M["COMM_SEEN_TALK"]["kept"] >= GAP),
            "R4_joint_account_fixed": (ok("DIR_SEEN_TALK") and M["DIR_SEEN_TALK"]["over_share"] is not None
                                       and M["DIR_SEEN_TALK"]["over_share"] <= ROUND1_OVER.get(mo, 0.0) / 3),
            "I_identities": all(x.get("identity_violations", 0) == 0 for x in M.values()),
        }
        res["models"][mo] = {"measures": M, "verdicts": v}
    names = ["R1_talk_completes_where_coupled", "R2_pool_does_not_reach_beyond", "R3_scope_makes_the_difference",
             "R4_joint_account_fixed", "I_identities"]
    res["passed_for_every_model"] = {h: all(res["models"][mo]["verdicts"][h] for mo in res["models"]) for h in names}
    text = json.dumps(res, indent=1)
    if runs == Path("results/runs-round2"):
        Path("results/verdicts-round2.json").write_text(text)
    print(text)


if __name__ == "__main__":
    main()
