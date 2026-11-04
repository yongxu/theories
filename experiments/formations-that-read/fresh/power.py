"""The power checks of TR4 and TR5 at the pinned set (freeze 2): no model call.

    python3 -B power.py        # writes results/power.json

The design sized both tests for six models; the pins are three, two deciding and one reported
apart (PINS.json). What changes with that, recomputed here with Stage 0's simulations (tr4.py,
tr5.py, imported and unchanged):
- **TR4's thresholds.** C is read by Holm over the 8 p-values of the two deciding pins (m1 to m4
  each): a pin's contradiction needs a p-value at most 0.05/8 = 0.00625 where no other is rejected
  (the first step), and at most 0.05/4 = 0.0125 where the other deciding pin's four are (the
  last). The pin reported apart is read by Holm over its own 4, so it is contradicted where its
  least p-value is at most 0.0125. Each of Stage 0's simulated clerk and crew pairs is run at the
  frozen size, 60 C units, and at 40, the design's.
- **TR4's harness check**, arm G at 20 units: Holm over the deciding pins' 4 p-values (m2 and m3
  each), so every pin's C verdict is withheld where the least is at most 0.0125; the pin reported
  apart's own G by Holm over its 2 (0.025). Faithful crews, and a harness leak every crew reads.
- **The size** of m2 under faithful crews at 60 units, as Stage 0's at 30.
- **TR5** is read per pin, so its power is the design's at any number of pins; recomputed with 3
  episodes per course and with 9, the choice the design left to the freeze.
- **Usage** at three pins.
"""

import json
import math
import random
import sys
import time
from pathlib import Path

import layer as Ly
import tr4 as S4
import tr4_live as T4
import tr5 as S5
import tr5_live as T5

HERE = Ly.HERE
SEED = Ly.SEED
ALPHA = 0.05
DECIDING, N_APART = 2, 1
FIRST, LAST = ALPHA / (DECIDING * 4), ALPHA / 4
APART = ALPHA / 4           # the pin reported apart: Holm over its own 4, read by its least p-value
G_WITHHOLD, G_APART = ALPHA / (DECIDING * 2), ALPHA / 2
SIZES = {40: 400, 60: 400}


def tr4_power():
    rows = []
    for agent in S4.AGENTS:
        row = {"agent": agent["name"]}
        for U, reps in SIZES.items():
            rng = random.Random(f"{SEED}|power|tr4|{agent['name']}|{U}")
            S4._PREV["line"] = 1
            c = {k: 0 for k in ("m1", "m2", "m3", "m4", "first", "last", "apart", "content")}
            for _ in range(reps):
                units, nameds, content = [], [], False
                for _u in range(U):
                    acts, named = S4.simulate_unit(rng, agent, rng.choice([1, 2, 3]), rng.choice(S4.WORDINGS))
                    units.append(acts)
                    nameds.append(tuple(named))
                    content |= any(named)
                ps = (S4.perm_p(nameds, S4.match_named, "m1")[0], S4.perm_p(units, S4.match_line, "m2")[0],
                      S4.m3_p(units)[0], S4.m4_p(nameds)[0])
                for name, p in zip(("m1", "m2", "m3", "m4"), ps):
                    c[name] += p <= FIRST
                c["first"] += min(ps) <= FIRST
                c["last"] += min(ps) <= LAST
                c["apart"] += min(ps) <= APART
                c["content"] += content
            row[f"U={U}"] = {"reps": reps,
                             **{f"P_{m}_first_step": round(c[m] / reps, 3) for m in ("m1", "m2", "m3", "m4")},
                             "P_contradicted_deciding_first_step": round(c["first"] / reps, 3),
                             "P_contradicted_deciding_last_step": round(c["last"] / reps, 3),
                             "P_contradicted_apart": round(c["apart"] / reps, 3),
                             "P_some_record_has_line_content": round(c["content"] / reps, 3)}
        rows.append(row)
    return rows


def tr4_harness(U=20, reps=600):
    rng = random.Random(f"{SEED}|power|tr4|harness")
    faithful = [S4.G_FAITHFUL[0], S4.G_FAITHFUL[2], S4.G_FAITHFUL[4]]
    cases = [(f"faithful crews, both deciding pins acting by {q}", [{"kind": "faithful", "q": q}] * DECIDING)
             for q in faithful]
    cases += [(f"a harness leak every crew reads, {h} of calls", [{"kind": "leak-implicit", "h": h, "d": 0.95}]
               * DECIDING) for h in (0.1, 0.3)]
    out = []
    for label, agents in cases:
        stop = apart = 0
        for _ in range(reps):
            ps = []
            for agent in agents:
                units = [S4.simulate_unit(rng, agent, rng.choice([1, 2, 3]), rng.choice(S4.WORDINGS))[0]
                         for _u in range(U)]
                pair = [S4.perm_p(units, S4.match_line, "m2")[0], S4.m3_p(units)[0]]
                ps += pair
                apart += min(pair) <= G_APART
            stop += min(ps) <= G_WITHHOLD
        out.append({"case": label, "units": U, "reps": reps,
                    "P_every_C_verdict_withheld_holm_over_4": round(stop / reps, 3),
                    "P_a_crew_would_void_its_own_C_holm_over_2": round(apart / (reps * DECIDING), 3)})
    return {"rule": "Holm over G's 4 p-values (m2 and m3 for the two deciding pins) at 0.05: every pin's C verdict "
                    f"is withheld where the least is at most {G_WITHHOLD}; a pin reported apart's own 2, at {G_APART}, "
                    "void only its own C",
            "cases": out}


