"""Run LA1b (PREDICTIONS-2026-10-27.md): Haiku chooses a threshold, sees results that resolve it, and chooses again.

    python3 run.py all      # 40 seeds (5 per condition, 15 in k3s8) x 5 calls; resumes from results/calls.jsonl
    python3 run.py smoke    # every code path with scripted agents in place of the model; nothing kept

Each seed: the agent's first answer, given no results, is played in round 1; rounds 2-4 are assigned
(m = 0, 1 and 6 in the seed's order, game.ORDERS); the agent's next three answers are played in rounds
5-7, each given every round before it; its fifth answer is its final choice.  A round is 10,000 episodes
on streams fixed by condition, seed and round, so a resumed run shows the agent exactly what it was shown.
An answer with no valid choice is asked again once; a played round whose answer still has none is played
with the threshold of the round before it (round 1: m = 4), shown to the agent as assigned; a final choice
with none counts against the prediction.  Before its first call, `all` checks that the CLI is the version
pinned (LA1's) and that every file the run depends on is in the freeze commit (results/FROZEN-AT) and
unchanged since (analyze.check_freeze); every answer it records, and runs.json, carry that commit.
"""

import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
import time

import agent
import analyze
import scripted
from game import ASSIGNED_ROUNDS, CONDITIONS, ORDERS, ROUNDS, SEEDS, play

HERE = os.path.dirname(os.path.abspath(__file__))
CLI = "2.1.220"


def seed_run(name, cond, seed, chooser, player=play):
    history, answers = [], []
    for rnd in range(1, ROUNDS + 1):
        if rnd in ASSIGNED_ROUNDS:
            m, kind = ORDERS[seed % len(ORDERS)][rnd - ASSIGNED_ROUNDS[0]], "assigned"
        else:
            a = chooser(name, cond, seed, len(answers), history, False)
            answers.append(a)
            m, kind = (a, "chosen") if a is not None else ((history[-1]["m"] if history else 4), "fallback")
        history.append(dict(m=m, kind=kind, **player(cond, m, f"la1b/{name}/{seed}/{rnd}")))
    final = chooser(name, cond, seed, len(answers), history, True)
    answers.append(final)
    return dict(cond=name, seed=seed, answers=answers, final=final, history=history)


def fast_player(episodes):
    return lambda cond, m, tag: play(cond, m, tag, episodes)


def smoke_calls():
    """agent.choose, its cache, re-ask and fallback rounds, with a scripted stand-in for the CLI that follows
    the shown means; the verdict code on the result; rounds of 200 episodes; files in a scratch folder."""
    state, asked = dict(n=0), {}

    def fake_call(text):
        state["n"] += 1
        h = int(hashlib.sha256(text.encode()).hexdigest(), 16)
        asked[h] = asked.get(h, 0) + 1
        if h % 11 == 0 and asked[h] <= 2:         # for one prompt in eleven, two answers without a choice
            return 0, "Every threshold seems close to me.", ""
        if h % 11 == 1 and asked[h] == 1:         # for another, one: asked again
            return 0, "The sum = 3 here, hard to say.", ""
        means = {}
        for m, r in re.findall(r"Round \d+: m = (\d)(?: \([^)]*\))?; mean reward (\d+\.\d+)", text):
            means.setdefault(int(m), []).append(float(r))
        if not means:
            return 0, "No results yet; I start in the middle.\nm = **4**", ""
        choice = max(means, key=lambda m: sum(means[m]) / len(means[m]))
        return 0, f"The best mean so far.\nm = {choice}", ""

    with tempfile.TemporaryDirectory() as d:
        agent.CALLS, agent.call, agent.FROZEN = os.path.join(d, "calls.jsonl"), fake_call, "smoke"
        cache = {}
        chooser = lambda name, cond, seed, answer, history, final: agent.choose(name, cond, seed, answer, history,
                                                                               final, cache)
        runs = [seed_run(n, c, s, chooser, fast_player(200)) for n, c in CONDITIONS.items()
                for s in range(SEEDS[n])]
        v = analyze.verdicts(runs, analyze.load_values())
        for n, c in v["conditions"].items():
            print(f"{n:11} final {c['final']} -> {c['verdict']}")
        print("contrasts", v["contrasts"])
        print("measures", {k: v["measures"][k] for k in ("R", "R_small", "R_small_held", "R_new_at_7", "open_short",
                                                         "open_at_0", "invalid_finals", "locked_first_at_0",
                                                         "locked_seeds")})
        print("readings", {k: r["supported"] for k, r in v["readings"].items()})
        print("fallback rounds", sum(1 for r in runs for h in r["history"] if h["kind"] == "fallback"),
              "| invalid finals", sum(1 for r in runs if r["final"] is None),
              "| calls made", state["n"], "| records", sum(1 for _ in open(agent.CALLS)),
              "| cache reloaded", len(agent.load_cache()))
        made, reloaded = state["n"], agent.load_cache()
        again = seed_run("k3s8", CONDITIONS["k3s8"], 3,
                         lambda name, cond, seed, answer, history, final: agent.choose(name, cond, seed, answer,
                                                                                      history, final, reloaded),
                         fast_player(200))
        first = next(r for r in runs if r["cond"] == "k3s8" and r["seed"] == 3)
        print("a resumed seed replays its answers from the cache, its prompts unchanged, without a call:",
              again["answers"] == first["answers"] and state["n"] == made)
        key = ("k3s8", 3, 1)
        reloaded[key] = dict(reloaded[key], prompt=reloaded[key]["prompt"] + " ")
        try:
            seed_run("k3s8", CONDITIONS["k3s8"], 3,
                     lambda name, cond, seed, answer, history, final: agent.choose(name, cond, seed, answer, history,
                                                                                  final, reloaded),
                     fast_player(200))
            print("a cached answer to another prompt is refused: False")
        except RuntimeError as e:
            print("a cached answer to another prompt is refused:", "another prompt" in str(e))
        agent.FROZEN = "another freeze"
        try:
            agent.load_cache()
            print("answers made under another freeze are refused: False")
        except RuntimeError as e:
            print("answers made under another freeze are refused:", "never reused" in str(e))


