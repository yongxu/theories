"""Run LA1c (PREDICTIONS-2026-10-28.md): Haiku chooses a threshold in each of seven rounds that resolve it, then a
final one, with no round assigned.

    python3 run.py all      # 40 seeds (5 per condition, 15 in k3s8) x 8 calls; resumes from results/calls.jsonl
    python3 run.py smoke    # every code path with scripted agents in place of the model; nothing kept

Each seed: the agent's first answer, given no results, is played in round 1; each of its next six answers is played
in the next round, given every round before it; its eighth answer is its final choice.  A round is 10,000 episodes
on streams fixed by condition, seed and round, so a resumed run shows the agent exactly what it was shown.  An
answer with no valid choice is asked again once; a played round whose answer still has none is played with the
threshold of the round before it (round 1: m = 4), shown to the agent as LA1b shows it; a final choice with none
counts against the prediction.  Before its first call, `all` checks that the CLI is the version pinned (LA1's and
LA1b's), that every file the run depends on is in the freeze commit (results/FROZEN-AT) and unchanged since
(analyze.check_freeze), and that results/power.json was made from the files as they are (analyze.sources); every
answer it records, and runs.json, carry that commit.
"""

import hashlib
import importlib.util
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
from game import CONDITIONS, ROUNDS, SEEDS, play

HERE = os.path.dirname(os.path.abspath(__file__))
CLI = "2.1.220"
FAILED = []     # the smoke run's checks that failed


def check(what, ok):
    print(f"{what}: {ok}")
    if not ok:
        FAILED.append(what)


def seed_run(name, cond, seed, chooser, player=play):
    history, answers = [], []
    for rnd in range(1, ROUNDS + 1):
        a = chooser(name, cond, seed, len(answers), history, False)
        answers.append(a)
        m, kind = (a, "chosen") if a is not None else ((history[-1]["m"] if history else 4), "fallback")
        history.append(dict(m=m, kind=kind, **player(cond, m, f"la1c/{name}/{seed}/{rnd}")))
    final = chooser(name, cond, seed, len(answers), history, True)
    answers.append(final)
    return dict(cond=name, seed=seed, answers=answers, final=final, history=history)


def fast_player(episodes):
    return lambda cond, m, tag: play(cond, m, tag, episodes)


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def smoke_calls():
    """agent.choose, its cache, re-ask and fallback rounds, with a scripted stand-in for the CLI that follows the
    shown means; the verdict code on the result; rounds of 200 episodes; files in a scratch folder."""
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
        top = max(means, key=lambda m: sum(means[m]) / len(means[m]))
        if "final" in text.splitlines()[-2]:
            return 0, f"The best mean so far.\nm = {top}", ""
        near = [m for m in (top - 1, top + 1) if 0 <= m <= 9 and m not in means]
        return 0, f"A neighbour of the best mean so far.\nm = {near[0] if near else top}", ""

    with tempfile.TemporaryDirectory() as d:
        agent.CALLS, agent.call, agent.FROZEN = os.path.join(d, "calls.jsonl"), fake_call, "smoke"
        cache = {}
        chooser = lambda name, cond, seed, answer, history, final: agent.choose(name, cond, seed, answer, history,
                                                                               final, cache)
        runs = [seed_run(n, c, s, chooser, fast_player(200)) for n, c in CONDITIONS.items()
                for s in range(SEEDS[n])]
        v = analyze.verdicts(runs, analyze.load_values())
        for n, c in v["conditions"].items():
            print(f"{n:11} final {c['final']} -> LA1's rule {c['verdict']}; at the best {c['at_best']} of {c['seeds']}")
        print("rates", v["rates"], "| prediction", v["prediction"])
        print("contrasts", v["contrasts"])
        print("measures", {k: v["measures"][k] for k in ("R", "R_left", "R_descending", "R_stopped", "R_seen",
                                                         "R_left_held", "R_left_new_at_7", "invalid_locked",
                                                         "locked_first_at_0", "open_miss", "O_left", "O_hill",
                                                         "O_valley", "invalid_open", "open_first_at_7")})
        print("misses", [(d["cond"], d["seed"], d["final"], d["kind"], d["played"]) for d in v["measures"]["misses"]])
        print("readings", {side: [k for k, r in rs.items() if r["supported"]] for side, rs in v["readings"].items()})
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
        check("a resumed seed replays its answers from the cache, its prompts unchanged, without a call",
              again["answers"] == first["answers"] and state["n"] == made)
        key = ("k3s8", 3, 1)
        reloaded[key] = dict(reloaded[key], prompt=reloaded[key]["prompt"] + " ")
        try:
            seed_run("k3s8", CONDITIONS["k3s8"], 3,
                     lambda name, cond, seed, answer, history, final: agent.choose(name, cond, seed, answer, history,
                                                                                  final, reloaded),
                     fast_player(200))
            check("a cached answer to another prompt is refused", False)
        except RuntimeError as e:
            check("a cached answer to another prompt is refused", "another prompt" in str(e))
        agent.FROZEN = "another freeze"
        try:
            agent.load_cache()
            check("answers made under another freeze are refused", False)
        except RuntimeError as e:
            check("answers made under another freeze are refused", "never reused" in str(e))