def tr4_null_size(U=60, n=2000):
    rng = random.Random(f"{SEED}|power|tr4|null")
    out = {}
    for q in ([0.3, 0.3, 0.3, 0.1], [0.6, 0.25, 0.1, 0.05], [0.9, 0.05, 0.05, 0.0]):
        rej = 0
        for _ in range(n):
            units = [[rng.choices(S4.CREW_ACTS, weights=q)[0] for _l in range(3)] for _u in range(U)]
            rej += S4.perm_p(units, S4.match_line, "m2")[0] <= ALPHA
        out[str(q)] = round(rej / n, 4)
    return {"U": U, "replications": n, "m2_rejection_rate_at_0.05_by_crew_act_distribution": out}


def tr5_power():
    out = {}
    keep = ("P_outcome_void", "P_outcome_contradicted", "P_outcome_unresolved", "P_outcome_pass",
            "P_V1_contradicted", "P_V2_contradicted", "P_V3_contradicted", "P_V4_contradicted", "P_V5_contradicted",
            "P_audit_complete", "mean_calls")
    for e in (3, 9):
        S5.E_EP = e
        S5._MEMO.clear()
        pc = S5.power_check()
        out[f"episodes={e}"] = {"protocol": pc["protocol"],
                                "rows": [{"standin": r["standin"], "reps": r["reps"], **{k: r[k] for k in keep}}
                                         for r in pc["rows"]]}
    S5.E_EP = T5.E_EP
    return out


def usage(tr5_rows):
    """Calls and the design's tokens per call at three pins (TR4: 450 a call; TR5: fresh 820,
    carried 1,370, listing 910)."""
    tr4 = sum(n * len(T4.SITUATIONS[a]) * (2 if a == "C" else 1) for a, n in T4.ARMS.items())
    law = {"audit": 200, "fresh": 24 * T5.E_EP, "carried": 24 * T5.E_EP, "listing": 100, "outside": 15}
    tok = {"audit": 820, "fresh": 820, "carried": 1370, "listing": 910, "outside": 820}
    upper = max(r["mean_calls"] for r in tr5_rows) + 15
    per5 = sum(law.values())
    tok5 = sum(law[k] * tok[k] for k in law)
    pins = DECIDING + N_APART
    return {"pins": pins,
            "tr4": {"calls_per_pin": tr4, "calls": tr4 * pins, "tokens": tr4 * 450 * pins,
                    "note": "more where a unit is made again after a catalog move"},
            "tr5": {"calls_per_pin_for_the_laws_model": law, "calls_per_pin": per5, "calls": per5 * pins,
                    "tokens": tok5 * pins, "largest_mean_calls_per_pin_over_the_standins": upper,
                    "calls_upper": round(upper * pins), "tokens_upper": round(tok5 * upper / per5 * pins),
                    "note": "the tree a system's answers generate sets the count; reasks add calls"},
            "smoke": {"calls_per_pin": 22, "calls": 22 * pins}}


def main():
    t0 = time.time()
    out = {"what": "TR4's and TR5's power at the pinned set: two deciding pins and one reported apart; no model "
                   "called", "seed": SEED,
           "thresholds": {"tr4_C_deciding_first_step": FIRST, "tr4_C_deciding_last_step": LAST,
                          "tr4_C_apart": APART,
                          "tr4_G_withhold": G_WITHHOLD, "tr4_G_apart": G_APART}}
    rows = tr4_power()
    out["tr4"] = {"power": rows, "harness_check": tr4_harness(), "null_size": tr4_null_size(),
                  "competence_check": json.loads((HERE.parent / "tr4.json").read_text())["competence_check"],
                  "sensitivity_at_frozen_size": {r["agent"]: {k: v for k, v in r["U=60"].items()
                                                              if k.startswith("P_contradicted")} for r in rows}}
    print("tr4 done", round(time.time() - t0, 1), flush=True)
    out["tr5"] = tr5_power()
    print("tr5 done", round(time.time() - t0, 1), flush=True)
    out["usage"] = usage(out["tr5"][f"episodes={T5.E_EP}"]["rows"])
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "power.json").write_text(json.dumps(out, indent=1) + "\n", encoding="utf-8")
    print("written in", round(time.time() - t0, 1), "seconds")
    return 0


if __name__ == "__main__":
    sys.exit(main())
