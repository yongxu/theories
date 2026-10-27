"""The power check of LA1c, run before the freeze: what the feedback resolves, and what the frozen rules give for
scripted agents.

    python3 power.py      # writes results/power.json (about a quarter of an hour, one core)

1. Resolution of neighbouring thresholds at 10,000 episodes.  For each condition and each pair m, m + 1: z, the
   exact gap over the standard deviation of the difference of two rounds' means (each threshold's episode spread
   as estimated in LA1b's values.py), and how often the worse of the two shows a mean reward at least the better's
   (two decimals, as shown), from the normal approximation with a slack of 0.01 for the rounding.  LA1b bounds the
   locked gap between m = 0 and m = 1 without the approximation (its power.json); the game and the round are the
   same here.
2. The normal approximation checked on the open side, where LA1b did not check it: in k3s16's valley, how often a
   round at m = 4 shows at least the mean reward of a round at m = 3, from 1,000 pairs of simulated rounds of 500
   episodes, against the normal value.
3. The frozen rules for each scripted agent (scripted.py) over REPS replications of the whole design, each round's
   mean drawn as normal around the exact value with the episode's spread over the square root of 10,000, rounded
   to two decimals as the prompt shows it: how often the prediction passes on each side, each reading is supported
   or contradicted, unresolved gives each reason, and LA1's verdicts and contrasts pass; the mean of each measure
   and of the seeds at the best threshold in each condition.

results/power.json carries the hashes of the files its numbers depend on (analyze.POWER_SOURCES); `run.py smoke`
says whether they are the files as they are now, and `run.py all` refuses to start where they are not.
"""

import json
import math
import os
import random

import analyze
import run
import scripted
from game import CONDITIONS, EPISODES, SEEDS, play

HERE = os.path.dirname(os.path.abspath(__file__))
REPS, PAIRS, PAIR_EPISODES = 2000, 1000, 500
MEANS = ("R", "R_left", "R_descending", "R_stopped", "R_seen", "R_left_held", "R_left_new_at_7", "R_never_moved",
         "R_named_below", "invalid_locked", "locked_first_at_0", "locked_best_played", "open_miss", "O_left",
         "O_left_up", "O_left_down", "O_hill", "O_valley", "O_valley_named_on_hill", "O_left_held", "O_left_new_at_7",
         "invalid_open", "open_first_at_7", "open_best_played", "open_on_hill", "open_at_0")


def normal_player(vals, rng):
    def player(cond, m, tag):
        name = next(n for n, c in CONDITIONS.items() if c is cond)
        mu, sd = vals[name]["values"][m], vals[name]["episode_sd"][m] / math.sqrt(EPISODES)
        return dict(reward=rng.gauss(mu, sd), apples=0.0, end=0.0)
    return player


def phi(z):
    return 0.5 * (1 + math.erf(z / math.sqrt(2)))


def neighbours(vals):
    out = {}
    for n in CONDITIONS:
        v, sd = vals[n]["values"], vals[n]["episode_sd"]
        rows = []
        for m in range(9):
            gap, s = abs(v[m] - v[m + 1]), math.sqrt((sd[m] ** 2 + sd[m + 1] ** 2) / EPISODES)
            rows.append(dict(pair=[m, m + 1], better=m if v[m] > v[m + 1] else m + 1, z=gap / s,
                             wrong_order=analyze.wrong_order(vals, n, m, m + 1)))
        out[n] = rows
    return out


def normality(vals):
    n, c, (lo, hi) = "k3s16", CONDITIONS["k3s16"], (3, 4)
    sim = [(round(play(c, hi, f"la1c-power/normality/{i}/{hi}", PAIR_EPISODES)["reward"], 2),
            round(play(c, lo, f"la1c-power/normality/{i}/{lo}", PAIR_EPISODES)["reward"], 2)) for i in range(PAIRS)]
    v, sd = vals[n]["values"], vals[n]["episode_sd"]
    z = (v[lo] - v[hi]) / math.sqrt((sd[lo] ** 2 + sd[hi] ** 2) / PAIR_EPISODES)
    return dict(condition=n, thresholds=[lo, hi], episodes=PAIR_EPISODES, pairs=PAIRS,
                simulated=sum(1 for a, b in sim if a >= b) / PAIRS, normal=1 - phi(z))


def add(d, k, x):
    d[k] = d.get(k, 0) + x


def agents(vals):
    out = {}
    for name in scripted.AGENTS:
        tally = dict(prediction={}, conditions={}, at_best={}, on_hill={}, contrasts={},
                     readings=dict(locked={}, open={}), contradicted=dict(locked={}, open={}),
                     unresolved_because=dict(locked={}, open={}), means={k: 0.0 for k in MEANS})
        for rep in range(REPS):
            rng = random.Random(f"la1c-power/{name}/{rep}")
            chooser = scripted.chooser(name, f"la1c-power/{rep}")
            player = normal_player(vals, rng)
            runs = [run.seed_run(n, c, s, chooser, player) for n, c in CONDITIONS.items() for s in range(SEEDS[n])]
            v = analyze.verdicts(runs, vals)
            for k, x in v["prediction"].items():
                add(tally["prediction"], k, x)
            for n, d in v["conditions"].items():
                add(tally["conditions"], n, d["verdict"] == "passed")
                add(tally["at_best"], n, d["at_best"])
                if d["on_hill"] is not None:
                    add(tally["on_hill"], n, d["on_hill"])
            for k, x in v["contrasts"].items():
                add(tally["contrasts"], k, x)
            for side, rs in v["readings"].items():
                for k, r in rs.items():
                    add(tally["readings"][side], k, r["supported"])
                    add(tally["contradicted"][side], k, r["contradicted"])
                    for why in r.get("because", []):
                        add(tally["unresolved_because"][side], why, 1)
            for k in MEANS:
                tally["means"][k] += v["measures"][k]
        o = {part: ({side: {k: x / REPS for k, x in dd.items()} for side, dd in d.items()}
                    if part in ("readings", "contradicted", "unresolved_because") else {k: x / REPS for k, x in d.items()})
             for part, d in tally.items()}
        out[name] = o
        p, c, m = o["prediction"], o["contrasts"], o["means"]
        best = {cls: sum(x for n, x in o["at_best"].items() if CONDITIONS[n]["lock"] == cls) for cls in ("locked", "open")}
        print(f"{name:15} S {p['selection_locked']:.3f}/{p['selection_open']:.3f}"
              f" best {best['locked']:.2f}/{best['open']:.2f}"
              f" L1 {c['L1_locked_side']:.3f} L2 {c['L2_open_side']:.3f}"
              f" R {m['R']:.2f} (L {m['R_left']:.2f} D {m['R_descending']:.2f} S {m['R_stopped']:.2f})"
              f" O {m['open_miss']:.2f} (L {m['O_left']:.2f} H {m['O_hill']:.2f} V {m['O_valley']:.2f}) | "
              + " ".join(f"{k} {x:.3f}" for k, x in o["readings"]["locked"].items() if x) + " | "
              + " ".join(f"{k} {x:.3f}" for k, x in o["readings"]["open"].items() if x), flush=True)
    return out


def main():
    vals = analyze.load_values()
    out = dict(reps=REPS, sources=analyze.sources(), neighbours=neighbours(vals))
    for n, rows in out["neighbours"].items():
        print(n, [(r["pair"], round(r["z"], 1), f"{r['wrong_order']:.2g}") for r in rows], flush=True)
    out["normality"] = normality(vals)
    print("normality", out["normality"], flush=True)
    out["agents"] = agents(vals)
    json.dump(out, open(os.path.join(HERE, "results", "power.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
