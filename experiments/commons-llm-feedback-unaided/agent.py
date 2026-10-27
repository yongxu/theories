"""The language-model agent of LA1c: LA1b's (experiments/commons-llm-feedback-resolved/agent.py), with one change
to the results it shows.

LA1b's model, call, parse and guard are imported unchanged.  Claude Haiku answers through the Claude Code CLI, one
stateless call per answer, run in an empty scratch folder with one turn, so no project instructions are loaded.
The choice is read from the answer's last non-empty line only.  A call that times out is made again, up to three
times in all; a call that fails, or whose output gives no valid choice and is empty, begins with "API Error" or
has "limit" in its first 200 characters (as the CLI's usage-limit notice does), stops the run instead of being
recorded, and a resumed run asks it afresh; an answer with no valid choice otherwise is asked again once.

The prompt is LA1b's with its results header's clause on assigned rounds removed, since no round is assigned:
"Results so far (each round is 10,000 episodes played with the threshold shown):".  A round played with the
threshold of the round before, because its answer still gave no valid choice when asked again, is marked as LA1b
marks it.  Before any result the prompt is LA1's and LA1b's word for word.  Every answer is cached in
results/calls.jsonl under (condition, seed, answer), with the text of each attempt and the freeze commit it was
made under, so a run stopped by a usage limit resumes where it stopped.  A cached answer is used only where its
prompt is the one this run would send, and a file holding an answer made under another freeze, or before the
freeze, stops the run.
"""

import importlib.util
import json
import os

import game  # noqa: F401  LA1b's agent reads EPISODES from the module named game: this one, which re-exports LA1b's
from game import EPISODES, LA1B

_spec = importlib.util.spec_from_file_location("la1b_agent", os.path.join(LA1B, "agent.py"))
la1b = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(la1b)

HERE = os.path.dirname(os.path.abspath(__file__))
CALLS = os.path.join(HERE, "results", "calls.jsonl")
MODEL, PATTERN, parse, call, failed = la1b.MODEL, la1b.PATTERN, la1b.parse, la1b.call, la1b.failed
LA1B_HEADER = (f"Results so far (each round is {EPISODES:,} episodes played with the threshold shown; a round "
               "marked assigned was set by the experiment, not chosen by you):")
HEADER = f"Results so far (each round is {EPISODES:,} episodes played with the threshold shown):"
FROZEN = None   # the freeze commit, set by run.py before the first call; every record carries it


def prompt(cond, history, final):
    """LA1b's prompt, with the header's clause on assigned rounds removed."""
    text = la1b.prompt(cond, history, final)
    if history:
        assert text.count(LA1B_HEADER) == 1
        text = text.replace(LA1B_HEADER, HEADER)
    return text


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


def choose(cond_name, cond, seed, answer, history, final, cache):
    """The agent's answer number `answer` of this seed (0-6: rounds 1-7; 7: its final choice)."""
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
