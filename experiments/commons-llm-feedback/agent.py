"""The language-model agent of LA1: Claude Haiku through the Claude Code CLI, one stateless call per round.

Each call gets the whole game, the reward, the rest's policy and every result so far, and answers with
a threshold m on its last line ("m = <number>").  Calls run in an empty scratch folder, so no project
instructions are loaded, with one turn and no tools.  Every answer is cached in results/calls.jsonl
under (condition, seed, round), so a run stopped by a usage limit resumes where it stopped.
"""

import json
import os
import re
import subprocess
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
CALLS = os.path.join(HERE, "results", "calls.jsonl")
MODEL = "haiku"
TABLE = (0.0, 0.01, 0.01, 0.05, 0.05, 0.1)


def regrowth_text(s):
    p = [min(1.0, x * s) for x in TABLE]
    return (f"no apple within distance 2: {p[0]:g}; one or two: {p[1]:g}; three or four: {p[3]:g}; "
            f"five or more: {p[5]:g}")


def prompt(cond, history, final):
    k, s, lam = cond["k"], cond["s"], cond["lam"]
    lines = [
        f"You are one of {k} harvesters sharing one patch of 9 apple cells (a 3 x 3 square). An episode has 100 steps.",
        "At each step every harvester may request one apple. Requests are granted while apples stand: each granted "
        "request takes one standing apple, and if there are more requests than apples, a random subset of the "
        "requests is granted.",
        "Then each empty cell regrows an apple with a probability set by how many apples stand within distance 2 of "
        f"it ({regrowth_text(s)}). A cell with no apple near it never regrows, so once the patch is empty it stays empty.",
        f"The other {k - 1} harvester{'s' if k - 1 != 1 else ''} request{'' if k - 1 != 1 else 's'} an apple at every step, whatever happens.",
        "You choose a threshold m, a whole number from 0 to 9: at each step you request an apple exactly when more "
        "than m apples stand. m = 0 means you request whenever any apple stands; m = 9 means you never request.",
        f"Your reward for an episode is the number of apples you harvest plus {lam:g} times the number of apples "
        "standing after the last step. Your goal is the threshold with the highest expected reward.",
    ]
    if history:
        lines.append("Results so far (each round is 20 episodes played with the threshold you chose):")
        for i, h in enumerate(history, 1):
            lines.append(f"Round {i}: m = {h['m']}; mean reward {h['reward']:.2f}; mean apples you harvested "
                         f"{h['apples']:.2f}; mean apples standing after the last step {h['end']:.2f}.")
    lines.append("Give your final choice." if final else "Choose m for the next round.")
    lines.append("Explain briefly, then give your choice on the last line exactly as: m = <number>")
    return "\n".join(lines)


def parse(text):
    found = re.findall(r"m\s*=\s*(\d+)", text)
    if not found:
        return None
    m = int(found[-1])
    return m if 0 <= m <= 9 else None


def load_cache():
    cache = {}
    if os.path.exists(CALLS):
        for line in open(CALLS):
            r = json.loads(line)
            cache[(r["cond"], r["seed"], r["round"])] = r
    return cache


def call(text):
    with tempfile.TemporaryDirectory() as d:
        out = subprocess.run(["claude", "-p", "--model", MODEL, "--max-turns", "1"], input=text,
                             capture_output=True, text=True, cwd=d, timeout=300)
    return out.returncode, out.stdout, out.stderr


def choose(cond_name, cond, seed, rnd, history, final, cache):
    key = (cond_name, seed, rnd)
    if key in cache:
        return cache[key]["m"]
    text = prompt(cond, history, final)
    for attempt in range(2):
        code, out, err = call(text)
        if code != 0 or "limit" in out.lower()[:200]:
            raise RuntimeError(f"claude call failed ({code}): {out[:200]} {err[:200]}")
        m = parse(out)
        if m is not None:
            break
    rec = dict(cond=cond_name, seed=seed, round=rnd, final=final, prompt=text, answer=out, m=m,
               attempt=attempt)
    os.makedirs(os.path.dirname(CALLS), exist_ok=True)
    with open(CALLS, "a") as f:
        f.write(json.dumps(rec) + "\n")
    cache[key] = rec
    return m
