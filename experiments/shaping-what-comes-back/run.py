"""Run LA3 (PREDICTIONS-2026-10-25.md): Haiku chooses a policy, sees its lineage's scores, and chooses again.

    python3 run.py all      # 6 conditions x 5 seeds x 6 calls; resumes from results/calls.jsonl
    python3 run.py smoke    # every code path with a scripted agent in place of the model; nothing kept

Each seed: round 0 is a choice with no results; after each of rounds 1..5 the agent sees that round's
mean score (20 runs of 3 generations from 100 members, on a stream fixed by condition, seed and round);
the sixth answer is its final choice.  An answer with no valid policy is asked again once; a played
round with no valid policy after that is played with an assigned policy (S in even rounds, N in odd
ones), shown to the agent as assigned; a final choice with no valid policy counts against the
prediction.
"""

import json
import os
import random
import re
import sys
import tempfile

import agent
import analyze
import scripted
from game import CONDITIONS, play

HERE = os.path.dirname(os.path.abspath(__file__))
SEEDS, ROUNDS = 5, 5


def seed_run(name, cond, seed, chooser):
    history, choices = [], []
    for rnd in range(ROUNDS + 1):
        final = rnd == ROUNDS
        policy = chooser(name, seed, rnd, history, final)
        choices.append(policy)
        if final:
            break
        played = policy if policy is not None else ("S" if rnd % 2 == 0 else "N")
        history.append(dict(policy=played, chosen=policy is not None,
                            score=play(cond, played, f"la3/{name}/{seed}/{rnd}")))
    return dict(cond=name, seed=seed, choices=choices, history=history)


def scripted_chooser(fn, tag):
    def chooser(name, seed, rnd, history, final):
        rng = random.Random(f"{tag}/{name}/{seed}/{rnd}")
        return fn(rnd, history, final, rng)
    return chooser


def game_hash(text):
    import hashlib
    return hashlib.sha256(text.encode()).hexdigest()


def smoke_calls():
    """agent.choose, its cache, re-ask and assigned rounds, with a scripted stand-in for the CLI that follows
    the scores in the prompt; the verdict code on the result; files in a scratch folder."""
    state = dict(n=0)
    asked = {}

    def fake_call(text):
        state["n"] += 1
        h = int(game_hash(text), 16)
        asked[h] = asked.get(h, 0) + 1
        if h % 9 == 0 and asked[h] <= 2:          # for one prompt in nine, two answers without a policy
            return 0, "Both policies seem reasonable to me.", ""
        if h % 9 == 1 and asked[h] == 1:          # for another, one: asked again
            return 0, "Hard to say from this.", ""
        seen = {}
        for pol, score in re.findall(r"Round \d+: ([SN])(?: \([^)]*\))?; mean score (\d+(?:\.\d+)?)", text):
            seen.setdefault(pol, []).append(float(score))
        if len(seen) == 2:
            choice = max(seen, key=lambda k: sum(seen[k]) / len(seen[k]))
        else:
            choice = "N" if "S" in seen else "S"
        return 0, f"Comparing the rounds so far.\npolicy = **{choice}**", ""

    with tempfile.TemporaryDirectory() as d:
        agent.CALLS, agent.call = os.path.join(d, "calls.jsonl"), fake_call
        cache = {}
        chooser = lambda name, seed, rnd, history, final: agent.choose(name, seed, rnd, history, final, cache)
        runs = [seed_run(n, c, s, chooser) for n, c in CONDITIONS.items() for s in range(SEEDS)]
        v = analyze.verdicts(runs, analyze.predicted())
        for n, c in v["conditions"].items():
            print(f"{n:8} final {c['final']} -> {c['verdict']}; H1-LA3 {'holds' if c['H1_holds'] else 'low'}")
        print("contrasts", v["contrasts"])
        print("assigned rounds", sum(1 for r in runs for h in r["history"] if not h["chosen"]),
              "| calls made", state["n"], "| records", sum(1 for _ in open(agent.CALLS)),
              "| cache reloaded", len(agent.load_cache()))


def main(argv):
    mode = argv[1] if len(argv) > 1 else "all"
    if mode == "smoke":
        chooser = scripted_chooser(scripted.AGENTS["follower"], "smoke")
        for name, cond in CONDITIONS.items():
            r = seed_run(name, cond, 0, chooser)
            print(f"{name:8} choices {r['choices']} scores {[round(h['score'], 1) for h in r['history']]}")
        print(agent.prompt(r["history"][:2], False))
        print("parse:", agent.parse("I compare the two.\npolicy = **N**"), agent.parse("Policy = S"),
              agent.parse("no choice"))
        print("failed:", agent.failed(0, "", True), agent.failed(0, "API Error: 529", True),
              agent.failed(0, "I cannot tell yet.", True), agent.failed(1, "policy = S", False))
        smoke_calls()
        return
    cache = agent.load_cache()
    chooser = lambda name, seed, rnd, history, final: agent.choose(name, seed, rnd, history, final, cache)
    out = []
    for name, cond in CONDITIONS.items():
        for seed in range(SEEDS):
            out.append(seed_run(name, cond, seed, chooser))
            print(name, seed, out[-1]["choices"], flush=True)
    json.dump(dict(model=agent.MODEL, runs=out), open(os.path.join(HERE, "results", "runs.json"), "w"), indent=1)


if __name__ == "__main__":
    main(sys.argv)
