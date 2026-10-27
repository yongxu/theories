"""The power check of LA1b, run before the freeze: what the frozen rules give for scripted agents.

    python3 power.py      # writes results/power.json (about twenty minutes, one core)

1. Resolution at 10,000 episodes.  For each locked condition, how often a round at m = 1 shows a mean reward
   at least that of a round at m = 0 (two decimals, as shown), at most: from the normal approximation below,
   with a slack of 0.01 for the rounding; and without it, by Bernstein's inequality, with an episode's reward
   in [0, 100] (one apple a step at most) wherever the patch is empty after the last step, each threshold's
   spread as estimated in values.py, and the same slack; plus the chance that some episode of the two rounds
   ends with an apple
   standing, at most 10,000 x the sum of E[apples standing after the last step] at m = 0 and m = 1, from
   CG2's exact programme with the end reading alone (expected_end).
2. The normal approximation, checked in the middle of its range: at 500 episodes in k3s8, the same
   probability from 300 pairs of simulated rounds against the normal value.
3. LA1 replayed under its own feedback: each of LA1's locked seeds keeps the thresholds it played, each round
   is redrawn as 20 episodes from simulated episodes, and the final choice is the best seen (the highest mean
   of the shown means, ties at random).  How many of the 20 locked seeds such a reader of its feedback ends
   off m = 0, against the 4 LA1 saw, and among the 18 that played m = 0, against 3.  A reading of LA1's
   data, not of LA1b's rules.
4. The frozen rules for each scripted agent (scripted.py) over REPS replications of the whole design, each
   round's mean drawn as normal around the exact value with the episode's spread over the square root of
   10,000 (values.py), rounded to two decimals as the prompt shows it.
"""

import json
import math
import os
import random

import analyze
import run
import scripted
from game import CONDITIONS, EPISODES, SEEDS, episode, la1, play

HERE = os.path.dirname(os.path.abspath(__file__))
REPS, BANK, REPLAYS, PAIRS = 2000, 5000, 4000, 300
LOCKED = [n for n, c in CONDITIONS.items() if c["lock"] == "locked"]
LA1_RUNS = json.load(open(os.path.join(HERE, "..", "commons-llm-feedback", "results", "runs.json")))["runs"]


def normal_player(vals, rng):
    def player(cond, m, tag):
        name = next(n for n, c in CONDITIONS.items() if c is cond)
        mu, sd = vals[name]["values"][m], vals[name]["episode_sd"][m] / math.sqrt(EPISODES)
        return dict(reward=rng.gauss(mu, sd), apples=0.0, end=0.0)
    return player


def phi(z):
    return 0.5 * (1 + math.erf(z / math.sqrt(2)))


def expected_end(c, m):
    """E[apples standing after the last step] at threshold m: LA1's threshold_value with no harvest reward and
    an end weight of 1, so that nothing cancels."""
    cal, rest = la1.cal, c["k"] - 1
    P = cal.regrowth_probs(c["s"])
    V = [float(cal.POP[z]) for z in range(512)]
    for _tau in range(cal.H):
        W = cal.expect_regrowth(V, P)
        NV = [0.0] * 512
        for x in range(512):
            n = cal.POP[x]
            ss = cal.subsets(x, min(rest + (1 if n > m else 0), n))
            NV[x] = sum(W[x & ~t] for t in ss) / len(ss)
        V = NV
    return V[511]


def resolution(vals):
    out = {}
    for n in LOCKED:
        c, v, sd = CONDITIONS[n], vals[n]["values"], vals[n]["episode_sd"]
        gap, var = v[0] - v[1], sd[0] ** 2 + sd[1] ** 2
        t, b = gap - 0.01, 100.0 + gap
        end = [expected_end(c, m) for m in (0, 1)]
        out[n] = dict(normal=1 - phi(t / math.sqrt(var / EPISODES)),
                      bernstein=math.exp(-EPISODES * t * t / (2 * var + 2 * b * t / 3)),
                      expected_end=end, apple_standing_bound=EPISODES * sum(end))
        out[n]["bound"] = out[n]["bernstein"] + out[n]["apple_standing_bound"]
    return out


