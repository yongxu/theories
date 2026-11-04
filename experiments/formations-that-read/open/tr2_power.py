"""TR2 Stage B's power check at the frozen choices: exact, with no model, no torch and no download.

    python3 -B tr2_power.py        # writes results/power.json

What it computes, each from the frozen rule (tr2_rule.py) and Stage 0's exact tests (tr2.py, unchanged):
- **The sampled acts.** Under the shared draw a content's two arms are coupled monotonically, so a
  factor's minority share of discordant pairs is the share of its shift running against the mean. The
  power at 0.05/4 to show a mean shift of 5 points, by minority share and size: N_B = 1,600 is the
  least size of Stage 0's grid with power 0.9 at every share up to 0.4, the worst the rates 10% and 15%
  allow; at a base of 30% or 50% the worst coupling allows more, and the power at 1,600 is given too.
- **The positive control.** The pilot's 400 pairs, read at 0.05: the power to show a one-way shift of
  2, 3, 5 and 10 points.
- **The probe.** 200 held-out pairs at each layer, Holm over the layers at 0.01: at the first step a
  rejection needs the least count whose one-sided tail is at most 0.01/L for L states (37 for Qwen3-8B,
  33 for Olmo-3 7B), so the power at a pair accuracy a is P(Bin(200, a) >= that count); the least
  accuracy with power 0.9 there bounds what the probe can miss at every step. The control (the
  identical arm against base) is one test for the four factors: with no signal it voids them all in at
  most 0.01 of runs, and under exact passes it cannot reject (its states equal base's, so no pair is
  ordered).
- **Coverage**, exact (no sampling enters it): its values at the two lumpings a factor can have, the
  factor's arm in base's lump and apart from it.
- **Usage.** Passes per phase and checkpoint, the prompts' words, the states kept and their bytes, the
  files Ren's yes downloads; the time per pass is measured by the smoke run, and is projected here at
  seven rates. A pass is a prefill of about 100 to 200 tokens through about 8 billion parameters, some
  2.5e12 floating-point operations, so a second or less on a GPU that sustains a few teraflops, and
  several to tens of seconds on a CPU in bfloat16, where a checkpoint's run may take a day or more;
  the smoke run decides.
"""

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
import tr2 as S0                                        # noqa: E402  Stage 0's exact tests, unchanged
import tr2_conditions as C                                  # noqa: E402
import tr2_plan as P                                        # noqa: E402
import tr2_rule as RU                                       # noqa: E402

STATES = {"qwen": 37, "olmo": 33}                       # hidden states at the last position: embeddings and each layer
HIDDEN = {"qwen": 4096, "olmo": 4096}
TEST_PAIRS = C.STATE_N // 2


def least_count(n, alpha):
    """The least k with P(Bin(n, 1/2) >= k) <= alpha."""
    pm = S0.binom_pmf_list(n, 0.5)
    tail = 0.0
    for k in range(n, -1, -1):
        tail += pm[k]
        if tail > alpha:
            return k + 1
    return 0


def tail_at(n, a, k):
    return sum(S0.binom_pmf_list(n, a)[k:])


def probe_power():
    out = {}
    for fam, L in STATES.items():
        first = least_count(TEST_PAIRS, RU.ALPHA_PROBE / L)
        last = least_count(TEST_PAIRS, RU.ALPHA_PROBE)
        acc = [x / 1000 for x in range(500, 1001)]
        a90 = next(a for a in acc if tail_at(TEST_PAIRS, a, first) >= 0.9)
        out[fam] = {"states": L, "pairs_held_out": TEST_PAIRS,
                    "count_needed_first_step": first, "count_needed_last_step": last,
                    "power_at_accuracy": {str(a): round(tail_at(TEST_PAIRS, a, first), 4)
                                          for a in (0.55, 0.6, 0.65, 0.7, 0.75)},
                    "least_accuracy_power_0.9_first_step": a90}
    return out


def usage():
    m = json.loads((HERE / "MODELS.json").read_text(encoding="utf-8"))
    per = {ph: P.passes(ph) for ph in P.PHASES}
    per["all"] = sum(per.values())
    kept = sum(len(g["arms"]) for g in P.phase_groups("main") if g["keep_state"])
    rows, total = {}, 0
    for ck in m["checkpoints"]:
        fam = ck["family"]
        size = sum(f["size"] for f in ck["files"])
        total += size
        rows[ck["id"]] = {"files": len(ck["files"]), "bytes": size, "weights_bytes": ck["weights_bytes"],
                          "states_kept": kept,
                          "state_bytes": kept * STATES[fam] * HIDDEN[fam] * 4}
    hours = {f"{s} s a pass": round(per["all"] * s / 3600, 1) for s in (0.25, 0.5, 1.0, 2.0, 5.0, 10.0, 30.0)}
    words = {}
    for ph in P.PHASES:
        w = [len(C.body(C.CONTENTS[g["content"]], arm, "choice" if g["kind"] == "pilot" else g["kind"]).split()) + 1
             for g in P.phase_groups(ph) for arm in g["arms"]]
        words[ph] = [min(w), max(w)]
    return {"passes_per_checkpoint": per, "prompt_words_with_answer": words, "checkpoints": rows,
            "download_bytes": total,
            "state_bytes_in_all": sum(r["state_bytes"] for r in rows.values()),
            "passes_in_all": per["all"] * len(rows),
            "hours_per_checkpoint_at": hours,
            "time": "measured by each checkpoint's smoke run (seconds a pass, projected for every phase)"}


def main():
    alpha = RU.ALPHA_ACTS / len(C.FACTOR_IDS)
    out = {
        "what": "TR2 Stage B's power check at the frozen choices; exact, no model, no download",
        "sampled_acts": {"alpha": alpha, "shift": RU.SHIFT, "pairs": RU.PAIRS,
                         "least_pairs_power_0.9_every_share": RU.least_pairs(),
                         "power_by_minority_share": RU.power_table(),
                         "power_at_pairs_by_base_worst_coupling": RU.base_rate_power()},
        "positive_control": {"pairs": len(C.PILOT), "alpha": RU.ALPHA_ACTS,
                             "power_one_way": {str(d): round(S0.power_discordant(len(C.PILOT), d, 0.0, RU.ALPHA_ACTS), 4)
                                               for d in (0.02, 0.03, 0.05, 0.10)}},
        "probe": probe_power(),
        "probe_control": {"false_void_at_most": RU.ALPHA_PROBE,
                          "under_exact_passes": "cannot reject: the identical arm's states equal base's"},
        "coverage": {"arm in base's lump": dict(zip(("S1", "S2", "S3"), map(lambda x: round(x, 4),
                                                                                RU.coverage(True, True, True)))),
                     "arm apart from base": dict(zip(("S1", "S2", "S3"), map(lambda x: round(x, 4),
                                                                              RU.coverage(False, False, True))))},
        "usage": usage(),
    }
    ok = (out["sampled_acts"]["least_pairs_power_0.9_every_share"] == RU.PAIRS
          and min(out["sampled_acts"]["power_by_minority_share"][s][RU.PAIRS] for s in out["sampled_acts"]["power_by_minority_share"]) >= 0.9)
    out["ok"] = ok
    (HERE / "results").mkdir(exist_ok=True)
    (HERE / "results" / "power.json").write_text(json.dumps(out, indent=1) + "\n", encoding="utf-8")
    print(json.dumps(out, indent=1))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
