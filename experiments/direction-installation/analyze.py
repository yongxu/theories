"""Measures and frozen verdict rules for IN1 (see PREDICTIONS-2026-10-21.md).

python3 analyze.py [runs_dir]   writes results/verdicts.json (or prints, for a scratch dir)
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from lake import CAPACITY, NEED

KEPT_HIGH, KEPT_LOW, GAP, GAP_UNSEEN, DEC_HIGH, DEC_GAP, INVALID_MAX = 0.80, 0.20, 0.30, 0.50, 0.90, 0.20, 0.05


def load(runs: Path):
    by = {}
    for p in sorted(runs.glob("*/*/*.json")):
        d = json.loads(p.read_text())
        by.setdefault((d["model"], d["cell"]), []).append(d)
    return by


def keeping_threshold(stock: int) -> int:
    """The symmetric share that leaves the bed's need: floor((stock - NEED) / 3)."""
    return (stock - NEED) // 3 if stock >= NEED else -1


def cell_measures(rs):
    valid = [r for r in rs if r["valid"]]
    n_all, n = len(rs), len(valid)
    out = {"runs": n_all, "valid_runs": n, "invalid_share": (n_all - n) / n_all if n_all else None}
    if not n:
        return out
    out["kept"] = sum(r["bed_kept"] for r in valid) / n
    out["lake_kept"] = sum(r["lake_kept"] for r in valid) / n
    out["season_catch_mean"] = sum(sum(sum(m["caught"]) for m in r["months"]) for r in valid) / n
    out["min_left_mean"] = sum(min(m["left"] for m in r["months"]) for r in valid) / n
    dec = tot = 0
    for r in valid:
        alive = True
        for m in r["months"]:
            if alive and m["stock"] >= NEED:
                t = keeping_threshold(m["stock"])
                for c in m["requested"]:
                    tot += 1
                    dec += c <= t
            alive = m["bed_alive_after"]
    out["keeping_decisions"] = dec / tot if tot else None
    out["decisions_while_alive"] = tot
    out["identity_violations"] = sum(len(r.get("identity_violations", [])) for r in valid)
    return out


def verdicts(m):
    """m: cell -> measures for one model."""
    def k(c):
        return m.get(c, {}).get("kept")

    def tested(*cs):
        return all(c in m and m[c].get("valid_runs") and m[c]["invalid_share"] <= INVALID_MAX for c in cs)

    v = {}
    v["H1_installed_where_coupled"] = tested("DIR_SEEN") and k("DIR_SEEN") >= KEPT_HIGH
    v["H2_scope_makes_the_difference"] = tested("DIR_SEEN", "COMM_SEEN") and k("DIR_SEEN") - k("COMM_SEEN") >= GAP
    v["H3_coupling_needed"] = (tested("DIR_SEEN", "DIR_UNSEEN") and k("DIR_UNSEEN") <= KEPT_LOW
                               and k("DIR_SEEN") - k("DIR_UNSEEN") >= GAP_UNSEEN)
    v["H4_seeing_is_not_valuing"] = tested("OWN_SEEN") and k("OWN_SEEN") <= KEPT_LOW
    v["H5_cost_on_the_catch"] = (tested("DIR_SEEN", "COMM_SEEN")
                                 and m["DIR_SEEN"]["season_catch_mean"] < m["COMM_SEEN"]["season_catch_mean"])
    v["D1_decisions"] = (tested("DIR_SEEN", "COMM_SEEN")
                         and m["DIR_SEEN"]["keeping_decisions"] is not None
                         and m["DIR_SEEN"]["keeping_decisions"] >= DEC_HIGH
                         and (m["COMM_SEEN"]["keeping_decisions"] or 0) <= m["DIR_SEEN"]["keeping_decisions"] - DEC_GAP)
    v["I_identities"] = all(x.get("identity_violations", 0) == 0 for x in m.values())
    return v


def main():
    runs = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("results/runs")
    by = load(runs)
    models = sorted({mo for mo, _ in by})
    res = {"thresholds": {"kept_high": KEPT_HIGH, "kept_low": KEPT_LOW, "gap": GAP, "gap_unseen": GAP_UNSEEN,
                          "decisions_high": DEC_HIGH, "decisions_gap": DEC_GAP, "invalid_max": INVALID_MAX},
           "models": {}}
    for mo in models:
        m = {c: cell_measures(rs) for (mo2, c), rs in by.items() if mo2 == mo}
        res["models"][mo] = {"measures": m, "verdicts": verdicts(m)}
    names = list(next(iter(res["models"].values()))["verdicts"]) if models else []
    res["passed_for_every_model"] = {h: all(res["models"][mo]["verdicts"][h] for mo in models) for h in names}
    text = json.dumps(res, indent=1)
    if runs == Path("results/runs"):
        Path("results/verdicts.json").write_text(text)
    print(text)


if __name__ == "__main__":
    main()
