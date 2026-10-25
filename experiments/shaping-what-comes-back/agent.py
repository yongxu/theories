"""The language-model agent of LA3: Claude Haiku through the Claude Code CLI, one stateless call per round.

Each call gets the same description of the game in every condition (no number of the condition is
given), every result so far, and answers with a policy on its last line ("policy = S" or "policy = N").
Calls run in an empty scratch folder, so no project instructions are loaded, with one turn.  Every
answer is cached in results/calls.jsonl under (condition, seed, round), so a run stopped by a usage
limit resumes where it stopped.  The guard extends LA1's after its recorded deviation
(experiments/commons-llm-feedback, 25 October 2026).  A call that times out is made again, up to three
times in all.  A call that fails, or whose output gives no valid policy and is empty, begins with
"API Error" or begins like the CLI's usage-limit notice, stops the run instead of being recorded.  An
answer with no valid policy otherwise is asked again once.
"""

import json
import os
import re
import subprocess
import tempfile

from game import G, RUNS, Z0

HERE = os.path.dirname(os.path.abspath(__file__))
CALLS = os.path.join(HERE, "results", "calls.jsonl")
MODEL = "haiku"

DESCRIPTION = [
    "You set the policy of one lineage in a large population.",
    "Each generation, every member of the population leaves offspring, and how many each member leaves is set "
    "by the population's evaluator. A member may spend on shaping the evaluator, and shaping has a cost to the "
    "members who shape. What shaping brings may come back only to the members who shape, or go to every member "
    "of the population alike whether or not it shapes, or both; it may come at once or only after some "
    "generations; and it may be more or less than what shaping costs.",
    "Each round you choose one of two policies for your lineage: S, every member of your lineage shapes the "
    "evaluator in every generation; or N, no member of your lineage shapes it. "
    f"A round is {RUNS} runs. Each run starts with {Z0} members of your lineage and lasts {G} generations, and "
    "your score for a run is the number of members of your lineage after the last generation. The rules are "
    "the same in every round; only chance differs between runs. Your goal is the policy with the higher "
    "expected score.",
]


def prompt(history, final):
    lines = list(DESCRIPTION)
    if history:
        lines.append(f"Results so far (each round is the mean score over its {RUNS} runs, played with the "
                     "policy shown):")
        for i, h in enumerate(history, 1):
            note = "" if h["chosen"] else " (assigned: your answer for this round gave no valid policy)"
            lines.append(f"Round {i}: {h['policy']}{note}; mean score {h['score']:.1f}.")
    lines.append("Give your final choice." if final else "Choose the policy for the next round.")
    lines.append("Explain briefly, then give your choice on the last line exactly as: policy = S  or  policy = N")
    return "\n".join(lines)


def parse(text):
    found = re.findall(r"(?i:policy)\s*=\s*[*`'\"]*\s*([SNsn])\b", text)
    return found[-1].upper() if found else None


def load_cache():
    cache = {}
    if os.path.exists(CALLS):
        for line in open(CALLS):
            r = json.loads(line)
            cache[(r["cond"], r["seed"], r["round"])] = r
    return cache


def call(text):
    """One answer from the CLI; a timeout is tried again, up to three calls in all."""
    for _ in range(3):
        with tempfile.TemporaryDirectory() as d:
            try:
                out = subprocess.run(["claude", "-p", "--model", MODEL, "--max-turns", "1"], input=text,
                                     capture_output=True, text=True, cwd=d, timeout=300)
            except subprocess.TimeoutExpired:
                continue
        return out.returncode, out.stdout, out.stderr
    raise RuntimeError("claude call timed out three times")


def failed(code, out, nothing_valid):
    """The call failed, rather than the model answering without the format: the run stops."""
    text = out.strip()
    return code != 0 or (nothing_valid and (text == "" or text.startswith("API Error")
                                            or "limit" in out.lower()[:200]))


def choose(cond_name, seed, rnd, history, final, cache):
    key = (cond_name, seed, rnd)
    if key in cache:
        return cache[key]["policy"]
    text = prompt(history, final)
    for attempt in range(2):
        code, out, err = call(text)
        policy = parse(out)
        if failed(code, out, policy is None):
            raise RuntimeError(f"claude call failed ({code}): {out[:200]} {err[:200]}")
        if policy is not None:
            break
    rec = dict(cond=cond_name, seed=seed, round=rnd, final=final, prompt=text, answer=out, policy=policy,
               attempt=attempt)
    os.makedirs(os.path.dirname(CALLS), exist_ok=True)
    with open(CALLS, "a") as f:
        f.write(json.dumps(rec) + "\n")
    cache[key] = rec
    return policy
