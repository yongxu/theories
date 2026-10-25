"""Power check of LA2, run before the freeze (no model): can the judge's picks resolve what the verdicts ask?

    python3 power.py      # writes results/power.json (a few minutes, one core)

The whole protocol (5 conditions, 5 seeds, the loop of loop.course) with each scripted judge of
scripted.MODELS in place of the model, REPS times per model, scored by analyze.verdicts.  A judge's
ten picks in a call are drawn independently or, for the clumped judges, a whole call is answered alike
half the time; a prompt met twice in a replication gives the same picks, as two conditions sharing a
call do in the run.  Reported per model: the probability that each condition and each contrast passes,
how the failures are labelled, how often the control (in_time_unread) is kept and how often it turns in
at least 4 of its 5 seeds, how often each measure is resolved, and how often each frozen rule of what
the verdicts support holds.  The pool models are the premise of the predictions at several strengths,
down to readings near even; the others are the rival accounts.
"""

import json
import os
import random

import analyze
import loop
import scripted
from run import SEEDS

HERE = os.path.dirname(os.path.abspath(__file__))
REPS, POOL_SIZE = 2000, 24
VERDICT_CONDITIONS = [c for c in loop.CONDITIONS if analyze.PREDICTED[c] is not None]


def main():
    out = dict(REPS=REPS, models={})
    for name, (model, clump) in scripted.MODELS.items():
        rng = random.Random(f"power/{name}")
        cond_pass = {c: 0 for c in VERDICT_CONDITIONS}
        con_pass = {k: 0 for k in analyze.CONTRASTS}
        seed_hit = {c: 0 for c in VERDICT_CONDITIONS}
        labels = {c: {} for c in VERDICT_CONDITIONS}
        control = dict(kept=0, turned=0)
        measured = {k: 0 for k in analyze.MEASURES}
        support = {}
        for _ in range(REPS):
            read = scripted.reader(model, rng, shared={}, clump=clump)
            runs = [loop.course(c, seed, read, POOL_SIZE) for c in loop.CONDITIONS for seed in range(SEEDS)]
            for r in runs:
                if r["cond"] in seed_hit:
                    seed_hit[r["cond"]] += analyze.seed_hit(r)
            v = analyze.verdicts(runs)
            for c in VERDICT_CONDITIONS:
                cond_pass[c] += v["conditions"][c]["verdict"] == "passed"
                lab = v["conditions"][c]["label"]
                if lab:
                    labels[c][lab] = labels[c].get(lab, 0) + 1
            for k in analyze.CONTRASTS:
                con_pass[k] += v["contrasts"][k]
            control["kept"] += v["conditions"]["in_time_unread"]["kept_seeds"] >= 4
            control["turned"] += v["conditions"]["in_time_unread"]["turned_seeds"] >= 4
            for k in analyze.MEASURES:
                measured[k] += v["measures"][k]["resolved"]
            for k, held in v["supports"].items():
                support[k] = support.get(k, 0) + held
        out["models"][name] = dict(
            clump=clump,
            P_seed_as_predicted={c: seed_hit[c] / (REPS * SEEDS) for c in VERDICT_CONDITIONS},
            P_condition_passes={c: cond_pass[c] / REPS for c in VERDICT_CONDITIONS},
            P_contrast_passes={k: con_pass[k] / REPS for k in analyze.CONTRASTS},
            failure_labels={c: {lab: n / REPS for lab, n in d.items()} for c, d in labels.items() if d},
            P_control_kept_in_4_of_5=control["kept"] / REPS,
            P_control_turned_in_4_of_5=control["turned"] / REPS,
            P_measure_resolved={k: measured[k] / REPS for k in analyze.MEASURES},
            P_supported={k: n / REPS for k, n in support.items()})
        print(f"{name:29} contrasts " + " ".join(f"{k[:2]}:{con_pass[k] / REPS:.3f}" for k in analyze.CONTRASTS)
              + f" | control kept {control['kept'] / REPS:.3f} turned {control['turned'] / REPS:.3f} | measures "
              + " ".join(f"{k.split('_')[0]}:{measured[k] / REPS:.3f}" for k in analyze.MEASURES), flush=True)
    json.dump(out, open(os.path.join(HERE, "results", "power.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
