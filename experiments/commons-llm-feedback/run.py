"""Run LA1 (PREDICTIONS-2026-10-22.md): Haiku chooses a threshold, sees the results, and chooses again.

    python3 run.py all      # 6 conditions x 5 seeds x 7 calls; resumes from results/calls.jsonl
    python3 run.py smoke    # every code path with a scripted agent in place of the model; nothing kept

Each seed: round 0 is a choice with no results; after each of rounds 1..6 the agent sees the mean
reward, apples harvested and apples standing at the end over 20 episodes played with its threshold
against the rest (always-harvesters), on fresh regrowth streams; the seventh answer is its final choice.
"""

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(HERE, "..", "commons-outrun"))
sys.path.append(os.path.join(HERE, "..", "commons-gated-renewal"))
from commons import Commons, isolated_layout  # noqa: E402
from calibrate import table  # noqa: E402

import agent  # noqa: E402
from values import CONDITIONS  # noqa: E402

SEEDS, ROUNDS, EPISODES, H = 5, 6, 20, 100


def play(cond, m, tag):
    k = cond["k"]
    tot = dict(reward=0.0, apples=0.0, end=0.0)
    for e in range(EPISODES):
        env = Commons(isolated_layout(1), f"{tag}/{e}", table=table(cond["s"]))
        env.reset(full=True)
        apples = 0
        for _t in range(H):
            x = env.level(0)
            req = ([0] if x > m else []) + list(range(1, k))
            _tk, _gv, got = env.step([req])
            apples += sum(1 for i in got if i == 0)
        end = env.level(0)
        tot["reward"] += apples + cond["lam"] * end
        tot["apples"] += apples
        tot["end"] += end
    return {key: v / EPISODES for key, v in tot.items()}


def seed_run(name, cond, seed, chooser):
    history, choices = [], []
    for rnd in range(ROUNDS + 1):
        final = rnd == ROUNDS
        m = chooser(name, cond, seed, rnd, history, final)
        choices.append(m)
        if final:
            break
        res = play(cond, m if m is not None else 0, f"la1/{name}/{seed}/{rnd}")
        history.append(dict(m=m if m is not None else 0, **res))
    return dict(cond=name, seed=seed, choices=choices, history=history)


def main(argv):
    mode = argv[1] if len(argv) > 1 else "all"
    out = []
    if mode == "smoke":
        scripted = lambda name, cond, seed, rnd, history, final: (rnd * 3) % 10
        for name, cond in CONDITIONS.items():
            r = seed_run(name, cond, 0, scripted)
            print(name, r["choices"], [round(h["reward"], 1) for h in r["history"]])
        print(agent.prompt(CONDITIONS["k3s1"], r["history"][:2], False))
        return
    cache = agent.load_cache()
    chooser = lambda name, cond, seed, rnd, history, final: agent.choose(name, cond, seed, rnd, history, final, cache)
    for name, cond in CONDITIONS.items():
        for seed in range(SEEDS):
            out.append(seed_run(name, cond, seed, chooser))
            print(name, seed, out[-1]["choices"], flush=True)
    json.dump(dict(model=agent.MODEL, runs=out), open(os.path.join(HERE, "results", "runs.json"), "w"), indent=1)


if __name__ == "__main__":
    main(sys.argv)