def power_current():
    """results/power.json carries the hashes of the files its numbers depend on, and they are the files as they are."""
    p = os.path.join(HERE, "results", "power.json")
    return os.path.exists(p) and json.load(open(p)).get("sources") == analyze.sources()


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
        r = seed_run(name, CONDITIONS[name], 0, scripted.chooser("search1_down", "smoke"))
        print(f"{name} seed 0, search1_down, rounds of 10,000 episodes ({time.time() - t:.0f} s): answers "
              f"{r['answers']}, rounds {[(h['m'], round(h['reward'], 2)) for h in r['history']]}")
        shown = r["history"][:3] + [dict(r["history"][3], kind="fallback")]
        print(agent.prompt(CONDITIONS[name], shown, False))
        check("parse", [agent.parse(t) for t in ("so\nm = **0**", "**m** = 1", "m = $2$", "M = 3", "the sum = 3",
                                                  "m = 12", "no choice")] == [0, 1, 2, 3, None, None, None])
        check("guard", [agent.failed(0, "", True), agent.failed(0, "API Error: 529", True),
                        agent.failed(0, "You've hit your usage limit", True),
                        agent.failed(0, "I cannot tell yet.", True), agent.failed(1, "m = 0", False)]
              == [True, True, True, False, True])
        la1_agent = load("la1_agent", os.path.join(HERE, "..", "commons-llm-feedback", "agent.py"))
        check("first prompt word for word LA1's and LA1b's in every condition",
              all(agent.prompt(c, [], False) == la1_agent.prompt(c, [], False) == agent.la1b.prompt(c, [], False)
                  for c in CONDITIONS.values()))

        def only_header(a, b):
            a, b = a.splitlines(), b.splitlines()
            return len(a) == len(b) and [(x, y) for x, y in zip(a, b) if x != y] == [(agent.HEADER, agent.LA1B_HEADER)]
        check("with results, LA1b's prompt line for line but the header, which loses its clause on assigned rounds",
              "assigned" not in agent.HEADER and all(
                  only_header(agent.prompt(c, shown[:k], f), agent.la1b.prompt(c, shown[:k], f))
                  for c in CONDITIONS.values() for k in (1, 4) for f in (False, True)))
        check("a fallback round keeps LA1b's mark", "(assigned: your answer for this round gave no valid choice)"
              in agent.prompt(CONDITIONS[name], shown, False))
        print("first answers drawn by the scripted agents (LA1's and LA1b's):",
              {n: sorted(v) for n, v in scripted.PRIORS.items()})
        n_cases = analyze.check_rules()
        check(f"reading rules: on each side exactly one supported, never supported and contradicted, unresolved "
              f"with its reason, in {n_cases} cases", n_cases > 0)
        check("results/power.json made from the files as they are now", power_current())
        smoke_calls()
        if FAILED:
            raise SystemExit(f"smoke run: {len(FAILED)} check(s) failed: {FAILED}")
        return
    version = check_cli()
    agent.FROZEN = analyze.check_freeze()
    if not power_current():
        raise SystemExit("results/power.json was not made from the files as they are; rerun power.py and freeze again")
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
