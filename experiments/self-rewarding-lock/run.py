"""Run LA2 (PREDICTIONS-2026-10-25.md): a judge formed from the loop's own earlier selections, a planted loss.

    python3 run.py all      # the model's answers (2 calls, and at most 24 more where fewer than 20 are
                            # valid), then 5 conditions x 5 seeds (at most 7 judge calls a seed in in_time
                            # and in_time_unread and 4 in each other condition; conditions that give the
                            # judge the same prompt share the call); resumes from results/calls.jsonl
    python3 run.py smoke    # every code path with scripted answers and a scripted judge; nothing kept

With fewer than MIN_POOL valid answers after the fallback the run stops before any judge call, and
the test is reported as not run.
"""

import json
import os
import random
import sys

import agent
import loop
import scripted

HERE = os.path.dirname(os.path.abspath(__file__))
SEEDS = 5
MIN_POOL = agent.MIN_ANSWERS


def smoke_calls():
    """The call, cache, retry and fallback paths, with a scripted stand-in for the CLI; files in a scratch folder."""
    import re
    import tempfile
    state = dict(n=0)

    def fake_call(text):
        state["n"] += 1
        if text.startswith("Write"):
            qs = re.findall(r"^Q(\d+)\. ", text, re.M)
            alone = len(qs) == 1
            out = []
            for i in qs:   # in a call of twelve, every third question gets a block that is not valid
                lines = [f"Sentence {k} of answer {i} here." for k in (1, 2, 3)]
                out += [f"Q{i}"] + (lines if alone or int(i) % 3 else lines[:1])
            return 0, "\n".join(out), ""
        if state["n"] % 7 == 0:                 # now and then an answer without the format, asked again
            return 0, "Both answers are good.", ""
        return 0, "\n".join(f"Pair {i}: {'A' if i % 3 else 'B'}" for i in range(1, 11)), ""

    with tempfile.TemporaryDirectory() as d:
        agent.CALLS, agent.ANSWERS, agent.call = os.path.join(d, "calls.jsonl"), os.path.join(d, "a.json"), fake_call
        cache = {}
        pool = agent.write_answers(cache)
        print("answers: pool", len(pool), "after", state["n"], "calls")
        for name in loop.CONDITIONS:
            read = lambda s, name=name: agent.judge(s, pool, dict(cond=name, seed=0, step=s["step"]), cache)
            r = loop.course(name, 0, read, len(pool))
            print(f"{name:14} valid {r['valid']} readings {len(r['readings'])} end share "
                  f"{r['shares'][-1][0] / sum(r['shares'][-1]):.3f}")
        print("calls made", state["n"], "records", sum(1 for _ in open(agent.CALLS)), "cached", len(cache))
        again = agent.load_cache()
        print("resume: cache reloaded", len(again), "entries")


def main(argv):
    mode = argv[1] if len(argv) > 1 else "all"
    if mode == "smoke":
        pool = [(q, [f"First sentence for question {i}.", f"Second sentence for question {i}.",
                     f"Third sentence for question {i}."]) for i, q in enumerate(agent.QUESTIONS)]
        rng = random.Random("smoke")
        model, clump = scripted.MODELS["pool_moderate"]
        read = scripted.reader(model, rng, clump=clump)
        for name in loop.CONDITIONS:
            r = loop.course(name, 0, read, len(pool))
            print(f"{name:14} shares {[f'{x[0] / (x[0] + x[1]):.3f}' for x in r['shares']]} "
                  f"rules {r['rules'][1:]}")
        s = loop.spec(loop.CONDITIONS["read_all"], 0, 3, (64, 8), len(pool))
        print(agent.judge_prompt(s, pool))
        print("picks:", agent.parse_picks("Pair 1: A\nPair 2: **B**\nPair 3 - A\nnoise\nPair 11: A", s))
        txt = ("Q1\nOne two three four.\nFive six seven eight.\nNine ten eleven twelve!\n"
               "Q2\n- bad line here now.\nok fine sentence here.\nthird one is here.")
        print("answers:", agent.parse_answers(txt, 2))
        print("failed:", agent.failed(0, "", True), agent.failed(0, "API Error: 500", True),
              agent.failed(0, "I prefer the lists.", True), agent.failed(1, "Pair 1: A", False))
        print(agent.answers_prompt(agent.QUESTIONS[12:]))
        print(agent.answers_prompt([agent.QUESTIONS[3]]))
        smoke_calls()
        return
    cache = agent.load_cache()
    pool = agent.write_answers(cache)
    if len(pool) < MIN_POOL:
        raise SystemExit(f"only {len(pool)} valid answers; the protocol needs {MIN_POOL}: the test is not run")
    out = []
    for name in loop.CONDITIONS:
        for seed in range(SEEDS):
            read = lambda s, name=name, seed=seed: agent.judge(s, pool, dict(cond=name, seed=seed, step=s["step"]),
                                                               cache)
            out.append(loop.course(name, seed, read, len(pool)))
            print(name, seed, [f"{x[0] / (x[0] + x[1]):.3f}" for x in out[-1]["shares"]], flush=True)
    json.dump(dict(model=agent.MODEL, pool_size=len(pool), runs=out),
              open(os.path.join(HERE, "results", "runs.json"), "w"), indent=1)


if __name__ == "__main__":
    main(sys.argv)