def check_cli():
    """Before any call: the CLI is the pinned version."""
    version = subprocess.run(["claude", "--version"], capture_output=True, text=True).stdout.strip()
    if version.split()[:1] != [CLI]:
        raise SystemExit(f"claude {version!r}: the run is pinned to {CLI}; a run on another version is a "
                         "deviation, recorded in README.md before the run")
    return version


def main(argv):
    mode = argv[1] if len(argv) > 1 else "all"
    if mode == "smoke":
        name = "k3s8"
        t = time.time()
        r = seed_run(name, CONDITIONS[name], 0, scripted.chooser("follower_explore0.5", "smoke"))
        print(f"{name} seed 0, the follower, rounds of 10,000 episodes ({time.time() - t:.0f} s): answers "
              f"{r['answers']}, rounds {[(h['m'], h['kind'][0], round(h['reward'], 2)) for h in r['history']]}")
        print(agent.prompt(CONDITIONS[name], r["history"][:4], False))
        print("parse:", agent.parse("so\nm = **0**"), agent.parse("**m** = 1"), agent.parse("m = $2$"),
              agent.parse("M = 3"), agent.parse("the sum = 3"), agent.parse("m = 12"), agent.parse("no choice"))
        print("failed:", agent.failed(0, "", True), agent.failed(0, "API Error: 529", True),
              agent.failed(0, "I cannot tell yet.", True), agent.failed(1, "m = 0", False))
        import importlib.util
        spec = importlib.util.spec_from_file_location("la1_agent", os.path.join(HERE, "..", "commons-llm-feedback",
                                                                                "agent.py"))
        la1_agent = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(la1_agent)
        same = all(agent.prompt(c, [], False) == la1_agent.prompt(c, [], False) for c in CONDITIONS.values())
        print("first prompt word for word LA1's in every condition:", same)
        print("reading rules: exactly one supported, never supported and contradicted, unresolved with its "
              f"reason, in {analyze.check_rules()} cases")
        smoke_calls()
        return
    version = check_cli()
    agent.FROZEN = analyze.check_freeze()
    cache = agent.load_cache()
    chooser = lambda name, cond, seed, answer, history, final: agent.choose(name, cond, seed, answer, history,
                                                                           final, cache)
    out = []
    for name, cond in CONDITIONS.items():
        for seed in range(SEEDS[name]):
            out.append(seed_run(name, cond, seed, chooser))
            print(name, seed, out[-1]["answers"], flush=True)
    json.dump(dict(model=agent.MODEL, cli=version, frozen=agent.FROZEN, runs=out),
              open(os.path.join(HERE, "results", "runs.json"), "w"), indent=1)


if __name__ == "__main__":
    main(sys.argv)