def normality(vals):
    n, c, N = "k3s8", CONDITIONS["k3s8"], 500
    sim = [(round(play(c, 1, f"la1b-power/normality/{i}/1", N)["reward"], 2),
            round(play(c, 0, f"la1b-power/normality/{i}/0", N)["reward"], 2)) for i in range(PAIRS)]
    v, sd = vals[n]["values"], vals[n]["episode_sd"]
    z = (v[0] - v[1]) / math.sqrt((sd[0] ** 2 + sd[1] ** 2) / N)
    return dict(condition=n, episodes=N, pairs=PAIRS, simulated=sum(1 for a, b0 in sim if a >= b0) / PAIRS,
                normal=1 - phi(z))


def la1_replay():
    locked = [r for r in LA1_RUNS if CONDITIONS[r["cond"]]["lock"] == "locked"]
    need = sorted({(r["cond"], h["m"]) for r in locked for h in r["history"]})
    bank = {(n, m): [episode(CONDITIONS[n], m, f"la1b-power/replay/{n}/{m}/{e}")[0] for e in range(BANK)]
            for n, m in need}
    rng, per = random.Random("la1b-power/replay"), {}
    for r in locked:
        off = 0
        for _ in range(REPLAYS):
            by = {}
            for h in r["history"]:
                by.setdefault(h["m"], []).append(round(sum(rng.choice(bank[(r["cond"], h["m"])])
                                                           for _ in range(20)) / 20, 2))
            s = {m: sum(x) / len(x) for m, x in by.items()}
            off += scripted.best(s, rng) != 0
        per[f"{r['cond']}/{r['seed']}"] = dict(p_off_m0=off / REPLAYS, played_m0=any(h["m"] == 0 for h in r["history"]),
                                               la1_final=r["choices"][-1])
    played = [p for p in per.values() if p["played_m0"]]
    return dict(per_seed=per, expected_off_m0=sum(p["p_off_m0"] for p in per.values()),
                observed_off_m0=sum(1 for p in per.values() if p["la1_final"] != 0),
                seeds_that_played_m0=len(played), expected_off_m0_among_them=sum(p["p_off_m0"] for p in played),
                observed_off_m0_among_them=sum(1 for p in played if p["la1_final"] != 0))


MEANS = ("R", "R_small", "R_small_held", "R_new_at_7", "open_short", "open_at_0", "locked_first_at_0")


def agents(vals):
    out = {}
    for name in scripted.AGENTS:
        tally = dict(conditions={n: 0 for n in CONDITIONS}, contrasts={}, readings={}, contradicted={},
                     means={k: 0.0 for k in MEANS}, unresolved_because={})
        for rep in range(REPS):
            rng = random.Random(f"la1b-power/{name}/{rep}")
            chooser = scripted.chooser(name, f"la1b-power/{rep}")
            player = normal_player(vals, rng)
            runs = [run.seed_run(n, c, s, chooser, player) for n, c in CONDITIONS.items() for s in range(SEEDS[n])]
            v = analyze.verdicts(runs, vals)
            for n, d in v["conditions"].items():
                tally["conditions"][n] += d["verdict"] == "passed"
            for k, x in v["contrasts"].items():
                tally["contrasts"][k] = tally["contrasts"].get(k, 0) + x
            for k, r in v["readings"].items():
                tally["readings"][k] = tally["readings"].get(k, 0) + r["supported"]
                tally["contradicted"][k] = tally["contradicted"].get(k, 0) + r["contradicted"]
                for why in r.get("because", []):
                    tally["unresolved_because"][why] = tally["unresolved_because"].get(why, 0) + 1
            for k in MEANS:
                tally["means"][k] += v["measures"][k]
        out[name] = {part: {k: x / REPS for k, x in d.items()} for part, d in tally.items()}
        o = out[name]
        print(f"{name:22} L1 {o['contrasts']['L1_locked_side']:.3f} L2 {o['contrasts']['L2_open_side']:.3f} "
              f"R {o['means']['R']:.2f} held {o['means']['R_small_held']:.2f} OS {o['means']['open_short']:.2f} | "
              + " ".join(f"{k} {x:.3f}" for k, x in o["readings"].items() if x), flush=True)
    return out


def main():
    vals = analyze.load_values()
    out = dict(reps=REPS, resolution=resolution(vals))
    print("resolution", json.dumps(out["resolution"]), flush=True)
    out["normality"] = normality(vals)
    print("normality", out["normality"], flush=True)
    out["la1_replay"] = la1_replay()
    print("LA1 replayed", {k: x for k, x in out["la1_replay"].items() if k != "per_seed"}, flush=True)
    out["agents"] = agents(vals)
    json.dump(out, open(os.path.join(HERE, "results", "power.json"), "w"), indent=1)


if __name__ == "__main__":
    main()
