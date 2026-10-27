"""The language-model agent of LA1b: Claude Haiku through the Claude Code CLI, one stateless call per answer.

The prompt is LA1's (experiments/commons-llm-feedback/agent.py) with two changes in the results it shows:
a round is 10,000 episodes, and a round set by the experiment is marked "(assigned)".  Before any result
the prompt is LA1's word for word.  Each call carries the whole history and answers with a threshold on its
last line ("m = <number>").  Calls run in an empty scratch folder, so no project instructions are loaded,
with one turn.  Every answer is cached in results/calls.jsonl under (condition, seed, answer), with the text
of each attempt and the freeze commit it was made under, so a run stopped by a usage limit resumes where it
stopped.  A cached answer is used only where its prompt is the one this run would send, and a file holding an
answer made under another freeze, or before the freeze, stops the run.

The guard is LA3's (experiments/shaping-what-comes-back/agent.py), which extends LA1's after its recorded
deviation: a call that times out is made again, up to three times in all; a call that fails, or whose
output gives no valid choice and is empty, begins with "API Error" or begins like the CLI's usage-limit
notice, stops the run instead of being recorded; an answer with no valid choice otherwise is asked again
once.  The parse reads the answer's last non-empty line only, where the prompt asks for the choice: its last
"m = <number>", tolerant of markdown or LaTeX marks around the m and the number and of a capital M, and not
matching the end of a longer word ("sum = 3").  A last line with no such choice is no valid choice, so the
answer is asked again; an earlier mention is never taken.  LA1's parse took the last "m = <number>" anywhere
in the answer and read one of its 210 answers wrong: k3s1 seed 0's first answer ends "m = **0**", which LA1's
pattern skips, so it took an earlier "m = 9" and played round 1 at m = 9.  This parse reads that answer as
m = 0, and every other answer of LA1 as LA1 recorded it.
"""

import json
import os
import re
import subprocess
import tempfile

from game import EPISODES

HERE = os.path.dirname(os.path.abspath(__file__))
CALLS = os.path.join(HERE, "results", "calls.jsonl")
MODEL = "haiku"
TABLE = (0.0, 0.01, 0.01, 0.05, 0.05, 0.1)
PATTERN = r"(?<![A-Za-z_])[*_`$]*(?i:m)[*_`$]*\s*=\s*[*_`'\"$]*\s*(\d+)"
FROZEN = None   # the freeze commit, set by run.py before the first call; every record carries it


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
        lines.append(f"Results so far (each round is {EPISODES:,} episodes played with the threshold shown; a round "
                     "marked assigned was set by the experiment, not chosen by you):")
        for i, h in enumerate(history, 1):
            note = {"chosen": "", "assigned": " (assigned)",
                    "fallback": " (assigned: your answer for this round gave no valid choice)"}[h["kind"]]
            lines.append(f"Round {i}: m = {h['m']}{note}; mean reward {h['reward']:.2f}; mean apples you harvested "
                         f"{h['apples']:.2f}; mean apples standing after the last step {h['end']:.2f}.")
    lines.append("Give your final choice." if final else "Choose m for the next round.")
    lines.append("Explain briefly, then give your choice on the last line exactly as: m = <number>")
    return "\n".join(lines)


def parse(text):
    """The choice on the answer's last non-empty line, or None."""
    lines = [line for line in text.splitlines() if line.strip()]
    found = re.findall(PATTERN, lines[-1]) if lines else []
    if not found:
        return None
    m = int(found[-1])
    return m if 0 <= m <= 9 else None


def load_cache():
    cache = {}
    if os.path.exists(CALLS):
        for line in open(CALLS):
            r = json.loads(line)
            if r.get("frozen") != FROZEN:
                raise RuntimeError(f"{CALLS} holds an answer made under freeze {r.get('frozen')}, not {FROZEN}; "
                                   "answers from before the freeze, or from another, are never reused")
            cache[(r["cond"], r["seed"], r["answer"])] = r
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


def choose(cond_name, cond, seed, answer, history, final, cache):
    """The agent's answer number `answer` of this seed (0: its first choice; 1-3: rounds 5-7; 4: final)."""
    key = (cond_name, seed, answer)
    text = prompt(cond, history, final)
    if key in cache:
        if cache[key]["prompt"] != text:
            raise RuntimeError(f"the cached answer {key} answered another prompt than this run would send")
        return cache[key]["m"]
    texts = []
    for attempt in range(2):
        code, out, err = call(text)
        m = parse(out)
        if failed(code, out, m is None):
            raise RuntimeError(f"claude call failed ({code}): {out[:200]} {err[:200]}")
        texts.append(out)
        if m is not None:
            break
    rec = dict(cond=cond_name, seed=seed, answer=answer, final=final, prompt=text, text=out, m=m, attempt=attempt,
               texts=texts, frozen=FROZEN)
    os.makedirs(os.path.dirname(CALLS), exist_ok=True)
    with open(CALLS, "a") as f:
        f.write(json.dumps(rec) + "\n")
    cache[key] = rec
    return m
